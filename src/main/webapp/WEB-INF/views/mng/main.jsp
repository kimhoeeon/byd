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

    <title>관리자 메인 | BYD 관리자</title>
    <link href="/assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/assets/css/style.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/css/mngStyle.css" rel="stylesheet">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body id="kt_app_body" data-kt-app-layout="dark-sidebar" data-kt-app-header-fixed="true"
      data-kt-app-sidebar-enabled="true" data-kt-app-sidebar-fixed="true" class="app-default">

    <div class="d-flex flex-column flex-root app-root">
        <div class="app-page flex-column flex-column-fluid">

            <jsp:include page="/WEB-INF/views/mng/include/header.jsp" />

            <div class="app-wrapper flex-column flex-row-fluid">
                <jsp:include page="/WEB-INF/views/mng/include/sidebar.jsp" />

                <div class="app-main flex-column flex-row-fluid p-10">
                    <div class="row g-5 mb-10">
                        <div class="col-md-3">
                            <div class="card shadow-sm bg-primary p-6">
                                <div class="text-white fw-bold fs-6">누적 신청자 수</div>
                                <div class="text-white fw-bolder fs-2hx mt-2"><fmt:formatNumber value="${stats.totalCnt}" pattern="#,###"/></div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card shadow-sm bg-success p-6">
                                <div class="text-white fw-bold fs-6">금일 신규 신청</div>
                                <div class="text-white fw-bolder fs-2hx mt-2"><fmt:formatNumber value="${stats.todayCnt}" pattern="#,###"/></div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card shadow-sm bg-info p-6">
                                <div class="text-white fw-bold fs-6">QR 현장 확인</div>
                                <div class="text-white fw-bolder fs-2hx mt-2"><fmt:formatNumber value="${stats.qrCheckCnt}" pattern="#,###"/></div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card shadow-sm bg-warning p-6">
                                <div class="text-white fw-bold fs-6">시승 대기</div>
                                <div class="text-white fw-bolder fs-2hx mt-2"><fmt:formatNumber value="${stats.driveWaitCnt}" pattern="#,###"/></div>
                            </div>
                        </div>
                    </div>

                    <div class="row g-5">
                        <div class="col-xl-8">
                            <div class="card shadow-sm border-0 h-100">
                                <div class="card-header align-items-center">
                                    <h3 class="card-title align-items-start flex-column">
                                        <span class="fw-bold text-dark">신청 현황 추이</span>
                                        <span class="text-muted mt-1 fw-semibold fs-7">최근 7일 일별 데이터</span>
                                    </h3>
                                </div>
                                <div class="card-body">
                                    <canvas id="statChart" style="height: 350px;"></canvas>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-4">
                            <div class="card shadow-sm border-0 h-100">
                                <div class="card-header"><h3 class="card-title fw-bold">신청 타입별 비중</h3></div>
                                <div class="card-body d-flex flex-center">
                                    <canvas id="typeDoughnutChart"></canvas>
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
        // JSTL을 활용하여 Java List 배열을 JavaScript 배열 형식으로 출력
        const chartLabels = [
            <c:forEach items="${chartData.labels}" var="label" varStatus="st">
            '${label}'${!st.last ? ',' : ''}
            </c:forEach>
        ];

        const eventDataList = [
            <c:forEach items="${chartData.eventData}" var="d" varStatus="st">
            ${d}${!st.last ? ',' : ''}
            </c:forEach>
        ];

        const driveDataList = [
            <c:forEach items="${chartData.driveData}" var="d" varStatus="st">
            ${d}${!st.last ? ',' : ''}
            </c:forEach>
        ];

        // 1. 통계 차트 (Line Chart - DB 연동)
        const ctx = document.getElementById('statChart').getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: chartLabels,
                datasets: [{
                    label: '일반 참여',
                    data: eventDataList,
                    borderColor: '#009ef7',
                    tension: 0.3,
                    fill: true,
                    backgroundColor: 'rgba(0, 158, 247, 0.1)'
                }, {
                    label: '시승 신청',
                    data: driveDataList,
                    borderColor: '#50cd89',
                    tension: 0.3
                }]
            },
            options: { responsive: true, maintainAspectRatio: false }
        });

        // 2. 타입별 비중 (Doughnut Chart - DB 연동)
        const eventTotal = ${stats.eventCnt};
        const driveTotal = ${stats.driveCnt};

        const ctx2 = document.getElementById('typeDoughnutChart').getContext('2d');
        new Chart(ctx2, {
            type: 'doughnut',
            data: {
                labels: ['이벤트 참여', '시승 신청'],
                datasets: [{
                    data: [eventTotal, driveTotal],
                    backgroundColor: ['#009ef7', '#50cd89']
                }]
            }
        });
    </script>
</body>
</html>