<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- JSTL 대시보드 통계 사전 계산 --%>
<c:set var="totalItems" value="${0}" />
<c:set var="todayTotalOut" value="${0}" />
<c:set var="lowStockItems" value="${0}" />

<c:forEach items="${list}" var="item">
    <c:set var="totalItems" value="${totalItems + 1}" />
    <c:set var="todayTotalOut" value="${todayTotalOut + item.todayOutQty}" />
    <fmt:parseNumber var="rate" value="${item.initQty > 0 ? (item.totalQty / item.initQty) * 100 : 0}" integerOnly="true" />
    <c:if test="${rate <= 20}">
        <c:set var="lowStockItems" value="${lowStockItems + 1}" />
    </c:if>
</c:forEach>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <title>BYD ADMIN | 물자 관리 대시보드</title>
    <link rel="stylesheet" href="/assets/plugins/global/plugins.bundle.css">
    <link rel="stylesheet" href="/assets/css/style.bundle.css">
    <style>
        #kt_app_main {
            background-color: #f5f8fa;
        }

        .pulse-danger {
            animation: pulse-danger 2s infinite;
        }

        @keyframes pulse-danger {
            0% {
                box-shadow: 0 0 0 0 rgba(241, 65, 108, 0.7);
            }
            70% {
                box-shadow: 0 0 0 10px rgba(241, 65, 108, 0);
            }
            100% {
                box-shadow: 0 0 0 0 rgba(241, 65, 108, 0);
            }
        }

        .timeline-label:before {
            left: 88px;
        }

        .table th {
            vertical-align: middle;
        }
    </style>
</head>

<body id="kt_app_body" data-kt-app-layout="dark-sidebar" data-kt-app-header-fixed="true"
      data-kt-app-sidebar-enabled="true" data-kt-app-sidebar-fixed="true" class="app-default">
<div class="d-flex flex-column flex-root app-root">
    <div class="app-page flex-column flex-column-fluid">
        <jsp:include page="/WEB-INF/views/mng/include/header.jsp"/>

        <div class="app-wrapper flex-column flex-row-fluid" id="kt_app_wrapper">
            <jsp:include page="/WEB-INF/views/mng/include/sidebar.jsp"/>

            <div class="app-main flex-column flex-row-fluid" id="kt_app_main">
                <div class="d-flex flex-column flex-column-fluid">

                    <div id="kt_app_content" class="app-content flex-column-fluid mt-8">
                        <div id="kt_app_content_container" class="app-container container-fluid">

                            <div class="row g-5 g-xl-8 mb-8">
                                <div class="col-xl-4">
                                    <div class="card bg-dark hoverable card-xl-stretch mb-xl-8">
                                        <div class="card-body">
                                            <i class="ki-duotone ki-element-11 text-white fs-3x ms-n1">
                                                <span class="path1"></span>
                                                <span class="path2"></span>
                                                <span class="path3"></span>
                                                <span class="path4"></span>
                                            </i>
                                            <div class="text-white fw-bold fs-2 mb-2 mt-5">${totalItems} 개</div>
                                            <div class="fw-semibold text-white">조회된 물자 종류</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xl-4">
                                    <div class="card bg-primary hoverable card-xl-stretch mb-xl-8">
                                        <div class="card-body">
                                            <i class="ki-duotone ki-exit-right-corner text-white fs-3x ms-n1">
                                                <span class="path1"></span>
                                                <span class="path2"></span>
                                            </i>
                                            <div class="text-white fw-bold fs-2 mb-2 mt-5">
                                                <fmt:formatNumber value="${todayTotalOut}" pattern="#,###"/> 개
                                            </div>
                                            <div class="fw-semibold text-white">선택일자(${searchDate}) 총 불출 수량</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xl-4">
                                    <div class="card ${lowStockItems > 0 ? 'bg-danger pulse-danger' : 'bg-success'} hoverable card-xl-stretch mb-5 mb-xl-8">
                                        <div class="card-body">
                                            <i class="ki-duotone ki-information-5 text-white fs-3x ms-n1">
                                                <span class="path1"></span>
                                                <span class="path2"></span>
                                                <span class="path3"></span>
                                            </i>
                                            <div class="text-white fw-bold fs-2 mb-2 mt-5">${lowStockItems} 건</div>
                                            <div class="fw-semibold text-white">재고 위험 (20% 이하)</div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="card shadow-sm mb-5">
                                <div class="card-header align-items-center py-5">
                                    <form id="searchForm" action="/mng/material/list" method="get" class="d-flex flex-wrap align-items-center gap-3 w-100">
                                        <div class="d-flex align-items-center fw-bold text-gray-700">
                                            <i class="ki-duotone ki-calendar-8 fs-3 me-2">
                                                <span class="path1"></span>
                                                <span class="path2"></span>
                                                <span class="path3"></span>
                                                <span class="path4"></span>
                                                <span class="path5"></span>
                                                <span class="path6"></span>
                                            </i>
                                            행사일자
                                        </div>
                                        <input type="date" name="searchDate" value="${searchDate}" class="form-control form-control-solid w-150px">

                                        <select name="category" class="form-select form-select-solid w-150px">
                                            <option value="">구분 (전체)</option>
                                            <c:forEach items="${categoryList}" var="cat">
                                                <option value="${cat}" ${category == cat ? 'selected' : ''}>${cat}</option>
                                            </c:forEach>
                                        </select>

                                        <select name="stockStatus" class="form-select form-select-solid w-150px">
                                            <option value="">재고상태 (전체)</option>
                                            <option value="SAFE" ${stockStatus == 'SAFE' ? 'selected' : ''}>안전 (50% 초과)</option>
                                            <option value="WARN" ${stockStatus == 'WARN' ? 'selected' : ''}>경고 (20~50%)</option>
                                            <option value="DANGER" ${stockStatus == 'DANGER' ? 'selected' : ''}>위험 (20% 이하)</option>
                                        </select>

                                        <div class="position-relative flex-grow-1 mw-250px">
                                            <i class="ki-duotone ki-magnifier fs-3 position-absolute top-50 translate-middle-y ms-4">
                                                <span class="path1"></span>
                                                <span class="path2"></span>
                                            </i>
                                            <input type="text" name="keyword" value="${keyword}" class="form-control form-control-solid ps-12" placeholder="물자명 검색">
                                        </div>

                                        <button type="submit" class="btn btn-dark">검색</button>
                                        <a href="/mng/material/list" class="btn btn-light">초기화</a>
                                    </form>
                                </div>
                            </div>

                            <div class="card shadow-sm">
                                <div class="card-header align-items-center py-5">
                                    <h3 class="card-title fw-bold text-gray-800">물자 현황 목록</h3>
                                    <div class="card-toolbar">
                                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalAddMaterial">
                                            <i class="ki-duotone ki-plus fs-2"></i> 신규 물자 등록
                                        </button>
                                    </div>
                                </div>

                                <div class="card-body py-4">
                                    <div class="table-responsive">
                                        <table class="table align-middle table-row-dashed fs-6 gy-5 table-hover" id="materialTable">
                                            <thead>
                                                <tr class="text-center text-gray-500 fw-bold fs-7 text-uppercase gs-0 bg-light">
                                                    <th class="w-50px">No.</th>
                                                    <th class="min-w-100px text-start">구분</th>
                                                    <th class="min-w-150px text-start">물자명</th>
                                                    <th class="min-w-100px">사전 세팅 수량</th>
                                                    <th class="min-w-100px text-danger">금일<br>불출 수량</th>
                                                    <th class="min-w-100px text-primary">자동 계산<br>잔여 수량</th>
                                                    <th class="min-w-100px">최종 재고</th>
                                                    <th class="min-w-150px text-start">메모</th>
                                                    <th class="min-w-200px">메뉴</th>
                                                </tr>
                                            </thead>
                                            <tbody class="fw-semibold text-gray-600">
                                                <c:if test="${empty list}">
                                                    <tr>
                                                        <td colspan="9" class="text-center py-10">등록된 물자가 없습니다.</td>
                                                    </tr>
                                                </c:if>

                                                <c:forEach items="${list}" var="item" varStatus="st">
                                                    <fmt:parseNumber var="rate" value="${item.initQty > 0 ? (item.totalQty / item.initQty) * 100 : 0}" integerOnly="true"/>
                                                    <c:set var="isDanger" value="${rate <= 20}"/>

                                                    <tr class="text-center">
                                                        <td>${item.seq}</td>
                                                        <td class="text-start">
                                                            <span class="badge badge-light-dark fs-7">${item.category}</span>
                                                        </td>
                                                        <td class="text-start">
                                                            <div class="d-flex justify-content-between align-items-center mb-1">
                                                                <div class="text-dark fw-bold fs-5">${item.materialName}</div>
                                                                <div class="fs-8 fw-bold ${isDanger ? 'text-danger' : 'text-muted'}">${rate}%</div>
                                                            </div>
                                                            <div class="h-4px w-100 bg-light rounded">
                                                                <div class="${isDanger ? 'bg-danger pulse-danger' : (rate <= 50 ? 'bg-warning' : 'bg-success')} rounded h-4px" style="width: ${rate}%;"></div>
                                                            </div>
                                                        </td>
                                                        <td class="fw-bold text-muted">
                                                            <fmt:formatNumber value="${item.initQty}" pattern="#,###"/>
                                                        </td>
                                                        <td class="fw-bold text-danger">
                                                            <fmt:formatNumber value="${item.todayOutQty}" pattern="#,###"/>
                                                        </td>
                                                        <td class="fw-bolder fs-5 text-primary">
                                                            <fmt:formatNumber value="${item.totalQty}" pattern="#,###"/>
                                                        </td>
                                                        <td class="fw-bold text-dark">
                                                            <fmt:formatNumber value="${item.totalQty}" pattern="#,###"/>
                                                        </td>
                                                        <td class="text-start text-muted fs-8">
                                                            ${empty item.memo ? '-' : item.memo}
                                                        </td>
                                                        <td>
                                                            <button class="btn btn-sm btn-light-primary px-3 py-2 me-1" onclick="openInOutModal(${item.seq}, '${item.materialName}', ${item.totalQty})">
                                                                입/출고
                                                            </button>
                                                            <button class="btn btn-sm btn-light-info px-3 py-2 me-1" onclick="openHistoryModal(${item.seq}, '${item.materialName}')">
                                                                이력
                                                            </button>
                                                            <button class="btn btn-sm btn-icon btn-light-danger h-30px w-30px" onclick="deleteMaterial(${item.seq})">
                                                                <i class="ki-duotone ki-trash fs-5">
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

<div class="modal fade" id="modalAddMaterial" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered mw-500px">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="fw-bold">신규 현장 물자 등록</h2>
                <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                    <i class="ki-duotone ki-cross fs-1">
                        <span class="path1"></span>
                        <span class="path2"></span>
                    </i>
                </div>
            </div>
            <form id="formAddMaterial">
                <div class="modal-body py-10 px-lg-17">

                    <div class="d-flex flex-column mb-5 fv-row">
                        <label class="required fs-5 fw-semibold mb-2">물자 구분 (카테고리)</label>
                        <div class="d-flex gap-2">
                            <select id="categorySelect" class="form-select form-select-solid w-150px" onchange="toggleCategory()">
                                <option value="">직접 입력</option>
                                <c:forEach items="${categoryList}" var="cat">
                                    <option value="${cat}">${cat}</option>
                                </c:forEach>
                            </select>
                            <input type="text" class="form-control form-control-solid" id="categoryInput" name="category" placeholder="새 구분 입력" required>
                        </div>
                    </div>

                    <div class="d-flex flex-column mb-5 fv-row">
                        <label class="required fs-5 fw-semibold mb-2">물자명</label>
                        <input type="text" class="form-control form-control-solid" placeholder="예: 생수, 카탈로그, 부채" name="materialName" required/>
                    </div>
                    <div class="d-flex flex-column mb-5 fv-row">
                        <label class="required fs-5 fw-semibold mb-2">사전 세팅 수량 (초기수량)</label>
                        <input type="number" class="form-control form-control-solid" placeholder="0" name="initQty" required min="0"/>
                    </div>
                    <div class="d-flex flex-column mb-5 fv-row">
                        <label class="fs-5 fw-semibold mb-2">비고 (메모)</label>
                        <textarea class="form-control form-control-solid" rows="3" name="memo" placeholder="선택사항"></textarea>
                    </div>
                </div>
                <div class="modal-footer flex-center">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-primary" onclick="submitAddMaterial()">등록하기</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="modalInOut" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered mw-500px">
        <div class="modal-content">
            <div class="modal-header bg-light">
                <h2 class="fw-bold" id="inoutModalTitle">물자 입출고</h2>
                <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                    <i class="ki-duotone ki-cross fs-1">
                        <span class="path1"></span>
                        <span class="path2"></span>
                    </i>
                </div>
            </div>
            <form id="formInOut">
                <input type="hidden" name="materialSeq" id="inoutMaterialSeq">
                <div class="modal-body py-10 px-lg-17">
                    <div class="notice d-flex bg-light-primary rounded border-primary border border-dashed p-4 mb-8">
                        <div class="d-flex flex-stack flex-grow-1">
                            <div class="fw-semibold">
                                <h4 class="text-gray-900 fw-bold">현재 잔여 수량</h4>
                                <div class="fs-6 text-gray-700" id="inoutCurrentQtyText">0 개</div>
                            </div>
                        </div>
                    </div>

                    <div class="mb-5">
                        <label class="required fs-5 fw-semibold mb-2">작업 분류</label>
                        <div class="d-flex gap-5">
                            <div class="form-check form-check-custom form-check-solid form-check-success flex-fill">
                                <input class="form-check-input" type="radio" name="changeType" value="IN" id="typeIn" checked/>
                                <label class="form-check-label fw-bold text-dark w-100 text-center py-3 border rounded" for="typeIn">
                                    <i class="ki-duotone ki-entrance-left fs-2 me-2 text-success">
                                        <span class="path1"></span>
                                        <span class="path2"></span>
                                    </i> 입고 (+)
                                </label>
                            </div>
                            <div class="form-check form-check-custom form-check-solid form-check-danger flex-fill">
                                <input class="form-check-input" type="radio" name="changeType" value="OUT" id="typeOut"/>
                                <label class="form-check-label fw-bold text-dark w-100 text-center py-3 border rounded" for="typeOut">
                                    <i class="ki-duotone ki-exit-right-corner fs-2 me-2 text-danger">
                                        <span class="path1"></span>
                                        <span class="path2"></span>
                                    </i> 출고 (-)
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex flex-column mb-5 fv-row">
                        <label class="required fs-5 fw-semibold mb-2">변동 수량</label>
                        <input type="number"
                               class="form-control form-control-solid form-control-lg text-center fw-bold fs-3"
                               name="changeQty" id="inoutQty" required min="1" value="1"/>
                        <div class="text-muted fs-7 mt-2" id="inoutWarning" style="display:none; color:#f1416c !important;">
                            * 현재 잔여 수량보다 많이 출고할 수 없습니다.
                        </div>
                    </div>

                    <div class="d-flex flex-column mb-5 fv-row">
                        <label class="fs-5 fw-semibold mb-2">작업 사유 (메모)</label>
                        <input type="text" class="form-control form-control-solid" placeholder="선택사항 (예: 추가 지원, 파손 폐기)" name="reason"/>
                    </div>
                </div>
                <div class="modal-footer flex-center">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-primary" id="btnSubmitInOut" onclick="submitInOut()">적용하기</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="modalHistory" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable mw-600px">
        <div class="modal-content">
            <div class="modal-header bg-light">
                <h2 class="fw-bold" id="historyModalTitle">타임라인 이력</h2>
                <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                    <i class="ki-duotone ki-cross fs-1">
                        <span class="path1"></span>
                        <span class="path2"></span>
                    </i>
                </div>
            </div>
            <div class="modal-body py-10" style="min-height: 400px;">
                <div class="timeline-label" id="historyTimeline"></div>
            </div>
        </div>
    </div>
</div>

<script src="/assets/plugins/global/plugins.bundle.js"></script>
<script src="/assets/js/scripts.bundle.js"></script>

<script>
    const Toast = Swal.mixin({
        toast: true, position: 'top-end', showConfirmButton: false, timer: 3000, timerProgressBar: true,
        didOpen: (toast) => {
            toast.addEventListener('mouseenter', Swal.stopTimer);
            toast.addEventListener('mouseleave', Swal.resumeTimer);
        }
    });

    // 신규 등록 팝업: 구분(카테고리) 콤보박스 제어
    function toggleCategory() {
        var val = $('#categorySelect').val();
        if (val === '') {
            $('#categoryInput').val('').prop('readonly', false).focus();
        } else {
            $('#categoryInput').val(val).prop('readonly', true);
        }
    }

    function submitAddMaterial() {
        const form = document.getElementById('formAddMaterial');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        $.ajax({
            url: '/mng/material/api/add', type: 'POST', data: $(form).serialize(),
            success: function (res) {
                if (res.success) {
                    Swal.fire({
                        text: res.message,
                        icon: "success",
                        buttonsStyling: false,
                        confirmButtonText: "확인",
                        customClass: {confirmButton: "btn btn-primary"}
                    }).then(function () {
                        location.reload();
                    });
                } else {
                    Swal.fire({
                        text: res.message,
                        icon: "error",
                        buttonsStyling: false,
                        confirmButtonText: "확인",
                        customClass: {confirmButton: "btn btn-danger"}
                    });
                }
            }
        });
    }

    let g_currentTotalQty = 0;

    function openInOutModal(seq, name, totalQty) {
        $('#inoutMaterialSeq').val(seq);
        $('#inoutModalTitle').text('[' + name + '] 입/출고 관리');
        $('#inoutCurrentQtyText').text(totalQty.toLocaleString() + ' 개');
        $('#formInOut')[0].reset();
        g_currentTotalQty = totalQty;
        checkQtyWarning();
        $('#modalInOut').modal('show');
    }

    $('input[name="changeType"], #inoutQty').on('change keyup', checkQtyWarning);

    function checkQtyWarning() {
        const isOut = $('#typeOut').is(':checked');
        const qty = parseInt($('#inoutQty').val()) || 0;

        if (isOut && qty > g_currentTotalQty) {
            $('#inoutWarning').slideDown(200);
            $('#btnSubmitInOut').prop('disabled', true);
        } else {
            $('#inoutWarning').slideUp(200);
            $('#btnSubmitInOut').prop('disabled', false);
        }
    }

    function submitInOut() {
        const form = document.getElementById('formInOut');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        $.ajax({
            url: '/mng/material/api/inout', type: 'POST', data: $(form).serialize(),
            success: function (res) {
                if (res.success) {
                    Toast.fire({icon: 'success', title: res.message});
                    setTimeout(() => location.reload(), 1500);
                } else {
                    Swal.fire({
                        text: res.message,
                        icon: "error",
                        buttonsStyling: false,
                        confirmButtonText: "확인",
                        customClass: {confirmButton: "btn btn-danger"}
                    });
                }
            }
        });
    }

    function openHistoryModal(seq, name) {
        $('#historyModalTitle').text('[' + name + '] 타임라인 이력');
        $('#historyTimeline').html('<div class="text-center text-muted py-10">데이터를 불러오는 중입니다...</div>');
        $('#modalHistory').modal('show');

        $.ajax({
            url: '/mng/material/api/history?materialSeq=' + seq,
            type: 'GET',
            success: function (list) {
                let html = '';
                if (list.length === 0) {
                    html = '<div class="text-center text-muted py-10">입출고 이력이 없습니다.</div>';
                } else {
                    list.forEach(function (item) {
                        const d = new Date(item.regDate);
                        const timeStr = ('0' + (d.getMonth() + 1)).slice(-2) + '/' + ('0' + d.getDate()).slice(-2) + ' ' + ('0' + d.getHours()).slice(-2) + ':' + ('0' + d.getMinutes()).slice(-2);

                        const isIn = item.changeType === 'IN';
                        const badgeColor = isIn ? 'badge-light-success' : 'badge-light-danger';
                        const textColor = isIn ? 'text-success' : 'text-danger';
                        const sign = isIn ? '+' : '-';
                        const icon = isIn ? 'ki-entrance-left' : 'ki-exit-right-corner';
                        const reasonText = item.reason ? item.reason : '(사유 미입력)'; // 메모가 없을 때의 처리

                        html += `
                            <div class="timeline-item">
                                <div class="timeline-label fw-bold text-gray-800 fs-7" style="width: 85px;">\${timeStr}</div>
                                <div class="timeline-badge">
                                    <i class="ki-duotone ki-abstract-8 \${textColor} fs-2">
                                        <span class="path1"></span><span class="path2"></span>
                                    </i>
                                </div>
                                <div class="timeline-content d-flex">
                                    <span class="fw-bold text-gray-800 ps-3">\${reasonText}</span>
                                </div>
                                <div class="timeline-content text-end">
                                    <span class="badge \${badgeColor} fs-6 fw-bold px-3 py-2">
                                        <i class="ki-duotone \${icon} fs-5 \${textColor} me-1"><span class="path1"></span><span class="path2"></span></i>
                                        \${sign}\${item.changeQty}
                                    </span>
                                    <div class="text-muted fs-8 mt-1">\${item.adminId}</div>
                                </div>
                            </div>
                        `;
                    });
                }
                $('#historyTimeline').html(html);
            }
        });
    }

    function deleteMaterial(seq) {
        Swal.fire({
            text: "정말 이 물자를 삭제하시겠습니까?\\n(입출고 이력도 함께 보이지 않게 됩니다)",
            icon: "warning", showCancelButton: true, buttonsStyling: false,
            confirmButtonText: "예, 삭제합니다", cancelButtonText: "아니요",
            customClass: {confirmButton: "btn btn-danger", cancelButton: "btn btn-light"}
        }).then(function (result) {
            if (result.isConfirmed) {
                $.ajax({
                    url: '/mng/material/api/delete', type: 'POST', data: {seq: seq},
                    success: function (res) {
                        if (res.success) {
                            Toast.fire({icon: 'success', title: '삭제가 완료되었습니다.'});
                            setTimeout(() => location.reload(), 1500);
                        } else {
                            Swal.fire({
                                text: res.message,
                                icon: "error",
                                buttonsStyling: false,
                                confirmButtonText: "확인",
                                customClass: {confirmButton: "btn btn-danger"}
                            });
                        }
                    }
                });
            }
        });
    }
</script>
</body>
</html>