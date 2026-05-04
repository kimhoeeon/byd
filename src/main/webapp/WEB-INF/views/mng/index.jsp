<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta name="robots" content="noindex, nofollow">

    <link rel="icon" href="/favicon.ico"/>
    <link rel="shortcut icon" href="/favicon.ico"/>

    <title>BYD ADMIN | 로그인</title>

    <link href="/assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/assets/css/style.bundle.css" rel="stylesheet" type="text/css"/>

    <style>
        /* 어두운 테마 배경 적용 */
        body {
            background-color: #151521;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }

        /* 로그인 카드 UI (화이트 로고가 잘 보이도록 다크톤 유지) */
        .login-card {
            background-color: #1e1e2d;
            border: 1px solid rgba(255, 255, 255, 0.05);
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
            width: 100%;
            max-width: 450px;
            padding: 50px 40px;
        }

        .logo-area {
            text-align: center;
            margin-bottom: 25px;
        }

        .logo-area img {
            height: 45px;
        }

        .system-title {
            text-align: center;
            font-size: 18px;
            font-weight: 600;
            color: #ffffff;
            margin-bottom: 30px;
            letter-spacing: -0.5px;
        }

        /* 입력창 디자인 (다크 테마용) */
        .form-control {
            background-color: rgba(255, 255, 255, 0.05) !important;
            border: 1px solid rgba(255, 255, 255, 0.1) !important;
            color: #ffffff !important;
            padding: 12px 15px;
        }

        .form-control:focus {
            border-color: #009ef7 !important;
            background-color: rgba(255, 255, 255, 0.08) !important;
        }

        .btn-primary {
            background-color: #009ef7 !important;
            padding: 12px;
            width: 100%;
            font-size: 16px;
            border: none;
        }

        .btn-primary:hover {
            background-color: #008be0 !important;
        }
    </style>
</head>

<body id="kt_body">

<div class="login-card">
    <div class="logo-area">
        <!-- 하얀색 로고 파일 경로 (확장자 주의) -->
        <img alt="Logo" src="/img/logo.png"/>
    </div>

    <div class="system-title">
        BYD 이벤트 통합 관리 시스템
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger d-flex align-items-center p-3 mb-5"
             style="background-color: rgba(241, 65, 108, 0.1); border: 1px solid rgba(241, 65, 108, 0.3); color: #f1416c;">
            <span class="fw-bold" style="font-size: 13px;">${errorMessage}</span>
        </div>
    </c:if>

    <form action="/mng/loginProcess" method="post">
        <div class="mb-5">
            <input type="text" placeholder="아이디를 입력하세요" name="adminId" autocomplete="off" class="form-control"
                   required/>
        </div>
        <div class="mb-10">
            <input type="password" placeholder="비밀번호를 입력하세요" name="adminPw" autocomplete="off" class="form-control"
                   required/>
        </div>
        <div>
            <button type="submit" class="btn btn-primary fw-bold">로그인</button>
        </div>
    </form>
</div>

<script src="/assets/plugins/global/plugins.bundle.js"></script>
<script src="/assets/js/scripts.bundle.js"></script>
</body>
</html>