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

    <title>댓글 관리 | 승요일기 관리자</title>
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
                                        전체 댓글 목록
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
                                        <li class="breadcrumb-item text-dark">전체 댓글 목록</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card mb-7">
                                    <div class="card-body">
                                        <form id="searchForm" action="/mng/comment/list" method="get" class="d-flex align-items-center">
                                            <input type="hidden" name="pageNum" value="1">
                                            <input type="hidden" name="amount" value="${pageMaker.cri.amount}">

                                            <div class="position-relative w-md-400px me-md-2">
                                                <i class="ki-duotone ki-magnifier fs-3 text-gray-500 position-absolute top-50 translate-middle ms-6">
                                                    <span class="path1"></span>
                                                    <span class="path2"></span>
                                                </i>
                                                <input type="text" class="form-control form-control-solid ps-10"
                                                       name="keyword" value="${pageMaker.cri.keyword}"
                                                       placeholder="내용 또는 작성자 검색"/>
                                            </div>
                                            <select name="status" class="form-select form-select-solid w-150px me-3">
                                                <option value="" ${empty pageMaker.cri.status ? 'selected' : ''}>전체 상태</option>
                                                <option value="N" ${pageMaker.cri.status eq 'N' ? 'selected' : ''}>정상</option>
                                                <option value="Y" ${pageMaker.cri.status eq 'Y' ? 'selected' : ''}>삭제됨</option>
                                            </select>
                                            <button type="button" class="btn btn-primary" onclick="searchInit()">검색</button>
                                        </form>
                                    </div>
                                </div>

                                <div class="card">
                                    <div class="card-body py-4">
                                        <div class="table-responsive">
                                            <table class="table align-middle table-row-dashed fs-6 gy-5">
                                                <thead>
                                                    <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                                        <th class="min-w-50px text-center">No.</th>
                                                        <th class="min-w-300px">댓글 내용</th>
                                                        <th class="min-w-100px">작성자</th>
                                                        <th class="min-w-100px text-center">작성일</th>
                                                        <th class="min-w-50px text-center">상태</th>
                                                        <th class="min-w-100px text-center">관리</th>
                                                    </tr>
                                                </thead>
                                                <tbody class="text-gray-600 fw-semibold">
                                                    <c:forEach var="item" items="${list}" varStatus="status">
                                                        <tr>
                                                            <td class="text-center">${list.size() - status.index}</td>
                                                            <td>
                                                                <span class="text-gray-800 d-block text-truncate" style="max-width: 400px;">${item.content}</span>
                                                                <a href="/mng/diary/detail?diaryId=${item.diaryId}" target="_blank"
                                                                   class="text-gray-400 fs-8 text-hover-primary">
                                                                    <i class="ki-duotone ki-entrance-right fs-8"></i> 원본 일기 보기
                                                                </a>
                                                            </td>
                                                            <td>
                                                                <div class="d-flex align-items-center">
                                                                    <div class="symbol symbol-circle symbol-35px me-3">
                                                                        <c:choose>
                                                                            <c:when test="${not empty item.profileImage}">
                                                                                <img src="${item.profileImage}" alt="프로필" style="object-fit: cover;">
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <img src="/img/ico_user.svg" alt="기본 프로필" style="background-color: #f5f5f5; padding: 4px;">
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                    <div class="d-flex flex-column">
                                                                        <span class="text-gray-800 fw-bold fs-7">${item.nickname}</span>
                                                                        <span class="text-gray-400 fs-8">${item.email}</span>
                                                                    </div>
                                                                </div>
                                                            </td>
                                                            <td class="text-center">
                                                                <c:choose>
                                                                    <c:when test="${not empty item.regDateStr}">
                                                                        <c:set var="cDate" value="${fn:replace(item.regDateStr, 'T', ' ')}" />
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
                                                                <c:if test="${item.delYn eq 'N'}">
                                                                    <span class="badge badge-light-success">게시</span>
                                                                </c:if>
                                                                <c:if test="${item.delYn eq 'Y'}">
                                                                    <span class="badge badge-light-danger">삭제</span>
                                                                </c:if>
                                                            </td>
                                                            <td class="text-center">
                                                                <c:if test="${item.delYn eq 'N'}">
                                                                    <button class="btn btn-icon btn-bg-light btn-active-color-danger btn-sm"
                                                                            onclick="deleteComment('${item.commentId}')">
                                                                        <i class="ki-duotone ki-trash fs-2">
                                                                            <span class="path1"></span>
                                                                            <span class="path2"></span>
                                                                            <span class="path3"></span>
                                                                            <span class="path4"></span>
                                                                            <span class="path5"></span>
                                                                        </i>
                                                                    </button>
                                                                </c:if>
                                                                <c:if test="${item.delYn eq 'Y'}">-</c:if>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                    <c:if test="${empty list}">
                                                        <tr>
                                                            <td colspan="6" class="text-center py-10">작성된 댓글이 없습니다.</td>
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

    <form id="actionForm" action="/mng/comment/list" method="get">
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

        // 검색 시 1페이지로 초기화
        function searchInit() {
            const form = document.getElementById('searchForm');
            form.pageNum.value = 1; // 1페이지로 리셋
            form.submit();
        }

        function deleteComment(id) {
            if (confirm('이 댓글을 삭제하시겠습니까?')) {
                $.post('/mng/comment/delete', {commentId: id}, function (res) {
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