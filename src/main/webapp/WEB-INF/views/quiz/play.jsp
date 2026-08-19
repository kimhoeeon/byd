<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" />
    <meta name="description" content="">
    <meta name="author" content="">
    <meta name="format-detection" content="telephone=no"/>
    <title>BYD 퀴즈 이벤트</title>
    <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css"/>
    <script src="https://unpkg.com/swiper@7/swiper-bundle.min.js"></script>
    <link href="/css/reset.css" rel="stylesheet">
    <link href="/css/font.css" rel="stylesheet">
    <link href="/css/style.css?ver=20260616" rel="stylesheet">

    <script src="/js/jquery-1.9.1.min.js"></script>
    <script src="https://code.jquery.com/ui/1.13.0/jquery-ui.js"></script>
    <script src="/js/jquery.cookie.min.js"></script>
    <script src="/js/jquery.ui.touch-punch.min.js"></script>
    <script src="/js/script.js"></script>
    <style>
        .selected_ans {
            background-color: #E50000 !important;
            color: #fff !important;
            font-weight: bold !important;
            border-color: #E50000 !important;
            box-shadow: 0 0 15px rgba(229, 0, 0, 0.4) !important;
        }
        .timer_box .time {
            color: #ffffff !important;
            text-shadow: 0 0 10px rgba(255, 255, 255, 0.5);
        }
        #loadingOverlay {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.8); z-index: 9999;
            display: flex; flex-direction: column; justify-content: center; align-items: center;
            color: #fff; font-size: 18px; font-weight: bold;
        }
    </style>
</head>
<body class="quiz">

    <!-- 로딩 오버레이 -->
    <div id="loadingOverlay">
        <p id="loadingText">퀴즈를 준비 중입니다...</p>
    </div>

    <div id="container">
        <div class="ck-in mobile center">
            <div class="top_tit">
                <div class="inner">
                    <div class="tit">
                        <a href="/">
                            <img src="/img/logo.png" alt="logo">
                        </a>
                    </div>
                </div>
            </div>

            <!-- 개별 10초 타이머 -->
            <div class="time_box mt-5">
                <div class="timer_box">
                    <div id="timer" class="time"><span id="timer_label">10</span></div>
                </div>
            </div>

            <!-- 퀴즈 영역 -->
            <div id="content">
                <div class="ct_wrap quiz_wrap mt-4">
                    <div class="quiz_a">
                        <div class="ask" id="qText" style="padding-top: 15px;">문제 로딩 중...</div>
                    </div>

                    <div class="quiz_q mt-4">
                        <div class="multi">
                            <div class="btn_multi" onclick="selectAnswer(1)">
                                <input type="radio" id="choice1" name="choice" value="1">
                                <label for="choice1" id="label1">보기1</label>
                            </div>
                            <div class="btn_multi" onclick="selectAnswer(2)">
                                <input type="radio" id="choice2" name="choice" value="2">
                                <label for="choice2" id="label2">보기2</label>
                            </div>
                            <div class="btn_multi" onclick="selectAnswer(3)">
                                <input type="radio" id="choice3" name="choice" value="3">
                                <label for="choice3" id="label3">보기3</label>
                            </div>
                            <div class="btn_multi" onclick="selectAnswer(4)">
                                <input type="radio" id="choice4" name="choice" value="4">
                                <label for="choice4" id="label4">보기4</label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        let questionData = null;
        let historySeq = 0;
        let timer = 10;
        let countdownInterval;
        let isAnswered = false;

        const soundTimerIng = new Audio('/audio/timer_ing.mp3');
        const soundTimerEnd = new Audio('/audio/timer_end.mp3');

        $(document).ready(function () {
            const questionsStr = sessionStorage.getItem('quizQuestions');
            const hSeq = sessionStorage.getItem('quizHistorySeq');

            if (!questionsStr || !hSeq) {
                alert("퀴즈 정보가 없습니다. 처음부터 다시 진행해 주세요.");
                location.href = "/quiz/step1";
                return;
            }

            const parsedQuestions = JSON.parse(questionsStr);
            if (parsedQuestions.length > 0) {
                questionData = parsedQuestions[0]; // 단일 문제 할당
            }
            historySeq = hSeq;

            $('#loadingOverlay').hide();
            loadQuestion();
        });

        function loadQuestion() {
            isAnswered = false;

            $('#qText').text(questionData.questionText);
            $('#label1').text(questionData.choice1);
            $('#label2').text(questionData.choice2);
            $('#label3').text(questionData.choice3);
            $('#label4').text(questionData.choice4);

            $('input[name="choice"]').prop('checked', false);
            $('.btn_multi label').removeClass('selected_ans');

            startTimer();
        }

        function startTimer() {
            if (countdownInterval) clearInterval(countdownInterval);

            timer = 10;
            $('#timer_label').text(timer);

            soundTimerIng.currentTime = 0;
            soundTimerIng.play().catch(e => console.log('사운드 재생 에러:', e));

            countdownInterval = setInterval(function () {
                timer--;
                $('#timer_label').text(timer);

                if (timer <= 0) {
                    clearInterval(countdownInterval);
                    soundTimerIng.pause();
                    soundTimerEnd.currentTime = 0;
                    soundTimerEnd.play().catch(e => console.log('사운드 에러:', e));

                    if (!isAnswered) {
                        isAnswered = true;
                        autoSaveAndNext(0); // 시간 초과 시 0번(오답) 전송
                    }
                }
            }, 1000);
        }

        function selectAnswer(answerId) {
            if (isAnswered) return;
            isAnswered = true;

            clearInterval(countdownInterval);
            soundTimerIng.pause();

            $('input[name="choice"]').eq(answerId - 1).prop('checked', true);
            $('.btn_multi label').removeClass('selected_ans');
            $('#label' + answerId).addClass('selected_ans');

            autoSaveAndNext(answerId);
        }

        function autoSaveAndNext(answerId) {
            $.ajax({
                url: '/api/quiz/auto-save',
                type: 'POST',
                data: {
                    historySeq: historySeq,
                    questionIndex: 1, // 단일 문제이므로 1 전송
                    answerId: answerId
                }
            });

            // 1문항이므로 지연 후 즉시 제출 로직 호출
            setTimeout(function() {
                executeSubmitQuiz();
            }, 700);
        }

        function executeSubmitQuiz() {
            $('#loadingText').text('답안을 채점하고 있습니다...');
            $('#loadingOverlay').show();

            $.ajax({
                url: '/api/quiz/submit',
                type: 'POST',
                data: { historySeq: historySeq },
                success: function(res) {
                    if (res.success) {
                        sessionStorage.setItem('finalScore', res.score);
                        location.href = '/quiz/result';
                    } else {
                        alert(res.message);
                        location.href = '/quiz/step1';
                    }
                },
                error: function() {
                    alert("최종 제출 중 오류가 발생했습니다.");
                    $('#loadingOverlay').hide();
                }
            });
        }
    </script>
</body>
</html>