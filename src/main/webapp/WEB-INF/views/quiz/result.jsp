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
                        <div class="tit">정답!</div>
                        <div class="desc">축하합니다!<br>정답입니다.</div>
                    </div>

                    <div class="end_fail" id="failView" style="display: none;">
                        <img src="/img/icon_fail.png" alt="실패">
                        <div class="tit">오답!</div>
                        <div class="desc">너무 아쉬워요!</div>

                        <div class="txt_box">
                            <div class="desc">BYD 퀴즈 이벤트에 참여해 주셔서 감사합니다.</div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function () {
            const scoreStr = sessionStorage.getItem("finalScore");

            if (scoreStr === null || scoreStr === "") {
                alert("정상적인 접근이 아닙니다. 퀴즈를 다시 진행해 주세요.");
                location.replace("/");
                return;
            }

            // 퀴즈를 완료했으므로 브라우저에 참여 완료 꼬리표 부착 (재접속 차단용)
            localStorage.setItem('quizCompleted_BYD2026', 'Y');

            const score = parseInt(scoreStr);

            // 1점(만점)일 경우 성공 화면
            if (score === 1) {
                $('#successView').show();
                $('#failView').hide();
            } else {
                // 실패 (0점)
                $('#successView').hide();
                $('#failView').show();
            }

            // 보안을 위해 일회성 세션스토리지 즉시 삭제
            sessionStorage.removeItem("quizQuestions");
            sessionStorage.removeItem("finalScore");
            sessionStorage.removeItem("quizHistorySeq");
        });
    </script>
</body>
</html>