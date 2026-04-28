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

    <title>문의 상세 | 승요일기 관리자</title>
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
                                        1:1 문의 관리
                                    </h1>

                                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0 pt-1">
                                        <li class="breadcrumb-item text-muted">
                                            <a href="/mng/main.do" class="text-muted text-hover-primary">Home</a>
                                        </li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-muted">고객센터</li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-dark">1:1 문의 관리</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card mb-5 mb-xl-10">
                                    <div class="card-header border-0">
                                        <div class="card-title m-0">
                                            <h3 class="fw-bold m-0 me-2">문의 상세</h3>
                                            <c:if test="${inquiry.status eq 'WAITING'}">
                                                <span class="badge badge-light-warning">답변대기</span>
                                            </c:if>
                                            <c:if test="${inquiry.status eq 'COMPLETED'}">
                                                <span class="badge badge-light-success">답변완료</span>
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="card-body p-9">
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">작성자</label>
                                            <div class="col-lg-4">
                                                <span class="fw-bold fs-6 text-gray-800">${inquiry.memberName} (${inquiry.memberEmail})</span>
                                            </div>
                                            <label class="col-lg-2 fw-semibold text-muted">작성일</label>
                                            <div class="col-lg-4">
                                                <span class="fw-bold fs-6 text-gray-800">
                                                    ${fn:replace(fn:substring(inquiry.createdAt, 0, 16), 'T', ' ')}
                                                </span>
                                            </div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">유형</label>
                                            <div class="col-lg-4">
                                                <span class="badge badge-light-primary fw-bold">${inquiry.typeName}</span>
                                            </div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">제목</label>
                                            <div class="col-lg-10">
                                                <span class="fw-bold fs-6 text-gray-800">${inquiry.title}</span>
                                            </div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">내용</label>
                                            <div class="col-lg-10">
                                                <div class="p-5 border rounded bg-light text-gray-800 fs-6" style="white-space: pre-wrap; min-height: 150px;">${inquiry.content}</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="card mb-5 mb-xl-10">
                                    <div class="card-header border-0">
                                        <div class="card-title m-0"><h3 class="fw-bold m-0">관리자 답변</h3></div>
                                        <c:if test="${not empty inquiry.answeredAt}">
                                            <div class="card-toolbar">
                                                <span class="text-gray-400 fs-7">답변일:
                                                    ${fn:replace(fn:substring(inquiry.answeredAt, 0, 16), 'T', ' ')}
                                                </span>
                                            </div>
                                        </c:if>
                                    </div>
                                    <form action="/mng/support/inquiry/answer" method="post">
                                        <input type="hidden" name="inquiryId" value="${inquiry.inquiryId}">

                                        <input type="hidden" name="pageNum" value="${cri.pageNum}">
                                        <input type="hidden" name="amount" value="${cri.amount}">
                                        <input type="hidden" name="keyword" value="${cri.keyword}">
                                        <input type="hidden" name="status" value="${cri.status}">

                                        <div class="card-body p-9 pt-0">
                                            <textarea class="form-control form-control-solid" name="answer" rows="10"
                                                      placeholder="답변 내용을 입력하세요." required>${inquiry.answer}</textarea>
                                        </div>
                                        <div class="card-footer d-flex justify-content-end py-6 px-9">
                                            <a href="/mng/support/inquiry/list?pageNum=${cri.pageNum}&amount=${cri.amount}&keyword=${cri.keyword}&status=${cri.status}"
                                               class="btn btn-light btn-active-light-primary me-2">목록으로</a>
                                            <button type="submit" class="btn btn-primary">
                                                ${empty inquiry.answer ? '답변 등록' : '답변 수정'}
                                            </button>
                                        </div>
                                    </form>
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