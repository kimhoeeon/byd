<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="robots" content="noindex, nofollow">
    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />

    <title>BYD ADMIN | 메인대시보드</title>

    <link href="/assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/assets/css/style.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/css/mngStyle.css" rel="stylesheet">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        #kt_app_main { background-color: #f5f8fa; }
        .summary-card { color: white; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .bg-card-1 { background-color: #009ef7; }
        .bg-card-2 { background-color: #50cd89; }
        .bg-card-3 { background-color: #7239ea; }
        .bg-card-4 { background-color: #f1416c; }
    </style>
</head>
<body id="kt_app_body" data-kt-app-layout="dark-sidebar" data-kt-app-header-fixed="true" data-kt-app-sidebar-enabled="true" data-kt-app-sidebar-fixed="true" class="app-default">

<!-- 레이아웃 붕괴 방지를 위해 id 필수 적용 (kt_app_root) -->
<div class="d-flex flex-column flex-root app-root" id="kt_app_root">

    <!-- id 필수 적용 (kt_app_page) -->
    <div class="app-page flex-column flex-column-fluid" id="kt_app_page">

        <jsp:include page="/WEB-INF/views/mng/include/header.jsp" />

        <!-- id 필수 적용 (kt_app_wrapper) -->
        <div class="app-wrapper flex-column flex-row-fluid" id="kt_app_wrapper">

            <jsp:include page="/WEB-INF/views/mng/include/sidebar.jsp" />

            <!-- id 필수 적용 (kt_app_main) -->
            <div class="app-main flex-column flex-row-fluid" id="kt_app_main">

                <!-- 컨텐츠 내부를 감싸는 Flex Fluid 컨테이너 추가 -->
                <div class="d-flex flex-column flex-column-fluid p-10">

                    <!-- 최상단 요약 카드 -->
                    <div class="row g-5 mb-7">
                        <div class="col-md-3">
                            <div class="card summary-card bg-card-1 p-6">
                                <div class="fw-bold fs-6 opacity-75">누적 신청자 수</div>
                                <div class="fw-bolder fs-2hx mt-2"><fmt:formatNumber value="${stats.totalCnt}" pattern="#,###"/></div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card summary-card bg-card-2 p-6">
                                <div class="fw-bold fs-6 opacity-75">금일 신규 신청</div>
                                <div class="fw-bolder fs-2hx mt-2"><fmt:formatNumber value="${stats.todayCnt}" pattern="#,###"/></div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card summary-card bg-card-3 p-6">
                                <div class="fw-bold fs-6 opacity-75">챌린지 도착(확인) 완료</div>
                                <div class="fw-bolder fs-2hx mt-2"><fmt:formatNumber value="${chartData.attStats.challengeCnt}" pattern="#,###"/></div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card summary-card bg-card-4 p-6">
                                <div class="fw-bold fs-6 opacity-75">시승 도착(확인) 완료</div>
                                <div class="fw-bolder fs-2hx mt-2"><fmt:formatNumber value="${chartData.attStats.driveCnt}" pattern="#,###"/></div>
                            </div>
                        </div>
                    </div>

                    <!-- 1열: 날짜별 추이 & 도착 현황 -->
                    <div class="row g-5 mb-7">
                        <div class="col-xl-8">
                            <div class="card shadow-sm border-0 h-100">
                                <div class="card-header align-items-center">
                                    <h3 class="card-title fw-bold text-dark">일별 신청 추이 (최근 7일)</h3>
                                </div>
                                <div class="card-body"><canvas id="dailyChart" style="height: 300px;"></canvas></div>
                            </div>
                        </div>
                        <div class="col-xl-4">
                            <div class="card shadow-sm border-0 h-100">
                                <div class="card-header"><h3 class="card-title fw-bold text-dark">시승 예약자 현장 참석 비율</h3></div>
                                <div class="card-body d-flex flex-center"><canvas id="attChart"></canvas></div>
                            </div>
                        </div>
                    </div>

                    <!-- 2열: 모델 비율 & 시간대별 신청 -->
                    <div class="row g-5 mb-7">
                        <div class="col-xl-4">
                            <div class="card shadow-sm border-0 h-100">
                                <div class="card-header"><h3 class="card-title fw-bold text-dark">관심 차종 분포</h3></div>
                                <div class="card-body d-flex flex-center"><canvas id="carChart"></canvas></div>
                            </div>
                        </div>
                        <div class="col-xl-8">
                            <div class="card shadow-sm border-0 h-100">
                                <div class="card-header"><h3 class="card-title fw-bold text-dark">시간대별 시승 예약 현황</h3></div>
                                <div class="card-body"><canvas id="timeChart" style="height: 300px;"></canvas></div>
                            </div>
                        </div>
                    </div>

                    <!-- 3열: 전시장 랭킹 -->
                    <div class="row g-5">
                        <div class="col-xl-12">
                            <div class="card shadow-sm border-0 h-100">
                                <div class="card-header"><h3 class="card-title fw-bold text-dark">전시장별 신청 TOP 10</h3></div>
                                <div class="card-body"><canvas id="shopChart" style="height: 350px;"></canvas></div>
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
    // 공통 컬러 팔레트
    const palette = ['#009ef7', '#50cd89', '#ffc700', '#7239ea', '#f1416c', '#43b1e5', '#ff9800', '#20c997', '#e83e8c', '#6f42c1'];

    // 데이터 파싱 헬퍼 함수
    const extractValues = (dataArr) => ({
        labels: dataArr.map(d => d.label),
        data: dataArr.map(d => d.cnt)
    });

    // 1. 일별 신청 추이 (라인 차트)
    const dailyLabels = [<c:forEach items="${chartData.dailyLabels}" var="label" varStatus="st">'${label}'${!st.last ? ',' : ''}</c:forEach>];
    const dailyData = [<c:forEach items="${chartData.dailyData}" var="d" varStatus="st">${d}${!st.last ? ',' : ''}</c:forEach>];
    new Chart(document.getElementById('dailyChart'), {
        type: 'line',
        data: {
            labels: dailyLabels,
            datasets: [{
                label: '신청자 수', data: dailyData, borderColor: '#009ef7', tension: 0.4, fill: true, backgroundColor: 'rgba(0, 158, 247, 0.1)'
            }]
        },
        options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } } }
    });

    // 2. 시승 참석 비율 (도넛 차트)
    const checked = parseInt("${chartData.attStats.driveCnt}") || 0;
    const waiting = parseInt("${stats.driveWaitCnt}") || 0;
    new Chart(document.getElementById('attChart'), {
        type: 'doughnut',
        data: {
            labels: ['도착 완료', '미도착 대기'],
            datasets: [{ data: [checked, waiting], backgroundColor: ['#009ef7', '#f1416c'], borderWidth: 0 }]
        },
        options: { responsive: true, maintainAspectRatio: false, cutout: '65%', plugins: { legend: { position: 'bottom' } } }
    });

    // 3. 관심 차종 분포 (도넛 차트)
    const carArr = [<c:forEach items="${chartData.carStats}" var="item" varStatus="st">{label:'${item.label}', cnt:${item.cnt}}${!st.last?',' : ''}</c:forEach>];
    const carExt = extractValues(carArr);
    new Chart(document.getElementById('carChart'), {
        type: 'pie',
        data: {
            labels: carExt.labels,
            datasets: [{ data: carExt.data, backgroundColor: palette, borderWidth: 0 }]
        },
        options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'bottom' } } }
    });

    // 4. 시간대별 시승 예약 현황 (바 차트)
    const timeArr = [<c:forEach items="${chartData.timeStats}" var="item" varStatus="st">{label:'${item.label}', cnt:${item.cnt}}${!st.last?',' : ''}</c:forEach>];
    const timeExt = extractValues(timeArr);
    new Chart(document.getElementById('timeChart'), {
        type: 'bar',
        data: {
            labels: timeExt.labels,
            datasets: [{ label: '예약 인원', data: timeExt.data, backgroundColor: '#50cd89', borderRadius: 4 }]
        },
        options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } } }
    });

    // 5. 전시장별 TOP 10 (가로 바 차트 - 디자인 개선)
    const shopArr = [<c:forEach items="${chartData.shopStats}" var="item" varStatus="st">{label:'${item.label}', cnt:${item.cnt}}${!st.last?',' : ''}</c:forEach>];
    const shopExt = extractValues(shopArr);
    new Chart(document.getElementById('shopChart'), {
        type: 'bar',
        data: {
            labels: shopExt.labels,
            datasets: [{
                label: '신청 건수',
                data: shopExt.data,
                backgroundColor: '#7239ea',
                borderRadius: 4,
                // 막대 두께 강제 지정 (너무 두꺼워지는 것 방지)
                maxBarThickness: 30
            }]
        },
        options: {
            indexAxis: 'y',
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false }
            },
            // x축 설정: 데이터가 1건일 때도 여백이 보이도록 최소 최대값 세팅
            scales: {
                x: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 1 // 소수점 방지 (1단위로 표시)
                    },
                    // 가장 큰 값이 5 미만일 경우 x축을 최소 5까지 그려서 여백 확보
                    suggestedMax: Math.max(...shopExt.data) < 5 ? 5 : null
                }
            }
        }
    });
</script>
</body>
</html>