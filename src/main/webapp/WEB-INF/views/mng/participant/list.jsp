<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <title>BYD ADMIN | 통합 신청 내역</title>
    <link rel="stylesheet" href="/assets/plugins/custom/datatables/datatables.bundle.css">
    <link rel="stylesheet" href="/assets/plugins/global/plugins.bundle.css">
    <link rel="stylesheet" href="/assets/css/style.bundle.css">
    <style>
        #kt_app_main { background-color: #f5f8fa; }

        .toggle-switch { position: relative; display: inline-block; width: 46px; height: 24px; vertical-align: middle; margin: 0; }
        .toggle-switch input { opacity: 0; width: 0; height: 0; }
        .slider { position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background-color: #e4e6ef; transition: .4s; border-radius: 24px; }
        .slider:before { position: absolute; content: ""; height: 18px; width: 18px; left: 3px; bottom: 3px; background-color: white; transition: .4s; border-radius: 50%; box-shadow: 0 1px 3px rgba(0,0,0,0.15); }
        input:checked + .slider { background-color: #009ef7; }
        input:checked + .slider:before { transform: translateX(22px); }

        .link-name { color: #009ef7; font-weight: bold; text-decoration: underline; cursor: pointer; }
        .link-name:hover { color: #007bb5; }

        .pagination { justify-content: center; margin-top: 20px; gap: 5px;}
        .page-item .page-link { border-radius: 4px !important; color: #333; border: 1px solid #dee2e6; }
        .page-item.active .page-link { background-color: #202020; border-color: #202020; color: #fff; }

        /* 코드가 길어 줄바꿈이 일어나는 것을 방지하고 툴팁 안내를 위한 커서 변경 */
        .code-text { word-break: keep-all; white-space: nowrap; font-family: monospace; font-size: 13px; cursor: help; }
    </style>
</head>
<body id="kt_app_body" data-kt-app-layout="dark-sidebar" data-kt-app-header-fixed="true"
      data-kt-app-sidebar-enabled="true" data-kt-app-sidebar-fixed="true" class="app-default">

<!-- 레이아웃 붕괴 방지를 위해 id 추가 -->
<div class="d-flex flex-column flex-root app-root" id="kt_app_root">
    <div class="app-page flex-column flex-column-fluid" id="kt_app_page">

        <jsp:include page="/WEB-INF/views/mng/include/header.jsp"/>

        <div class="app-wrapper flex-column flex-row-fluid" id="kt_app_wrapper">

            <jsp:include page="/WEB-INF/views/mng/include/sidebar.jsp"/>

            <div class="app-main flex-column flex-row-fluid" id="kt_app_main">

                <!-- 컨텐츠 내부를 감싸는 Flex Fluid 컨테이너 추가 -->
                <div class="d-flex flex-column flex-column-fluid p-10">

                    <!-- 검색 영역 카드 -->
                    <div class="card shadow-sm border-0 mb-7">
                        <div class="card-body">
                            <!-- 검색 및 페이징 전송용 폼 -->
                            <form action="/mng/participant/list" method="get" id="searchForm" class="d-flex align-items-center gap-3">
                                <!-- 페이지 번호 유지를 위한 hidden 값 -->
                                <input type="hidden" name="pageNum" id="pageNum" value="${cri.pageNum}">
                                <input type="hidden" name="amount" value="${cri.amount}">

                                <select name="searchType" class="form-select form-select-solid w-150px">
                                    <option value="name" ${cri.searchType == 'name' ? 'selected' : ''}>이름</option>
                                    <option value="phone" ${cri.searchType == 'phone' ? 'selected' : ''}>연락처</option>
                                </select>

                                <input type="text" name="keyword" value="${cri.keyword}" class="form-control form-control-solid w-250px" placeholder="검색어를 입력해 주세요.">

                                <button type="button" class="btn btn-dark" onclick="searchData()">검색</button>
                                <a href="/mng/participant/list" class="btn btn-light">초기화</a>
                            </form>
                        </div>
                        <div class="card-footer d-flex justify-content-end">
                            <button type="button" class="btn btn-success" onclick="downloadExcel()">엑셀 다운로드</button>
                        </div>
                    </div>

                    <!-- 데이터 목록 카드 -->
                    <div class="card shadow-sm border-0">
                        <div class="card-header border-0 pt-6">
                            <div class="card-title"><h3 class="fw-bold m-0">시승 관리</h3></div>
                        </div>
                        <div class="card-body pt-0" style="overflow-x: auto;">
                            <table class="table align-middle table-row-dashed fs-6 gy-5" id="kt_datatable" style="min-width: 1300px;">
                                <thead>
                                <tr class="text-start text-gray-400 fw-bold fs-7 text-uppercase gs-0">
                                    <th class="text-center min-w-100px">등록일자</th>
                                    <th class="text-center">챌린지 도착</th>
                                    <th class="text-center">시승 도착</th>
                                    <th class="text-center">이름</th>
                                    <th class="text-center">연락처</th>
                                    <th class="text-center">주소</th>
                                    <th class="text-center">전시장정보</th>
                                    <th class="text-center">관심/시승차량</th>
                                    <th class="text-center">예약시간</th>
                                    <th class="text-center">개인정보 동의 여부</th>
                                    <th class="text-center">마케팅 동의 여부</th>
                                </tr>
                                </thead>
                                <tbody>
                                <!-- colspan="11" 이 포함된 JSTL empty 조건문을 삭제하여 DataTables 에러를 원천 차단합니다 -->
                                <c:forEach items="${list}" var="item">

                                    <!-- 전시장 코드 JSTL 매핑 (엑셀 규격과 동일) -->
                                    <c:set var="shopCode" value="${item.shopInfo}" />
                                    <c:choose>
                                        <c:when test="${item.shopInfo eq 'BYD 동탄'}"><c:set var="shopCode" value="APKR0001AW0011SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 부산 동래'}"><c:set var="shopCode" value="APKR0001AW0010SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 분당'}"><c:set var="shopCode" value="APKR0001AW0003SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 서초'}"><c:set var="shopCode" value="APKR0001AW0002SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 수영'}"><c:set var="shopCode" value="APKR0001AW0005SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 수원'}"><c:set var="shopCode" value="APKR0001AW0001SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 스타필드 명지'}"><c:set var="shopCode" value="APKR0001AW0014SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 스타필드 안성'}"><c:set var="shopCode" value="APKR0001AW0016SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 스타필드 운정'}"><c:set var="shopCode" value="APKR0001AW0017SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 스타필드 일산'}"><c:set var="shopCode" value="APKR0001AW0013SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 스타필드 하남'}"><c:set var="shopCode" value="APKR0001AW0015SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 일산'}"><c:set var="shopCode" value="APKR0001AW0007SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 창원'}"><c:set var="shopCode" value="APKR0001AW0012SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 강서'}"><c:set var="shopCode" value="APKR0002AW0004SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 김포'}"><c:set var="shopCode" value="APKR0002AW0005SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 마포'}"><c:set var="shopCode" value="APKR0002AW0006SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 용산'}"><c:set var="shopCode" value="APKR0002AW0001SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 의정부'}"><c:set var="shopCode" value="APKR0002AW0010SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 제주'}"><c:set var="shopCode" value="APKR0002AW0002SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 천안'}"><c:set var="shopCode" value="APKR0002AW0008SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 청주'}"><c:set var="shopCode" value="APKR0002AW0009SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 강동'}"><c:set var="shopCode" value="APKR0003AW0010SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 목동'}"><c:set var="shopCode" value="APKR0003AW0002SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 부천'}"><c:set var="shopCode" value="APKR0003AW0007SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 서해구'}"><c:set var="shopCode" value="APKR0003AW0008SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 송도'}"><c:set var="shopCode" value="APKR0003AW0001SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 송파'}"><c:set var="shopCode" value="APKR0003AW0009SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 안양'}"><c:set var="shopCode" value="APKR0003AW0003SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 대구'}"><c:set var="shopCode" value="APKR0004AW0001SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 포항'}"><c:set var="shopCode" value="APKR0004AW0002SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 원주'}"><c:set var="shopCode" value="APKR0005AW0001SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 광주'}"><c:set var="shopCode" value="APKR0006AW0003SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 대전'}"><c:set var="shopCode" value="APKR0006AW0001SW"/></c:when>
                                        <c:when test="${item.shopInfo eq 'BYD 전주'}"><c:set var="shopCode" value="APKR0006AW0005SW"/></c:when>
                                    </c:choose>

                                    <!-- 관심모델 코드 JSTL 매핑 (엑셀 규격과 동일) -->
                                    <c:set var="carCode" value="${item.carModel}" />
                                    <c:choose>
                                        <c:when test="${item.carModel eq 'BYD DOLPHIN'}"><c:set var="carCode" value="BYD0004"/></c:when>
                                        <c:when test="${item.carModel eq 'BYD ATTO 3'}"><c:set var="carCode" value="BYD0001"/></c:when>
                                        <c:when test="${item.carModel eq 'BYD SEAL'}"><c:set var="carCode" value="BYD0005"/></c:when>
                                        <c:when test="${item.carModel eq 'BYD SEALION 7'}"><c:set var="carCode" value="BYD0019"/></c:when>
                                    </c:choose>

                                    <tr class="text-center">
                                        <!-- 등록일자 출력 (형식 지정) -->
                                        <td><fmt:formatDate value="${item.regDate}" pattern="yyyy.MM.dd HH:mm"/></td>

                                        <!-- 챌린지 도착 토글 -->
                                        <td>
                                            <label class="toggle-switch">
                                                <input type="checkbox" class="arrival-toggle" data-seq="${item.seq}" data-type="challenge" ${item.challengeCheckYn eq 'Y' ? 'checked' : ''}>
                                                <span class="slider"></span>
                                            </label>
                                        </td>
                                        <!-- 시승 도착 토글 -->
                                        <td>
                                            <label class="toggle-switch">
                                                <input type="checkbox" class="arrival-toggle" data-seq="${item.seq}" data-type="drive" ${item.driveCheckYn eq 'Y' ? 'checked' : ''}>
                                                <span class="slider"></span>
                                            </label>
                                        </td>
                                        <td><a href="/mng/participant/detail?seq=${item.seq}&pageNum=${cri.pageNum}&searchType=${cri.searchType}&keyword=${cri.keyword}" class="link-name">${item.name}</a></td>
                                        <td>${item.phone}</td>
                                        <td>${empty item.address ? '-' : item.address}</td>

                                        <!-- 전시장 정보 및 시승차량 정보 (코드로 표기, 툴팁으로 원래 이름 확인) -->
                                        <td class="code-text" title="${item.shopInfo}">${empty item.shopInfo ? '-' : shopCode}</td>
                                        <td class="code-text" title="${item.carModel}">${empty item.carModel ? '-' : carCode}</td>

                                        <td><span class="text-primary fw-bold">${item.testDriveTime}</span></td>
                                        <td>
                                            <span class="badge badge-light-primary">Y</span>
                                        </td>
                                        <td>
                                            <span class="badge ${item.mktAgree eq 'Y' ? 'badge-light-primary' : 'badge-light-danger'}">${item.mktAgree}</span>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>

                            <!-- 페이징 (Pagination) 영역 -->
                            <c:if test="${pageMaker.total > 0}">
                                <ul class="pagination">
                                    <c:if test="${pageMaker.prev}">
                                        <li class="page-item">
                                            <a href="javascript:void(0);" onclick="goPage(${pageMaker.startPage - 1})" class="page-link">&laquo; 이전</a>
                                        </li>
                                    </c:if>

                                    <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                                        <li class="page-item ${pageMaker.cri.pageNum == num ? 'active' : ''}">
                                            <a href="javascript:void(0);" onclick="goPage(${num})" class="page-link">${num}</a>
                                        </li>
                                    </c:forEach>

                                    <c:if test="${pageMaker.next}">
                                        <li class="page-item">
                                            <a href="javascript:void(0);" onclick="goPage(${pageMaker.endPage + 1})" class="page-link">다음 &raquo;</a>
                                        </li>
                                    </c:if>
                                </ul>
                            </c:if>

                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<script src="/assets/plugins/global/plugins.bundle.js"></script>
<script src="/assets/js/scripts.bundle.js"></script>
<script src="/assets/plugins/custom/datatables/datatables.bundle.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
<script>
    $(document).ready(function () {

        // JSTL 빈 데이터 colspan 충돌을 막기 위해 DataTables 설정에서 데이터 없음 메시지를 지정합니다.
        $('#kt_datatable').DataTable({
            "paging": false,
            "info": false,
            "searching": false,
            "ordering": false,
            "language": {
                "emptyTable": "검색된 신청 내역이 없습니다."
            }
        });

        // 도착 처리 토글 액션 (챌린지/시승 분리)
        $(document).on('change', '.arrival-toggle', function () {
            let seq = $(this).data('seq');
            let type = $(this).data('type'); // 'challenge' 또는 'drive'
            let isChecked = $(this).is(':checked');

            $.ajax({
                url: '/mng/api/manualArrival',
                type: 'POST',
                data: { seq: seq, status: isChecked, type: type },
                success: function(res) {
                    if(!res.success) {
                        alert("상태 변경에 실패했습니다.");
                        $(this).prop('checked', !isChecked);
                    }
                }.bind(this),
                error: function() {
                    alert("서버 통신 오류가 발생했습니다.");
                    $(this).prop('checked', !isChecked);
                }.bind(this)
            });
        });
    });

    function searchData() {
        document.getElementById('pageNum').value = 1;
        document.getElementById('searchForm').submit();
    }

    function goPage(page) {
        document.getElementById('pageNum').value = page;
        document.getElementById('searchForm').submit();
    }

    function downloadExcel() {
        var searchData = $('#searchForm').serialize();

        $.ajax({
            url: '/mng/api/participant/excelData',
            type: 'GET',
            data: searchData,
            success: function(res) {
                if(res.length === 0) {
                    alert("다운로드할 데이터가 없습니다.");
                    return;
                }

                var ws = XLSX.utils.json_to_sheet(res);

                var wscols = [
                    {wch: 20}, // 문의일자
                    {wch: 20}, // 전시장코드
                    {wch: 15}, // 전시장명
                    {wch: 15}, // 유입경로코드
                    {wch: 15}, // 유입경로명
                    {wch: 15}, // 고객명
                    {wch: 15}, // 연락처
                    {wch: 20}, // 관심모델그룹코드
                    {wch: 20}, // 관심모델그룹코드명
                    {wch: 15}, // 시승시간
                    {wch: 15}, // 개인정보동의여부
                    {wch: 15}, // 마케팅동의여부
                    {wch: 12}, // 챌린지참여
                    {wch: 12}, // 시승참여
                    {wch: 40}  // 주소
                ];
                ws['!cols'] = wscols;

                var wb = XLSX.utils.book_new();
                XLSX.utils.book_append_sheet(wb, ws, "참여자목록");

                var today = new Date();
                var month = ('0' + (today.getMonth() + 1)).slice(-2);
                var day = ('0' + today.getDate()).slice(-2);
                var filename = "BYD_Event_참여자_" + today.getFullYear() + month + day + ".xlsx";

                XLSX.writeFile(wb, filename);
            },
            error: function(err) {
                alert("엑셀 데이터를 생성하는 중 오류가 발생했습니다.");
                console.error(err);
            }
        });
    }
</script>
</body>
</html>