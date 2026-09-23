<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!doctype html>
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

    <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css"/>
    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/style.css?ver=20260918">

    <title>BYD</title>

    <c:if test="${empty applyCompleteFlag}">
        <script>
            alert("잘못된 접근입니다.\n신청 페이지로 이동합니다.");
            location.replace("/apply/step1");
        </script>
    </c:if>

</head>

<body class="success apply_w">

    <header id="header">
        <div class="inner">
            <a href="/apply/step1" class="logo">
                <img src="/img/logo_w.png?ver=20260921" alt="logo">
            </a>
        </div>
    </header>

    <div id="container">
        <!-- //title -->
        <div class="info_box padding_tb h-100" style="color: #fff;">
            <div class="inner" style="text-align: center;">

                <!-- title -->
                <div class="top_tit padding_tb mx-320">
                    <div class="inner">
                        <div class="tit">
                            <img src="/img/logo_w_com.png" alt="logo">
                        </div>
                    </div>
                </div>

                <div style="font-size: 60px;margin-top: 60px; margin-bottom: 20px;">🎉</div>
                <div class="bd_tit" style="color: #fff;">
                    BYD SEALION 6 DM-I 증정 <br/>이벤트 응모 완료
                </div>

                <div class="bd_txt_w" style="margin-top: 20px;">
                    <div class="big">무대에서 진행되는 경품 이벤트를 기대해주세요!</div>
                </div>

                <div class="btn_box" style="margin-top: 40px;">
                    <a href="/apply/step1" class="btn_st01">메인 페이지로 이동</a>
                </div>

            </div>
        </div>
    </div>

</body>
</html>