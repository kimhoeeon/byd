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
    <style>
        .code-text {
            word-break: keep-all;
            white-space: nowrap;
            font-family: monospace;
            font-size: 14px;
            cursor: help;
        }
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
                <div class="card shadow-sm border-0">
                    <div class="card-header border-0 pt-6">
                        <div class="card-title"><h3 class="fw-bold m-0">신청 상세 정보 (No.${data.seq})</h3></div>
                        <div class="card-toolbar"><a href="/mng/participant/list" class="btn btn-sm btn-light">목록으로</a></div>
                    </div>
                    <div class="card-body">

                        <c:set var="shopCode" value="${data.shopInfo}"/>
                        <c:choose>
                            <c:when test="${data.shopInfo eq 'BYD 동탄'}"><c:set var="shopCode" value="APKR0001AW0011SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 부산 동래'}"><c:set var="shopCode" value="APKR0001AW0010SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 분당'}"><c:set var="shopCode" value="APKR0001AW0003SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 서초'}"><c:set var="shopCode" value="APKR0001AW0002SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 수영'}"><c:set var="shopCode" value="APKR0001AW0005SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 수원'}"><c:set var="shopCode" value="APKR0001AW0001SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 스타필드 명지'}"><c:set var="shopCode" value="APKR0001AW0014SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 스타필드 안성'}"><c:set var="shopCode" value="APKR0001AW0016SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 스타필드 운정'}"><c:set var="shopCode" value="APKR0001AW0017SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 스타필드 일산'}"><c:set var="shopCode" value="APKR0001AW0013SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 스타필드 하남'}"><c:set var="shopCode" value="APKR0001AW0015SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 일산'}"><c:set var="shopCode" value="APKR0001AW0007SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 창원'}"><c:set var="shopCode" value="APKR0001AW0012SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 강서'}"><c:set var="shopCode" value="APKR0002AW0004SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 김포'}"><c:set var="shopCode" value="APKR0002AW0005SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 마포'}"><c:set var="shopCode" value="APKR0002AW0006SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 용산'}"><c:set var="shopCode" value="APKR0002AW0001SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 의정부'}"><c:set var="shopCode" value="APKR0002AW0010SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 제주'}"><c:set var="shopCode" value="APKR0002AW0002SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 천안'}"><c:set var="shopCode" value="APKR0002AW0008SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 청주'}"><c:set var="shopCode" value="APKR0002AW0009SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 강동'}"><c:set var="shopCode" value="APKR0003AW0010SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 목동'}"><c:set var="shopCode" value="APKR0003AW0002SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 부천'}"><c:set var="shopCode" value="APKR0003AW0007SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 서해구'}"><c:set var="shopCode" value="APKR0003AW0008SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 송도'}"><c:set var="shopCode" value="APKR0003AW0001SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 송파'}"><c:set var="shopCode" value="APKR0003AW0009SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 안양'}"><c:set var="shopCode" value="APKR0003AW0003SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 대구'}"><c:set var="shopCode" value="APKR0004AW0001SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 포항'}"><c:set var="shopCode" value="APKR0004AW0002SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 원주'}"><c:set var="shopCode" value="APKR0005AW0001SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 광주'}"><c:set var="shopCode" value="APKR0006AW0003SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 대전'}"><c:set var="shopCode" value="APKR0006AW0001SW"/></c:when>
                            <c:when test="${data.shopInfo eq 'BYD 전주'}"><c:set var="shopCode" value="APKR0006AW0005SW"/></c:when>
                        </c:choose>

                        <c:set var="carCode" value="${data.carModel}"/>
                        <c:choose>
                            <c:when test="${data.carModel eq 'BYD DOLPHIN'}"><c:set var="carCode" value="BYD0004"/></c:when>
                            <c:when test="${data.carModel eq 'BYD ATTO 3'}"><c:set var="carCode" value="BYD0001"/></c:when>
                            <c:when test="${data.carModel eq 'BYD SEAL'}"><c:set var="carCode" value="BYD0005"/></c:when>
                            <c:when test="${data.carModel eq 'BYD SEALION 7'}"><c:set var="carCode" value="BYD0019"/></c:when>
                        </c:choose>

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
                                <td colspan="3"><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${data.regDate}"/></td>
                            </tr>
                            <tr>
                                <th class="bg-light fw-bold">이름</th>
                                <td>${data.name}</td>
                                <th class="bg-light fw-bold">연락처</th>
                                <td>${data.phone}</td>
                            </tr>
                            <tr>
                                <th class="bg-light fw-bold">이메일</th>
                                <td colspan="3">${empty data.email ? '-' : data.email}</td>
                            </tr>
                            <tr>
                                <th class="bg-light fw-bold">전시장 정보</th>
                                <td class="code-text" title="${data.shopInfo}">${empty data.shopInfo ? '-' : shopCode}</td>
                                <th class="bg-light fw-bold">관심/시승 차량</th>
                                <td class="code-text" title="${data.carModel}">${empty data.carModel ? '-' : carCode}</td>
                            </tr>
                            <tr>
                                <th class="bg-light fw-bold text-primary">시승 예약시간</th>
                                <td colspan="3">
                                    <span class="fw-bolder fs-5 text-primary">${empty data.testDriveTime ? '-' : data.testDriveTime}</span>
                                </td>
                            </tr>

                            <tr>
                                <th class="bg-light fw-bold">개인정보 수집 및 이용 동의</th>
                                <td><span class="badge badge-primary">${empty data.privacyAgree ? 'N' : data.privacyAgree}</span></td>
                                <th class="bg-light fw-bold">마케팅 정보 수신 동의</th>
                                <td><span class="badge badge-primary">${empty data.mktAgree ? 'N' : data.mktAgree}</span></td>
                            </tr>
                            <tr>
                                <th class="bg-light fw-bold">제 3자 정보 제공 동의</th>
                                <td colspan="3"><span class="badge badge-primary">${empty data.thirdPartyAgree ? 'N' : data.thirdPartyAgree}</span></td>
                            </tr>

                            <tr>
                                <th class="bg-light fw-bold">챌린지 도착확인</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${data.challengeCheckYn eq 'Y'}"><span class="text-success fw-bold">도착 확인 완료</span></c:when>
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