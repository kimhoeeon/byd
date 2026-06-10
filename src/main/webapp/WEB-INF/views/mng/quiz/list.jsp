<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <title>BYD ADMIN | 퀴즈 신청자 관리</title>
    <link rel="stylesheet" href="/assets/plugins/global/plugins.bundle.css">
    <link rel="stylesheet" href="/assets/css/style.bundle.css">
</head>

<body id="kt_app_body" data-kt-app-layout="dark-sidebar" data-kt-app-header-fixed="true" data-kt-app-sidebar-enabled="true" data-kt-app-sidebar-fixed="true" class="app-default">
<div class="d-flex flex-column flex-root app-root">
    <div class="app-page flex-column flex-column-fluid">
        <jsp:include page="/WEB-INF/views/mng/include/header.jsp"/>

        <div class="app-wrapper flex-column flex-row-fluid" id="kt_app_wrapper">
            <jsp:include page="/WEB-INF/views/mng/include/sidebar.jsp"/>

            <div class="app-main flex-column flex-row-fluid" id="kt_app_main">
                <div class="d-flex flex-column flex-column-fluid">
                    <div id="kt_app_content" class="app-content flex-column-fluid mt-8">
                        <div class="app-container container-fluid">

                            <div class="card shadow-sm mb-5">
                                <div class="card-body py-5">
                                    <form action="/mng/quiz/list" method="get" class="d-flex align-items-center gap-3 w-100 flex-wrap">

                                        <div class="position-relative mw-150px">
                                            <input type="date" name="searchDate" value="${searchDate}" class="form-control form-control-solid" title="참여 날짜">
                                        </div>

                                        <div class="position-relative mw-125px">
                                            <select name="searchSession" class="form-select form-select-solid" data-control="select2" data-hide-search="true">
                                                <option value="">전체 회차</option>
                                                <option value="1" ${searchSession == 1 ? 'selected' : ''}>1회차</option>
                                                <option value="2" ${searchSession == 2 ? 'selected' : ''}>2회차</option>
                                                <option value="3" ${searchSession == 3 ? 'selected' : ''}>3회차</option>
                                                <option value="4" ${searchSession == 4 ? 'selected' : ''}>4회차</option>
                                                <option value="5" ${searchSession == 5 ? 'selected' : ''}>5회차</option>
                                            </select>
                                        </div>

                                        <div class="form-check form-check-custom form-check-solid form-check-danger me-2">
                                            <input class="form-check-input" type="checkbox" name="perfectScoreOnly" value="Y" id="chkPerfect" ${perfectScoreOnly == 'Y' ? 'checked' : ''}/>
                                            <label class="form-check-label fw-bold text-gray-700" for="chkPerfect">만점자(10점)만 조회</label>
                                        </div>

                                        <div class="position-relative flex-grow-1 mw-250px">
                                            <input type="text" name="keyword" value="${keyword}" class="form-control form-control-solid" placeholder="이름 / 연락처 검색">
                                        </div>

                                        <button type="submit" class="btn btn-dark">검색</button>
                                        <a href="/mng/quiz/list" class="btn btn-light">초기화</a>
                                        <a href="/mng/quiz/question/list" class="btn btn-primary fw-bold ms-auto">문제 관리 바로가기</a>
                                    </form>
                                </div>
                            </div>

                            <div class="card shadow-sm">
                                <div class="card-body py-4">
                                    <div class="table-responsive">
                                        <table class="table align-middle table-row-dashed fs-6 gy-5 table-hover">
                                            <thead>
                                            <tr class="text-center text-gray-500 fw-bold fs-7 text-uppercase gs-0 bg-light">
                                                <th class="w-100px">기념품 수령</th>
                                                <th class="min-w-100px">이름</th>
                                                <th class="min-w-150px">연락처</th>
                                                <th class="min-w-150px">이메일</th>
                                                <th class="min-w-100px">방문 지역</th>
                                                <th class="min-w-150px">방문 전시장</th>
                                                <th class="min-w-100px">관심차량</th>
                                                <th class="min-w-150px">참여날짜(회차)</th>
                                                <th class="min-w-100px">퀴즈현황</th>
                                            </tr>
                                            </thead>
                                            <tbody class="fw-semibold text-gray-600 text-center">
                                            <c:if test="${empty list}">
                                                <tr><td colspan="9" class="py-10">참여자가 없습니다.</td></tr>
                                            </c:if>

                                            <c:forEach items="${list}" var="user">
                                                <tr>
                                                    <td>
                                                        <c:forEach items="${user.historyList}" var="hist" varStatus="st">
                                                            <div class="form-check form-switch form-check-custom form-check-solid justify-content-center py-2">
                                                                <input class="form-check-input h-20px w-30px" type="checkbox" onchange="toggleGift(${hist.historySeq}, this)" ${hist.giftReceivedYn == 'Y' ? 'checked' : ''} />
                                                            </div>
                                                            <c:if test="${!st.last}"><hr class="my-1 border-transparent"/></c:if>
                                                        </c:forEach>
                                                    </td>
                                                    <td class="fw-bold text-dark">${user.name}</td>
                                                    <td>${user.phone}</td>
                                                    <td>${user.email}</td>
                                                    <td>${not empty user.region ? user.region : '-'}</td>
                                                    <td>${not empty user.shopInfo ? user.shopInfo : '-'}</td>
                                                    <td>
                                                        <span class="badge badge-light-primary fs-7" data-bs-toggle="tooltip"
                                                              title="${user.carModelCode == 'BYD0019' ? 'BYD SEALION 7' :
                                                                     user.carModelCode == 'BYD0005' ? 'BYD SEAL' :
                                                                     user.carModelCode == 'BYD0001' ? 'BYD ATTO 3' :
                                                                     user.carModelCode == 'BYD0004' ? 'BYD DOLPHIN' : '기타'}">
                                                                ${user.carModelCode}
                                                        </span>
                                                    </td>

                                                    <td>
                                                        <c:forEach items="${user.historyList}" var="hist" varStatus="st">
                                                            <div class="py-2">${hist.playDate} <span class="badge badge-light-dark fs-8">${hist.sessionNo}회차</span></div>
                                                            <c:if test="${!st.last}"><hr class="my-1 border-dashed"/></c:if>
                                                        </c:forEach>
                                                    </td>

                                                    <td>
                                                        <c:forEach items="${user.historyList}" var="hist" varStatus="st">
                                                            <div class="py-2">
                                                                <c:choose>
                                                                    <c:when test="${hist.status == 'COMPLETED'}">
                                                                        <span class="fw-bold ${hist.score == 10 ? 'text-danger' : 'text-primary'}">${hist.score} / 10 점</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="text-muted">진행중</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                            <c:if test="${!st.last}"><hr class="my-1 border-dashed"/></c:if>
                                                        </c:forEach>
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

<script src="/assets/plugins/global/plugins.bundle.js"></script>
<script src="/assets/js/scripts.bundle.js"></script>
<script>
    // 부트스트랩 툴팁 초기화 (마우스 오버 시 차량명 표시)
    $(document).ready(function(){
        $('[data-bs-toggle="tooltip"]').tooltip();
    });

    // 기념품 수령 토글 API 호출
    function toggleGift(historySeq, obj) {
        const isChecked = obj.checked ? 'Y' : 'N';
        $.ajax({
            url: '/mng/quiz/api/toggleGift',
            type: 'POST',
            data: { historySeq: historySeq, status: isChecked },
            success: function(res) {
                if(!res.success) {
                    alert(res.message);
                    obj.checked = !obj.checked; // 실패 시 롤백
                }
            },
            error: function() {
                alert("통신 오류");
                obj.checked = !obj.checked; // 실패 시 롤백
            }
        });
    }
</script>
</body>
</html>