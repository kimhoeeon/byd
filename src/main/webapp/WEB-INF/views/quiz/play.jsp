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
        .btn_multi label { word-break: keep-all; line-height: 1.3; }
        .btn_disabled { background-color: #d3d3d3 !important; color: #888 !important; cursor: not-allowed !important; pointer-events: none; }
    </style>
</head>
<body class="quiz">

<div id="container">
    <div class="ck-in center">
        <div class="top_tit">
            <div class="inner">
                <div class="back">
                    <a href="javascript:history.back();">
                        <img src="/img/left_arrow.svg" alt="뒤로가기">
                    </a>
                </div>
                <div class="tit">
                    <a href="/quiz/main">
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
                    <div class="numb" id="progressText">Q.1</div>
                    <div class="ask" id="questionText">문제를 불러오는 중입니다...</div>
                </div>
                <div class="quiz_q">
                    <div class="multi">
                        <div class="btn_multi">
                            <input type="radio" id="choice1" name="choice" value="1">
                            <label for="choice1" id="choiceLabel1">보기1</label>
                        </div>
                        <div class="btn_multi">
                            <input type="radio" id="choice2" name="choice" value="2">
                            <label for="choice2" id="choiceLabel2">보기2</label>
                        </div>
                        <div class="btn_multi">
                            <input type="radio" id="choice3" name="choice" value="3">
                            <label for="choice3" id="choiceLabel3">보기3</label>
                        </div>
                        <div class="btn_multi">
                            <input type="radio" id="choice4" name="choice" value="4">
                            <label for="choice4" id="choiceLabel4">보기4</label>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="btn_box">
            <button type="button" class="btn_st05 btn_disabled" id="btnNext" style="width:100%; border:none;">다음</button>
        </div>
    </div>
</div>

<script>
    let quizQuestions = [];
    let historySeq = null;
    let currentIndex = 0;
    let userAnswers = {};

    $(document).ready(function() {
        const storedQuestions = sessionStorage.getItem("quizQuestions");
        historySeq = sessionStorage.getItem("quizHistorySeq");

        if (!storedQuestions || !historySeq) {
            alert("비정상적인 접근이거나 세션이 만료되었습니다.");
            location.replace("/quiz/main");
            return;
        }

        quizQuestions = JSON.parse(storedQuestions);
        renderQuestion(currentIndex);

        $('input[name="choice"]').on('change', function() {
            $('#btnNext').removeClass('btn_disabled');
        });

        $('#btnNext').on('click', function() {
            if ($(this).hasClass('btn_disabled')) return;

            const selectedVal = $('input[name="choice"]:checked').val();
            const currentQId = quizQuestions[currentIndex].questionId;
            userAnswers[currentQId] = parseInt(selectedVal);

            currentIndex++;

            if (currentIndex < quizQuestions.length) {
                renderQuestion(currentIndex);
            } else {
                submitQuiz();
            }
        });
    });

    function renderQuestion(index) {
        const q = quizQuestions[index];

        // 텍스트 업데이트
        $('#progressText').text('Q.' + (index + 1));
        $('#questionText').text(q.questionText);
        $('#choiceLabel1').text(q.choice1);
        $('#choiceLabel2').text(q.choice2);
        $('#choiceLabel3').text(q.choice3);
        $('#choiceLabel4').text(q.choice4);

        // [추가] 상단 진행바(bar) UI 업데이트 로직
        $('.quiz_progress .progress_item').removeClass('on');
        $('.quiz_progress .progress_item').each(function(i) {
            if (i <= index) {
                $(this).addClass('on');
            }
        });

        $('input[name="choice"]').prop('checked', false);
        $('#btnNext').addClass('btn_disabled');

        if (index === quizQuestions.length - 1) {
            $('#btnNext').text('결과 확인하기');
        } else {
            $('#btnNext').text('다음');
        }
    }

    function submitQuiz() {
        $('#btnNext').addClass('btn_disabled').text('채점 중입니다...');

        $.ajax({
            url: '/api/quiz/submit?historySeq=' + historySeq,
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(userAnswers),
            success: function(res) {
                if (res.success) {
                    sessionStorage.setItem("quizScore", res.score);
                    location.replace("/quiz/result");
                } else {
                    alert(res.message);
                    location.replace("/quiz/main");
                }
            },
            error: function() {
                alert("채점 중 오류가 발생했습니다.");
                $('#btnNext').removeClass('btn_disabled').text('결과 확인하기');
            }
        });
    }
</script>
</body>
</html>