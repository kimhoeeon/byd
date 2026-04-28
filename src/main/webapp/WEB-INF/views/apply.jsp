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
                    <ul class="form_box">
                        <li>
                            <div class="gubun">이름</div>
                            <div class="input"><input type="text" placeholder="입력해 주세요."></div>
                        </li>
                        <li>
                            <div class="gubun">연락처</div>
                            <div class="input tel">
                                <input type="tel" placeholder="입력해 주세요." class="onlyTel">
                                <button class="phone-cert">
                                    중복확인
                                </button>
                            </div>
                        </li>
                        <li>
                            <div class="gubun">주소</div>
                            <div class="input"><input type="text" placeholder="입력해 주세요."></div>
                        </li>
                        <li>
                            <div class="gubun">전시장 정보</div>
                            <div class="input">
                                <select>
                                    <option>선택해 주세요.</option>
                                    <option>서울 강남 전시장</option>
                                    <option>성남 분당 전시장</option>
                                    <option>인천 송도 전시장</option>
                                </select>
                            </div>
                        </li>
                        <li>
                            <div class="gubun">관심차량 정보</div>
                            <div class="input">
                                <select>
                                    <option>선택해 주세요.</option>
                                    <option>BYD Seal</option>
                                    <option>BYD Han</option>
                                    <option>BYD Qin Plus</option>
                                    <option>BYD Destroyer 05</option>
                                    <option>BYD Atto 3</option>
                                    <option>BYD Song Plus</option>
                                    <option>BYD Tang</option>
                                    <option>BYD Yuan Plus</option>
                                    <option>BYD Sea Lion 07</option>
                                    <option>BYD Denza D9</option>
                                    <option>BYD Xia</option>
                                    <option>BYD Shark</option>
                                    <option>BYD Fangchengbao Bao 5</option>
                                    <option>D9</option>
                                    <option>N7</option>
                                    <option>Z9 GT</option>
                                    <option>Yangwang U8</option>
                                    <option>Yangwang U9</option>
                                </select>
                            </div>
                        </li>
                        <li>
                            <div class="gubun">시승 시간 선택</div>
                            <div class="input">
                                <select>
                                    <option>선택해 주세요.</option>
                                    <option>09:00</option>
                                    <option>10:00</option>
                                    <option>11:00</option>
                                </select>
                            </div>
                        </li>
                    </ul>
                    <div class="terms-check">
                        <label>
                            <input type="checkbox" id="">
                            <span class="terms-check_box" aria-hidden="true"></span>
                            <span class="terms-check_label">
                                    마케팅 수신 동의
                                </span>
                        </label>
                        <p>선택하신 정보는 마케팅 정보 제공을 위해 활용되며, <br />동의하지 않으셔도 서비스 이용에는 제한이 없습니다.</p>
                    </div>
                    <div class="terms-check">
                        <label>
                            <input type="checkbox" id="">
                            <span class="terms-check_box" aria-hidden="true"></span>
                            <span class="terms-check_label">
                                    시승 안전 동의
                                </span>
                        </label>
                        <p>시승 안전 안내 및 유의사항을 충분히 숙지하였으며, <br />이에 동의합니다.</p>
                    </div>
                    <div class="btn_box">
                        <a href="main/main.html" class="btn_st01">SUBMIT</a>
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