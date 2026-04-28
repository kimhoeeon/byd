<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta name="naver-site-verification" content="07e0fdf4e572854d6fbe274f47714d3e7bbb9fbd" />
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" />
    <title>로그인 처리 중...</title>

    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>

    <script>
        // 브라우저 URL에 남아있는 1회용 인증 코드를 숨겨 새로고침 시 중복 요청(KOE320 에러) 방지
        if (window.history.replaceState) {
            window.history.replaceState({}, null, '/member/login');
        }

        $(document).ready(function() {
            // 1. 기존 가입 데이터 초기화
            sessionStorage.clear();

            // URL에 노출된 보안 코드 제거
            window.history.replaceState({}, document.title, "/member/join_social_bridge");

            <c:if test="${not empty socialInfo}">
                // script.js에 정의된 customConfirm 사용
                // [확인] 콜백 -> 가입 프로세스 진행
                sessionStorage.setItem('join_email', '${socialInfo.email}');
                sessionStorage.setItem('join_nickname', '${socialInfo.nickname}');
                sessionStorage.setItem('join_provider', '${socialInfo.socialProvider}');
                sessionStorage.setItem('join_social_uid', '${socialInfo.socialUid}');
            </c:if>

            location.replace('/member/join/step1');
        });
    </script>
</body>
</html>