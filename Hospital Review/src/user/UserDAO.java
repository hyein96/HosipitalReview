//DB접근에 성공한 Connection 객체(DatabaseUtil) 이용해서 
//실질적으로 DB에 접근하는 UserDAO(SQL문 이용)
package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DatabaseUtil;

public class UserDAO {
	
	//사용자 로그인 함수 
	public int login(String userID,String userPassword) {
		String SQL = "SELECT userPassword FROM USER WHERE userID = ?";
		Connection conn = null;
		//SQl문 처리위해 필요한 PreparedStatement
		PreparedStatement pstmt = null;
		//특정한 SQL문 실행 후, 결과값에 대해 처리해주는 클래스 ResultSet
		ResultSet rs = null;
		try {
			//DB에 연결된 Connection객체 conn 에 담김
			conn = DatabaseUtil.getConnection();
			//SQL문을 실행 할 수있는 형태로 준비시킴
			pstmt = conn.prepareStatement(SQL);
			//SQL문의 ? 채우기(사용자로부터 입력받은 값으로)
			pstmt.setString(1,userID);
			//SQL문을 DB에서 실행시켜서 결과 rs에 담기
			rs = pstmt.executeQuery();
			if(rs.next()) { //결과 존재하면
				if(rs.getString(1).equals(userPassword)) {
					return 1; //로그인 성공
				}
				else {
					return 0; //비밀번호 틀림(ID는 존재)
				}
			}
			return -1; //아이디 없음
		}catch(Exception e) {
			e.printStackTrace();
			
		} finally {
			//위의 3가지는 한번 사용되면(즉, DB에 접근), 접근한 자원 해제해주는 것이 중요
			try {if(conn!=null) conn.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt!=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(rs!=null) rs.close();} catch(Exception e) {e.printStackTrace();}
		}
		return -2; //데이터베이스 오류
	}
	
	//회원가입 함수
	public int join(UserDTO user) {
		//이메일 인증은 처음에 안된 상태이므로 false값 넣기
		String SQL = "INSERT INTO USER VALUES(?, ?, ?, ?, false)";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1,user.getUserID());
			pstmt.setString(2,user.getUserPassword());
			pstmt.setString(3,user.getUserEmail());
			pstmt.setString(4,user.getUserEmailHash());
			
			//pstmt의 SQL문 실행 2가지: executeQuery와 executeUpdate 
			//executeQuery: DB에서 데이터를 조회할 때 사용(SELECT) (Resultset을 이용해서 결과 확인)
			//executeUpdate: INSERT,UPDATE,DELETE (실제로 영향을 받은 데이터 갯수 반환)
			
			//회원가입 성공하면 1명이 추가 된 것이므로 1을 반환
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			//접근한 자원 해제 
			try {if(conn!=null) conn.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt!=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(rs!=null) rs.close();} catch(Exception e) {e.printStackTrace();}
		}
		return -1; //데이터베이스 오류 또는 회원가입 실패(예: 아이디 겹칠때(PK))
	}
	
	//특정회원(userID)의 이메일 반환 함수
	public String getUserEmail(String userID) {
			String SQL = "SELECT userEmail FROM USER WHERE userID =?";
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1,userID);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					//1번째 속성(즉,userEmail)의 값 반환
					return rs.getString(1);
				}
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
				try {if(conn!=null) conn.close();} catch(Exception e) {e.printStackTrace();}
				try {if(pstmt!=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
				try {if(rs!=null) rs.close();} catch(Exception e) {e.printStackTrace();}
			}
			return null; ///데이터 베이스 오류
		}
	
	
	//이메일 검증 함수(userID 통해 확인)
	public boolean getUserEmailChecked(String userID) {
		String SQL = "SELECT userEmailChecked FROM USER WHERE userID =?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1,userID);
			rs = pstmt.executeQuery();
			if(rs.next()) { //결과 존재(즉, userID 존재): 결과가 1개이면 if, 여러개이면 while로 작성
				//select 한 1번째 속성의 값(boolean) 반환 (userEmailcheced만 select 했으므로 당연히 1로 작성)
				//해당 사용자가 이메일 인증이 되었다면 true 아니면 false 반환
				return rs.getBoolean(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			//접근한 자원 해제
			try {if(conn!=null) conn.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt!=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(rs!=null) rs.close();} catch(Exception e) {e.printStackTrace();}
		}
		return false; //데이터 베이스 오류
	}

	//검증 통해 이메일 인증 처리 함수(인증 완료 되도록)
	public boolean setUserEmailChecked(String userID) {
		String SQL = "UPDATE USER SET userEmailChecked = true WHERE userID =? ";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1,userID);
			pstmt.executeUpdate();
			return true;
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			//접근한 자원 해제
			try {if(conn!=null) conn.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt!=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(rs!=null) rs.close();} catch(Exception e) {e.printStackTrace();}
		}
		return false; //데이터 베이스 오류 
	}
}