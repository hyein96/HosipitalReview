
<!-- 로그인 된 사용자가 로그아웃을 요청할 때  처리해주는 페이지 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	session.invalidate(); // 현재 사용자가 클라이언트의 모든 session정보를 파기시킴
%>
<script>
	location.href = 'index.jsp';	
</script>