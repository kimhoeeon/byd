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

    <title>콘텐츠 상세 | 승요일기</title>

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>

    <style>
        .d-none { display: none !important; }
        /* Summernote 에디터 스타일 강제 복원 */
        .notice_view_body .txt { font-size: 14px; line-height: 1.6; color: #333; }
        .notice_view_body .txt b, .notice_view_body .txt strong { font-weight: bold !important; }
        .notice_view_body .txt i, .notice_view_body .txt em { font-style: italic !important; }
        .notice_view_body .txt u { text-decoration: underline !important; }
        .notice_view_body .txt a { color: #0d6efd !important; text-decoration: underline !important; cursor: pointer; }
        .notice_view_body .txt ul { list-style-type: disc !important; padding-left: 20px !important; margin: 10px 0 !important; }
        .notice_view_body .txt ol { list-style-type: decimal !important; padding-left: 20px !important; margin: 10px 0 !important; }
        .notice_view_body .txt li { margin-bottom: 5px !important; display: list-item !important; }
        .notice_view_body .txt p { margin-bottom: 10px !important; }
        .notice_view_body .txt img { max-width: 100% !important; height: auto !important; }

        /* 유튜브/인스타 iframe 반응형 래퍼 */
        .video-container { position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; border-radius: 8px; margin-bottom: 20px;}
        .video-container iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }

        .og-card { display: flex; flex-direction: column; border: 1px solid #e1e1e1; border-radius: 12px; overflow: hidden; text-decoration: none !important; color: #333; background: #fff; box-shadow: 0 2px 8px rgba(0,0,0,0.04); transition: transform 0.2s;}
        .og-card:hover { transform: translateY(-2px); }
        .og-card img { width: 100%; height: 180px; object-fit: cover; border-bottom: 1px solid #f0f0f0; }
        .og-card-info { padding: 16px; }
        .og-card-title { font-weight: bold; font-size: 15px; margin-bottom: 6px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; line-height: 1.4; color: #111;}
        .og-card-desc { font-size: 13px; color: #666; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; margin-bottom: 10px; line-height: 1.4; }
        .og-card-domain { font-size: 11px; color: #999; text-transform: lowercase; }

        /* Summernote 에디터 본문 전용 스타일 복원 (reset.css 무효화) */
        #contentBody { line-height: 1.6; word-break: keep-all; }
        #contentBody h1 { font-size: 2em; font-weight: bold; margin: 0.67em 0; }
        #contentBody h2 { font-size: 1.5em; font-weight: bold; margin: 0.83em 0; }
        #contentBody h3 { font-size: 1.17em; font-weight: bold; margin: 1em 0; }
        #contentBody h4 { font-size: 1em; font-weight: bold; margin: 1.33em 0; }
        #contentBody h5 { font-size: 0.83em; font-weight: bold; margin: 1.67em 0; }
        #contentBody h6 { font-size: 0.67em; font-weight: bold; margin: 2.33em 0; }
        #contentBody p { margin: 1em 0; }
        #contentBody b, #contentBody strong { font-weight: bold; }
        #contentBody i, #contentBody em { font-style: italic; }
        #contentBody u { text-decoration: underline; }
        #contentBody s, #contentBody strike { text-decoration: line-through; }
        #contentBody ul { list-style-type: disc; padding-left: 40px; margin: 1em 0; }
        #contentBody ol { list-style-type: decimal; padding-left: 40px; margin: 1em 0; }
        #contentBody li { display: list-item; margin-bottom: 4px; }
        #contentBody a { color: #007bff; text-decoration: underline; cursor: pointer; }
        #contentBody a:hover { color: #0056b3; }
        #contentBody blockquote { margin: 1em 40px; border-left: 4px solid #ccc; padding-left: 16px; color: #666; }
        #contentBody img { max-width: 100%; height: auto; } /* 이미지 반응형 처리 */
    </style>
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
                <div class="page-tit">우리 팀 추천 콘텐츠</div>
            </div>

            <div class="page-main_wrap mt-24">
                <div class="notice_view">

                    <div class="notice_view_head">
                        <div class="tit">${post.title}</div>
                        <div class="date">
                            <fmt:parseDate value="${post.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both"/>
                            <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd"/>
                        </div>
                    </div>

                    <div class="notice_view_body">
                        <c:if test="${not empty post.imageUrl}">
                            <div class="img-box" style="margin-bottom:20px;">
                                <img src="${post.imageUrl}" alt="콘텐츠 이미지" style="width:100%; border-radius:8px;">
                            </div>
                        </c:if>

                        <div class="txt" id="contentBody">
                            ${post.content}
                        </div>

                        <c:if test="${not empty post.contentUrl}">
                            <div id="urlPreviewBox" data-url="${post.contentUrl}" style="margin-top: 24px; padding-top: 24px; border-top: 1px dashed #eee;">
                            </div>
                        </c:if>
                    </div>

                </div>

                <div class="card_wrap">
                    <div class="card_item">
                        <div class="like_wrap">
                            <ul>
                                <li>
                                    <button type="button" class="like_btn good ${userReaction eq 'LIKE' ? 'active' : ''}" onclick="toggleReaction('LIKE')">
                                        <div class="icon">
                                            <img src="/img/${userReaction eq 'LIKE' ? 'good_icon-active.svg' : 'good_icon.svg'}" alt="좋아요">
                                        </div>
                                        <div>
                                            <div class="tit">좋아요</div>
                                            <div class="num">${post.likeCount}</div>
                                        </div>
                                    </button>
                                </li>
                                <li>
                                    <button type="button" class="like_btn sad ${userReaction eq 'SAD' ? 'active' : ''}" onclick="toggleReaction('SAD')">
                                        <div class="icon">
                                            <img src="/img/${userReaction eq 'SAD' ? 'sad_icon-active.svg' : 'sad_icon.svg'}" alt="슬퍼요">
                                        </div>
                                        <div>
                                            <div class="tit">슬퍼요</div>
                                            <div class="num">${post.sadCount}</div>
                                        </div>
                                    </button>
                                </li>
                                <li>
                                    <button type="button" class="like_btn sad ${userReaction eq 'ANGRY' ? 'active' : ''}" onclick="toggleReaction('ANGRY')">
                                        <div class="icon">
                                            <img src="/img/${userReaction eq 'ANGRY' ? 'angry_icon-active.svg' : 'angry_icon.svg'}" alt="화나요">
                                        </div>
                                        <div>
                                            <div class="tit">화나요</div>
                                            <div class="num">${post.angryCount}</div>
                                        </div>
                                    </button>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="card_wrap play_wrap gap-16">
                    <div class="card_item pt-24 pb-24">
                        <div class="review_wrap">
                            <ul class="review_list" id="commentList">
                                <c:forEach var="cmt" items="${comments}" varStatus="status">
                                    <li class="${status.index >= 5 ? 'hidden-cmt d-none' : ''}">
                                        <div class="name" style="display: flex; align-items: center;">
                                            <c:choose>
                                                <c:when test="${not empty cmt.profileImage}">
                                                    <img src="${cmt.profileImage}" alt="프로필" style="width:24px; height:24px; border-radius:50%; object-fit:cover; margin-right:6px;">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="/img/ico_user.svg" alt="기본 프로필" style="width:24px; height:24px; border-radius:50%; background:#f5f5f5; padding:2px; margin-right:6px;">
                                                </c:otherwise>
                                            </c:choose>
                                            <c:if test="${not empty cmt.memberTeamCode}">
                                                <span>${cmt.memberTeamCode}</span>
                                            </c:if>
                                            &nbsp;${cmt.nickname}
                                        </div>
                                        <div class="nae">${cmt.content}</div>

                                        <c:if test="${cmt.memberId eq sessionScope.loginMember.memberId}">
                                            <button class="del-btn" onclick="deleteContentComment(${cmt.commentId})">
                                                <span><img src="/img/ico_del.svg" alt="삭제 아이콘"></span>
                                            </button>
                                        </c:if>
                                    </li>
                                </c:forEach>
                                <c:if test="${empty comments}">
                                    <li style="text-align:center; padding:30px 0; color:#999; border:none;">등록된 댓글이 없습니다.</li>
                                </c:if>
                            </ul>

                            <c:if test="${fn:length(comments) > 5}">
                                <div class="more-btn" id="commentMoreBtn" onclick="loadMoreComments()">
                                    <div class="btn">더 보기</div>
                                </div>
                            </c:if>

                            <div class="review_write">
                                <div class="tit">댓글 작성하기</div>
                                <div class="write_input">
                                    <input type="text" id="contentCommentInput" placeholder="댓글을 입력하세요. (30자 이내)" maxlength="30" onkeyup="checkContentCommentInput()">
                                    <button class="send wpx-80" id="contentCommentSubmitBtn" disabled onclick="submitContentComment()">
                                        작성
                                    </button>
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

    <script>
        $(document).ready(function() {

            // 본문 내 썸머노트 첨부 유튜브(iframe) 반응형 처리 (안전한 방식)
            $('#contentBody iframe').each(function() {
                if (!$(this).parent().hasClass('video-container')) {
                    $(this).wrap('<div class="video-container"></div>');
                    $(this).removeAttr('width').removeAttr('height');
                }
            });

            // 본문 내부의 새창 열기 링크 안전 처리
            $('#contentBody a').on('click', function(e) {
                var href = $(this).attr('href');
                if(href && href.startsWith('http')) {
                    e.preventDefault(); window.open(href, '_blank');
                }
            });

            // 2. '콘텐츠 URL' 항목 스마트 렌더링 (유튜브 vs 썸네일 카드)
            var contentUrl = $('#urlPreviewBox').data('url');
            if (contentUrl) {
                var singleYtRegex = /(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/;
                var match = contentUrl.match(singleYtRegex);

                if (match && match[1]) {
                    // [유튜브 링크인 경우] 즉시 플레이어로 렌더링
                    $('#urlPreviewBox').html('<div class="video-container"><iframe src="https://www.youtube.com/embed/' + match[1] + '" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>');
                } else {
                    // [인스타/블로그 등 일반 링크인 경우] 백엔드 API를 호출해 카카오톡 스타일 카드 렌더링
                    $.get('/locker/extract-og', { url: contentUrl }, function(res) {
                        if (!res.error && res.title) {
                            var cardHtml = `
                                <a href="\${contentUrl}" target="_blank" class="og-card">
                                    \${res.image ? '<img src="' + res.image + '" alt="링크 썸네일">' : ''}
                                    <div class="og-card-info">
                                        <div class="og-card-title">\${res.title}</div>
                                        <div class="og-card-desc">\${res.description}</div>
                                        <div class="og-card-domain">\${res.domain}</div>
                                    </div>
                                </a>
                            `;
                            $('#urlPreviewBox').html(cardHtml);
                        } else {
                            // 메타태그가 없는 사이트의 경우 기본 버튼형 링크 제공
                            $('#urlPreviewBox').html('<a href="' + contentUrl + '" target="_blank" style="display:block; text-align:center; padding:14px; background:#f8f9fa; border-radius:8px; color:#333; text-decoration:none; font-weight:bold;">🔗 외부 관련 콘텐츠 보러가기</a>');
                        }
                    });
                }
            }
        });

        // 공감 반응 토글 함수
        function toggleReaction(type) {
            $.post('/locker/content/reaction', { contentId: ${post.contentId}, reactionType: type }, function(res) {
                if(res.resultCode === 'SUCCESS') {
                    location.reload(); // 즉시 화면 갱신
                } else {
                    alert(res.resultMessage || '오류가 발생했습니다.');
                }
            });
        }

        // 댓글 입력 버튼 활성화 감지
        function checkContentCommentInput() {
            var val = $('#contentCommentInput').val().trim();
            if(val.length > 0) {
                $('#contentCommentSubmitBtn').prop('disabled', false).css('opacity', '1');
            } else {
                $('#contentCommentSubmitBtn').prop('disabled', true).css('opacity', '0.5');
            }
        }

        // 더보기 버튼
        function loadMoreComments() {
            $('#commentList li.hidden-cmt').removeClass('d-none');
            $('#commentMoreBtn').hide();
        }

        // 댓글 작성
        function submitContentComment() {
            var content = $('#contentCommentInput').val().trim();
            if(!content) return;

            $.post('/locker/content/comment/add', { contentId: ${post.contentId}, content: content }, function(res) {
                if(res.resultCode === 'SUCCESS') {
                    location.reload();
                } else {
                    alert(res.resultMessage || '댓글 작성에 실패했습니다.');
                }
            });
        }

        // 댓글 삭제
        function deleteContentComment(commentId) {
            if(!confirm('댓글을 삭제하시겠습니까?')) return;
            $.post('/locker/content/comment/delete', { commentId: commentId }, function(res) {
                if(res.resultCode === 'SUCCESS') {
                    location.reload();
                }
            });
        }
    </script>
</body>
</html>