<%-- views/diary/friend_list.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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

    <title>친구 일기 | 승요일기</title>

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
</head>

<body>
    <div class="app">

        <div class="top_wrap">
            <div class="main-top">
                <div class="main-title">
                    <c:choose>
                        <c:when test="${hasFriends}">
                            친구 일기
                        </c:when>
                        <c:otherwise>
                            추천 직관 일기
                        </c:otherwise>
                    </c:choose>
                </div>

                <button class="noti-btn ${hasUnreadAlarm ? 'has-badge' : ''}" onclick="location.href='/alarm/list'">
                    <span class="noti-btn_icon" aria-hidden="true"><img src="/img/ico_noti.svg" alt="알림 아이콘"></span>
                    <span class="noti-dot" aria-hidden="true"></span>
                </button>
            </div>
        </div>

        <div class="app-main">

            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">

                <div class="tab-pill" style="margin-bottom: 0; margin-top: 0;">
                    <button type="button" class="tab-pill_btn" onclick="location.href='/diary/all'">전체 보기</button>
                    <button type="button" class="tab-pill_btn" onclick="location.href='/diary/winyo'">나의 기록</button>
                    <button type="button" class="tab-pill_btn on" onclick="location.href='/diary/friend/list'">친구 일기</button>
                </div>

                <a href="/member/search" class="btn-friend-search" style="display: flex; align-items: center; gap: 4px; font-size: 13px; font-weight: 600; color: #555;">
                    <img src="/img/ico_friend.svg" alt="검색" style="width: 18px; height: 18px;">
                    친구찾기
                </a>
            </div>

            <c:if test="${empty targetMemberId}">
                <div class="tab-pill">
                    <button type="button" class="tab-pill_btn ${(param.tab == 'all' or empty tab or not hasFriends) ? 'on' : ''}" onclick="location.href='?tab=all'">전체</button>
                    <button type="button" class="tab-pill_btn ${(hasFriends and param.tab == 'follower') ? 'on' : ''}" onclick="location.href='?tab=follower'">나를 팔로우</button>
                    <button type="button" class="tab-pill_btn ${(hasFriends and param.tab == 'following') ? 'on' : ''}" onclick="location.href='?tab=following'">내가 팔로잉</button>
                </div>
            </c:if>

            <div class="page-main_wrap">

                <div class="history">
                    <div class="history-list mt-24">
                        <div class="score_wrap row_wrap">

                            <c:choose>
                                <c:when test="${empty list}">
                                    <div class="score_list nodt_list">
                                        <div class="nodt_wrap">
                                            <div class="cont">
                                                <img src="/img/ico_not_mark.svg" alt="데이터 비었을 때">
                                                <div class="nodt_tit">
                                                    <c:choose>
                                                        <c:when test="${!hasFriends and param.tab == 'all'}">
                                                            추천할 인기 직관 일기가 없습니다.
                                                        </c:when>
                                                        <c:when test="${param.tab == 'follower'}">
                                                            아직 나를 팔로우하는 친구가 없어요.
                                                        </c:when>
                                                        <c:when test="${empty param.tab or param.tab == 'following'}">
                                                            아직 팔로잉 중인 친구가 없어요.
                                                        </c:when>
                                                        <c:otherwise>
                                                            등록된 직관 기록이 없어요.
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:when>

                                <c:otherwise>
                                    <c:forEach var="item" items="${list}">
                                        <div class="score_list ${item.gameStatus == 'CANCELLED' ? 'cancel_list' : ''}"
                                             onclick="location.href='/diary/detail?diaryId=${item.diaryId}'"
                                             style="cursor: pointer;">

                                            <div class="img">
                                                <img src="${not empty item.imageUrl ? item.imageUrl : '/img/card_defalut.svg'}"
                                                     alt="스코어카드 이미지" style="width:100%; height:100%; object-fit:cover;">
                                            </div>

                                            <div class="column gap-16" style="flex:1;">
                                                <div class="score_txt">
                                                    <div class="txt_box">
                                                        <div class="tit">
                                                            ${item.scoreAway} ${item.awayTeamName} vs ${item.homeTeamName} ${item.scoreHome}
                                                        </div>
                                                        <div class="date">
                                                            ${item.gameDate} </div>
                                                    </div>

                                                    <c:choose>
                                                        <%-- Case 1: 경기 중 --%>
                                                        <c:when test="${item.gameStatus eq 'LIVE'}">
                                                            <div class="during">
                                                                <div class="badge">경기중</div>
                                                            </div>
                                                        </c:when>

                                                        <%-- Case 2: 경기 취소 --%>
                                                        <c:when test="${item.gameStatus eq 'CANCELLED'}">
                                                            <div class="cancel">
                                                                <div class="badge">
                                                                    취소${not empty item.cancelReason ? '(' += item.cancelReason += ')' : ''}
                                                                </div>
                                                            </div>
                                                        </c:when>

                                                        <%-- Case 3: 승리 (경기 종료 & 승리) --%>
                                                        <c:when test="${item.gameStatus eq 'FINISHED' and item.gameResult eq 'WIN'}">
                                                            <div class="score_win">
                                                                <img src="/img/thumbs-up.svg" alt="승리">
                                                            </div>
                                                        </c:when>
                                                    </c:choose>
                                                    </div>

                                                <div class="diary_review text-ellipsis-1">
                                                    ${item.oneLineComment}
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>

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
    <style>
        /* 한줄평 말줄임 처리 */
        .text-ellipsis-1 {
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            font-size: 14px;
            color: #333;
        }
    </style>
</body>
</html>