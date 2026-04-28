<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!doctype html>
<html lang="ko">
<head>
    <meta name="naver-site-verification" content="07e0fdf4e572854d6fbe274f47714d3e7bbb9fbd" />
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" />
    <meta name="format-detection" content="telephone=no,email=no,address=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="mobile-web-app-capable" content="yes" />

    <meta property="og:type" content="website">
    <meta property="og:locale" content="ko_KR">
    <meta property="og:site_name" content="승요일기">
    <meta property="og:title" content="승요일기 | 야구 직관 기록 앱">
    <meta property="og:description" content="야구 직관 기록을 더 쉽고 재미있게! 경기 결과, 기록, 사진과 함께 나만의 야구 직관일기를 남겨보세요.">
    <meta name="keywords" content="승요일기 / 야구 직관 / 프로야구 직관 / 직관 후기 / 직관일기 / KBO / KBO 직관 / 프로야구 앱 / 야구팬 앱">
    <meta property="og:url" content="https://myseungyo.com/">
    <meta property="og:image" content="https://myseungyo.com/img/og_img.jpg">

    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="manifest" href="/site.webmanifest" />

    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">

    <title>댓글 관리 | 승요일기</title>

    <style>
        /* 데이터 없을 때 스타일 추가 */
        .no-data { text-align: center; padding: 60px 0; color: #999; font-size: 14px; }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
</head>

<body>
    <div class="app">

        <header class="app-header">
            <button class="app-header_btn app-header_back" type="button" onclick="location.href='/member/mypage'">
                <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
            </button>
        </header>

        <div class="app-main">

            <div class="app-tit">
                <div class="page-tit">댓글 관리</div>
            </div>

            <div class="review review_wrap mt-24">
                <ul class="review_list">
                    <c:choose>
                        <c:when test="${empty list}">
                            <li class="no-data" style="background: none;">작성한 댓글이 없습니다.</li>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="item" items="${list}">
                                <li>
                                    <div class="name"><span>${item.diaryTeamCode}</span> ${item.diaryTitle}</div>
                                    <div class="nae">${item.content}</div>
                                    <button class="del-btn" type="button" onclick="deleteComment(${item.commentId}, this)">
                                        <span><img src="/img/ico_del.svg" alt="삭제 아이콘"></span>
                                    </button>
                                </li>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>

        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
    <script>
        function deleteComment(commentId, btn) {
            if (!confirm('정말 삭제하시겠습니까?')) return;

            $.post('/member/review/delete', { commentId: commentId }, function(res) {
                if (res === 'ok') {
                    // 삭제 성공 시 리스트에서 제거 (애니메이션 효과)
                    $(btn).closest('li').fadeOut(300, function() {
                        $(this).remove();
                        if ($('.review_list li').length === 0) {
                            location.reload(); // 리스트 비면 갱신 (no-data 표시)
                        }
                    });
                } else {
                    alert('삭제에 실패했습니다.');
                }
            }).fail(function() {
                alert('서버 오류가 발생했습니다.');
            });
        }
    </script>
</body>
</html>