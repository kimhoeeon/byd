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

    <title>앱 버전 관리 | 승요일기 관리자</title>
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
                                        앱 버전 관리
                                    </h1>

                                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0 pt-1">
                                        <li class="breadcrumb-item text-muted">
                                            <a href="/mng/main.do" class="text-muted text-hover-primary">Home</a>
                                        </li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-muted">시스템 관리</li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-dark">앱 버전 관리</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card mb-7">
                                    <div class="card-body py-4 d-flex justify-content-between align-items-center">
                                        <h3 class="card-title m-0">📱 앱 버전 목록</h3>
                                        <button type="button" class="btn btn-primary" onclick="openModal()">
                                            <i class="ki-duotone ki-plus fs-2"></i> 버전 등록
                                        </button>
                                    </div>
                                </div>

                                <div class="card">
                                    <div class="card-body py-4">
                                        <div class="table-responsive">
                                            <table class="table align-middle table-row-dashed fs-6 gy-5">
                                                <thead>
                                                <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                                    <th class="min-w-50px text-center">OS</th>
                                                    <th class="min-w-100px text-center">버전명</th>
                                                    <th class="min-w-100px text-center">빌드번호</th>
                                                    <th class="min-w-100px text-center">강제업데이트</th>
                                                    <th class="min-w-200px">메시지</th>
                                                    <th class="min-w-100px text-center">등록일</th>
                                                    <th class="min-w-100px text-center">삭제</th>
                                                </tr>
                                                </thead>
                                                <tbody class="text-gray-600 fw-semibold">
                                                <c:forEach var="item" items="${list}">
                                                    <tr>
                                                        <td class="text-center">
                                                            <c:if test="${item.osType eq 'ANDROID'}">
                                                                <i class="ki-duotone ki-android fs-2 text-success">
                                                                    <span class="path1"></span>
                                                                    <span class="path2"></span>
                                                                    <span class="path3"></span>
                                                                    <span class="path4"></span>
                                                                    <span class="path5"></span>
                                                                    <span class="path6"></span>
                                                                </i>
                                                            </c:if>
                                                            <c:if test="${item.osType eq 'IOS'}">
                                                                <i class="ki-duotone ki-apple fs-2 text-dark">
                                                                    <span class="path1"></span>
                                                                    <span class="path2"></span>
                                                                </i>
                                                            </c:if>
                                                        </td>
                                                        <td class="fw-bold text-gray-800 text-center">${item.versionName}</td>
                                                        <td class="text-center">${item.versionCode}</td>
                                                        <td class="text-center">
                                                            <c:if test="${item.forceUpdateYn eq 'Y'}">
                                                                <span class="badge badge-light-danger">필수</span>
                                                            </c:if>
                                                            <c:if test="${item.forceUpdateYn eq 'N'}">
                                                                <span class="badge badge-light-secondary">선택</span>
                                                            </c:if>
                                                        </td>
                                                        <td class="text-truncate" style="max-width: 200px;">${item.message}</td>
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
                                                            <button class="btn btn-icon btn-bg-light btn-active-color-danger btn-sm"
                                                                    onclick="deleteVersion('${item.versionId}')">
                                                                <i class="ki-duotone ki-trash fs-2">
                                                                    <span class="path1"></span>
                                                                    <span class="path2"></span>
                                                                    <span class="path3"></span>
                                                                    <span class="path4"></span>
                                                                    <span class="path5"></span>
                                                                </i>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
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

    <div class="modal fade" id="versionModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered mw-650px">
            <div class="modal-content">
                <form action="/mng/system/versions/save" method="post">
                    <div class="modal-header">
                        <h2 class="fw-bold">앱 버전 등록</h2>
                        <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal"><i
                                class="ki-duotone ki-cross fs-1"><span class="path1"></span><span class="path2"></span></i>
                        </div>
                    </div>
                    <div class="modal-body py-10 px-lg-17">
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">OS 종류</label>
                            <select class="form-select form-select-solid" name="osType">
                                <option value="ANDROID">Android</option>
                                <option value="IOS">iOS</option>
                            </select>
                        </div>
                        <div class="row mb-7">
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">버전명 (예: 1.0.0)</label>
                                <input type="text" class="form-control form-control-solid" name="versionName" required/>
                            </div>
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">빌드번호 (숫자)</label>
                                <input type="number" class="form-control form-control-solid" name="versionCode" required/>
                            </div>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">강제 업데이트 여부</label>
                            <select class="form-select form-select-solid" name="forceUpdateYn">
                                <option value="N">선택 (권장)</option>
                                <option value="Y">필수 (강제)</option>
                            </select>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">업데이트 메시지</label>
                            <input type="text" class="form-control form-control-solid" name="message"
                                   placeholder="새로운 기능이 추가되었습니다."/>
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
        const modal = new bootstrap.Modal(document.getElementById('versionModal'));

        function openModal() {
            modal.show();
        }

        function deleteVersion(id) {
            if (confirm('삭제하시겠습니까?')) {
                $.post('/mng/system/versions/delete', {versionId: id}, function (res) {
                    if (res === 'ok') location.reload();
                    else alert('삭제 실패');
                });
            }
        }
    </script>
</body>
</html>