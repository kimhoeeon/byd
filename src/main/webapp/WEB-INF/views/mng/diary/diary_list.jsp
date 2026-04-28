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

    <title>일기 관리 | 승요일기 관리자</title>
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

                                <div class="card mb-7">
                                    <div class="card-body">
                                        <form id="searchForm" action="/mng/diary/list" method="get" class="d-flex align-items-center">
                                            <input type="hidden" name="pageNum" value="1">
                                            <input type="hidden" name="amount" value="${pageMaker.cri.amount}">

                                            <div class="position-relative w-md-400px me-md-2">
                                                <i class="ki-duotone ki-magnifier fs-3 text-gray-500 position-absolute top-50 translate-middle ms-6">
                                                    <span class="path1"></span>
                                                    <span class="path2"></span>
                                                </i>
                                                <input type="text" class="form-control form-control-solid ps-10"
                                                       name="keyword" value="${fn:trim(pageMaker.cri.keyword)}"
                                                       placeholder="내용 또는 작성자 검색"/>
                                            </div>

                                            <select name="isPopular" class="form-select form-select-solid w-150px me-3" onchange="this.form.submit()">
                                                <option value="" ${empty pageMaker.cri.isPopular ? 'selected' : ''}>전체 게시물</option>
                                                <option value="Y" ${pageMaker.cri.isPopular eq 'Y' ? 'selected' : ''}>인기 게시물 (Y)</option>
                                                <option value="N" ${pageMaker.cri.isPopular eq 'N' ? 'selected' : ''}>일반 게시물 (N)</option>
                                            </select>

                                            <select name="status" class="form-select form-select-solid w-150px me-3" onchange="this.form.submit()">
                                                <option value="" ${empty pageMaker.cri.status ? 'selected' : ''}>전체 상태</option>
                                                <option value="COMPLETED" ${pageMaker.cri.status eq 'COMPLETED' ? 'selected' : ''}>등록</option>
                                                <option value="BLIND" ${pageMaker.cri.status eq 'BLIND' ? 'selected' : ''}>블라인드</option>
                                                <option value="DELETED" ${pageMaker.cri.status eq 'DELETED' ? 'selected' : ''}>삭제됨</option>
                                            </select>

                                            <button type="submit" class="btn btn-primary">검색</button>
                                        </form>
                                    </div>
                                </div>

                                <div class="card">
                                    <div class="card-body py-4">
                                        <div class="table-responsive">
                                            <table class="table align-middle table-row-dashed fs-6 gy-5">
                                                <thead>
                                                <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                                    <th class="w-50px text-center">No.</th>
                                                    <th class="min-w-150px">작성자 정보</th>
                                                    <th class="min-w-200px">내용 (미리보기)</th>
                                                    <th class="min-w-200px text-center">관람 경기 정보</th>
                                                    <th class="min-w-100px text-center">직관 인증 / 공개</th>
                                                    <th class="min-w-100px text-center">인기게시물</th>
                                                    <th class="min-w-125px text-center">작성일시</th>
                                                    <th class="min-w-100px text-center">상태</th>
                                                    <th class="min-w-100px text-center">관리</th>
                                                </tr>
                                                </thead>
                                                <tbody class="text-gray-600 fw-semibold">
                                                    <c:choose>
                                                        <c:when test="${empty list}">
                                                            <tr>
                                                                <td colspan="9" class="text-center p-10">조회된 일기가 없습니다.</td>
                                                            </tr>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:forEach var="item" items="${list}" varStatus="status">
                                                                <c:set var="rowNum" value="${pageMaker.total - (pageMaker.cri.pageNum - 1) * pageMaker.cri.amount - status.index}"/>

                                                                <tr>
                                                                    <td class="text-center">${rowNum}</td>

                                                                    <td>
                                                                        <div class="d-flex align-items-center">
                                                                            <div class="d-flex flex-column">
                                                                                <span class="text-gray-800 fw-bold mb-1">${item.memberName}</span>
                                                                                <span class="text-muted fs-7">${item.memberEmail}</span>
                                                                            </div>
                                                                        </div>
                                                                    </td>

                                                                    <td>
                                                                        <div class="d-flex flex-column">
                                                                            <c:if test="${not empty item.oneLineComment}">
                                                                                <span class="text-dark fw-bold mb-1 fs-6 text-truncate" style="max-width: 250px;">
                                                                                    "${item.oneLineComment}"
                                                                                </span>
                                                                            </c:if>

                                                                            <div class="d-flex align-items-center mt-1">
                                                                                <c:if test="${not empty item.imageUrl}">
                                                                                    <i class="ki-duotone ki-picture fs-5 text-primary me-2" title="사진 포함">
                                                                                        <span class="path1"></span>
                                                                                        <span class="path2"></span>
                                                                                    </i>
                                                                                </c:if>
                                                                                <c:set var="cleanText" value="${item.content.replaceAll('<[^>]*>', '')}" />
                                                                                <c:set var="trimText" value="${fn:trim(cleanText)}" />
                                                                                <span class="text-muted fs-7 text-truncate" style="max-width: ${empty item.imageUrl ? '250px' : '220px'};">
                                                                                    <c:choose>
                                                                                        <c:when test="${empty trimText}">-</c:when>
                                                                                        <c:when test="${fn:length(trimText) > 30}">${fn:substring(trimText, 0, 30)}...</c:when>
                                                                                        <c:otherwise>${trimText}</c:otherwise>
                                                                                    </c:choose>
                                                                                </span>
                                                                            </div>
                                                                        </div>
                                                                    </td>

                                                                    <td class="text-center">
                                                                        <c:choose>
                                                                            <c:when test="${not empty item.gameDate}">
                                                                                <div class="d-flex flex-column align-items-center">
                                                                                    <span class="badge badge-light fs-8 mb-1">${item.gameDate}</span>
                                                                                    <span class="fw-bold text-gray-800">${item.awayTeamName} vs ${item.homeTeamName}</span>

                                                                                    <%-- 진짜 승요 여부 메인 노출 --%>
                                                                                    <c:if test="${item.gameStatus eq 'FINISHED'}">
                                                                                        <div class="mt-1 mb-1">
                                                                                            <c:choose>
                                                                                                <c:when test="${item.gameResult eq 'WIN'}"><span class="badge badge-primary fs-9">승리 요정</span></c:when>
                                                                                                <c:when test="${item.gameResult eq 'LOSE'}"><span class="badge badge-secondary fs-9 text-muted">패배</span></c:when>
                                                                                                <c:when test="${item.gameResult eq 'DRAW'}"><span class="badge badge-light-dark fs-9 text-muted">무승부</span></c:when>
                                                                                                <c:when test="${item.gameResult eq 'NONE'}"><span class="badge badge-light fs-9 text-muted">타팀관전</span></c:when>
                                                                                            </c:choose>
                                                                                        </div>
                                                                                    </c:if>

                                                                                    <%-- 서브 정보: 재미용 스코어 예측 --%>
                                                                                    <c:if test="${not empty item.predScoreHome and not empty item.predScoreAway}">
                                                                                        <div class="text-muted" style="font-size: 11px;">
                                                                                            (재미용 예측: [${item.predScoreAway}:${item.predScoreHome}]
                                                                                            <c:choose>
                                                                                                <c:when test="${item.gameStatus eq 'FINISHED'}">
                                                                                                    <c:choose>
                                                                                                        <c:when test="${item.predScoreHome == item.scoreHome and item.predScoreAway == item.scoreAway}">
                                                                                                            <span class="text-success ms-1 fw-bold">적중</span>)
                                                                                                        </c:when>
                                                                                                        <c:otherwise>
                                                                                                            <span class="text-danger ms-1">미적중</span>)
                                                                                                        </c:otherwise>
                                                                                                    </c:choose>
                                                                                                </c:when>
                                                                                                <c:otherwise>)</c:otherwise>
                                                                                            </c:choose>
                                                                                        </div>
                                                                                    </c:if>
                                                                                </div>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="text-muted">-</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>

                                                                    <td class="text-center">
                                                                        <div class="d-flex flex-column align-items-center gap-1">
                                                                            <c:choose>
                                                                                <c:when test="${item.verified}">
                                                                                    <span class="badge badge-light-success fs-8">직관 인증</span>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <span class="badge badge-light-secondary fs-8">미인증</span>
                                                                                </c:otherwise>
                                                                            </c:choose>

                                                                            <c:choose>
                                                                                <c:when test="${item.isPublic eq 'PUBLIC'}"><span class="badge badge-light-primary fs-8">전체 공개</span></c:when>
                                                                                <c:when test="${item.isPublic eq 'FRIENDS'}"><span class="badge badge-light-info fs-8">친구 공개</span></c:when>
                                                                                <c:when test="${item.isPublic eq 'PRIVATE'}"><span class="badge badge-light-warning fs-8">비공개</span></c:when>
                                                                            </c:choose>
                                                                        </div>
                                                                    </td>

                                                                    <td class="text-center">
                                                                        <button type="button"
                                                                                class="btn btn-sm ${item.isPopular == 'Y' ? 'btn-primary' : 'btn-light btn-active-light-primary'}"
                                                                                onclick="togglePopular(${item.diaryId}, '${item.isPopular}')">
                                                                                ${item.isPopular == 'Y' ? '인기' : '일반'}
                                                                        </button>
                                                                    </td>

                                                                    <td class="text-center fs-7 text-muted">
                                                                        ${fn:substring(fn:replace(item.createdAt, 'T', ' '), 0, 16)}
                                                                    </td>

                                                                    <td class="text-center">
                                                                        <c:choose>
                                                                            <c:when test="${item.status eq 'COMPLETED'}"><span class="badge badge-light-success fs-8">등록</span></c:when>
                                                                            <c:when test="${item.status eq 'BLIND'}"><span class="badge badge-light-warning fs-8">블라인드</span></c:when>
                                                                            <c:when test="${item.status eq 'DELETED'}"><span class="badge badge-light-danger fs-8">삭제됨</span></c:when>
                                                                            <c:otherwise><span class="badge badge-light-secondary fs-8">${item.status}</span></c:otherwise>
                                                                        </c:choose>
                                                                    </td>

                                                                    <td class="text-center">
                                                                        <a href="/mng/diary/detail?diaryId=${item.diaryId}&pageNum=${pageMaker.cri.pageNum}&amount=${pageMaker.cri.amount}&keyword=${pageMaker.cri.keyword}&status=${pageMaker.cri.status}"
                                                                           class="btn btn-sm btn-light btn-active-light-primary">상세</a>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </tbody>
                                            </table>
                                        </div>

                                        <div class="d-flex flex-stack flex-wrap pt-10">
                                            <div class="fs-6 fw-semibold text-gray-700"></div>
                                            <ul class="pagination">
                                                <c:if test="${pageMaker.prev}">
                                                    <li class="page-item previous">
                                                        <a href="${pageMaker.startPage - 1}" class="page-link">
                                                            <i class="previous"></i>
                                                        </a>
                                                    </li>
                                                </c:if>
                                                <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                                                    <li class="page-item ${pageMaker.cri.pageNum == num ? 'active' : ''}">
                                                        <a href="${num}" class="page-link">${num}</a>
                                                    </li>
                                                </c:forEach>
                                                <c:if test="${pageMaker.next}">
                                                    <li class="page-item next">
                                                        <a href="${pageMaker.endPage + 1}" class="page-link">
                                                            <i class="next"></i>
                                                        </a>
                                                    </li>
                                                </c:if>
                                            </ul>
                                        </div>

                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <form id="actionForm" action="/mng/diary/list" method="get">
        <input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
        <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
        <input type="hidden" name="keyword" value="${pageMaker.cri.keyword}">
        <input type="hidden" name="status" value="${pageMaker.cri.status}">
    </form>

    <script src="/assets/plugins/global/plugins.bundle.js"></script>
    <script src="/assets/js/scripts.bundle.js"></script>
    <script>
        $(document).ready(function () {
            var actionForm = $("#actionForm");
            $(".page-link").on("click", function (e) {
                e.preventDefault();
                actionForm.find("input[name='pageNum']").val($(this).attr("href"));
                actionForm.submit();
            });
        });

        // 인기 게시물 토글 스크립트 추가
        function togglePopular(diaryId, currentStatus) {
            if (!confirm('인기 게시물 상태를 변경하시겠습니까?')) return;

            $.ajax({
                url: '/mng/diary/popular/toggle',
                type: 'POST',
                cache: false,
                data: {
                    diaryId: diaryId,
                    currentStatus: currentStatus
                },
                success: function(response) {
                    if (response.result === 'SUCCESS') {
                        alert(response.message);
                        location.reload();
                    } else {
                        alert(response.message);
                    }
                },
                error: function() {
                    alert('서버 통신 중 오류가 발생했습니다.');
                }
            });
        }
    </script>
</body>
</html>