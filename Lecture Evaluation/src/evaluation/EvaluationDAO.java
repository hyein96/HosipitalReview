package evaluation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import util.DatabaseUtil;

public class EvaluationDAO {

	//글쓰기 함수(강의평가 정보 등록)
	public int write(EvaluationDTO evaluationDTO) {
		String SQL = "INSERT INTO EVALUATION VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0)";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1,evaluationDTO.getUserID().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n","<br>"));
			pstmt.setString(2,evaluationDTO.getLectureName().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n","<br>"));
			pstmt.setString(3,evaluationDTO.getProfessorName().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n","<br>"));
			pstmt.setInt(4,evaluationDTO.getLectureYear()); //숫자 이므로 replaceAll 할 필요 없음 (문자열 부분만!)
			pstmt.setString(5,evaluationDTO.getSemesterDivide().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n","<br>"));
			pstmt.setString(6,evaluationDTO.getLectureDivide().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n","<br>"));
			pstmt.setString(7,evaluationDTO.getEvaluationTitle().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n","<br>"));
			pstmt.setString(8,evaluationDTO.getEvaluationContent().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n","<br>"));
			pstmt.setString(9,evaluationDTO.getTotalScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n","<br>"));
			pstmt.setString(10,evaluationDTO.getCreditScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n","<br>"));
			pstmt.setString(11,evaluationDTO.getComfortableScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n","<br>"));
			pstmt.setString(12,evaluationDTO.getLectureScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n","<br>"));
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
			
		} finally {
			try {if(conn!=null) conn.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt!=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(rs!=null) rs.close();} catch(Exception e) {e.printStackTrace();}
		}
		return -1; //데이터베이스 오류
	}
	
	//강의평가 검색기능(사용자가 검색한 내용에 대한 결과(강의평가 글)를 리스트로 반환하는 함수) 
	public ArrayList<EvaluationDTO> getList(String lectureDivide, String searchType, String search, int pageNumber) {
		if (lectureDivide.equals("전체")) {
			lectureDivide = "";
		}
		ArrayList<EvaluationDTO> evaluationList = null; //강의평가 글 담기는 리스트
		String SQL = "";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		//최신순과 추천순 차이: SQL문의 ORDER BY(정렬기준:evaluationID로 정렬할지, likeCount로 정렬할지) 
		try {
			if (searchType.equals("최신순")) {
				// LIKE 특정 문자열을 포함하는지 물어볼때 사용하는 mysql 문법
				// 한 페이지에 5개씩 강의평가 글 출력 (6개를 가져오도록 코드 작성한건  다음 페이지로 넘어가도록  만들어 주기 위해!:index.jsp 참고)[5개까지 출력하는데 6개가 존재한다는건 다음페이지가 존재한다는 뜻]
				SQL = "SELECT * FROM EVALUATION WHERE lectureDivide LIKE ? AND CONCAT(lectureName, professorName, evaluationTitle, evaluationContent) LIKE"
						+ "? ORDER BY evaluationID DESC LIMIT " + pageNumber * 5 + ", " + pageNumber * 5 + 6;
			} else if (searchType.equals("추천순")) {
				SQL = "SELECT * FROM EVALUATION WHERE lectureDivide LIKE ? AND CONCAT(lectureName, professorName, evaluationTitle, evaluationContent) LIKE"
						+ "? ORDER BY likeCount DESC LIMIT " + pageNumber * 5 + ", " + pageNumber * 5 + 6;
			}
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			
			//LIKE 다음에 % 뒤에 문자열이 오면 해당 문자열을 포함하는지 물어보는 것
			
			//lectureDivide가 전체,전공,교양,기타가 있었으므로 전체일 때는 ""로 항상 포함하게 만드는 것이고, 나머지는 해당 글자와 동일한 결과만 출력하도록 만듬
			pstmt.setString(1, "%" + lectureDivide + "%");
			//강의명,교수명,평가제목,평가내용을 포함한 문자열에 사용자가 검색한내용(search)이 포함되어 있는지 확인 
			pstmt.setString(2, "%" + search + "%");
			rs = pstmt.executeQuery();
			evaluationList = new ArrayList<EvaluationDTO>();
			//게시물이 존재할 때 마다 list에 담기
			while (rs.next()) { //결과가 여러개일 땐 while문 으로 작성
				EvaluationDTO evaluation  = new EvaluationDTO(
						rs.getInt(1),
						rs.getString(2), 
						rs.getString(3),
						rs.getString(4), 
						rs.getInt(5), 
						rs.getString(6), 
						rs.getString(7), 
						rs.getString(8),
						rs.getString(9), 
						rs.getString(10), 
						rs.getString(11), 
						rs.getString(12), 
						rs.getString(13),
						rs.getInt(14)
				);
				evaluationList.add(evaluation);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {if(conn!=null) conn.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt!=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(rs!=null) rs.close();} catch(Exception e) {e.printStackTrace();}
		}
		return evaluationList;
	}
	
	//특정 강의평가글에 likeCount 1씩 증가시키는 함수
	public int like(String evaluationID) {
		String SQL = "UPDATE EVALUATION SET likeCount = likeCount + 1 WHERE evaluationID =? ";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			//evaluationID는 숫자(AUTO_INCREMENT) 이므로 setInt로 보내기
			pstmt.setInt(1,Integer.parseInt(evaluationID));
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {if(conn!=null) conn.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt!=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(rs!=null) rs.close();} catch(Exception e) {e.printStackTrace();}
		}
		return -1; //데이터 베이스 오류 	
	}
	
	//특정 강의평가 글 삭제하는 함수
	public int delete(String evaluationID) {
		String SQL = "DELETE FROM EVALUATION WHERE evaluationID =? ";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,Integer.parseInt(evaluationID));
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {if(conn!=null) conn.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt!=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(rs!=null) rs.close();} catch(Exception e) {e.printStackTrace();}
		}
		return -1; //데이터 베이스 오류 	
	}
	
	//특정한 강의평가글을 작성한 사람의 userID를 가져오는 함수
	public String getUserID(String evaluationID) {
		String SQL = "SELECT userID FROM EVALUATION WHERE evaluationID =?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,Integer.parseInt(evaluationID));
			rs = pstmt.executeQuery();
			if(rs.next()) { //결과 존재(결과가 1개일 땐 if문으로)
				return rs.getString(1); //userID 값 반환
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			//접근한 자원 해제
			try {if(conn!=null) conn.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt!=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(rs!=null) rs.close();} catch(Exception e) {e.printStackTrace();}
		}
		return null; //userID 값 존재하지 않음
	}	
}
	
	
	
	
	
	
	
	

