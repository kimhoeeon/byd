<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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

    <title>약관 상세 | 승요일기 관리자</title>
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
                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card mb-5 mb-xl-10">
                                    <div class="card-header border-0 cursor-pointer">
                                        <div class="card-title m-0"><h3 class="fw-bold m-0">약관 상세 정보</h3></div>
                                    </div>
                                    <div class="card-body p-9">
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">구분</label>
                                            <div class="col-lg-4">
                                                <span class="badge badge-light-primary fw-bold fs-6">${term.typeName}</span>
                                            </div>
                                            <label class="col-lg-2 fw-semibold text-muted">버전</label>
                                            <div class="col-lg-4">
                                                <span class="fw-bold fs-6 text-gray-800">${term.version}</span>
                                            </div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">제목</label>
                                            <div class="col-lg-10">
                                                <span class="fw-bold fs-6 text-gray-800">${term.title}</span>
                                            </div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">필수 여부</label>
                                            <div class="col-lg-4">
                                                <c:if test="${term.isRequired eq 'Y'}"><span
                                                        class="badge badge-light-danger">필수</span></c:if>
                                                <c:if test="${term.isRequired eq 'N'}"><span
                                                        class="badge badge-light-success">선택</span></c:if>
                                            </div>
                                            <label class="col-lg-2 fw-semibold text-muted">최종 수정일</label>
                                            <div class="col-lg-4">
                                                <span class="fw-bold fs-6 text-gray-800">
                                                    <fmt:parseDate value="${term.updatedAt}" pattern="yyyy-MM-dd'T'HH:mm:ss"
                                                                   var="parsedDate" type="both"/>
                                                    <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd HH:mm"/>
                                                </span>
                                            </div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">약관 내용</label>
                                            <div class="col-lg-10">
                                                <div class="p-5 border rounded bg-light text-gray-800 fs-6"
                                                     style="min-height: 300px;">
                                                    <c:out value="${term.content}" escapeXml="false"/>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-footer d-flex justify-content-end py-6 px-9">
                                        <a href="/mng/system/terms"
                                           class="btn btn-light btn-active-light-primary me-2">목록으로</a>
                                        <button type="button" class="btn btn-primary" onclick="openEditModal()">수정하기
                                        </button>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="termsModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered mw-800px">
            <div class="modal-content">
                <form action="/mng/system/terms/save" method="post">
                    <input type="hidden" name="termId" value="${term.termId}">
                    <div class="modal-header">
                        <h2 class="fw-bold">약관 수정</h2>
                        <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal"><i
                                class="ki-duotone ki-cross fs-1"><span class="path1"></span><span class="path2"></span></i>
                        </div>
                    </div>
                    <div class="modal-body py-10 px-lg-17">
                        <div class="row mb-7">
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">구분</label>
                                <select class="form-select form-select-solid" name="type">
                                    <option value="SERVICE" ${term.type eq 'SERVICE' ? 'selected' : ''}>이용약관</option>
                                    <option value="PRIVACY" ${term.type eq 'PRIVACY' ? 'selected' : ''}>개인정보처리방침</option>
                                    <option value="LOCATION" ${term.type eq 'LOCATION' ? 'selected' : ''}>위치정보 이용약관
                                    </option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">버전</label>
                                <input type="text" class="form-control form-control-solid" name="version"
                                       value="${term.version}" required/>
                            </div>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">제목</label>
                            <input type="text" class="form-control form-control-solid" name="title" value="${term.title}"
                                   required/>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">필수 여부</label>
                            <select class="form-select form-select-solid" name="isRequired">
                                <option value="Y" ${term.isRequired eq 'Y' ? 'selected' : ''}>필수</option>
                                <option value="N" ${term.isRequired eq 'N' ? 'selected' : ''}>선택</option>
                            </select>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">내용 (HTML)</label>
                            <textarea class="form-control form-control-solid" name="content" rows="15"
                                      required>${term.content}</textarea>
                        </div>
                    </div>
                    <div class="modal-footer flex-center">
                        <button type="button" class="btn btn-light me-3" data-bs-dismiss="modal">취소</button>
                        <button type="submit" class="btn btn-primary">저장</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="/assets/plugins/global/plugins.bundle.js"></script>
    <script src="/assets/js/scripts.bundle.js"></script>
    <script>
        const modal = new bootstrap.Modal(document.getElementById('termsModal'));

        function openEditModal() {
            modal.show();
        }
    </script>
</body>
</html>