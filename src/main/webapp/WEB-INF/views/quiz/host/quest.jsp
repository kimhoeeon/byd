<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover"/>
    <meta name="format-detection" content="telephone=no,email=no,address=no"/>
    <meta name="apple-mobile-web-app-capable" content="yes"/>
    <meta name="mobile-web-app-capable" content="yes"/>

    <meta property="og:type" content="website">
    <meta property="og:locale" content="ko_KR">
    <meta property="og:site_name" content="BYD">

    <!-- swiper 외부 라이브러리 -->
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

    <title>BYD 퀴즈 이벤트</title>

</head>

<body class="host">

    <!-- container -->
    <div id="container">

        <!-- check-in -->
        <div class="ck-in center">
            <!-- title -->
            <div class="top_tit">
                <div class="inner">
                    <div class="tit">
                        <a href="/quiz/host/main">
                            <img src="/img/logo.png" alt="logo">
                        </a>
                    </div>
                </div>
            </div>
            <!-- //title -->

            <div class="bar">
                <div class="tit">BYD <span>퀴즈 이벤트</span></div>
                <div class="quiz_progress">
                    <div class="progress_item"></div>
                    <div class="progress_item"></div>
                    <div class="progress_item"></div>
                    <div class="progress_item"></div>
                    <div class="progress_item"></div>
                    <div class="progress_item"></div>
                    <div class="progress_item"></div>
                    <div class="progress_item"></div>
                    <div class="progress_item"></div>
                    <div class="progress_item"></div>
                </div>
            </div>

            <!-- info -->
            <div id="content">
                <div class="ct_wrap quiz_wrap">
                    <div class="quiz_a">
                        <div class="numb">1</div>
                        <div class="ask">문제를 로딩 중입니다...</div>
                    </div>
                    <div class="quiz_q">
                        <!-- 타이머 -->
                        <div class="time_box">
                            <div class="timerBox">
                                <div id="timer"><span id="timer_label">10</span></div>
                            </div>
                        </div>

                        <!-- 객관식 -->
                        <div class="multi">
                            <div class="btn_multi">
                                <input type="radio" id="choice1" name="choice" value="1" disabled>
                                <label for="choice1">1번</label>
                            </div>
                            <div class="btn_multi">
                                <input type="radio" id="choice2" name="choice" value="2" disabled>
                                <label for="choice2">2번</label>
                            </div>
                            <div class="btn_multi">
                                <input type="radio" id="choice3" name="choice" value="3" disabled>
                                <label for="choice3">3번</label>
                            </div>
                            <div class="btn_multi">
                                <input type="radio" id="choice4" name="choice" value="4" disabled>
                                <label for="choice4">4번</label>
                            </div>
                        </div>
                        <!-- //객관식 -->
                    </div>
                    <div class="btn_box">
                        <a href="javascript:void(0);" id="btnClicker" class="btn_st05">문제 시작 대기 중...</a>
                    </div>
                </div>
            </div>
            <!-- //info -->

        </div>
        <!-- //check-in -->

    </div>
    <!-- //container -->

    <script>
        const urlParams = new URLSearchParams(window.location.search);
        const sessionNo = urlParams.get('sessionNo');
        const playDate = getTodayStr();

        let questions = [];
        let currentQIndex = 0;
        let timer = 10;
        let countdownInterval;

        const STATE = {
            READY: 'READY',             // 문제 띄워놓고 10초 시작 전 대기
            PLAYING: 'PLAYING',         // 10초 카운트다운 시작
            SHOW_ANSWER: 'SHOW_ANSWER'  // 정답 공개
        };
        let currentState = STATE.READY;

        function getTodayStr() {
            const d = new Date();
            return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
        }

        $(document).ready(function () {
            // 1. 문제 로드
            $.ajax({
                url: '/api/quiz/live/host/questions',
                type: 'GET',
                data: {playDate: playDate, sessionNo: sessionNo},
                success: function (res) {
                    if (res.success && res.questions.length > 0) {
                        questions = res.questions;
                        loadQuestionUI();
                        updateServerState(STATE.READY);
                    } else {
                        alert("문제를 불러올 수 없습니다. 회차를 초기화해주세요.");
                        location.href = '/quiz/host/main';
                    }
                }
            });

            // 2. 클리커(Clicker) 제어 로직
            $('#btnClicker').on('click', function () {
                if ($(this).css('pointer-events') === 'none') return; // 비활성화 방어

                if (currentState === STATE.READY) {
                    // [동작 1. 문제 풀이 시작]
                    currentState = STATE.PLAYING;
                    updateServerState(STATE.PLAYING);
                    startTimer();

                    // CSS 클래스 대신 직관적인 제어
                    $(this).text('10초 카운트다운 진행중...').css({'opacity': '0.5', 'pointer-events': 'none'});

                } else if (currentState === STATE.PLAYING) {
                    // [동작 2. 정답 공개] (타이머가 0이 되어 클릭이 허용된 상태)
                    currentState = STATE.SHOW_ANSWER;
                    updateServerState(STATE.SHOW_ANSWER);
                    showCorrectAnswer();

                    const isLast = (currentQIndex === questions.length - 1);
                    $(this).text(isLast ? '결과 보기 페이지로 이동' : '다음 문제 준비하기');

                } else if (currentState === STATE.SHOW_ANSWER) {
                    // [동작 3. 다음 문제 준비 또는 퀴즈 종료]
                    const isLast = (currentQIndex === questions.length - 1);
                    if (isLast) {
                        updateServerState('ENDED');
                        location.href = '/quiz/host/end';
                    } else {
                        currentQIndex++;
                        loadQuestionUI();

                        currentState = STATE.READY;
                        updateServerState(STATE.READY);
                    }
                }
            });
        });

        function loadQuestionUI() {
            const q = questions[currentQIndex];
            $('.quiz_a .numb').text(currentQIndex + 1);
            $('.quiz_a .ask').text(q.questionText);

            const labels = $('.quiz_q .btn_multi label');
            $(labels[0]).text(q.choice1);
            $(labels[1]).text(q.choice2);
            $(labels[2]).text(q.choice3);
            $(labels[3]).text(q.choice4);

            // 기존에 켜져있던 정답 체크 박스 모두 초기화 (style.css 자동 반영 해제)
            $('input[name="choice"]').prop('checked', false);

            $('#timer_label').text('10');

            // 버튼 상태 원상복구
            $('#btnClicker').text('현재 문제 시작 (클릭)').css({'opacity': '1', 'pointer-events': 'auto'});

            $('.quiz_progress .progress_item').removeClass('on').eq(currentQIndex).addClass('on');
        }

        function updateServerState(status) {
            $.ajax({
                url: '/api/quiz/live/host/control',
                type: 'POST',
                data: {
                    playDate: playDate,
                    sessionNo: sessionNo,
                    targetQuestionNo: currentQIndex + 1,
                    targetStatus: status
                }
            });
        }

        function startTimer() {
            timer = 10;
            $('#timer_label').text(timer);

            countdownInterval = setInterval(function () {
                timer--;
                $('#timer_label').text(timer);

                if (timer <= 0) {
                    clearInterval(countdownInterval);
                    // 10초 끝난 후 '정답 공개' 버튼 활성화
                    $('#btnClicker').text('정답 공개 (클릭)').css({'opacity': '1', 'pointer-events': 'auto'});
                }
            }, 1000);
        }

        function showCorrectAnswer() {
            const q = questions[currentQIndex];
            const correctIndex = q.correctAnswer - 1; // 1번 정답이면 인덱스 0

            // style.css 에 이미 구현된 ":checked + label" 디자인을 100% 활용하기 위해 강제로 checked 상태 부여
            $('input[name="choice"]').eq(correctIndex).prop('checked', true);
        }
    </script>
</body>
</html>