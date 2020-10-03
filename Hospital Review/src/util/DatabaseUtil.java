//실질적으로 DB와 연동하는 부분(getConnection함수) 정의(userDAO에서 사용 )
package util;

import java.sql.Connection;
import java.sql.DriverManager;


public class DatabaseUtil {

	//getConnection함수 (Connection 객체를 이용해서 DB와 연동된 상태(즉,연결)를 관리)  
	//다른 라이브러리에서 함수 사용할 수 있도록 static 넣기
	public static Connection getConnection() {
		try {
			//mysql에 접속하기 위한 명령어(DB이름:TUTORIAL)
			//timezone에러 방지 위해 ?~ 코드작성
			String dbURL = "jdbc:mysql://localhost:3306/LectureEvaluation?serverTimezone=UTC"; 
			String dbID ="root";
			String dbPassword = "Jhi8524561";
			//jdbc driver(mysql과 jsp 연동위해 필요)찾아서 사용(WEB-INF의 lib 폴더 안)
			//connector버전에 따라 코드 작성다름
			Class.forName("com.mysql.cj.jdbc.Driver");
			return DriverManager.getConnection(dbURL,dbID,dbPassword);
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return null ; //오류가 발생하면 null반환
	}
}
