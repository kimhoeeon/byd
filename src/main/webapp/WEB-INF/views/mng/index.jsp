<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:if test="${not empty sessionScope.admin}">
    <c:redirect url="/mng/main.do"/>
</c:if>

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

    <title>관리자 로그인 | 승요일기</title>

    <link href="/assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/assets/css/style.bundle.css" rel="stylesheet" type="text/css"/>

    <style>
        /* 배경 이미지 대신 CSS 그라데이션 적용 */
        body {
            /* 기본 다크 배경 */
            /* 중앙에서 퍼지는 은은한 조명 효과 (Dark Blue 톤) */
            background: #1e1e2d radial-gradient(circle at center, #2b3344 0%, #1e1e2d 70%);
            min-height: 100vh;
        }

        /* 로그인 카드 스타일 */
        .card-login {
            background-color: #151521 !important;
            border: 1px solid #2b2b40;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.4); /* 그림자 강화 */
        }

        /* 입력창 커스텀 (다크 모드) */
        .form-control.bg-dark-input {
            background-color: #1e1e2d !important;
            border-color: #323248;
            color: #ffffff;
        }
        .form-control.bg-dark-input:focus {
            border-color: #0055a2; /* 키 컬러 (Blue) */
            box-shadow: 0 0 0 0.25rem rgba(0, 85, 162, 0.25);
        }

        /* 로고 텍스트 */
        .logo-text {
            color: #ffffff;
            font-weight: 700;
            letter-spacing: -1px;
        }

        /* 로그인 버튼 (키 컬러 그라데이션) */
        .btn-primary-custom {
            background: #0055a2 linear-gradient(135deg, #0055a2 0%, #003e7e 100%);
            border: none;
            color: white;
            font-weight: 600;
        }
        .btn-primary-custom:hover {
            background: linear-gradient(135deg, #0066c2 0%, #004a96 100%);
            color: white;
        }
    </style>
</head>

<body id="kt_body" class="app-blank">
    <div class="d-flex flex-column flex-root" id="kt_app_root">
        <div class="d-flex flex-column flex-column-fluid flex-center p-10">

            <div class="card card-login w-100 w-md-400px w-lg-450px rounded-3">
                <div class="card-body p-10 p-lg-15">

                    <form class="form w-100" novalidate="novalidate" id="login_form" action="/mng/login" method="post">

                        <div class="text-center mb-10">
                            <img alt="Logo" src="/img/logo.svg" class="h-60px mb-3"/>
                            <h1 class="logo-text mb-3">
                                Admin System
                            </h1>
                            <div class="text-gray-500 fw-semibold fs-4">
                                승요일기 관리자 시스템
                            </div>
                        </div>

                        <c:if test="${not empty msg}">
                            <div class="alert alert-danger d-flex align-items-center p-5 mb-5">
                                <i class="ki-duotone ki-shield-cross fs-2hx text-danger me-4">
                                    <span class="path1"></span><span class="path2"></span>
                                </i>
                                <div class="d-flex flex-column">
                                    <h4 class="mb-1 text-danger">Login Failed</h4>
                                    <span>${msg}</span>
                                </div>
                            </div>
                        </c:if>

                        <div class="fv-row mb-8">
                            <label class="form-label fs-6 fw-bold text-white">아이디</label>
                            <input type="text" name="adminId" autocomplete="off"
                                   class="form-control bg-dark-input form-control-lg"
                                   placeholder="아이디를 입력하세요" required />
                        </div>

                        <div class="fv-row mb-10">
                            <div class="d-flex flex-stack mb-2">
                                <label class="form-label fw-bold text-white fs-6 mb-0">비밀번호</label>
                            </div>
                            <input type="password" name="adminPw" autocomplete="off"
                                   class="form-control bg-dark-input form-control-lg"
                                   placeholder="비밀번호를 입력하세요" required />
                        </div>

                        <div class="d-grid mb-10">
                            <button type="submit" id="kt_sign_in_submit" class="btn btn-primary-custom btn-lg">
                                <span class="indicator-label">로그인</span>
                                <span class="indicator-progress">Please wait...
                                    <span class="spinner-border spinner-border-sm align-middle ms-2"></span></span>
                            </button>
                        </div>

                    </form>

                </div>
            </div>

            <div class="d-flex flex-center flex-column-auto p-10">
                <div class="d-flex align-items-center fw-semibold fs-6">
                    <span class="text-gray-600 px-2">Copyright &copy; 승요일기. All rights reserved.</span>
                </div>
            </div>

        </div>
    </div>

    <script src="/assets/plugins/global/plugins.bundle.js"></script>
    <script src="/assets/js/scripts.bundle.js"></script>
    <script>
        var form = document.querySelector('#login_form');
        var submitButton = document.querySelector('#kt_sign_in_submit');

        // [3] 뒤로 가기(BF Cache) 감지하여 버튼 상태 리셋
        window.addEventListener('pageshow', function(event) {
            var historyTraversal = event.persisted ||
                (typeof window.performance != "undefined" &&
                    window.performance.navigation.type === 2);

            if (historyTraversal) {
                // 로딩 상태 해제
                submitButton.removeAttribute('data-kt-indicator');
                submitButton.disabled = false;

                // 이미 세션이 있다면 메인으로 새로고침
                location.reload();
            }
        });

        // 폼 제출 시 로딩 처리
        form.addEventListener('submit', function (e) {
            var id = form.querySelector('input[name="adminId"]').value;
            var pw = form.querySelector('input[name="adminPw"]').value;

            if (!id || !pw) {
                e.preventDefault();
                Swal.fire({
                    text: "아이디와 비밀번호를 모두 입력해주세요.",
                    icon: "warning",
                    buttonsStyling: false,
                    confirmButtonText: "확인",
                    customClass: {
                        confirmButton: "btn btn-primary"
                    }
                });
                return;
            }

            // 로딩 표시 켜기
            submitButton.setAttribute('data-kt-indicator', 'on');
            submitButton.disabled = true;
        });
    </script>
</body>
</html>