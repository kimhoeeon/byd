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

    <title>공지사항 관리 | 승요일기 관리자</title>
    <link href="/assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/assets/css/style.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/css/mngStyle.css" rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
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
                                        공지사항 관리
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
                                        <li class="breadcrumb-item text-dark">공지사항 관리</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card mb-7">
                                    <div class="card-body py-4 d-flex justify-content-between align-items-center">
                                        <h3 class="card-title m-0">📢 공지사항 목록</h3>
                                        <button type="button" class="btn btn-primary" onclick="openModal()">
                                            <i class="ki-duotone ki-plus fs-2"></i> 공지 등록
                                        </button>
                                    </div>
                                </div>

                                <div class="card">
                                    <div class="card-body py-4">
                                        <div class="table-responsive">
                                            <table class="table align-middle table-row-dashed fs-6 gy-5">
                                                <thead>
                                                    <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                                        <th class="min-w-50px text-center">No.</th>
                                                        <th class="min-w-50px text-center">구분</th>
                                                        <th class="min-w-50px text-center">고정</th>
                                                        <th class="min-w-200px">제목</th>
                                                        <th class="min-w-100px text-center">상태</th>
                                                        <th class="min-w-100px text-center">조회수</th>
                                                        <th class="min-w-100px text-center">등록일</th>
                                                        <th class="min-w-70px text-center">관리</th>
                                                    </tr>
                                                </thead>
                                                <tbody class="text-gray-600 fw-semibold">
                                                    <c:forEach var="item" items="${list}" varStatus="status">
                                                        <tr>
                                                            <td class="text-center">${list.size() - status.index}</td>
                                                            <td class="text-center">
                                                                <c:choose>
                                                                    <c:when test="${item.category eq 'SURVEY'}"><span class="badge badge-light-info">설문</span></c:when>
                                                                    <c:otherwise><span class="badge badge-light-primary">공지</span></c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="text-center">
                                                                <c:if test="${item.isTop eq 'Y'}"><span class="badge badge-light-danger">TOP</span></c:if>
                                                                <c:if test="${item.isTop ne 'Y'}">-</c:if>
                                                            </td>
                                                            <td>
                                                                <span class="text-gray-800 fw-bold">${item.title}</span>
                                                            </td>
                                                            <td class="text-center">
                                                                <c:if test="${item.status eq 'ACTIVE'}"><div class="badge badge-light-success">게시중</div></c:if>
                                                                <c:if test="${item.status eq 'HIDDEN'}"><div class="badge badge-light-secondary">숨김</div></c:if>
                                                            </td>
                                                            <td class="text-center">${item.viewCount}</td>
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
                                                                <a href="/mng/system/notices/detail?noticeId=${item.noticeId}"
                                                                   class="btn btn-icon btn-bg-light btn-active-color-primary btn-sm me-1"
                                                                   title="수정">
                                                                    <i class="ki-duotone ki-pencil fs-2">
                                                                        <span class="path1"></span>
                                                                        <span class="path2"></span>
                                                                    </i>
                                                                </a>
                                                                <button type="button"
                                                                        onclick="deleteNotice(${item.noticeId})"
                                                                        class="btn btn-icon btn-bg-light btn-active-color-danger btn-sm"
                                                                        title="삭제">
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

    <div class="modal fade" id="noticeModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered mw-900px">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="fw-bold" id="modalTitle">공지사항 등록</h2>
                    <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                        <span class="svg-icon svg-icon-1"><i class="ki-duotone ki-cross fs-1"><span class="path1"></span><span class="path2"></span></i></span>
                    </div>
                </div>

                <form id="noticeForm" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="noticeId" id="noticeId">

                    <div class="modal-body py-10 px-lg-17">
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">제목</label>
                            <input type="text" class="form-control form-control-solid" name="title" id="title" required />
                        </div>

                        <div class="row mb-7">
                            <div class="col-md-4">
                                <label class="required fs-6 fw-semibold mb-2">구분</label>
                                <select class="form-select form-select-solid" name="category" id="category">
                                    <option value="NOTICE">공지</option>
                                    <option value="SURVEY">설문</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="fs-6 fw-semibold mb-2">상단 고정</label>
                                <select class="form-select form-select-solid" name="isTop" id="isTop">
                                    <option value="N">미설정</option>
                                    <option value="Y">고정 (Top)</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="fs-6 fw-semibold mb-2">상태</label>
                                <select class="form-select form-select-solid" name="status" id="status">
                                    <option value="ACTIVE">게시</option>
                                    <option value="HIDDEN">숨김</option>
                                </select>
                            </div>
                        </div>

                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">썸네일 이미지</label>
                            <input type="file" name="file" class="form-control form-control-solid" accept="image/*"/>
                            <div class="form-text text-muted">리스트에 노출될 이미지를 등록해주세요. (권장: 300x200)</div>
                        </div>

                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">내용</label>
                            <textarea name="content" id="content"></textarea>
                        </div>
                    </div>

                    <div class="modal-footer flex-center">
                        <button type="button" class="btn btn-light me-3" data-bs-dismiss="modal">취소</button>
                        <button type="button" class="btn btn-primary" onclick="saveNotice()">저장</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/assets/plugins/global/plugins.bundle.js"></script>
    <script src="/assets/js/scripts.bundle.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.min.js"></script>
    <script src="/js/summernote.js"></script>
    <script>

        // 1. 초기화 및 전역 변수 설정
        let noticeModal;

        $(document).ready(function() {

            const modalEl = document.getElementById('noticeModal');
            if (modalEl) {
                noticeModal = new bootstrap.Modal(modalEl);
            }

            // [6] Summernote 초기화 (summernote.js의 함수 사용)
            // 만약 initSummernote가 로드되지 않았을 경우를 대비한 안전 장치
            if (typeof initSummernote === 'function') {
                initSummernote('#content', 400); // ID, Height
            } else {
                $('#content').summernote({ height: 400, lang: 'ko-KR' });
            }
        });

        // 2. 등록 모달 열기
        function openModal() {
            // 1. 폼 리셋
            const form = document.getElementById('noticeForm');
            if (form) form.reset();

            // 2. 히든값(ID) 초기화
            $('#noticeId').val('');

            // 3. 에디터 내용 초기화
            $('#content').summernote('reset');

            // 4. 모달 타이틀 변경
            $('#modalTitle').text('공지사항 등록');

            // 5. 체크박스 초기화 (선택사항)
            $('#isTop').prop('checked', false);

            // 6. 모달 표시
            if (noticeModal) noticeModal.show();
        }

        /**
         * 공지사항 저장 (AJAX)
         */
        function saveNotice() {
            const title = $('#title').val();

            // 유효성 검사
            if (!title.trim()) {
                alert('제목을 입력해주세요.');
                $('#title').focus();
                return;
            }
            if ($('#content').summernote('isEmpty')) {
                alert('내용을 입력해주세요.');
                $('#content').summernote('focus');
                return;
            }

            // Summernote 내용 동기화 (Form Data 생성 전 필수)
            /* textarea에 값이 잘 들어가있는지 확인 필요, 보통 summernote('code')로 가져옴 */
            /* FormData 생성 시 자동으로 textarea 값을 가져오려면 값을 넣어줘야 함 */
            /* $('#content').val($('#content').summernote('code')); // 필요 시 주석 해제 */

            // 폼 데이터 생성 (파일 포함)
            const form = document.getElementById('noticeForm');
            const formData = new FormData(form);

            // AJAX 전송
            $.ajax({
                url: '/mng/system/notices/save',
                type: 'POST',
                data: formData,
                contentType: false, // 파일 업로드 시 필수
                processData: false, // 파일 업로드 시 필수
                success: function(response) {
                    if (response === 'ok') {
                        alert('저장되었습니다.');
                        location.reload(); // 목록 새로고침
                    } else {
                        alert('저장에 실패했습니다. 고객센터로 문의해 주세요.');
                    }
                },
                error: function() {
                    alert('서버 통신 중 오류가 발생했습니다.');
                }
            });
        }

        function deleteNotice(id) {
            if (confirm('삭제하시겠습니까?')) {
                $.post('/mng/system/notices/delete', {noticeId: id}, function (res) {
                    if (res === 'ok') location.reload();
                    else alert('삭제 실패');
                });
            }
        }
    </script>
</body>
</html>