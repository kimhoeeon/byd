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

    <title>FAQ 관리 | 승요일기 관리자</title>
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
                                        FAQ 관리
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
                                        <li class="breadcrumb-item text-dark">FAQ 관리</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card mb-7">
                                    <div class="card-body py-4 d-flex justify-content-between align-items-center">
                                        <h3 class="card-title m-0">❓ FAQ 관리</h3>
                                        <button type="button" class="btn btn-primary" onclick="openModal()">
                                            <i class="ki-duotone ki-plus fs-2"></i> FAQ 등록
                                        </button>
                                    </div>
                                </div>

                                <div class="card">
                                    <div class="card-body py-4">
                                        <div class="table-responsive">
                                            <table class="table align-middle table-row-dashed fs-6 gy-5">
                                                <thead>
                                                <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                                    <th class="min-w-50px">순서</th>
                                                    <th class="min-w-100px">카테고리</th>
                                                    <th class="min-w-300px">질문</th>
                                                    <th class="min-w-100px">상태</th>
                                                    <th class="min-w-100px">관리</th>
                                                </tr>
                                                </thead>
                                                <tbody class="text-gray-600 fw-semibold">
                                                <c:forEach var="item" items="${list}">
                                                    <tr>
                                                        <td><span class="badge badge-light fw-bold">${item.sortOrder}</span>
                                                        </td>
                                                        <td><span
                                                                class="badge badge-light-primary">${item.categoryName}</span>
                                                        </td>
                                                        <td class="text-gray-800 fw-bold">${item.question}</td>
                                                        <td>
                                                            <c:if test="${item.isVisible eq 'Y'}"><span
                                                                    class="badge badge-light-success">노출</span></c:if>
                                                            <c:if test="${item.isVisible eq 'N'}"><span
                                                                    class="badge badge-light-secondary">숨김</span></c:if>
                                                        </td>
                                                        <td>
                                                            <button class="btn btn-icon btn-bg-light btn-active-color-primary btn-sm me-1"
                                                                    onclick="editFaq('${item.faqId}')">
                                                                <i class="ki-duotone ki-pencil fs-2"><span
                                                                        class="path1"></span><span class="path2"></span></i>
                                                            </button>
                                                            <button class="btn btn-icon btn-bg-light btn-active-color-danger btn-sm"
                                                                    onclick="deleteFaq('${item.faqId}')">
                                                                <i class="ki-duotone ki-trash fs-2"><span
                                                                        class="path1"></span><span
                                                                        class="path2"></span><span
                                                                        class="path3"></span><span
                                                                        class="path4"></span><span class="path5"></span></i>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty list}">
                                                    <tr>
                                                        <td colspan="5" class="text-center py-10">등록된 FAQ가 없습니다.</td>
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

    <div class="modal fade" id="faqModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered mw-650px">
            <div class="modal-content">
                <form id="faqForm" action="/mng/support/faq/save" method="post">
                    <input type="hidden" name="faqId" id="faqId">
                    <div class="modal-header">
                        <h2 class="fw-bold" id="modalTitle">FAQ 등록</h2>
                        <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal"><i
                                class="ki-duotone ki-cross fs-1"><span class="path1"></span><span class="path2"></span></i>
                        </div>
                    </div>
                    <div class="modal-body py-10 px-lg-17">
                        <div class="row mb-7">
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">카테고리</label>
                                <select class="form-select form-select-solid" name="category" id="category">
                                    <option value="MEMBER">회원/계정</option>
                                    <option value="DIARY">일기/기록</option>
                                    <option value="GAME">경기/데이터</option>
                                    <option value="ETC">기타</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="fs-6 fw-semibold mb-2">정렬 순서</label>
                                <input type="number" class="form-control form-control-solid" name="sortOrder" id="sortOrder"
                                       value="0"/>
                            </div>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">질문</label>
                            <input type="text" class="form-control form-control-solid" name="question" id="question"
                                   required/>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">답변</label>
                            <textarea class="form-control form-control-solid" name="answer" id="answer" rows="5"
                                      required></textarea>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">노출 여부</label>
                            <div class="form-check form-switch form-check-custom form-check-solid">
                                <input class="form-check-input" type="checkbox" value="Y" name="isVisible" id="isVisible"
                                       checked="checked"/>
                                <label class="form-check-label" for="isVisible">사용자에게 보이기</label>
                            </div>
                            <input type="hidden" name="isVisible_hidden" value="N">
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
        const modal = new bootstrap.Modal(document.getElementById('faqModal'));

        // 체크박스 값 처리 보완
        document.getElementById('faqForm').addEventListener('submit', function () {
            const chk = document.getElementById('isVisible');
            if (!chk.checked) {
                // 체크 해제 시 hidden input을 만들어 N 값 전송 (혹은 Controller에서 null 처리)
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'isVisible';
                input.value = 'N';
                this.appendChild(input);
            }
        });

        function openModal() {
            document.getElementById('faqForm').reset();
            document.getElementById('faqId').value = '';
            document.getElementById('modalTitle').innerText = 'FAQ 등록';
            document.getElementById('isVisible').checked = true;
            modal.show();
        }

        function editFaq(id) {
            fetch('/mng/support/faq/get?faqId=' + id)
                .then(res => res.json())
                .then(data => {
                    document.getElementById('faqId').value = data.faqId;
                    document.getElementById('category').value = data.category;
                    document.getElementById('sortOrder').value = data.sortOrder;
                    document.getElementById('question').value = data.question;
                    document.getElementById('answer').value = data.answer;
                    document.getElementById('isVisible').checked = (data.isVisible === 'Y');

                    document.getElementById('modalTitle').innerText = 'FAQ 수정';
                    modal.show();
                });
        }

        function deleteFaq(id) {
            if (confirm('삭제하시겠습니까?')) {
                $.post('/mng/support/faq/delete', {faqId: id}, function (res) {
                    if (res === 'ok') location.reload();
                });
            }
        }
    </script>
</body>
</html>