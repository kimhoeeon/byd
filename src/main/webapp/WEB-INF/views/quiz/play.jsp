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
        /* 정답 공개 시 하이라이트 스타일 (MC 화면과 동일하게 맞춤) */
        .correct { background-color: #000 !important; color: #fff !important; font-weight: bold !important; border-color: #000 !important; }
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

                    <div style="text-align:center; color:#fff; font-size:16px; margin-top:20px; font-weight:bold;" id="quizStatusTxt">
                        잠시만 기다려 주세요.
                    </div>

                    <div class="quiz_q">
                        <div class="multi">
                            <div class="btn_multi">
                                <input type="radio" id="choice1" name="choice" value="1" disabled>
                                <label for="choice1" id="choiceLabel1">보기 1</label>
                            </div>
                            <div class="btn_multi">
                                <input type="radio" id="choice2" name="choice" value="2" disabled>
                                <label for="choice2" id="choiceLabel2">보기 2</label>
                            </div>
                            <div class="btn_multi">
                                <input type="radio" id="choice3" name="choice" value="3" disabled>
                                <label for="choice3" id="choiceLabel3">보기 3</label>
                            </div>
                            <div class="btn_multi">
                                <input type="radio" id="choice4" name="choice" value="4" disabled>
                                <label for="choice4" id="choiceLabel4">보기 4</label>
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
                        // MC가 퀴즈를 최종 종료한 경우
                        if (res.status === 'ENDED') {
                            submitFinalScore();
                            return;
                        }

                        // 문제 번호나 진행 상태(READY, PLAYING, SHOW_ANSWER)가 바뀌었을 때만 화면 갱신
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
                error: function() {
                    // 간헐적인 통신 장애 시 튕기지 않도록 에러 무시
                }
            });
        }

        function renderUI(res) {
            if (currentQIndex < 0) return; // 아직 1번 문제가 세팅되지 않음

            const q = quizQuestions[currentQIndex];
            $('.quiz_a .numb').text(currentQIndex + 1);
            $('.quiz_a .ask').text(q.questionText);
            $('#choiceLabel1').text(q.choice1);
            $('#choiceLabel2').text(q.choice2);
            $('#choiceLabel3').text(q.choice3);
            $('#choiceLabel4').text(q.choice4);

            // 상단 프로그레스 바 갱신
            $('.quiz_progress .progress_item').removeClass('on');
            $('.quiz_progress .progress_item').each(function(i) {
                if (i <= currentQIndex) $(this).addClass('on');
            });

            // 상태별 UI(버튼 활성/비활성, 정답 표시) 제어
            if (currentState === 'READY') {
                $('input[name="choice"]').prop('disabled', true);
                $('.quiz_q .btn_multi label').removeClass('correct');
                $('#quizStatusTxt').text("MC가 문제를 시작하기를 대기 중입니다...");
                restoreSavedAnswer(); // 혹시 저장된 답이 있으면 유지

            } else if (currentState === 'PLAYING') {
                $('input[name="choice"]').prop('disabled', false);
                $('.quiz_q .btn_multi label').removeClass('correct');
                $('#quizStatusTxt').text("10초 내에 화면에서 정답을 선택해 주세요!");
                restoreSavedAnswer();

            } else if (currentState === 'SHOW_ANSWER') {
                $('input[name="choice"]').prop('disabled', true);
                $('#quizStatusTxt').text("정답이 공개되었습니다.");

                // 서버에서 내려준 정답 번호에 하이라이트 표시
                if(res.correctAnswer) {
                    const correctIndex = res.correctAnswer - 1;
                    $('.quiz_q .btn_multi label').eq(correctIndex).addClass('correct');
                }
            }
        }

        // 통신 끊김 대비: 사용자가 이전에 찍어둔 답이 있으면 화면 갱신 시 다시 체크해줌
        function restoreSavedAnswer() {
            const savedAns = sessionStorage.getItem("ans_" + currentQIndex);
            if (savedAns) {
                $('#choice' + savedAns).prop('checked', true);
            } else {
                $('input[name="choice"]').prop('checked', false);
            }
        }

        // 사용자가 보기를 터치할 때마다 즉시 서버에 임시 저장 (Auto-Save)
        $('input[name="choice"]').on('change', function() {
            const answerId = $(this).val();
            sessionStorage.setItem("ans_" + currentQIndex, answerId); // 화면 새로고침 대비 로컬 보관

            $.ajax({
                url: '/api/quiz/live/auto-save',
                type: 'POST',
                data: {
                    userSeq: userSeq,
                    playDate: playDate,
                    sessionNo: sessionNo,
                    questionIndex: currentQIndex + 1, // 서버 DB 저장을 위해 1~10으로 전달
                    answerId: answerId
                }
            });
        });

        // MC가 최종 10번 문제를 끝내고 ENDED 처리 시, 서버에 일괄 채점 요청 후 결과창 이동
        function submitFinalScore() {
            $.ajax({
                url: '/api/quiz/submit?historySeq=' + historySeq,
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({}), // 답안은 이미 Auto-save 되었으므로 빈 객체 전송
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