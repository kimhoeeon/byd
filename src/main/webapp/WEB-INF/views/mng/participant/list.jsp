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
        /* 토글 스위치 CSS */
        .toggle-switch { position: relative; display: inline-block; width: 46px; height: 24px; vertical-align: middle; margin: 0; }
        .toggle-switch input { opacity: 0; width: 0; height: 0; }
        .slider { position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background-color: #e4e6ef; transition: .4s; border-radius: 24px; }
        .slider:before { position: absolute; content: ""; height: 18px; width: 18px; left: 3px; bottom: 3px; background-color: white; transition: .4s; border-radius: 50%; box-shadow: 0 1px 3px rgba(0,0,0,0.15); }
        input:checked + .slider { background-color: #009ef7; }
        input:checked + .slider:before { transform: translateX(22px); }

        .link-name { color: #009ef7; font-weight: bold; text-decoration: underline; cursor: pointer; }
        .link-name:hover { color: #007bb5; }

        /* 페이징 커스텀 추가 */
        .pagination { justify-content: center; margin-top: 20px; gap: 5px;}
        .page-item .page-link { border-radius: 4px !important; color: #333; border: 1px solid #dee2e6; }
        .page-item.active .page-link { background-color: #202020; border-color: #202020; color: #fff; }
    </style>
</head>
<body id="kt_app_body" data-kt-app-layout="dark-sidebar" data-kt-app-header-fixed="true"
      data-kt-app-sidebar-enabled="true" data-kt-app-sidebar-fixed="true" class="app-default">
    <div class="d-flex flex-column flex-root app-root">
        <div class="app-page flex-column flex-column-fluid">
            <jsp:include page="/WEB-INF/views/mng/include/header.jsp"/>

            <div class="app-wrapper flex-column flex-row-fluid">
                <jsp:include page="/WEB-INF/views/mng/include/sidebar.jsp"/>

                <div class="app-main flex-column flex-row-fluid p-10">

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
                    </div>

                    <!-- 데이터 목록 카드 -->
                    <div class="card shadow-sm border-0">
                        <div class="card-header border-0 pt-6">
                            <div class="card-title"><h3 class="fw-bold m-0">시승 관리</h3></div>
                        </div>
                        <div class="card-body pt-0">
                            <table class="table align-middle table-row-dashed fs-6 gy-5" id="kt_datatable">
                                <thead>
                                <tr class="text-start text-gray-400 fw-bold fs-7 text-uppercase gs-0">
                                    <th class="text-center">도착확인</th>
                                    <th class="text-center">연번</th>
                                    <th class="text-center">이름</th>
                                    <th class="text-center">연락처</th>
                                    <th class="text-center">주소</th>
                                    <th class="text-center">전시장정보</th>
                                    <th class="text-center">관심차량정보</th>
                                    <th class="text-center">마케팅수신동의</th>
                                    <th class="text-center">시승안전동의</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:choose>
                                    <c:when test="${empty list}">
                                        <tr>
                                            <td colspan="9" class="text-center text-muted py-10">검색된 신청 내역이 없습니다.</td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${list}" var="item">
                                            <tr class="text-center">
                                                <td>
                                                    <label class="toggle-switch">
                                                        <input type="checkbox" class="arrival-toggle" data-seq="${item.seq}" ${not empty item.qrScanTime ? 'checked' : ''}>
                                                        <span class="slider"></span>
                                                    </label>
                                                </td>
                                                <td>${item.seq}</td>
                                                <td><a href="/mng/participant/detail?seq=${item.seq}&pageNum=${cri.pageNum}&searchType=${cri.searchType}&keyword=${cri.keyword}" class="link-name">${item.name}</a></td>
                                                <td>${item.phone}</td>
                                                <td>${empty item.address ? '-' : item.address}</td>
                                                <td>${empty item.shopInfo ? '-' : item.shopInfo}</td>
                                                <td>${empty item.carModel ? '-' : item.carModel}</td>
                                                <td>
                                                    <span class="badge ${item.mktAgree eq 'Y' ? 'badge-light-primary' : 'badge-light-danger'}">${item.mktAgree}</span>
                                                </td>
                                                <td>
                                                    <span class="badge ${item.safetyAgree eq 'Y' ? 'badge-light-primary' : 'badge-light-danger'}">${item.safetyAgree}</span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                                </tbody>
                            </table>

                            <!-- 페이징 (Pagination) 영역 -->
                            <c:if test="${pageMaker.total > 0}">
                                <ul class="pagination">
                                    <!-- 이전 버튼 -->
                                    <c:if test="${pageMaker.prev}">
                                        <li class="page-item">
                                            <a href="javascript:void(0);" onclick="goPage(${pageMaker.startPage - 1})" class="page-link">&laquo; 이전</a>
                                        </li>
                                    </c:if>

                                    <!-- 페이지 번호 -->
                                    <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                                        <li class="page-item ${pageMaker.cri.pageNum == num ? 'active' : ''}">
                                            <a href="javascript:void(0);" onclick="goPage(${num})" class="page-link">${num}</a>
                                        </li>
                                    </c:forEach>

                                    <!-- 다음 버튼 -->
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

    <script src="/assets/plugins/global/plugins.bundle.js"></script>
    <script src="/assets/js/scripts.bundle.js"></script>
    <!-- 서버사이드 페이징과 충돌 방지를 위해 DataTables 라이브러리는 스타일용으로만 남기고 페이징/검색/정렬 기능은 false 처리합니다. -->
    <script src="/assets/plugins/custom/datatables/datatables.bundle.js"></script>
    <script>
        $(document).ready(function () {
            $('#kt_datatable').DataTable({
                "paging": false,
                "info": false,
                "searching": false,
                "ordering": false
            });

            // 토글 버튼 수동 도착 처리
            $(document).on('change', '.arrival-toggle', function () {
                let seq = $(this).data('seq');
                let isChecked = $(this).is(':checked');

                $.ajax({
                    url: '/mng/api/manualArrival',
                    type: 'POST',
                    data: { seq: seq, status: isChecked },
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

        // 검색 버튼 클릭 시 (1페이지부터 다시 검색)
        function searchData() {
            document.getElementById('pageNum').value = 1;
            document.getElementById('searchForm').submit();
        }

        // 페이징 번호 클릭 시 이동
        function goPage(page) {
            document.getElementById('pageNum').value = page;
            document.getElementById('searchForm').submit();
        }
    </script>
</body>
</html>