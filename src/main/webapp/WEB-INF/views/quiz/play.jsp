<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" />
    <meta name="format-detection" content="telephone=no,email=no,address=no"/>
    <meta name="apple-mobile-web-app-capable" content="yes"/>
    <meta name="mobile-web-app-capable" content="yes"/>

    <meta property="og:type" content="website">
    <meta property="og:locale" content="ko_KR">
    <meta property="og:site_name" content="BYD">
    <meta property="og:image" content="https://bydsmrun26.co.kr/img/og_img.jpg?ver=20260918">

    <title>BYD 퀴즈 이벤트</title>

    <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css"/>
    <link href="/css/reset.css" rel="stylesheet">
    <link href="/css/font.css" rel="stylesheet">
    <link href="/css/style.css?ver=20260918" rel="stylesheet">

    <script src="https://unpkg.com/swiper@7/swiper-bundle.min.js"></script>
    <script src="/js/jquery-1.9.1.min.js"></script>
    <script src="https://code.jquery.com/ui/1.13.0/jquery-ui.js"></script>
    <script src="/js/jquery.cookie.min.js"></script>
    <script src="/js/jquery.ui.touch-punch.min.js"></script>
    <script src="/js/script.js"></script>
    <style>
        #loadingOverlay {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.8); z-index: 9999;
            display: flex; flex-direction: column; justify-content: center; align-items: center;
            color: #fff; font-size: 18px; font-weight: bold;
        }
    </style>
</head>
<body class="quiz quiz_w">

    <!-- 로딩 오버레이 -->
    <div id="loadingOverlay">
        <p id="loadingText">퀴즈를 준비 중입니다...</p>
    </div>

    <div id="container">
        <div class="ck-in center">

            <!-- title -->
            <div class="top_tit">
                <div class="inner">
                    <div class="back">
                        <a href="javascript:history.back();">
                            <img src="/img/left_arrow_g.svg" alt="뒤로가기">
                        </a>
                    </div>
                    <div class="tit">
                        <a href="/quiz/step1">
                            <img src="/img/logo_w.png?ver=20260921" alt="logo">
                        </a>
                    </div>
                </div>
            </div>
            <!-- //title -->

            <div class="bar">
                <div class="tit">BYD 퀴즈 이벤트</div>
            </div>

            <!-- 개별 10초 타이머 -->
            <%--<div class="time_box mt-5">
                <div class="timer_box">
                    <div id="timer" class="time" style="font-size: 24px;"><span id="timer_label">05:00</span></div>
                </div>
            </div>--%>

            <!-- 퀴즈 영역 -->
            <div id="content">
                <div class="ct_wrap quiz_wrap mt-4">
                    <div class="quiz_a">
                        <div class="ask" id="qText" style="padding-top: 15px;">문제 로딩 중...</div>
                    </div>

                    <div class="quiz_q mt-4">
                        <div class="multi">
                            <div class="btn_multi" id="div_choice1" onclick="selectAnswer(1)">
                                <input type="radio" id="choice1" name="choice" value="1">
                                <label for="choice1" id="label1">보기1</label>
                            </div>
                            <div class="btn_multi" id="div_choice2" onclick="selectAnswer(2)">
                                <input type="radio" id="choice2" name="choice" value="2">
                                <label for="choice2" id="label2">보기2</label>
                            </div>
                            <div class="btn_multi" id="div_choice3" onclick="selectAnswer(3)">
                                <input type="radio" id="choice3" name="choice" value="3">
                                <label for="choice3" id="label3">보기3</label>
                            </div>
                            <div class="btn_multi" id="div_choice4" onclick="selectAnswer(4)">
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

        // BFCache (뒤로가기 시 캐시된 페이지 사용) 방지 및 강제 초기화
        window.addEventListener('pageshow', function(event) {
            if (event.persisted || (window.performance && window.performance.navigation.type === 2)) {
                location.reload();
            }
        });

        let questionData = null;
        let historySeq = 0;
        let timer = 300; // 5분
        let countdownInterval;
        let isAnswered = false;

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
                questionData = parsedQuestions[0];
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
            $('.btn_multi').removeClass('correct fail');

            startTimer(); // 백그라운드 5분 제한시간 시작
        }

        // 백그라운드 타이머 실행 로직
        function startTimer() {
            if (countdownInterval) clearInterval(countdownInterval);

            timer = 300; // 5분으로 초기화

            countdownInterval = setInterval(function () {
                timer--;

                if (timer <= 0) {
                    clearInterval(countdownInterval);

                    if (!isAnswered) {
                        isAnswered = true;
                        applyResultEffect(0); // 0 = 시간초과 (오답 처리)
                    }
                }
            }, 1000);
        }

        function selectAnswer(answerId) {
            if (isAnswered) return;
            isAnswered = true;

            clearInterval(countdownInterval); // 답변 시 타이머 중지

            $('input[name="choice"]').eq(answerId - 1).prop('checked', true);

            applyResultEffect(answerId);
        }

        // 퍼블리셔 CSS(correct, fail)를 활용한 시각적 피드백
        function applyResultEffect(userAnswerId) {
            const correctId = questionData.correctAnswer; // 실제 정답 번호

            if (userAnswerId === correctId) {
                // 정답을 맞춘 경우: 선택한 div에 'correct' 클래스 부여
                $('#div_choice' + userAnswerId).addClass('correct');
            } else {
                // 오답이거나 시간초과인 경우
                if (userAnswerId !== 0) {
                    // 선택한 번호에는 'fail' 클래스 (빨간색)
                    $('#div_choice' + userAnswerId).addClass('fail');
                }
                // 실제 정답이 무엇이었는지 'correct' 클래스로 보여줌 (녹색)
                $('#div_choice' + correctId).addClass('correct');
            }

            // 시각적 피드백을 주기 위해 2.5초 대기 후 채점 로직으로 넘어감
            setTimeout(function() {
                autoSaveAndNext(userAnswerId);
            }, 2500);
        }

        function autoSaveAndNext(answerId) {
            $('#loadingText').text('결과를 확인 중입니다...');
            $('#loadingOverlay').show();

            $.ajax({
                url: '/api/quiz/auto-save',
                type: 'POST',
                data: {
                    historySeq: historySeq,
                    questionIndex: 1,
                    answerId: answerId
                },
                success: function() {
                    executeSubmitQuiz();
                },
                error: function() {
                    executeSubmitQuiz();
                }
            });
        }

        function executeSubmitQuiz() {
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