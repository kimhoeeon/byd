<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" />
    <meta name="format-detection" content="telephone=no,email=no,address=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="mobile-web-app-capable" content="yes" />
    <meta name="robots" content="noindex, nofollow">

    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="manifest" href="/site.webmanifest" />

    <title>관리자 로그인 | BYD</title>

    <link href="/assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/assets/css/style.bundle.css" rel="stylesheet" type="text/css"/>

    <style>
        body { background: #0f1014; }
        .login-card {
            background: rgba(30, 32, 44, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.05);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.5);
        }
        .form-control {
            background: rgba(255, 255, 255, 0.05) !important;
            border: 1px solid rgba(255, 255, 255, 0.1) !important;
            color: #fff !important;
        }
        .form-control:focus { border-color: #009ef7 !important; }
        .btn-primary { background-color: #009ef7 !important; }
        .text-gray-dark { color: #a1a5b7; }
    </style>
</head>

<body id="kt_body" class="app-blank">

    <div class="d-flex flex-column flex-root" id="kt_app_root">
        <div class="d-flex flex-column flex-column-fluid flex-lg-row">
            <div class="d-flex flex-center w-lg-50 pt-15 pt-lg-0 px-10">
                <div class="d-flex flex-center flex-lg-start flex-column">
                    <a href="#" class="mb-7"><img alt="Logo" src="/img/logo.svg" class="h-60px" /></a>
                    <h2 class="text-white fw-normal m-0">BYD 하이록스 홍보 부스 통합 관리 시스템</h2>
                </div>
            </div>
            <div class="d-flex flex-column-fluid flex-lg-row-auto justify-content-center p-12">
                <div class="bg-body d-flex flex-column flex-center rounded-4 w-md-600px p-10 login-card">
                    <div class="d-flex flex-center flex-column align-items-stretch w-md-400px">
                        <div class="text-center mb-11">
                            <h1 class="text-white fw-bolder mb-3 font-interstate">ADMIN LOGIN</h1>
                            <div class="text-gray-dark fw-semibold fs-6">관리자 계정으로 로그인하세요.</div>
                        </div>

                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-dismissible bg-light-danger d-flex flex-column flex-sm-row p-5 mb-10">
                                <div class="d-flex flex-column pe-0 pe-sm-10">
                                    <span class="text-danger fw-bold">${errorMessage}</span>
                                </div>
                            </div>
                        </c:if>

                        <form class="form w-100" action="/mng/loginProcess" method="post">
                            <div class="fv-row mb-8">
                                <input type="text" placeholder="ID" name="adminId" autocomplete="off" class="form-control bg-transparent" required />
                            </div>
                            <div class="fv-row mb-10">
                                <input type="password" placeholder="Password" name="adminPw" autocomplete="off" class="form-control bg-transparent" required />
                            </div>
                            <div class="d-grid mb-10">
                                <button type="submit" class="btn btn-primary">
                                    <span class="indicator-label fw-bold fs-5">로그인</span>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="/assets/plugins/global/plugins.bundle.js"></script>
    <script src="/assets/js/scripts.bundle.js"></script>
</body>
</html>