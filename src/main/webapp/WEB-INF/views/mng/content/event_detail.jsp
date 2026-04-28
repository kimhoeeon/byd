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

    <title>이벤트 상세 | 승요일기 관리자</title>
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
                                        이벤트 관리
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
                                        <li class="breadcrumb-item text-dark">이벤트 관리</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card mb-5 mb-xl-10">
                                    <div class="card-header border-0 cursor-pointer">
                                        <div class="card-title m-0"><h3 class="fw-bold m-0">이벤트 상세</h3></div>
                                    </div>
                                    <div class="card-body p-9">
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">제목</label>
                                            <div class="col-lg-10"><span class="fw-bold fs-6 text-gray-800">${event.title}</span></div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">기간</label>
                                            <div class="col-lg-10"><span class="fw-bold fs-6 text-gray-800">${event.startDate} ~ ${event.endDate}</span></div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">상태</label>
                                            <div class="col-lg-10">
                                                <c:if test="${event.status eq 'ACTIVE'}"><span class="badge badge-light-success">활성</span></c:if>
                                                <c:if test="${event.status eq 'INACTIVE'}"><span class="badge badge-light-secondary">비활성</span></c:if>
                                            </div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">경로</label>
                                            <div class="col-lg-10">
                                                <span class="badge badge-light-primary me-2">${event.linkType eq 'EXTERNAL' ? '외부링크' : '게시판'}</span>
                                                <c:if test="${event.linkType eq 'EXTERNAL'}"><a href="${event.linkUrl}" target="_blank">${event.linkUrl}</a></c:if>
                                            </div>
                                        </div>

                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">썸네일 이미지</label>
                                            <div class="col-lg-10">
                                                <c:if test="${not empty event.imageUrl}">
                                                    <img src="${event.imageUrl}" alt="썸네일" style="max-width: 300px; border-radius: 8px; border: 1px solid #eee;">
                                                </c:if>
                                                <c:if test="${empty event.imageUrl}">
                                                    <span class="text-muted">등록된 이미지가 없습니다.</span>
                                                </c:if>
                                            </div>
                                        </div>

                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">내용</label>
                                            <div class="col-lg-10">
                                                <div class="p-5 border rounded bg-light text-gray-800 fs-6 min-h-200px">
                                                    <c:out value="${event.content}" escapeXml="false"/>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-footer d-flex justify-content-end py-6 px-9">
                                        <a href="/mng/content/events" class="btn btn-light btn-active-light-primary me-2">목록으로</a>
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
                    <h2 class="fw-bold">이벤트 수정</h2>
                    <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                        <i class="ki-duotone ki-cross fs-1">
                            <span class="path1"></span>
                            <span class="path2"></span>
                        </i>
                    </div>
                </div>

                <form id="eventEditForm" action="/mng/content/events/save" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="eventId" value="${event.eventId}">

                    <div class="modal-body py-10 px-lg-17">
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">상태</label>
                            <div class="d-flex align-items-center mt-3">
                                <div class="form-check form-check-custom form-check-solid me-5">
                                    <input class="form-check-input" type="radio" value="ACTIVE" name="status" ${event.status eq 'ACTIVE' ? 'checked' : ''}/>
                                    <label class="form-check-label">활성</label>
                                </div>
                                <div class="form-check form-check-custom form-check-solid">
                                    <input class="form-check-input" type="radio" value="INACTIVE" name="status" ${event.status eq 'INACTIVE' ? 'checked' : ''}/>
                                    <label class="form-check-label">비활성</label>
                                </div>
                            </div>
                        </div>

                        <div class="row mb-7">
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">시작일</label>
                                <input type="date" class="form-control form-control-solid" name="startDate" value="${event.startDate}" required />
                            </div>
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">종료일</label>
                                <input type="date" class="form-control form-control-solid" name="endDate" value="${event.endDate}" required />
                            </div>
                        </div>

                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">제목</label>
                            <input type="text" class="form-control form-control-solid" name="title" value="${event.title}" required />
                        </div>

                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">이동 경로</label>
                            <div class="d-flex align-items-center mt-3">
                                <div class="form-check form-check-custom form-check-solid me-5">
                                    <input class="form-check-input" type="radio" value="BOARD" name="linkType" ${event.linkType eq 'BOARD' ? 'checked' : ''}/>
                                    <label class="form-check-label">게시판</label>
                                </div>
                                <div class="form-check form-check-custom form-check-solid">
                                    <input class="form-check-input" type="radio" value="EXTERNAL" name="linkType" ${event.linkType eq 'EXTERNAL' ? 'checked' : ''}/>
                                    <label class="form-check-label">외부 링크</label>
                                </div>
                            </div>
                        </div>

                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">외부 링크 URL</label>
                            <input type="text" class="form-control form-control-solid" name="linkUrl" value="${event.linkUrl}" placeholder="https://example.com" />
                            <div class="form-text text-muted">"https://" 가 포함된 전체 링크로 복사/붙여넣기 해주세요.</div>
                        </div>

                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">썸네일 변경</label>
                            <input type="file" name="file" class="form-control form-control-solid" accept="image/jpeg, image/png, image/jpg"/>
                            <div class="form-text text-muted">새 파일을 선택하면 기존 이미지가 변경됩니다. (10MB 이하)</div>
                            <c:if test="${not empty event.imageUrl}">
                                <div class="mt-2">
                                    <span class="badge badge-light mb-1">현재 이미지:</span><br>
                                    <img src="${event.imageUrl}" style="max-height: 100px; border-radius: 4px;">
                                </div>
                            </c:if>
                        </div>

                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">내용</label>
                            <textarea name="content" id="summernote_edit">${event.content}</textarea>
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

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/assets/plugins/global/plugins.bundle.js"></script>
    <script src="/assets/js/scripts.bundle.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.min.js"></script>
    <script src="/js/summernote.js"></script>
    <script>
        const modifyModal = new bootstrap.Modal(document.getElementById('modifyModal'));

        $(document).ready(function() {
            if(typeof initSummernote === 'function') {
                initSummernote('#summernote_edit', 400);
            } else {
                $('#summernote_edit').summernote({ height: 400, lang: 'ko-KR' });
            }

            // 이벤트 수정 폼 제출 시 외부 링크 필수 입력 검증
            $('#eventEditForm').on('submit', function(e) {
                var linkType = $('input[name="linkType"]:checked').val();
                var linkUrl = $('input[name="linkUrl"]').val().trim();

                if (linkType === 'EXTERNAL' && linkUrl === '') {
                    alert('외부 링크 URL을 입력해주세요.');
                    $('input[name="linkUrl"]').focus();
                    e.preventDefault(); // 폼 제출 막기
                    return false;
                }
            });
        });

        function openEditModal() {
            modifyModal.show();
        }
    </script>
</body>
</html>