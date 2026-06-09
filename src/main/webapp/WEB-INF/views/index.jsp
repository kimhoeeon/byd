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
    <script src="/js/gsap.min.js"></script>
    <script src="/js/ScrollTrigger.min.js"></script>
    <script src="/js/script.js"></script>

    <title>BYD</title>

</head>

<body>

<!-- container -->
<div class="container">

    <!-- check-in -->
    <div class="main">

        <!-- header -->
        <div class="header padding_tb">
            <div class="inner">
                <div class="tit">
                    <img src="/img/logo.png" alt="logo">
                </div>
            </div>
        </div>
        <!-- //header -->

        <!-- banner -->
        <div class="main_banner">
            <div class="inner">
                <div class="tit">
                    <div class="txt_img">
                        <img src="/img/main_tit.png" alt="메인 타이틀">
                    </div>
                    <div class="txt">The Power of Duailty</div>
                </div>
                <div class="date_box">
                    <ul>
                        <li>
                            <img src="/img/date_icon.png" alt="아이콘">
                            <div>2026.6.26(금) - 7. 5(일)</div>
                        </li>
                        <li>
                            <img src="/img/map_icon.png" alt="아이콘">
                            <div>BEXCO</div>
                        </li>
                    </ul>
                </div>
                <div class="scroll">
                    <div>SCROLL</div>
                </div>
            </div>
        </div>
        <!-- //banner -->

        <!-- section -->
        <div class="main_video">
            <div class="bg">
                <div class="bg_video">
                    <div class="video_container">
                        <div class="yt-wrapper">
                            <div class="video_content">
                                <iframe id="vimeo-player" src="https://player.vimeo.com/video/1199335845?h=b9ac112efc&badge=0&autopause=0&player_id=0&muted=1&loop=1&playsinline=1&controls=0" frameborder="0" allow="autoplay; fullscreen; picture-in-picture; clipboard-write; encrypted-media" data-ready="true">
                                </iframe>
                            </div>
                            <script src="https://player.vimeo.com/api/player.js"></script>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- //section -->

        <!-- section -->
        <div class="main_car">
            <div class="inner">
                <div class="car_top">
                    <div>DRIVE IS</div>
                    <div>PLAYFUL</div>
                    <img src="/img/car_list01_big.png" alt="차량 이미지" class="main_car_img">
                </div>

                <div class="car_list">
                    <ul>
                        <li data-num="1" class="on">
                            <img src="/img/car_list01.png" alt="">
                            <div>BYD DOLPHIN</div>
                        </li>
                        <li data-num="2">
                            <img src="/img/car_list02.png" alt="">
                            <div>BYD ATTO 3</div>
                        </li>
                        <li data-num="3">
                            <img src="/img/car_list03.png" alt="">
                            <div>BYD SEAL</div>
                        </li>

                        <li data-num="4">
                            <img src="/img/car_list04.png" alt="">
                            <div>BYD SEALION 7</div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
        <!-- //section -->

        <!-- section -->
        <div class="main_map">
            <div class="location">
                <div class="tit">EVENT LOCATION</div>
                <ul class="info">
                    <li>명칭: BUSAN MOBITILY SHOW 2026</li>
                    <li>주최: BYD</li>
                    <li>일시: 2026. 6. 26(금) ~ 7. 5(일), 10일간</li>
                    <li>장소: BEXCO</li>
                </ul>
            </div>
            <div class="map_img">
                <img src="/img/main_map.png" alt="지도">
            </div>
        </div>
        <!-- //section -->

        <!-- footer -->
        <div class="footer">
            <div class="f_info">
                <div class="logo">
                    <img src="/img/logo.png" alt="로고">
                    Busan Mobility Show 2026
                </div>
                <div class="copy">Copyright ©2026 BYD Company Ltd. All rights reserved.</div>
            </div>
        </div>
        <!-- //footer -->
    </div>
    <!-- //check-in -->

</div>
<!-- //container -->

</body>
</html>