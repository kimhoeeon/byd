<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" />
    <meta name="description" content="">
    <meta name="author" content="">
    <meta name="format-detection" content="telephone=no"/>
    <title>BYD 퀴즈 이벤트</title>
    <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css"/>
    <script src="https://unpkg.com/swiper@7/swiper-bundle.min.js"></script>
    <link href="/css/reset.css" rel="stylesheet">
    <link href="/css/font.css" rel="stylesheet">
    <link href="/css/style.css?ver=20260616" rel="stylesheet">

    <script src="/js/jquery-1.9.1.min.js"></script>
    <script src="https://code.jquery.com/ui/1.13.0/jquery-ui.js"></script>
    <script src="/js/jquery.cookie.min.js"></script>
    <script src="/js/jquery.ui.touch-punch.min.js"></script>
    <script src="/js/script.js"></script>
</head>
<body class="quiz quiz_w">

    <div id="container">

        <div class="ck-in center">

            <div class="top_tit padding_tb">
                <div class="inner">
                    <div class="tit">
                        <img src="/img/logo_g.png" alt="logo">
                    </div>
                </div>
            </div>
            <div class="info_box padding_b">
                <div class="inner">
                    <div class="tit pb_0">
                        <span>QUIZ EVENT</span>
                        <div>퀴즈 이벤트</div>
                    </div>

                    <form id="step1Form" action="/quiz/step2" method="POST">
                        <ul class="form_box">
                            <li>
                                <div class="input">
                                    <input type="text" name="name" id="name" placeholder="이름" maxlength="20">
                                </div>
                            </li>
                            <li>
                                <div class="input tel">
                                    <input type="tel" name="phone" id="phone" placeholder="연락처 ('-' 제외 숫자만 입력)" class="onlyTel" maxlength="11">
                                </div>
                            </li>
                            <li>
                                <div class="terms-check">
                                    <label>
                                        <input type="checkbox" name="privacyAgree" id="privacyAgree" value="Y">
                                        <span class="terms-check_box" aria-hidden="true"></span>
                                        <span class="terms-check_label">
                                            (필수) 개인정보 수집·이용 동의
                                        </span>
                                    </label>
                                    <textarea style="line-height: 20px;" readonly>BYD코리아는 고객 상담 서비스 제공을 위하여 아래와 같이 개인정보를 수집·이용합니다.&#10;수집 항목: 이름, 전화번호, 이메일 주소&#10;수집 및 이용 목적: 문의 응대 및 상담 진행, 고객 관리, 차량 구매 관련 안내 제공, 서비스 품질 개선 및 운영 통계 분석&#10;보유 및 이용 기간: 처리 목적 달성 시 또는 고객의 동의 철회 시까지&#10;고객은 개인정보 수집·이용에 대한 동의를 거부할 권리가 있습니다.&#10;다만, 필수 정보 제공에 대한 동의를 거부할 경우 상담 서비스 이용이 제한될 수 있습니다.</textarea>
                                </div>
                            </li>
                            <li>
                                <div class="terms-check" style="margin-top: 15px;">
                                    <label>
                                        <input type="checkbox" name="provideAgree" id="provideAgree" value="Y">
                                        <span class="terms-check_box" aria-hidden="true"></span>
                                        <span class="terms-check_label" style="line-height: 20px;">
                                            (필수) 행사의 운영 및 참가자 통계 데이터 분석을 위하여 참가자의 개인정보(이름, 연락처, 이메일, 관심 전시장, 관심 차종)를 제공하는 데 동의합니다.
                                        </span>
                                    </label>
                                </div>
                            </li>
                        </ul>
                    </form>
                </div>
            </div>

            <div class="btn_box">
                <button type="button" class="btn_st05" onclick="goNext()">
                    다음
                </button>
            </div>
        </div>
    </div>
    <script>
        $(document).ready(function () {
            // 이미 퀴즈를 완료한 기기인 경우 무한루프를 막기 위해 다른 곳으로 리다이렉트 하지 않고 폼만 숨김 처리
            if (localStorage.getItem('quizCompleted_BYD2026') === 'Y') {
                alert('이미 퀴즈 이벤트에 참여하셨습니다.\n(기기당 1회만 참여 가능합니다.)');
                $('#step1Form').hide();
                $('.btn_box').hide();
                $('.info_box .inner').append('<div style="text-align:center; padding: 50px 0; color:#383838; font-size:18px; line-height:1.5;">이미 퀴즈에 참여한 기기입니다.<br><br>이벤트에 참여해 주셔서 감사합니다.</div>');
            }

            // 이름 입력 시 공백(스페이스바) 완전 차단
            $('#name').on('input', function () {
                $(this).val($(this).val().replace(/\s/g, ''));
            });

            // 연락처 숫자만 입력되도록 처리
            $('.onlyTel').on('input', function () {
                $(this).val($(this).val().replace(/[^0-9]/g, ''));
            });
        });

        // 다음 버튼 클릭 시 유효성 검사
        function goNext() {
            var name = $("#name").val().trim();
            var phone = $("#phone").val().trim();

            if (!name) {
                alert("이름을 입력해 주세요.");
                $("#name").focus();
                return;
            }

            if (!phone || phone.length < 10) {
                alert("올바른 연락처를 입력해 주세요.");
                $("#phone").focus();
                return;
            }

            if (!$("#privacyAgree").is(":checked")) {
                alert("개인정보 수집·이용 동의에 체크해 주세요.");
                return;
            }

            if (!$("#provideAgree").is(":checked")) {
                alert("개인정보 제공 동의에 체크해 주세요.");
                return;
            }

            // 오늘 이미 완료(COMPLETED)한 사용자인지 백엔드에 사전 조회
            $.ajax({
                url: '/api/quiz/check',
                type: 'GET',
                data: { name: name, phone: phone },
                success: function(res) {
                    if (res.eligible) {
                        $("#step1Form").submit();
                    } else {
                        alert(res.message);
                    }
                },
                error: function() {
                    alert("검증 중 서버 오류가 발생했습니다.");
                }
            });
        }
    </script>
</body>
</html>