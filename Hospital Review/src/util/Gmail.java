//Gmail SMTP 이용하기 위해 계정 정보 넣는 부분
package util;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

//인증수행 도와주는 Authenticator 클래스 상속
public class Gmail extends Authenticator {
		@Override
		protected PasswordAuthentication getPasswordAuthentication() {
			//사용자한테 메일을 전송할(즉, 관리자(나))의 gmail 아이디와 비밀번호 입력
			return new PasswordAuthentication("johaein1@gmail.com","jhi852147");
		}
}
/* 정보 입력 후, 구글(Gmail) 계정으로 들어가서 내 계정(로그인 및 보안) 으로 들어감
   계정 엑세스 권한을 가진 앱> 보안 수준이 낮은 앱 허용을 사용으로 바꿔 줘야 함
   (이클립스와 같이 로컬환경에서 인위적으로 구성한 접속환경 에서도 사용하기 위해) */