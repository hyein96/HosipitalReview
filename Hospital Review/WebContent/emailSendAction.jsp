
<!-- 이메일 인증 받는 페이지 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- 메일 전송위해 mail 라이브러리 다 사용한다고 설정(*이 안되면 일일히 작성)  -->
<%@ page import="javax.mail.Transport"%>
<%@ page import="javax.mail.Message"%>
<%@ page import="javax.mail.Address"%>
<%@ page import="javax.mail.internet.InternetAddress"%>
<%@ page import="javax.mail.internet.MimeMessage"%>
<%@ page import="javax.mail.Session"%>
<%@ page import="javax.mail.Authenticator"%>
<!-- 속성 정의 시 사용하는 라이브러리 -->
<%@ page import="java.util.Properties"%>
<%@ page import="user.UserDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="util.Gmail"%>
<%@ page import="java.io.PrintWriter"%>
<%
	UserDAO userDAO = new UserDAO();
	String userID = null;
	
	 //session값이 유효한 상태 ,즉,사용자가 로그인 한 상태 : userID에 해당 session값 넣어줌
	if(session.getAttribute("userID") != null){
		userID = (String)session.getAttribute("userID");
	}
	if(userID == null){  //사용자가 로그인 하지 않은 상태
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 헤주세요.');");
		script.println("location.href = 'userLogin.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
	//이메일 인증 되었는지 확인
	boolean emailChecked = userDAO.getUserEmailChecked(userID);
	if(emailChecked == true){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 인증 된 회원입니다.');");
		script.println("location.href = 'index.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
	
	// 이메일 인증이 안되어있으면 이메일 인증 메세지 보내줘야함 
	// --> 구글 SMTP가 기본적으로 제공하는 양식 사용
	   
	String host = "http://localhost:8080/Lecture_Evaluation/" ; //현재 웹사이트 주소(웹사이트에 뜨는 주소 잘보고 적기!!(공백이 _로 됬는지 아니면 그냥 공백인지 공백으로 되어있으면 스페이스 공백인 %20로 줘야함))
	String from = "johaein1@gmail.com";
	String to = userDAO.getUserEmail(userID);
	String subject = "강의평가를 위한 이메일 인증 메일입니다.";
	String content = "다움 링크에 접속하여 이메일 인증을 진행하세요." + 
		"<a href='" + host + "emailCheckAction.jsp?code=" + new SHA256().getSHA256(to) + "'>이메일 인증하기</a>";
	
	// 실제로 SMTP에 접속 하기위한 정보 넣기 --> Properties 사용
	Properties p = new Properties();
	// 구글 SMTP 서버 이용 위한 정보 입력 & 설정
	p.put("mail.smtp.user", from);
	p.put("mail.smtp.host", "smtp.googlemail.com"); //구글에서 제공하는 SMTP서버
	p.put("mail.smtp.port", "465"); //포트는 정해져있음
	p.put("mail.smtp.starttls.enable", "true"); //starttls 사용가능여부 true로
	p.put("mail.smtp.auth", "true");
	p.put("mail.smtp.debug", "true");
	p.put("mail.smtp.socketFactory.port", "465");
	p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
	p.put("mail.smtp.socketFactory.fallback", "false");
	
	//이메일전송부분
	try{
		//구글계정으로 Gmail 인증 수행 후, 사용자에게 이메일 인증메일 전송
		Authenticator auth = new Gmail();
		Session sess = Session.getInstance(p, auth);
		sess.setDebug(true); //디버깅 설정
		MimeMessage msg = new MimeMessage(sess); //MimeMessage 객체 이용해서 전송
		
		msg.setSubject(subject); //메일 제목넣기
		Address fromAddr = new InternetAddress(from); //보내는사람정보
		msg.setFrom(fromAddr);
		Address toAddr = new InternetAddress(to); //받는사람정보
		msg.addRecipient(Message.RecipientType.TO, toAddr); //받는사람 주소넣기
		msg.setContent(content, "text/html;charset=UTF-8"); //메일안에 담길 내용정의(UTF8로 전송)
		Transport.send(msg); //메세지 전송
	
	}catch(Exception e){
		e.printStackTrace();
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('오류가 발생했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
%>
<!-- 이메일 보냈다는 메세지 출력부분 -->
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=divice-width, initial-scale=1, shrink-to-fit=no">
	<title>강의평가 웹 사이트</title>
	<!-- 부트스트랩 CSS 추가하기 -->
	<link rel="stylesheet" href="./css/bootstrap.min.css">
	<!-- 커스텀 CSS 추가하기 -->
	<link rel="stylesheet" href="./css/custom.css">
</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-light bg-light">
		<a class="navbar-brand" href="index.jsp">강의평가 웹 사이트</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar" >
			<span class="navbar-toggler-icon"></span>
		</button>
		<div id="navbar" class="collapse navbar-collapse">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item active">
					<a class="nav-link" href="index.jsp">메인</a>
				</li>
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown">
						회원 관리
					</a>
					<div class="dropdown-menu" aria-labelledby="dropdown">
<%
	//로그인상태에 따라 index.jsp의 화면이 달라야하므로 처리해주는 것
	if(userID == null){
%>
						<a class="dropdown-item" href="userLogin.jsp">로그인</a>
						<a class="dropdown-item" href="userJoin.jsp">회원가입</a>
<%	
	} else {
%>
						<a class="dropdown-item" href="userLogout.jsp">로그아웃</a>
<%
	}
%>
					</div>
				</li>
			</ul>
			<form action="./index.jsp" method="get" class="form-inline my-2 my-lg-0">
				<input type="text" name="search" class="form-control mr-sm-2" placeholder="내용을 입력하세요" aria-label="search">
				<button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
			</form>	
		</div>
	</nav>
	<!-- 이메일 보냈다는 메세지 출력 -->
	<section class="container mt-3" style="max-width: 560px;">
		<div class="alert alert-success mt-4 role="alert">
			이메일 주소 인증 메일이 전송되었습니다. 회원가입시 입력했던 이메일에 들어가셔서 인증해주세요.
		</div>
	</section>
	
	<footer class="bg-dark mt-4 p-5 text-center" style="color: #FFFFFF;">
		Copyright &copy; 2019 조혜인 All Rights Reserved.
	</footer>
	<!-- 제이쿼리 자바스크립트 추가하기 -->
	<script src="./js/jquery.min.js"></script>
	<!-- 파퍼 자바스크립트 추가하기 -->
	<script src="./js/popper.min.js"></script>
	<!-- 부트스트랩 자바스크립트 추가하기 -->
	<script src="./js/bootstrap.min.js"></script>
</body>
</html>