<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!doctype html>
<html lang="ko">
<head>
    <meta name="naver-site-verification" content="07e0fdf4e572854d6fbe274f47714d3e7bbb9fbd" />
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" />
    <meta name="format-detection" content="telephone=no,email=no,address=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="mobile-web-app-capable" content="yes" />

    <meta property="og:type" content="website">
    <meta property="og:locale" content="ko_KR">
    <meta property="og:site_name" content="승요일기">
    <meta property="og:title" content="승요일기 | 야구 직관 기록 앱">
    <meta property="og:description" content="야구 직관 기록을 더 쉽고 재미있게! 경기 결과, 기록, 사진과 함께 나만의 야구 직관일기를 남겨보세요.">
    <meta name="keywords" content="승요일기 / 야구 직관 / 프로야구 직관 / 직관 후기 / 직관일기 / KBO / KBO 직관 / 프로야구 앱 / 야구팬 앱">
    <meta property="og:url" content="https://myseungyo.com/">
    <meta property="og:image" content="https://myseungyo.com/img/og_img.jpg">

    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="manifest" href="/site.webmanifest" />

    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">

    <title>계정 찾기 결과 | 승요일기</title>

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
</head>
<body class="page-login">

    <div class="page-login_wrap">
        <div class="login-card">
            <div class="login gap-24">
                <c:choose>
                    <%-- 1. 아이디 찾기 성공 --%>
                    <c:when test="${not empty foundEmail}">
                        <img src="/img/ico_user.svg" alt="성공">
                        <div class="login-txt">
                            <div class="login_title">
                                    ${nickname}님의 아이디는<br />
                                <span class="name color-p">${foundEmail}</span><br />
                                입니다.
                            </div>
                        </div>

                        <div class="login-bottom mt-50">
                            <div class="login-actions">
                                <button class="join-btn btn-primary" onclick="location.href='/member/login'">
                                    로그인 하기
                                </button>
                            </div>
                            <div class="login-options mt-16" style="justify-content: center;">
                                <a class="login-link" href="/member/find-password">비밀번호 찾기</a>
                            </div>
                        </div>
                    </c:when>

                    <%-- 2. 아이디 찾기 실패 (일치하는 정보 없음) --%>
                    <c:otherwise>
                        <img src="/img/ico_warning.svg" alt="실패">
                        <div class="login-txt">
                            <h1 class="login_title">일치하는 회원 정보가 없습니다.</h1>
                            <p class="login_desc">입력하신 정보를 다시 확인해 주세요.</p>
                        </div>

                        <div class="login-bottom mt-50">
                            <div class="login-actions">
                                <button class="join-btn btn-primary" onclick="history.back()">
                                    다시 시도하기
                                </button>
                            </div>
                            <div class="login-options mt-16" style="justify-content: center;">
                                <a class="login-link" href="/member/join">회원가입 하기</a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
</body>
</html>