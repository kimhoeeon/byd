<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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

    <title>친구찾기 | 승요일기</title>

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
                <div class="page-tit">친구찾기</div>
            </div>

            <div class="stack mt-24">

                <form action="/member/search/result" method="get">
                    <div class="search-box">
                        <div class="input-row" style="display:flex; gap:8px;">
                            <input type="text" name="keyword" value="${keyword}" placeholder="닉네임을 검색해보세요" style="flex:1; padding:10px; border:1px solid #ddd; border-radius:8px; width:100%;">
                            <button type="submit" class="btn btn-primary" style="width:60px;">검색</button>
                        </div>
                    </div>
                </form>

                <c:choose>
                    <c:when test="${empty list and not empty keyword}">
                        <div class="tab_cont on">
                            <!-- 콘텐츠 없을 때 -->
                            <div class="score_list nodt_list pd-24">
                                <div class="nodt_wrap">
                                    <div class="cont">
                                        <img src="/img/ico_not_mark.svg" alt="데이터 비었을 때">
                                        <div class="nodt_tit">검색 결과가 없습니다.</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="tab_cont on">
                            <div class="people">${fn:length(list)}명</div>
                            <ul class="make gap-16">
                                <c:forEach var="mem" items="${list}">
                                    <li onclick="location.href='/diary/friend/list?targetMemberId=${mem.memberId}'" style="cursor:pointer;">
                                        <div class="diary_write_list nodt_line friend_info_wrap bg-gray">
                                            <div class="friend_info">

                                                <div class="friend_item <c:if test="${mem.following}">follow-back</c:if>">
                                                    <div class="name">${mem.nickname}</div>
                                                    <div class="friend_team">${not empty mem.myTeamName ? mem.myTeamName : '응원팀 없음'}</div>
                                                </div>

                                                <div class="win_rate">승요력 ${mem.winRateStr != null ? mem.winRateStr : '0%'}</div>
                                            </div>

                                            <div class="follow-btn">
                                                <c:choose>
                                                    <%-- 팔로잉 상태 (버튼 텍스트 '취소', 클래스 'not-follow') --%>
                                                    <c:when test="${mem.following}">
                                                        <button type="button" id="btn_${mem.memberId}"
                                                                class="btn not-follow w-auto"
                                                                onclick="event.stopPropagation(); toggleFollow(${mem.memberId})">
                                                            취소
                                                        </button>
                                                    </c:when>

                                                    <%-- 팔로우 안 한 상태 (버튼 텍스트 '팔로우', 클래스 'follow') --%>
                                                    <c:otherwise>
                                                        <button type="button" id="btn_${mem.memberId}"
                                                                class="btn follow w-auto"
                                                                onclick="event.stopPropagation(); toggleFollow(${mem.memberId})">
                                                            팔로우
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                        </div>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%@ include file="../include/tabbar.jsp" %>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
    <script>
        function toggleFollow(targetId) {
            const btn = document.getElementById('btn_' + targetId);

            // 버튼 비활성화 (중복 클릭 방지)
            btn.disabled = true;

            fetch('/member/follow/toggle?targetId=' + targetId, {method: 'POST'})
                .then(response => response.text())
                .then(res => {
                    btn.disabled = false;

                    if (res === 'followed') {
                        btn.innerText = '취소';
                        btn.classList.remove('follow');
                        btn.classList.add('not-follow');
                        // 맞팔 아이콘 추가 로직 (선택사항)
                        btn.closest('.friend_info_wrap').querySelector('.friend_item').classList.add('follow-back');
                    } else if (res === 'unfollowed') {
                        btn.innerText = '팔로우';
                        btn.classList.remove('not-follow');
                        btn.classList.add('follow');
                        // 맞팔 아이콘 제거 로직
                        btn.closest('.friend_info_wrap').querySelector('.friend_item').classList.remove('follow-back');
                    } else {
                        alert('오류가 발생했습니다.');
                    }
                })
                .catch(err => {
                    console.error(err);
                    btn.disabled = false;
                    alert('서버 통신 오류');
                });
        }
    </script>
</body>
</html>