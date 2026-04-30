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
        .select-group { display: flex; gap: 10px; }
        .select-group select { flex: 1; }
        .notice-box { background: #f8f9fa; padding: 15px; border-radius: 8px; margin-bottom: 20px; font-size: 14px; color: #e50000; font-weight: bold; text-align: center; line-height: 1.4; border: 1px solid #ffcccc; }
    </style>
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

                    <div class="notice-box">
                        ※ 챌린지 및 시승 행사는 행사 기간(3일) 중<br>각각 1회에 한하여 참여 가능합니다.
                    </div>

                    <form action="/apply/applyProcess" method="post" id="applyForm2" onsubmit="return validateForm();">

                        <ul class="form_box">
                            <li>
                                <div class="gubun">주소</div>
                                <div class="input"><input type="text" name="address" placeholder="입력해 주세요." required></div>
                            </li>
                            <li>
                                <div class="gubun">전시장 정보</div>
                                <div class="input select-group">
                                    <select id="regionSelect" onchange="updateShops()" required>
                                        <option value="">지역 선택</option>
                                        <option value="서울">서울</option>
                                        <option value="경기">경기</option>
                                        <option value="인천">인천</option>
                                        <option value="강원">강원</option>
                                        <option value="충청/대전">충청/대전</option>
                                        <option value="전라/광주">전라/광주</option>
                                        <option value="경상/대구/부산/창원">경상/대구/부산/창원</option>
                                        <option value="제주">제주</option>
                                    </select>

                                    <select name="shopInfo" id="shopSelect" required>
                                        <option value="">전시장 선택</option>
                                        <!-- 지역 선택 시 여기에 옵션이 동적으로 생성됩니다. -->
                                    </select>
                                </div>
                            </li>
                            <li>
                                <div class="gubun">관심차량 정보</div>
                                <div class="input">
                                    <select name="carModel" required>
                                        <option value="">선택해 주세요.</option>
                                        <option value="BYD DOLPHIN">BYD DOLPHIN</option>
                                        <option value="BYD ATTO 3">BYD ATTO 3</option>
                                        <option value="BYD SEAL">BYD SEAL</option>
                                        <option value="BYD SEALION 7">BYD SEALION 7</option>
                                    </select>
                                </div>
                            </li>
                            <li>
                                <div class="gubun">시승 시간 선택</div>
                                <div class="input">
                                    <select name="testDriveTime" id="testDriveTime" required>
                                        <option value="시승 미신청" selected>시승 미신청</option>
                                        <option value="10:00">10:00</option>
                                        <option value="11:00">11:00</option>
                                        <option value="12:00">12:00</option>
                                        <option value="13:00">13:00</option>
                                        <option value="14:00">14:00</option>
                                        <option value="15:00">15:00</option>
                                        <option value="16:00">16:00</option>
                                        <option value="17:00">17:00</option>
                                        <option value="18:00">18:00</option>
                                        <option value="19:00">19:00</option>
                                    </select>
                                </div>
                            </li>
                        </ul>
                        <div class="terms-check">
                            <label>
                                <input type="checkbox" name="privacyAgree" id="privacyAgreeCheckbox" value="Y" required>
                                <span class="terms-check_box" aria-hidden="true"></span>
                                <span class="terms-check_label">개인정보 수집 및 이용 동의 (필수)</span>
                            </label>
                            <p>행사 참여 및 본인 확인을 위해 개인정보를 수집 및 이용합니다.</p>
                        </div>
                        <div class="terms-check">
                            <label>
                                <input type="checkbox" name="mktAgree" id="mktAgreeCheckbox" value="Y" required>
                                <span class="terms-check_box" aria-hidden="true"></span>
                                <span class="terms-check_label">마케팅 정보 수신 동의 (필수)</span>
                            </label>
                            <p>행사 안내 및 원활한 이벤트 정보 제공을 위해 마케팅 정보를 수신합니다.</p>
                        </div>
                        <div class="btn_box">
                            <button type="submit" class="btn_st01">제출</button>
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
        const shopData = {
            "서울": [ "BYD 강동", "BYD 강서", "BYD 마포", "BYD 목동", "BYD 서초", "BYD 송파", "BYD 용산" ],
            "경기": [ "BYD 김포", "BYD 동탄", "BYD 부천", "BYD 분당", "BYD 수원", "BYD 스타필드 안성", "BYD 스타필드 운정", "BYD 스타필드 일산", "BYD 스타필드 하남", "BYD 안양", "BYD 의정부", "BYD 일산" ],
            "인천": [ "BYD 서해구", "BYD 송도" ],
            "강원": [ "BYD 원주" ],
            "충청/대전": [ "BYD 대전", "BYD 천안", "BYD 청주" ],
            "전라/광주": [ "BYD 광주", "BYD 전주" ],
            "경상/대구/부산/창원": [ "BYD 대구", "BYD 부산 동래", "BYD 수영", "BYD 스타필드 명지", "BYD 창원", "BYD 포항" ],
            "제주": [ "BYD 제주" ]
        };

        $(document).ready(function() {
            // 페이지 로드 시 예약 현황 체크
            checkDriveTimeAvailability();
        });

        // 전시장 업데이트
        function updateShops() {
            const regionSelect = document.getElementById("regionSelect");
            const shopSelect = document.getElementById("shopSelect");
            const selectedRegion = regionSelect.value;
            shopSelect.innerHTML = '<option value="">전시장 선택</option>';
            if (selectedRegion && shopData[selectedRegion]) {
                shopData[selectedRegion].forEach(function(shop) {
                    const option = document.createElement("option");
                    option.value = shop; option.text = shop;
                    shopSelect.appendChild(option);
                });
            }
        }

        // Ajax로 시간대별 예약자 마감 여부 확인
        function checkDriveTimeAvailability() {
            $.ajax({
                url: "/apply/getDriveTimeStatus",
                type: "GET",
                success: function(response) {
                    $('#testDriveTime option').each(function() {
                        var timeVal = $(this).val();
                        if(timeVal !== "시승 미신청" && response[timeVal] >= 4) {
                            $(this).prop('disabled', true);
                            $(this).text(timeVal + ' (마감)');
                        }
                    });
                },
                error: function(err) {
                    console.log("시간대 조회 실패");
                }
            });
        }
        
        // 폼 제출 시 유효성 검사
        function validateForm() {
            const regionSelect = document.getElementById("regionSelect");
            const shopSelect = document.getElementById("shopSelect");
            const carModel = document.querySelector("select[name='carModel']");
            const address = document.querySelector("input[name='address']");
            const privacyCheckbox = document.getElementById("privacyAgreeCheckbox");
            const mktCheckbox = document.getElementById("mktAgreeCheckbox");

            if(address.value.trim() === "") {
                alert("주소를 입력해 주세요.");
                address.focus();
                return false;
            }
            if(regionSelect.value === "") {
                alert("지역을 선택해 주세요.");
                regionSelect.focus();
                return false;
            }
            if(shopSelect.value === "") {
                alert("전시장 정보를 선택해 주세요.");
                shopSelect.focus();
                return false;
            }
            if(carModel.value === "") {
                alert("관심차량 정보를 선택해 주세요.");
                carModel.focus();
                return false;
            }

            if (!privacyCheckbox.checked) {
                alert("개인정보 수집 및 이용 동의(필수)에 체크해 주세요.");
                privacyCheckbox.focus();
                return false;
            }

            if (!mktCheckbox.checked) {
                alert("마케팅 정보 수신 동의(필수)에 체크해 주세요.");
                mktCheckbox.focus();
                return false;
            }

            return true;
        }
    </script>
</body>
</html>