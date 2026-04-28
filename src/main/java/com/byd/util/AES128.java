package com.byd.util;

import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.util.Base64;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

public class AES128 {
	
	public Key getAESKey(String apiKey) throws Exception {
	    Key keySpec;

	    String key = apiKey;
	    byte[] keyBytes = new byte[16];
	    byte[] b = key.getBytes(StandardCharsets.UTF_8);

	    int len = b.length;
	    if (len > keyBytes.length) {
	       len = keyBytes.length;
	    }

	    System.arraycopy(b, 0, keyBytes, 0, len);
	    keySpec = new SecretKeySpec(keyBytes, "AES");

	    return keySpec;
	}

	// AES encryption
	public String encAES(String str, String apiKey, String ivKey) throws Exception {
	    Key keySpec = getAESKey(apiKey);
	    String iv = ivKey;
	    Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
	    c.init(Cipher.ENCRYPT_MODE, keySpec, new IvParameterSpec(iv.getBytes(StandardCharsets.UTF_8)));
	    byte[] encrypted = c.doFinal(str.getBytes(StandardCharsets.UTF_8));
	    String enStr = Base64.getEncoder().encodeToString(encrypted);

	    return enStr;
	}

}

