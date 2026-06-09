<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <meta name="format-detection" content="telephone=no"/>
    <title>BYD 퀴즈 이벤트</title>
    <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css"/>
    <script src="https://unpkg.com/swiper@7/swiper-bundle.min.js"></script>
    <link href="/css/reset.css" rel="stylesheet">
    <link href="/css/font.css" rel="stylesheet">
    <link href="/css/style.css" rel="stylesheet">

    <script src="/js/jquery-1.9.1.min.js"></script>
    <script src="https://code.jquery.com/ui/1.13.0/jquery-ui.js"></script>
    <script src="/js/jquery.cookie.min.js"></script>
    <script src="/js/jquery.ui.touch-punch.min.js"></script>
    <script src="/js/script.js"></script>
</head>
<body class="quiz">

<div id="container">

    <div class="ck-in center">

        <div class="top_tit">
            <div class="inner">
                <div class="back">
                    <a href="javascript:history.back();">
                        <img src="/img/left_arrow.svg" alt="뒤로가기">
                    </a>
                </div>
                <div class="tit">
                    <a href="/quiz/step1">
                        <img src="/img/logo.png" alt="logo">
                    </a>
                </div>
            </div>
        </div>
        <div class="info_box padding_b">
            <div class="inner">
                <div class="tit">
                    <span>QUIZ EVENT</span>
                    <div>퀴즈 이벤트</div>
                </div>

                <input type="hidden" id="name" value="${name}">
                <input type="hidden" id="phone" value="${phone}">
                <input type="hidden" id="privacyAgree" value="${privacyAgree}">

                <ul class="form_box">
                    <li>
                        <div class="gubun">이메일</div>
                        <div class="row email">
                            <input type="text" id="emailId" placeholder="이메일 주소" maxlength="30">
                            <span>@</span>
                            <input type="text" id="customDomain" class="direct" placeholder="직접입력" maxlength="30">
                            <div class="input">
                                <select id="emailDomain">
                                    <option value="">이메일 선택</option>
                                    <option value="naver.com">naver.com</option>
                                    <option value="google.com">google.com</option>
                                    <option value="hanmail.net">hanmail.net</option>
                                    <option value="nate.com">nate.com</option>
                                    <option value="direct">직접입력</option>
                                </select>
                            </div>
                        </div>
                    </li>
                    <li>
                        <div class="gubun">방문 가능 전시장</div>
                        <div class="row">
                            <div class="input">
                                <select id="regionSelect" onchange="updateShops()">
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
                                <select id="shopSelect">
                                    <option value="">전시장 선택</option>
                                </select>
                            </div>
                        </div>
                    </li>
                    <li>
                        <div class="gubun">관심차량 정보</div>
                        <div class="input">
                            <select id="carModelCode">
                                <option value="">선택해 주세요.</option>
                                <option value="BYD0004">BYD DOLPHIN</option>
                                <option value="BYD0001">BYD ATTO 3</option>
                                <option value="BYD0005">BYD SEAL</option>
                                <option value="BYD0019">BYD SEALION 7</option>
                            </select>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
        <div class="btn_box">
            <button type="button" class="btn_st05" onclick="startQuiz()">
                다음
            </button>
        </div>
    </div>
</div>
<script>
    // 전시장 데이터 맵
    const shopData = {
        "서울": ["BYD 강동", "BYD 강서", "BYD 마포", "BYD 목동", "BYD 서초", "BYD 송파", "BYD 용산"],
        "경기": ["BYD 김포", "BYD 동탄", "BYD 부천", "BYD 분당", "BYD 수원", "BYD 스타필드 안성", "BYD 스타필드 운정", "BYD 스타필드 일산", "BYD 스타필드 하남", "BYD 안양", "BYD 의정부", "BYD 일산"],
        "인천": ["BYD 서해구", "BYD 송도"],
        "강원": ["BYD 원주"],
        "충청/대전": ["BYD 대전", "BYD 천안", "BYD 청주"],
        "전라/광주": ["BYD 광주", "BYD 전주"],
        "경상/대구/부산/창원": ["BYD 대구", "BYD 부산 동래", "BYD 수영", "BYD 스타필드 명지", "BYD 창원", "BYD 포항"],
        "제주": ["BYD 제주"]
    };

    $(document).ready(function () {
        // 이메일 도메인 자동 세팅 로직
        $("#emailDomain").on("change", function () {
            var selectedVal = $(this).val();
            if (selectedVal === "direct") {
                $("#customDomain").val("").prop("readonly", false).focus();
            } else if (selectedVal === "") {
                $("#customDomain").val("").prop("readonly", true);
            } else {
                $("#customDomain").val(selectedVal).prop("readonly", true);
            }
        });

        // 이메일 아이디 한글/공백 방지
        $("#emailId").on("input", function () {
            let val = $(this).val().replace(/[^a-zA-Z0-9_-]/g, '');
            $(this).val(val);
        });
    });

    // 전시장 업데이트 함수
    function updateShops() {
        const regionSelect = document.getElementById("regionSelect");
        const shopSelect = document.getElementById("shopSelect");
        const selectedRegion = regionSelect.value;
        shopSelect.innerHTML = '<option value="">전시장 선택</option>';
        if (selectedRegion && shopData[selectedRegion]) {
            shopData[selectedRegion].forEach(function (shop) {
                const option = document.createElement("option");
                option.value = shop;
                option.text = shop;
                shopSelect.appendChild(option);
            });
        }
    }

    // 퀴즈 시작 (API 호출)
    function startQuiz() {
        const name = $("#name").val();
        const phone = $("#phone").val();
        const privacyAgree = $("#privacyAgree").val();

        const emailId = $("#emailId").val().trim();
        const emailDomainSelect = $("#emailDomain").val();
        const customDomain = $("#customDomain").val().trim();
        const region = $("#regionSelect").val();
        const shopInfo = $("#shopSelect").val();
        const carModelCode = $("#carModelCode").val();

        // 유효성 검사
        if (emailId === "") {
            alert("이메일 아이디를 입력해 주세요.");
            $("#emailId").focus();
            return;
        }
        if (customDomain === "") {
            alert("이메일 도메인을 선택하거나 입력해 주세요.");
            if (emailDomainSelect === "direct") {
                $("#customDomain").focus();
            } else {
                $("#emailDomain").focus();
            }
            return;
        }

        const domainRegex = /^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        if (!domainRegex.test(customDomain)) {
            alert("유효한 이메일 도메인 형식이 아닙니다.\n(예: example.com)");
            $("#customDomain").focus();
            return;
        }

        if (region === "") {
            alert("지역을 선택해 주세요.");
            return;
        }
        if (shopInfo === "") {
            alert("방문 가능 전시장를 선택해 주세요.");
            return;
        }
        if (carModelCode === "") {
            alert("관심차량 정보를 선택해 주세요.");
            return;
        }

        const fullEmail = emailId + "@" + customDomain;

        // API로 전송할 JSON 데이터
        const requestData = {
            name: name,
            phone: phone,
            privacyAgree: privacyAgree,
            email: fullEmail,
            region: region,
            shopInfo: shopInfo,
            carModelCode: carModelCode
        };

        // AJAX로 퀴즈 시작 API 호출
        $.ajax({
            type: "POST",
            url: "/api/quiz/start",
            contentType: "application/json",
            data: JSON.stringify(requestData),
            success: function (res) {
                if (res.success) {
                    // 성공 시 발급받은 참여 이력 번호(historySeq)와 문제 10개를 SessionStorage에 보관!
                    sessionStorage.setItem("quizHistorySeq", res.historySeq);
                    sessionStorage.setItem("quizQuestions", JSON.stringify(res.questions));

                    // 대망의 퀴즈 문제 풀이 화면으로 이동!
                    location.href = "/quiz/play";
                } else {
                    // 중복 참여 등으로 막힌 경우
                    alert(res.message);
                    location.href = "/quiz/step1"; // 메인으로 돌려보냄
                }
            },
            error: function () {
                alert("서버 통신 중 오류가 발생했습니다.");
            }
        });
    }
</script>
</body>
</html>