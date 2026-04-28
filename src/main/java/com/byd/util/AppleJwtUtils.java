package com.byd.util;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.security.KeyFactory;
import java.security.PublicKey;
import java.security.spec.RSAPublicKeySpec;
import java.util.Base64;

@Slf4j
@Component
public class AppleJwtUtils {

    private static final String APPLE_AUTH_KEYS_URL = "https://appleid.apple.com/auth/keys";
    private static final String APPLE_ISSUER = "https://appleid.apple.com";
    private static final String CLIENT_ID = "com.byd.web"; // Apple Developer 센터에 등록한 Services ID

    /**
     * Apple id_token의 서명을 검증하고 Claims(페이로드)를 안전하게 파싱하여 반환합니다.
     */
    public Claims getClaimsBy(String idToken) throws Exception {
        try {
            // 1. 토큰 헤더 디코딩을 통해 kid, alg 추출
            String[] jwtParts = idToken.split("\\.");
            String headerJson = new String(Base64.getUrlDecoder().decode(jwtParts[0]), StandardCharsets.UTF_8);

            ObjectMapper mapper = new ObjectMapper();
            JsonNode headerNode = mapper.readTree(headerJson);
            String kid = headerNode.get("kid").asText();
            String alg = headerNode.get("alg").asText();

            // 2. Apple 공개키 조회
            RestTemplate restTemplate = new RestTemplate();
            String keysJson = restTemplate.getForObject(APPLE_AUTH_KEYS_URL, String.class);
            JsonNode keysNode = mapper.readTree(keysJson).get("keys");

            // 3. kid와 alg가 일치하는 Key 찾기
            JsonNode matchedKey = null;
            for (JsonNode key : keysNode) {
                if (kid.equals(key.get("kid").asText()) && alg.equals(key.get("alg").asText())) {
                    matchedKey = key;
                    break;
                }
            }

            if (matchedKey == null) {
                throw new Exception("일치하는 Apple Public Key를 찾을 수 없습니다.");
            }

            // 4. RSA 공개키(PublicKey) 객체 생성 (n, e 값 이용)
            byte[] nBytes = Base64.getUrlDecoder().decode(matchedKey.get("n").asText());
            byte[] eBytes = Base64.getUrlDecoder().decode(matchedKey.get("e").asText());

            BigInteger n = new BigInteger(1, nBytes);
            BigInteger e = new BigInteger(1, eBytes);

            RSAPublicKeySpec publicKeySpec = new RSAPublicKeySpec(n, e);
            KeyFactory keyFactory = KeyFactory.getInstance(matchedKey.get("kty").asText());
            PublicKey publicKey = keyFactory.generatePublic(publicKeySpec);

            // 5. 검증 수행 (서명 확인, 발급자 확인, 대상자(클라이언트 ID) 확인, 만료일 자동 확인)
            return Jwts.parserBuilder()
                    .setSigningKey(publicKey)
                    .requireIssuer(APPLE_ISSUER)
                    .requireAudience(CLIENT_ID)
                    .build()
                    .parseClaimsJws(idToken)
                    .getBody();

        } catch (Exception e) {
            log.error("Apple id_token 검증 중 보안 오류 발생: {}", e.getMessage());
            throw new Exception("유효하지 않은 Apple 토큰입니다.");
        }
    }
}