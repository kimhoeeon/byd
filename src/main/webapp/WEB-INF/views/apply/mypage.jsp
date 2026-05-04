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
    <meta property="og:url" content="https://meetingtest.store/">
    <meta property="og:image" content="https://meetingtest.store/img/og_img.jpg">

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

                    <h2 style="color:#fff; font-size:20px; margin-bottom:20px; text-align:center;">모바일 시승 티켓</h2>

                    <!-- QR 코드 영역 및 1회 참여 조건 문구 -->
                    <div style="text-align: center; background-color: #fff; padding: 20px; border-radius: 10px; margin-bottom: 25px;">
                        <p style="color: #333; font-weight: bold; margin-bottom: 10px;">현장 데스크에 아래 QR 코드를 제시해 주세요.</p>
                        <img src="${qrCodeImgUrl}" alt="QR Code" style="width: 200px; height: 200px;"/>
                        <p style="color: #e50000; font-size: 14px; margin-top: 10px; font-weight:bold; line-height: 1.4;">
                            [유효기간] 예약하신 시승 시간 (${data.testDriveTime}) 까지 유효합니다.<br><br>
                            ※ 챌린지 및 시승 행사는 행사 기간(3일) 중<br>각각 1회에 한하여 참여 가능합니다.
                        </p>
                    </div>

                    <form id="updateForm">
                        <ul class="form_box">
                            <li>
                                <div class="gubun">이름</div>
                                <div class="input"><input type="text" id="name" name="name" value="${data.name}" readonly style="background-color:#f5f5f5;"></div>
                            </li>
                            <li>
                                <div class="gubun">연락처</div>
                                <div class="input">
                                    <input type="text" id="phone" name="phone" value="${data.phone}" readonly style="background-color:#f5f5f5;"></div>
                            </li>
                            <li>
                                <div class="gubun">주소</div>
                                <div class="input">
                                    <label for="baseAddress">
                                        <input type="text" id="baseAddress" value="${data.address}" placeholder="주소찾기를 진행해 주세요." readonly style="background-color:#f5f5f5; flex: 1;">
                                        <button type="button" class="btn-search-addr" onclick="execDaumPostcode()">주소 찾기</button>
                                    </label>
                                    <div class="input mt-10">
                                        <input type="text" id="detailAddress" placeholder="새로 주소를 검색할 경우 상세 주소를 입력해 주세요.">
                                        <input type="hidden" name="address" id="fullAddress" value="${data.address}">
                                    </div>
                                </div>
                            </li>
                            <li>
                                <div class="gubun">전시장 정보</div>
                                <div class="row">
                                    <div class="input">
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
                                    </div>
                                    <div class="input">
                                        <select name="shopInfo" id="shopSelect" required>
                                            <option value="">전시장 선택</option>
                                            <!-- 지역 선택 시 또는 초기화 스크립트를 통해 옵션이 생성됩니다. -->
                                        </select>
                                    </div>
                                </div>
                            </li>
                            <li>
                                <div class="gubun">관심차량 정보</div>
                                <div class="input">
                                    <select name="carModel" required>
                                        <option value="">선택해 주세요.</option>
                                        <option value="BYD DOLPHIN" <c:if test="${data.carModel == 'BYD DOLPHIN'}">selected</c:if>>BYD DOLPHIN</option>
                                        <option value="BYD ATTO 3" <c:if test="${data.carModel == 'BYD ATTO 3'}">selected</c:if>>BYD ATTO 3</option>
                                        <option value="BYD SEAL" <c:if test="${data.carModel == 'BYD SEAL'}">selected</c:if>>BYD SEAL</option>
                                        <option value="BYD SEALION 7" <c:if test="${data.carModel == 'BYD SEALION 7'}">selected</c:if>>BYD SEALION 7</option>
                                    </select>
                                </div>
                            </li>
                            <li>
                                <div class="gubun">시승 시간 선택</div>
                                <div class="input">
                                    <select name="testDriveTime" id="testDriveTime" required>
                                        <option value="시승 미신청" <c:if test="${data.testDriveTime == '시승 미신청'}">selected</c:if>>시승 미신청</option>
                                        <option value="10:00" <c:if test="${data.testDriveTime == '10:00'}">selected</c:if>>10:00</option>
                                        <option value="11:00" <c:if test="${data.testDriveTime == '11:00'}">selected</c:if>>11:00</option>
                                        <option value="12:00" <c:if test="${data.testDriveTime == '12:00'}">selected</c:if>>12:00</option>
                                        <option value="13:00" <c:if test="${data.testDriveTime == '13:00'}">selected</c:if>>13:00</option>
                                        <option value="14:00" <c:if test="${data.testDriveTime == '14:00'}">selected</c:if>>14:00</option>
                                        <option value="15:00" <c:if test="${data.testDriveTime == '15:00'}">selected</c:if>>15:00</option>
                                        <option value="16:00" <c:if test="${data.testDriveTime == '16:00'}">selected</c:if>>16:00</option>
                                        <option value="17:00" <c:if test="${data.testDriveTime == '17:00'}">selected</c:if>>17:00</option>
                                        <option value="18:00" <c:if test="${data.testDriveTime == '18:00'}">selected</c:if>>18:00</option>
                                        <option value="19:00" <c:if test="${data.testDriveTime == '19:00'}">selected</c:if>>19:00</option>
                                    </select>
                                </div>
                            </li>
                        </ul>
                        <div class="terms-check">
                            <label>
                                <input type="checkbox" checked disabled>
                                <input type="hidden" name="privacyAgree" value="Y">
                                <span class="terms-check_box" aria-hidden="true"></span>
                                <span class="terms-check_label">개인정보 수집 및 이용 동의 (필수)</span>
                            </label>
                            <p>행사 참여 및 본인 확인을 위해 개인정보를 수집 및 이용합니다.</p>
                        </div>
                        <div class="terms-check">
                            <label>
                                <input type="checkbox" checked disabled>
                                <input type="hidden" name="mktAgree" value="Y">
                                <span class="terms-check_box" aria-hidden="true"></span>
                                <span class="terms-check_label">마케팅 정보 수신 동의 (필수)</span>
                            </label>
                            <p>행사 안내 및 원활한 이벤트 정보 제공을 위해 마케팅 정보를 수신합니다.</p>
                        </div>
                    </form>
                    <div class="btn_box">
                        <button type="button" id="btnUpdate" class="btn_st01">정보 수정하기</button>
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

    <!-- Daum 우편번호 API -->
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

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

        // 서버에서 받아온 기존 지점 데이터
        const currentShopInfo = "${data.shopInfo}";

        $(document).ready(function() {
            // 1. 기존 데이터에 맞춰 지역 및 전시장 초기화
            initRegionAndShop();

            // 2. 예약 현황 체크 및 안전동의 영역 가시성 초기화
            checkDriveTimeAvailability();

            // 3. 정보 수정 버튼 클릭 이벤트
            $("#btnUpdate").on("click", function(e) {
                e.preventDefault();

                // 폼 유효성 검사 통과 시
                if(validateCombinedForm()) {
                    if(confirm("입력하신 정보로 시승 예약을 수정하시겠습니까?")) {
                        var formData = $("#updateForm").serialize();

                        $.ajax({
                            type: "POST",
                            url: "/apply/updateAjax", // EventController에 추가된 AJAX 전용 API 호출
                            data: formData,
                            success: function(response) {
                                if(response.success) {
                                    alert(response.message);
                                    location.reload(); // 성공 시 페이지 새로고침하여 변경된 내용 갱신
                                } else {
                                    alert(response.message); // 정원 초과 등 백엔드 검증 실패 메시지 노출
                                }
                            },
                            error: function(xhr, status, error) {
                                alert("수정 중 오류가 발생했습니다. 다시 시도해주세요.");
                                console.error("Error:", error);
                            }
                        });
                    }
                }
            });
        });

        // Daum 주소 찾기 실행 함수
        function execDaumPostcode() {
            new daum.Postcode({
                oncomplete: function(data) {
                    var addr = '';

                    if (data.userSelectedType === 'R') {
                        addr = data.roadAddress;
                    } else {
                        addr = data.jibunAddress;
                    }

                    document.getElementById("baseAddress").value = addr;
                    document.getElementById("detailAddress").value = "";
                    document.getElementById("detailAddress").focus();
                }
            }).open();
        }

        // 저장된 지점명으로 지역을 찾아 Select Box를 세팅하는 함수
        function initRegionAndShop() {
            if (currentShopInfo) {
                for (const region in shopData) {
                    if (shopData[region].includes(currentShopInfo)) {
                        $("#regionSelect").val(region); // 지역 세팅
                        updateShops(); // 지점 목록 생성
                        $("#shopSelect").val(currentShopInfo); // 지점 세팅
                        break;
                    }
                }
            }
        }

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

        // Ajax로 시간대별 예약자 4명 마감 여부 확인
        function checkDriveTimeAvailability() {
            $.ajax({
                url: "/apply/getDriveTimeStatus",
                type: "GET",
                success: function(response) {
                    $('#testDriveTime option').each(function() {
                        var timeVal = $(this).val();
                        // 내 기존 예약 시간은 disabled 처리하지 않음
                        if(timeVal !== "시승 미신청" && timeVal !== "${data.testDriveTime}" && response[timeVal] >= 4) {
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

        // 폼 통합 유효성 검사 (이름, 연락처 검증 제외)
        function validateCombinedForm() {
            const regionSelect = document.getElementById("regionSelect");
            const shopSelect = document.getElementById("shopSelect");
            const carModel = document.querySelector("select[name='carModel']");
            const baseAddress = document.getElementById("baseAddress").value.trim();
            const detailAddress = document.getElementById("detailAddress").value.trim();

            if(baseAddress === "") {
                alert("주소 찾기를 진행해 주세요.");
                return false;
            }

            // 기존 주소에서 새롭게 주소를 검색(변경)한 경우 상세주소를 필수 입력받음
            if(baseAddress !== originalAddress && detailAddress === "") {
                alert("상세 주소를 입력해 주세요.");
                document.getElementById("detailAddress").focus();
                return false;
            }

            // 변경된 상세주소가 있으면 합치고, 없으면 기본 baseAddress(또는 기존 주소)만 전송
            if(detailAddress !== "") {
                document.getElementById("fullAddress").value = baseAddress + " " + detailAddress;
            } else {
                document.getElementById("fullAddress").value = baseAddress;
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

            return true;
        }
    </script>
</body>
</html>