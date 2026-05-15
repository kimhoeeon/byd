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

    <%-- 추가: 비정상 접근 시 화면 렌더링 전 강제 튕겨내기 --%>
    <c:if test="${empty sessionScope.tempInfo}">
        <script>
            alert("정상적인 접근 경로가 아닙니다.\n이름과 연락처를 먼저 입력해 주세요.");
            location.replace("/apply/step1");
        </script>
    </c:if>

    <style>
        .notice-box { background: #f8f9fa; padding: 15px; border-radius: 8px; margin-bottom: 20px; margin-top: 10px; font-size: 14px; color: #e50000; font-weight: bold; text-align: center; line-height: 1.4; border: 1px solid #ffcccc; }

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

                    <div class="notice-box">
                        ※ 챌린지 및 시승체험은 행사 기간(3일) 중<br>각각 1회에 한하여 참여 가능합니다.
                    </div>

                    <form action="/apply/applyProcess" method="post" id="applyForm2" onsubmit="return validateForm();">

                        <!-- 서버 전송용 히든 필드 -->
                        <input type="hidden" name="email" id="fullEmail">
                        <input type="hidden" name="privacyAgree" id="hiddenPrivacy" value="N">
                        <input type="hidden" name="thirdPartyAgree" id="hiddenThirdParty" value="N">
                        <input type="hidden" name="entrustAgree" id="hiddenEntrust" value="N">
                        <input type="hidden" name="mktAgree" id="hiddenMkt" value="N">

                        <ul class="form_box">
                            <li>
                                <div class="gubun">이메일</div>
                                <div class="row email">
                                    <input type="text" id="emailId" placeholder="이메일 주소">
                                    <span>@</span>
                                    <input type="text" id="customDomain" placeholder="도메인 입력" readonly>
                                    <div class="input">
                                        <select id="emailDomain">
                                            <option>이메일 선택</option>
                                            <option value="naver.com">naver.com</option>
                                            <option value="google.com">google.com</option>
                                            <option value="hanmail.net">hanmail.net</option>
                                            <option value="nate.com">nate.com</option>
                                            <option value="direct">직접 입력</option>
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
                                <input type="checkbox" id="privacyAgree" required>
                                <span class="terms-check_box" aria-hidden="true"></span>
                                <span class="terms-check_label">(필수) 개인정보 수집·이용 동의</span>
                            </label>
                            <textarea readonly>BYD코리아는 시승 신청 및 고객 상담 서비스 제공을 위하여 아래와 같이 개인정보를 수집·이용합니다. &#10; &#10;수집 항목: 이름, 휴대폰 번호, 이메일 주소&#10;수집 및 이용 목적: 시승 신청 접수, 시승 안내, 본인 확인, 문의 응대 및 상담 진행&#10;보유 및 이용 기간: 본 이벤트 종료 후 6개월까지 또는 귀하의 동의 철회 시까지.&#10;&#10;귀하는 개인정보 수집·이용에 대한 동의를 거부할 권리가 있으나, 거부할 경우 시승 신청 및 상담 서비스 이용이 제한될 수 있습니다.</textarea>
                        </div>
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
                                <input type="checkbox" id="mktAgree">
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
            // 1. 페이지 로드 시 예약 현황 체크
            checkDriveTimeAvailability();

            // [핵심 추가] 고객이 셀렉트 박스를 클릭/터치할 때마다 실시간 현황 재체크
            $('#testDriveTime').on('focus click touchstart', function() {
                checkDriveTimeAvailability();
            });

            // 2. 백엔드 유효성 검사 실패 시 에러 메시지 출력
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
            // 현재 시/분 가져오기
            const now = new Date();
            const currentHour = now.getHours();
            const currentMin = now.getMinutes();


            $.ajax({
                url: "/apply/getDriveTimeStatus",
                type: "GET",
                success: function(response) {
                    $('#testDriveTime option').each(function() {
                        var timeVal = $(this).val();

                        if(timeVal !== "시승 미신청") {
                            // 1. 상태 초기화 (누군가 취소해서 자리가 났을 경우를 대비해 일단 푼다)
                            $(this).prop('disabled', false);
                            $(this).text(timeVal);

                            // 2. 검증 1순위: 시간이 지났는가?
                            const timeParts = timeVal.split(':');
                            const targetHour = parseInt(timeParts[0]);
                            const targetMin = parseInt(timeParts[1]);

                            let isPassed = false;
                            if (currentHour > targetHour) {
                                isPassed = true;
                            } else if (currentHour === targetHour && currentMin >= targetMin) {
                                isPassed = true;
                            }

                            // 3. 검증 2순위: 예약 인원이 4명 꽉 찼는가?
                            const isFull = response[timeVal] >= 4;

                            // 4. 최종 판단 (우선순위 부여)
                            if (isPassed) {
                                // [핵심] 취소 자리가 있든 없든, 시간이 지났으면 무조건 마감 처리
                                $(this).prop('disabled', true);
                                $(this).text(timeVal + ' (마감)');
                            } else if (isFull) {
                                // 시간이 안 지났어도 정원이 찼으면 마감 처리
                                $(this).prop('disabled', true);
                                $(this).text(timeVal + ' (마감)');
                            }
                        }
                    });
                },
                error: function(err) {
                    console.log("시간대 실시간 조회 실패");
                }
            });
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

            $("#hiddenPrivacy").val($("#privacyAgree").is(":checked") ? "Y" : "N");
            $("#hiddenThirdParty").val($("#thirdPartyAgree").is(":checked") ? "Y" : "N");
            $("#hiddenEntrust").val($("#entrustAgree").is(":checked") ? "Y" : "N");
            $("#hiddenMkt").val($("#mktAgree").is(":checked") ? "Y" : "N");

            if (!$("#privacyAgree").is(":checked") || !$("#thirdPartyAgree").is(":checked") || !$("#entrustAgree").is(":checked")) {
                alert("필수 약관에 모두 동의해 주세요.");
                return false;
            }

            return true;
        }
    </script>
</body>
</html>