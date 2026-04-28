<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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

    <title>승요일기 - 로그인</title>

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
</head>

<body class="page-login">

    <div class="page-login_wrap">
        <div class="login-card">
            <div class="login">
                <div class="login_logo" aria-hidden="true">
                    <img src="/img/logo.svg" alt="로고 이미지">
                </div>
            </div>

            <form class="login-form" id="loginForm" action="/member/login" method="post" autocomplete="on">
                <div class="login-field_wrap">
                    <div class="login-field">
                        <input class="login-input" id="loginId" name="email" type="text" inputmode="email" autocomplete="username" placeholder="이메일을 입력해주세요" required />
                    </div>

                    <div class="login-field">
                        <div class="login-inputwrap">
                            <input class="login-input" id="loginPw" name="password" type="password" autocomplete="current-password" placeholder="비밀번호를 입력해주세요" required/>
                            <button class="login-eye" type="button" id="togglePw" aria-label="비밀번호 표시">
                                <img src="/img/pass_off.svg" alt="비밀번호 보기">
                            </button>
                        </div>

                        <div class="login-message" id="loginMessage" role="status" aria-live="polite"></div>
                    </div>
                </div>
                <div class="login-bottom">
                    <div class="login-actions">
                        <button class="login-btn btn-primary" type="submit" id="loginBtn">
                            이메일로 계속하기
                        </button>
                    </div>

                    <div class="login-options">
                        <label class="check">
                            <input type="checkbox" name="remember" id="remember" />
                            자동 로그인
                        </label>
                        <a class="login-link" href="/member/find-password">비밀번호 찾기</a>
                    </div>

                    <div class="login-kakao">
                        <p>또는</p>
                        <a href="https://kauth.kakao.com/oauth/authorize?client_id=68ed5201a09f5e4d4f4bbb3a91e366a1&redirect_uri=https://myseungyo.com/member/kakao/callback&response_type=code" class="login-btn btn-kakao">
                            카카오 로그인
                        </a>
                        <a href="#" id="appleLoginBtn" onclick="fn_appleLogin(); return false;" class="login-btn btn-apple mt-8" style="display: none;">
                            Apple 로그인
                        </a>
                    </div>

                    <ul class="join mt-16">
                        <li>
                            <a href="/member/join">회원가입</a>
                        </li>
                        <li>
                            <a href="/member/find-id">계정찾기</a>
                        </li>
                    </ul>
                </div>
            </form>
        </div>
    </div>

    <form id="appleLoginForm" action="https://appleid.apple.com/auth/authorize" method="get">
        <input type="hidden" name="client_id" id="apple_client_id" value="">
        <input type="hidden" name="redirect_uri" id="apple_redirect_uri" value="">
        <input type="hidden" name="response_type" value="code id_token">
        <input type="hidden" name="scope" value="name email">
        <input type="hidden" name="response_mode" value="form_post">
        <input type="hidden" name="state" id="apple_state" value="">
        <input type="hidden" name="nonce" id="apple_nonce" value="">
    </form>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // 1. 요소 선택
            const idInput = document.getElementById('loginId');
            const pwInput = document.getElementById('loginPw');
            const loginMessage = document.getElementById('loginMessage');

            // Apple 로그인 버튼 Web 및 iOS 노출 로직 (.then 방식 적용)
            const appleBtn = document.getElementById('appleLoginBtn');
            if (appleBtn) {
                // Appify 앱 환경인지 체크
                if (typeof appify !== 'undefined' && appify.isWebview) {
                    // Appify SDK를 통해 기기 정보 가져오기 (.then 방식)
                    appify.device.getInfo().then(function(info) {
                        // 앱일 경우: 플랫폼이 ios인 경우에만 버튼을 보이게 처리
                        if (info && info.platform && info.platform.toLowerCase() === 'ios') {
                            appleBtn.style.display = 'flex'; // 클래스 레이아웃 유지
                        }
                    }).catch(function(err) {
                        console.error("기기 정보 수집 실패 (Apple 버튼 제어):", err);
                    });
                } else {
                    // 웹 브라우저(PC, 모바일 사파리/크롬 등 일반 웹) 환경에서는 무조건 보이게 처리
                    appleBtn.style.display = 'flex';
                }
            }

            // 2. 에러 메시지 숨김 처리 함수
            function hideErrorMessage() {
                if (loginMessage && loginMessage.classList.contains('is-show')) {
                    loginMessage.classList.remove('is-show', 'is-error');
                    loginMessage.innerText = '';
                }
            }

            // 3. 입력 필드에 이벤트 리스너 추가 (타이핑 시 에러 숨김)
            if (idInput) { idInput.addEventListener('input', hideErrorMessage); }
            if (pwInput) { pwInput.addEventListener('input', hideErrorMessage); }

            // AJAX 로그인 전송
            $('#loginForm').on('submit', function(e) {
                e.preventDefault();

                $.ajax({
                    url: '/member/login',
                    type: 'POST',
                    data: $(this).serialize(),
                    // async 키워드 추가
                    success: async function(res) {
                        if (res.status === 'ok') {

                            // Appify 앱 환경일 경우 기기 정보 수집
                            if (typeof appify !== 'undefined' && appify.isWebview) {
                                appify.device.getInfo().then(function(info) {
                                    console.log("📱 Appify Device Info:", info);

                                    // $.post 완료 후 페이지 이동
                                    $.post('/member/device/update', {
                                        platform: info.platform,
                                        model: info.model,
                                        osVersion: info.osVersion,
                                        appVersion: info.appVersion,
                                        uuid: info.uniqueId
                                    }).always(function() {
                                        location.replace(res.redirect);
                                    });
                                }).catch(function(err) {
                                    console.error("기기 정보 수집 실패:", err);
                                    // 실패해도 로그인은 계속 진행
                                    location.replace(res.redirect);
                                });
                            } else {
                                // 웹 브라우저 환경
                                location.replace(res.redirect);
                            }
                        } else {
                            // 로그인 실패 시 에러 메시지 노출
                            $('#loginMessage').text(res.message).addClass('is-show is-error');
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error(error);
                        alert('로그인 처리 중 오류가 발생했습니다.');
                    }
                });
            });
        });

        // 난수(랜덤 문자열) 생성 함수
        function generateRandomString(length) {
            let result = '';
            const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
            for (let i = 0; i < length; i++) {
                result += characters.charAt(Math.floor(Math.random() * characters.length));
            }
            return result;
        }

        // Apple 로그인 연동 함수 추가
        function fn_appleLogin() {
            var clientId = "com.byd.web"; // 개발자 센터에 등록한 Services ID
            var redirectUri = "https://myseungyo.com/member/appleLoginCallback";

            document.getElementById("apple_client_id").value = clientId;
            document.getElementById("apple_redirect_uri").value = redirectUri;

            // 16자리의 랜덤 문자열을 생성하여 state와 nonce에 주입
            document.getElementById("apple_state").value = generateRandomString(16);
            document.getElementById("apple_nonce").value = generateRandomString(16);

            // 폼을 서밋하여 Apple 로그인 서버로 이동
            document.getElementById("appleLoginForm").submit();
        }
    </script>
</body>
</html>