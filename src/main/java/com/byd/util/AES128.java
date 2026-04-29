package com.byd.util;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

public class AES128 {

	private final String alg = "AES/CBC/PKCS5Padding";
	private final String key;
	private final String iv; // 초기화 벡터 (16바이트)

	public AES128(String key) {
		// 키 길이가 16자리가 아니면 16자리로 맞춤 (부족하면 패딩, 남으면 자름)
		if (key.length() < 16) {
			this.key = String.format("%-16s", key).replace(' ', '0');
		} else {
			this.key = key.substring(0, 16);
		}
		this.iv = this.key.substring(0, 16);
	}

	// 암호화
	public String encrypt(String text) throws Exception {
		Cipher cipher = Cipher.getInstance(alg);
		SecretKeySpec keySpec = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "AES");
		IvParameterSpec ivParamSpec = new IvParameterSpec(iv.getBytes(StandardCharsets.UTF_8));
		cipher.init(Cipher.ENCRYPT_MODE, keySpec, ivParamSpec);

		byte[] encrypted = cipher.doFinal(text.getBytes(StandardCharsets.UTF_8));
		return Base64.getUrlEncoder().encodeToString(encrypted); // URL Safe Base64
	}

	// 복호화
	public String decrypt(String cipherText) throws Exception {
		Cipher cipher = Cipher.getInstance(alg);
		SecretKeySpec keySpec = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "AES");
		IvParameterSpec ivParamSpec = new IvParameterSpec(iv.getBytes(StandardCharsets.UTF_8));
		cipher.init(Cipher.DECRYPT_MODE, keySpec, ivParamSpec);

		byte[] decodedBytes = Base64.getUrlDecoder().decode(cipherText);
		byte[] decrypted = cipher.doFinal(decodedBytes);
		return new String(decrypted, StandardCharsets.UTF_8);
	}
}