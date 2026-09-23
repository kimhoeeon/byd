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
    <meta property="og:image" content="https://bydsmrun26.co.kr/img/og_img.jpg?ver=20260918">

    <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />

    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/style.css?ver=20260918">

    <!-- SweetAlert2 CDN -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <title>BYD</title>

</head>

<body class="apply_w">

    <!-- container -->
    <div id="container">
    
        <!-- check-in -->
        <div class="ck-in center">

            <!-- title -->
            <div class="top_tit padding_tb">
                <div class="inner">
                    <div class="tit">
                        <img src="/img/logo_w.png?ver=20260921" alt="logo">
                    </div>
                </div>
            </div>
            <!-- //title -->

            <!-- info -->
            <div class="info_box padding_b">
                <div class="inner">
                    <form id="applyForm">

                        <ul class="form_box">
                            <li>
                                <div class="gubun">이름</div>
                                <div class="input"><input type="text" id="name" name="name" placeholder="입력해 주세요." required></div>
                            </li>
                            <li>
                                <div class="gubun">연락처</div>
                                <div class="input tel">
                                    <input type="tel" id="phone" name="phone" placeholder="입력해 주세요. (숫자만)" class="onlyTel" maxlength="13" required>
                                </div>
                            </li>
                            <li>
                                <div class="gubun">배번호</div>
                                <div class="input">
                                    <input type="text" id="bibNumber" name="bibNumber" placeholder="배번호가 경품 응모 번호이므로, 정확하게 기입해 주세요." maxlength="5" required>
                                </div>
                            </li>
                            <li>
                                <div class="terms-check">
                                    <label>
                                        <input type="checkbox" id="privacyAgree" value="Y" required>
                                        <span class="terms-check_box" aria-hidden="true"></span>
                                        <span class="terms-check_label">(필수) 개인정보 수집·이용 동의</span>
                                    </label>
                                    <textarea style="line-height: 20px;" readonly>BYD코리아는 이벤트 신청 및 고객 상담 서비스 제공을 위하여 아래와 같이 개인정보를 수집·이용합니다.&#10;&#10;수집 항목: 이름, 휴대폰 번호, 이메일 주소, 생년월일, 배번호&#10;수집 및 이용 목적: 이벤트 신청 접수, 이벤트 안내, 본인 확인, 경품 추첨 및 발송, 문의 응대&#10;보유 및 이용 기간: 본 이벤트 종료 후 6개월까지 또는 귀하의 동의 철회 시까지&#10;&#10;귀하는 개인정보 수집·이용에 대한 동의를 거부할 권리가 있으나, 거부할 경우 이벤트 신청 및 상담 서비스 이용이 제한될 수 있습니다.&#10;&#10;개인정보 수집 및 이용 동의&#10;&#10;이벤트 참여를 위해 아래와 같이 개인정보를 수집·이용하고자 합니다.&#10;내용을 확인하신 후 동의 여부를 결정하여 주시기 바랍니다.&#10;&#10;1. 수집항목&#10;필수항목 : 이름, 연락처, 이메일, 생년월일, 배번호, 관심 전시장, 관심 차종&#10;2. 수집 및 이용목적&#10;이벤트 참가자 확인 및 본인 식별&#10;이벤트 진행 및 결과 확인&#10;경품·쿠폰 지급 대상 확인 및 안내&#10;3. 보유 및 이용기간&#10;수집일로부터 6개월간 보관 후 지체 없이 파기&#10;4. 동의 거부 권리 및 불이익&#10;귀하는 개인정보 수집·이용에 대한 동의를 거부할 권리가 있습니다.&#10;다만, 필수항목 수집에 대한 동의를 거부할 경우 이벤트 참여가 제한될 수 있습니다.&#10;5.개인정보 처리 위탁&#10;회사는 원활한 행사를 위하여 아래와 같이 개인정보 처리 업무를 위탁하고 있습니다.&#10;&#10;수탁자 : (주)컴투스엔&#10;위탁업무 : 이벤트 운영 및 참가자 정보 수집·관리</textarea>
                                </div>
                            </li>
                            <li>
                                <div class="terms-check">
                                    <label>
                                        <input type="checkbox" id="provideAgree" name="provideAgree" value="Y" required>
                                        <span class="terms-check_box" aria-hidden="true"></span>
                                        <span class="terms-check_label" style="line-height: 20px;">
                                            (필수) 행사의 운영 및 참가자 통계 데이터 분석을 위하여 참가자의 개인정보(이름, 연락처, 이메일, 생년월일, 배번호, 관심 전시장, 관심 차종)를 제공하는 데 동의합니다.
                                        </span>
                                    </label>
                                </div>
                            </li>
                        </ul>
                        <div class="btn_box">
                            <button type="submit" class="btn_st01">다음</button>
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

            <c:if test="${not empty errorMsg}">
                alert("${errorMsg}");
            </c:if>

            $('#applyForm').on('submit', function(e) {
                e.preventDefault();
                submitStep1();
            });

            // 이름 입력 시 띄어쓰기(공백) 실시간 자동 제거
            $('#name').on('input', function() {
                var val = $(this).val().replace(/\s/g, ''); // 정규식을 사용해 모든 공백 제거
                $(this).val(val);
            });

            // 배번호 입력 시 숫자만 허용 & 공백 제거
            $('#bibNumber').on('input', function() {
                var val = $(this).val().replace(/[^0-9]/g, '');
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
            var bibNumber = document.getElementById("bibNumber").value.trim();

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

            // 배번호 5자리 유효성 검사
            if (bibNumber === "" || bibNumber.length !== 5) {
                alert("배번호 5자리를 정확하게 기입해 주세요.");
                document.getElementById("bibNumber").focus();
                return false;
            }

            if (!$('#privacyAgree').is(':checked')) {
                alert("개인정보 수집·이용 동의에 체크해 주세요.");
                return false;
            }

            if (!$('#provideAgree').is(':checked')) {
                alert("개인정보 제공 동의에 체크해 주세요.");
                return false;
            }

            // SweetAlert2 팝업으로 사용자 최종 확인
            Swal.fire({
                title: '입력하신 정보가 맞습니까?',
                html: '<div style="text-align:left; font-size:16px; margin-top:10px; padding:15px; background:#f8f9fa; border-radius:8px; color:#383838; border:1px solid #ddd;">' +
                    '<strong>이름 :</strong> ' + name + '<br>' +
                    '<strong style="margin-top:5px; display:inline-block;">연락처 :</strong> ' + phone + '<br>' +
                    '<strong style="margin-top:5px; display:inline-block;">배번호 :</strong> <span style="color:#d32f2f; font-weight:bold;">' + bibNumber + '</span>' +
                    '</div>',
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#383838',
                cancelButtonColor: '#888',
                confirmButtonText: '네, 맞습니다',
                cancelButtonText: '수정할래요'
            }).then((result) => {
                if (result.isConfirmed) {

                    var privacyAgree = "Y";

                    // 폼 서밋 대신 AJAX 통신으로 서버에 확인
                    $.ajax({
                        type: "POST",
                        url: "/apply/checkParticipant",
                        data: {
                            bibNumber: bibNumber, // 백엔드로 배번호 함께 전송
                            name: name,
                            phone: phone,
                            privacyAgree: privacyAgree
                        },
                        dataType: "json",
                        success: function(response) {
                            if(response.error) {
                                alert("처리 중 서버 오류가 발생했습니다.");
                                return;
                            }

                            // 배번호 중복 에러 처리
                            if(response.bibDuplicate) {
                                Swal.fire({
                                    title: '배번호 등록 오류',
                                    text: response.message,
                                    icon: 'error',
                                    confirmButtonColor: '#383838'
                                });
                                document.getElementById("bibNumber").focus();
                                return;
                            }

                            if(response.exists) {
                                // 기존 신청자일 경우 Alert 띄우고 전달받은 URL로 이동
                                alert("이미 이벤트 참여 신청이 완료된 고객입니다.");
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
            });
        }
    </script>
</body>
</html>