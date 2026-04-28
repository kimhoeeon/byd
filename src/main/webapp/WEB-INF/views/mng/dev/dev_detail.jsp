<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%-- 권한 체크: 현재 로그인한 사람이 발주사가 아닌 개발사인지 확인 --%>
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

    <title>요청사항 상세 | 승요일기 관리자</title>
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

                                <%-- [개발사 전용] 상태 즉시 변경 패널 --%>
                                <c:if test="${isDeveloper}">
                                    <div class="card mb-5 bg-light-primary border border-primary border-dashed">
                                        <div class="card-body p-5 d-flex align-items-center justify-content-between flex-wrap gap-3">
                                            <div class="d-flex align-items-center gap-4">
                                                <span class="fw-bold text-primary fs-5">
                                                    <i class="ki-duotone ki-setting-2 fs-2 text-primary me-1"><span class="path1"></span><span class="path2"></span></i>
                                                    처리 상태 관리
                                                </span>
                                                <select id="detailStatus" class="form-select form-select-solid w-150px">
                                                    <option value="WAITING" ${vo.status == 'WAITING' ? 'selected' : ''}>처리대기</option>
                                                    <option value="PROCESS" ${vo.status == 'PROCESS' ? 'selected' : ''}>진행중</option>
                                                    <option value="DONE" ${vo.status == 'DONE' ? 'selected' : ''}>완료</option>
                                                    <option value="DISCUSS" ${vo.status == 'DISCUSS' ? 'selected' : ''}>논의필요</option>
                                                    <option value="REJECT" ${vo.status == 'REJECT' ? 'selected' : ''}>처리불가</option>
                                                </select>
                                                <div class="d-flex align-items-center">
                                                    <span class="fw-bold text-gray-700 me-2">처리 예정일</span>
                                                    <input type="date" id="detailDueDate" class="form-control form-control-solid w-150px" value="${vo.dueDate}">
                                                </div>
                                            </div>
                                            <button type="button" class="btn btn-primary" onclick="updateDetailStatus()">상태 저장 및 메일발송</button>
                                        </div>
                                    </div>
                                </c:if>

                                <%-- 1. 본문 영역 --%>
                                <div class="card mb-5 mb-xl-10">
                                    <div class="card-header border-0 cursor-pointer d-flex justify-content-between align-items-center">
                                        <div class="card-title m-0 d-flex align-items-center gap-3">
                                            <c:if test="${vo.urgency eq 'Y'}">
                                                <span class="badge badge-danger fs-6">긴급</span>
                                            </c:if>
                                            <span class="badge badge-light fs-6">${vo.categoryName}</span>
                                            <h3 class="fw-bolder m-0 text-gray-900">${vo.title}</h3>
                                        </div>
                                        <div class="card-toolbar gap-2">
                                            <span class="badge ${vo.statusBadge} fs-6">${vo.status}</span>
                                            <c:if test="${sessionScope.admin.adminId == vo.adminId}">
                                                <a href="/mng/dev/write?reqId=${vo.reqId}" class="btn btn-sm btn-light-primary">수정</a>
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="card-body p-9 pt-0">
                                        <div class="d-flex justify-content-between mb-8 text-muted fs-7 border-bottom pb-4">
                                            <div>
                                                <span class="fw-bold text-gray-800 me-2">${vo.writerRole ne 'ROOT' ? '관리자' : '개발사'}</span>
                                                <span>| 작성일: ${fn:substring(fn:replace(vo.createdAt, 'T', ' '), 0, 16)}</span>
                                            </div>
                                            <div>
                                                <span>처리예정일: ${empty vo.dueDate ? '미정' : vo.dueDate}</span>
                                            </div>
                                        </div>

                                        <div class="fs-5 text-gray-800 mb-10" style="white-space: pre-wrap; min-height: 100px;">${vo.content}</div>

                                        <c:if test="${not empty vo.fileList}">
                                            <div class="mt-5 p-5 bg-light rounded">
                                                <h5 class="text-gray-700 fw-bold mb-3"><i class="ki-duotone ki-paper-clip fs-3 me-2"><span class="path1"></span><span class="path2"></span></i>첨부 파일</h5>
                                                <div class="d-flex flex-wrap gap-2">
                                                    <c:forEach items="${vo.fileList}" var="f">
                                                        <a href="${f.filePath}${f.saveFileName}" download="${f.orgFileName}" class="btn btn-sm btn-light btn-active-light-primary">
                                                            ${f.orgFileName}
                                                        </a>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>

                                <%-- 2. 댓글 영역 --%>
                                <div class="card mb-5 mb-xl-10">
                                    <div class="card-header border-0">
                                        <div class="card-title m-0">
                                            <h3 class="fw-bold m-0">댓글 및 피드백 <span class="text-primary ms-2">${fn:length(comments)}</span></h3>
                                        </div>
                                    </div>
                                    <div class="card-body p-9 pt-0">

                                        <%-- 댓글 목록 --%>
                                        <div class="mb-10">
                                            <c:forEach items="${comments}" var="comment">
                                                <div class="p-5 mb-5 border rounded ${comment.writerRole ne 'ROOT' ? 'bg-light' : 'bg-light-info'}">
                                                    <div class="d-flex justify-content-between align-items-center mb-3 border-bottom pb-3">
                                                        <div class="d-flex align-items-center">
                                                            <%--<span class="fw-bold text-gray-900 fs-6 me-2">${comment.writerName}</span>--%>
                                                            <span class="fw-bold fs-6 badge ${comment.writerRole ne 'ROOT' ? 'badge-light-dark' : 'badge-primary'}">
                                                                ${comment.writerRole ne 'ROOT' ? '관리자' : '개발사'}
                                                            </span>
                                                        </div>
                                                        <div class="text-muted fs-8">${fn:substring(fn:replace(comment.createdAt, 'T', ' '), 0, 16)}</div>
                                                    </div>

                                                    <%-- 읽기 모드 --%>
                                                    <div id="comment-view-${comment.commentId}">
                                                        <div class="text-gray-800 fs-6 mb-4" style="white-space: pre-wrap;">${comment.content}</div>
                                                        <c:if test="${not empty comment.fileList}">
                                                            <div class="d-flex flex-wrap gap-2 mt-3">
                                                                <c:forEach items="${comment.fileList}" var="cf">
                                                                    <a href="${cf.filePath}${cf.saveFileName}" download="${cf.orgFileName}" class="badge badge-light-secondary fs-7 p-2">
                                                                        <i class="ki-duotone ki-file-down me-1"></i>${cf.orgFileName}
                                                                    </a>
                                                                </c:forEach>
                                                            </div>
                                                        </c:if>

                                                        <c:if test="${sessionScope.admin.adminId == comment.adminId}">
                                                            <div class="d-flex justify-content-end mt-4 gap-2">
                                                                <button type="button" class="btn btn-sm btn-light btn-active-light-primary px-3 py-2" onclick="toggleEdit(${comment.commentId}, true)">수정</button>
                                                                <button type="button" class="btn btn-sm btn-light-danger px-3 py-2" onclick="deleteComment(${comment.commentId})">삭제</button>
                                                            </div>
                                                        </c:if>
                                                    </div>

                                                        <%-- 수정 모드 폼 (기본 숨김) --%>
                                                    <c:if test="${sessionScope.admin.adminId == comment.adminId}">
                                                        <div id="comment-edit-${comment.commentId}" style="display: none;">
                                                            <form action="/mng/dev/comment/update" method="post" enctype="multipart/form-data">
                                                                <input type="hidden" name="commentId" value="${comment.commentId}">
                                                                <input type="hidden" name="reqId" value="${vo.reqId}">

                                                                <textarea name="content" class="form-control form-control-solid mb-3" rows="3" required>${comment.content}</textarea>

                                                                <c:if test="${not empty comment.fileList}">
                                                                    <div class="mb-3 p-3 bg-white rounded border">
                                                                        <span class="fs-8 fw-bold text-danger mb-2 d-block">체크한 파일은 삭제됩니다.</span>
                                                                        <c:forEach items="${comment.fileList}" var="cf">
                                                                            <label class="form-check form-check-sm form-check-custom form-check-solid mb-2">
                                                                                <input class="form-check-input" type="checkbox" name="deleteFileIds" value="${cf.fileId}">
                                                                                <span class="form-check-label text-gray-700 fs-7">${cf.orgFileName}</span>
                                                                            </label>
                                                                        </c:forEach>
                                                                    </div>
                                                                </c:if>

                                                                <input type="file" name="coFiles" class="form-control form-control-solid mb-3" multiple title="추가할 파일 선택">

                                                                <div class="d-flex justify-content-end gap-2">
                                                                    <button type="button" class="btn btn-sm btn-light px-3 py-2" onclick="toggleEdit(${comment.commentId}, false)">취소</button>
                                                                    <button type="submit" class="btn btn-sm btn-primary px-3 py-2">수정 완료</button>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </c:forEach>
                                        </div>

                                        <%-- 신규 댓글 작성 폼 --%>
                                        <div class="p-5 border border-dashed border-gray-300 rounded bg-white mt-8">
                                            <form action="/mng/dev/comment/save" method="post" enctype="multipart/form-data">
                                                <input type="hidden" name="reqId" value="${vo.reqId}">
                                                <label class="fs-6 fw-bold mb-2">댓글 작성</label>
                                                <textarea name="content" class="form-control form-control-solid mb-3" rows="3" placeholder="피드백이나 문의사항을 입력해주세요." required></textarea>
                                                <div class="d-flex align-items-center justify-content-between">
                                                    <input type="file" name="coFiles" class="form-control form-control-solid w-50" multiple title="파일 첨부 (여러 개 가능)">
                                                    <button type="submit" class="btn btn-dark fw-bold">댓글 등록</button>
                                                </div>
                                            </form>
                                        </div>

                                    </div>
                                    <div class="card-footer d-flex justify-content-end py-6 px-9">
                                        <a href="/mng/dev/list?pageNum=${param.pageNum}&amount=${param.amount}&category=${param.category}&status=${param.status}&keyword=${param.keyword}" class="btn btn-light btn-active-light-primary">목록으로</a>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/assets/plugins/global/plugins.bundle.js"></script>
    <script src="/assets/js/scripts.bundle.js"></script>
    <script>
        // [개발사 전용] 상세 페이지 내 단건 상태 변경
        <c:if test="${isDeveloper}">
            function updateDetailStatus() {
                var status = $('#detailStatus').val();
                var dueDate = $('#detailDueDate').val();

                var msg = '상태를 변경하시겠습니까?';
                if (status === 'DONE') {
                    msg = '상태를 완료로 변경합니다.\n관리자에게 처리완료 알림 메일이 발송됩니다.\n진행하시겠습니까?';
                }

                if (confirm(msg)) {
                    $.ajax({
                        url: '/mng/dev/status',
                        type: 'POST',
                        data: {
                            reqId: ${vo.reqId},
                            status: status,
                            dueDate: dueDate
                        },
                        success: function(res) {
                            if (res === 'ok') {
                                alert('저장 및 처리되었습니다.');
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

        // 댓글 수정 모드 토글
        function toggleEdit(commentId, isEdit) {
            if (isEdit) {
                $('#comment-view-' + commentId).hide();
                $('#comment-edit-' + commentId).fadeIn();
            } else {
                $('#comment-edit-' + commentId).hide();
                $('#comment-view-' + commentId).fadeIn();
            }
        }

        // 댓글 삭제
        function deleteComment(commentId) {
            if (confirm('해당 댓글을 삭제하시겠습니까?\n첨부된 파일도 함께 삭제됩니다.')) {
                $.ajax({
                    url: '/mng/dev/comment/delete',
                    type: 'POST',
                    data: { commentId: commentId },
                    success: function(res) {
                        if (res === 'ok') {
                            alert('삭제되었습니다.');
                            location.reload();
                        } else {
                            alert('삭제 실패했습니다.');
                        }
                    }
                });
            }
        }
    </script>
</body>
</html>