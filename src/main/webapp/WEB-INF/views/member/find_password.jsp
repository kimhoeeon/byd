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

    <title>비밀번호 찾기 | 승요일기</title>

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
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
                <div class="tit">비밀번호가 기억나지 않나요?</div>
            </div>

            <form class="login-form" action="/member/find-password/reset" method="post" id="resetForm">
                <div class="login-field_wrap">

                    <div class="login-field">
                        <div class="gu">아이디(이메일)</div>
                        <div class="login-inputwrap">
                            <input class="login-input" id="memberId" name="memberId" type="email"
                                   placeholder="아이디(이메일)을 입력해주세요" required value="${param.memberId}">
                        </div>
                    </div>

                    <div class="login-field">
                        <div class="gu">휴대폰 번호</div>
                        <div class="login-inputwrap phone-field">
                            <div class="phone">
                                <input class="login-input" id="phoneNumber" name="phoneNumber" type="tel"
                                    maxlength="13"
                                    inputmode="numeric" autocomplete="tel" placeholder="휴대폰 번호를 입력해주세요"
                                    required value="${param.phoneNumber}">
                                <button type="button" class="phone-cert wpx-80" id="sendBtn" onclick="sendSms()">
                                    인증하기
                                </button>
                            </div>
                        </div>

                        <div class="auth_number mt-8" id="authBox" style="display:none;">
                            <div class="login-inputwrap">
                                <input class="login-input" id="authCode" name="authCode" type="number" maxlength="6"
                                       inputmode="numeric" autocomplete="one-time-code" placeholder="인증번호를 입력해주세요" required>

                                <span class="field-check-icon" id="certCheckIcon" style="display:none;">
                                    <img src="/img/ico_field_check.svg" alt="입력 완료">
                                </span>
                            </div>
                        </div>

                        <c:if test="${not empty error}">
                            <div class="login-message is-show is-error mt-8">
                                ${error}
                            </div>
                        </c:if>

                        <button class="login-btn btn-primary mt-16" type="submit" id="submitBtn">
                            비밀번호 초기화
                        </button>
                    </div>
                </div>

                <div class="login-bottom">
                    <div class="login-options mt-24 center">
                        <p>휴대폰 번호가 변경되었나요?</p>
                        <a class="login-link" href="#" onclick="alert('고객센터로 문의해 주세요.'); return false;">고객센터 문의</a>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>

    <c:if test="${isKakao}">
        <script>
            $(document).ready(function() {
                // 커스텀 알럿 호출 (확인 클릭 시 콜백 함수 실행)
                alert('카카오 계정으로 로그인해 주세요.', function() {
                    location.replace('/member/login');
                });
            });
        </script>
    </c:if>

    <script>

        $(document).ready(function() {
            // 휴대폰 번호 입력 시 자동 하이픈 (-) 추가
            $('#phoneNumber').on('input', function() {
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
            });
        });

        // 1. SMS 인증번호 발송
        function sendSms() {
            const memberId = $('#memberId').val().trim();
            const rawPhone = $('#phoneNumber').val().trim();
            const phone = rawPhone.replace(/-/g, '');

            if(!memberId) { alert('아이디(이메일)을 입력해주세요.'); return; }
            if(phone.length < 10) { alert('올바른 휴대폰 번호를 입력해주세요.'); return; }

            $('#sendBtn').prop('disabled', true).text('전송중');

            $.post('/member/send-sms', {
                memberId: memberId,
                phoneNumber: phone,
                type: 'FIND_PW'
            }, function(res) {
                const result = res.trim();

                // 백엔드 검증 결과에 따른 세밀한 분기 처리
                if(result === 'not_found') {
                    alert('가입된 아이디(이메일)와 일치하는 연락처가 아닙니다.');
                    $('#sendBtn').text('인증하기').prop('disabled', false);
                } else if(result === 'is_kakao') {
                    alert('카카오로 가입된 계정입니다. 카카오 로그인을 이용해 주세요.');
                    $('#sendBtn').text('인증하기').prop('disabled', false);
                } else if(result.startsWith('fail')) {
                    alert('SMS 발송에 실패했습니다. 잠시 후 다시 시도해 주세요.');
                    $('#sendBtn').text('인증하기').prop('disabled', false);
                } else {
                    alert('인증번호가 발송되었습니다.');

                    // 재전송 시 입력칸 초기화
                    $('#authCode').val('');
                    $('#certCheckIcon').hide();

                    $('#authBox').slideDown();
                    $('#sendBtn').text('재전송').prop('disabled', false);
                    $('#authCode').focus();
                }
            }).fail(function() {
                alert('서버 통신 중 오류가 발생했습니다.');
                $('#sendBtn').text('인증하기').prop('disabled', false);
            });
        }

        // 2. 인증번호 입력 감지
        $('#authCode').on('input', function() {
            if (this.value.length === 6) {
                $('#certCheckIcon').show();
            } else {
                $('#certCheckIcon').hide();
            }
        });

        // 3. 폼 제출 검증
        $('#resetForm').on('submit', function(e) {
            if ($('#authBox').css('display') === 'none') {
                e.preventDefault();
                alert('휴대폰 인증을 진행해주세요.');
                return false;
            }
            if ($('#authCode').val().length < 4) {
                e.preventDefault();
                alert('인증번호를 올바르게 입력해주세요.');
                return false;
            }
        });
    </script>
</body>
</html>