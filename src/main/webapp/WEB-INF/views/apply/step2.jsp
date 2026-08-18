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

    <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />

    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/style.css?ver=20260616">

    <title>BYD</title>

    <%-- 비정상 접근 시 화면 렌더링 전 강제 튕겨내기 --%>
    <c:if test="${empty sessionScope.tempInfo}">
        <script>
            alert("정상적인 접근 경로가 아닙니다.\n이름과 연락처를 먼저 입력해 주세요.");
            location.replace("/apply/step1");
        </script>
    </c:if>

    <style>
        .notice-box { background: #f8f9fa; padding: 15px; border-radius: 8px; margin-bottom: 20px; margin-top: 10px; font-size: 14px; color: #e50000; font-weight: bold; text-align: center; line-height: 1.4; border: 1px solid #ffcccc; }
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

                    <div class="notice-box">
                        ※ 기념품 수령은 행사 기간 중<br>1회에 한하여 참여 가능합니다.
                    </div>

                    <%-- 서버 튕김 방지용 데이터 복구 세팅 --%>
                    <c:set var="savedEmailId" value="" />
                    <c:set var="savedEmailDomain" value="" />
                    <c:set var="isCustomDomain" value="false" />

                    <c:if test="${not empty retainedData.email}">
                        <c:set var="emailParts" value="${fn:split(retainedData.email, '@')}" />
                        <c:set var="savedEmailId" value="${emailParts[0]}" />
                        <c:set var="savedEmailDomain" value="${fn:length(emailParts) > 1 ? emailParts[1] : ''}" />
                        <c:set var="isCustomDomain" value="${not empty savedEmailDomain and savedEmailDomain ne 'naver.com' and savedEmailDomain ne 'gmail.com' and savedEmailDomain ne 'hanmail.net' and savedEmailDomain ne 'nate.com'}" />
                    </c:if>

                    <form action="/apply/applyProcess" method="post" id="applyForm2" onsubmit="return validateForm();">

                        <!-- 서버 전송용 히든 필드 -->
                        <input type="hidden" name="email" id="fullEmail">
                        <input type="hidden" name="privacyAgree" id="hiddenPrivacy" value="N">
                        <input type="hidden" name="thirdPartyAgree" id="hiddenThirdParty" value="N">
                        <input type="hidden" name="entrustAgree" id="hiddenEntrust" value="N">
                        <input type="hidden" name="provideAgree" id="hiddenProvide" value="Y">
                        <input type="hidden" name="mktAgree" id="hiddenMkt" value="N">

                        <ul class="form_box">
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
                                            <option value="gmail.com" <c:if test="${savedEmailDomain == 'gmail.com'}">selected</c:if>>gmail.com</option>
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
                                            <!-- 지역 선택 시 여기에 옵션이 동적으로 생성됩니다. -->
                                        </select>
                                    </div>
                                </div>
                            </li>
                            <li>
                                <div class="gubun">관심차량 선택</div>
                                <div class="input">
                                    <select name="carModel" required>
                                        <option value="">선택해 주세요.</option>
                                        <option value="BYD DOLPHIN" <c:if test="${retainedData.carModel == 'BYD DOLPHIN'}">selected</c:if>>BYD DOLPHIN</option>
                                        <option value="BYD ATTO 3" <c:if test="${retainedData.carModel == 'BYD ATTO 3'}">selected</c:if>>BYD ATTO 3</option>
                                        <option value="BYD SEAL" <c:if test="${retainedData.carModel == 'BYD SEAL'}">selected</c:if>>BYD SEAL</option>
                                        <option value="BYD SEALION 7" <c:if test="${retainedData.carModel == 'BYD SEALION 7'}">selected</c:if>>BYD SEALION 7</option>
                                    </select>
                                </div>
                            </li>
                        </ul>
                        <div class="terms-check">
                            <label>
                                <input type="checkbox" id="thirdPartyAgree" required>
                                <span class="terms-check_box" aria-hidden="true"></span>
                                <span class="terms-check_label">(필수) 개인정보 제3자 제공 동의</span>
                            </label>
                            <textarea readonly>BYD코리아는 고객 상담, 시승 운영 및 차량 구매상담 연결을 위하여 아래와 같이 개인정보를 제3자에게 제공할 수 있습니다.&#10;&#10;제공받는 자: 비와이디코리아 유한회사의 공식 딜러사(*)중 고객이 선택한 전시장이 속한 딜러사&#10;*BYD 공식딜러사: 디티네트웍스㈜, ㈜삼천리이브이, 하모니오토모빌(유), ㈜비전모빌리티, 지엔비모빌리티㈜, 에스에스모터스㈜&#10;제공하는 개인정보: 이름, 휴대폰 번호, 이메일 주소, 관심 차종, 시승 신청 전시장, , 시승 신청 시간&#10;제공 목적: 시승 예약 운영, 시승 일정 안내, 차량 상담 및 문의 응대, 견적 제공 및 구매 상담 연결	&#10;보유 및 이용기간: 시승 및 상담 종료 후 6개월까지 또는 고객의 동의 철회 시까지. 단, 관계 법령에 따라 보존이 필요한 경우 해당 기간 동안 보관&#10;&#10;고객은 개인정보 제3자 제공에 대한 동의를 거부할 권리가 있습니다. 다만, 동의하지 않을 경우 시승 예약 운영 및 딜러 상담 연결이 제한될 수 있습니다.</textarea>
                        </div>
                        <div class="terms-check">
                            <label>
                                <input type="checkbox" id="entrustAgree" required>
                                <span class="terms-check_box" aria-hidden="true"></span>
                                <span class="terms-check_label">(필수) 개인정보 처리 위탁 안내 및 동의서</span>
                            </label>
                            <textarea readonly>BYD코리아는 원활한 이벤트 운영 및 시승 신청 페이지 운영을 위하여 아래와 같이 개인정보 처리 업무를 위탁합니다.&#10;&#10;수탁업체: ㈜엔피&#10;위탁 업무 내용: 이벤트 페이지 개발 및 운영, 시승 신청 정보 수집, 이벤트 운영 지원&#10;보유 및 이용 기간: 위탁업무 수행 기간 동안 보관하며, 위탁업무 종료시 지체 없이 파기</textarea>
                        </div>
                        <div class="terms-check">
                            <label>
                                <input type="checkbox" id="mktAgree" <c:if test="${retainedData.mktAgree == 'Y'}">checked</c:if>>
                                <span class="terms-check_box" aria-hidden="true"></span>
                                <span class="terms-check_label">(선택) 마케팅 정보 수신 동의</span>
                            </label>
                            <textarea readonly>BYD코리아는 고객에게 차량, 프로모션 및 이벤트 관련 혜택 정보를 제공하기 위하여 아래와 같이 개인정보를 활용하고 광고성 정보를 발송할 수 있습니다.&#10;&#10;수집 항목: 이름, 휴대폰 번호, 이메일 주소, 시승 신청 정보, 관심 차량 정보&#10;수집 및 이용 목적: 차량 구매 혜택, 프로모션 및 이벤트 안내, 서비스 및 브랜드 뉴스 안내, 고객 맞춤형 마케팅 정보 제공&#10;보유 및 이용 기간: 마케팅 활용 동의일로부터 2년 또는 고객의 동의 철회 시까지&#10;&#10;※ 고객은 마케팅 활용 및 광고성 정보 수신에 대한 동의를 거부할 권리가 있으며, 거부하더라도 시승 신청 및 기본 서비스 이용에는 제한이 없습니다.</textarea>
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

    <div class="testdrive_popup" id="testdrivePopup">
        <div class="testdrive_dim"></div>

        <div class="testdrive_box">
            <h3>시승 유의사항</h3>

            <ul class="popup_notice">
                <li>만 24세 이상만 시승 가능</li>
                <li>운전면허증 필수 지참</li>
                <li>시승 전 음주 측정 진행</li>
            </ul>

            <button type="button" class="popup_btn">확인</button>
        </div>
    </div>

    <script src="https://unpkg.com/swiper@7/swiper-bundle.min.js"></script>
    <script src="/js/jquery-1.9.1.min.js"></script>
    <script src="https://code.jquery.com/ui/1.13.0/jquery-ui.js"></script>
    <script src="/js/jquery.cookie.min.js"></script>
    <script src="/js/jquery.ui.touch-punch.min.js"></script>
    <script src="/js/script.js"></script>

    <script>
        // 전시장 데이터 맵
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

        const retainedShopInfo = "${retainedData.shopInfo}";

        $(document).ready(function() {
            // [서버 튕김 방지] 기존에 선택했던 지점 정보가 있다면 복구
            if (retainedShopInfo) {
                for (const region in shopData) {
                    if (shopData[region].includes(retainedShopInfo)) {
                        $("#regionSelect").val(region);
                        updateShops();
                        $("#shopSelect").val(retainedShopInfo);
                        break;
                    }
                }
            }

            // 백엔드 유효성 검사 실패 시 에러 메시지 출력
            <c:if test="${not empty errorMsg}">
                alert("${errorMsg}");
            </c:if>

            // 이메일 아이디 전체 입력 방지
            $("#emailId").on("input", function() {
                let val = $(this).val().replace(/\s/g, '');
                if(val.includes('@')) {
                    val = val.split('@')[0];
                }
                $(this).val(val);
            });

            // 셀렉트 박스 변경 시 도메인 인풋 처리 로직
            $("#emailDomain").on("change", function() {
                var selectedVal = $(this).val();

                if(selectedVal === "direct") {
                    $("#customDomain").val("").prop("readonly", false).focus();
                } else if(selectedVal === "") {
                    $("#customDomain").val("").prop("readonly", true);
                } else {
                    $("#customDomain").val(selectedVal).prop("readonly", true);
                }
            });
        });

        // 전시장 업데이트 함수
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

        // 폼 제출 시 유효성 검사
        function validateForm() {
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

            $("#fullEmail").val(emailId + "@" + customDomain);

            if($("#regionSelect").val() === "") { alert("지역을 선택해 주세요."); return false; }
            if($("#shopSelect").val() === "") { alert("방문 가능 전시장를 선택해 주세요."); return false; }
            if($("select[name='carModel']").val() === "") { alert("관심차량 정보를 선택해 주세요."); return false; }

            $("#hiddenThirdParty").val($("#thirdPartyAgree").is(":checked") ? "Y" : "N");
            $("#hiddenEntrust").val($("#entrustAgree").is(":checked") ? "Y" : "N");
            $("#hiddenMkt").val($("#mktAgree").is(":checked") ? "Y" : "N");

            if (!$("#thirdPartyAgree").is(":checked") || !$("#entrustAgree").is(":checked")) {
                alert("필수 약관에 모두 동의해 주세요.");
                return false;
            }

            return true;
        }
    </script>
</body>
</html>