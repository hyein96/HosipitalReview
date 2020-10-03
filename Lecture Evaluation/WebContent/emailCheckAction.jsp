<!-- emailSendAction.jsp에서 content에 사용자가 보낸 code를 이용해서 이메일 인증 수행 해주는 페이지 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.io.PrintWriter"%>
<%

	//사용자로부터 입력받은 정보는 UTF-8으로 처리  
	request.setCharacterEncoding("UTF-8");

	String code = null;
	if (request.getParameter("code") != null) {
		code = request.getParameter("code");
	}
	UserDAO userDAO = new UserDAO();
	String userID = null;
	
	//사용자가 로그인 한 상태 : userID에 해당 session값 넣어줌
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID"); //session 값은 기본적으로 객체를 반환하므로 String으로 형변환 
	}
	
	//사용자가 로그인 하지 않은 상태
	if (userID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 헤주세요.');");
		script.println("location.href = 'userLogin.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
	
	//userDAO 이용해서 해당하는 userEmail 받아오기
	String userEmail = userDAO.getUserEmail(userID);
	//사용자가 보낸 code가 해당 userEmail의 해쉬값을 적용한 값이랑 일치하는지 확인 
	boolean isRight = (new SHA256().getSHA256(userEmail).equals(code)) ? true : false;
	
	if (isRight == true) {
		userDAO.setUserEmailChecked(userID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('인증에 성공했습니다.');");
		script.println("location.href = 'index.jsp';") ;
		script.println("</script>");
		script.close();
		return;
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 코드입니다.');");
		script.println("location.href = 'index.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
%>