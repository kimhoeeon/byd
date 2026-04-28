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

    <title>관리자 계정 ${empty vo ? '등록' : '수정'} | 승요일기 관리자</title>
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
                                        관리자 계정 관리
                                    </h1>

                                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0 pt-1">
                                        <li class="breadcrumb-item text-muted">
                                            <a href="/mng/main.do" class="text-muted text-hover-primary">Home</a>
                                        </li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-dark">관리자 계정 관리</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card">
                                    <div class="card-header">
                                        <div class="card-title"><h3>관리자 계정 ${empty vo ? '등록' : '수정'}</h3></div>
                                    </div>
                                    <div class="card-body">
                                        <form id="adminForm" action="/mng/system/admin/save" method="post">
                                            <input type="hidden" name="adminId" value="${vo.adminId}">

                                            <h5 class="mb-4">1. 기본 정보</h5>
                                            <div class="row mb-5">
                                                <div class="col-md-6">
                                                    <label class="required form-label">로그인 ID</label>
                                                    <input type="text" name="loginId" class="form-control"
                                                           value="${vo.loginId}" ${not empty vo ? 'readonly' : ''} required/>
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="required form-label">이름</label>
                                                    <input type="text" name="name" class="form-control" value="${vo.name}" required/>
                                                </div>
                                            </div>
                                            <div class="row mb-5">
                                                <div class="col-md-6">
                                                    <label class="${empty vo ? 'required' : ''} form-label">비밀번호</label>
                                                    <input type="password" name="password" class="form-control"
                                                           placeholder="${empty vo ? '필수 입력' : '변경 시에만 입력'}"/>
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="required form-label">권한</label>
                                                    <select name="role" class="form-select" required ${vo.role eq 'ROOT' or vo.role eq 'SUPER' ? 'disabled' : ''}>
                                                        <option value="MANAGER" ${vo.role eq 'MANAGER' ? 'selected' : ''}>운영자</option>
                                                        <option value="CLIENT" ${vo.role eq 'CLIENT' ? 'selected' : ''}>발주사</option>
                                                        <c:if test="${vo.role eq 'SUPER'}">
                                                            <option value="SUPER" selected>최고관리자</option>
                                                        </c:if>
                                                    </select>
                                                    <%-- select disabled일 때 데이터 전송이 안되는 것을 막기 위한 hidden 꼼수 --%>
                                                    <c:if test="${vo.role eq 'ROOT' or vo.role eq 'SUPER'}">
                                                        <input type="hidden" name="role" value="${vo.role}">
                                                    </c:if>
                                                </div>
                                            </div>

                                            <div class="separator my-10"></div>

                                            <h5 class="mb-4 d-flex justify-content-between align-items-center">
                                                <span>2. 접속 허용 IP</span>
                                                <button type="button" class="btn btn-sm btn-light-primary"
                                                        onclick="addIpField()">+ IP 추가
                                                </button>
                                            </h5>
                                            <div id="ipContainer">
                                                <c:forEach var="ip" items="${vo.allowedIpList}" varStatus="status">
                                                    <div class="input-group mb-3">
                                                        <input type="text" class="form-control"
                                                               name="allowedIpList[${status.index}]" value="${ip}"
                                                               placeholder="예: 123.123.123.123">
                                                        <button class="btn btn-light-danger" type="button"
                                                                onclick="removeRow(this)">삭제
                                                        </button>
                                                    </div>
                                                </c:forEach>
                                                <c:if test="${empty vo.allowedIpList}">
                                                    <div class="input-group mb-3">
                                                        <input type="text" class="form-control" name="allowedIpList[0]"
                                                               placeholder="예: 123.123.123.123">
                                                        <button class="btn btn-light-danger" type="button"
                                                                onclick="removeRow(this)">삭제
                                                        </button>
                                                    </div>
                                                </c:if>
                                            </div>

                                            <div class="separator my-10"></div>

                                            <h5 class="mb-4 d-flex justify-content-between align-items-center">
                                                <span>3. 알림 수신 이메일</span>
                                                <button type="button" class="btn btn-sm btn-light-primary"
                                                        onclick="addEmailField()">+ 이메일 추가
                                                </button>
                                            </h5>
                                            <div id="emailContainer">
                                                <c:forEach var="email" items="${vo.emailList}" varStatus="status">
                                                    <div class="row mb-3 border-bottom pb-3">
                                                        <div class="col-md-5">
                                                            <input type="email" class="form-control"
                                                                   name="emailList[${status.index}].emailAddress"
                                                                   value="${email.emailAddress}" placeholder="이메일 주소">
                                                        </div>
                                                        <div class="col-md-5">
                                                            <input type="text" class="form-control"
                                                                   name="emailList[${status.index}].receiveTypes"
                                                                   value="${email.receiveTypes}"
                                                                   placeholder="수신유형 (ALL, BUG, MAINTENANCE 등)">
                                                        </div>
                                                        <div class="col-md-2 text-end">
                                                            <button class="btn btn-light-danger btn-sm" type="button"
                                                                    onclick="removeRow(this.parentNode.parentNode)">삭제
                                                            </button>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                                <c:if test="${empty vo.emailList}">
                                                    <div class="row mb-3 border-bottom pb-3">
                                                        <div class="col-md-5">
                                                            <input type="email" class="form-control"
                                                                   name="emailList[0].emailAddress" placeholder="이메일 주소">
                                                        </div>
                                                        <div class="col-md-5">
                                                            <input type="text" class="form-control"
                                                                   name="emailList[0].receiveTypes" value="ALL"
                                                                   placeholder="수신유형 (ALL, BUG 등)">
                                                        </div>
                                                        <div class="col-md-2 text-end">
                                                            <button class="btn btn-light-danger btn-sm" type="button"
                                                                    onclick="removeRow(this.parentNode.parentNode)">삭제
                                                            </button>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </div>

                                            <div class="text-end mt-5">
                                                <a href="/mng/system/admin/list" class="btn btn-light me-2">취소</a>
                                                <button type="submit" class="btn btn-primary">저장하기</button>
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
    </div>

    <script src="/assets/plugins/global/plugins.bundle.js"></script>
    <script src="/assets/js/scripts.bundle.js"></script>
    <script>
        let ipCount = ${empty vo.allowedIpList ? 1 : vo.allowedIpList.size()};
        let emailCount = ${empty vo.emailList ? 1 : vo.emailList.size()};

        function addIpField() {
            const html = `
                <div class="input-group mb-3">
                    <input type="text" class="form-control" name="allowedIpList[\${ipCount}]" placeholder="예: 123.123.123.123">
                    <button class="btn btn-light-danger" type="button" onclick="removeRow(this)">삭제</button>
                </div>`;
            document.getElementById('ipContainer').insertAdjacentHTML('beforeend', html);
            ipCount++;
        }

        function addEmailField() {
            const html = `
                <div class="row mb-3 border-bottom pb-3">
                    <div class="col-md-5">
                        <input type="email" class="form-control" name="emailList[\${emailCount}].emailAddress" placeholder="이메일 주소">
                    </div>
                    <div class="col-md-5">
                        <input type="text" class="form-control" name="emailList[\${emailCount}].receiveTypes" value="ALL" placeholder="수신유형">
                    </div>
                    <div class="col-md-2 text-end">
                        <button class="btn btn-light-danger btn-sm" type="button" onclick="removeRow(this.parentNode.parentNode)">삭제</button>
                    </div>
                </div>`;
            document.getElementById('emailContainer').insertAdjacentHTML('beforeend', html);
            emailCount++;
        }

        function removeRow(btn) {
            // input-group 또는 row 삭제
            if (btn.classList.contains('input-group')) btn.remove();
            else btn.closest('div.input-group, div.row').remove();
        }
    </script>
</body>
</html>