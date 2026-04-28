<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%-- 현재 로그인한 사람이 발주사(CLIENT)가 아닌 개발사인지 확인하는 변수 세팅 --%>
<c:set var="isDeveloper" value="${sessionScope.admin.role eq 'ROOT'}" />

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

    <title>요청사항 & 문의 | 승요일기 관리자</title>
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
                                        요청사항 & 문의
                                    </h1>

                                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0 pt-1">
                                        <li class="breadcrumb-item text-muted">
                                            <a href="/mng/main.do" class="text-muted text-hover-primary">Home</a>
                                        </li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-muted">개발사</li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-dark">요청사항 & 문의</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card mb-7">
                                    <div class="card-body">
                                        <form id="searchForm" action="/mng/dev/list" method="get" class="d-flex align-items-center flex-wrap gap-2">
                                            <input type="hidden" name="pageNum" value="1">
                                            <input type="hidden" name="amount" value="${pageMaker.cri.amount}">

                                            <select name="category" class="form-select form-select-solid w-150px">
                                                <option value="">전체 유형</option>
                                                <option value="MAINTENANCE" ${pageMaker.cri.category eq 'MAINTENANCE' ? 'selected' : ''}>
                                                    유지보수
                                                </option>
                                                <option value="BUG" ${pageMaker.cri.category eq 'BUG' ? 'selected' : ''}>
                                                    기능오류
                                                </option>
                                                <option value="INQUIRY" ${pageMaker.cri.category eq 'INQUIRY' ? 'selected' : ''}>
                                                    단순문의
                                                </option>
                                            </select>

                                            <select name="status" class="form-select form-select-solid w-150px">
                                                <option value="">전체 상태</option>
                                                <option value="WAITING" ${pageMaker.cri.status eq 'WAITING' ? 'selected' : ''}>
                                                    처리대기
                                                </option>
                                                <option value="PROCESS" ${pageMaker.cri.status eq 'PROCESS' ? 'selected' : ''}>
                                                    진행중
                                                </option>
                                                <option value="DONE" ${pageMaker.cri.status eq 'DONE' ? 'selected' : ''}>
                                                    완료
                                                </option>
                                                <option value="DISCUSS" ${pageMaker.cri.status eq 'DISCUSS' ? 'selected' : ''}>
                                                    논의필요
                                                </option>
                                                <option value="REJECT" ${pageMaker.cri.status eq 'REJECT' ? 'selected' : ''}>
                                                    처리불가
                                                </option>
                                            </select>

                                            <div class="position-relative w-md-300px">
                                                <i class="ki-duotone ki-magnifier fs-3 text-gray-500 position-absolute top-50 translate-middle ms-6">
                                                    <span class="path1"></span>
                                                    <span class="path2"></span>
                                                </i>
                                                <input type="text" class="form-control form-control-solid ps-10"
                                                       name="keyword" value="${pageMaker.cri.keyword}" placeholder="제목 검색"/>
                                            </div>

                                            <button type="submit" class="btn btn-primary">검색</button>

                                            <div class="ms-auto">
                                                <c:if test="${not isDeveloper}">
                                                    <a href="/mng/dev/write" class="btn btn-success">
                                                        <i class="ki-duotone ki-pencil fs-2">
                                                            <span class="path1"></span>
                                                            <span class="path2"></span>
                                                        </i> 요청하기
                                                    </a>
                                                </c:if>
                                            </div>
                                        </form>
                                    </div>
                                </div>

                                <div class="card">
                                    <div class="card-body py-4">

                                        <%-- 개발사 전용 일괄 상태 변경 툴바 --%>
                                        <c:if test="${isDeveloper}">
                                            <div class="d-flex align-items-center justify-content-start mb-4 gap-2 p-3 bg-light rounded">
                                                <span class="fw-bold text-gray-700 me-2">선택 항목 일괄 변경:</span>
                                                <select id="bulkStatus" class="form-select form-select-solid form-select-sm w-150px">
                                                    <option value="">상태 선택</option>
                                                    <option value="WAITING">처리대기</option>
                                                    <option value="PROCESS">진행중</option>
                                                    <option value="DONE">완료</option>
                                                    <option value="DISCUSS">논의필요</option>
                                                    <option value="REJECT">처리불가</option>
                                                </select>
                                                <input type="date" id="bulkDueDate" class="form-control form-control-solid form-control-sm w-150px" title="처리예정일 (선택사항)">
                                                <button type="button" class="btn btn-sm btn-dark fw-bold" onclick="applyBulkStatus()">변경 적용</button>
                                            </div>
                                        </c:if>

                                        <div class="table-responsive">
                                            <table class="table align-middle table-row-dashed fs-6 gy-5">
                                                <thead>
                                                <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                                    <%-- 개발사 전용: 전체 선택 체크박스 --%>
                                                    <c:if test="${isDeveloper}">
                                                        <th class="w-40px text-center">
                                                            <div class="form-check form-check-sm form-check-custom form-check-solid justify-content-center">
                                                                <input class="form-check-input" type="checkbox" id="chkAll" />
                                                            </div>
                                                        </th>
                                                    </c:if>
                                                    <th class="min-w-50px text-center">No.</th>
                                                    <th class="min-w-80px text-center">유형</th>
                                                    <th class="min-w-300px">제목</th>
                                                    <th class="min-w-100px text-center">작성자</th>
                                                    <th class="min-w-100px text-center">등록일</th>
                                                    <th class="min-w-100px text-center">처리예정일</th>
                                                    <th class="min-w-80px text-center">상태</th>
                                                </tr>
                                                </thead>
                                                <tbody class="text-gray-600 fw-semibold">
                                                <c:forEach var="item" items="${list}" varStatus="status">
                                                    <tr>
                                                        <%-- 개발사 전용: 개별 선택 체크박스 --%>
                                                        <c:if test="${isDeveloper}">
                                                            <td class="text-center">
                                                                <div class="form-check form-check-sm form-check-custom form-check-solid justify-content-center">
                                                                    <input class="form-check-input chk-item" type="checkbox" value="${item.reqId}" />
                                                                </div>
                                                            </td>
                                                        </c:if>
                                                        <td class="text-center">${list.size() - status.index}</td>
                                                        <td class="text-center">
                                                            <c:if test="${item.urgency eq 'Y'}">
                                                                <span class="badge badge-danger me-1">긴급</span>
                                                            </c:if>
                                                            <span class="badge badge-light fw-bold">${item.categoryName}</span>
                                                        </td>
                                                        <td>
                                                            <a href="/mng/dev/detail?reqId=${item.reqId}&pageNum=${pageMaker.cri.pageNum}&amount=${pageMaker.cri.amount}&category=${pageMaker.cri.category}&status=${pageMaker.cri.status}&keyword=${pageMaker.cri.keyword}"
                                                               class="text-gray-800 text-hover-primary fw-bold fs-6">
                                                                    ${item.title}
                                                                <c:if test="${item.commentCount > 0}">
                                                                    <span class="text-primary ms-1">[${item.commentCount}]</span>
                                                                </c:if>
                                                            </a>
                                                        </td>
                                                        <td class="text-center">${item.writerRole ne 'ROOT' ? '관리자' : '개발사'}</td>
                                                        <td class="text-center">
                                                            <c:choose>
                                                                <c:when test="${not empty item.createdAt}">
                                                                    <c:set var="cDate" value="${fn:replace(item.createdAt, 'T', ' ')}" />
                                                                    <c:choose>
                                                                        <c:when test="${fn:length(cDate) > 19}">
                                                                            ${fn:substring(cDate, 0, 19)}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            ${cDate}
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:when>
                                                                <c:otherwise>-</c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-center">
                                                            <c:out value="${item.dueDate}" default="-"/>
                                                        </td>
                                                        <td class="text-center">
                                                            <span class="badge ${item.statusBadge}">${item.status}</span>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty list}">
                                                    <tr>
                                                        <td colspan="${isDeveloper ? 8 : 7}" class="text-center py-10">등록된 요청사항이 없습니다.</td>
                                                    </tr>
                                                </c:if>
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

    <form id="actionForm" action="/mng/dev/list" method="get">
        <input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
        <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
        <input type="hidden" name="category" value="${pageMaker.cri.category}">
        <input type="hidden" name="status" value="${pageMaker.cri.status}">
        <input type="hidden" name="keyword" value="${pageMaker.cri.keyword}">
    </form>

    <script src="/assets/plugins/global/plugins.bundle.js"></script>
    <script src="/assets/js/scripts.bundle.js"></script>
    <script>
        $(document).ready(function () {
            var actionForm = $("#actionForm");

            // 페이지 번호 클릭 이벤트
            $(".page-link").on("click", function (e) {
                e.preventDefault();
                var targetPage = $(this).attr("href");
                actionForm.find("input[name='pageNum']").val(targetPage);
                actionForm.submit();
            });

            // 개발사 전용 체크박스 이벤트 바인딩
            <c:if test="${isDeveloper}">
                // 전체 선택/해제
                $('#chkAll').on('change', function() {
                    $('.chk-item').prop('checked', $(this).is(':checked'));
                });

                // 개별 선택 시 전체 선택 상태 동기화
                $('.chk-item').on('change', function() {
                    if($('.chk-item:checked').length === $('.chk-item').length) {
                        $('#chkAll').prop('checked', true);
                    } else {
                        $('#chkAll').prop('checked', false);
                    }
                });
            </c:if>
        });

        // 일괄 상태 변경 AJAX 요청 함수
        <c:if test="${isDeveloper}">
            function applyBulkStatus() {
                var reqIds = [];
                $('.chk-item:checked').each(function() {
                    reqIds.push($(this).val());
                });

                if (reqIds.length === 0) {
                    alert('상태를 변경할 항목을 체크해주세요.');
                    return;
                }

                var status = $('#bulkStatus').val();
                if (!status) {
                    alert('변경할 처리 상태를 선택해주세요.');
                    $('#bulkStatus').focus();
                    return;
                }

                var dueDate = $('#bulkDueDate').val();

                if (confirm(reqIds.length + '개의 요청사항을 선택한 상태로 일괄 변경하시겠습니까?')) {
                    $.ajax({
                        url: '/mng/dev/status/bulk',
                        type: 'POST',
                        traditional: true, // List(배열) 파라미터 직렬화를 위한 필수 설정
                        data: {
                            reqIds: reqIds,
                            status: status,
                            dueDate: dueDate
                        },
                        success: function(res) {
                            if (res === 'ok') {
                                alert('일괄 변경 처리되었습니다.');
                                location.reload();
                            } else {
                                alert('처리 중 오류가 발생했습니다.');
                            }
                        },
                        error: function() {
                            alert('서버 통신 오류가 발생했습니다.');
                        }
                    });
                }
            }
        </c:if>
    </script>
</body>
</html>