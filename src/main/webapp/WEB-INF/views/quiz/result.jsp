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

    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
</head>
<body class="quiz">

    <div id="container">
        <div class="ck-in center">

            <div class="top_tit">
                <div class="inner">
                    <div class="tit">
                        <a href="/quiz/step1">
                            <img src="/img/logo.png" alt="logo">
                        </a>
                    </div>
                </div>
            </div>

            <div id="content">
                <div class="ct_wrap end_wrap">

                    <div class="end_success" id="successView" style="display: none;">
                        <img src="/img/icon_success.png" alt="성공">
                        <div class="tit">10문제 만점!</div>
                        <div class="desc">대단해요! 퀴즈를 모두 맞히셨습니다.</div>

                        <div class="qr_wrap" style="background: #ffffff; padding: 15px; border-radius: 15px; display: inline-block; margin: 20px auto; box-shadow: 0 4px 10px rgba(0,0,0,0.1);">
                            <div id="qrcode" style="display: flex; justify-content: center; align-items: center; width: 160px; height: 160px;"></div>
                        </div>

                        <div class="info_box">
                            <div class="txt" style="line-height: 1.4;">안내데스크 직원에게 위 QR코드를 보여주시고<br>소정의 기념품을 수령해 주세요!</div>
                        </div>

                        <div class="btn_box" style="margin-top: 30px;">
                            <a href="javascript:void(0);" onclick="goHome()" class="btn_st05">처음으로 돌아가기</a>
                        </div>
                    </div>

                    <div class="end_fail" id="failView" style="display: none;">
                        <img src="/img/icon_fail.png" alt="실패">
                        <div class="tit"><span id="failScore">0</span>문제 정답!</div>
                        <div class="desc">너무 아쉬워요 <br/>대신 다른 모델을 둘러보세요.</div>
                        <img src="/img/img_car.png" alt="자동차 이미지">

                        <div class="btn_box">
                            <a href="javascript:void(0);" onclick="goModel()" class="btn_st05_f">모델 둘러보기</a>
                            <a href="javascript:void(0);" onclick="goHome()" class="btn_st05" style="margin-top: 10px;">처음으로 돌아가기</a>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function () {
            // 저장 시 사용한 키(quizHistorySeq)와 정확하게 매핑
            const scoreStr = sessionStorage.getItem("finalScore");
            const historySeq = sessionStorage.getItem("quizHistorySeq");

            if (scoreStr === null || scoreStr === "") {
                alert("정상적인 접근이 아닙니다. 퀴즈를 다시 진행해 주세요.");
                location.replace("/quiz/step1");
                return;
            }

            const score = parseInt(scoreStr);

            if (score === 10) {
                // 만점자 QR 코드 발급
                const qrData = "BYD_HISTORY_" + historySeq;

                // qrcode.js를 이용한 클라이언트 자체 렌더링
                new QRCode(document.getElementById("qrcode"), {
                    text: qrData,
                    width: 160,
                    height: 160,
                    colorDark : "#000000",
                    colorLight : "#ffffff",
                    correctLevel : QRCode.CorrectLevel.H
                });

                $('#successView').show();
                $('#failView').hide();
            } else {
                // 실패
                $('#failScore').text(score);
                $('#successView').hide();
                $('#failView').show();
            }
        });

        function goHome() {
            sessionStorage.clear();
            location.replace("/quiz/step1");
        }

        function goModel() {
            sessionStorage.clear();
            location.replace("/");
        }
    </script>
</body>
</html>