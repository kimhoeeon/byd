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

</head>

<body>

    <!-- container -->
    <div id="container">

        <!-- check-in -->
        <div class="ck-in">

            <!-- title -->
            <div class="top_tit padding_tb">
                <div class="inner">
                    <div class="tit">
                        <img src="/img/logo.png" alt="logo">
                    </div>
                </div>
            </div>
            <!-- //title -->

            <!-- info -->
            <div class="info_box padding_b">
                <div class="inner">

                    <h2 style="color:#fff; font-size:20px; margin-bottom:20px; text-align:center;">모바일 시승 티켓</h2>

                    <!-- [추가] QR 코드 영역 -->
                    <div style="text-align: center; background-color: #fff; padding: 20px; border-radius: 10px; margin-bottom: 25px;">
                        <p style="color: #333; font-weight: bold; margin-bottom: 10px;">현장 데스크에 아래 QR 코드를 제시해 주세요.</p>
                        <img src="${qrCodeImgUrl}" alt="QR Code" style="width: 200px; height: 200px;"/>
                        <p style="color: #e50000; font-size: 14px; margin-top: 10px; font-weight:bold;">
                            [유효기간] 예약하신 시승 시간 (${data.testDriveTime}) 까지 유효합니다.
                        </p>
                    </div>

                    <ul class="form_box">
                        <li>
                            <div class="gubun">이름</div>
                            <div class="input"><input type="text" value="${data.name}" readonly style="background-color:#f5f5f5;"></div>
                        </li>
                        <li>
                            <div class="gubun">연락처</div>
                            <div class="input">
                                <input type="text" name="phone" value="${data.phone}" readonly style="background-color:#f5f5f5;"></div>
                        </li>
                        <li>
                            <div class="gubun">주소</div>
                            <div class="input"><input type="text" value="${empty data.address ? '-' : data.address}" readonly style="background-color:#f5f5f5;"></div>
                        </li>
                        <li>
                            <div class="gubun">전시장 정보</div>
                            <div class="input"><input type="text" value="${empty data.shopInfo ? '-' : data.shopInfo}" readonly style="background-color:#f5f5f5;"></div>
                        </li>
                        <li>
                            <div class="gubun">관심차량 정보</div>
                            <div class="input"><input type="text" value="${empty data.carModel ? '-' : data.carModel}" readonly style="background-color:#f5f5f5;"></div>
                        </li>
                        <li>
                            <div class="gubun">시승 시간 선택</div>
                            <div class="input"><input type="text" value="${empty data.testDriveTime ? '-' : data.testDriveTime}" readonly style="background-color:#f5f5f5;"></div>
                        </li>
                    </ul>
                    <div class="terms-check">
                        <label>
                            <input type="checkbox" checked disabled>
                            <span class="terms-check_box" aria-hidden="true"></span>
                            <span class="terms-check_label">마케팅 수신 동의 <span style="color:#009ef7;">(${data.mktAgree})</span></span>
                        </label>
                        <p>선택하신 정보는 마케팅 정보 제공을 위해 활용되며, <br />동의하지 않으셔도 서비스 이용에는 제한이 없습니다.</p>
                    </div>
                    <div class="terms-check">
                        <label>
                            <input type="checkbox" checked disabled>
                            <span class="terms-check_box" aria-hidden="true"></span>
                            <span class="terms-check_label">시승 안전 동의 <span style="color:#009ef7;">(${data.safetyAgree})</span></span>
                        </label>
                        <p>시승 안전 안내 및 유의사항을 충분히 숙지하였으며, <br />이에 동의합니다.</p>
                    </div>
                    <div class="btn_box">
                        <a href="/apply/step1" class="btn_st01">확인 (HOME)</a>
                    </div>
                </div>
            </div>
            <!-- //info -->

        </div>
        <!-- //check-in -->

    </div>
    <!-- //container -->

    <script src="https://unpkg.com/swiper@7/swiper-bundle.min.js"></script>
    <script src="/js/jquery-1.9.1.min.js"></script>
    <script src="https://code.jquery.com/ui/1.13.0/jquery-ui.js"></script>
    <script src="/js/jquery.cookie.min.js"></script>
    <script src="/js/jquery.ui.touch-punch.min.js"></script>
    <script src="/js/script.js"></script>

</body>
</html>