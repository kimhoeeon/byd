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

            <div class="top_tit padding_tb">
                <div class="inner">
                    <div class="tit">
                        <img src="/img/logo.png" alt="logo">
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
                                    <textarea readonly>시승 신청 및 원활한 안내를 위해 아래와 같이 개인정보를 수집 이용하고자 합니다. 시승 신청 및 원활한 안내를 위해 아래와 같이 개인정보를 수집 이용하고자 합니다.시승 신청 및 원활한 안내를 위해 아래와 같이 개인정보를 수집 이용하고자 합니다.</textarea>
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

        // 이름 입력 시 공백(스페이스바) 완전 차단
        $('#name').on('input', function () {
            $(this).val($(this).val().replace(/\s/g, ''));
        });

        // 연락처 숫자만 입력되도록 처리
        $('.onlyTel').on('input', function () {
            $(this).val($(this).val().replace(/[^0-9]/g, ''));
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

            // 오늘 이미 완료(COMPLETED)한 사용자인지 백엔드에 사전 조회
            $.ajax({
                url: '/api/quiz/check',
                type: 'GET',
                data: { name: name, phone: phone },
                success: function(res) {
                    if (res.eligible) {
                        // 통과되면 폼 제출 (step2로 데이터 전송)
                        $("#step1Form").submit();
                    } else {
                        // 이미 참여한 경우 경고창을 띄우고 다음 단계 진입 차단
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