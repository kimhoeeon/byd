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

    <title>공지 및 설문 | 승요일기</title>

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
                <div class="page-tit">공지 및 설문</div>
            </div>

            <div class="page-main_wrap mt-24">
                <div class="notice_wrap">

                    <c:choose>
                        <c:when test="${empty list}">
                            <div class="no-data" style="text-align:center; padding:50px 0; color:#999;">
                                등록된 공지가 없습니다.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="item" items="${list}">
                                <div class="notice_list" onclick="location.href='/locker/notice/detail?noticeId=${item.noticeId}'" style="cursor:pointer;">
                                    <div class="notice_thum">
                                        <img src="${not empty item.imageUrl ? item.imageUrl : '/img/card_defalut.svg'}" alt="공지 썸네일">
                                    </div>
                                    <div class="notice_item">
                                        <div class="notice_txt">
                                            <div class="notice_badge ${item.category eq 'SURVEY' ? 'quest_badge' : ''}">
                                                ${item.category eq 'SURVEY' ? '설문' : '공지'}
                                            </div>
                                            <div class="tit">${item.title}</div>
                                        </div>
                                        <div class="date">
                                            <c:choose>
                                                <c:when test="${not empty item.createdAt}">
                                                    <c:set var="cDate" value="${fn:replace(item.createdAt, 'T', ' ')}" />
                                                    <c:choose>
                                                        <c:when test="${fn:length(cDate) > 19}">
                                                            ${fn:substring(cDate, 0, 19)}
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${cDate}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>

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