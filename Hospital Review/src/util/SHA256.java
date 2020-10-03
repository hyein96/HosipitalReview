package util;

import java.security.MessageDigest;

public class SHA256 {


	//이메일에 해쉬 적용한 값(해쉬값) 구하는 함수
	public static String getSHA256(String input){
		StringBuffer result = new StringBuffer();
		try {
		    //실제로 사용자가 입력한 값을 SHA-256으로 알고리즘 적용할 수 있도록 만듬
			MessageDigest digest = MessageDigest.getInstance("SHA-256");
			//단순히 SHA-256을 적용하면 해킹을 당할 위험이 있으므로 일반적으로, salt값 적용(안전하게)
			//salt값은 자신이 원하는 값으로 넣어도 됨
			byte[] salt = "Hello! This is Salt.".getBytes();
			digest.reset();
			digest.update(salt); // salt값 적용
			//input(UTF-8)의 해쉬를 적용한 값을 char 배열에 넣어줌 
			byte[]chars = digest.digest(input.getBytes("UTF-8"));
			//char 배열을 문자열 형태로 만들기
			for(int i= 0; i<chars.length; i++) {
				//헥스값(0xff)과 해쉬 적용한 chars의 해당인덱스를 AND(&)연산
				String hex = Integer.toHexString(0xff & chars[i]); 
				//1자리수면 0을 붙혀서 총 2자리 값을 가지는 16진수 형태로 만듬
				if(hex.length() == 1) result.append("0");
				result.append(hex);
			}
		} catch(Exception e) {
			e.printStackTrace(); 
		}
		return result.toString(); //해쉬값 반환 
	}
}
