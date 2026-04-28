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

    <title>휴대폰 인증 | 승요일기</title>

    <style>
        /* Chrome, Safari, Edge, Opera */
        input[type=number]::-webkit-outer-spin-button,
        input[type=number]::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

        /* Firefox */
        input[type=number] {
            -moz-appearance: textfield;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        if (!sessionStorage.getItem('join_birth')) {
            alert('이전 단계가 완료되지 않았습니다.');
            location.replace('/member/join/step4');
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
                    <h1 class="login_title">휴대폰 번호를 입력해 주세요</h1>
                </div>
            </div>

            <div class="login-form gap-50">
                <div class="login-field_wrap gap-16">
                    <div class="login-field">
                        <div class="login-inputwrap">
                            <div class="phone">
                                <input type="tel" class="login-input pr-8" id="number" placeholder="휴대폰 번호 입력 ('-' 없이 입력)" maxlength="13" required>
                                <button type="button" class="phone-cert wpx-80 btn_disabled" id="sendBtn" onclick="sendSms()" disabled>
                                    인증하기
                                </button>
                            </div>
                            <div class="auth_number mt-8" id="authBox" style="display:none;">
                                <input class="login-input" id="number_cert" type="number" placeholder="인증번호를 입력해주세요" required>

                                <span class="field-check-icon" id="certCheckIcon">
                                        <img src="/img/ico_field_check.svg" alt="입력 완료">
                                    </span>
                                <span class="field-field-icon" id="certFailIcon">
                                        <img src="/img/ico_field_fail.svg" alt="실패">
                                    </span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="login-bottom">
                    <div class="login-actions">
                        <button class="join-btn btn-primary" id="termsNext" disabled onclick="verifySms()">
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

        $(document).ready(function() {
            // [기능 1] 휴대폰 번호 입력 시 자동 하이픈 (-) 추가
            $('#number').on('input', function() {
                let number = $(this).val().replace(/[^0-9]/g, ''); // 숫자만 남김
                let phone = '';

                if (number.length < 4) {
                    phone = number;
                } else if (number.length < 7) {
                    phone = number.substr(0, 3) + '-' + number.substr(3);
                } else if (number.length < 11) {
                    phone = number.substr(0, 3) + '-' + number.substr(3, 3) + '-' + number.substr(6);
                } else {
                    phone = number.substr(0, 3) + '-' + number.substr(3, 4) + '-' + number.substr(7);
                }

                $(this).val(phone);

                // [추가된 부분] 숫자 길이가 10자리 이상이면 '인증하기' 버튼 활성화
                if (number.length >= 10) {
                    $('#sendBtn').removeClass('btn_disabled').removeAttr('disabled');
                } else {
                    $('#sendBtn').addClass('btn_disabled').attr('disabled', true);
                }
            });
        });

        function sendSms() {
            // [기능 2] 하이픈 제거 및 유효성 검증
            const rawPhone = $('#number').val();
            const phone = rawPhone.replace(/-/g, ''); // 하이픈 제거

            // 정규식: 01로 시작하는 10~11자리 숫자
            const regPhone = /^01([0|1|6|7|8|9])([0-9]{3,4})([0-9]{4})$/;

            if (phone.length < 10 || !regPhone.test(phone)) {
                alert('올바른 휴대폰 번호를 입력해주세요.');
                $('#number').focus();
                return;
            }

            $.post('/member/send-sms', {
                phoneNumber: phone,
                type: 'JOIN'
            }, function(res) {
                if(res === 'ok') {
                    alert('인증번호가 발송되었습니다.');
                    $('#authBox').show();
                    $('#sendBtn').text('재전송');
                    $('#number_cert').focus();
                } else if(res === 'duplicate_phone') {
                    // 중복 연락처인 경우 알럿 띄우고 발송 중단
                    alert('이미 가입된 연락처입니다.\n로그인이나 비밀번호 찾기를 이용해 주세요.');
                } else if(res === 'suspended') {
                    // 영구 정지된 계정의 연락처인 경우
                    alert('운영정책 위반으로 영구 정지된 연락처이므로 가입할 수 없습니다.');
                } else if(res === 'withdrawn_7days') {
                    // 탈퇴 후 7일이 지나지 않은 경우
                    alert('탈퇴 후 7일간은 동일한 연락처로 재가입할 수 없습니다.');
                } else {
                    // 기타 실패 시 (발송 건수 초과 등) 페이지 이동
                    location.href = '/member/sms/fail?msg=' + encodeURIComponent(res);
                }
            }).fail(function() {
                // 네트워크 오류 등 아예 통신 실패 시에도 이동
                location.href = '/member/sms/fail?msg=' + encodeURIComponent('서버 통신 오류가 발생했습니다.');
            });
        }

        function verifySms() {
            // 전송 시 하이픈이 제거된 값을 사용해야 하므로 다시 추출
            const phone = $('#number').val().replace(/-/g, '');
            const code = $('#number_cert').val();

            if(code.length < 1) {
                alert('인증번호를 입력해주세요.');
                return;
            }

            $.post('/member/verify-sms', { phoneNumber: phone, authCode: code }, function(res) {
                if(res === 'ok') {
                    sessionStorage.setItem('join_phone', phone);
                    location.href = '/member/join/step6';
                } else {
                    alert('인증번호가 일치하지 않습니다.');
                    // 실패 시 실패 아이콘 노출
                    $('#certFailIcon').addClass('is-show');
                    // 혹시 체크 아이콘이 떠있다면 숨김 처리
                    $('#certCheckIcon').removeClass('is-show');
                }
            });
        }

        // [기능 3] 인증번호 입력 시 다음 버튼 활성화 (ID 수정: nextBtn -> termsNext)
        $('#number_cert').on('input', function() {
            //  입력 시작 시 실패 아이콘 숨김 (겹침 방지)
            $('#certFailIcon').removeClass('is-show');

            // 입력값이 있으면 버튼 활성화, 없으면 비활성화
            if(this.value.length >= 4) { // 보통 인증번호는 4자리 이상이므로 조건 유지
                $('#termsNext').prop('disabled', false);
            } else {
                $('#termsNext').prop('disabled', true);
            }
        });
    </script>
</body>
</html>