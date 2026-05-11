<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 현재 접속 중인 URL을 추출하여 currentUrl 변수에 저장 -->
<c:set var="currentUrl" value="${requestScope['javax.servlet.forward.servlet_path']}" />
<c:if test="${empty currentUrl}">
    <c:set var="currentUrl" value="${pageContext.request.requestURI}" />
</c:if>

<div id="kt_app_sidebar" class="app-sidebar flex-column" data-kt-drawer="true" data-kt-drawer-name="app-sidebar" data-kt-drawer-activate="{default: true, lg: false}" data-kt-drawer-overlay="true" data-kt-drawer-width="225px" data-kt-drawer-direction="start" data-kt-drawer-toggle="#kt_app_sidebar_mobile_toggle">

    <div class="app-sidebar-logo px-6" id="kt_app_sidebar_logo">
        <a href="javascript:void(0);" class="d-flex align-items-center cursor-default">
            <img alt="Logo" src="/img/logo.png" class="h-15px app-sidebar-logo-default" />
            <span class="text-white fw-bolder fs-4 ms-3 font-interstate">ADMIN</span>
        </a>
        <div id="kt_app_sidebar_toggle" class="app-sidebar-toggle btn btn-icon btn-shadow btn-sm btn-color-muted btn-active-color-primary body-bg h-30px w-30px position-absolute top-50 start-100 translate-middle rotate" data-kt-toggle="true" data-kt-toggle-state="active" data-kt-toggle-target="body" data-kt-toggle-name="app-sidebar-minimize">
            <i class="ki-duotone ki-double-left fs-2 rotate-180">
                <span class="path1"></span><span class="path2"></span>
            </i>
        </div>
    </div>

    <div class="app-sidebar-menu overflow-hidden flex-column-fluid">
        <div id="kt_app_sidebar_menu_wrapper" class="app-sidebar-wrapper hover-scroll-overlay-y my-5" data-kt-scroll="true" data-kt-scroll-activate="true" data-kt-scroll-height="auto" data-kt-scroll-dependencies="#kt_app_sidebar_logo, #kt_app_sidebar_footer" data-kt-scroll-wrappers="#kt_app_sidebar_menu" data-kt-scroll-offset="5px">

            <div class="menu menu-column menu-rounded menu-sub-indention fw-semibold px-3" id="#kt_app_sidebar_menu" data-kt-menu="true">

                <div class="menu-item">
                    <!-- /mng/main 경로와 일치할 때 active 클래스 부여 -->
                    <a class="menu-link ${currentUrl eq '/mng/main' ? 'active' : ''}" href="/mng/main">
                        <span class="menu-icon">
                            <i class="ki-duotone ki-element-11 fs-2">
                                <span class="path1"></span><span class="path2"></span><span class="path3"></span><span class="path4"></span>
                            </i>
                        </span>
                        <span class="menu-title">대시보드 홈</span>
                    </a>
                </div>

                <div class="menu-item pt-5">
                    <div class="menu-content">
                        <span class="menu-heading fw-bold text-uppercase fs-7 text-muted">이벤트 관리</span>
                    </div>
                </div>

                <div class="menu-item">
                    <!-- /mng/participant 가 포함된 경로(목록, 상세페이지 모두)에서 active 클래스 부여 -->
                    <a class="menu-link ${fn:contains(currentUrl, '/mng/participant') ? 'active' : ''}" href="/mng/participant/list">
                        <span class="menu-icon">
                            <i class="ki-duotone ki-address-book fs-2">
                                <span class="path1"></span>
                                <span class="path2"></span>
                                <span class="path3"></span>
                            </i>
                        </span>
                        <span class="menu-title">시승 관리</span>
                    </a>
                </div>

            </div>
        </div>
    </div>

    <%--<div class="app-sidebar-footer flex-column-auto pt-2 pb-6 px-6" id="kt_app_sidebar_footer">
        <a href="/mng/logout" class="btn btn-flex flex-center btn-custom btn-primary overflow-hidden text-nowrap px-0 h-40px w-100" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-dismiss-="click" title="로그아웃">
            <span class="btn-label">Logout</span>
            <i class="ki-duotone ki-document btn-icon fs-2 m-0">
                <span class="path1"></span><span class="path2"></span>
            </i>
        </a>
    </div>--%>
</div>