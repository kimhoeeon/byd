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
    <meta property="og:url" content="https://byd-hyroxevent.kr/">
    <meta property="og:image" content="https://byd-hyroxevent.kr/img/og_img.jpg">

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
                    <form id="applyForm" onsubmit="event.preventDefault(); submitStep1();">

                        <ul class="form_box">
                            <li>
                                <div class="gubun">이름</div>
                                <div class="input"><input type="text" id="name" name="name" placeholder="입력해 주세요." required></div>
                            </li>
                            <li>
                                <div class="gubun">연락처</div>
                                <div class="input">
                                    <input type="tel" id="phone" name="phone" placeholder="입력해 주세요. (숫자만)" class="onlyTel" maxlength="13" required>
                                </div>
                            </li>
                        </ul>
                        <div class="btn_box">
                            <button type="button" class="btn_st01" onclick="submitStep1();">다음</button>
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

        $(document).ready(function() {

            // 이름 입력 시 띄어쓰기(공백) 실시간 자동 제거
            $('#name').on('input', function() {
                var val = $(this).val().replace(/\s/g, ''); // 정규식을 사용해 모든 공백 제거
                $(this).val(val);
            });

            // 연락처 입력 시 자동 하이픈 및 숫자 이외의 문자 입력 방지
            $('#phone').on('input', function() {
                // 입력된 값에서 숫자 이외의 문자 모두 제거
                var val = $(this).val().replace(/[^0-9]/g, '');

                // 최대 11자리까지만 입력 허용
                if (val.length > 11) {
                    val = val.substring(0, 11);
                }

                var formatted = '';
                if (val.length < 4) {
                    formatted = val;
                } else if (val.length < 7) {
                    formatted = val.substring(0, 3) + '-' + val.substring(3);
                } else if (val.length < 11) {
                    formatted = val.substring(0, 3) + '-' + val.substring(3, 6) + '-' + val.substring(6);
                } else {
                    formatted = val.substring(0, 3) + '-' + val.substring(3, 7) + '-' + val.substring(7);
                }

                // 변환된 값을 다시 인풋 박스에 세팅
                $(this).val(formatted);
            });
        });

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

            // 연락처 숫자만 입력되었는지 간단한 정규식 체크 (하이픈 제외 후 검증)
            var phoneRegex = /^[0-9]{10,11}$/;
            if (!phoneRegex.test(phone.replace(/-/g, ''))) {
                alert("올바른 연락처 형식이 아닙니다.");
                document.getElementById("phone").focus();
                return false;
            }

            // 폼 서밋 대신 AJAX 통신으로 서버에 확인
            $.ajax({
                type: "POST",
                url: "/apply/checkParticipant",
                data: {
                    name: name,
                    phone: phone
                },
                dataType: "json",
                success: function(response) {
                    if(response.error) {
                        alert("처리 중 서버 오류가 발생했습니다.");
                        return;
                    }

                    if(response.exists) {
                        // 기존 신청자일 경우 Alert 띄우고 전달받은 URL로 이동
                        alert("이미 시승 신청이 완료된 고객입니다.\n모바일 티켓 화면으로 이동합니다.");
                        location.href = response.redirectUrl;
                    } else {
                        // 신규 신청자일 경우 step2 페이지로 이동
                        location.href = "/apply/step2";
                    }
                },
                error: function() {
                    alert("서버와의 통신에 실패했습니다. 다시 시도해 주세요.");
                }
            });
        }
    </script>
</body>
</html>