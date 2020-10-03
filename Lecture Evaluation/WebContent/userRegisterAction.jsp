
<!-- 회원가입 기능작동(처리) 페이지 : 회원가입을 하면 디비에 정보를 넣어줌 -->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="user.UserDTO" %> 
<%@ page import ="user.UserDAO" %>
<%@ page import ="util.SHA256" %>
<%@ page import = "java.io.PrintWriter" %> <!-- 자바스크립트 구문 출력하기 위해 사용하는 것 중 하나  --> 

<%
	//사용자로부터 입력받은 정보는 UTF-8으로 처리  
	request.setCharacterEncoding("UTF-8"); 

	//사용자가 로그인 상태면 userReigisterAction.jsp 페이지 접속 불가 
	String userID = null;
	if(session.getAttribute("userID") != null){ // 로그인 상태면(session값 으로 확인)
		userID = (String)session.getAttribute("userID");
	}
	if(userID != null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인이 된 상태입니다.');");
		script.println("location.href = 'index.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
	
	String userPassword = null;
	String userEmail = null;
	if(request.getParameter("userID") != null){
		userID = request.getParameter("userID");
	}
	if(request.getParameter("userPassword") != null){
		userPassword = request.getParameter("userPassword");
	}
	if(request.getParameter("userEmail") != null){
		userEmail = request.getParameter("userEmail");
	}
	if(userID == null || userPassword == null || userEmail == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안 된 사항이 있습니다.');");
		script.println("history.back();"); // 다시 뒤 쪽으로 back
		script.println("</script>");
		script.close();
		return;
	}
	
	//입력을 제대로 받았다면 ? 회원가입 진행 
	UserDAO userDAO = new UserDAO();
	// 새로운 객체 생성 후 , 한 명의 사용자 객체 넣어줌
	// 네번째 인자값은 hash값 적용한 이메일이므로  SHA256이용
	int result = userDAO.join(new UserDTO(userID,userPassword,userEmail,SHA256.getSHA256(userEmail),false));
	if(result == -1) { // 회원가입이 안됬을 때
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 존재하는 아이디입니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else {
		//로그인 상태로 바로 만들어 주기위해 session값으로 넣어줌 
		session.setAttribute("userID",userID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		//회원가입하자마자 이메일 인증 받을수 있게 emailSendAction.jsp로 보냄
		script.println("location.href = 'emailSendAction.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
%>