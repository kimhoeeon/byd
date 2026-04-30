<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <title>BYD ADMIN | 상세 정보</title>
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
                            <div class="card-title"><h3 class="fw-bold m-0">신청 상세 정보 (No.${data.seq})</h3></div>
                            <div class="card-toolbar"><a href="/mng/participant/list" class="btn btn-sm btn-light">목록으로</a>
                            </div>
                        </div>
                        <div class="card-body">
                            <table class="table table-bordered align-middle gs-7 gy-4">
                                <colgroup>
                                    <col width="20%">
                                    <col width="30%">
                                    <col width="20%">
                                    <col width="30%">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th class="bg-light fw-bold">등록일시</th>
                                    <td colspan="3"><fmt:parseDate value="${data.regDate}" pattern="yyyy-MM-dd'T'HH:mm:ss"
                                                                   var="pDate"/><fmt:formatDate
                                            pattern="yyyy-MM-dd HH:mm:ss" value="${pDate}"/></td>
                                </tr>
                                <tr>
                                    <th class="bg-light fw-bold">이름</th>
                                    <td>${data.name}</td>
                                    <th class="bg-light fw-bold">연락처</th>
                                    <td>${data.phone}</td>
                                </tr>
                                <tr>
                                    <th class="bg-light fw-bold">주소</th>
                                    <td colspan="3">${empty data.address ? '-' : data.address}</td>
                                </tr>
                                <tr>
                                    <th class="bg-light fw-bold">전시장 정보</th>
                                    <td>${empty data.shopInfo ? '-' : data.shopInfo}</td>
                                    <th class="bg-light fw-bold">관심/시승 차량</th>
                                    <td>${empty data.carModel ? '-' : data.carModel}</td>
                                </tr>
                                <tr>
                                    <th class="bg-light fw-bold text-primary">시승 예약시간</th>
                                    <td colspan="3"><span
                                            class="fw-bolder fs-5 text-primary">${empty data.testDriveTime ? '-' : data.testDriveTime}</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="bg-light fw-bold">마케팅 수신동의</th>
                                    <td><span
                                            class="badge ${data.mktAgree eq 'Y' ? 'badge-primary' : 'badge-danger'}">${data.mktAgree}</span>
                                    </td>
                                    <th class="bg-light fw-bold">시승 안전동의</th>
                                    <td><span
                                            class="badge ${data.safetyAgree eq 'Y' ? 'badge-primary' : 'badge-danger'}">${data.safetyAgree}</span>
                                    </td>
                                </tr>
                                <!-- 챌린지 및 시승 도착 여부 분리 -->
                                <tr>
                                    <th class="bg-light fw-bold">챌린지 도착확인</th>
                                    <td>
                                        <c:choose>
                                            <c:when test="${data.challengeCheckYn eq 'Y'}"><span
                                                    class="text-success fw-bold">도착 확인 완료</span></c:when>
                                            <c:otherwise><span class="text-danger fw-bold">미도착</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <th class="bg-light fw-bold">시승 도착확인</th>
                                    <td>
                                        <c:choose>
                                            <c:when test="${data.driveCheckYn eq 'Y'}"><span class="text-success fw-bold">도착 확인 완료</span></c:when>
                                            <c:otherwise><span class="text-danger fw-bold">미도착</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
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
</body>
</html>