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
    <meta property="og:image" content="https://bydsmrun26.co.kr/img/og_img.jpg?ver=20260918">

    <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />

    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/style.css?ver=20260918">

    <!-- SweetAlert2 CDN -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <title>BYD</title>

</head>

<body class="apply_w">

    <!-- container -->
    <div id="container">
    
        <!-- check-in -->
        <div class="ck-in center">

            <!-- title -->
            <div class="top_tit padding_tb">
                <div class="inner">
                    <div class="tit">
                        <img src="/img/logo_w.png?ver=20260929" alt="logo">
                    </div>
                </div>
            </div>
            <!-- //title -->

            <!-- info -->
            <div class="info_box padding_b">
                <div class="inner">
                    <ul class="form_box">
                        <li>
                            <div class="gubun">응모 자격 안내</div>
                            <div class="input nae">
                                <textarea readonly>이벤트 응모일 기준 만 19세 이상의 국내 거주자로, 본인 명의의 연락처를 통해 응모하고 당첨 시 본인 확인, 경품 관련 세금 처리, 국내 차량 등록 및 지정 장소에서의 인수가 가능한 분에 한합니다.&#10;&#10;BYD코리아 및 본 이벤트 운영 관계사의 임직원과 그 직계가족은 응모 대상에서 제외합니다.</textarea>
                            </div>
                        </li>
                        <li>
                            <div class="gubun">경품 지급 안내</div>
                            <div class="input nae">
                                <textarea readonly>- 중복 응모, 타인 명의 응모, 허위 정보 제출, 부정한 방법의 참여 시 당첨 취소&#10;- 당첨 통보 후 정해진 기간 내 (~10/8 6:00 PM) 전화 연락이 3회 이상 닿지 않거나 필요 서류를 제출하지 않으면 당첨 취소&#10;- 당첨 경품인 BYD SEALION 6 DM-i는 현금 또는 다른 상품으로 대체할 수 없으며, 당첨 권리 및 차량 인수 권리를 타인에게 양도할 수 없습니다.&#10;- 경품 지급에 따른 제세공과금은 당첨자 본인 부담이며, 당첨자 본인 명의로 차량을 등록·인수해야 합니다. </textarea>
                            </div>
                        </li>
                    </ul>
                    <div class="btn_box">
                        <%--<button type="button" class="btn_st01" onclick="location.href='/apply/step1'">다음</button>--%>
                        <button type="button" class="btn_st01" onclick="location.href='/apply/form'">다음</button>
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