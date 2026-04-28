<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!doctype html>
<html lang="ko">
<head>
    <meta name="naver-site-verification" content="07e0fdf4e572854d6fbe274f47714d3e7bbb9fbd" />
    <meta charset="utf-8" />
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover"/>
    <meta name="format-detection" content="telephone=no,email=no,address=no"/>
    <meta name="apple-mobile-web-app-capable" content="yes"/>
    <meta name="mobile-web-app-capable" content="yes"/>

    <link rel="icon" href="/favicon.ico"/>
    <link rel="shortcut icon" href="/favicon.ico"/>
    <link rel="manifest" href="/site.webmanifest"/>

    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">

    <title>알림 | 승요일기</title>

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
                <div class="page-tit">알림</div>
            </div>

            <div class="notice-list mt-24">

                <c:if test="${empty list}">
                    <div class="no-data" style="text-align:center; padding:50px 0; color:#999;">
                        새로운 알림이 없습니다.
                    </div>
                </c:if>

                <c:forEach var="item" items="${list}">
                    <div class="card notice-item ${item.read ? 'read' : ''}"
                         onclick="readAndGo(${item.alarmId}, '${item.redirectUrl}')" style="cursor:pointer;">
                        <div class="row">
                            <span class="status-badge">
                                <c:choose>
                                    <c:when test="${item.category eq 'GAME'}">경기</c:when>
                                    <c:when test="${item.category eq 'NEWS'}">소식</c:when>
                                    <c:when test="${item.category eq 'EVENT'}">이벤트</c:when>
                                    <c:when test="${item.category eq 'FRIEND'}">친구</c:when>
                                    <c:when test="${item.category eq 'SYSTEM'}">안내</c:when>
                                    <c:otherwise>알림</c:otherwise>
                                </c:choose>
                            </span>
                            <div class="notice-item_time text-muted">
                                ${fn:substring(item.createdAt, 5, 10)}
                            </div>
                        </div>
                        <c:if test="${not empty item.title}">
                          <div class="notice-item_tit mt-8" style="font-weight: 600; font-size: 15px; color: #222;">
                              ${item.title}
                          </div>
                      </c:if>

                      <p class="notice-item_desc mt-4" style="color: #666;">${item.content}</p>
                  </div>
                </c:forEach>

                <div class="message mt-16">
                    최근 7일 전 알림까지 확인할 수 있어요
                </div>
            </div>
        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
    <script>
        function readAndGo(alarmId, url) {
            // 1. 읽음 처리 요청
            $.post('/alarm/read', {alarmId: alarmId});

            // 2. 페이지 이동 (URL이 있을 경우)
            if (url && url !== 'null' && url !== '') {
                location.href = url;
            }
        }
    </script>
</body>
</html>