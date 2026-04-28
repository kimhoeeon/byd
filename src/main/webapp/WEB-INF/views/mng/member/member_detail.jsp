<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" />
    <meta name="format-detection" content="telephone=no,email=no,address=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="mobile-web-app-capable" content="yes" />
    <meta name="robots" content="noindex, nofollow">

    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="manifest" href="/site.webmanifest" />

    <title>회원 상세 | 승요일기 관리자</title>
    <link href="/assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/assets/css/style.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/css/mngStyle.css" rel="stylesheet">

    <style>
        .diary-history-list {
            max-height: 300px;
            overflow-y: auto;
            border: 1px solid var(--bs-gray-200);
            border-radius: 8px;
            background-color: #fff;
        }
        .diary-history-item {
            padding: 16px 20px;
            border-bottom: 1px dashed var(--bs-gray-200);
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
        }
        .diary-history-item:last-child {
            border-bottom: none;
        }
        .diary-history-item:hover {
            background-color: var(--bs-light);
        }
        .score-box {
            background: var(--bs-gray-200);
            padding: 4px 12px;
            border-radius: 6px;
            font-weight: 800;
            color: var(--bs-gray-900);
            font-size: 15px;
            letter-spacing: 1px;
        }
    </style>
</head>
<body id="kt_app_body"
      data-kt-app-layout="dark-sidebar"
      data-kt-app-header-fixed="true"
      data-kt-app-sidebar-enabled="true"
      data-kt-app-sidebar-fixed="true"
      data-kt-app-sidebar-hoverable="true"
      data-kt-app-sidebar-push-header="true"
      data-kt-app-sidebar-push-toolbar="true"
      data-kt-app-sidebar-push-footer="true"
      data-kt-app-toolbar-enabled="true"
      class="app-default">

    <div class="d-flex flex-column flex-root app-root" id="kt_app_root">
        <div class="app-page flex-column flex-column-fluid" id="kt_app_page">
            <jsp:include page="/WEB-INF/views/mng/include/header.jsp"/>
            <div class="app-wrapper flex-column flex-row-fluid" id="kt_app_wrapper">
                <jsp:include page="/WEB-INF/views/mng/include/sidebar.jsp"/>

                <div class="app-main flex-column flex-row-fluid" id="kt_app_main">
                    <div class="d-flex flex-column flex-column-fluid">

                        <div id="kt_app_toolbar" class="app-toolbar pt-6 pb-2 pt-lg-10 pb-lg-2">
                            <div id="kt_app_toolbar_container" class="app-container container-xxl d-flex flex-stack">
                                <div class="page-title d-flex flex-column justify-content-center flex-wrap me-3">
                                    <h1 class="page-heading d-flex text-dark fw-bold fs-3 flex-column justify-content-center my-0">
                                        회원 목록
                                    </h1>

                                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0 pt-1">
                                        <li class="breadcrumb-item text-muted">
                                            <a href="/mng/main.do" class="text-muted text-hover-primary">Home</a>
                                        </li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-muted">회원 관리</li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-dark">회원 목록</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card mb-5 mb-xl-10">
                                    <div class="card-header border-0 cursor-pointer">
                                        <div class="card-title m-0">
                                            <h3 class="fw-bold m-0">회원 상세 정보</h3>
                                        </div>
                                        <div class="card-toolbar">
                                            <c:if test="${member.status eq 'ACTIVE'}">
                                                <button type="button" class="btn btn-sm btn-light-warning me-2" onclick="changeStatus('SUSPENDED')">
                                                    활동 정지
                                                </button>
                                                <button type="button" class="btn btn-sm btn-light-danger me-2" onclick="changeStatus('WITHDRAWN')">
                                                    강제 탈퇴
                                                </button>
                                                <c:if test="${empty member.socialProvider or member.socialProvider eq 'NONE' or member.socialProvider eq 'EMAIL'}">
                                                    <button type="button" class="btn btn-sm btn-light-primary" onclick="resetPassword()">
                                                        비밀번호 초기화
                                                    </button>
                                                </c:if>
                                            </c:if>
                                            <c:if test="${member.status eq 'SUSPENDED'}">
                                                <button type="button" class="btn btn-sm btn-light-success me-2" onclick="changeStatus('ACTIVE')">
                                                    정지 해제
                                                </button>
                                                <button type="button" class="btn btn-sm btn-light-danger" onclick="changeStatus('WITHDRAWN')">
                                                    강제 탈퇴
                                                </button>
                                            </c:if>
                                            <c:if test="${member.status eq 'WITHDRAWN'}">
                                                <span class="badge badge-light-danger fs-6">탈퇴 회원</span>
                                            </c:if>
                                        </div>
                                    </div>

                                    <div class="card-body p-9">
                                        <input type="hidden" id="memberId" value="${member.memberId}">

                                        <div class="mb-10">
                                            <h3 class="fw-bolder mb-6 text-gray-900">기본 정보</h3>

                                            <div class="row mb-7 align-items-center">
                                                <label class="col-lg-2 fw-semibold text-muted">현재 상태</label>
                                                <div class="col-lg-4">
                                                    <c:choose>
                                                        <c:when test="${member.status eq 'ACTIVE'}"><span class="badge badge-light-success fs-7">정상</span></c:when>
                                                        <c:when test="${member.status eq 'SUSPENDED'}"><span class="badge badge-light-warning fs-7">정지</span></c:when>
                                                        <c:when test="${member.status eq 'WITHDRAWN'}"><span class="badge badge-light-danger fs-7">탈퇴</span></c:when>
                                                        <c:otherwise><span class="badge badge-light-secondary fs-7">${member.status}</span></c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <label class="col-lg-2 fw-semibold text-muted">이메일</label>
                                                <div class="col-lg-4 d-flex align-items-center">
                                                    <span class="fw-bold fs-6 text-gray-800">${member.email}</span>
                                                    <c:if test="${not empty member.socialProvider and member.socialProvider ne 'NONE'}">
                                                        <c:choose>
                                                            <c:when test="${member.socialProvider eq 'KAKAO'}">
                                                                <span class="badge fs-9 ms-2" style="background-color: #f8df00; color: #3c1e1e;">${member.socialProvider}</span>
                                                            </c:when>
                                                            <c:when test="${member.socialProvider eq 'APPLE'}">
                                                                <span class="badge fs-9 ms-2" style="background-color: #000000; color: #FFFFFF;">${member.socialProvider}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge fs-9 ms-2">${member.socialProvider}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <div class="row mb-7 align-items-center">
                                                <label class="col-lg-2 fw-semibold text-muted">닉네임</label>
                                                <div class="col-lg-4">
                                                    <div class="d-flex align-items-center">
                                                        <input type="text" id="nickname" class="form-control form-control-sm form-control-solid w-200px me-3" value="${member.nickname}">
                                                        <button type="button" class="btn btn-sm btn-primary text-nowrap" onclick="updateMemberInfo()">수정</button>
                                                    </div>
                                                </div>
                                                <label class="col-lg-2 fw-semibold text-muted">연락처</label>
                                                <div class="col-lg-4">
                                                    <div class="d-flex align-items-center">
                                                        <input type="text" id="phoneNumber" class="form-control form-control-sm form-control-solid w-200px me-3" value="${member.phoneNumber}" placeholder="숫자만 입력">
                                                        <button type="button" class="btn btn-sm btn-primary text-nowrap" onclick="updateMemberInfo()">수정</button>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="row align-items-center">
                                                <label class="col-lg-2 fw-semibold text-muted">비밀번호</label>
                                                <div class="col-lg-4">
                                                    <c:choose>
                                                        <c:when test="${empty member.socialProvider or member.socialProvider eq 'NONE' or member.socialProvider eq 'EMAIL'}">
                                                            <div class="d-flex align-items-center">
                                                                <button type="button" class="btn btn-sm btn-danger text-nowrap me-3" onclick="resetPassword()">비밀번호 초기화</button>
                                                                <div class="fs-8 text-muted">(가입된 연락처로 SMS 임시 비밀번호 발송)</div>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-light-secondary fs-7">소셜 로그인 계정 (초기화 불가)</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <label class="col-lg-2 fw-semibold text-muted">생년월일</label>
                                                <div class="col-lg-4">
                                                    <span class="fw-bold fs-6 text-gray-800">${empty member.birthdate ? '-' : member.birthdate}</span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="separator separator-dashed my-10"></div>

                                        <div class="mb-10">
                                            <h3 class="fw-bolder mb-6 text-gray-900">승요 정보</h3>

                                            <div class="row mb-7 align-items-center">
                                                <label class="col-lg-2 fw-semibold text-muted">응원 구단</label>
                                                <div class="col-lg-4">
                                                    <c:choose>
                                                        <c:when test="${empty member.myTeamCode or member.myTeamCode eq 'NONE'}">
                                                            <span class="badge badge-light-secondary fw-bold fs-6">미설정</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="d-flex align-items-center">
                                                                <div class="symbol symbol-30px symbol-circle me-3 border border-1 border-gray-300">
                                                                    <c:choose>
                                                                        <c:when test="${not empty member.myTeamLogoUrl}">
                                                                            <img src="${member.myTeamLogoUrl}" alt="${member.myTeamName}" class="p-1 object-fit-contain"/>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <img src="/img/team_default.svg" alt="기본로고" class="p-1 object-fit-contain"/>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                                <span class="fw-bold fs-6 text-gray-800">${member.myTeamName}</span>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <label class="col-lg-2 fw-semibold text-muted">최다 방문 구장</label>
                                                <div class="col-lg-4">
                                                    <span class="fw-bold fs-6 text-gray-800">${empty member.mostVisitedStadium ? '기록 없음' : member.mostVisitedStadium}</span>
                                                </div>
                                            </div>

                                            <div class="row align-items-center">
                                                <label class="col-lg-2 fw-semibold text-muted">직관 승률</label>
                                                <div class="col-lg-4">
                                                    <c:set var="validGames" value="${member.winCount + member.loseCount}" />
                                                    <c:set var="winRate" value="0.0" />
                                                    <c:if test="${validGames > 0}">
                                                        <c:set var="winRate" value="${(member.winCount * 100.0) / validGames}" />
                                                    </c:if>
                                                    <span class="fw-bolder fs-3 text-primary"><fmt:formatNumber value="${winRate}" pattern="0.0"/>%</span>
                                                </div>
                                                <label class="col-lg-2 fw-semibold text-muted">직관 전적</label>
                                                <div class="col-lg-4">
                                                    <%-- 무승부 표기 추가 --%>
                                                    <span class="fw-bold fs-6 text-gray-800">${member.winCount}승 <c:if test="${member.drawCount > 0}">${member.drawCount}무 </c:if>${member.loseCount}패</span>
                                                </div>
                                            </div>

                                            <%-- 승요력 칭호 및 멘트 노출 영역 --%>
                                            <div class="separator separator-dashed my-7"></div>
                                            <div class="row mb-7 align-items-center">
                                                <label class="col-lg-2 fw-semibold text-muted">직관 횟수 칭호</label>
                                                <div class="col-lg-10 d-flex align-items-center">
                                                    <span class="badge badge-light-success fs-6 fw-bold me-3">${not empty winYo.countLevelName ? winYo.countLevelName : '-'}</span>
                                                    <span class="text-gray-800">${winYo.countMessage}</span>
                                                </div>
                                            </div>
                                            <div class="row mb-7 align-items-center">
                                                <label class="col-lg-2 fw-semibold text-muted">승률 구간 칭호</label>
                                                <div class="col-lg-10 d-flex align-items-center">
                                                    <span class="badge badge-light-primary fs-6 fw-bold me-3">${not empty winYo.rateLevelName ? winYo.rateLevelName : '-'}</span>
                                                    <span class="text-gray-800">${winYo.rateMessage}</span>
                                                </div>
                                            </div>
                                            <div class="row mb-7 align-items-center">
                                                <label class="col-lg-2 fw-semibold text-muted">최근 흐름 멘트</label>
                                                <div class="col-lg-10">
                                                    <span class="text-gray-800 fs-6">${not empty winYo.subMessage ? winYo.subMessage : '-'}</span>
                                                </div>
                                            </div>

                                            <%-- 직관 기록 이력 (일기 목록) 영역 --%>
                                            <div class="row align-items-start mt-7">
                                                <label class="col-lg-2 fw-semibold text-muted pt-3">
                                                    직관 기록 이력<br><span class="fs-8 text-gray-400 fw-normal">(승률 산출 기준)</span>
                                                </label>
                                                <div class="col-lg-10">
                                                    <div class="diary-history-list">
                                                        <c:choose>
                                                            <c:when test="${empty diaries}">
                                                                <div class="p-5 text-center text-muted fs-6">작성된 직관 일기가 없습니다.</div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:forEach var="diary" items="${diaries}">
                                                                    <div class="diary-history-item">
                                                                        <div class="d-flex flex-column" style="width: 85%;">

                                                                            <%-- 1. 경기 일시 및 승요 결과 --%>
                                                                            <div class="d-flex align-items-center mb-3 gap-2">
                                                                                <span class="badge badge-secondary fs-8 text-gray-700">
                                                                                    <i class="ki-duotone ki-calendar fs-8 me-1">
                                                                                        <span class="path1"></span>
                                                                                        <span class="path2"></span>
                                                                                    </i>
                                                                                    ${diary.gameDate}
                                                                                    <c:if test="${not empty diary.gameTime and diary.gameTime ne '00:00:00'}">
                                                                                        ${fn:substring(diary.gameTime, 0, 5)}
                                                                                    </c:if>
                                                                                </span>

                                                                                <c:choose>
                                                                                    <c:when test="${diary.gameResult eq 'WIN'}"><span class="badge badge-light-primary px-2 py-1 fs-9">승리요정</span></c:when>
                                                                                    <c:when test="${diary.gameResult eq 'LOSE'}"><span class="badge badge-light-danger px-2 py-1 fs-9">패배요정</span></c:when>
                                                                                    <c:when test="${diary.gameResult eq 'DRAW'}"><span class="badge badge-light-dark px-2 py-1 fs-9">무승부</span></c:when>
                                                                                    <c:when test="${diary.gameResult eq 'NONE'}"><span class="badge badge-light px-2 py-1 fs-9 text-muted">타팀관전</span></c:when>
                                                                                </c:choose>
                                                                            </div>

                                                                            <%-- 2. 원정/홈 매치업 및 스코어 --%>
                                                                            <div class="d-flex align-items-center mb-3 bg-light rounded px-3 py-2" style="width: fit-content; border: 1px solid var(--bs-gray-200);">
                                                                                <div class="d-flex align-items-center justify-content-end" style="min-width: 90px;">
                                                                                    <span class="badge badge-light-secondary fs-10 me-2 text-gray-500">원정</span>
                                                                                    <span class="fw-bolder fs-6 ${diary.scoreAway > diary.scoreHome ? 'text-primary' : 'text-gray-700'}">
                                                                                        ${diary.awayTeamName}
                                                                                        <c:if test="${diary.scoreAway > diary.scoreHome}">
                                                                                            <i class="ki-duotone ki-crown fs-5 ms-1 text-warning">
                                                                                                <span class="path1"></span>
                                                                                                <span class="path2"></span>
                                                                                            </i>
                                                                                        </c:if>
                                                                                    </span>
                                                                                </div>

                                                                                <span class="score-box mx-4">${diary.scoreAway} : ${diary.scoreHome}</span>

                                                                                <div class="d-flex align-items-center justify-content-start" style="min-width: 90px;">
                                                                                    <span class="badge badge-light-danger fs-10 me-2">홈</span>
                                                                                    <span class="fw-bolder fs-6 ${diary.scoreHome > diary.scoreAway ? 'text-danger' : 'text-gray-700'}">
                                                                                        ${diary.homeTeamName}
                                                                                        <c:if test="${diary.scoreHome > diary.scoreAway}">
                                                                                            <i class="ki-duotone ki-crown fs-5 ms-1 text-warning">
                                                                                                <span class="path1"></span>
                                                                                                <span class="path2"></span>
                                                                                            </i>
                                                                                        </c:if>
                                                                                    </span>
                                                                                </div>
                                                                            </div>

                                                                            <%-- 3. 구장 정보 및 한줄평 --%>
                                                                            <span class="text-muted fs-7 text-truncate" style="max-width: 100%;">
                                                                                <i class="ki-duotone ki-geolocation fs-7 me-1"><span class="path1"></span><span class="path2"></span></i>
                                                                                <span class="text-gray-700 fw-semibold">${diary.stadiumName}</span>
                                                                                <c:if test="${not empty diary.oneLineComment}">
                                                                                    <span class="mx-2 text-gray-300">|</span>
                                                                                    <span class="text-gray-600">"${diary.oneLineComment}"</span>
                                                                                </c:if>
                                                                            </span>
                                                                        </div>

                                                                        <%-- 4. 일기 상세 버튼 --%>
                                                                        <div class="d-flex justify-content-end align-items-center" style="width: 15%; height: 100%;">
                                                                            <a href="/mng/diary/detail?diaryId=${diary.diaryId}" class="btn btn-sm btn-light btn-active-light-primary py-2 px-3 text-nowrap mt-4">
                                                                                일기 상세 <i class="ki-duotone ki-arrow-right fs-6 ms-1"><span class="path1"></span><span class="path2"></span></i>
                                                                            </a>
                                                                        </div>
                                                                    </div>
                                                                </c:forEach>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="separator separator-dashed my-10"></div>

                                        <div class="mb-10">
                                            <h3 class="fw-bolder mb-6 text-gray-900">이용 정보</h3>

                                            <div class="row mb-7 align-items-center">
                                                <label class="col-lg-2 fw-semibold text-muted">이번달 직관 횟수</label>
                                                <div class="col-lg-4">
                                                    <span class="fw-bold fs-6 text-gray-800">${member.monthlyAttendanceCount} 회</span>
                                                </div>
                                                <label class="col-lg-2 fw-semibold text-muted">누적 직관 횟수</label>
                                                <div class="col-lg-4">
                                                    <span class="fw-bold fs-6 text-gray-800">${member.totalAttendanceCount} 회</span>
                                                </div>
                                            </div>

                                            <div class="row align-items-center">
                                                <label class="col-lg-2 fw-semibold text-muted">팔로우 / 팔로워 (맞팔)</label>
                                                <div class="col-lg-4">
                                                    <span class="fw-bold fs-6 text-gray-800">
                                                        <span class="text-primary">${member.followingCount}</span> / <span class="text-info">${member.followerCount}</span>
                                                        <span class="text-muted fs-7 ms-1">(${member.mutualFollowCount}명)</span>
                                                    </span>
                                                </div>
                                                <label class="col-lg-2 fw-semibold text-muted">가입일시</label>
                                                <div class="col-lg-4">
                                                    <span class="fw-bold fs-6 text-gray-800">
                                                        <c:choose>
                                                            <c:when test="${not empty member.createdAt}">
                                                                <c:set var="cDate" value="${fn:replace(member.createdAt, 'T', ' ')}" />
                                                                <c:choose>
                                                                    <c:when test="${fn:length(cDate) == 16}">${cDate}:00</c:when>
                                                                    <c:otherwise>${fn:substring(cDate, 0, 19)}</c:otherwise>
                                                                </c:choose>
                                                            </c:when>
                                                            <c:otherwise>-</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                    <div class="card-footer d-flex justify-content-end py-6 px-9">
                                        <a href="/mng/members/list" class="btn btn-light btn-active-light-primary">목록으로</a>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="/assets/plugins/global/plugins.bundle.js"></script>
    <script src="/assets/js/scripts.bundle.js"></script>
    <script>
        function changeStatus(status) {
            let msg = '';
            if (status === 'SUSPENDED') msg = '활동 정지 처리하시겠습니까?';
            else if (status === 'WITHDRAWN') msg = '강제 탈퇴 처리하시겠습니까? (복구 불가)';
            else if (status === 'ACTIVE') msg = '정지를 해제하시겠습니까?';

            var memberId = $('#memberId').val();

            if (confirm(msg)) {
                $.ajax({
                    url: '/mng/members/updateStatus',
                    type: 'POST',
                    data: {
                        memberId: memberId,
                        status: status
                    },
                    success: function (res) {
                        // 공백이 포함될 경우를 대비해 trim 처리
                        if ($.trim(res) === 'ok') {
                            alert('처리되었습니다.');
                            location.reload();
                        } else {
                            alert('상태 변경 처리에 실패했습니다.');
                        }
                    },
                    error: function(xhr, status, error) {
                        alert('서버 통신 중 오류가 발생했습니다.');
                    }
                });
            }
        }

        // 관리자: 닉네임, 연락처 수정 기능
        function updateMemberInfo() {
            var memberId = $('#memberId').val();
            var nickname = $('#nickname').val();
            var phoneNumber = $('#phoneNumber').val();

            if(!nickname) { alert('닉네임을 입력해주세요.'); return; }

            // 사용자 화면과 동일한 닉네임 유효성 검사 적용
            const nickRegex = /^[가-힣a-zA-Z0-9]{2,6}$/;
            if (!nickRegex.test(nickname)) {
                alert('2~6자리의 한글 또는 영문, 숫자 중 2개 이상 조합하여 가능합니다.');
                $('#nickname').focus();
                return;
            }

            if(confirm("회원 정보를 수정하시겠습니까?")) {
                $.ajax({
                    url: '/mng/members/updateInfo',
                    type: 'POST',
                    data: {
                        memberId: memberId,
                        nickname: nickname,
                        phoneNumber: phoneNumber
                    },
                    success: function(res) {
                        if(res === 'ok') {
                            alert("수정되었습니다.");
                            location.reload();
                        } else {
                            alert("수정 중 오류가 발생했습니다.");
                        }
                    }
                });
            }
        }

        // 관리자: 비밀번호 초기화 및 SMS 발송
        function resetPassword() {
            var memberId = $('#memberId').val();

            if(confirm("해당 회원의 비밀번호를 초기화하시겠습니까?\n임시 비밀번호가 회원의 연락처로 문자로 발송됩니다.")) {
                $.ajax({
                    url: '/mng/members/resetPassword',
                    type: 'POST',
                    data: { memberId: memberId },
                    success: function(res) {
                        if(res === 'ok') {
                            alert("비밀번호 초기화 완료 및 SMS 문자가 정상 발송되었습니다.");
                        } else if(res === 'no_phone') {
                            alert("등록된 연락처가 없어 SMS를 발송할 수 없습니다.");
                        } else if(res === 'is_social') {
                            alert("소셜 가입자는 비밀번호를 초기화할 수 없습니다.");
                        } else {
                            alert("처리 중 오류가 발생했습니다.");
                        }
                    }
                });
            }
        }
    </script>
</body>
</html>