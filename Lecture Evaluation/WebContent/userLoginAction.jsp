
<!-- 로그인 요청을 처리해주는 페이지 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="user.UserDTO" %> 
<%@ page import ="user.UserDAO" %>
<%@ page import ="util.SHA256" %>
<%@ page import = "java.io.PrintWriter" %> <!-- 자바스크립트 구문 출력하기 위해 사용하는 것 중 하나  --> 




<%
	//사용자로부터 입력받은 정보는 UTF-8으로 처리  
	request.setCharacterEncoding("UTF-8");

	//사용자로부터 아이디와 비밀번호 받기 
	String userID = null;
	String userPassword = null;
	if(request.getParameter("userID") != null){
		userID = request.getParameter("userID");
	}
	if(request.getParameter("userPassword") != null){
		userPassword = request.getParameter("userPassword");
	}
	if(userID == null || userPassword == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안 된 사항이 있습니다.');");
		script.println("history.back();"); // 다시 뒤 쪽으로 back
		script.println("</script>");
		script.close();
		return;
	}
	
	//입력을 제대로 받았다면 ? 로그인진행  
	UserDAO userDAO = new UserDAO();
	int result = userDAO.login(userID,userPassword);
	if(result == 1) { // 정상적으로 로그인 성공 --> session값 설정해서 로그인상태로 만들기
		session.setAttribute("userID",userID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'index.jsp'");
		script.println("</script>");
		script.close();
		return;
	} else if(result == 0) { // 비밀번호 틀림
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('비밀번호가 틀립니다');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		
		return;
	} else if(result == -1) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('존재하지 않는 아이디입니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else if(result == -2) { 
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('데이터베이스 오류가 발생했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
%>