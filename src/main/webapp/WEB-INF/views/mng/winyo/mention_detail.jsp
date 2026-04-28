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

    <title>멘트 상세 | 승요일기 관리자</title>
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

                        <div id="kt_app_toolbar" class="app-toolbar py-3 py-lg-6">
                            <div id="kt_app_toolbar_container" class="app-container container-fluid d-flex flex-stack">
                                <div class="page-title d-flex flex-column justify-content-center flex-wrap me-3">
                                    <h1 class="page-heading d-flex text-dark fw-bold fs-3 flex-column justify-content-center my-0">승요 멘트 상세 및 수정</h1>
                                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0 pt-1">
                                        <li class="breadcrumb-item text-muted">승요력 관리</li>
                                        <li class="breadcrumb-item"><span class="bullet bg-gray-400 w-5px h-2px"></span></li>
                                        <li class="breadcrumb-item text-muted">승요 멘트 수정</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-fluid">
                                <div class="card shadow-sm">
                                    <div class="card-header border-0 pt-5">
                                        <h3 class="card-title fw-bold">멘트 설정 수정</h3>
                                    </div>
                                    <div class="card-body py-5">
                                        <form id="mentionForm">
                                            <input type="hidden" name="mentionId" value="${mention.mentionId}">
                                            <input type="hidden" name="category" value="${mention.category}">
                                            <input type="hidden" name="conditionCode" value="${mention.conditionCode}">

                                            <div class="row mb-8">
                                                <div class="col-md-6">
                                                    <label class="form-label fs-6 fw-bold">구분 (카테고리)</label>
                                                    <input type="text" class="form-control form-control-solid bg-secondary"
                                                           value="${mention.category eq 'WIN_RATE' ? '승률 구간 (%)' : mention.category eq 'ATTENDANCE_COUNT' ? '직관 횟수 (회)' : mention.category eq 'RECENT_TREND' ? '최근 흐름' : mention.category}" readonly />
                                                    <div class="form-text mt-2">※ 카테고리와 조건 코드는 시스템 로직과 연결되어 임의로 변경할 수 없습니다.</div>
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="form-label fs-6 fw-bold">조건 코드 (시스템 매핑용)</label>
                                                    <input type="text" class="form-control form-control-solid bg-secondary" value="${mention.conditionCode}" readonly />
                                                </div>
                                            </div>

                                            <div class="separator border-dashed my-8"></div>

                                            <div class="mb-8">
                                                <label class="required form-label fs-6 fw-bold">레벨 명</label>
                                                <input type="text" name="levelName" class="form-control" value="${mention.levelName}" required placeholder="이모티콘과 함께 칭호를 입력하세요 (예: 🍼 응애 승요)" />
                                            </div>

                                            <div class="row mb-8">
                                                <div class="col-md-4">
                                                    <label class="form-label fs-6 fw-bold">조건 최소값 (시작)</label>
                                                    <input type="number" name="minVal" class="form-control ${mention.category eq 'RECENT_TREND' ? 'form-control-solid bg-secondary' : ''}"
                                                           value="${mention.minVal}" ${mention.category eq 'RECENT_TREND' ? 'readonly' : ''} />
                                                </div>
                                                <div class="col-md-4">
                                                    <label class="form-label fs-6 fw-bold">조건 최대값 (끝)</label>
                                                    <input type="number" name="maxVal" class="form-control ${mention.category eq 'RECENT_TREND' ? 'form-control-solid bg-secondary' : ''}"
                                                           value="${mention.maxVal}" ${mention.category eq 'RECENT_TREND' ? 'readonly' : ''} />
                                                    <c:if test="${mention.category ne 'RECENT_TREND'}">
                                                        <div class="form-text text-primary mt-2">※ 상한선이 없는 구간(무한대)일 경우 <b>9999</b> 를 입력하세요.</div>
                                                    </c:if>
                                                </div>
                                                <div class="col-md-4">
                                                    <label class="required form-label fs-6 fw-bold">우선순위</label>
                                                    <input type="number" name="priority" class="form-control" value="${mention.priority}" required />
                                                    <div class="form-text mt-2">숫자가 클수록 우선순위가 높습니다. (기본값: 0)</div>
                                                </div>
                                            </div>

                                            <div class="mb-8">
                                                <label class="required form-label fs-6 fw-bold">사용자 노출 멘트</label>
                                                <textarea name="message" class="form-control" rows="4" required placeholder="사용자에게 보여질 실제 안내 멘트를 작성해주세요.">${mention.message}</textarea>
                                            </div>

                                            <div class="mb-8">
                                                <label class="form-label fs-6 fw-bold">관리자 메모 (설명)</label>
                                                <input type="text" name="description" class="form-control" value="${mention.description}" placeholder="어떤 조건일 때 보여지는 멘트인지 관리자용 메모를 남겨주세요." />
                                            </div>

                                        </form>
                                    </div>
                                    <div class="card-footer d-flex justify-content-end py-6 border-0">
                                        <a href="/mng/winyo/mentions" class="btn btn-light me-3">목록으로</a>
                                        <button type="button" class="btn btn-primary" onclick="saveMention()">
                                            <span class="indicator-label">수정 내용 저장</span>
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

    <script src="/assets/plugins/global/plugins.bundle.js"></script>
    <script src="/assets/js/scripts.bundle.js"></script>
    <script>
        function saveMention() {
            const $form = $('#mentionForm');

            if(!$('input[name=levelName]').val().trim()) { alert('레벨 명을 입력해주세요.'); return; }
            if(!$('input[name=priority]').val().trim()) { alert('우선순위를 입력해주세요.'); return; }
            if(!$('textarea[name=message]').val().trim()) { alert('사용자 노출 멘트를 입력해주세요.'); return; }

            if(confirm('이 설정으로 멘트를 수정하시겠습니까?')) {
                $.post('/mng/winyo/mention/update', $form.serialize(), function(res) {
                    if(res === 'ok') {
                        alert('정상적으로 수정되었습니다.');
                        location.href = '/mng/winyo/mentions';
                    } else {
                        alert('서버 처리 중 오류가 발생했습니다.');
                    }
                });
            }
        }
    </script>
</body>
</html>