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

    <title>일기 상세 | 승요일기 관리자</title>
    <link href="/assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/assets/css/style.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/css/mngStyle.css" rel="stylesheet">
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
                                        전체 일기 목록
                                    </h1>

                                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0 pt-1">
                                        <li class="breadcrumb-item text-muted">
                                            <a href="/mng/main.do" class="text-muted text-hover-primary">Home</a>
                                        </li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-muted">일기 관리</li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-dark">전체 일기 목록</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card mb-5 mb-xl-10">
                                    <div class="card-header border-0 cursor-pointer">
                                        <div class="card-title m-0"><h3 class="fw-bold m-0">일기 상세 정보</h3></div>
                                        <div class="card-toolbar d-flex align-items-center gap-2">
                                            <c:choose>
                                                <c:when test="${diary.status eq 'COMPLETED'}">
                                                    <button type="button" class="btn btn-sm btn-light-warning" onclick="blindDiary()">
                                                        숨김 처리
                                                    </button>
                                                    <button type="button" class="btn btn-sm btn-light-danger" onclick="deleteDiary()">
                                                        일기 삭제
                                                    </button>
                                                </c:when>
                                                <c:when test="${diary.status eq 'BLIND'}">
                                                    <span class="badge badge-light-warning fs-6">숨김(블라인드) 처리된 일기</span>
                                                    <button type="button" class="btn btn-sm btn-light-danger" onclick="deleteDiary()">
                                                        일기 삭제
                                                    </button>
                                                </c:when>
                                                <c:when test="${diary.status eq 'DELETED'}">
                                                    <span class="badge badge-light-danger fs-6">삭제된 일기</span>
                                                </c:when>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="card-body p-9">
                                        <div class="mb-10">
                                            <h3 class="fw-bolder mb-6 text-gray-900">기본 정보</h3>
                                            <div class="row mb-7 align-items-center">
                                                <label class="col-lg-2 fw-semibold text-muted">작성자</label>
                                                <div class="col-lg-4">
                                                    <div class="d-flex align-items-center">
                                                        <c:if test="${not empty diary.profileImage}">
                                                            <div class="symbol symbol-circle symbol-30px me-3">
                                                                <img src="${diary.profileImage}" alt="프로필">
                                                            </div>
                                                        </c:if>
                                                        <span class="fw-bold fs-6 text-gray-800">${diary.memberName} <span class="text-muted fs-7">(${diary.memberEmail})</span></span>
                                                    </div>
                                                </div>
                                                <label class="col-lg-2 fw-semibold text-muted">작성일시</label>
                                                <div class="col-lg-4">
                                                    <span class="fw-bold fs-6 text-gray-800">
                                                        ${fn:replace(fn:substring(diary.createdAt, 0, 16), 'T', ' ')}
                                                    </span>
                                                </div>
                                            </div>

                                            <div class="row align-items-center">
                                                <label class="col-lg-2 fw-semibold text-muted">일기 속성</label>
                                                <div class="col-lg-4 d-flex align-items-center gap-2">
                                                    <c:choose>
                                                        <c:when test="${diary.verified}">
                                                            <span class="badge badge-light-success fw-bold">직관 인증</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-light-secondary fw-bold">미인증</span>
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <c:choose>
                                                        <c:when test="${diary.isPublic eq 'PUBLIC'}"><span class="badge badge-light-primary">전체 공개</span></c:when>
                                                        <c:when test="${diary.isPublic eq 'FRIENDS'}"><span class="badge badge-light-info">친구 공개</span></c:when>
                                                        <c:when test="${diary.isPublic eq 'PRIVATE'}"><span class="badge badge-light-warning">비공개</span></c:when>
                                                    </c:choose>

                                                </div>
                                                <label class="col-lg-2 fw-semibold text-muted">조회수</label>
                                                <div class="col-lg-4">
                                                    <span class="fw-bold fs-6 text-gray-800">${diary.viewCount} 회</span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="separator separator-dashed my-10"></div>

                                        <div class="mb-10">
                                            <h3 class="fw-bolder mb-6 text-gray-900">경기 정보</h3>
                                            <div class="row mb-7 align-items-center">
                                                <label class="col-lg-2 fw-semibold text-muted">관람 경기</label>
                                                <div class="col-lg-10">
                                                    <c:choose>
                                                        <c:when test="${not empty diary.gameDate}">
                                                            <div class="d-flex align-items-center bg-light p-4 rounded border border-gray-200">
                                                                <div class="d-flex flex-column me-8">
                                                                    <span class="text-gray-600 fs-7 fw-bold mb-1">${diary.gameDate} ${diary.gameTime}</span>
                                                                    <span class="text-gray-500 fs-8">
                                                                        <i class="ki-duotone ki-geolocation fs-6 text-gray-400 me-1">
                                                                            <span class="path1"></span>
                                                                            <span class="path2"></span>
                                                                        </i>${diary.stadiumName}
                                                                    </span>
                                                                </div>
                                                                <div class="d-flex align-items-center flex-grow-1">
                                                                    <span class="fw-bolder fs-4 text-gray-800">${diary.awayTeamName}</span>

                                                                    <c:if test="${diary.gameStatus eq 'FINISHED'}">
                                                                        <span class="badge badge-dark fs-5 mx-3 px-3 py-2">${diary.scoreAway} : ${diary.scoreHome}</span>
                                                                    </c:if>
                                                                    <c:if test="${diary.gameStatus ne 'FINISHED'}">
                                                                        <span class="badge badge-light text-muted fs-6 mx-3 px-3 py-2">VS</span>
                                                                    </c:if>

                                                                    <span class="fw-bolder fs-4 text-gray-800">${diary.homeTeamName}</span>
                                                                </div>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-gray-400">경기 정보가 연결되지 않았습니다.</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>

                                            <%-- 이 일기가 실제 승리 요정(승요)를 달성한 일기인지 확인하는 패널 --%>
                                            <div class="row align-items-center bg-light-primary border-primary border-dashed p-4 rounded mb-5">
                                                <label class="col-lg-2 fw-semibold text-primary">직관 승패 결과</label>
                                                <div class="col-lg-10">
                                                    <c:choose>
                                                        <c:when test="${diary.gameStatus eq 'FINISHED'}">
                                                            <c:choose>
                                                                <c:when test="${diary.gameResult eq 'WIN'}">
                                                                    <span class="badge badge-primary fs-5 py-2 px-3"><i class="ki-duotone ki-crown fs-4 text-white me-1"><span class="path1"></span><span class="path2"></span></i>승리 요정 달성 (응원팀 승리)</span>
                                                                </c:when>
                                                                <c:when test="${diary.gameResult eq 'LOSE'}">
                                                                    <span class="badge badge-secondary fs-5 py-2 px-3 text-muted">패배 요정 (응원팀 패배)</span>
                                                                </c:when>
                                                                <c:when test="${diary.gameResult eq 'DRAW'}">
                                                                    <span class="badge badge-light-dark fs-5 py-2 px-3 text-muted">무승부</span>
                                                                </c:when>
                                                                <c:when test="${diary.gameResult eq 'NONE'}">
                                                                    <span class="badge badge-light fs-5 py-2 px-3 text-muted">승패 무관 (타팀 경기 관람)</span>
                                                                </c:when>
                                                            </c:choose>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-light-warning fs-6">경기 진행 전/진행 중</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>

                                            <div class="row align-items-center bg-light-info p-4 rounded">
                                                <label class="col-lg-2 fw-semibold text-info">스코어 예측</label>
                                                <div class="col-lg-4">
                                                    <span class="fw-bold fs-6 text-gray-800">
                                                        <c:choose>
                                                            <c:when test="${not empty diary.predScoreAway and not empty diary.predScoreHome}">
                                                                <span class="me-2">예상 스코어 : ${diary.predScoreAway} (원정) vs ${diary.predScoreHome} (홈)</span>

                                                                <%-- 실제 결과와 예측 결과 비교 로직 추가 --%>
                                                                <c:choose>
                                                                    <c:when test="${diary.gameStatus eq 'FINISHED'}">
                                                                        <c:choose>
                                                                            <c:when test="${diary.predScoreHome == diary.scoreHome and diary.predScoreAway == diary.scoreAway}">
                                                                                <span class="badge badge-success">적중 (스코어 일치)</span>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="badge badge-danger">미적중</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge badge-warning">결과 대기중</span>
                                                                    </c:otherwise>
                                                                </c:choose>

                                                            </c:when>
                                                            <c:otherwise><span class="text-muted fs-7">스코어 예측 없음</span></c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </div>
                                                <label class="col-lg-2 fw-semibold text-info">예상 히어로</label>
                                                <div class="col-lg-4">
                                                    <span class="fw-bold fs-6 text-gray-800">${empty diary.heroName ? '<span class="text-muted fs-7">없음</span>' : diary.heroName}</span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="separator separator-dashed my-10"></div>

                                        <div class="mb-10">
                                            <h3 class="fw-bolder mb-6 text-gray-900">일기 내용</h3>

                                            <div class="row mb-5">
                                                <label class="col-lg-2 fw-semibold text-muted align-top pt-2">한줄평</label>
                                                <div class="col-lg-10">
                                                    <div class="d-flex align-items-center mb-2">
                                                        <span class="fw-bold fs-5 text-gray-800">
                                                            "${empty diary.oneLineComment ? '한줄평이 없습니다.' : diary.oneLineComment}"
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="row mb-7">
                                                <label class="col-lg-2 fw-semibold text-muted align-top pt-3">본문 및 사진</label>
                                                <div class="col-lg-10">
                                                    <div class="p-5 border border-gray-300 rounded bg-white text-gray-800 fs-6" style="min-height: 200px;">
                                                        <c:if test="${not empty diary.imageUrl}">
                                                            <div class="mb-5 d-flex flex-wrap gap-4 justify-content-center">
                                                                <c:set var="imgArr" value="${fn:split(diary.imageUrl, ',')}" />
                                                                <c:forEach var="imgSrc" items="${imgArr}">
                                                                    <c:if test="${not empty imgSrc}">
                                                                        <img src="${imgSrc}" alt="일기 첨부 사진" class="mw-100 rounded border border-gray-200 shadow-sm" style="max-height: 300px; object-fit: contain;">
                                                                    </c:if>
                                                                </c:forEach>
                                                            </div>
                                                        </c:if>

                                                        <div style="white-space: pre-wrap;">${diary.content}</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-footer d-flex justify-content-end py-6 px-9">
                                        <a href="/mng/diary/list" class="btn btn-light btn-active-light-primary">목록으로</a>
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

        function blindDiary() {
            if (confirm('이 일기를 숨김(블라인드) 처리하시겠습니까?\n사용자들의 화면에서 더 이상 노출되지 않습니다.')) {
                $.post('/mng/diary/blind', {diaryId: '${diary.diaryId}'}, function (res) {
                    if (res === 'ok') {
                        alert('숨김 처리되었습니다.');
                        location.reload();
                    } else {
                        alert('오류가 발생했습니다.');
                    }
                });
            }
        }

        function deleteDiary() {
            if (confirm('이 일기를 관리자 권한으로 삭제하시겠습니까?\n삭제 후에는 사용자에게 노출되지 않습니다.')) {
                $.post('/mng/diary/delete', {diaryId: '${diary.diaryId}'}, function (res) {
                    if (res === 'ok') {
                        alert('삭제 처리되었습니다.');
                        location.reload();
                    } else {
                        alert('오류가 발생했습니다.');
                    }
                });
            }
        }
    </script>
</body>
</html>