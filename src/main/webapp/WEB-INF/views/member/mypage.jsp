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

    <title>마이페이지 | 승요일기</title>

    <style>
        /* 프로필 영역을 가로 배치(Flex)로 변경 */
        .mypage-profile {
            display: flex !important;
            align-items: center;
            justify-content: flex-start;
            text-align: left;
            padding: 20px 0;
        }

        /* 썸네일 크기 축소 및 여백 조정 */
        .mypage-profile .thumb {
            width: 72px !important;  /* 기존보다 작게 설정 */
            height: 72px !important;
            flex-shrink: 0;          /* 줄어들지 않도록 고정 */
            margin: 0 20px 0 0 !important; /* 오른쪽 여백 추가, 기존 중앙 정렬(auto) 제거 */
        }

        /* 프로필 정보 영역 (닉네임 + 버튼) */
        .mypage-profile .profile-info {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            align-items: flex-start; /* 왼쪽 정렬 */
        }

        /* 닉네임 스타일 보정 */
        .mypage-profile .nickname {
            margin-top: 0 !important;
            font-size: 20px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        /* 팀 로고 크기 조정 */
        .my-team-logo {
            width: 22px;
            height: 22px;
            vertical-align: middle;
        }

        /* 프로필 관리 버튼 위치 조정 */
        .mypage-profile .btn-manage {
            margin-top: 8px;
            margin-left: 0;
            height: 32px;
            line-height: 30px;
            font-size: 13px;
            padding: 0 14px;
        }
    </style>

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
</head>

<body>
    <div class="app">

        <div class="app-main">

            <div class="app-tit" style="justify-content: flex-start; gap: 12px; align-items: center;">
                <div class="img-box" style="width:42px; height:42px; border-radius:50%; overflow:hidden; border:1px solid #eee; flex-shrink: 0;">
                    <img src="${not empty member.profileImage ? member.profileImage : '/img/ico_user.svg'}"
                         alt="프로필 이미지"
                         onclick="location.href='/member/update/profile'"
                         style="width:100%; height:100%; object-fit:cover; cursor:pointer; display:block;">
                </div>
                <div class="page-tit" style="font-size: 20px; font-weight: 700; display: flex; align-items: center; gap: 8px;">
                    <div>
                        <span id="userName">
                            <a href="javascript:location.href='/member/update/profile'">${member.nickname}</a>
                        </span> 님
                    </div>
                    <c:if test="${not empty winYo.countLevelName}">
                        <span style="font-size: 13px; font-weight: 600; color: #1A7CFF; background-color: #EBF4FF; padding: 4px 10px; border-radius: 12px; letter-spacing: -0.3px; line-height: 1;">${winYo.countLevelName}</span>
                    </c:if>
                </div>
            </div>

            <div class="stack mt-24">

                <div class="my-info">

                    <div class="my-info_item">
                        <div class="tit">계정</div>
                        <ul>
                            <li>
                                <div class="gu">가입 수단</div>
                                <div class="nae">
                                    <c:choose>
                                        <c:when test="${empty member.socialProvider or member.socialProvider eq 'NONE'}">이메일</c:when>
                                        <c:otherwise>${member.socialProvider}</c:otherwise>
                                    </c:choose>
                                </div>
                            </li>
                            <li>
                                <div class="gu">아이디</div>
                                <div class="nae">${member.email}</div>
                            </li>
                            <li>
                                <a href="/member/update/password">비밀번호 변경</a>
                            </li>
                        </ul>
                    </div>

                    <div class="my-info_item">
                        <div class="tit">서비스 관리</div>
                        <ul>
                            <li>
                                <a href="/member/update/profile">프로필 설정</a>
                            </li>
                            <li>
                                <a href="/member/team-setting">응원 팀 관리</a>
                            </li>
                            <li>
                                <a href="/member/follow/list">팔로우 관리</a>
                            </li>
                            <li>
                                <a href="/member/alarm/setting">알림 설정</a>
                            </li>
                            <li>
                                <a href="/member/review/list">댓글 관리</a>
                            </li>
                        </ul>
                    </div>

                    <div class="my-info_item">
                        <div class="tit">이용 안내</div>
                        <ul>
                            <li>
                                <a href="/policy/privacy">개인정보처리방침</a>
                            </li>
                            <li>
                                <a href="/policy/terms">이용약관</a>
                            </li>
                            <li>
                                <a href="/policy/location">위치정보 이용약관</a>
                            </li>
                        </ul>
                    </div>

                    <div class="my-info_item">
                        <div class="tit">기타</div>
                        <ul>
                            <li>
                                <a href="javascript:void(0);" onclick="openLogoutPopup()">로그아웃</a>
                            </li>
                            <%--<li>
                                <a href="javascript:void(0);" onclick="openWithdrawPopup()">탈퇴하기</a>
                            </li>--%>
                        </ul>
                    </div>
                </div>

                <div class="withdraw-area" style="margin-top: 40px; padding-bottom: 20px; text-align: center;">
                    <a href="javascript:void(0);" onclick="openWithdrawPopup()"
                       style="font-size: 13px; color: #a6a9b0; text-decoration: underline;">
                        탈퇴하기
                    </a>
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
        // 로그아웃 팝업
        function openLogoutPopup() {
            showPopup('confirm', '로그아웃 하시겠어요?<br />로그아웃하면 서비스를 이용할 수 없어요.', function() {
                location.href = '/member/logout';
            });
            // 확인 버튼 텍스트를 '로그아웃'으로 바꾸고 싶다면 추가 스크립트 작성 가능
            document.getElementById('popupConfirmBtn').innerText = '로그아웃';
        }

        // 회원탈퇴 팝업
        function openWithdrawPopup() {
            showPopup('confirm', '정말 탈퇴하시겠습니까?<br />모든 데이터가 삭제되며 복구할 수 없습니다.', function() {
                location.href = '/member/withdraw';
            });
            document.getElementById('popupConfirmBtn').innerText = '탈퇴하기';
        }
    </script>
</body>
</html>