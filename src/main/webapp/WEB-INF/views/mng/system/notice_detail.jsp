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

    <title>공지 상세 | 승요일기 관리자</title>
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

                                <div class="card mb-5 mb-xl-10">
                                    <div class="card-header border-0 cursor-pointer">
                                        <div class="card-title m-0"><h3 class="fw-bold m-0">공지사항 상세</h3></div>
                                    </div>
                                    <div class="card-body p-9">
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">제목</label>
                                            <div class="col-lg-10">
                                                <span class="fw-bold fs-6 text-gray-800">${notice.title}</span>
                                            </div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">설정</label>
                                            <div class="col-lg-10">
                                                <span class="badge badge-light-info me-2">${notice.category eq 'SURVEY' ? '설문' : '공지'}</span>
                                                <span class="badge badge-light-primary me-2">고정: ${notice.isTop}</span>
                                                <span class="badge badge-light-${notice.status eq 'ACTIVE' ? 'success' : 'secondary'}">상태: ${notice.status}</span>
                                            </div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">등록일</label>
                                            <div class="col-lg-10">
                                                <span class="fw-bold fs-6 text-gray-800">
                                                    <fmt:parseDate value="${notice.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both"/>
                                                    <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd HH:mm"/>
                                                </span>
                                            </div>
                                        </div>

                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">썸네일</label>
                                            <div class="col-lg-10">
                                                <c:if test="${not empty notice.imageUrl}">
                                                    <img src="${notice.imageUrl}" alt="썸네일" style="max-width: 200px; border-radius: 8px; border: 1px solid #eee;">
                                                </c:if>
                                                <c:if test="${empty notice.imageUrl}">
                                                    <span class="text-gray-400">등록된 이미지가 없습니다.</span>
                                                </c:if>
                                            </div>
                                        </div>

                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">내용</label>
                                            <div class="col-lg-10">
                                                <div class="p-5 border rounded bg-light text-gray-800 fs-6" style="min-height: 200px;">
                                                    <c:out value="${notice.content}" escapeXml="false"/>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-footer d-flex justify-content-end py-6 px-9">
                                        <a href="/mng/system/notices" class="btn btn-light btn-active-light-primary me-2">목록으로</a>
                                        <button type="button" class="btn btn-primary" onclick="openEditModal()">수정하기</button>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modifyModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered mw-900px">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="fw-bold">공지사항 수정</h2>
                    <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                        <span class="svg-icon svg-icon-1"><i class="ki-duotone ki-cross fs-1"><span class="path1"></span><span class="path2"></span></i></span>
                    </div>
                </div>

                <form id="modifyForm" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="noticeId" value="${notice.noticeId}">

                    <div class="modal-body py-10 px-lg-17">
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">제목</label>
                            <input type="text" class="form-control form-control-solid" name="title" value="${notice.title}" required/>
                        </div>

                        <div class="row mb-7">
                            <div class="col-md-4">
                                <label class="required fs-6 fw-semibold mb-2">구분</label>
                                <select class="form-select form-select-solid" name="category">
                                    <option value="NOTICE" ${notice.category eq 'NOTICE' ? 'selected' : ''}>공지</option>
                                    <option value="SURVEY" ${notice.category eq 'SURVEY' ? 'selected' : ''}>설문</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="fs-6 fw-semibold mb-2">상단 고정</label>
                                <select class="form-select form-select-solid" name="isTop">
                                    <option value="N" ${notice.isTop eq 'N' ? 'selected' : ''}>미설정</option>
                                    <option value="Y" ${notice.isTop eq 'Y' ? 'selected' : ''}>고정 (Top)</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="fs-6 fw-semibold mb-2">상태</label>
                                <select class="form-select form-select-solid" name="status">
                                    <option value="ACTIVE" ${notice.status eq 'ACTIVE' ? 'selected' : ''}>게시</option>
                                    <option value="HIDDEN" ${notice.status eq 'HIDDEN' ? 'selected' : ''}>숨김</option>
                                </select>
                            </div>
                        </div>

                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">썸네일 변경</label>
                            <input type="file" name="file" class="form-control form-control-solid" accept="image/*"/>
                            <div class="form-text text-muted">새 파일을 선택하면 기존 이미지가 변경됩니다.</div>
                            <c:if test="${not empty notice.imageUrl}">
                                <div class="mt-2">
                                    <span class="badge badge-light mb-1">현재 이미지:</span><br>
                                    <img src="${notice.imageUrl}" style="max-height: 100px; border-radius: 4px;">
                                </div>
                            </c:if>
                        </div>

                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">내용</label>
                            <textarea class="form-control form-control-solid" name="content" id="summernote_edit" required>${notice.content}</textarea>
                        </div>
                    </div>
                    <div class="modal-footer flex-center">
                        <button type="button" class="btn btn-light me-3" data-bs-dismiss="modal">취소</button>
                        <button type="button" class="btn btn-primary" onclick="updateNotice()">저장</button>
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
        const modal = new bootstrap.Modal(document.getElementById('modifyModal'));

        $(document).ready(function() {
            // 수정 모달용 에디터 초기화
            if (typeof initSummernote === 'function') {
                initSummernote('#summernote_edit', 400);
            } else {
                $('#summernote_edit').summernote({ height: 400, lang: 'ko-KR' });
            }
        });

        // 수정 폼 AJAX 제출 처리
        function updateNotice() {
            // 1. 유효성 검사
            const title = $('input[name="title"]').val();
            if (!title) {
                alert('제목을 입력해주세요.');
                return;
            }

            // Summernote 내용이 비었는지 체크
            if ($('#summernote_edit').summernote('isEmpty')) {
                alert('내용을 입력해주세요.');
                return;
            }

            // 2. 폼 데이터 생성
            // 폼 태그에 id="modifyForm"이 지정되어 있어야 합니다.
            const form = document.getElementById('modifyForm');
            const formData = new FormData(form);

            // 3. AJAX 전송
            $.ajax({
                url: '/mng/system/notices/save',
                type: 'POST',
                data: formData,
                contentType: false, // 파일 업로드 필수 설정
                processData: false, // 파일 업로드 필수 설정
                success: function(response) {
                    if (response === 'ok') {
                        alert('수정되었습니다.');
                        location.reload(); // 성공 시 새로고침
                    } else {
                        alert('수정에 실패했습니다.');
                    }
                },
                error: function(xhr, status, error) {
                    console.error(error);
                    alert('서버 통신 중 오류가 발생했습니다.');
                }
            });
        }

        function openEditModal() {
            modal.show();
        }
    </script>
</body>
</html>