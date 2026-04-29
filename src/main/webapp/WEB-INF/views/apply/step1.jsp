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
        <div class="ck-in center">

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
                    <form action="/apply/checkParticipant" method="post" id="applyForm">

                        <ul class="form_box">
                            <li>
                                <div class="gubun">이름</div>
                                <div class="input"><input type="text" id="name" name="name" placeholder="입력해 주세요." required></div>
                            </li>
                            <li>
                                <div class="gubun">연락처</div>
                                <div class="input">
                                    <input type="text" id="phone" name="phone" placeholder="입력해 주세요. (숫자만)" class="onlyTel" required>
                                </div>
                            </li>
                        </ul>
                        <div class="btn_box">
                            <button type="button" class="btn_st01" onclick="submitStep1();">NEXT</button>
                        </div>
                    </form>
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
    <script>
        function submitStep1() {
            var name = document.getElementById("name").value.trim();
            var phone = document.getElementById("phone").value.trim();

            if (name === "") {
                alert("이름을 입력해 주세요.");
                document.getElementById("name").focus();
                return false;
            }

            if (phone === "") {
                alert("연락처를 입력해 주세요.");
                document.getElementById("phone").focus();
                return false;
            }

            // 연락처 숫자만 입력되었는지 간단한 정규식 체크 (선택 사항)
            var phoneRegex = /^[0-9]{10,11}$/;
            if (!phoneRegex.test(phone.replace(/-/g, ''))) {
                alert("올바른 연락처 형식이 아닙니다.");
                document.getElementById("phone").focus();
                return false;
            }

            document.getElementById("applyForm").submit();
        }
    </script>
</body>
</html>