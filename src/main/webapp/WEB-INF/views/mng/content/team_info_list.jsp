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

    <title>구단 정보 관리 | 승요일기 관리자</title>
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
                                        구단 정보 관리
                                    </h1>

                                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0 pt-1">
                                        <li class="breadcrumb-item text-muted">
                                            <a href="/mng/main.do" class="text-muted text-hover-primary">Home</a>
                                        </li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-muted">콘텐츠 관리</li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-dark">구단 정보 관리</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card mb-7">
                                    <div class="card-body py-4">
                                        <h3 class="card-title m-0">⚾ KBO 구단 정보 관리</h3>
                                        <div class="text-muted fs-7 mt-1">구단 로고 및 앱 내 노출 정보를 관리합니다.</div>
                                    </div>
                                </div>

                                <div class="card">
                                    <div class="card-body py-4">
                                        <div class="table-responsive">
                                            <table class="table align-middle table-row-dashed fs-6 gy-5">
                                                <thead>
                                                <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                                    <th class="min-w-50px text-center">순서</th>
                                                    <th class="min-w-100px text-center">로고</th>
                                                    <th class="min-w-100px text-center">코드</th>
                                                    <th class="min-w-150px">구단명 (한글/영문)</th>
                                                    <th class="min-w-100px">메인 컬러</th>
                                                    <th class="min-w-100px text-center">관리</th>
                                                </tr>
                                                </thead>
                                                <tbody class="text-gray-600 fw-semibold">
                                                <c:forEach var="item" items="${list}">
                                                    <tr>
                                                        <td class="text-center">
                                                            <span class="badge badge-light fw-bold">${item.sortOrder}</span>
                                                        </td>
                                                        <td class="text-center">
                                                            <div class="symbol symbol-50px">
                                                                <img src="${item.logoImageUrl}" alt="${item.nameKr}" onerror="this.src='/img/logo.png'"/>
                                                            </div>
                                                        </td>
                                                        <td class="text-center">
                                                            <span class="badge badge-light-primary">${item.teamCode}</span>
                                                        </td>
                                                        <td>
                                                            <div class="text-gray-800 fw-bold">${item.nameKr}</div>
                                                            <div class="text-gray-400 fs-7">${item.nameEn}</div>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <span class="w-20px h-20px rounded-circle me-2 border" style="background-color:${item.colorMainHex}"></span>
                                                                ${item.colorMainHex}
                                                            </div>
                                                        </td>
                                                        <td class="text-center">
                                                            <button class="btn btn-icon btn-bg-light btn-active-color-primary btn-sm" onclick="editTeam('${item.teamCode}')">
                                                                <i class="ki-duotone ki-pencil fs-2">
                                                                    <span class="path1"></span>
                                                                    <span class="path2"></span>
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

    <div class="modal fade" id="teamModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered mw-650px">
            <div class="modal-content">
                <form id="teamForm" action="/mng/content/team-info/save" method="post" enctype="multipart/form-data">
                    <div class="modal-header">
                        <h2 class="fw-bold">구단 정보 수정</h2>
                        <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                            <i class="ki-duotone ki-cross fs-1">
                                <span class="path1"></span>
                                <span class="path2"></span>
                            </i>
                        </div>
                    </div>
                    <div class="modal-body py-10 px-lg-17">
                        <div class="row mb-7">
                            <div class="col-md-6">
                                <label class="fs-6 fw-semibold mb-2">구단 코드</label>
                                <input type="text" class="form-control form-control-solid" name="teamCode" id="teamCode" readonly/>
                            </div>
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">정렬 순서</label>
                                <input type="number" class="form-control form-control-solid" name="sortOrder" id="sortOrder" required/>
                            </div>
                        </div>
                        <div class="row mb-7">
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">구단명 (한글)</label>
                                <input type="text" class="form-control form-control-solid" name="nameKr" id="nameKr" required/>
                            </div>
                            <div class="col-md-6">
                                <label class="fs-6 fw-semibold mb-2">구단명 (영문)</label>
                                <input type="text" class="form-control form-control-solid" name="nameEn" id="nameEn"/>
                            </div>
                        </div>
                        <div class="row mb-7">
                            <div class="col-md-6">
                                <label class="fs-6 fw-semibold mb-2">약어 (Scoreboard용)</label>
                                <input type="text" class="form-control form-control-solid" name="shortName" id="shortName"/>
                            </div>
                            <div class="col-md-6">
                                <label class="fs-6 fw-semibold mb-2">메인 컬러 (HEX)</label>
                                <input type="text" class="form-control form-control-solid" name="colorMainHex" id="colorMainHex" placeholder="#FFFFFF"/>
                            </div>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">로고 파일 업로드 (변경 시 첨부)</label>
                            <input type="file" class="form-control form-control-solid mb-3" name="uploadFile" id="uploadFile" accept="image/*"/>

                            <label class="required fs-6 fw-semibold mb-2">현재 로고 이미지 URL</label>
                            <input type="text" class="form-control form-control-solid" name="logoImageUrl" id="logoImageUrl" required/>
                            <div class="text-muted fs-8 mt-2">※ 새 이미지를 업로드하면 위 URL이 새로운 파일 경로로 자동 교체됩니다.</div>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">홈페이지 URL</label>
                            <input type="text" class="form-control form-control-solid" name="homepageUrl" id="homepageUrl"/>
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
        <c:if test="${not empty msg}">
            alert('${msg}');
        </c:if>

        const modal = new bootstrap.Modal(document.getElementById('teamModal'));
        function editTeam(code) {
            fetch('/mng/content/team-info/get?teamCode=' + code)
                .then(res => res.json())
                .then(data => {
                    document.getElementById('teamCode').value = data.teamCode;
                    document.getElementById('sortOrder').value = data.sortOrder;
                    document.getElementById('nameKr').value = data.nameKr;
                    document.getElementById('nameEn').value = data.nameEn;
                    document.getElementById('shortName').value = data.shortName;
                    document.getElementById('colorMainHex').value = data.colorMainHex;
                    document.getElementById('logoImageUrl').value = data.logoImageUrl;
                    document.getElementById('homepageUrl').value = data.homepageUrl;

                    modal.show();
                });
        }
    </script>
</body>
</html>