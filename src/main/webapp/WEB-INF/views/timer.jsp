<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <meta name="format-detection" content="telephone=no" />
    <title>BYD 시승 타이머</title>

    <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />
    <script src="https://unpkg.com/swiper@7/swiper-bundle.min.js"></script>

    <link href="/css/reset.css" rel="stylesheet">
    <link href="/css/font.css" rel="stylesheet">
    <link href="/css/style.css" rel="stylesheet">

    <script src="/js/jquery-1.9.1.min.js"></script>
    <script src="https://code.jquery.com/ui/1.13.0/jquery-ui.js"></script>
    <script src="/js/jquery.cookie.min.js"></script>
    <script src="/js/jquery.ui.touch-punch.min.js"></script>
    <script src="/js/script.js"></script>
</head>
<body>

<!-- container -->
<div id="container">

    <!-- check-in -->
    <div class="ck-in timer_wrap">
        <div class="inner">
            <!-- 초기 시간 세팅 -->
            <div class="timer" id="timer">00:00</div>
            <img src="/img/logo.png" alt="logo">
        </div>
    </div>
    <!-- //check-in -->

</div>
<!-- //container -->

<script>
    $(document).ready(function() {
        let startTime = 0;
        let elapsedTime = 0;
        let timerInterval;
        let isRunning = false;

        const timerDisplay = document.getElementById("timer");

        // 시간을 00:00 형태로 포맷팅
        function formatTime(ms) {
            let totalSeconds = Math.floor(ms / 1000);
            let minutes = Math.floor(totalSeconds / 60);
            let seconds = totalSeconds % 60;

            let mDisplay = minutes < 10 ? "0" + minutes : minutes;
            let sDisplay = seconds < 10 ? "0" + seconds : seconds;
            return mDisplay + ":" + sDisplay;
        }

        // 타이머 시작 (또는 재개)
        function startTimer() {
            startTime = Date.now() - elapsedTime;
            timerInterval = setInterval(function() {
                elapsedTime = Date.now() - startTime;
                timerDisplay.innerHTML = formatTime(elapsedTime);
            }, 100); // 0.1초마다 화면 갱신
            isRunning = true;
        }

        // 타이머 정지
        function stopTimer() {
            clearInterval(timerInterval);
            isRunning = false;
        }

        // 시작/정지 토글
        function toggleTimer() {
            if (isRunning) {
                stopTimer();
            } else {
                startTimer();
            }
        }

        // 타이머 초기화 (00:00)
        function resetTimer() {
            stopTimer();
            elapsedTime = 0;
            timerDisplay.innerHTML = "00:00";
        }

        // ==========================================
        // [핵심 로직] 로지텍 스포트라이트 (키보드 이벤트) 매핑
        // ==========================================
        document.addEventListener('keydown', function(event) {

            // 1. 프리젠터 '다음(Next)' 버튼 (기본값: PageDown, 방향키 오른쪽)
            // - 역할: 타이머 시작 / 정지 (토글)
            // - 참고: 스페이스바, 엔터키로도 작동하게 보조 설정
            if (event.key === 'PageDown' || event.key === 'ArrowRight' || event.key === ' ' || event.key === 'Enter') {
                event.preventDefault(); // 스크롤이 내려가는 기본 동작 방지
                toggleTimer();
            }

            // 2. 프리젠터 '이전(Back)' 버튼 (기본값: PageUp, 방향키 왼쪽)
            // - 역할: 타이머 00:00으로 초기화
            // - 참고: 백스페이스(Backspace) 키로도 작동하게 보조 설정
            else if (event.key === 'PageUp' || event.key === 'ArrowLeft' || event.key === 'Backspace') {
                event.preventDefault();
                resetTimer();
            }

        });
    });
</script>

</body>
</html>