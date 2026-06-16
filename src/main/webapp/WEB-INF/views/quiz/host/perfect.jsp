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
    <link href="/css/style.css?ver=20260616" rel="stylesheet">

    <script src="/js/jquery-1.9.1.min.js"></script>
    <script src="https://code.jquery.com/ui/1.13.0/jquery-ui.js"></script>
    <script src="/js/jquery.cookie.min.js"></script>
    <script src="/js/jquery.ui.touch-punch.min.js"></script>
    <script src="/js/script.js"></script>

    <title>BYD 퀴즈 이벤트</title>

    <style>
        /* 만점자 명단 애니메이션 추가 효과 */
        .prize_list li {
            opacity: 0;
            transform: translateY(20px);
            animation: slideUp 0.5s ease-out forwards;
        }
        @keyframes slideUp {
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>

<body class="host">

    <!-- container -->
    <div id="container">

        <!-- check-in -->
        <div class="ck-in center">

            <!-- title -->
            <div class="top_tit">
                <div class="inner">
                    <div class="tit">
                        <a href="/quiz/host/main">
                            <img src="/img/logo.png" alt="logo">
                        </a>
                    </div>
                </div>
            </div>
            <!-- //title -->

            <!-- info -->
            <div class="info_box padding_b mb-50">
                <div class="inner">
                    <div class="tit">
                        <span>QUIZ EVENT</span>
                        <div class="prize_tit">축하합니다</div>
                    </div>
                    <div class="end_success">
                        <div class="txt_box">
                            <div class="desc prize">
                                <ul class="prize_list" id="scorerList">
                                    <li style="width:100%; color:#fff; text-align:center; opacity:1; transform:none; animation:none;">
                                        채점 결과를 집계 중입니다...
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- //info -->

        </div>
        <!-- //check-in -->

    </div>
    <!-- //container -->

    <script>
        const urlParams = new URLSearchParams(window.location.search);
        const sessionNo = urlParams.get('sessionNo');

        function getTodayStr() {
            const d = new Date();
            return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
        }

        $(document).ready(function() {
            // 참가자 폰 채점 완료를 기다리기 위해 2초 후 명단 로드
            setTimeout(fetchScorers, 2000);
        });

        // 이름 가운데 글자를 '*'로 변환하는 마스킹 함수
        function maskName(name) {
            if (!name) return "";
            if (name.length <= 2) {
                return name.charAt(0) + '*'; // 2글자 (예: 김김 -> 김*)
            }
            // 3글자 이상 (예: 홍길동 -> 홍*동, 남궁민수 -> 남**수)
            return name.charAt(0) + '*'.repeat(name.length - 2) + name.charAt(name.length - 1);
        }

        function fetchScorers() {
            $.ajax({
                url: '/api/quiz/live/host/perfect-scorers',
                type: 'GET',
                data: { playDate: getTodayStr(), sessionNo: sessionNo },
                success: function(res) {
                    if(res.success) {
                        const list = res.scorers;
                        let html = '';
                        if(list.length === 0) {
                            html = '<li style="width:100%; color:#fff; text-align:center; opacity:1; transform:none; animation:none;">아쉽게도 이번 회차에는 만점자가 없습니다. 😢</li>';
                        } else {
                            // 0.2초 간격으로 명단이 하나씩 등장하도록 딜레이 설정
                            list.forEach((u, i) => {
                                const delay = i * 0.2;

                                // 마스킹 함수 적용 및 전화번호 포맷팅 (예: 홍*동 010 **** 1234)
                                const maskedName = maskName(u.name);
                                const maskedPhone = "010 **** " + u.phoneLast4;

                                html += '<li style="animation-delay: ' + delay + 's;">' + maskedName + ' ' + maskedPhone + '</li>';
                            });
                        }
                        $('#scorerList').html(html);
                    } else {
                        $('#scorerList').html('<li style="width:100%; color:red; text-align:center;">데이터를 불러오지 못했습니다.</li>');
                    }
                }
            });
        }

        function goToEnd() {
            location.href = '/quiz/host/end';
        }

        // 키보드/클리커 이벤트 캡처 시 end.jsp 로 이동
        document.addEventListener('keydown', function(e) {
            if (e.keyCode === 34 || e.keyCode === 39 || e.keyCode === 32 || e.keyCode === 13 || e.keyCode === 40) {
                e.preventDefault();
                goToEnd();
            }
        }, true);

        // 빈 화면 클릭해도 이동
        $(document).on('click', function(e) {
            if (e.target.tagName !== 'A') {
                goToEnd();
            }
        });
    </script>
</body>
</html>