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
        .end_success, .end_fail { display: none; }
    </style>
</head>
<body class="quiz">

<div id="container">
    <div class="ck-in center">

        <div class="top_tit">
            <div class="inner">
                <div class="tit">
                    <a href="/quiz/main">
                        <img src="/img/logo.png" alt="logo">
                    </a>
                </div>
            </div>
        </div>

        <div class="bar">
            <div class="tit">BYD <span>퀴즈 이벤트</span></div>
            <div class="end_progress">
                <div class="progress_item on"></div>
                <div class="progress_item on"></div>
                <div class="progress_item on"></div>
                <div class="progress_item on"></div>
                <div class="progress_item on"></div>
                <div class="progress_item on"></div>
                <div class="progress_item on"></div>
                <div class="progress_item on"></div>
                <div class="progress_item on"></div>
                <div class="progress_item on"></div>
            </div>
        </div>

        <div id="content">
            <div class="ct_wrap end_wrap">

                <div class="end_success" id="successView">
                    <img src="/img/icon_success.png" alt="성공">
                    <div class="tit text-primary">10문제 정답!</div>
                    <div class="desc">안내센터로 가서 기념품을 수령해 보세요.</div>
                    <div class="txt_box">
                        <img src="/img/ico_present.png" alt="선물">
                        <div class="txt">기념품 수령 안내</div>
                        <div class="desc">안내 데스크 직원에게 본 화면을 제시해 주시면 기념품을 증정해 드립니다. <br>(기념품은 1인 1개 한정 수령 가능)</div>
                    </div>
                </div>

                <div class="end_fail" id="failView">
                    <img src="/img/icon_fail.png" alt="실패">
                    <div class="tit"><span id="failScore">0</span>문제 정답!</div>
                    <div class="desc">너무 아쉬워요 <br/>대신 다른 모델을 둘러보세요.</div>
                    <img src="/img/img_car.png" alt="자동차 이미지">
                    <div class="btn_box">
                        <a href="https://www.byd.com/kr" class="btn_st05_f">모델 둘러보기</a>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        // 1. 세션에 저장해둔 점수 가져오기
        const scoreStr = sessionStorage.getItem("quizScore");

        // 점수 데이터가 없으면 강제 접근으로 간주하고 튕겨냄
        if (scoreStr === null || scoreStr === "") {
            alert("정상적인 접근이 아닙니다. 퀴즈를 다시 진행해 주세요.");
            location.replace("/quiz/main");
            return;
        }

        const score = parseInt(scoreStr);

        // 2. 점수에 따른 화면 분기
        if (score === 10) {
            // 만점자: 성공 뷰 노출
            $('#successView').fadeIn(300);
        } else {
            // 실패자: 몇 문제 맞혔는지 숫자 업데이트 후 실패 뷰 노출
            $('#failScore').text(score);
            $('#failView').fadeIn(300);
        }

        // 3. 재접근 시 어뷰징을 막기 위해 문제 데이터 세션 초기화 (선택적)
        sessionStorage.removeItem("quizQuestions");
    });
</script>
</body>
</html>