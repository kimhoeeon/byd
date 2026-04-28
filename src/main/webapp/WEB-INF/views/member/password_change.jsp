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

    <title>비밀번호 변경 | 승요일기</title>

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
</head>

<body>
    <div class="app">

        <header class="app-header">
            <button class="app-header_btn app-header_back" type="button" onclick="history.back()">
                <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
            </button>
        </header>

        <div class="app-main">

            <div class="app-tit">
                <div class="page-tit">비밀번호 변경</div>
            </div>

            <form id="pwChangeForm" onsubmit="return false;">
                <div class="stack mt-24">

                    <div class="password_info">
                        <div class="password-info_item">
                            <div class="gu">기존 비밀번호</div>
                            <div class="nae">
                                <div class="input">
                                    <input type="password" name="currentPassword" id="currentPassword" placeholder="기존 비밀번호를 입력해 주세요." required>
                                    <button class="login-eye" type="button" id="togglePwBasic" aria-label="비밀번호 표시">
                                        <img src="/img/pass_off.svg" alt="비밀번호 보기">
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="password-info_item mt-24">
                            <div class="gu">변경할 비밀번호</div>
                            <div class="nae">
                                <div class="input">
                                    <input type="password" name="newPassword" id="newPassword" placeholder="변경할 비밀번호를 입력해 주세요." required>
                                    <button class="login-eye" type="button" id="toggleNewPwBasic" aria-label="비밀번호 표시">
                                        <img src="/img/pass_off.svg" alt="비밀번호 보기">
                                    </button>
                                </div>
                            </div>
                            <div class="nae">
                                <div class="input">
                                    <input type="password" id="confirmPassword" placeholder="변경할 비밀번호를 한번 더 입력해 주세요." required>
                                    <button class="login-eye" type="button" id="toggleConfPwBasic" aria-label="비밀번호 표시">
                                        <img src="/img/pass_off.svg" alt="비밀번호 보기">
                                    </button>
                                </div>
                                <div class="input-msg is-error" id="pwMatchMsg" style="display:none; margin-top:5px; font-size:12px; color: #FF0000;">
                                    비밀번호가 일치하지 않습니다.
                                </div>
                            </div>
                        </div>

                        <ul class="pre">
                            <li>* 영문, 숫자, 특수문자(!@#$%^&*-_?) 중 2종 이상 조합 (8~14자)</li>
                            <li>* 비밀번호를 변경하면, 로그인된 모든 디바이스에서 자동으로 로그아웃돼요</li>
                        </ul>

                    </div>

                </div>
            </form>
        </div>
    </div>

    <div class="bottom-action bottom-main">
        <button type="button" class="btn btn-primary" id="submitBtn" disabled onclick="submitForm()">변경 완료</button>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
    <script>
        const currentPw = document.getElementById('currentPassword');
        const newPw = document.getElementById('newPassword');
        const confirmPw = document.getElementById('confirmPassword');
        const submitBtn = document.getElementById('submitBtn');
        const pwMatchMsg = document.getElementById('pwMatchMsg');

        // [입력 감지]
        [currentPw, newPw, confirmPw].forEach(el => {
            el.addEventListener('input', validateForm);
        });

        function validateForm() {
            const isCurrentFilled = currentPw.value.length > 0;
            const isNewFilled = newPw.value.length > 0;
            const isConfirmFilled = confirmPw.value.length > 0;

            if (isNewFilled && isConfirmFilled) {
                if (newPw.value !== confirmPw.value) {
                    pwMatchMsg.style.display = 'block';
                    submitBtn.disabled = true;
                    return;
                } else {
                    pwMatchMsg.style.display = 'none';
                }
            } else {
                pwMatchMsg.style.display = 'none';
            }

            if (isCurrentFilled && isNewFilled && isConfirmFilled && (newPw.value === confirmPw.value)) {
                submitBtn.disabled = false;
            } else {
                submitBtn.disabled = true;
            }
        }

        // [제출]
        function submitForm() {
            const currentVal = currentPw.value;
            const newVal = newPw.value;

            if (!currentVal) { alert('기존 비밀번호를 입력해주세요.'); return; }
            if (currentVal === newVal) { alert('기존 비밀번호와 다른 비밀번호를 입력해주세요.'); return; }

            const regExp = /^(?!((?:[A-Za-z]+)|(?:[!@#$%^&*_\-?]+)|(?:[0-9]+))$)[A-Za-z\d!@#$%^&*_\-?]{8,14}$/;
            if (!regExp.test(newVal)) {
                alert('비밀번호는 영문, 숫자, 특수문자(!@#$%^&*-_?) 중 2종 이상을 조합하여 8~14자로 입력해주세요.');
                return;
            }

            //console.log("[Client] 비밀번호 변경 요청 전송");

            $.ajax({
                type: 'POST',
                url: '/member/update/password',
                data: {
                    currentPassword: currentVal,
                    newPassword: newVal
                },
                dataType: 'text',
                success: function(res) {
                    //console.log("[Client] 응답 수신:", res);

                    if (res && res.trim() === 'ok') {
                        // 성공 시 공통 팝업(alert) 띄우고 확인 클릭 시 로그인 페이지로 이동
                        alert('비밀번호 변경이 완료되었습니다.<br>다시 로그인해주세요.', function() {
                            location.replace('/member/login');
                        });
                    } else {
                        // 실패 시 에러 메시지 팝업
                        alert(res);
                    }
                },
                error: function(xhr, status, error) {
                    console.error("[Client] AJAX Error:", status, error);
                    alert('서버 통신 중 오류가 발생했습니다.');
                }
            });
        }
    </script>
</body>
</html>