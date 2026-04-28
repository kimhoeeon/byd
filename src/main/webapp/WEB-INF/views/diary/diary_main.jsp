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

    <title>직관 일기 메인 | 승요일기</title>

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
</head>

<body>
    <div class="app">
        <div class="top_wrap">
            <div class="main-top">
                <div class="main-title">
                    직관일기
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
                    <button type="button" class="tab-pill_btn on" onclick="location.href='/diary/winyo'">나의 기록</button>
                    <button type="button" class="tab-pill_btn" onclick="location.href='/diary/friend/list'">친구 일기</button>
                </div>

                <a href="/member/search" class="btn-friend-search" style="display: flex; align-items: center; gap: 4px; font-size: 13px; font-weight: 600; color: #555;">
                    <img src="/img/ico_friend.svg" alt="검색" style="width: 18px; height: 18px;">
                    친구찾기
                </a>
            </div>

            <div class="page-main_wrap">

                <div class="history">
                    <div class="history-list">

                        <%--<div class="card_wrap clover">
                            <div class="card_item gap-16">
                                <div class="tit clover_tit">
                                    <c:choose>
                                        <c:when test="${not empty winYo.rateMessage}">
                                            ${winYo.rateMessage}
                                        </c:when>
                                        <c:otherwise>승요력 데이터가 필요해요! 직관을 기록해보세요.</c:otherwise>
                                    </c:choose>
                                </div>
                                <c:if test="${not empty winYo.countMessage}">
                                    <div style="font-size: 14px; font-weight: 500; color: #555;">
                                        ${winYo.countMessage}
                                    </div>
                                </c:if>
                                <div class="live-certify">
                                    <c:if test="${hasTodayGame}">
                                        <c:choose>
                                            <c:when test="${not empty todayDiaryId}">
                                                <a href="/diary/detail?diaryId=${todayDiaryId}" class="btn btn-primary" style="background-color:#EBF4FF; color:#1A7CFF; border:none;">
                                                    일기 보기
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="/diary/write" class="btn btn-primary">
                                                    직관 인증하기<span><img src="/img/ico_right_arrow.svg" alt=""></span>
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                </div>

                                <ul class="live-score">
                                    <li>
                                        <div>
                                            <p>나의 직관 승률</p>
                                            <div class="data">
                                                <fmt:formatNumber value="${winYo.winRate}" pattern="#,##0"/>%
                                            </div>
                                        </div>
                                        <c:choose>
                                            <c:when test="${winYo.winRate < 50}">
                                                <img src="/img/score_character01-2.svg" alt="스코어 캐릭터(패배)">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="/img/score_character01.svg" alt="스코어 캐릭터(승리)">
                                            </c:otherwise>
                                        </c:choose>
                                    </li>

                                    <li>
                                        <div>
                                            <p>나의 직관 경기</p>
                                            <div class="data">${winYo.totalGames}경기</div>
                                        </div>
                                        <img src="/img/score_character02.svg" alt="스코어 캐릭터">
                                    </li>

                                    <li>
                                        <div>
                                            <p>우리팀 전적</p>
                                            <div class="data">${winYo.winGames}승 <c:if test="${winYo.drawGames > 0}">${winYo.drawGames}무 </c:if>${winYo.loseGames}패</div>
                                         </div>
                                        <c:choose>
                                            <c:when test="${winYo.winRate < 50}">
                                                <img src="/img/score_character03-2.svg" alt="스코어 캐릭터(패배)">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="/img/score_character03.svg" alt="스코어 캐릭터(승리)">
                                            </c:otherwise>
                                        </c:choose>
                                    </li>

                                    <li>
                                        <div>
                                            <p>최다 방문 구장</p>
                                            <div class="data">${not empty winYo.topStadium ? winYo.topStadium : '-'}</div>
                                        </div>
                                        <img src="/img/score_character04.svg" alt="스코어 캐릭터">
                                    </li>
                                </ul>
                            </div>
                        </div>--%>

                        <div class="card_wrap diary_card">
                            <div class="card_item gap-16">
                                <div class="row history-head">
                                    <div class="tit diary_card_tit">나의 직관 일기</div>
                                    <a href="/diary/list">
                                        <img src="/img/ico_next_arrow.svg" alt="모두 보기">
                                    </a>
                                </div>

                                <c:if test="${empty myDiaries}">
                                    <div class="nodt_wrap only_txt">
                                        <div class="cont">
                                            <div class="nodt_txt">아직 직관 기록이 없어요.</div>
                                        </div>
                                    </div>
                                </c:if>

                                <div class="score_wrap">
                                    <c:forEach var="diary" items="${myDiaries}">
                                        <div class="score_list" onclick="location.href='/diary/detail?diaryId=${diary.diaryId}'">

                                            <c:set var="firstImage" value="" />
                                            <c:if test="${not empty diary.imageUrl}">
                                                <c:set var="imgArr" value="${fn:split(diary.imageUrl, ',')}" />
                                                <c:set var="firstImage" value="${imgArr[0]}" />
                                            </c:if>
                                            <div class="img">
                                                <img src="${not empty firstImage ? firstImage : '/img/card_defalut.svg'}"
                                                     alt="스코어카드 이미지"
                                                     onerror="this.src='/img/card_defalut.svg'"
                                                     style="width:100%; height:100%; object-fit:cover;">
                                            </div>

                                            <div class="score_txt">
                                                <div class="txt_box">
                                                    <div class="tit">
                                                        <%--<c:choose>
                                                            <c:when test="${diary.gameType eq 'EXHIBITION'}">
                                                                <span class="badge-game-type badge-exhibition">시범</span>
                                                            </c:when>
                                                            <c:when test="${diary.gameType eq 'REGULAR'}">
                                                                <span class="badge-game-type badge-regular">정규</span>
                                                            </c:when>
                                                            <c:when test="${diary.gameType eq 'POST'}">
                                                                <span class="badge-game-type badge-post">포스트</span>
                                                            </c:when>
                                                            <c:when test="${diary.gameType eq 'ALLSTAR'}">
                                                                <span class="badge-game-type badge-allstar">올스타</span>
                                                            </c:when>
                                                        </c:choose>--%>

                                                        ${diary.scoreAway} ${diary.awayTeamName} vs ${diary.homeTeamName} ${diary.scoreHome}
                                                    </div>
                                                    <div class="date">
                                                        <fmt:parseDate value="${diary.gameDate}" pattern="yyyy-MM-dd" var="pDate" type="date"/>
                                                        <fmt:formatDate value="${pDate}" pattern="yyyy-MM-dd"/>
                                                    </div>
                                                </div>
                                                <c:choose>
                                                    <%-- 1. 경기중 --%>
                                                    <c:when test="${diary.gameStatus eq 'LIVE'}">
                                                        <div class="during"><div class="badge">경기중</div></div>
                                                    </c:when>

                                                    <%-- 2. 취소된 경기 --%>
                                                    <c:when test="${diary.gameStatus eq 'CANCELLED'}">
                                                        <div class="cancel">
                                                            <div class="badge">취소(${not empty diary.cancelReason ? diary.cancelReason : '우천'})</div>
                                                        </div>
                                                    </c:when>

                                                    <%-- 3. 승리한 경기 --%>
                                                    <c:when test="${diary.gameStatus eq 'FINISHED' and diary.gameResult eq 'WIN'}">
                                                        <div class="score_win">
                                                            <img src="/img/thumbs-up.svg" alt="승리">
                                                        </div>
                                                    </c:when>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <div class="card_wrap friend">
                            <div class="card_item gap-16">
                                <div class="row history-head">
                                    <div class="tit friend_tit">
                                        <c:choose>
                                            <c:when test="${hasFriends}">
                                                <h3>친구들의 직관 일기는?</h3>
                                            </c:when>
                                            <c:otherwise>
                                                <h3>요즘 인기 있는 직관 일기 🔥</h3>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <a href="/diary/friend/list">
                                        <img src="/img/ico_next_arrow.svg" alt="모두 보기">
                                    </a>
                                </div>

                                <c:if test="${empty friendDiaries}">
                                    <div class="nodt_wrap only_txt">
                                        <div class="cont">
                                            <div class="nodt_txt">아직 친구들의 직관 기록이 없어요.</div>
                                        </div>
                                    </div>
                                </c:if>

                                <div class="score_wrap">
                                    <c:forEach var="item" items="${friendDiaries}">
                                        <div class="score_list" onclick="location.href='/diary/detail?diaryId=${item.diaryId}'">
                                            <c:set var="firstImage" value="" />
                                            <c:if test="${not empty item.imageUrl}">
                                                <c:set var="imgArr" value="${fn:split(item.imageUrl, ',')}" />
                                                <c:set var="firstImage" value="${imgArr[0]}" />
                                            </c:if>
                                            <div class="img">
                                                <img src="${not empty firstImage ? firstImage : '/img/card_defalut.svg'}"
                                                     alt="썸네일"
                                                     onerror="this.src='/img/card_defalut.svg'"
                                                     style="width:100%; height:100%; object-fit:cover;">
                                            </div>
                                            <div class="score_txt">
                                                <div class="txt_box">
                                                    <div class="tit">
                                                        ${item.scoreAway} ${item.awayTeamName} vs ${item.homeTeamName} ${item.scoreHome}
                                                    </div>
                                                    <div class="date">
                                                        ${item.nickname}
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <div class="card_wrap score_card">
                            <div class="row history-head">
                                <div class="tit score_card_tit">직관 스코어카드</div>
                            </div>
                            <div class="card_item">
                                <div class="score_card_wrap">
                                    <div class="tit">${stadiumStatus.size()}개 구장 중, ${visitedCount}개 구장에 방문했어요!</div>
                                    <ul class="score_card_item">
                                        <c:forEach var="stadium" items="${stadiumStatus}">
                                            <li>
                                                <%-- item 객체의 visited 속성 확인 --%>
                                                <c:choose>
                                                    <c:when test="${stadium.visited}">
                                                        <img src="/img/score_on.svg" alt="${stadium.name} 방문 완료" title="${stadium.name}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="/img/score_off.svg" alt="${stadium.name} 미방문" title="${stadium.name}">
                                                    </c:otherwise>
                                                </c:choose>

                                                <%-- (선택사항) 구장 이름 표시가 필요하다면 아래 주석 해제 --%>
                                                <%-- <div class="stadium-name" style="text-align:center; font-size:10px;">${stadium.name}</div> --%>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </div>
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