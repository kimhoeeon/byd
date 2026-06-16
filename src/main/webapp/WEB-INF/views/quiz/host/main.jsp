<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" />
    <meta name="format-detection" content="telephone=no,email=no,address=no"/>
    <meta name="apple-mobile-web-app-capable" content="yes"/>
    <meta name="mobile-web-app-capable" content="yes"/>

    <meta property="og:type" content="website">
    <meta property="og:locale" content="ko_KR">
    <meta property="og:site_name" content="BYD">

    <!-- swiper 외부 라이브러리 -->
    <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css"/>
    <script src="https://unpkg.com/swiper@7/swiper-bundle.min.js"></script>
    <link href="/css/reset.css" rel="stylesheet">
    <link href="/css/font.css" rel="stylesheet">
    <link href="/css/style.css?ver=20260615" rel="stylesheet">

    <script src="/js/jquery-1.9.1.min.js"></script>
    <script src="https://code.jquery.com/ui/1.13.0/jquery-ui.js"></script>
    <script src="/js/jquery.cookie.min.js"></script>
    <script src="/js/jquery.ui.touch-punch.min.js"></script>
    <script src="/js/script.js"></script>

    <title>BYD 퀴즈 이벤트</title>

</head>

<body class="host">

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
                    <div class="tit">
                        <span>QUIZ EVENT</span>
                        <div>퀴즈 이벤트</div>
                    </div>
                </div>
            </div>

            <div class="btn_box_pc">
                <p style="margin-bottom: 10px; font-weight: bold; color: #fff; text-align: center;">진행할 회차를 선택해 주세요</p>
                <select name="sessionNo" id="sessionNo" style="width: 100%;"></select>
            </div>

            <div class="btn_box_pc" style="margin-top: 15px;">
                <a href="javascript:void(0);" onclick="startLiveQuiz()" class="btn_st05">시작하기</a>
            </div>

            <div class="btn_box_pc" style="margin-top: 15px;">
                <a href="javascript:void(0);" onclick="resetLiveQuiz()" class="btn_st05" style="background:#444; border-color:#444;">현재 회차 강제 초기화</a>
            </div>
            <!-- //info -->

        </div>
        <!-- //check-in -->

    </div>
    <!-- //container -->

    <script>
        let isStarting = false; // 중복 실행 방지용

        $(document).ready(function() {
            // 평일 4회차, 주말 5회차 자동 세팅
            const today = new Date();
            const dayOfWeek = today.getDay();
            const isWeekend = (dayOfWeek === 0 || dayOfWeek === 6);
            const maxSession = isWeekend ? 5 : 4;

            let selectHtml = "";
            for(let i = 1; i <= maxSession; i++) {
                selectHtml += `<option value="` + i + `">` + i + `회차 진행</option>`;
            }
            $('#sessionNo').html(selectHtml);
        });

        // 최상위 클리커(키보드) 캡처 이벤트
        document.addEventListener('keydown', function(e) {
            // 34(PageDown), 39(우측방향), 32(스페이스바), 13(엔터), 40(하단방향)
            if (e.keyCode === 34 || e.keyCode === 39 || e.keyCode === 32 || e.keyCode === 13 || e.keyCode === 40) {
                e.preventDefault();
                if(!isStarting) {
                    startLiveQuiz();
                }
            }
        }, true);

        function getTodayStr() {
            const d = new Date();
            return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
        }

        function startLiveQuiz() {
            isStarting = true; // 중복 클릭 방지
            const sessionNo = $('#sessionNo').val();

            $.ajax({
                url: '/api/quiz/live/host/start',
                type: 'POST',
                data: { playDate: getTodayStr(), sessionNo: sessionNo },
                success: function(res) {
                    if(res.success) {
                        location.href = '/quiz/host/quest?sessionNo=' + sessionNo;
                    } else {
                        isStarting = false;
                        // 이미 방이 존재할 경우 복구 진입 여부를 묻습니다.
                        if(confirm("이미 개설되어 진행 중이거나 중단된 회차입니다.\n기존 화면으로 [이어서 진행] 하시겠습니까?\n\n※ 처음부터 다시 하려면 '취소'를 누른 뒤 하단의 [강제 초기화]를 진행해주세요.")) {
                            location.href = '/quiz/host/quest?sessionNo=' + sessionNo;
                        }
                    }
                },
                error: function() {
                    alert('서버 통신 중 오류가 발생했습니다.');
                    isStarting = false;
                }
            });
        }

        function resetLiveQuiz() {
            const sessionNo = $('#sessionNo').val();
            if(confirm("정말 " + sessionNo + "회차를 강제 초기화하시겠습니까?\n(현재 방에 있는 참가자들의 퀴즈 진행이 모두 중단됩니다)")) {
                $.ajax({
                    url: '/api/quiz/live/host/reset',
                    type: 'POST',
                    data: { playDate: getTodayStr(), sessionNo: sessionNo },
                    success: function(res) {
                        if(res.success) {
                            alert("초기화가 완료되었습니다. [시작하기]를 눌러 새로 개설해주세요.");
                        } else {
                            alert(res.message);
                        }
                    }
                });
            }
        }
    </script>
</body>
</html>