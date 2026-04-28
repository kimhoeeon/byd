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

    <title>생년월일 입력 | 승요일기</title>

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        const joinProvider = sessionStorage.getItem('join_provider');
        const isSocial = joinProvider && (joinProvider === 'KAKAO' || joinProvider === 'APPLE');

        // 소셜 가입자(카카오, 애플)는 비밀번호 입력을 건너뛰므로 예외 처리
        if (!isSocial && !sessionStorage.getItem('join_pw')) {
            alert('이전 단계가 완료되지 않았습니다.');
            location.replace('/member/join/step3');
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
                    <h1 class="login_title">생년월일을 입력해 주세요</h1>
                </div>
            </div>

            <div class="login-form gap-50">
                <div class="login-field_wrap">
                    <%--<div class="dob-wrap">
                        <div class="dob-picker" id="picker">
                            <div class="dob-picker_value" id="dobValue" style="color: #999;">YYYY.MM.DD</div>
                        </div>
                        <input type="hidden" id="birthdateInput">
                    </div>--%>

                        <div class="login-date">
                            <select name="birth_year" id="birthYear" class="birth_select">
                                <option value="">연</option>
                            </select>

                            <select name="birth_month" id="birthMonth" class="birth_select">
                                <option value="">월</option>
                                <option value="1">1월</option>
                                <option value="2">2월</option>
                                <option value="3">3월</option>
                                <option value="4">4월</option>
                                <option value="5">5월</option>
                                <option value="6">6월</option>
                                <option value="7">7월</option>
                                <option value="8">8월</option>
                                <option value="9">9월</option>
                                <option value="10">10월</option>
                                <option value="11">11월</option>
                                <option value="12">12월</option>
                            </select>

                            <select name="birth_day" id="birthDay" class="birth_select">
                                <option value="">일</option>
                            </select>
                        </div>

                    <ul class="word">
                        <li>* 만 14세 이상 가입 가능합니다.</li>
                    </ul>
                </div>
                <div class="login-bottom">
                    <button class="join-btn btn-primary" id="nextBtn" disabled onclick="goNext()">
                        다음
                    </button>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const yearSelect = document.getElementById('birthYear');
            const monthSelect = document.getElementById('birthMonth');
            const daySelect = document.getElementById('birthDay');
            const nextBtn = document.getElementById('nextBtn');

            // 1. 연도 동적 생성 (현재 연도부터 1920년까지)
            const currentYear = new Date().getFullYear();
            for (let i = currentYear; i >= 1920; i--) {
                let option = document.createElement('option');
                option.value = i;
                option.text = i + '년';
                yearSelect.appendChild(option);
            }

            // 2. 월/연도 선택에 따른 '일(Day)' 동적 생성 (윤년 등 계산)
            function updateDays() {
                const y = yearSelect.value;
                const m = monthSelect.value;
                const currentDay = daySelect.value; // 기존에 선택된 일 유지용

                daySelect.innerHTML = '<option value="">일</option>'; // 초기화

                if (y && m) {
                    // 선택한 연/월에 해당하는 마지막 일수 계산
                    const daysInMonth = new Date(y, m, 0).getDate();
                    for (let i = 1; i <= daysInMonth; i++) {
                        let option = document.createElement('option');
                        option.value = i;
                        option.text = i + '일';
                        daySelect.appendChild(option);
                    }
                    // 월이 바뀌었을 때 선택했던 '일'이 새 월의 일수 범위 내에 있으면 유지
                    if (currentDay && currentDay <= daysInMonth) {
                        daySelect.value = currentDay;
                    }
                }
                checkValidity();
            }

            yearSelect.addEventListener('change', updateDays);
            monthSelect.addEventListener('change', updateDays);
            daySelect.addEventListener('change', checkValidity);

            // 3. 값 입력 여부 확인하여 '다음' 버튼 활성화
            function checkValidity() {
                if (yearSelect.value && monthSelect.value && daySelect.value) {
                    nextBtn.disabled = false;
                } else {
                    nextBtn.disabled = true;
                }
            }

            // 4. 기존 저장된 값이 있다면 불러오기 (뒤로가기 시 데이터 유지)
            const savedBirth = sessionStorage.getItem('join_birth');
            if (savedBirth) {
                const parts = savedBirth.split('-'); // YYYY-MM-DD 파싱
                if (parts.length === 3) {
                    yearSelect.value = parseInt(parts[0], 10);
                    monthSelect.value = parseInt(parts[1], 10);
                    updateDays(); // 연/월 세팅 후 해당 월의 일수 목록 생성
                    daySelect.value = parseInt(parts[2], 10);
                    checkValidity();
                }
            }
        });

        // 5. 만 14세 이상 체크 함수
        function isOver14(year, month, day) {
            const today = new Date();
            const birthDate = new Date(year, month - 1, day);
            let age = today.getFullYear() - birthDate.getFullYear();
            const mDiff = today.getMonth() - birthDate.getMonth();

            // 아직 생일이 지나지 않았으면 1살 빼기
            if (mDiff < 0 || (mDiff === 0 && today.getDate() < birthDate.getDate())) {
                age--;
            }
            return age >= 14;
        }

        // 6. 다음 단계 이동 함수
        function goNext() {
            const y = document.getElementById('birthYear').value;
            const m = document.getElementById('birthMonth').value;
            const d = document.getElementById('birthDay').value;

            if (!y || !m || !d) {
                alert('생년월일을 모두 선택해주세요.');
                return;
            }

            // 만 14세 이상 검증 로직 반영
            if (!isOver14(y, m, d)) {
                alert('만 14세 이상만 가입 가능합니다.');
                return;
            }

            // 포맷 맞추기: YYYY-MM-DD
            const formattedMonth = m.padStart(2, '0');
            const formattedDay = d.padStart(2, '0');
            const birthValue = `${y}-${formattedMonth}-${formattedDay}`;

            // 세션 스토리지에 저장 후 이동
            sessionStorage.setItem('join_birth', birthValue);
            location.href = '/member/join/step5';
        }
    </script>
</body>
</html>