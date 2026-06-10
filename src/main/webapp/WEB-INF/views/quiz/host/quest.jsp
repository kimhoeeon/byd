<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover"/>
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

    <style>
        /* 정답 강제 하이라이트 처리 (눈에 확 띄는 붉은색 + 글로우 효과) */
        .correct_ans {
            background-color: #E50000 !important;
            color: #fff !important;
            font-weight: bold !important;
            border-color: #E50000 !important;
            box-shadow: 0 0 15px rgba(229, 0, 0, 0.6) !important;
        }

        /* 타이머 색상을 기존 어두운 회색에서 눈에 띄는 밝은 흰색으로 강제 변경 */
        .timer_box .time {
            color: #ffffff !important;
            text-shadow: 0 0 15px rgba(255, 255, 255, 0.5);
        }
    </style>
</head>

<body class="host">

    <div id="liveCountBox" style="position: fixed; top: 20px; right: 20px; background: rgba(0,0,0,0.8); padding: 12px 20px; border-radius: 30px; z-index: 9999; box-shadow: 0 4px 10px rgba(0,0,0,0.3);">
        <span style="color: #fff; font-size: 16px; font-weight: bold;">
            접속 인원 : <span id="liveCount" style="color: #00ffcc; font-size: 22px;">0</span> 명
        </span>
    </div>

    <!-- container -->
    <div id="container">

        <!-- check-in -->
        <div class="ck-in center">
            <!-- title -->
            <div class="top_tit">
                <div class="inner">
                    <div class="tit">
                        <img src="/img/logo.png" alt="logo">
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

            <!-- 타이머 -->
            <div class="time_box">
                <div class="timer_box">
                    <div id="timer" class="time"><span id="timer_label">10</span></div>
                </div>
            </div>

            <!-- info -->
            <div id="content">
                <div class="ct_wrap quiz_wrap">
                    <div class="quiz_a">
                        <div class="numb">1</div>
                        <div class="ask">문제를 준비 중입니다...</div>
                    </div>

                    <div class="quiz_q">
                        <!-- 객관식 -->
                        <div class="multi">
                            <div class="btn_multi">
                                <input type="radio" id="choice1" name="choice" value="1" disabled>
                                <label for="choice1">?</label>
                            </div>
                            <div class="btn_multi">
                                <input type="radio" id="choice2" name="choice" value="2" disabled>
                                <label for="choice2">?</label>
                            </div>
                            <div class="btn_multi">
                                <input type="radio" id="choice3" name="choice" value="3" disabled>
                                <label for="choice3">?</label>
                            </div>
                            <div class="btn_multi">
                                <input type="radio" id="choice4" name="choice" value="4" disabled>
                                <label for="choice4">?</label>
                            </div>
                        </div>
                        <!-- //객관식 -->
                    </div>
                    <div class="btn_box" style="margin-top: 30px;">
                        <a href="javascript:void(0);" id="btnClicker" class="btn_st05">문제 로딩 중...</a>
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
            READY: 'READY',             // 문제 공개 전 대기
            PLAYING: 'PLAYING',         // 10초 카운트 시작
            SHOW_ANSWER: 'SHOW_ANSWER'  // 정답 공개
        };
        let currentState = STATE.READY;

        function getTodayStr() {
            const d = new Date();
            return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
        }

        // 최상위 키보드/클리커 이벤트 강제 캡처
        document.addEventListener('keydown', function(e) {
            // 34(PageDown), 39(우측방향), 32(스페이스바), 13(엔터), 40(하단방향)
            if (e.keyCode === 34 || e.keyCode === 39 || e.keyCode === 32 || e.keyCode === 13 || e.keyCode === 40) {
                e.preventDefault();
                processNextStep();
            }
        }, true);

        // 빈 화면(배경) 클릭 시 진행
        $(document).on('click', function(e) {
            if (e.target.id !== 'btnClicker' && $(e.target).closest('.btn_multi').length === 0) {
                processNextStep();
            }
        });

        $(document).ready(function () {
            // 1. 현재 서버의 상태를 먼저 조회 (새로고침 시 복구용)
            $.ajax({
                url: '/api/quiz/live/status',
                type: 'GET',
                data: {playDate: playDate, sessionNo: sessionNo},
                success: function (statusRes) {
                    if (statusRes.success) {
                        // 서버에 저장된 현재 진행 번호와 상태를 JS에 강제 주입
                        currentQIndex = statusRes.currentQuestionNo > 0 ? statusRes.currentQuestionNo - 1 : 0;
                        currentState = statusRes.status;

                        // 2. 이어서 문제 목록 로드
                        $.ajax({
                            url: '/api/quiz/live/host/questions',
                            type: 'GET',
                            data: {playDate: playDate, sessionNo: sessionNo},
                            success: function (res) {
                                if (res.success && res.questions.length > 0) {
                                    questions = res.questions;

                                    // 상태에 맞게 UI 즉시 복구
                                    if (currentState === 'PLAYING' || currentState === 'SHOW_ANSWER') {
                                        // 이미 진행 중이던 문제면 텍스트를 바로 띄움
                                        const q = questions[currentQIndex];
                                        $('.quiz_a .numb').text(currentQIndex + 1);
                                        $('.quiz_a .ask').text(q.questionText);
                                        const labels = $('.quiz_q .btn_multi label');
                                        $(labels[0]).text(q.choice1);
                                        $(labels[1]).text(q.choice2);
                                        $(labels[2]).text(q.choice3);
                                        $(labels[3]).text(q.choice4);

                                        $('.quiz_progress .progress_item').removeClass('on');
                                        $('.quiz_progress .progress_item').each(function (i) {
                                            if (i <= currentQIndex) $(this).addClass('on');
                                        });

                                        if (currentState === 'PLAYING') {
                                            startTimer(); // 타이머 재가동
                                            $('#btnClicker').text('10초 카운트다운 진행중...').css({
                                                'opacity': '0.5',
                                                'pointer-events': 'none'
                                            });
                                        } else {
                                            showCorrectAnswer();
                                            const isLast = (currentQIndex === questions.length - 1);
                                            $('#btnClicker').text(isLast ? '결과 보기 페이지로 이동' : '다음 문제 준비하기').css({
                                                'opacity': '1',
                                                'pointer-events': 'auto'
                                            });
                                        }
                                    } else {
                                        // 대기(READY) 상태면 블라인드 UI 로드
                                        loadQuestionUI();
                                        updateServerState(STATE.READY);
                                    }
                                } else {
                                    alert("문제를 불러올 수 없습니다.");
                                    location.href = '/quiz/host/main';
                                }
                            }
                        });
                    }
                }
            });

            // (기존 클릭 이벤트, 폴링 등 유지)
            $('#btnClicker').on('click', function (e) {
                e.preventDefault();
                processNextStep();
            });
            fetchParticipantCount();
            setInterval(fetchParticipantCount, 2000);
        });

        function processNextStep() {
            const btn = $('#btnClicker');
            if(btn.css('pointer-events') === 'none') return; // 비활성화 방어

            if (currentState === STATE.READY) {
                currentState = STATE.PLAYING;
                updateServerState(STATE.PLAYING);

                const q = questions[currentQIndex];
                $('.quiz_a .ask').text(q.questionText);
                const labels = $('.quiz_q .btn_multi label');
                $(labels[0]).text(q.choice1);
                $(labels[1]).text(q.choice2);
                $(labels[2]).text(q.choice3);
                $(labels[3]).text(q.choice4);

                startTimer();
                btn.text('10초 카운트다운 진행중...').css({'opacity': '0.5', 'pointer-events': 'none'});

            } else if (currentState === STATE.PLAYING) {
                currentState = STATE.SHOW_ANSWER;
                updateServerState(STATE.SHOW_ANSWER);
                showCorrectAnswer();

                const isLast = (currentQIndex === questions.length - 1);
                btn.text(isLast ? '결과 보기 페이지로 이동' : '다음 문제 준비하기');

            } else if (currentState === STATE.SHOW_ANSWER) {
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
        }

        function loadQuestionUI() {
            $('.quiz_a .numb').text(currentQIndex + 1);
            $('.quiz_a .ask').text('잠시 후 ' + (currentQIndex + 1) + '번 문제가 공개됩니다!');

            const labels = $('.quiz_q .btn_multi label');
            $(labels[0]).text('?');
            $(labels[1]).text('?');
            $(labels[2]).text('?');
            $(labels[3]).text('?');

            $('input[name="choice"]').prop('checked', false);
            $('.quiz_q .btn_multi label').removeClass('correct_ans');

            $('#timer_label').text('10');
            $('#btnClicker').text('현재 문제 시작 (클릭)').css({'opacity': '1', 'pointer-events': 'auto'});

            $('.quiz_progress .progress_item').removeClass('on');
            $('.quiz_progress .progress_item').each(function(i) {
                if (i <= currentQIndex) $(this).addClass('on');
            });
        }

        function updateServerState(status) {
            $.ajax({
                url: '/api/quiz/live/host/control',
                type: 'POST',
                data: { playDate: playDate, sessionNo: sessionNo, targetQuestionNo: currentQIndex + 1, targetStatus: status }
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
                    $('#btnClicker').text('정답 공개 (클릭)').css({'opacity': '1', 'pointer-events': 'auto'});
                }
            }, 1000);
        }

        function showCorrectAnswer() {
            const q = questions[currentQIndex];
            const correctIndex = q.correctAnswer - 1;

            $('input[name="choice"]').eq(correctIndex).prop('checked', true);
            $('.quiz_q .btn_multi label').eq(correctIndex).addClass('correct_ans');
        }

        function fetchParticipantCount() {
            if (currentState === 'ENDED') return;
            $.ajax({
                url: '/api/quiz/live/host/participant-count',
                type: 'GET',
                data: { playDate: playDate, sessionNo: sessionNo },
                success: function(res) {
                    if(res.success) {
                        $('#liveCount').text(res.count);
                    }
                }
            });
        }
    </script>
</body>
</html>