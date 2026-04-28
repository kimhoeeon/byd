<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

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

    <title>나의 직관일기 | 승요일기</title>

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
</head>

<body>
    <div class="app">

        <header class="app-header">
            <button class="app-header_btn app-header_back" type="button" onclick="history.back()">
                <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
            </button>
        </header>

        <div class="app-main">
            <div class="app-tit">
                <div class="page-tit">나의 직관일기</div>
            </div>

            <div class="page-main_wrap">
                <div class="history">
                    <div class="history-list mt-24">
                        <div class="score_wrap row_wrap">

                            <c:if test="${empty list}">
                                <div class="score_list nodt_list">
                                    <div class="nodt_wrap">
                                        <div class="cont">
                                            <img src="/img/ico_not_mark.svg" alt="데이터 없음" style="width:40px;">
                                            <div class="nodt_tit">아직 작성한 직관 기록이 없어요.</div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <c:forEach var="item" items="${list}">
                                <div class="score_list ${item.gameResult eq 'CANCELLED' ? 'cancel_list' : ''}"
                                     onclick="location.href='/diary/detail?diaryId=${item.diaryId}'"
                                     style="cursor:pointer;">

                                    <c:set var="firstImage" value="" />
                                    <c:if test="${not empty item.imageUrl}">
                                        <c:set var="imgArr" value="${fn:split(item.imageUrl, ',')}" />
                                        <c:set var="firstImage" value="${imgArr[0]}" />
                                    </c:if>
                                    <div class="img">
                                        <img src="${not empty firstImage ? firstImage : '/img/card_defalut.svg'}"
                                             alt="스코어카드 이미지"
                                             onerror="this.src='/img/card_defalut.svg'"
                                             style="width:100%; height:100%; object-fit:cover;">
                                    </div>

                                    <div class="column gap-16">
                                        <div class="score_txt">
                                            <div class="txt_box">
                                                <div class="tit">
                                                    ${item.awayTeamName} ${item.scoreAway} vs ${item.scoreHome} ${item.homeTeamName}
                                                </div>
                                                <div class="date">
                                                    <fmt:parseDate value="${item.gameDate}" pattern="yyyy-MM-dd" var="pDate" type="date"/>
                                                    <fmt:formatDate value="${pDate}" pattern="yyyy-MM-dd"/>

                                                    <%--<c:choose>
                                                        <c:when test="${item.gameType eq 'EXHIBITION'}">
                                                            <span class="badge-game-type badge-exhibition">시범</span>
                                                        </c:when>
                                                        <c:when test="${item.gameType eq 'REGULAR'}">
                                                            <span class="badge-game-type badge-regular">정규</span>
                                                        </c:when>
                                                        <c:when test="${item.gameType eq 'POST'}">
                                                            <span class="badge-game-type badge-post">포스트</span>
                                                        </c:when>
                                                        <c:when test="${item.gameType eq 'ALLSTAR'}">
                                                            <span class="badge-game-type badge-allstar">올스타</span>
                                                        </c:when>
                                                    </c:choose>--%>
                                                </div>
                                            </div>

                                            <c:choose>
                                                <%-- 1. 경기중 --%>
                                                <c:when test="${item.gameStatus eq 'LIVE'}">
                                                    <div class="during"><div class="badge">경기중</div></div>
                                                </c:when>

                                                <%-- 2. 취소된 경기 --%>
                                                <c:when test="${item.gameStatus eq 'CANCELLED'}">
                                                    <div class="cancel">
                                                        <div class="badge">취소(${not empty item.cancelReason ? item.cancelReason : '우천'})</div>
                                                    </div>
                                                </c:when>

                                                <%-- 3. 승리한 경기 --%>
                                                <c:when test="${item.gameStatus eq 'FINISHED' and item.gameResult eq 'WIN'}">
                                                    <div class="score_win">
                                                        <img src="/img/thumbs-up.svg" alt="승리">
                                                    </div>
                                                </c:when>
                                            </c:choose>
                                        </div>
                                        <div class="diary_review">${item.oneLineComment}</div>
                                    </div>
                                </div>
                            </c:forEach>

                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="../include/tabbar.jsp" %>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
</body>
</html>