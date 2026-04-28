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
                    <form action="/event/applyProcess" method="post" id="applyForm">

                        <ul class="form_box">
                            <li>
                                <div class="gubun">주소</div>
                                <div class="input"><input type="text" name="address" placeholder="입력해 주세요."></div>
                            </li>
                            <li>
                                <div class="gubun">전시장 정보</div>
                                <div class="input">
                                    <select name="shopInfo">
                                        <option value="">선택해 주세요.</option>
                                        <option value="서울 강남 전시장">서울 강남 전시장</option>
                                        <option value="성남 분당 전시장">성남 분당 전시장</option>
                                        <option value="인천 송도 전시장">인천 송도 전시장</option>
                                    </select>
                                </div>
                            </li>
                            <li>
                                <div class="gubun">관심차량 정보</div>
                                <div class="input">
                                    <select name="carModel">
                                        <option value="">선택해 주세요.</option>
                                        <option value="BYD Seal">BYD Seal</option>
                                        <option value="BYD Han">BYD Han</option>
                                        <option value="BYD Qin Plus">BYD Qin Plus</option>
                                        <option value="BYD Destroyer 05">BYD Destroyer 05</option>
                                        <option value="BYD Atto 3">BYD Atto 3</option>
                                        <option value="BYD Song Plus">BYD Song Plus</option>
                                        <option value="BYD Tang">BYD Tang</option>
                                        <option value="BYD Yuan Plus">BYD Yuan Plus</option>
                                        <option value="BYD Sea Lion 07">BYD Sea Lion 07</option>
                                        <option value="BYD Denza D9">BYD Denza D9</option>
                                        <option value="BYD Xia">BYD Xia</option>
                                        <option value="BYD Shark">BYD Shark</option>
                                        <option value="BYD Fangchengbao Bao 5">BYD Fangchengbao Bao 5</option>
                                        <option value="D9">D9</option>
                                        <option value="N7">N7</option>
                                        <option value="Z9 GT">Z9 GT</option>
                                        <option value="Yangwang U8">Yangwang U8</option>
                                        <option value="Yangwang U9">Yangwang U9</option>
                                    </select>
                                </div>
                            </li>
                            <li>
                                <div class="gubun">시승 시간 선택</div>
                                <div class="input">
                                    <select name="testDriveTime">
                                        <option value="">선택해 주세요.</option>
                                        <option value="09:00">09:00</option>
                                        <option value="10:00">10:00</option>
                                        <option value="11:00">11:00</option>
                                    </select>
                                </div>
                            </li>
                        </ul>
                        <div class="terms-check">
                            <label>
                                <input type="checkbox" name="mktAgree" value="Y">
                                <span class="terms-check_box" aria-hidden="true"></span>
                                <span class="terms-check_label">마케팅 수신 동의</span>
                            </label>
                            <p>선택하신 정보는 마케팅 정보 제공을 위해 활용되며, <br />동의하지 않으셔도 서비스 이용에는 제한이 없습니다.</p>
                        </div>
                        <div class="terms-check">
                            <label>
                                <input type="checkbox" name="safetyAgree" value="Y" required>
                                <span class="terms-check_box" aria-hidden="true"></span>
                                <span class="terms-check_label">시승 안전 동의</span>
                            </label>
                            <p>시승 안전 안내 및 유의사항을 충분히 숙지하였으며, <br />이에 동의합니다.</p>
                        </div>
                        <div class="btn_box">
                            <button type="submit" class="btn_st01">SUBMIT</button>
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

</body>
</html>