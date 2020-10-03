<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDAO"%>
<%@ page import="evaluation.EvaluationDAO"%>
<%@ page import="evaluation.EvaluationDTO"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.net.URLEncoder"%>


<!-- UTF-8 하는 이유: 한글로 작성   -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!--부트스트랩은 디자인 알아서 처리해주는 반응형 웹 플랫폼이므로 viewport와 관련 설정 넣어줘야함 -->
<meta name="viewport"
	content="width=device.width, initial-scale = 1, shrink-to-fit=no">
<title>강의평가 웹 사이트</title>
<!--  부트스트랩 CSS 추가하기 -->
<link rel="stylesheet" href="./css/bootstrap.min.css">
<!--  커스텀 CSS 추가하기 -->
<link rel="stylesheet" href="./css/custom.css">
</head>
<body>
	<%
	request.setCharacterEncoding("UTF-8");
	String lectureDivide = "전체";
	String searchType = "최신순";
	String search = "";
	int pageNumber = 0;
	
	//사용자가 특정 내용으로 검색했는지 확인
	//검색 요청 들어오면(검색 했다면)
	if(request.getParameter("lectureDivide") != null) { 
		lectureDivide = request.getParameter("lectureDivide");
	}
	if(request.getParameter("searchType") != null) { 
		searchType = request.getParameter("searchType");
	}
	if(request.getParameter("search") != null) { 
		search = request.getParameter("search");
	}
	if(request.getParameter("pageNumber") != null) { 
		try{
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		} catch(Exception e){
			//입력한 pageNumber가 정수형이 아니면 오류 발생
			System.out.println("검색 페이지 번호 오류");
		}
	}
	
	//사용자가 로그인 안했으면 index.jsp 페이지 접속 불가 
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
	//사용자가 이메일인증을 받았는지 확인
	boolean emailChecked = new UserDAO().getUserEmailChecked(userID);
	if(emailChecked == false){ //이메일 인증이 안되면 강의평가 X
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'emailSendConfirm.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
%>
	<!-- navbar는 기본적으로 부트스트랩이 제공해주는 클래스 중 하나 (네비게이션 바 구성해보자!)-->
	<nav class="navbar navbar-expand-lg navbar-light bg-light">
		<a class="navbar-brand" href="index.jsp">강의평가 웹사이트</a>
		<!-- 버튼을 누르면 navbar라는 id를 가진 곳으로 넘어감 , data-target 참고 -->
		<button class="navbar-toggler" type="button" data-toggle="collapse"
			data-target="#navbar">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div id="navbar" class="collapse navbar-collapse">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item active"><a class="nav-link"
					href="index.jsp">메인</a></li>
				<li class="nav-item dropdown"><a
					class="nav-link dropdown-toggle" id="dropdown"
					data-toggle="dropdown"> 회원 관리 </a>
					<div class="dropdown-menu" aria-labelledby="dropdown">
					<%
	//로그인상태에 따라 index.jsp의 화면이 달라야하므로 처리해주는 것
	if(userID == null){ //로그인 안된 상태
%>
						<a class="dropdown-item" href="userLogin.jsp">로그인</a> <a
							class="dropdown-item" href="userJoin.jsp">회원가입</a>
						<%
	} else {

%>
						<a class="dropdown-item" href="userLogout.jsp">로그아웃</a>
						<%
	}
%>

					</div></li>
			</ul>
			<form action="./index.jsp" method="get"
				class="form-inline my-2 my-lg-0">
				<!-- search에 요청정보 들어가며 index url로 이동 (search값이 채워진상태로 DB 호출하며 evaluationList 반환 됨) -->
				<input type="text" name="search" class="form-control mr-sm-2"
					placeholder="내용을 입력하세요" aria-label="search">
				<button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
			</form>
		</div>
	</nav>
	<!-- 메인페이지  본문(강의평가 관련내용) 넣어보자 ! -->
	<section class="container">
		<!-- get방식으로 전달 , lectureDivide의 option 중 하나 선택해서 서버로전달! action은 index.jsp -->
		<form method="get" action="./index.jsp" class="form-inline mt-3">
			<select name="lectureDivide" class="form-control mx-1 mt-2">
				<option value="전체">전체</option>
				<option value="전공"<% if(lectureDivide.equals("전공")) out.println("selected"); %>>전공</option>
				<option value="교양"<% if(lectureDivide.equals("교양")) out.println("selected"); %>>교양</option>
				<option value="기타"<% if(lectureDivide.equals("기타")) out.println("selected"); %>>기타</option>
			</select>
			<select name="searchType" class="form-control mx-1 mt-2">
				<option value="최신순">최신순</option>
				<option value="추천순"<% if(searchType.equals("추천순")) out.println("selected"); %>>추천순</option>
			</select>
			<!-- 사용자가 내용입력하는 검색기능  -->
			<input type="text" name="search" class="form-conreol mx-1 mt-2"
				placeholder="내용을 입력하세요.">
			<button type="submit" class="btn btn-primary mx-1 mt-2">검색</button>
			<!-- a태그사용해서 modal형식(부트스트랩에서 제공함)으로 강의평가 등록버튼과 신고버튼 만들기 -->
			<a class="btn btn-primary mx-1 mt-2" data-toggle="modal"
				href="#registerModal">등록하기</a> <a class="btn btn-danger mx-1 mt-2"
				data-toggle="modal" href="#reportModal">신고</a>
		</form>
	
<%
	//사용자가 검색한 내용이 리스트에 담겨서 출력 되도록 코드 작성
	ArrayList<EvaluationDTO> evaluationList = new ArrayList<EvaluationDTO>();
	evaluationList = new EvaluationDAO().getList(lectureDivide, searchType, search, pageNumber);
	if(evaluationList != null){
		for(int i = 0; i < evaluationList.size(); i++){
			if(i == 5) break;
			EvaluationDTO evaluation = evaluationList.get(i);
%>

		<!-- 강의평가를 등록했을 때 어떻게 화면에 출력될지 정의//card 이용 -->
		<div class="card bg-light mt-3">
			<div class="card-header bg-light">
				<div class="row">
					<div class="col-8 text-left">
						<%= evaluation.getLectureName() %>&nbsp;<small><%= evaluation.getProfessorName() %></small>
					</div>
					<div class="col-4 text-right">
						종합 <span style="color: red;"><%= evaluation.getTotalScore() %></span>
					</div>
				</div>
			</div>
			<div class="card-body">
				<h5 class="card-title">
					<%= evaluation.getEvaluationTitle() %>&nbsp;<small>(<%= evaluation.getLectureYear() %>년 <%= evaluation.getSemesterDivide() %>)</small>
				</h5>
				<p class="card-text"><%= evaluation.getEvaluationContent() %></p>
				<div class="row">
					<div class="col-9 text-left">
						성적<span style="color: red;"><%= evaluation.getCreditScore() %></span> 
						널널<span style="color: red;"><%= evaluation.getComfortableScore() %></span>
						강의<span style="color: red;"><%= evaluation.getLectureScore() %></span> 
						<span style="color: green;">(추천: <%= evaluation.getLikeCount() %>)</span>
					</div>
					<div class="col-3 text-right">
						<!--ID가 특정 값을 가지는 해당 강의평가 글에 추천을 하거나 삭제를 함  -->
						<a onclick="return confirm('추천하시겠습니까?')"
							href="./likeAction.jsp?evaluationID=<%= evaluation.getEvalutaionID() %>">추천</a> <a
							onclick="return confirm('삭제하시겠습니까?')"
							href="./deleteAction.jsp?evaluationID=<%= evaluation.getEvalutaionID() %>">삭제</a>
					</div>
				</div>
			</div>
		</div>
<%
		}
	}
%>	
	</section>
	<!-- 페이지 내이션 -->
	<ul class ="pagination justify-content-center mt-3">
		<li class = "page-item">
<%
	//이전페이지 처리
	
	//이전페이지가 없다면
	if(pageNumber <= 0) {
%>
	<!-- 마우스가 클릭할 수 없게 disabled 처리 -->
	<a class= "page-link disabled">이전</a>
<%
	//이전페이지 존재하면 
	} else {
%>
	<!--특정URL로 이동할 떄ㅡ URLEncoder 이용하는게 일반적(현재 값 유지한 채, page 뒤로 이동시킴 -->
	<a class="page-link" href="./index.jsp?lectureDivide=<%= URLEncoder.encode(lectureDivide, "UTF-8") %>
	&searchType=<%= URLEncoder.encode(searchType, "UTF-8")%>&search=<%= URLEncoder.encode(search, "UTF-8")%>
	&pageNumber=<%= pageNumber +1%>">이전</a>
<%
	}
%>
		</li>
		<li>
<%
	//다음페이지 처리
	
	//다음페이지가 없다면(6보다 작으면 다음페이지가 없는 것: EvaluationDAO getList 함수 참고)
	if(evaluationList.size()< 6) {
%>
	<!-- 마우스가 클릭할 수 없게 disabled 처리 -->
	<a class= "page-link disabled">다음</a>
<%
	//다음페이지 존재하면 
	} else {
%>
	<!--특정URL로 이동할 떄ㅡ URLEncoder 이용하는게 일반적(현재 값 유지한 채, page 뒤로 이동시킴 -->
	<a class="page-link" href="./index.jsp?lectureDivide=<%= URLEncoder.encode(lectureDivide, "UTF-8") %>
	&searchType=<%= URLEncoder.encode(searchType, "UTF-8")%>&search=<%= URLEncoder.encode(search, "UTF-8")%>
	&pageNumber=<%= pageNumber +1%>">다음</a>
<%
	}
%>
		</li>
	</ul>

	<!-- modal양식 넣어주기 즉, 위의 modal버튼 클릭시 각각의 해당내용이 밑에부분 처럼 나옴-->
	<!-- 등록하기 modal 양식 -->
	<div class="modal fade" id="registerModal" tabindex="-1" role="dialog"
		aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<!-- modal-content(modal창)는 modal-header,modal-body,modal-footer로 나뉨 -->
				<div class="modal-header">
					<h5 class="modal-title" id="modal">평가등록</h5>
					<!-- 닫기버튼으로 버튼누르면 data-dismiss="modal" 즉, modal 창이 닫힘 , 닫기아이콘은 &times이다. -->
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<!--evaluationRegisterAction jsp페이지로 사용자의 평가등록 요청이 전달됨 -->
					<form action="./evaluationRegisterAction.jsp" method="post">
						<!-- 하나의행을 여러개의 열로 나눌때 row사용, 일반적으로 하나의 행을 12열인데 6개씩 나누어서들어가게!  -->
						<div class="form-row">
							<div class="form-group col-sm-6">
								<label>강의명</label> <input type="text" name="lectureName"
									class="form-control" maxlength="20">
							</div>
							<div class="form-group col-sm-6">
								<label>교수명</label> <input type="text" name="professorName"
									class="form-control" maxlength="20">
							</div>
						</div>
						<div class="form-row">
							<div class="form-group col-sm-4">
								<label>수강 연도</label> <select name="lectureYear"
									class="form-control">
									<option value="2011">2011</option>
									<option value="2012">2012</option>
									<option value="2013">2013</option>
									<option value="2014">2014</option>
									<option value="2015">2015</option>
									<option value="2016">2016</option>
									<option value="2017">2017</option>
									<option value="2018">2018</option>
									<option value="2019" selected>2019</option>
									<option value="2020">2020</option>
									<option value="2021">2021</option>
									<option value="2022">2022</option>
									<option value="2023">2023</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label>수강 학기</label> <select name="semesterDivide"
									class="form-control">
									<option value="1학기" selected>1학기</option>
									<option value="여름학기">여름학기</option>
									<option value="2학기">2학기</option>
									<option value="겨울학기">겨울학기</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label>강의 구분</label> <select name="lectureDivide"
									class="form-control">
									<option value="전공" selected>전공</option>
									<option value="교양">교양</option>
									<option value="기타">기타</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label>제목</label> <input type="text" name="evaluationTitle"
								class="form-control" maxlength="30">
						</div>
						<div class="form-group">
							<label>내용</label>
							<textarea name="evaluationContent" class="form-control"
								maxlength="2048" style="height: 180px;"></textarea>
						</div>
						<div class="form-row">
							<div class="form-group-col-sm-3">
								<label>종합</label> <select name="totalScore" class="form-control">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
							<div class="form-group-col-sm-3">
								<label>성적</label> <select name="creditScore"
									class="form-control">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
							<div class="form-group-col-sm-3">
								<label>널널</label> <select name="comfortableScore"
									class="form-control">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
							<div class="form-group-col-sm-3">
								<label>강의</label> <select name="lectureScore"
									class="form-control">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary"
								data-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-primary">등록하기</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<!-- 신고하기 modal 양식 -->
	<div class="modal fade" id="reportModal" tabindex="-1" role="dialog"
		aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<!-- modal-content(modal창)는 modal-header,modal-body,modal-footer로 나뉨 -->
				<div class="modal-header">
					<h5 class="modal-title" id="modal">신고하기</h5>
					<!-- 닫기버튼으로 버튼누르면 data-dismiss="modal" 즉, modal 창이 닫힘 , 닫기아이콘은 &times이다. -->
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<!--evaluationRegisterAction jsp페이지로 사용자의 평가등록 요청이 전달됨 -->
					<form action="./reportAction.jsp" method="post">
						<div class="form-group">
							<label>신고제목</label> <input type="text" name="reportTitle"
								class="form-control" maxlength="30">
						</div>
						<div class="form-group">
							<label>신고 내용</label>
							<textarea name="reportContent" class="form-control"
								maxlength="2048" style="height: 180px;"></textarea>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary"
								data-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-danger">신고하기</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<footer class="bg-dark mt-4 p-5 text-center" style="color: #FFFFFF;">
		Copyright &copy; 2019 조혜인 All Rights Reserved. </footer>
	<!--  제이쿼리 자바스크립트 추가하기 -->
	<script src="./js/jquery.min.js"></script>
	<!--  파퍼 자바스크립트 추가하기 -->
	<script src="./js/popper.js"></script>
	<!--  부트스트랩 자바스크립트 추가하기 -->
	<script src="./js/bootstrap.min.js"></script>
</body>
</html>