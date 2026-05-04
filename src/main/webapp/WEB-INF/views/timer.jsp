<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <meta name="format-detection" content="telephone=no"/>
    <title>BYD 시승 타이머</title>

    <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css"/>
    <script src="https://unpkg.com/swiper@7/swiper-bundle.min.js"></script>

    <link href="/css/reset.css" rel="stylesheet">
    <link href="/css/font.css" rel="stylesheet">
    <link href="/css/style.css" rel="stylesheet">

    <script src="/js/jquery-1.9.1.min.js"></script>
    <script src="https://code.jquery.com/ui/1.13.0/jquery-ui.js"></script>
    <script src="/js/jquery.cookie.min.js"></script>
    <script src="/js/jquery.ui.touch-punch.min.js"></script>
    <script src="/js/script.js"></script>

    <style>
        /* ==========================================
           [수정] 폰트 변경 없이 타이머 흔들림 & 개행 방지
           Flex 레이아웃으로 한 줄에 고정하고 여유 있는 너비를 줍니다.
           ========================================== */
        .timer-display {
            display: flex;
            align-items: center;
            justify-content: center;
            /* Flex 특성상 폭이 좁아도 절대 줄바꿈 되지 않도록 방지 */
            flex-wrap: nowrap;
            white-space: nowrap;
        }

        .digit {
            /* 숫자가 들어가는 칸의 가로 폭을 넉넉하게 고정하여 흔들림 방지 */
            /* LABDigital 폰트 특성에 맞춰 폭을 넓게(0.7em) 설정 */
            display: inline-block;
            width: 0.7em;
            text-align: center;
        }

        .colon {
            /* 콜론(:)이 들어가는 칸의 폭 */
            display: inline-block;
            width: 0.3em;
            text-align: center;
            /* 폰트에 따라 콜론이 너무 아래에 있으면 이 margin-top을 음수로 조절 (-1vw 등) */
            margin-top: -1.5vw;
        }

        /* 우측 하단 조작 가이드 박스 스타일 지정 */
        .guide-box {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background: rgba(0, 0, 0, 0.7);
            color: #fff;
            padding: 20px;
            border-radius: 12px;
            font-size: 14px;
            line-height: 1.6;
            z-index: 1000;
            text-align: left;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(5px);
        }

        .guide-box h4 {
            margin: 0 0 12px 0;
            font-size: 16px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.3);
            padding-bottom: 8px;
            color: #fff;
        }

        .guide-box p {
            margin: 0;
            color: #ddd;
        }

        .guide-box strong {
            color: #009ef7;
            display: inline-block;
            margin-bottom: 3px;
        }

        .guide-box .key-desc {
            padding-left: 8px;
        }
    </style>
</head>
<body>

<!-- container -->
<div id="container">

    <!-- check-in -->
    <div class="ck-in timer_wrap">
        <div class="inner">
            <!-- 기존 timer 클래스 내부에 새로운 Flex 컨테이너 추가 -->
            <div class="timer">
                <div class="timer-display" id="timer">
                    <span class="digit">2</span><span class="digit">0</span><span class="colon">:</span><span
                        class="digit">0</span><span class="digit">0</span>
                </div>
            </div>
            <img src="/img/logo.png" alt="logo">
        </div>
    </div>
    <!-- //check-in -->

</div>
<!-- //container -->

<!-- 우측 하단 조작 가이드 -->
<div class="guide-box">
    <h4>🎮 조작 가이드</h4>
    <p><strong>[시작 / 일시정지]</strong></p>
    <div class="key-desc">
        - 프리젠터 : 다음 (Next) 〉<br>
        - 키보드 : Space, Enter, PageDown, →
    </div>
    <p style="margin-top: 15px;"><strong>[타이머 초기화]</strong></p>
    <div class="key-desc">
        - 프리젠터 : 이전 (Back) 〈<br>
        - 키보드 : Backspace, PageUp, ←
    </div>
</div>

<script>
    $(document).ready(function () {
        const initialTimeMs = 20 * 1000;

        let startTime = 0;
        let elapsedTime = 0;
        let timerInterval;
        let isRunning = false;

        const timerDisplay = document.getElementById("timer");

        // 시간을 구해서 각각의 박스(span)에 담아 리턴하는 함수
        function formatTime(ms) {
            let seconds = Math.floor(ms / 1000);
            let centiseconds = Math.floor((ms % 1000) / 10);

            // 한 자리면 앞에 0 붙이기
            let sDisplay = seconds < 10 ? "0" + seconds : seconds.toString();
            let cDisplay = centiseconds < 10 ? "0" + centiseconds : centiseconds.toString();

            // 숫자를 쪼개서 고정폭 span에 삽입
            return '<span class="digit">' + sDisplay.charAt(0) + '</span>' +
                '<span class="digit">' + sDisplay.charAt(1) + '</span>' +
                '<span class="colon">:</span>' +
                '<span class="digit">' + cDisplay.charAt(0) + '</span>' +
                '<span class="digit">' + cDisplay.charAt(1) + '</span>';
        }

        // 카운트다운 타이머 시작 (또는 재개)
        function startTimer() {
            startTime = Date.now() - elapsedTime;

            // 역동적인 밀리초 렌더링을 위해 0.01초(10ms)마다 화면 갱신
            timerInterval = setInterval(function () {
                elapsedTime = Date.now() - startTime;
                let remainingMs = initialTimeMs - elapsedTime;

                if (remainingMs <= 0) {
                    remainingMs = 0;
                    stopTimer();
                }

                timerDisplay.innerHTML = formatTime(remainingMs);
            }, 10);

            isRunning = true;
        }

        // 타이머 정지
        function stopTimer() {
            clearInterval(timerInterval);
            isRunning = false;
        }

        // 시작/정지 토글
        function toggleTimer() {
            if (elapsedTime >= initialTimeMs) return;

            if (isRunning) {
                stopTimer();
            } else {
                startTimer();
            }
        }

        // 타이머 초기화
        function resetTimer() {
            stopTimer();
            elapsedTime = 0;
            // 초기화 시에도 span 구조를 그대로 삽입
            timerDisplay.innerHTML = '<span class="digit">2</span><span class="digit">0</span><span class="colon">:</span><span class="digit">0</span><span class="digit">0</span>';
        }

        // ==========================================
        // 프리젠터 & 키보드 매핑 로직
        // ==========================================
        document.addEventListener('keydown', function (event) {

            // 시작/일시정지
            if (event.key === 'PageDown' || event.key === 'ArrowRight' || event.key === ' ' || event.key === 'Enter') {
                event.preventDefault();
                toggleTimer();
            }

            // 초기화
            else if (event.key === 'PageUp' || event.key === 'ArrowLeft' || event.key === 'Backspace') {
                event.preventDefault();
                resetTimer();
            }

        });
    });
</script>

</body>
</html>