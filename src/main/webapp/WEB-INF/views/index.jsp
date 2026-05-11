<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 카페24 점검 봇에게 index 파일이 존재함을 알리고,
    // 실제 접속한 사용자는 이벤트 신청 첫 페이지로 즉시 리다이렉트 시킵니다.
    response.sendRedirect("/apply/step1");
%>