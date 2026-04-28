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

    <title>콘텐츠 상세 | 승요일기 관리자</title>
    <link href="/assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/assets/css/style.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/css/mngStyle.css" rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">

    <style>
        /* 미리보기 카드 & 비디오 반응형 CSS */
        .video-container { position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; border-radius: 8px; margin-bottom: 20px;}
        .video-container iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
        .og-card { display: flex; flex-direction: column; border: 1px solid #e1e1e1; border-radius: 12px; overflow: hidden; text-decoration: none !important; color: #333; background: #fff; box-shadow: 0 2px 8px rgba(0,0,0,0.04); transition: transform 0.2s;}
        .og-card:hover { transform: translateY(-2px); }
        .og-card img { width: 100%; height: 180px; object-fit: cover; border-bottom: 1px solid #f0f0f0; }
        .og-card-info { padding: 16px; }
        .og-card-title { font-weight: bold; font-size: 15px; margin-bottom: 6px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; line-height: 1.4; color: #111;}
        .og-card-desc { font-size: 13px; color: #666; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; margin-bottom: 10px; line-height: 1.4; }
        .og-card-domain { font-size: 11px; color: #999; text-transform: lowercase; }
    </style>
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
                                        구단 콘텐츠 관리
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
                                        <li class="breadcrumb-item text-dark">구단 콘텐츠 관리</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card mb-5 mb-xl-10">
                                    <div class="card-header border-0 cursor-pointer">
                                        <div class="card-title m-0"><h3 class="fw-bold m-0">구단 콘텐츠 상세</h3></div>
                                    </div>
                                    <div class="card-body p-9">

                                        <div class="row mb-7">
                                            <div class="col-lg-6 d-flex align-items-center">
                                                <label class="col-lg-4 fw-semibold text-muted">구단</label>
                                                <div class="col-lg-8 d-flex align-items-center">
                                                    <c:if test="${not empty content.logoImageUrl}">
                                                        <img src="${content.logoImageUrl}" alt="${content.teamCode}" class="w-30px h-30px object-fit-contain me-2"/>
                                                    </c:if>
                                                    <span class="badge badge-light fw-bold fs-6">${empty content.teamNameKr ? content.teamCode : content.teamNameKr}</span>
                                                </div>
                                            </div>
                                            <div class="col-lg-6 d-flex align-items-center">
                                                <label class="col-lg-4 fw-semibold text-muted">상태</label>
                                                <div class="col-lg-8">
                                                    <c:if test="${content.status eq 'ACTIVE'}"><span class="badge badge-light-success fs-6">활성</span></c:if>
                                                    <c:if test="${content.status eq 'INACTIVE'}"><span class="badge badge-light-secondary fs-6">비활성</span></c:if>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">제목</label>
                                            <div class="col-lg-10">
                                                <span class="fw-bold fs-6 text-gray-800">${content.title}</span>
                                            </div>
                                        </div>

                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">콘텐츠 URL</label>
                                            <div class="col-lg-10">
                                                <c:choose>
                                                    <c:when test="${not empty content.contentUrl}">
                                                        <a href="${content.contentUrl}" target="_blank" class="text-primary d-block mb-3">${content.contentUrl}</a>
                                                        <div id="urlPreviewBox" data-url="${content.contentUrl}" style="max-width: 400px;"></div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">등록된 외부 링크가 없습니다.</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div class="row mb-7">
                                            <div class="col-lg-2 fw-semibold text-muted">썸네일 미리보기</div>
                                            <div class="col-lg-10">
                                                <div class="d-flex flex-center bg-light rounded overflow-hidden" style="width: 200px; height: 150px; border: 1px dashed #ccc;">
                                                    <img src="${not empty content.imageUrl ? content.imageUrl : '/assets/media/svg/files/blank-image.svg'}"
                                                         alt="썸네일" class="mw-100 mh-100 object-fit-contain"
                                                         onclick="window.open(this.src)" style="cursor: pointer;">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">내용</label>
                                            <div class="col-lg-10">
                                                <div class="border rounded p-5 bg-light text-dark fs-6" id="adminContentBody" style="min-height: 150px; width: 100%; overflow: hidden;">
                                                    ${content.content}
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row mb-7">
                                            <div class="col-lg-6 d-flex align-items-center">
                                                <label class="col-lg-4 fw-semibold text-muted">조회수</label>
                                                <div class="col-lg-8">
                                                    <span class="fw-bold fs-6 text-gray-800"><fmt:formatNumber value="${content.clickCount}" pattern="#,###"/> 회</span>
                                                </div>
                                            </div>
                                            <div class="col-lg-6 d-flex align-items-center">
                                                <label class="col-lg-4 fw-semibold text-muted">등록일시</label>
                                                <div class="col-lg-8">
                                                    <span class="fw-bold fs-6 text-gray-800">${fn:replace(content.createdAt, 'T', ' ')}</span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="separator my-10"></div>
                                        <h3 class="fw-bold mb-5">📊 콘텐츠 반응 분석</h3>
                                        <div class="row g-5 g-xl-8">
                                            <div class="col-xl-6">
                                                <div class="card card-bordered h-100">
                                                    <div class="card-header border-0 pt-5">
                                                        <h3 class="card-title align-items-start flex-column">
                                                            <span class="card-label fw-bold text-dark">연령대별 클릭수</span>
                                                            <span class="text-muted mt-1 fw-semibold fs-7">어떤 연령층이 가장 많이 봤을까요?</span>
                                                        </h3>
                                                    </div>
                                                    <div class="card-body pt-0">
                                                        <canvas id="ageChart" style="max-height: 300px;"></canvas>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="col-xl-6">
                                                <div class="card card-bordered h-100">
                                                    <div class="card-header border-0 pt-5">
                                                        <h3 class="card-title align-items-start flex-column">
                                                            <span class="card-label fw-bold text-dark">최근 30일 클릭 추이</span>
                                                            <span class="text-muted mt-1 fw-semibold fs-7">일별 조회수 변화 그래프</span>
                                                        </h3>
                                                    </div>
                                                    <div class="card-body pt-0">
                                                        <canvas id="dailyChart" style="max-height: 300px;"></canvas>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="separator my-10"></div>
                                        <h3 class="fw-bold mb-5">💬 공감 및 댓글 현황</h3>
                                        <div class="row g-5 g-xl-8">
                                            <div class="col-xl-4">
                                                <div class="card card-bordered h-100">
                                                    <div class="card-header border-0 pt-5">
                                                        <h3 class="card-title align-items-start flex-column">
                                                            <span class="card-label fw-bold text-dark">공감 반응 통계</span>
                                                        </h3>
                                                    </div>
                                                    <div class="card-body pt-5 d-flex justify-content-around align-items-center text-center">
                                                        <div>
                                                            <img src="/img/good_icon.svg" style="width:45px; height:45px;" class="mb-3 opacity-75"/>
                                                            <div class="fs-5 fw-bold text-gray-800">좋아요</div>
                                                            <div class="fs-3 text-primary fw-bolder">${content.likeCount}건</div>
                                                        </div>
                                                        <div>
                                                            <img src="/img/sad_icon.svg" style="width:45px; height:45px;" class="mb-3 opacity-75"/>
                                                            <div class="fs-5 fw-bold text-gray-800">슬퍼요</div>
                                                            <div class="fs-3 text-info fw-bolder">${content.sadCount}건</div>
                                                        </div>
                                                        <div>
                                                            <img src="/img/angry_icon.svg" style="width:45px; height:45px;" class="mb-3 opacity-75"/>
                                                            <div class="fs-5 fw-bold text-gray-800">화나요</div>
                                                            <div class="fs-3 text-danger fw-bolder">${content.angryCount}건</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="col-xl-8">
                                                <div class="card card-bordered h-100">
                                                    <div class="card-header border-0 pt-5">
                                                        <h3 class="card-title align-items-start flex-column">
                                                            <span class="card-label fw-bold text-dark">댓글 목록</span>
                                                        </h3>
                                                    </div>
                                                    <div class="card-body pt-5" style="max-height: 300px; overflow-y: auto;">
                                                        <div class="table-responsive">
                                                            <table class="table align-middle gs-0 gy-4">
                                                                <thead class="bg-light">
                                                                <tr class="fw-bold text-muted">
                                                                    <th class="ps-4 min-w-150px rounded-start">작성자</th>
                                                                    <th class="min-w-200px">내용</th>
                                                                    <th class="min-w-125px">작성일시</th>
                                                                    <th class="min-w-50px rounded-end text-end pe-4">관리</th>
                                                                </tr>
                                                                </thead>
                                                                <tbody>
                                                                <c:forEach var="cmt" items="${comments}">
                                                                    <tr>
                                                                        <td>
                                                                            <div class="d-flex align-items-center">
                                                                                <div class="symbol symbol-circle symbol-30px me-3">
                                                                                    <c:choose>
                                                                                        <c:when test="${not empty cmt.profileImage}"><img src="${cmt.profileImage}" alt="프로필" style="object-fit: cover;"></c:when>
                                                                                        <c:otherwise><img src="/img/ico_user.svg" alt="기본" style="background-color:#f5f5f5; padding:4px;"></c:otherwise>
                                                                                    </c:choose>
                                                                                </div>
                                                                                <div class="d-flex flex-column">
                                                                                    <span class="text-gray-800 fw-bold fs-7">${cmt.nickname} <c:if test="${not empty cmt.memberTeamCode}"><span class="badge badge-light ms-1">${cmt.memberTeamCode}</span></c:if></span>
                                                                                    <span class="text-gray-400 fs-8">${cmt.email}</span>
                                                                                </div>
                                                                            </div>
                                                                        </td>
                                                                        <td><span class="text-gray-800 fs-7">${cmt.content}</span></td>
                                                                        <td><span class="text-gray-600 fs-7">${fn:substring(fn:replace(cmt.createdAt, 'T', ' '), 0, 16)}</span></td>
                                                                        <td class="text-end pe-4">
                                                                            <button type="button" class="btn btn-icon btn-light-danger btn-sm" onclick="deleteComment(${cmt.commentId})">
                                                                                <i class="ki-duotone ki-trash fs-3">
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
                                                                <c:if test="${empty comments}">
                                                                    <tr><td colspan="4" class="text-center p-5 text-muted">등록된 댓글이 없습니다.</td></tr>
                                                                </c:if>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card-footer d-flex justify-content-end py-6 px-9">
                                        <a href="/mng/content/teams" class="btn btn-light me-2">목록으로</a>
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
                    <h2 class="fw-bold">콘텐츠 수정</h2>
                    <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                        <i class="ki-duotone ki-cross fs-1">
                            <span class="path1"></span>
                            <span class="path2"></span>
                        </i>
                    </div>
                </div>
                <form id="modifyForm" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="contentId" value="${content.contentId}">

                    <div class="modal-body py-10 px-lg-17">
                        <div class="row mb-7">
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">구단 선택</label>
                                <select class="form-select form-select-solid" name="teamCode" id="detailTeamCode">
                                    <option value="LG" ${content.teamCode eq 'LG' ? 'selected' : ''}>LG</option>
                                    <option value="HANWHA" ${content.teamCode eq 'HANWHA' ? 'selected' : ''}>한화</option>
                                    <option value="SSG" ${content.teamCode eq 'SSG' ? 'selected' : ''}>SSG</option>
                                    <option value="SAMSUNG" ${content.teamCode eq 'SAMSUNG' ? 'selected' : ''}>삼성</option>
                                    <option value="NC" ${content.teamCode eq 'NC' ? 'selected' : ''}>NC</option>
                                    <option value="KT" ${content.teamCode eq 'KT' ? 'selected' : ''}>KT</option>
                                    <option value="LOTTE" ${content.teamCode eq 'LOTTE' ? 'selected' : ''}>롯데</option>
                                    <option value="KIA" ${content.teamCode eq 'KIA' ? 'selected' : ''}>KIA</option>
                                    <option value="DOOSAN" ${content.teamCode eq 'DOOSAN' ? 'selected' : ''}>두산</option>
                                    <option value="KIWOOM" ${content.teamCode eq 'KIWOOM' ? 'selected' : ''}>키움</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">상태</label>
                                <div class="d-flex align-items-center mt-3">
                                    <div class="form-check form-check-custom form-check-solid me-5">
                                        <input class="form-check-input" type="radio" value="ACTIVE" name="status" id="detail_st_active" ${content.status == 'ACTIVE' ? 'checked' : ''}/>
                                        <label class="form-check-label" for="detail_st_active">활성</label>
                                    </div>
                                    <div class="form-check form-check-custom form-check-solid">
                                        <input class="form-check-input" type="radio" value="INACTIVE" name="status" id="detail_st_inactive" ${content.status == 'INACTIVE' ? 'checked' : ''}/>
                                        <label class="form-check-label" for="detail_st_inactive">비활성</label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">제목</label>
                            <input type="text" class="form-control form-control-solid" name="title" id="detailTitle" value="${content.title}" required placeholder="콘텐츠 제목을 입력하세요."/>
                        </div>

                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">콘텐츠 URL</label>
                            <input type="text" class="form-control form-control-solid mb-2" name="contentUrl" id="detailContentUrl" value="${content.contentUrl}" placeholder="https://..." />
                            <div class="form-text text-muted mb-3">- "https://"로 시작하는 링크를 입력하시면 하단에 썸네일과 공유 카드가 자동 생성됩니다.</div>
                            <div id="popupUrlPreviewBox" data-url="${content.contentUrl}" style="max-width: 400px;"></div>
                        </div>

                        <div class="row mb-7">
                            <div class="col-md-4">
                                <label class="fs-6 fw-bold mb-2">썸네일 미리보기</label>
                                <div class="d-flex flex-center bg-light rounded position-relative overflow-hidden" style="width: 200px; height: 150px; border: 1px dashed #ccc;">
                                    <img id="detailPreviewImg" src="${not empty content.imageUrl ? content.imageUrl : '/assets/media/svg/files/blank-image.svg'}" style="max-width: 100%; max-height: 100%; object-fit: contain;" alt="미리보기" />
                                    <div id="detailLoader" class="position-absolute w-100 h-100 justify-content-center align-items-center bg-white bg-opacity-75" style="display: none;">
                                        <div class="spinner-border text-primary" role="status">
                                            <span class="visually-hidden">Loading...</span>
                                        </div>
                                    </div>
                                </div>
                                <input type="hidden" id="detailHiddenImageUrl" name="imageUrl" value="${content.imageUrl}" />
                            </div>
                            <div class="col-md-8">
                                <label class="fs-6 fw-semibold mb-2">썸네일 이미지 변경</label>
                                <input type="file" class="form-control form-control-solid mb-2" name="file" id="detailFileInput" accept="image/jpeg, image/png, image/jpg"/>
                                <div class="form-text text-muted">
                                    - jpg, png, jpeg 파일만 등록 가능합니다.<br>
                                    - 파일 등록 시, 콘텐츠 URL에서 자동 추출된 썸네일보다 우선 적용됩니다.
                                </div>
                            </div>
                        </div>

                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">내용</label>
                            <textarea name="content" id="summernote_edit">${content.content}</textarea>
                        </div>
                    </div>
                    <div class="modal-footer flex-center">
                        <button type="button" class="btn btn-light me-3" data-bs-dismiss="modal">취소</button>
                        <button type="button" class="btn btn-primary" onclick="updateContent()">저장</button>
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
        // URL 썸네일 미리보기를 그리는 공통 함수
        function renderUrlPreview(url, targetElementId) {
            var targetBox = $('#' + targetElementId);
            if (!url) {
                targetBox.empty();
                return;
            }

            var singleYtRegex = /(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/;
            var match = url.match(singleYtRegex);

            if (match && match[1]) {
                targetBox.html('<div class="video-container"><iframe src="https://www.youtube.com/embed/' + match[1] + '" frameborder="0" allowfullscreen></iframe></div>');
            } else {
                $.get('/locker/extract-og', { url: url }, function(res) {
                    if (!res.error && res.title) {
                        var cardHtml = `
                            <a href="\${url}" target="_blank" class="og-card">
                                \${res.image ? '<img src="' + res.image + '" alt="링크 썸네일">' : ''}
                                <div class="og-card-info">
                                    <div class="og-card-title">\${res.title}</div>
                                    <div class="og-card-desc">\${res.description}</div>
                                    <div class="og-card-domain">\${res.domain}</div>
                                </div>
                            </a>
                        `;
                        targetBox.html(cardHtml);
                    } else {
                        targetBox.html('<a href="' + url + '" target="_blank" style="display:block; text-align:center; padding:14px; background:#f8f9fa; border-radius:8px; color:#333; text-decoration:none; font-weight:bold;">🔗 외부 관련 콘텐츠 보러가기</a>');
                    }
                });
            }
        }

        $(document).ready(function() {

            let lastDetailUrl = "${content.contentUrl}"; // 초기값 설정

            // 1. 파일 변경 시 미리보기
            $('input[name="file"]').on('change', function(e) {
                const file = e.target.files[0];
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        $('#detailPreviewImg').attr('src', e.target.result);
                        $('#detailHiddenImageUrl').val(''); // 파일이 우선이므로 추출 URL 제거

                        // 파일 로드 완료 시 로딩바 숨김 및 이미지 투명도 원복
                        $('#detailLoader').removeClass('d-flex').hide();
                        $('#detailPreviewImg').css('opacity', 1);
                    }
                    reader.readAsDataURL(file);
                }
            });

            // 2. [상세페이지] 링크 변경 및 붙여넣기 시 실시간 감지
            $('#detailContentUrl').on('blur paste keyup', function() {
                setTimeout(() => {
                    const url = $(this).val();
                    const fileInput = $('input[name="file"]').val();

                    if (url !== lastDetailUrl) {
                        lastDetailUrl = url;
                        // 모달 하단에 콘텐츠 미리보기 카드 실시간 렌더링
                        renderUrlPreview(url, 'popupUrlPreviewBox');

                        // 썸네일 이미지 자동 추출 (파일이 없을 때만)
                        if (!fileInput && url.length > 10) {
                            $('#detailLoader').addClass('d-flex').show();
                            $('#detailPreviewImg').css('opacity', 0.5);

                            $.get('/mng/content/teams/meta', { url: url }, function(res) {
                                if (res) {
                                    $('#detailPreviewImg').attr('src', res);
                                    $('#detailHiddenImageUrl').val(res);
                                }
                            }).always(function() {
                                $('#detailLoader').removeClass('d-flex').hide();
                                $('#detailPreviewImg').css('opacity', 1);
                            });
                        }
                    }
                }, 100);
            });

            // 3. 페이지 로드 시 렌더링 (상세 뷰 & 팝업 뷰 둘 다 적용)
            renderUrlPreview($('#urlPreviewBox').data('url'), 'urlPreviewBox');
            renderUrlPreview($('#popupUrlPreviewBox').data('url'), 'popupUrlPreviewBox');

            // 썸머노트 본문 내의 고정크기 iframe을 반응형으로 교체
            $('#adminContentBody iframe').each(function() {
                if (!$(this).parent().hasClass('video-container')) {
                    $(this).wrap('<div class="video-container"></div>');
                    // 고정된 가로/세로 크기를 지워 CSS의 100% 비율이 적용되게 함
                    $(this).removeAttr('width').removeAttr('height');
                }
            });

            // 2. 방해되는 조건문을 지우고 우리가 선언한 Summernote 환경설정을 무조건 적용
            $('#summernote_edit').summernote({
                height: 400,
                lang: 'ko-KR',
                toolbar: [
                    ['style', ['style']],
                    ['font', ['bold', 'underline', 'clear']],
                    ['color', ['color']],
                    ['para', ['ul', 'ol', 'paragraph']],
                    ['insert', ['picture', 'video', 'link']]
                ],
                callbacks: {
                    // 실제 파일 업로드를 수행하는 콜백 정상 작동!
                    onImageUpload: function(files) {
                        for (var i = 0; i < files.length; i++) {
                            var data = new FormData();
                            data.append("file", files[i]);
                            $.ajax({
                                url: '/api/common/upload/editor',
                                type: 'POST',
                                data: data,
                                cache: false,
                                contentType: false,
                                processData: false,
                                success: function(url) {
                                    $('#summernote_edit').summernote('insertImage', url);
                                },
                                error: function() {
                                    alert("이미지 업로드 중 오류가 발생했습니다.");
                                }
                            });
                        }
                    }
                }
            });

            // 차트 초기화
            initCharts();
        });

        function openEditModal() {
            const modifyModal = new bootstrap.Modal(document.getElementById('modifyModal'));
            modifyModal.show();
        }

        /**
         * 콘텐츠 수정 (AJAX)
         */
        function updateContent() {
            // FormData 생성 직전에 Summernote 에디터 내용을 textarea에 동기화
            $('#summernote_edit').val($('#summernote_edit').summernote('code'));

            // 폼 데이터 생성
            const form = document.getElementById('modifyForm');
            const formData = new FormData(form);

            // AJAX 전송
            $.ajax({
                url: '/mng/content/teams/save',
                type: 'POST',
                data: formData,
                contentType: false,
                processData: false,
                success: function(res) {
                    if (res === 'ok') {
                        // 팝업 닫기 (안전한 탐색 로직)
                        // 1순위: 전역변수 modal 확인
                        if (typeof modal !== 'undefined') {
                            modal.hide();
                        }
                        // 2순위: 폼을 감싸는 모달 요소 찾기 (Bootstrap 5)
                        else {
                            const modalEl = form.closest('.modal');
                            if (modalEl) {
                                const modalInstance = bootstrap.Modal.getInstance(modalEl);
                                if (modalInstance) modalInstance.hide();
                            }
                        }

                        // 알림창 확인 후 새로고침
                        if(confirm('콘텐츠가 수정되었습니다.')){
                            location.reload(); // 확인 클릭 시 새로고침
                        }
                    } else {
                        alert('수정에 실패했습니다.');
                    }
                },
                error: function() {
                    alert('서버 통신 중 오류가 발생했습니다.');
                }
            });
        }

        // 콘텐츠 댓글 강제 삭제 (관리자)
        function deleteComment(commentId) {
            if(confirm('해당 댓글을 강제 삭제하시겠습니까?')) {
                $.post('/mng/content/teams/comment/delete', { commentId: commentId }, function(res) {
                    if(res === 'ok') {
                        alert('댓글이 삭제되었습니다.');
                        location.reload();
                    } else {
                        alert('삭제 처리 중 오류가 발생했습니다.');
                    }
                });
            }
        }

        // --- 통계 차트 스크립트 ---
        function initCharts() {
            // 서버에서 전달받은 JSON 데이터
            const stats = ${empty statsJson ? '{}' : statsJson};
            // stats 구조: { age: [{ageGroup:'20대', cnt:10}, ...], daily: [{clickDate:'2024-02-01', cnt:5}, ...] }

            // 1. 연령대별 차트 (Bar Chart)
            const ageCtx = document.getElementById('ageChart').getContext('2d');
            const ageLabels = stats.age ? stats.age.map(d => d.ageGroup) : [];
            const ageData = stats.age ? stats.age.map(d => d.cnt) : [];

            new Chart(ageCtx, {
                type: 'bar',
                data: {
                    labels: ageLabels,
                    datasets: [{
                        label: '클릭 수',
                        data: ageData,
                        backgroundColor: 'rgba(54, 162, 235, 0.6)',
                        borderColor: 'rgba(54, 162, 235, 1)',
                        borderWidth: 1,
                        borderRadius: 5
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: { beginAtZero: true, ticks: { stepSize: 1 } }
                    }
                }
            });

            // 2. 일별 추이 차트 (Line Chart)
            const dailyCtx = document.getElementById('dailyChart').getContext('2d');
            const dailyLabels = stats.daily ? stats.daily.map(d => d.clickDate.substring(5)) : []; // MM-dd만 표시
            const dailyData = stats.daily ? stats.daily.map(d => d.cnt) : [];

            new Chart(dailyCtx, {
                type: 'line',
                data: {
                    labels: dailyLabels,
                    datasets: [{
                        label: '일별 조회수',
                        data: dailyData,
                        borderColor: '#50cd89', // 초록색 계열
                        backgroundColor: 'rgba(80, 205, 137, 0.1)',
                        borderWidth: 2,
                        fill: true,
                        tension: 0.3 // 부드러운 곡선
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: { beginAtZero: true, ticks: { stepSize: 1 } }
                    },
                    plugins: {
                        legend: { display: false } // 범례 숨김 (심플하게)
                    }
                }
            });
        }
    </script>
</body>
</html>