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
    <%--<meta property="og:title" content="BYD | 야구 직관 기록 앱">
    <meta property="og:description" content="야구 직관 기록을 더 쉽고 재미있게! 경기 결과, 기록, 사진과 함께 나만의 야구 직관일기를 남겨보세요.">
    <meta name="keywords" content="BYD / 야구 직관 / 프로야구 직관 / 직관 후기 / 직관일기 / KBO / KBO 직관 / 프로야구 앱 / 야구팬 앱">
    <meta property="og:url" content="https://meetingtest.store/">
    <meta property="og:image" content="https://meetingtest.store/img/og_img.jpg">

    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="manifest" href="/site.webmanifest" />--%>

    <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css"/>

    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/style.css">

    <title>BYD</title>

    <c:if test="${empty applyCompleteFlag}">
        <script>
            alert("잘못된 접근입니다.\n신청 페이지로 이동합니다.");
            location.replace("/apply/step1");
        </script>
    </c:if>

</head>

<body class="success">

    <header id="header">
        <div class="inner">
            <a href="/apply/step1" class="logo">
                <img src="/img/logo.png" alt="BYD">
            </a>
        </div>
    </header>

    <div id="container" style="padding-top: 60px;">
        <div class="info_box padding_tb" style="color: #fff;">
            <div class="inner" style="text-align: center;">

                <div style="font-size: 60px; margin-bottom: 20px;">🎉</div>
                <div class="bd_tit" style="color: #bb0a0a;">
                    신청 완료
                </div>

                <div class="bd_txt_w" style="margin-top: 20px;">
                    <div class="big">시승 신청이 성공적으로 접수되었습니다.</div>
                    <p style="color: #CBCBCA; line-height: 1.6; margin-top: 15px;">
                        입력하신 연락처로 <span style="color: #fff; font-weight: bold;">모바일 티켓(QR) 링크</span>가 발송되었습니다.<br><br>
                        현장 데스크에 방문하셔서<br>
                        문자로 받으신 모바일 티켓을 보여주시면<br>
                        빠르게 시승 안내를 도와드리겠습니다.
                    </p>
                </div>

                <div class="nt_box" style="text-align: left; background-color: #202020; padding: 25px 20px; border-radius: 10px;">
                    <div class="txt">
                        <p>문자를 받지 못하셨다면 스팸 메일함을 확인해 주세요.</p>
                        <p>행사 당일 원활한 진행을 위해 예약 시간을 준수해 주시기 바랍니다.</p>
                    </div>
                </div>

                <div class="btn_box" style="margin-top: 40px;">
                    <a href="/apply/step1" class="btn_st01">처음으로 돌아가기</a>
                </div>

            </div>
        </div>
    </div>

</body>
</html>