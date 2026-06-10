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

            <!-- info -->
            <div class="info_box padding_b mt-100">
                <div class="inner">
                    <div class="tit">
                        <span>QUIZ EVENT</span>
                        <div>참여해 주셔서 감사합니다</div>
                    </div>
                    <div class="end_success">
                        <div class="txt_box">
                            <img src="/img/ico_present.png" alt="선물">
                            <div class="txt">기념품 수령 안내</div>
                            <div class="desc">기념품은 1인 1개만 수령 가능합니다. 어쩌고 저쩌고 기념품은 1인 1개만 수령 가능합니다. 어쩌고 저쩌고 기념품은 1인 1개만 수령 가능</div>
                        </div>
                    </div>
                </div>
                <div class="btn_box">
                    <a href="/quiz/host/main" class="btn_st05">다음 회차 준비하기 (메인으로)</a>
                </div>
            </div>
            <!-- //info -->

        </div>
        <!-- //check-in -->

    </div>
    <!-- //container -->

</body>
</html>