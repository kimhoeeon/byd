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

    <title>친구들의 직관 | 승요일기</title>

    <style>
        .team img { width: 48px; height: 48px; object-fit: contain; display: block; margin: 0 auto; }
        .review_list li.hidden-cmt { display: none; }
        .del-btn { background: none; border: none; padding: 0; cursor: pointer; }

        /* 승요 뱃지 내부 스타일 선언 (테마 변수 적용 완료) */
        .result-badge-wrap {
            background-color: #f8f9fa; border-radius: 8px; padding: 16px; display: flex; align-items: center; justify-content: space-between; border: 1px solid var(--color-border, #eee);
        }
        .result-badge-wrap .tit { font-size: 14px; font-weight: 700; color: var(--color-text, #555); margin-bottom: 0; }
        .result-badge { font-size: 14px; font-weight: 700; padding: 6px 12px; border-radius: 6px; display: inline-flex; align-items: center; gap: 4px; }
        .result-badge.win { background-color: #E8F3FF; color: var(--color-primary, #1A7CFF); }
        .result-badge.lose { background-color: #FEE8E8; color: var(--color-danger, #FF4D4D); }
        .result-badge.draw { background-color: #F1F1F1; color: #666; }
        .result-badge.none { background-color: #f5f5f5; color: #999; }
    </style>

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
                <div class="page-tit">친구들의 직관</div>

                <div class="location-certify">
                    <c:choose>
                        <c:when test="${diary.verified}">
                            <button class="btn btn-certify-comp w-auto" type="button" id="verifyComplete">
                                직관 인증완료!
                            </button>
                        </c:when>
                        <c:otherwise>
                            <div class="certify_mes" style="opacity: 0.5; filter: grayscale(1);">
                                <img src="/img/ico_certify-not_p.svg" alt="미인증">인증하지 않았어요
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="page-main_wrap">
                <div class="history">
                    <div class="history-list mt-24">
                        <div class="diary_write_form">

                            <div class="diary_write_list nodt_line friend_info_wrap">
                                <div class="friend_info">
                                    <div class="friend_item">
                                        <div class="name">${writer.nickname}</div>
                                        <div class="friend_team">${writer.myTeamCode}</div>
                                    </div>
                                    <div class="win_rate">
                                        승요력 <fmt:formatNumber value="${writerWinYo.winRate}" pattern="#,##0"/>%
                                    </div>
                                </div>

                                <div class="follow-btn">
                                    <c:choose>
                                        <c:when test="${writer.memberId eq sessionScope.loginMember.memberId}">
                                            </c:when>
                                        <c:otherwise>
                                            <c:choose>
                                                <c:when test="${isFollowing}">
                                                    <button class="btn not-follow w-auto" type="button" onclick="toggleFollow(${writer.memberId})">취소</button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn follow w-auto" type="button" onclick="toggleFollow(${writer.memberId})">팔로우</button>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="diary_write_list diary_character">
                                <div class="tit">직관할 경기</div>
                                <button class="select-field" disabled>
                                    <span class="select-field_value">
                                        [${diary.stadiumName}] ${diary.awayTeamName} vs ${diary.homeTeamName}
                                        <c:if test="${not empty diary.gameDate}">
                                            <fmt:parseDate value="${diary.gameDate}" pattern="yyyy-MM-dd" var="pDate" type="date"/>
                                            <span style="font-weight:400; color:#666; font-size:13px; margin-left:4px;">
                                                <fmt:formatDate value="${pDate}" pattern="MM.dd"/> ${diary.gameTime}
                                            </span>
                                        </c:if>
                                    </span>
                                </button>
                            </div>

                            <%-- 직관 승패 결과 뱃지 --%>
                            <div class="result-badge-wrap">
                                <div class="tit">직관 승패 결과</div>
                                <div>
                                    <c:choose>
                                        <c:when test="${diary.gameStatus eq 'FINISHED'}">
                                            <c:choose>
                                                <c:when test="${diary.gameResult eq 'WIN'}">
                                                    <span class="result-badge win"><img src="/img/ico_crown.svg" style="width:16px;"> 승리 요정 달성!</span>
                                                </c:when>
                                                <c:when test="${diary.gameResult eq 'LOSE'}">
                                                    <span class="result-badge lose">패배 요정 (응원팀 패배)</span>
                                                </c:when>
                                                <c:when test="${diary.gameResult eq 'DRAW'}">
                                                    <span class="result-badge draw">무승부</span>
                                                </c:when>
                                                <c:when test="${diary.gameResult eq 'NONE'}">
                                                    <span class="result-badge none">승패 무관 (타팀 관전)</span>
                                                </c:when>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="result-badge none" style="background:transparent; border:1px solid #ddd;">경기 진행 전/중</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="diary_write_list diary_character yellow">
                                <div class="tit">오늘의 스코어 예상해 본다면?</div>
                                <div class="card_item">
                                    <div class="game-board">
                                        <div class="row row-center gap-6">
                                            <div class="team">
                                                <c:if test="${diary.awayTeamCode eq writer.myTeamCode}">
                                                    <div class="my-team">MY</div>
                                                </c:if>
                                                <img src="${diary.awayTeamLogo}" alt="${diary.awayTeamName}" onerror="this.src='/img/team_default.svg'">
                                                <div class="team-name mt-4">${diary.awayTeamName}</div>
                                            </div>

                                            <div class="game-score schedule">
                                                <div class="left-team-score">
                                                    <div class="score-data">${diary.predScoreAway}</div>
                                                </div>
                                                <div class="game-info-wrap" style="color:#ccc; font-weight:700;">VS</div>
                                                <div class="right-team-score">
                                                    <div class="score-data">${diary.predScoreHome}</div>
                                                </div>
                                            </div>

                                            <div class="team">
                                                <c:if test="${diary.homeTeamCode eq writer.myTeamCode}">
                                                    <div class="my-team">MY</div>
                                                </c:if>
                                                <img src="${diary.homeTeamLogo}" alt="${diary.homeTeamName}" onerror="this.src='/img/team_default.svg'">
                                                <div class="team-name mt-4">${diary.homeTeamName}</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="diary_write_list">
                                <div class="tit">오늘의 히어로는 누구일까?</div>
                                <input type="text" value="${diary.heroName}" placeholder="최대 100자까지 입력하실 수 있습니다." disabled>
                            </div>

                            <div class="diary_write_list">
                                <div class="tit">오늘의 경기를 한 마디로 평가한다면?!</div>
                                <input type="text" value="${diary.oneLineComment}" placeholder="최대 100자까지 입력하실 수 있습니다." disabled>
                            </div>

                            <div class="diary_write_list">
                                <div class="tit">오늘의 경기를 기록해 보세요</div>
                                <textarea placeholder="최대 1,000자까지 입력하실 수 있습니다." disabled style="height: auto; min-height: 120px; background-color: #f9f9f9;">${diary.content}</textarea>
                            </div>

                            <div class="diary_write_list">
                                <div class="tit">오늘 경기 사진</div>
                                <c:choose>
                                    <c:when test="${not empty diary.imageUrl}">
                                        <div style="display:flex; flex-direction:column; gap:16px; width:100%;">
                                            <c:set var="imgArr" value="${fn:split(diary.imageUrl, ',')}" />
                                            <c:forEach var="imgSrc" items="${imgArr}">
                                                <c:if test="${not empty imgSrc}">
                                                    <div style="border-radius:8px; overflow:hidden; border:1px solid #eee;">
                                                        <img src="${imgSrc}" alt="업로드 이미지" style="width:100%; display:block; object-fit:cover;">
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div style="color:#999; font-size:13px; padding:10px 0;">등록된 사진이 없습니다.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="card_wrap play_wrap gap-16">
                            <div class="card_item pt-24 pb-24">
                                <div class="review_wrap">
                                    <ul class="review_list" id="reviewList">
                                        <c:forEach var="cmt" items="${comments}" varStatus="status">
                                            <li class="${status.index >= 5 ? 'hidden-cmt' : ''}">
                                                <div class="name">
                                                    <c:if test="${not empty cmt.memberTeamCode}">
                                                        <span>${cmt.memberTeamCode}</span>
                                                    </c:if>
                                                    ${cmt.nickname}
                                                </div>
                                                <div class="nae">${cmt.content}</div>

                                                <c:if test="${cmt.memberId eq sessionScope.loginMember.memberId}">
                                                    <button class="del-btn" style="float:right;" onclick="deleteComment(${cmt.commentId}, this)">
                                                        <img src="/img/ico_del.svg" alt="삭제" style="width:16px; opacity:0.5;">
                                                    </button>
                                                </c:if>
                                            </li>
                                        </c:forEach>

                                        <c:if test="${empty comments}">
                                            <li style="text-align:center; padding:20px; color:#999; border:none;">
                                                아직 작성된 댓글이 없습니다.
                                            </li>
                                        </c:if>
                                    </ul>

                                    <c:if test="${fn:length(comments) > 5}">
                                        <div class="more-btn" id="moreBtn" onclick="showAllComments()">
                                            <div class="btn">더 보기</div>
                                        </div>
                                    </c:if>

                                    <div class="review_write">
                                        <div class="tit">댓글 작성하기</div>
                                        <div class="write_input">
                                            <input type="text" id="cmtContent" placeholder="댓글을 입력하세요. (30자 이내)" maxlength="30" onkeyup="checkCmtInput()">
                                            <button class="send wpx-80" id="btnCmtSend" disabled onclick="submitComment()">
                                                작성
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <div class="bottom-action bottom-main">
            <button type="button" class="btn btn-primary" onclick="location.href='/diary/friend/list'">
                목록으로
            </button>
        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>

    <script>
        function toggleFollow(targetId) {
            const $btn = $('.follow-btn button');
            if ($btn.prop('disabled')) return;
            $btn.prop('disabled', true);

            $.post('/member/follow/toggle', { targetId: targetId }, function(res) {
                // 서버 응답값 매칭 및 클래스 토글링
                if (res === 'followed') {
                    $btn.removeClass('follow').addClass('not-follow').text('취소');
                } else if (res === 'unfollowed') {
                    $btn.removeClass('not-follow').addClass('follow').text('팔로우');
                } else if (res === 'fail:self') {
                    alert('자기 자신은 팔로우할 수 없습니다.');
                } else if (res.startsWith('fail:login')) {
                    alert('로그인이 필요합니다.');
                    location.href = '/member/login';
                } else {
                    alert('요청을 처리하지 못했습니다.');
                }
            }).fail(function() {
                alert('서버 통신 오류가 발생했습니다.');
            }).always(function() {
                $btn.prop('disabled', false);
            });
        }

        function checkCmtInput() {
            const val = $('#cmtContent').val().trim();
            $('#btnCmtSend').prop('disabled', val.length === 0);
        }

        function submitComment() {
            const content = $('#cmtContent').val().trim();
            const diaryId = '${diary.diaryId}';
            if (!content) return;

            $('#btnCmtSend').prop('disabled', true).text('등록중..');
            $.post('/diary/comment/write', { diaryId: diaryId, content: content }, function (res) {
                if (res === 'ok') location.reload();
                else if (res.startsWith('fail:login')) {
                    alert('로그인 필요'); location.href = '/member/login';
                } else {
                    alert('등록 실패'); $('#btnCmtSend').prop('disabled', false).text('작성');
                }
            });
        }

        function deleteComment(commentId, btn) {
            if (!confirm('삭제하시겠습니까?')) return;
            $.post('/diary/comment/delete', { commentId: commentId }, function (res) {
                if (res === 'ok') {
                    $(btn).closest('li').fadeOut(300, function() { $(this).remove(); });
                } else {
                    alert('삭제 권한이 없거나 실패했습니다.');
                }
            });
        }

        function showAllComments() {
            $('.hidden-cmt').slideDown();
            $('#moreBtn').hide();
        }
    </script>
</body>
</html>