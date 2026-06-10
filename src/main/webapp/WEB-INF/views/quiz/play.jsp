<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <meta name="format-detection" content="telephone=no"/>
    <title>BYD 퀴즈 이벤트</title>
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
        /* 정답 공개 시 하이라이트 스타일 (강렬한 붉은색 네온 효과) */
        .correct {
            background-color: #E50000 !important;
            color: #fff !important;
            font-weight: bold !important;
            border-color: #E50000 !important;
            box-shadow: 0 0 15px rgba(229, 0, 0, 0.6) !important;
        }
    </style>
</head>
<body class="quiz">

    <div id="container">
        <div class="ck-in center">
            <div class="top_tit">
                <div class="inner">
                    <div class="tit">
                        <a href="/">
                            <img src="/img/logo.png" alt="logo">
                        </a>
                    </div>
                </div>
            </div>

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

            <div id="content">
                <div class="ct_wrap quiz_wrap">
                    <div class="quiz_a">
                        <div class="numb">1</div>
                        <div class="ask">MC가 문제를 준비 중입니다...</div>
                    </div>

                    <div class="quiz_q">
                        <div class="multi">
                            <div class="btn_multi">
                                <input type="radio" id="choice1" name="choice" value="1" disabled>
                                <label for="choice1" id="choiceLabel1">?</label>
                            </div>
                            <div class="btn_multi">
                                <input type="radio" id="choice2" name="choice" value="2" disabled>
                                <label for="choice2" id="choiceLabel2">?</label>
                            </div>
                            <div class="btn_multi">
                                <input type="radio" id="choice3" name="choice" value="3" disabled>
                                <label for="choice3" id="choiceLabel3">?</label>
                            </div>
                            <div class="btn_multi">
                                <input type="radio" id="choice4" name="choice" value="4" disabled>
                                <label for="choice4" id="choiceLabel4">?</label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        let quizQuestions = [];
        const historySeq = sessionStorage.getItem("quizHistorySeq");
        const userSeq = sessionStorage.getItem("quizUserSeq");
        const sessionNo = sessionStorage.getItem("quizSessionNo");
        const playDate = sessionStorage.getItem("quizPlayDate");

        let currentQIndex = -1;
        let currentState = '';

        $(document).ready(function () {
            if (!historySeq || !sessionNo) {
                alert("정상적인 접근이 아닙니다.");
                location.replace("/quiz/step1");
                return;
            }

            quizQuestions = JSON.parse(sessionStorage.getItem("quizQuestions"));

            // 1초마다 MC 화면의 상태를 가져옴 (Polling)
            setInterval(pollLiveStatus, 1000);
        });

        function pollLiveStatus() {
            $.ajax({
                url: '/api/quiz/live/status',
                type: 'GET',
                data: { playDate: playDate, sessionNo: sessionNo },
                success: function(res) {
                    if(res.success) {
                        if (res.status === 'ENDED') {
                            submitFinalScore();
                            return;
                        }

                        if (currentQIndex !== (res.currentQuestionNo - 1) || currentState !== res.status) {
                            currentQIndex = res.currentQuestionNo - 1;
                            currentState = res.status;
                            renderUI(res);
                        }
                    } else {
                        alert("MC에 의해 세션이 초기화되었거나 종료되었습니다.");
                        location.replace("/quiz/step1");
                    }
                },
                error: function() { }
            });
        }

        function renderUI(res) {
            if (currentQIndex < 0) return;

            const q = quizQuestions[currentQIndex];
            $('.quiz_a .numb').text(currentQIndex + 1);

            $('.quiz_progress .progress_item').removeClass('on');
            $('.quiz_progress .progress_item').each(function(i) {
                if (i <= currentQIndex) $(this).addClass('on');
            });

            if (currentState === 'READY') {
                // [대기 상태] 문제와 보기를 '?'로 가림 (미리보기 차단)
                $('.quiz_a .ask').text("MC가 문제를 준비 중입니다...");
                $('#choiceLabel1').text('?');
                $('#choiceLabel2').text('?');
                $('#choiceLabel3').text('?');
                $('#choiceLabel4').text('?');

                $('input[name="choice"]').prop('disabled', true);
                $('.quiz_q .btn_multi label').removeClass('correct');
                restoreSavedAnswer();

            } else if (currentState === 'PLAYING') {
                // [진행 상태] 실제 문제와 보기를 노출!
                $('.quiz_a .ask').text(q.questionText);
                $('#choiceLabel1').text(q.choice1);
                $('#choiceLabel2').text(q.choice2);
                $('#choiceLabel3').text(q.choice3);
                $('#choiceLabel4').text(q.choice4);

                $('input[name="choice"]').prop('disabled', false);
                $('.quiz_q .btn_multi label').removeClass('correct');
                restoreSavedAnswer();

            } else if (currentState === 'SHOW_ANSWER') {
                // [정답 상태] 문제 표기 유지, 정답 하이라이트 처리
                $('.quiz_a .ask').text(q.questionText);
                $('#choiceLabel1').text(q.choice1);
                $('#choiceLabel2').text(q.choice2);
                $('#choiceLabel3').text(q.choice3);
                $('#choiceLabel4').text(q.choice4);

                $('input[name="choice"]').prop('disabled', true);

                if(res.correctAnswer) {
                    const correctIndex = res.correctAnswer - 1;
                    $('.quiz_q .btn_multi label').eq(correctIndex).addClass('correct');
                }
            }
        }

        function restoreSavedAnswer() {
            const savedAns = sessionStorage.getItem("ans_" + currentQIndex);
            if (savedAns) {
                $('#choice' + savedAns).prop('checked', true);
            } else {
                $('input[name="choice"]').prop('checked', false);
            }
        }

        $('input[name="choice"]').on('change', function() {
            const answerId = $(this).val();
            sessionStorage.setItem("ans_" + currentQIndex, answerId);

            $.ajax({
                url: '/api/quiz/live/auto-save',
                type: 'POST',
                data: {
                    userSeq: userSeq,
                    playDate: playDate,
                    sessionNo: sessionNo,
                    questionIndex: currentQIndex + 1,
                    answerId: answerId
                }
            });
        });

        function submitFinalScore() {
            $.ajax({
                url: '/api/quiz/submit?historySeq=' + historySeq,
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({}),
                success: function(res) {
                    if(res.success) {
                        sessionStorage.setItem("quizScore", res.score);
                        location.replace("/quiz/result");
                    } else {
                        alert(res.message);
                        location.replace("/quiz/step1");
                    }
                }
            });
        }
    </script>
</body>
</html>