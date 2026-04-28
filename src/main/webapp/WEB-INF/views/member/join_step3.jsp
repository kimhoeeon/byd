<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

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

    <title>비밀번호 입력 | 승요일기</title>

    <style>
        /* 애플 심사 대응: 레이아웃 틀어짐 방지를 위해 opacity 사용 */
        body { opacity: 0; transition: opacity 0.2s ease-in-out; }
    </style>

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        const joinProvider = sessionStorage.getItem('join_provider');

        // 소셜 사용자 접근 차단
        if (joinProvider && (joinProvider === 'KAKAO' || joinProvider === 'APPLE')) {
            location.replace('/member/join/step4');
        } else if (!sessionStorage.getItem('join_email')) {
            alert('이전 단계가 완료되지 않았습니다.');
            location.replace('/member/join/step2');
        } else {
            // 일반 가입자인 경우에만 body 노출
            document.addEventListener("DOMContentLoaded", function() {
                document.body.style.opacity = "1";
            });
        }
    </script>
</head>
<body class="page-login">

    <header class="app-header">
        <button class="app-header_btn app-header_back" type="button" onclick="history.back()">
            <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
        </button>
    </header>

    <div class="page-login_wrap">
        <div class="login-card">
            <div class="login">
                <img src="/img/ico_check.svg" alt="체크이미지">
                <div class="login-txt">
                    <h1 class="login_title">비밀번호를 입력해 주세요</h1>
                    <p class="login_desc">영문, 숫자, 특수문자 포함 8~14자리</p>
                </div>
            </div>

            <div class="login-form gap-50">
                <div class="login-field_wrap">
                    <div class="login-field">
                        <div class="login-inputwrap">
                            <input class="login-input" id="loginPw" type="password" autocomplete="new-password" placeholder="비밀번호" required/>
                            <button class="login-eye" type="button" id="togglePw" aria-label="비밀번호 표시">
                                <img src="/img/pass_off.svg" alt="비밀번호 보기">
                            </button>
                        </div>
                    </div>
                    <div class="login-field login-field-check">
                        <div class="login-inputwrap">
                            <input class="login-input" id="loginPwConfirm" type="password" autocomplete="new-password" placeholder="비밀번호를 한번 더 입력해 주세요" required/>
                            <button class="login-eye" type="button" id="togglePwCheck" aria-label="비밀번호 표시">
                                <img src="/img/pass_off.svg" alt="비밀번호 보기">
                            </button>
                        </div>
                        <div class="login-message" id="pwMessage" role="status"></div>
                        <ul class="word">
                            <li>* 영문, 숫자, 특수문자 중 2종 이상 조합 (8~14자)</li>
                            <li>* 사용 가능 특수문자: ! @ # $ % ^ & * - _ ?</li>
                        </ul>
                    </div>
                </div>
                <div class="login-bottom">
                    <div class="login-actions">
                        <button class="join-btn btn-primary" id="termsNext" disabled onclick="goNext()">
                            다음
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
    <script>
        const pw = document.getElementById('loginPw');
        const pwConfirm = document.getElementById('loginPwConfirm');
        const nextBtn = document.getElementById('termsNext');
        const msg = document.getElementById('pwMessage');

        function checkPw() {
            // 정규식 업데이트: 물음표(?) 추가 허용
            // 정규식 설명: 영문/숫자/특수문자(!@#$%^&*-_?) 중 하나로만 구성되지 않음(즉 2종 이상) AND 8~14자
            const reg = /^(?!((?:[A-Za-z]+)|(?:[!@#$%^&*_\-?]+)|(?:[0-9]+))$)[A-Za-z\d!@#$%^&*_\-?]{8,14}$/;

            if(!reg.test(pw.value)) {
                msg.textContent = '비밀번호 규칙에 맞지 않습니다.';
                msg.classList.add('is-show', 'is-error');
                nextBtn.disabled = true;
                return;
            }
            if(pw.value !== pwConfirm.value) {
                msg.textContent = '비밀번호가 일치하지 않습니다.';
                msg.classList.add('is-show', 'is-error');
                nextBtn.disabled = true;
            } else {
                msg.textContent = '';
                msg.classList.remove('is-show', 'is-error');
                nextBtn.disabled = false;
            }
        }

        pw.addEventListener('input', checkPw);
        pwConfirm.addEventListener('input', checkPw);

        function goNext() {
            sessionStorage.setItem('join_pw', pw.value);
            location.href = '/member/join/step4';
        }
    </script>
</body>
</html>