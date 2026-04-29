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
</head>
<body id="kt_app_body" data-kt-app-layout="dark-sidebar" data-kt-app-header-fixed="true"
      data-kt-app-sidebar-enabled="true" data-kt-app-sidebar-fixed="true" class="app-default">
<div class="d-flex flex-column flex-root app-root">
    <div class="app-page flex-column flex-column-fluid">
        <jsp:include page="/WEB-INF/views/mng/include/header.jsp"/>
        <div class="app-wrapper flex-column flex-row-fluid">
            <jsp:include page="/WEB-INF/views/mng/include/sidebar.jsp"/>
            <div class="app-main flex-column flex-row-fluid p-10">
                <div class="card shadow-sm border-0">
                    <div class="card-header border-0 pt-6">
                        <div class="card-title"><h3 class="fw-bold m-0">통합 시승 신청 내역</h3></div>
                    </div>
                    <div class="card-body pt-0">
                        <table class="table align-middle table-row-dashed fs-6 gy-5" id="kt_datatable">
                            <thead>
                            <tr class="text-start text-gray-400 fw-bold fs-7 text-uppercase gs-0">
                                <th>No</th>
                                <th>이름</th>
                                <th>연락처</th>
                                <th>전시장/관심차량</th>
                                <th>시승시간</th>
                                <th>등록일시</th>
                                <th>도착 상태</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${empty list}">
                                    <tr>
                                        <td colspan="7" style="text-align:center;">신청 내역이 없습니다.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${list}" var="item">
                                        <tr>
                                            <td>${item.seq}</td>
                                            <td><a href="/mng/participant/detail?seq=${item.seq}">${item.name}</a></td>
                                            <td>${item.phone}</td>
                                            <td>${item.carModel}</td>
                                            <td>${item.testDriveTime}</td>
                                            <td><fmt:formatDate value="${item.regDate}" pattern="yyyy-MM-dd HH:mm"/></td>

                                            <!-- [중요] 방문 상태 출력 분기 -->
                                            <td style="text-align:center;">
                                                <c:choose>
                                                    <c:when test="${empty item.qrScanTime}">
                                                        <span style="color:#999; font-weight:bold;">미방문</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color:#009ef7; font-weight:bold;">방문 완료</span><br>
                                                        <span style="font-size:12px; color:#555;">
                                                    (<fmt:formatDate value="${item.qrScanTime}" pattern="MM/dd HH:mm"/>)
                                                </span>
                                                    </c:otherwise>
                                                </c:choose>
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
<script src="/assets/plugins/global/plugins.bundle.js"></script>
<script src="/assets/js/scripts.bundle.js"></script>
<script src="/assets/plugins/custom/datatables/datatables.bundle.js"></script>
<script>
    $(document).ready(function () {
        $('#kt_datatable').DataTable({"order": [[0, "desc"]]});
        $(document).on('click', '.check-arrival-btn', function () {
            var seq = $(this).data('seq');
            if (confirm("고객 도착 확인 처리를 하시겠습니까?")) {
                $.post('/mng/api/checkArrival', {seq: seq}, function (res) {
                    if (res === 'SUCCESS') location.reload();
                    else alert("오류가 발생했습니다.");
                });
            }
        });
    });
</script>
</body>
</html>