
<!-- 이메일 인증위해 사용자에게 이메일 인증메세지 다시 받을지 물어보는 페이지 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.io.PrintWriter" %>
<!-- UTF-8 하는 이유: 한글로 작성   -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<!--부트스트랩은 디자인 알아서 처리해주는 반응형 웹 플랫폼이므로 viewport와 관련 설정 넣어줘야함 -->
	<meta name = "viewport" content= "width=device.width, initial-scale = 1, shrink-to-fit=no">
	<title>강의평가 웹 사이트</title>
	<!--  부트스트랩 CSS 추가하기 -->
	<link rel = "stylesheet" href="./css/bootstrap.min.css">
	<!--  커스텀 CSS 추가하기 -->
	<link rel = "stylesheet" href="./css/custom.css">
</head>
<body>
<%
	//사용자가 로그인 상태면 userLogin.jsp 페이지 접속 불가 
	String userID = null;
	if(session.getAttribute("userID") != null){ // 로그인 상태면
		userID = (String)session.getAttribute("userID");
	}
	if(userID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href = 'userLogin.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
%>
	<!-- navbar는 기본적으로 부트스트랩이 제공해주는 클래스 중 하나 (네비게이션 바 구성해보자!)-->
	<nav class = "navbar navbar-expand-lg navbar-light bg-light">
		<a class ="navbar-brand" href ="index.jsp">강의평가 웹사이트</a>
		<!-- 버튼을 누르면 navbar라는 id를 가진 곳으로 넘어감 , data-target 참고 -->
		<button class ="navbar-toggler" type ="button" data-toggle="collapse" data-target="#navbar">
			<span class ="navbar-toggler-icon"></span>
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
	if(userID == null){ //로그인 안된 상태
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
	<section class="container mt-3" style="max-width:560px;">
		<div class = "alert alert-warning mt-4" role="alert">
			이메일 주소 인증을 하셔야 이용 가능합니다. 인증 메일을 받지 못하셨나요?
		</div>
		<a href = "emailSendAction.jsp" class="btn btn-primary">인증 메일 다시 받기</a>
	</section>
	<footer class="bg-dark mt-4 p-5 text-center" style="color:#FFFFFF;">
		Copyright &copy; 2019 조혜인 All Rights Reserved.
	</footer>
	<!--  제이쿼리 자바스크립트 추가하기 -->
	<script src = "./js/jquery.min.js"></script>
	<!--  파퍼 자바스크립트 추가하기 -->
	<script src = "./js/popper.js"></script>
	<!--  부트스트랩 자바스크립트 추가하기 -->
	<script src = "./js/bootstrap.min.js"></script>	
</body>
</html>