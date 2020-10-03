
<!-- 강의평가 등록 기능작동 페이지 : 등록하면 디비에 정보를 넣어줌 -->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="evaluation.EvaluationDTO" %> 
<%@ page import ="evaluation.EvaluationDAO" %> 
<%@ page import ="util.SHA256" %>
<%@ page import = "java.io.PrintWriter" %> <!-- 자바스크립트 구문 출력하기 위해 사용하는 것 중 하나  --> 

<%
	request.setCharacterEncoding("UTF-8"); 
	String userID = null;
	if(session.getAttribute("userID") != null){ // 로그인 상태면(session값 으로 확인)
		userID = (String)session.getAttribute("userID");
	}
	//기본적으로 로그인이 되어있어야 강의평가 등록 가능 
	if(userID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href = 'userLogin.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
	
	//evaluationID와 likeCount는 자동으로 들어가므로 제외 
	String lectureName = null;
	String professorName = null;
	int lectureYear = 0;
	String semesterDivide = null;
	String lectureDivide = null;
	String evaluationTitle = null;
	String evaluationContent = null;
	String totalScore = null;
	String creditScore = null;
	String comfortableScore = null;
	String lectureScore = null;
	
	// * Spring 같은 프레임워크를 사용하면 좀 더 손쉽게 작성가능 *
	if(request.getParameter("lectureName") != null){
		lectureName = request.getParameter("lectureName");
	}
	if(request.getParameter("professorName") != null){
		professorName = request.getParameter("professorName");
	}
	if(request.getParameter("lectureYear") != null){
		//lectureYear는 int형이므로 정수형으로 바꿔주고, 오류발생하면 처리 
		try { 
			lectureYear = Integer.parseInt(request.getParameter("lectureYear"));
		} catch(Exception e) { 
			System.out.println("강의 연도 데이터 오류");
		}
	}
	if(request.getParameter("semesterDivide") != null){
		semesterDivide = request.getParameter("semesterDivide");
	}
	if(request.getParameter("lectureDivide") != null){
		lectureDivide = request.getParameter("lectureDivide");
	}
	if(request.getParameter("evaluationTitle") != null){
		evaluationTitle = request.getParameter("evaluationTitle");
	}
	if(request.getParameter("evaluationContent") != null){
		evaluationContent = request.getParameter("evaluationContent");
	}
	if(request.getParameter("totalScore") != null){
		totalScore = request.getParameter("totalScore");
	}
	if(request.getParameter("creditScore") != null){
		creditScore = request.getParameter("creditScore");
	}
	if(request.getParameter("comfortableScore") != null){
		comfortableScore = request.getParameter("comfortableScore");
	}
	if(request.getParameter("lectureScore") != null){
		lectureScore = request.getParameter("lectureScore");
	}
	
	//평가제목과 내용은 null뿐만아니라 공백이 오면 안되므로 공백일때도 되돌리기 
	if(lectureName == null || professorName == null || lectureYear == 0 || semesterDivide == null || 
			lectureDivide == null || evaluationTitle == null || evaluationContent == null || totalScore == null || 
			creditScore == null || comfortableScore == null || lectureScore == null ||
			evaluationTitle.equals("") || evaluationContent.equals("")) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안 된 사항이 있습니다.');");
		script.println("history.back();"); // 다시 뒤 쪽으로 back
		script.println("</script>");
		script.close();
		return;
	}
	
	//입력을 제대로 받았다면 ? 게시글 등록시키기
	EvaluationDAO evaluationDAO = new EvaluationDAO();
	int result = evaluationDAO.write(new EvaluationDTO(0, userID, lectureName, professorName,
			lectureYear, semesterDivide, lectureDivide, evaluationTitle, evaluationContent, 
			totalScore, creditScore, comfortableScore, lectureScore, 0));
	if(result == -1) { 
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('강의 평가 등록 실패했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'index.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
%>