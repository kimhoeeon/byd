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

    <title>경기 데이터 관리 | 승요일기 관리자</title>
    <link href="/assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/assets/css/style.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/css/mngStyle.css" rel="stylesheet">

    <style>
        /* 1. 모바일 환경 (기본 설정): 화면이 작으므로 여백을 적당히 줍니다. */
        #kt_scrolltop {
            bottom: 20px !important;
            right: 20px !important;
            z-index: 105; /* 다른 팝업이나 메뉴에 가려지지 않도록 최상단 배치 */
        }

        /* 2. 데스크톱/태블릿 환경 (가로 768px 이상): 화면이 크므로 넉넉하게 띄웁니다. */
        @media (min-width: 768px) {
            #kt_scrolltop {
                bottom: 40px !important;
                right: 40px !important;
            }
        }
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
                                        경기 데이터 관리
                                    </h1>

                                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0 pt-1">
                                        <li class="breadcrumb-item text-muted">
                                            <a href="/mng/main.do" class="text-muted text-hover-primary">Home</a>
                                        </li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-muted">운영 관리</li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-dark">경기 데이터 관리</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="alert alert-dismissible bg-light-warning border border-warning border-dashed d-flex flex-column flex-sm-row w-100 p-5 mb-7">
                                    <i class="ki-duotone ki-information-5 fs-2hx text-warning me-4 mb-5 mb-sm-0"><span class="path1"></span><span class="path2"></span><span class="path3"></span></i>
                                    <div class="d-flex flex-column pe-0 pe-sm-10">
                                        <h5 class="mb-1">🚨 수동 등록 경기 운영 주의사항</h5>
                                        <span>관리자가 <strong>수동으로 등록한 경기는 API 실시간 스코어 연동 및 상태 변경(진행중, 종료 등)이 자동으로 이루어지지 않습니다.</strong><br>
                                            수동 등록 경기의 점수와 상태는 반드시 관리자가 직접 수정해 주셔야 합니다.</span>
                                    </div>
                                </div>

                                <div class="card mb-7">
                                    <div class="card-body py-4 d-flex justify-content-between align-items-center">
                                        <form action="/mng/game/list" method="get" class="d-flex align-items-center">
                                            <input type="month" class="form-control form-control-solid w-150px me-3" name="ym" value="${ym}">
                                            <button type="submit" class="btn btn-primary me-2">조회</button>
                                            <button type="button" class="btn btn-light-info" onclick="scrollToToday()">오늘로 이동</button>
                                        </form>
                                        <div>
                                            <button type="button" class="btn btn-light-success me-2" onclick="syncData('MONTH')">
                                                <i class="ki-duotone ki-calendar-8 fs-2">
                                                    <span class="path1"></span>
                                                    <span class="path2"></span>
                                                    <span class="path3"></span>
                                                    <span class="path4"></span>
                                                    <span class="path5"></span>
                                                    <span class="path6"></span>
                                                </i> 월간 동기화
                                            </button>
                                            <button type="button" class="btn btn-light-primary me-2" onclick="syncData('YEAR')">
                                                <i class="ki-duotone ki-calendar fs-2">
                                                    <span class="path1"></span>
                                                    <span class="path2"></span>
                                                </i> 연간 동기화
                                            </button>
                                            <button type="button" class="btn btn-primary" onclick="openModal()">
                                                <i class="ki-duotone ki-plus fs-2"></i> 수동 등록
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <div class="card">
                                    <div class="card-body py-4">
                                        <div class="table-responsive">
                                            <table class="table align-middle table-row-dashed fs-6 gy-5">
                                                <thead>
                                                <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                                    <th class="w-50px text-center">No.</th>
                                                    <th class="min-w-80px text-center">상태</th>
                                                    <th class="min-w-100px text-center">구분</th>
                                                    <th class="min-w-100px text-center">경기결과</th>
                                                    <th class="min-w-150px text-center">대진 (원정 vs 홈)</th>
                                                    <th class="min-w-100px text-center">날짜/시간</th>
                                                    <th class="min-w-100px text-center">승리투수</th>
                                                    <th class="min-w-100px text-center">점수</th>
                                                    <th class="min-w-50px text-center">경기장소</th>
                                                    <th class="min-w-125px text-center">직관 일기 작성 수</th>
                                                    <th class="min-w-80px text-center">관리</th>
                                                </tr>
                                                </thead>
                                                <tbody class="text-gray-600 fw-semibold">
                                                <c:choose>
                                                    <c:when test="${empty list}">
                                                        <tr>
                                                            <td colspan="11" class="text-center py-10">경기 일정이 없습니다.</td>
                                                        </tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="item" items="${list}" varStatus="status">
                                                            <tr data-date="${item.gameDate}">
                                                                <td class="text-center">${status.count}</td>

                                                                <td class="text-center">
                                                                    <c:choose>
                                                                        <c:when test="${item.status eq 'FINISHED'}">
                                                                            <span class="badge badge-light-dark">종료</span>
                                                                        </c:when>
                                                                        <c:when test="${item.status eq 'LIVE'}">
                                                                            <span class="badge badge-light-primary">진행중</span>
                                                                        </c:when>
                                                                        <c:when test="${item.status eq 'CANCELLED' and fn:contains(item.cancelReason, '우천')}">
                                                                            <span class="badge badge-light-warning">우천취소</span>
                                                                        </c:when>
                                                                        <c:when test="${item.status eq 'CANCELLED'}">
                                                                            <span class="badge badge-light-danger">취소</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge badge-light-success">예정</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>

                                                                <td class="text-center">
                                                                    <c:choose>
                                                                        <c:when test="${item.dataSource eq 'API'}">
                                                                            <span class="badge badge-outline badge-primary">자동 연동</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge badge-outline badge-warning" data-bs-toggle="tooltip" data-bs-placement="top" title="수동 등록된 경기는 자동 스코어 업데이트가 지원되지 않습니다.">수동 등록</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>

                                                                <td class="text-center">
                                                                    <c:choose>
                                                                        <c:when test="${item.status eq 'FINISHED'}">
                                                                            <c:choose>
                                                                                <c:when test="${item.winningTeam eq 'DRAW'}">
                                                                                    <span class="badge badge-light-secondary">무승부</span>
                                                                                </c:when>
                                                                                <c:when test="${item.winningTeam eq item.homeTeamCode}">
                                                                                    <span class="badge badge-light-info fw-bold">${item.homeTeamName} 승</span>
                                                                                </c:when>
                                                                                <c:when test="${item.winningTeam eq item.awayTeamCode}">
                                                                                    <span class="badge badge-light-info fw-bold">${item.awayTeamName} 승</span>
                                                                                </c:when>
                                                                                <c:otherwise>-</c:otherwise>
                                                                            </c:choose>
                                                                        </c:when>
                                                                        <c:otherwise>-</c:otherwise>
                                                                    </c:choose>
                                                                </td>

                                                                <td class="text-center">
                                                                    <span class="text-danger fw-bold fs-6">${item.awayTeamName}</span>
                                                                    <span class="text-gray-400 mx-2 fs-8">vs</span>
                                                                    <span class="text-primary fw-bold fs-6">${item.homeTeamName}</span>
                                                                </td>

                                                                <td class="text-center">
                                                                    <div class="text-gray-800 fw-bold">${item.gameDate}</div>
                                                                    <div class="text-gray-500 fs-8">${item.gameTime}</div>
                                                                </td>

                                                                <td class="text-center fw-bold text-gray-800">
                                                                        ${empty item.mvpPlayer ? '-' : item.mvpPlayer}
                                                                </td>

                                                                <td class="text-center">
                                                                    <c:choose>
                                                                        <c:when test="${item.status eq 'SCHEDULED' or item.status eq 'CANCELLED'}">
                                                                            <span class="text-muted">-</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="fs-4 fw-bolder text-dark">${item.scoreAway} : ${item.scoreHome}</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>

                                                                <td class="text-center">${empty item.stadiumName ? '-' : item.stadiumName}</td>

                                                                <td class="text-center">
                                                                    <span class="fw-bold text-gray-800">${item.diaryCount}</span><span class="fs-8 text-muted fw-normal ms-1">건</span>
                                                                </td>

                                                                <td class="text-center">
                                                                    <button class="btn btn-icon btn-bg-light btn-active-color-primary btn-sm me-1" onclick="editGame('${item.gameId}')">
                                                                        <i class="ki-duotone ki-pencil fs-2">
                                                                            <span class="path1"></span>
                                                                            <span class="path2"></span>
                                                                        </i>
                                                                    </button>
                                                                    <button class="btn btn-icon btn-bg-light btn-active-color-danger btn-sm" onclick="deleteGame('${item.gameId}')">
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
                                                    </c:otherwise>
                                                </c:choose>
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

    <div class="modal fade" id="gameModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered mw-650px">
            <div class="modal-content">
                <form id="gameForm" method="post">
                    <input type="hidden" name="gameId" id="gameId">
                    <input type="hidden" name="dataSource" id="dataSource" value="MANUAL"> <div class="modal-header">
                    <h2 class="fw-bold" id="modalTitle">경기 등록</h2>
                    <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                        <i class="ki-duotone ki-cross fs-1">
                            <span class="path1"></span>
                            <span class="path2"></span>
                        </i>
                    </div>
                </div>
                    <div class="modal-body py-10 px-lg-17">
                        <div class="row mb-5">
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">경기 날짜</label>
                                <input type="date" class="form-control form-control-solid" name="gameDate" id="gameDate" required/>
                            </div>
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">경기 시간</label>
                                <input type="time" class="form-control form-control-solid" name="gameTime" id="gameTime" required/>
                            </div>
                        </div>
                        <div class="row mb-5">
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">원정 팀 (Away)</label>
                                <select class="form-select form-select-solid" name="awayTeamCode" id="awayTeamCode">
                                    <option value="LG">LG</option>
                                    <option value="HANWHA">한화</option>
                                    <option value="SSG">SSG</option>
                                    <option value="SAMSUNG">삼성</option>
                                    <option value="NC">NC</option>
                                    <option value="KT">KT</option>
                                    <option value="LOTTE">롯데</option>
                                    <option value="KIA">KIA</option>
                                    <option value="DOOSAN">두산</option>
                                    <option value="KIWOOM">키움</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">홈 팀 (Home)</label>
                                <select class="form-select form-select-solid" name="homeTeamCode" id="homeTeamCode">
                                    <option value="LG">LG</option>
                                    <option value="HANWHA">한화</option>
                                    <option value="SSG">SSG</option>
                                    <option value="SAMSUNG">삼성</option>
                                    <option value="NC">NC</option>
                                    <option value="KT">KT</option>
                                    <option value="LOTTE">롯데</option>
                                    <option value="KIA">KIA</option>
                                    <option value="DOOSAN">두산</option>
                                    <option value="KIWOOM">키움</option>
                                </select>
                            </div>
                        </div>
                        <div class="row mb-5">
                            <div class="col-md-6">
                                <label class="fs-6 fw-semibold mb-2">원정 점수</label>
                                <input type="number" class="form-control form-control-solid" name="scoreAway" id="scoreAway" value="0"/>
                            </div>
                            <div class="col-md-6">
                                <label class="fs-6 fw-semibold mb-2">홈 점수</label>
                                <input type="number" class="form-control form-control-solid" name="scoreHome" id="scoreHome" value="0"/>
                            </div>
                        </div>
                        <div class="row mb-5">
                            <div class="col-md-6">
                                <label class="fs-6 fw-semibold mb-2">상태</label>
                                <select class="form-select form-select-solid" name="status" id="status">
                                    <option value="SCHEDULED">예정</option>
                                    <option value="LIVE">진행중</option>
                                    <option value="FINISHED">종료</option>
                                    <option value="CANCELLED">취소</option>
                                    <option value="RAIN">우천취소</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="fs-6 fw-semibold mb-2">구장</label>
                                <select class="form-select form-select-solid" name="stadiumId" id="stadiumId">
                                    <option value="">구장 선택</option>
                                    <c:forEach var="stadium" items="${stadiums}">
                                        <option value="${stadium.stadiumId}">${stadium.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label for="awayStarter" class="form-label">원정 선발투수</label>
                                <input type="text" class="form-control form-control-solid" id="awayStarter" name="awayStarter">
                            </div>
                            <div class="col-md-4">
                                <label for="homeStarter" class="form-label">홈 선발투수</label>
                                <input type="text" class="form-control form-control-solid" id="homeStarter" name="homeStarter">
                            </div>
                            <div class="col-md-4">
                                <label for="mvpPlayer" class="form-label text-primary">수훈선수 (히어로)</label>
                                <input type="text" class="form-control form-control-solid" id="mvpPlayer" name="mvpPlayer" placeholder="예: 김도영">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="cancelReason" class="form-label">취소 사유</label>
                            <input type="text" class="form-control" id="cancelReason" name="cancelReason" placeholder="예: 우천취소, 미세먼지 등">
                        </div>
                        <div class="fv-row">
                            <label class="fs-6 fw-semibold mb-2">비고 (사유 등)</label>
                            <input type="text" class="form-control form-control-solid" name="etcInfo" id="etcInfo"/>
                        </div>
                    </div>
                    <div class="modal-footer flex-center">
                        <button type="button" class="btn btn-light me-3" data-bs-dismiss="modal">취소</button>
                        <button type="button" class="btn btn-primary" onclick="saveGameAction()">저장</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div id="kt_scrolltop" class="scrolltop" data-kt-scrolltop="true">
        <i class="ki-duotone ki-arrow-up">
            <span class="path1"></span>
            <span class="path2"></span>
        </i>
    </div>

    <script src="/assets/plugins/global/plugins.bundle.js"></script>
    <script src="/assets/js/scripts.bundle.js"></script>
    <script>
        const modal = new bootstrap.Modal(document.getElementById('gameModal'));

        function openModal() {
            document.getElementById('gameForm').reset();
            document.getElementById('gameId').value = '';
            document.getElementById('dataSource').value = 'MANUAL'; // 신규 수동 등록
            document.getElementById('modalTitle').innerText = '경기 수동 등록';
            modal.show();
        }

        function editGame(id) {
            fetch('/mng/game/get?gameId=' + id)
                .then(res => res.json())
                .then(data => {
                    document.getElementById('gameId').value = data.gameId;
                    document.getElementById('dataSource').value = data.dataSource || 'MANUAL'; // 기존 값 유지
                    document.getElementById('gameDate').value = data.gameDate;
                    document.getElementById('gameTime').value = data.gameTime;
                    document.getElementById('awayTeamCode').value = data.awayTeamCode;
                    document.getElementById('homeTeamCode').value = data.homeTeamCode;
                    document.getElementById('stadiumId').value = data.stadiumId;

                    let statusValue = data.status;
                    if (data.status === 'CANCELLED' && data.cancelReason && data.cancelReason.includes('우천')) {
                        statusValue = 'RAIN';
                    }
                    document.getElementById('status').value = statusValue;

                    document.getElementById('scoreAway').value = data.scoreAway;
                    document.getElementById('scoreHome').value = data.scoreHome;
                    document.getElementById('etcInfo').value = data.etcInfo;
                    document.getElementById('homeStarter').value = data.homeStarter || '';
                    document.getElementById('awayStarter').value = data.awayStarter || '';
                    document.getElementById('mvpPlayer').value = data.mvpPlayer || '';
                    document.getElementById('cancelReason').value = data.cancelReason || '';

                    // 팝업 타이틀 동적 변경 (API인지 수동인지 알려줌)
                    document.getElementById('modalTitle').innerText = (data.dataSource === 'API') ? '경기 수정 (자동 연동)' : '경기 수정 (수동 등록)';

                    modal.show();
                });
        }

        function deleteGame(id) {
            if (confirm('삭제하시겠습니까?')) {
                $.post('/mng/game/delete', {gameId: id}, function (res) {
                    if (res === 'ok') location.reload();
                });
            }
        }

        function syncData(type) {
            // 1. 현재 선택된 '년-월' 값 가져오기 (예: 2026-05)
            const ym = document.querySelector('input[name="ym"]').value;

            if (!ym) {
                alert('날짜를 선택해 주세요.');
                return;
            }

            // 2. 연도와 월 추출
            const parts = ym.split('-');
            const year = parts[0];  // 2026
            const month = parts[1]; // 05

            let url = '';
            let confirmMsg = '';
            let postData = {};

            // 3. 타입별 로직 분기
            if (type === 'MONTH') {
                // [월간] 해당 월만 동기화
                url = '/mng/game/syncMonthly';
                confirmMsg = year + '년 ' + month + '월 경기 데이터를 동기화하시겠습니까?\n(해당 월의 데이터만 갱신됩니다)';
                postData = { year: year, month: month };

            } else {
                // [연간] 해당 연도 전체 동기화
                url = '/mng/game/syncYearly';
                confirmMsg = year + '년도 전체 경기 데이터를 API와 동기화하시겠습니까?\n(기존 데이터가 갱신될 수 있습니다)';
                postData = { year: year };
            }

            // 3. 사용자 확인 및 AJAX 요청 전송
            if (confirm(confirmMsg)) {
                $.post(url, postData, function (res) {
                    if (res === 'ok') {
                        alert(year + '년도 데이터 동기화가 완료되었습니다.');
                        location.reload(); // 목록 갱신
                    } else {
                        alert('동기화 실패: ' + res);
                    }
                }).fail(function() {
                    alert('서버 통신 중 오류가 발생했습니다.');
                });
            }
        }

        // 경기 저장 (AJAX)
        function saveGameAction() {
            // 1. 유효성 검사
            const gameDate = $('#gameDate').val();
            const gameTime = $('#gameTime').val();
            const stadiumId = $('#stadiumId').val();

            if (!gameDate || !gameTime) {
                alert('경기 날짜와 시간을 입력해주세요.');
                return;
            }

            // 구장 선택 여부 확인
            if (!stadiumId) {
                alert('구장을 선택해주세요.');
                return;
            }

            // 우천취소 선택 시 'cancelReason' 데이터 자동 가공
            const statusVal = $('#status').val();
            let reasonVal = $('#cancelReason').val().trim();

            if (statusVal === 'RAIN') {
                if (reasonVal === '') {
                    // 사유를 안 적었을 경우 기본 텍스트 삽입
                    $('#cancelReason').val('우천취소');
                } else if (!reasonVal.includes('우천')) {
                    // 사유를 적었으나 '우천'이라는 단어가 없을 경우 꼬리말 추가
                    $('#cancelReason').val(reasonVal + ' (우천)');
                }
            }

            // 2. 폼 데이터 생성
            const form = document.getElementById('gameForm');
            const formData = new FormData(form);

            // 3. AJAX 전송
            $.ajax({
                url: '/mng/game/save',
                type: 'POST',
                data: formData,
                contentType: false, // FormData 사용 시 필수
                processData: false, // FormData 사용 시 필수
                success: function(res) {
                    if (res === 'ok') {
                        // 1. 팝업(모달) 먼저 닫기
                        if (typeof modal !== 'undefined') {
                            modal.hide();
                        } else {
                            const myModalEl = document.getElementById('gameModal');
                            const myModal = bootstrap.Modal.getInstance(myModalEl);
                            if (myModal) myModal.hide();
                        }

                        // 2. 커스텀 알림창 띄우고 확인 클릭 시 새로고침
                        alert('저장되었습니다.');
                        location.reload();
                    } else {
                        alert('저장에 실패했습니다.\n' + res);
                    }
                },
                error: function(err) {
                    console.error(err);
                    alert('서버 통신 중 오류가 발생했습니다.');
                }
            });
        }

        function scrollToToday() {
            const today = new Date();
            const year = today.getFullYear();
            const month = String(today.getMonth() + 1).padStart(2, '0');
            const day = String(today.getDate()).padStart(2, '0');
            const todayStr1 = year + '-' + month + '-' + day; // 예: 2026-04-07

            // 순수 자바스크립트로 오늘 날짜가 포함된 행을 찾음
            const targetRows = document.querySelectorAll('tr[data-date*="' + todayStr1 + '"]');

            if (targetRows.length > 0) {
                // 오늘 날짜의 모든 행에 옅은 파란색 하이라이트 적용
                targetRows.forEach(row => {
                    row.style.backgroundColor = '#f0f8ff';
                });

                // 첫 번째 행의 절대 Y 좌표 계산 (스크롤 오프셋 포함)
                const firstRow = targetRows[0];
                const absoluteElementTop = firstRow.getBoundingClientRect().top + window.pageYOffset;

                // 네이티브 부드러운 스크롤 실행 (상단 고정 헤더 높이 150px 보정)
                window.scrollTo({
                    top: absoluteElementTop - 150,
                    behavior: 'smooth'
                });
            } else {
                // 오늘 경기가 목록에 없을 경우 친절하게 안내
                alert('현재 조회된 월에는 오늘 일정이 없습니다.');
            }
        }

        // DOM 로딩 완료 시 실행 (제이쿼리 로딩 타이밍 이슈 방지)
        document.addEventListener('DOMContentLoaded', function() {
            scrollToToday();

            // Bootstrap 툴팁 활성화
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
        });
    </script>
</body>
</html>