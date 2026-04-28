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

    <title>계정 찾기 | 승요일기</title>

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
                <div class="login-txt">
                    <h1 class="login_title">계정을 잊으셨나요?<br />가입 시 사용한 정보를 입력해 주세요</h1>
                </div>
            </div>

            <form class="login-form gap-50" id="findIdForm" action="/member/find-id/result" method="post">
                <div class="login-field_wrap gap-16">
                    <div class="login-field">
                        <label class="login-label">생년월일</label>
                        <div class="dob-wrap">
                            <div class="dob-picker" id="picker">
                                <div class="dob-picker_value" id="dobValue" style="color: #999;">생년월일 선택</div>
                            </div>
                            <input type="hidden" name="birthdate" id="birthdateInput">
                        </div>
                    </div>

                    <div class="login-field">
                        <label class="login-label">휴대폰 번호</label>
                        <input class="login-input" id="phoneNumber" name="phoneNumber" type="tel" placeholder="- 없이 숫자만 입력" required>
                    </div>
                </div>

                <div class="login-bottom">
                    <div class="login-actions">
                        <button class="join-btn btn-primary" type="submit" id="submitBtn">
                            아이디 찾기
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <div class="dob-wrap_pop" id="dobPopup">
        <div class="dob-pop-dim"></div>
        <div class="dob-pop-inner">
            <div class="dob-pop-picker">
                <div class="dob-pop-wheel" data-type="year"></div>
                <div class="dob-pop-wheel" data-type="month"></div>
                <div class="dob-pop-wheel" data-type="day"></div>
            </div>
            <div class="dob-pop-footer">
                <button type="button" class="btn-cancel" id="pickerCancel">취소</button>
                <button type="button" class="btn-apply" id="pickerApply">적용</button>
            </div>
        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/date-picker.js"></script>
    <script src="/js/app_interface.js"></script>
    <script>
        // [JS] 선택된 날짜를 히든 인풋에 바인딩하는 로직 보완
        document.addEventListener('DOMContentLoaded', () => {
            const applyBtn = document.getElementById('pickerApply');
            const cancelBtn = document.getElementById('pickerCancel');
            const popup = document.getElementById('dobPopup');
            const dobValueDiv = document.getElementById('dobValue');
            const hiddenInput = document.getElementById('birthdateInput');

            // '적용' 버튼 클릭 시 date-picker.js 내부 로직에 의해 값은 선택되지만,
            // 화면 표시와 hidden input 값 업데이트를 명시적으로 처리해야 할 수 있습니다.
            // date-picker.js의 구현 내용에 따라 자동 처리될 수도 있으나, 안전하게 이벤트 리스너 추가.

            if(applyBtn) {
                applyBtn.addEventListener('click', () => {
                    // date-picker.js가 .selected 클래스를 가진 항목들의 data-value를 가져오도록 가정
                    // 실제 date-picker.js 로직에 따라 다르지만, 일반적으로 선택된 값을 조합합니다.

                    const year = document.querySelector('.dob-pop-wheel[data-type="year"] .is-selected')?.dataset.value;
                    const month = document.querySelector('.dob-pop-wheel[data-type="month"] .is-selected')?.dataset.value;
                    const day = document.querySelector('.dob-pop-wheel[data-type="day"] .is-selected')?.dataset.value;

                    if (year && month && day) {
                        // 1. 화면 표시 (텍스트 색상 변경)
                        const fullDateStr = year + '.' + month.padStart(2, '0') + '.' + day.padStart(2, '0');
                        dobValueDiv.textContent = fullDateStr;
                        dobValueDiv.style.color = '#000'; // 선택 후 검정색

                        // 2. 서버 전송값 설정 (YYYY-MM-DD)
                        hiddenInput.value = year + '-' + month.padStart(2, '0') + '-' + day.padStart(2, '0');

                        // 팝업 닫기 (date-picker.js에 닫기 로직이 있다면 중복될 수 있으나 안전장치)
                        popup.classList.remove('is-open');
                    }
                });
            }

            // '취소' 및 딤 영역 클릭 닫기
            if(cancelBtn) {
                cancelBtn.addEventListener('click', () => {
                    popup.classList.remove('is-open');
                });
            }

            // 폼 전송 전 유효성 검사
            document.getElementById('findIdForm').addEventListener('submit', function(e) {
                if(!hiddenInput.value) {
                    e.preventDefault();
                    alert('생년월일을 선택해주세요.');
                }
            });
        });
    </script>
</body>
</html>