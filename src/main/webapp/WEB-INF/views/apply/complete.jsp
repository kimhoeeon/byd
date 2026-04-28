<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" />
    <meta name="format-detection" content="telephone=no,email=no,address=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="mobile-web-app-capable" content="yes" />

    <meta property="og:type" content="website">
    <meta property="og:locale" content="ko_KR">
    <meta property="og:site_name" content="BYD">
    <%--<meta property="og:title" content="BYD | 야구 직관 기록 앱">
    <meta property="og:description" content="야구 직관 기록을 더 쉽고 재미있게! 경기 결과, 기록, 사진과 함께 나만의 야구 직관일기를 남겨보세요.">
    <meta name="keywords" content="BYD / 야구 직관 / 프로야구 직관 / 직관 후기 / 직관일기 / KBO / KBO 직관 / 프로야구 앱 / 야구팬 앱">
    <meta property="og:url" content="https://myseungyo.com/">
    <meta property="og:image" content="https://myseungyo.com/img/og_img.jpg">

    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="manifest" href="/site.webmanifest" />--%>

    <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />

    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/style.css">

    <title>BYD</title>

    <style>
        /* 완료 페이지 전용 인라인 스타일 (필요시 style.css로 이동) */
        .complete-wrap { text-align: center; color: #fff; padding: 40px 20px; }
        .complete-wrap h2 { font-size: 26px; font-weight: bold; margin-bottom: 10px; }
        .complete-wrap .desc { font-size: 16px; margin-bottom: 30px; opacity: 0.9; }
        .qr-box { background: #fff; padding: 20px; display: inline-block; border-radius: 15px; margin-bottom: 20px; }
        .qr-box img { display: block; width: 200px; height: 200px; }
        .valid-time { font-size: 14px; color: #aaa; margin-bottom: 40px; line-height: 1.5; }
        .valid-time span { display: block; color: #fff; font-weight: 500; margin-top: 5px; }
    </style>
</head>

<body>

    <!-- container -->
    <div id="container">
        <div class="ck-in">
            <div class="top_tit padding_tb">
                <div class="inner">
                    <div class="tit"><img src="/img/logo.png" alt="logo"></div>
                </div>
            </div>

            <div class="info_box complete-wrap">
                <div class="inner">
                    <h2>등록이 완료되었습니다</h2>
                    <c:choose>
                        <c:when test="${entryType eq 'DRIVE'}">
                            <p class="desc">시승 신청 내역이 문자로 발송되었습니다.</p>
                        </c:when>
                        <c:otherwise>
                            <p class="desc">아래 QR 코드를 현장 데스크에 보여주세요.</p>

                            <div class="qr-box">
                                <img src="${qrCodeUrl}" alt="QR Code">
                            </div>

                            <div class="valid-time">
                                QR 코드 유효기간
                                <span>${validTime}</span>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <div class="btn_box">
                        <a href="/event/main" class="btn_st01">HOME</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- //container -->

</body>
</html>