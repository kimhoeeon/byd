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

    <title>회원 관리 | 승요일기 관리자</title>
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
                                <button type="button" class="btn btn-sm btn-success" onclick="downloadExcel()">
                                    <i class="ki-duotone ki-file-down">
                                        <span class="path1"></span>
                                        <span class="path2"></span>
                                    </i>
                                    엑셀 다운로드
                                </button>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card mb-7">
                                    <div class="card-body">
                                        <form id="searchForm" action="/mng/members/list" method="get"
                                              class="d-flex align-items-center">
                                            <input type="hidden" name="pageNum" value="1">
                                            <input type="hidden" name="amount" value="${pageMaker.cri.amount}">

                                            <div class="position-relative w-md-400px me-md-2">
                                                <i class="ki-duotone ki-magnifier fs-3 text-gray-500 position-absolute top-50 translate-middle ms-6">
                                                    <span class="path1"></span>
                                                    <span class="path2"></span>
                                                </i>
                                                <input type="text" class="form-control form-control-solid ps-10"
                                                       name="keyword" value="${pageMaker.cri.keyword}"
                                                       placeholder="이메일 또는 닉네임 검색"/>
                                            </div>
                                            <select name="status" class="form-select form-select-solid w-150px me-3">
                                                <option value="" ${empty pageMaker.cri.status ? 'selected' : ''}>
                                                    전체 상태
                                                </option>
                                                <option value="ACTIVE" ${pageMaker.cri.status eq 'ACTIVE' ? 'selected' : ''}>
                                                    정상
                                                </option>
                                                <option value="SUSPENDED" ${pageMaker.cri.status eq 'SUSPENDED' ? 'selected' : ''}>
                                                    정지
                                                </option>
                                                <option value="WITHDRAWN" ${pageMaker.cri.status eq 'WITHDRAWN' ? 'selected' : ''}>
                                                    탈퇴
                                                </option>
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
                                                        <th class="min-w-80px text-center">상태</th>
                                                        <th class="min-w-175px">회원정보 (닉네임/이메일)</th>
                                                        <th class="min-w-125px text-center">연락처</th>
                                                        <th class="min-w-125px text-center">응원팀</th>
                                                        <th class="min-w-100px text-center">직관 횟수<br><span class="fs-8 text-muted">(이번달)</span></th>
                                                        <th class="min-w-125px text-center">팔로우/팔로워</th>
                                                        <th class="min-w-125px text-center">승률 (전적)</th>
                                                        <th class="min-w-125px text-center">가입일시</th>
                                                        <th class="min-w-80px text-center">관리</th>
                                                    </tr>
                                                </thead>
                                                <tbody class="text-gray-600 fw-semibold">
                                                    <c:choose>
                                                        <c:when test="${empty list}">
                                                            <tr>
                                                                <td colspan="10" class="text-center p-10">데이터가 없습니다.</td>
                                                            </tr>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:forEach var="item" items="${list}" varStatus="status">
                                                                <c:set var="rowNum" value="${pageMaker.total - (pageMaker.cri.pageNum - 1) * pageMaker.cri.amount - status.index}"/>

                                                                <%-- 무승부는 승률 분모에서 제외 --%>
                                                                <c:set var="validGames" value="${item.winCount + item.loseCount}" />
                                                                <c:set var="winRate" value="0.0" />
                                                                <c:if test="${validGames > 0}">
                                                                    <c:set var="winRate" value="${(item.winCount * 100.0) / validGames}" />
                                                                </c:if>

                                                                <tr>
                                                                    <td class="text-center">${rowNum}</td>

                                                                    <td class="text-center">
                                                                        <c:choose>
                                                                            <c:when test="${item.status eq 'ACTIVE'}">
                                                                                <span class="badge badge-light-success">정상</span>
                                                                            </c:when>
                                                                            <c:when test="${item.status eq 'SUSPENDED'}">
                                                                                <span class="badge badge-light-warning">정지</span>
                                                                            </c:when>
                                                                            <c:when test="${item.status eq 'WITHDRAWN'}">
                                                                                <span class="badge badge-light-danger">탈퇴</span>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="badge badge-light-secondary">${item.status}</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>

                                                                    <td>
                                                                        <div class="d-flex flex-column">
                                                                            <span class="d-flex align-items-center text-gray-800 fw-bold fs-6">
                                                                                ${item.nickname}
                                                                                <c:if test="${not empty item.socialProvider and item.socialProvider ne 'NONE'}">
                                                                                    <c:choose>
                                                                                        <c:when test="${item.socialProvider eq 'KAKAO'}">
                                                                                            <span class="badge fs-9 ms-2" style="background-color: #f8df00; color: #3c1e1e;">${item.socialProvider}</span>
                                                                                        </c:when>
                                                                                        <c:when test="${item.socialProvider eq 'APPLE'}">
                                                                                            <span class="badge fs-9 ms-2" style="background-color: #000000; color: #FFFFFF;">${item.socialProvider}</span>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <span class="badge fs-9 ms-2">${item.socialProvider}</span>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </c:if>
                                                                            </span>
                                                                            <span class="text-gray-400 fw-semibold fs-7">${item.email}</span>
                                                                        </div>
                                                                    </td>

                                                                    <td class="text-center">
                                                                        ${item.formattedPhoneNumber}
                                                                    </td>

                                                                    <td class="text-center">
                                                                        <c:choose>
                                                                            <c:when test="${empty item.myTeamName}">
                                                                                <span class="text-muted">미설정</span>
                                                                            </c:when>
                                                                            <c:otherwise>${item.myTeamName}</c:otherwise>
                                                                        </c:choose>
                                                                    </td>

                                                                    <td class="text-center">
                                                                        <span class="fw-bolder text-dark">${item.monthlyAttendanceCount}</span><span class="text-muted fs-7">회</span>
                                                                    </td>

                                                                    <td class="text-center">
                                                                        <span class="text-primary fw-bolder">${item.followingCount}</span>
                                                                        <span class="text-muted mx-1">/</span>
                                                                        <span class="text-info fw-bolder">${item.followerCount}</span>
                                                                    </td>

                                                                    <td class="text-center">
                                                                        <div class="d-flex flex-column align-items-center">
                                                                            <span class="fw-bolder text-gray-800"><fmt:formatNumber value="${winRate}" pattern="0.0"/>%</span>
                                                                            <span class="text-muted fs-8">(${item.winCount}승 <c:if test="${item.drawCount > 0}">${item.drawCount}무 </c:if>${item.loseCount}패)</span>
                                                                        </div>
                                                                    </td>

                                                                    <td class="text-center fs-7 text-muted">
                                                                        <c:choose>
                                                                            <c:when test="${not empty item.createdAt}">
                                                                                <c:set var="cDate" value="${fn:replace(item.createdAt, 'T', ' ')}" />
                                                                                <c:choose>
                                                                                    <c:when test="${fn:length(cDate) == 16}">${cDate}:00</c:when>
                                                                                    <c:otherwise>${fn:substring(cDate, 0, 19)}</c:otherwise>
                                                                                </c:choose>
                                                                            </c:when>
                                                                            <c:otherwise>-</c:otherwise>
                                                                        </c:choose>
                                                                    </td>

                                                                    <td class="text-center">
                                                                        <a href="/mng/members/detail?memberId=${item.memberId}&pageNum=${pageMaker.cri.pageNum}&amount=${pageMaker.cri.amount}&keyword=${pageMaker.cri.keyword}&status=${pageMaker.cri.status}"
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

                                                <c:forEach var="num" begin="${pageMaker.startPage}"
                                                           end="${pageMaker.endPage}">
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

    <form id="actionForm" action="/mng/members/list" method="get">
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

            // 페이지 번호 클릭 이벤트
            $(".page-link").on("click", function (e) {
                e.preventDefault();
                // 클릭한 페이지 번호를 form에 설정 후 submit
                actionForm.find("input[name='pageNum']").val($(this).attr("href"));
                actionForm.submit();
            });
        });

        // 엑셀 다운로드 함수
        function downloadExcel() {
            // 다운로드 진행 여부를 묻는 확인 창 띄우기
            if (confirm("전체 회원 목록을 엑셀로 다운로드 하시겠습니까?")) {
                location.href = '/mng/members/excel';
            }
        }
    </script>
</body>
</html>