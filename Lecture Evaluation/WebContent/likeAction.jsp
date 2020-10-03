<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<%@ page import="evaluation.EvaluationDAO"%>
<%@ page import="likey.LikeyDAO"%>
<%@ page import="java.io.PrintWriter"%>

<%!//선언문(<%! 로시작)을 이용해서 함수 정의

	//해당 사이트에 접속한 사용자의 IP 받아오는 함수
	public static String getClientIP(HttpServletRequest request) {
		String ip = request.getHeader("X-FORMARDED-FOR");
		//proxy 서버를 사용한 고객이라도 ip 얻어옴
		if (ip == null || ip.length() == 0) {
			ip = request.getHeader("Proxy-Client-IP");
		}
		//처리를 한후에도, ip값 없으면
		if (ip == null || ip.length() == 0) {
			ip = request.getHeader("WL-Proxy-Client-IP");
		}
		//처리를 한후에도, ip값 없으면 request에 적혀있는 기본적인 ip주소 가져옴
		if (ip == null || ip.length() == 0) {
			ip = request.getRemoteAddr();
		}
		return ip;
	}
%>
<%
	UserDAO userDAO = new UserDAO();
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	if (userID == null) { //사용자가 로그인하지 않은 상태면
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

	//추천버튼 누를 evaluationID(강의평가 글)
	if (request.getParameter("evaluationID") != null) {
		evaluationID = request.getParameter("evaluationID");
	}
	EvaluationDAO evaluationDAO = new EvaluationDAO();
	LikeyDAO likeyDAO = new LikeyDAO();
	int result = likeyDAO.like(userID, evaluationID, getClientIP(request));
	if (result == 1) { //추천 하기 성공
		result = evaluationDAO.like(evaluationID); //해당 평가글의 추천수(likeCount) 증가
		if (result == 1) { //추천 수가 증가했다면(성공적으로 추천된 것)
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('추천이 완료되었습니다.');");
			script.println("location.href = 'index.jsp'");
			script.println("</script>");
			script.close();
			return;
		} else {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생했습니다.');");
			script.println("history.back();");
			script.println("</script>");
			script.close();
			return;
		}
	} else { // 특정사용자가 특정 강의평가글의 추천을 이미 한번 누른 상태(PRIMARY KEY이므로 에러!)
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 추천을 누른 글입니다..');");
		script.println("history.back();"); //이전페이지로 이동
		script.println("</script>");
		script.close();
		return;
	}
%>