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

    <style>
        /* readonly 인풋 박스 스타일링 (비활성화 느낌 부여) */
        input[readonly] { background-color: #2a2a2a !important; color: #888 !important; outline: none; }
    </style>
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

                    <h2 style="color:#fff; font-size:20px; margin-bottom:20px; text-align:center;">이벤트 참여 티켓</h2>

                    <!-- QR 코드 영역 및 1회 참여 조건 문구 -->
                    <div style="text-align: center; background-color: #fff; padding: 20px; border-radius: 10px; margin-bottom: 25px;">
                        <p style="color: #333; font-weight: bold; margin-bottom: 10px;">아래 QR 코드를 제시해 주세요.</p>

                        <!-- 구글 API 이미지 태그 삭제 후 클라이언트 렌더링용 div 추가 -->
                        <div id="qrcode" style="display: flex; justify-content: center; margin: 15px 0;"></div>

                        <p style="color: #333; font-size: 14px; margin-top: 10px; font-weight:bold; line-height: 1.4;">
                            ▶ 시승 신청 내용 : ${data.testDriveTime} / ${data.carModel}
                        </p>
                        <p style="color: #e50000; font-size: 14px; margin-top: 10px; font-weight:bold; line-height: 1.4;">
                            ※ 신청 타임 시작 15분 전까지 BYD부스 돌핀 포토존 앞 집합존으로 방문해주시기 바랍니다.
                        </p>
                    </div>

                    <form id="updateForm">
                        <input type="hidden" name="seq" value="${data.seq}">

                        <c:set var="emailParts" value="${fn:split(data.email, '@')}" />
                        <c:set var="savedEmailId" value="${emailParts[0]}" />
                        <c:set var="savedEmailDomain" value="${fn:length(emailParts) > 1 ? emailParts[1] : ''}" />
                        <c:set var="isCustomDomain" value="${not empty savedEmailDomain and savedEmailDomain ne 'naver.com' and savedEmailDomain ne 'google.com' and savedEmailDomain ne 'hanmail.net' and savedEmailDomain ne 'nate.com'}" />

                        <input type="hidden" name="email" id="fullEmail" value="${data.email}">

                        <ul class="form_box">
                            <li>
                                <div class="gubun">이름</div>
                                <div class="input"><input type="text" id="name" name="name" value="${data.name}" readonly style="color: #888;"></div>
                            </li>
                            <li>
                                <div class="gubun">연락처</div>
                                <div class="input">
                                    <input type="text" id="phone" name="phone" value="${data.phone}" readonly style="color: #888;"></div>
                            </li>
                            <li>
                                <div class="gubun">이메일</div>
                                <div class="row email">
                                    <input type="text" id="emailId" value="${savedEmailId}" placeholder="이메일 주소">
                                    <span>@</span>
                                    <input type="text" id="customDomain" value="${savedEmailDomain}" placeholder="도메인 입력" ${isCustomDomain ? '' : 'readonly'}>
                                    <div class="input">
                                        <select id="emailDomain">
                                            <option value="">이메일 선택</option>
                                            <option value="naver.com" <c:if test="${savedEmailDomain == 'naver.com'}">selected</c:if>>naver.com</option>
                                            <option value="google.com" <c:if test="${savedEmailDomain == 'google.com'}">selected</c:if>>google.com</option>
                                            <option value="hanmail.net" <c:if test="${savedEmailDomain == 'hanmail.net'}">selected</c:if>>hanmail.net</option>
                                            <option value="nate.com" <c:if test="${savedEmailDomain == 'nate.com'}">selected</c:if>>nate.com</option>
                                            <option value="direct" <c:if test="${isCustomDomain}">selected</c:if>>직접 입력</option>
                                        </select>
                                    </div>
                                </div>
                            </li>
                            <li>
                                <div class="gubun">방문 가능 전시장</div>
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
                                <span class="terms-check_box" aria-hidden="true"></span>
                                <span class="terms-check_label">개인정보 수집 및 이용 동의 (필수)</span>
                            </label>
                            <textarea readonly>시승 신청 및 원활한 안내를 위해 아래와 같이 개인정보를 수집·이용하고자 합니다. &#10;내용을 충분히 확인하신 후 동의 여부를 선택해 주시기 바랍니다.&#10;&#10;수집 항목: 이름, 연락처, 이메일, 시승 희망 차량, 시승 희망 일정 등&#10;수집 목적: 시승 예약 확인, 일정 조율, 안내 및 고객 응대&#10;보유 및 이용 기간: 시승 완료일로부터 일정 기간 보관 후 관련 법령에 따라 안전하게 파기&#10;&#10;귀하는 개인정보 수집 및 이용에 대한 동의를 거부할 권리가 있으며,&#10;동의를 거부할 경우 시승 신청 및 안내 서비스 이용이 제한될 수 있습니다.&#10;&#10;위 내용을 확인하였으며, 시승 진행을 위한 개인정보 수집 및 이용에 동의합니다.</textarea>
                        </div>
                        <div class="terms-check">
                            <label>
                                <input type="checkbox" checked disabled>
                                <span class="terms-check_box" aria-hidden="true"></span>
                                <span class="terms-check_label">마케팅 정보 수신 동의 (필수)</span>
                            </label>
                            <textarea readonly>시승 신청 및 원활한 안내를 위해 아래와 같이 개인정보를 수집·이용하고자 합니다. &#10;내용을 충분히 확인하신 후 동의 여부를 선택해 주시기 바랍니다.&#10;&#10;수집 항목: 이름, 연락처, 이메일, 시승 희망 차량, 시승 희망 일정 등&#10;수집 목적: 시승 예약 확인, 일정 조율, 안내 및 고객 응대&#10;보유 및 이용 기간: 시승 완료일로부터 일정 기간 보관 후 관련 법령에 따라 안전하게 파기&#10;&#10;귀하는 개인정보 수집 및 이용에 대한 동의를 거부할 권리가 있으며,&#10;동의를 거부할 경우 시승 신청 및 안내 서비스 이용이 제한될 수 있습니다.&#10;&#10;위 내용을 확인하였으며, 시승 진행을 위한 개인정보 수집 및 이용에 동의합니다.</textarea>
                        </div>
                        <div class="terms-check">
                            <label>
                                <input type="checkbox" checked disabled>
                                <span class="terms-check_box" aria-hidden="true"></span>
                                <span class="terms-check_label">제 3자 정보 제공 동의 (필수)</span>
                            </label>
                            <textarea readonly>시승 신청 및 원활한 안내를 위해 아래와 같이 개인정보를 수집·이용하고자 합니다. &#10;내용을 충분히 확인하신 후 동의 여부를 선택해 주시기 바랍니다.&#10;&#10;수집 항목: 이름, 연락처, 이메일, 시승 희망 차량, 시승 희망 일정 등&#10;수집 목적: 시승 예약 확인, 일정 조율, 안내 및 고객 응대&#10;보유 및 이용 기간: 시승 완료일로부터 일정 기간 보관 후 관련 법령에 따라 안전하게 파기&#10;&#10;귀하는 개인정보 수집 및 이용에 대한 동의를 거부할 권리가 있으며,&#10;동의를 거부할 경우 시승 신청 및 안내 서비스 이용이 제한될 수 있습니다.&#10;&#10;위 내용을 확인하였으며, 시승 진행을 위한 개인정보 수집 및 이용에 동의합니다.</textarea>
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

    <!-- QR 코드 생성 라이브러리 추가 -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>

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
            // 1. QR 코드 클라이언트 렌더링
            var qrUrl = "${data.qrCodeUrl}";
            if(qrUrl) {
                new QRCode(document.getElementById("qrcode"), {
                    text: qrUrl,
                    width: 200,
                    height: 200,
                    colorDark : "#000000",
                    colorLight : "#ffffff",
                    correctLevel : QRCode.CorrectLevel.H
                });
            }

            // 2. 기존 데이터에 맞춰 지역 및 전시장 초기화
            initRegionAndShop();

            // 3. 예약 현황 체크 및 안전동의 영역 가시성 초기화
            checkDriveTimeAvailability();

            // 이메일 아이디 전체 입력 방지
            $("#emailId").on("input", function() {
                let val = $(this).val().replace(/\s/g, '');
                if(val.includes('@')) {
                    val = val.split('@')[0];
                }
                $(this).val(val);
            });

            // 셀렉트 박스 변경 시 도메인 인풋 처리 로직 (Show/Hide 대신 Readonly 제어)
            $("#emailDomain").on("change", function() {
                var selectedVal = $(this).val();

                if(selectedVal === "direct") {
                    // 직접 입력 시 readonly 해제 및 포커스, 값 초기화
                    $("#customDomain").val("").prop("readonly", false).focus();
                } else if(selectedVal === "") {
                    // 이메일 선택(빈 값)일 경우
                    $("#customDomain").val("").prop("readonly", true);
                } else {
                    // 특정 도메인 선택 시 해당 값을 넣고 readonly 처리
                    $("#customDomain").val(selectedVal).prop("readonly", true);
                }
            });

            // 4. 정보 수정 버튼 클릭 이벤트
            $("#btnUpdate").on("click", function(e) {
                e.preventDefault();

                // 폼 유효성 검사 통과 시
                if(validateCombinedForm()) {
                    if(confirm("입력하신 정보로 시승 예약을 수정하시겠습니까?")) {
                        var formData = $("#updateForm").serialize();

                        $.ajax({
                            type: "POST",
                            url: "/apply/updateAjax",
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
            const emailId = $("#emailId").val().trim();
            const emailDomainSelect = $("#emailDomain").val();
            const customDomain = $("#customDomain").val().trim();

            if(emailId === "") {
                alert("이메일 아이디를 입력해 주세요.");
                $("#emailId").focus();
                return false;
            }

            if(customDomain === "") {
                alert("이메일 도메인을 선택하거나 입력해 주세요.");
                if(emailDomainSelect === "direct") {
                    $("#customDomain").focus();
                } else {
                    $("#emailDomain").focus();
                }
                return false;
            }

            // 도메인 유효성 검사 로직
            const domainRegex = /^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            if(!domainRegex.test(customDomain)) {
                alert("유효한 이메일 도메인 형식이 아닙니다.\n(예: example.com)");
                $("#customDomain").focus();
                return false;
            }

            let finalEmail = emailId + "@" + customDomain;

            $("#fullEmail").val(finalEmail);

            if($("#regionSelect").val() === "") {
                alert("지역을 선택해 주세요.");
                return false;
            }
            if($("#shopSelect").val() === "") {
                alert("방문 가능 전시장를 선택해 주세요.");
                return false;
            }
            if($("select[name='carModel']").val() === "") {
                alert("관심차량 정보를 선택해 주세요.");
                return false;
            }

            return true;
        }
    </script>
</body>
</html>