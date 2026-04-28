<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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

    <title>승요 멘트 관리 | 승요일기 관리자</title>
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
                                <div class="page-title d-flex flex-column justify-content-center flex-wrap me-3 my-0 mb-4">
                                    <h1 class="page-heading d-flex text-dark fw-bold fs-3 flex-column justify-content-center my-0">
                                        승요 멘트 관리
                                    </h1>
                                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                                        <li class="breadcrumb-item text-muted">
                                            <a href="/mng/main.do" class="text-muted text-hover-primary">Home</a>
                                        </li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-muted">승요 관리</li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-dark">승요 멘트 관리</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-6">

                                <div class="notice d-flex bg-light-primary d-flex align-items-center rounded border-primary border border-dashed p-5 mb-7">
                                    <i class="ki-duotone ki-shield-tick fs-2hx text-primary me-4">
                                        <span class="path1"></span><span class="path2"></span>
                                    </i>
                                    <div class="d-flex flex-column">
                                        <h4 class="mb-1 text-primary">💡 승요력 멘트 설정 가이드</h4>
                                        <span>
                                            - <b>승률 구간:</b> 최소/최대값은 퍼센트(%) 단위로 입력합니다. (예: 0 ~ 16)<br/>
                                            - <b>직관 횟수:</b> 최소/최대값은 횟수(회) 단위입니다. 상한선이 없는 경우 최대값을 <b>9999</b>로 설정하세요.<br/>
                                            - <b>최근 흐름:</b> 범위(최소/최대값)를 사용하지 않으며, 조건 코드로 판별됩니다.<br/>
                                            - <b>우선순위:</b> 숫자가 클수록 우선적으로 노출됩니다. 조건이 겹칠 경우 우선순위가 높은 멘트가 표시됩니다.
                                        </span>
                                    </div>
                                </div>

                                <div class="card mb-7">
                                    <div class="card-body py-5">
                                        <form id="searchForm" method="get" action="/mng/winyo/mentions">
                                            <div class="d-flex align-items-center gap-3">
                                                <select name="searchType" class="form-select form-select-solid w-150px">
                                                    <option value="">전체</option>
                                                    <option value="category" ${searchType eq 'category' ? 'selected' : ''}>구분 (카테고리)</option>
                                                    <option value="levelName" ${searchType eq 'levelName' ? 'selected' : ''}>레벨 명</option>
                                                    <option value="message" ${searchType eq 'message' ? 'selected' : ''}>멘트 내용</option>
                                                </select>
                                                <input type="text" name="searchWord" class="form-control form-control-solid w-300px" placeholder="검색어를 입력하세요" value="${searchWord}" />
                                                <button type="submit" class="btn btn-primary">검색</button>
                                                <a href="/mng/winyo/mentions" class="btn btn-light">초기화</a>
                                            </div>

                                            <div class="d-flex align-items-center gap-3 mt-5 pt-5 border-top border-gray-200">
                                                <label class="form-label mb-0 fw-bold text-muted" style="min-width: 60px;">구분 필터</label>
                                                <select name="filterCategory" class="form-select form-select-solid w-200px" onchange="this.form.submit();">
                                                    <option value="">모든 항목 보기</option>
                                                    <option value="WIN_RATE" ${filterCategory eq 'WIN_RATE' ? 'selected' : ''}>승률 구간</option>
                                                    <option value="ATTENDANCE_COUNT" ${filterCategory eq 'ATTENDANCE_COUNT' ? 'selected' : ''}>직관 횟수</option>
                                                    <option value="RECENT_TREND" ${filterCategory eq 'RECENT_TREND' ? 'selected' : ''}>최근 흐름</option>
                                                </select>
                                            </div>
                                        </form>
                                    </div>
                                </div>

                                <div class="card card-flush">
                                    <div class="card-body py-5">
                                        <div class="table-responsive">
                                            <table class="table align-middle table-row-dashed fs-6 gy-5">
                                                <thead>
                                                    <tr class="text-muted fw-bold fs-7 text-uppercase gs-0 border-bottom border-gray-200">
                                                        <th class="w-100px text-center">구분</th>
                                                        <th class="w-100px text-center">조건 코드</th>
                                                        <th class="w-120px text-center">조건 범위</th>
                                                        <th class="w-200px text-center">레벨 명</th>
                                                        <th class="text-start">멘트 내용</th>
                                                        <th class="w-80px text-center">우선순위</th>
                                                        <th class="w-100px text-center">관리</th>
                                                    </tr>
                                                </thead>
                                                <tbody class="text-gray-600 fw-semibold">
                                                    <c:forEach var="item" items="${list}">
                                                        <tr>
                                                            <td class="text-center">
                                                                <c:choose>
                                                                    <c:when test="${item.category eq 'WIN_RATE'}"><span class="badge badge-light-primary">승률 구간</span></c:when>
                                                                    <c:when test="${item.category eq 'ATTENDANCE_COUNT'}"><span class="badge badge-light-success">직관 횟수</span></c:when>
                                                                    <c:when test="${item.category eq 'RECENT_TREND'}"><span class="badge badge-light-warning">최근 흐름</span></c:when>
                                                                    <c:otherwise><span class="badge badge-light-secondary">${item.category}</span></c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="text-center">${item.conditionCode}</td>
                                                            <td class="text-center fw-bold text-dark">
                                                                <c:choose>
                                                                    <c:when test="${not empty item.minVal}">${item.minVal} ~ ${item.maxVal == 9999 ? '이상' : item.maxVal}</c:when>
                                                                    <c:otherwise>-</c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="text-center fw-bold text-dark">${item.levelName}</td>
                                                            <td class="text-start">${item.message}</td>
                                                            <td class="text-center">${item.priority}</td>
                                                            <td class="text-center">
                                                                <a href="/mng/winyo/mention/detail?mentionId=${item.mentionId}" class="btn btn-sm btn-light btn-active-light-primary">수정</a>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                    <c:if test="${empty list}">
                                                        <tr>
                                                            <td colspan="7" class="text-center p-10 text-muted">검색 결과가 없습니다.</td>
                                                        </tr>
                                                    </c:if>
                                                </tbody>
                                            </table>
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

    <script src="/assets/plugins/global/plugins.bundle.js"></script>
    <script src="/assets/js/scripts.bundle.js"></script>

</body>
</html>