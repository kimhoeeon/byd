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
                <img src="/img/logo_g.png?ver=20260921" alt="BYD">
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
                    <p style="color: #fff; line-height: 1.6; margin-top: 15px;">
                        입력하신 연락처로 발송된 <br/><span style="color: #fff; font-weight: bold;">모바일 티켓(QR) 링크</span>를 확인해주세요. <br/>인증 QR을 인포데스크에 보여주시면 기프트를 드립니다.
                    </p>
                </div>

                <div class="nt_box" style="text-align: center; background-color: #333333; padding: 25px 20px; border-radius: 10px;margin-top:30px">
                    <div class="txt">
                        <p>문자를 받지 못하셨다면 스팸 메일함을 확인해 주세요.</p>
                    </div>
                </div>

                <div class="btn_box" style="margin-top: 40px;">
                    <a href="/apply/step1" class="btn_st01">메인 페이지로 이동</a>
                </div>

            </div>
        </div>
    </div>

</body>
</html>