
<!-- 삭제 버튼 클릭하면 해당 글 삭제되는 페이지 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<%@ page import="evaluation.EvaluationDAO"%>
<%@ page import="likey.LikeyDTO"%>
<%@ page import="java.io.PrintWriter"%>
<%
	UserDAO userDAO = new UserDAO();
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	if (userID == null) { //사용자가 로그인하지 않은 상태면(특정 게시글 삭제 불가)
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href = 'userLogin.jsp';");
		script.println("</script>");
		script.close();
		return;
	}

	request.setCharacterEncoding("UTF-8");
	String evaluationID = null;

	//삭제할 글의 evaluationID 받기
	if (request.getParameter("evaluationID") != null) {
		evaluationID = request.getParameter("evaluationID");
	}
	EvaluationDAO evaluationDAO = new EvaluationDAO();
	//삭제버튼을 누른 사람이(userID) 해당 평가글을 작성한 사용자 일때만 글 삭제 함수 실행!!!
	if(userID.equals(evaluationDAO.getUserID(evaluationID))) {
		int result = new EvaluationDAO().delete(evaluationID);
		if(result == 1){ //삭제 성공
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('삭제가 완료 되었습니다.');");
			script.println("location.href = 'index.jsp'");
			script.println("</script>");
			script.close();
			return;
		} else { //삭제 실패
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생했습니다.');");
			script.println("history.back();"); //이전페이지로 이동
			script.println("</script>");
			script.close();
			return;
		}
	} else { //삭제버튼 누른사람이 평가글을 작성한 사람이 아닌 경우
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('자신이 쓴 글만 삭제 가능합니다.');");
		script.println("history.back();"); 
		script.println("</script>");
		script.close();
		return;	
	}
%>