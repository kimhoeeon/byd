<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div id="kt_app_header" class="app-header" data-kt-sticky="true" data-kt-sticky-activate="{default: true, lg: true}" data-kt-sticky-name="app-header-minimize" data-kt-sticky-offset="{default: '200px', lg: '300px'}">
    <div class="app-container container-fluid d-flex align-items-stretch justify-content-between" id="kt_app_header_container">

        <div class="d-flex align-items-center d-lg-none ms-n3 me-1" title="Show sidebar menu">
            <div class="btn btn-icon btn-active-color-primary w-35px h-35px" id="kt_app_sidebar_mobile_toggle">
                <i class="ki-duotone ki-abstract-14 fs-2">
                    <span class="path1"></span><span class="path2"></span>
                </i>
            </div>
        </div>

        <div class="d-flex align-items-center flex-grow-1 flex-lg-grow-0 me-lg-15">
            <a href="/mng/main" class="d-lg-none">
                <img alt="Logo" src="/img/logo.svg" class="h-30px" />
            </a>
            <h1 class="page-heading d-none d-lg-flex flex-column justify-content-center text-dark fw-bold fs-3 m-0">
                BYD 통합 관리 시스템
            </h1>
        </div>

        <div class="app-navbar flex-shrink-0">
            <div class="app-navbar-item ms-1 ms-lg-3">
                <div class="d-flex align-items-center">
                    <div class="me-3 text-end">
                        <span class="text-muted fw-semibold d-block fs-8">Administrator</span>
                        <span class="text-dark fw-bold fs-7">${sessionScope.adminInfo.adminName}</span>
                    </div>
                    <div class="symbol symbol-35px symbol-md-40px">
                        <div class="symbol-label fs-3 bg-light-primary text-primary fw-bold">
                            ${fn:substring(sessionScope.adminInfo.adminName, 0, 1)}
                        </div>
                    </div>
                </div>
            </div>

            <div class="app-navbar-item ms-1 ms-lg-3">
                <a href="/mng/logout" class="btn btn-icon btn-custom btn-icon-muted btn-active-light btn-active-color-primary w-35px h-35px w-md-40px h-md-40px">
                    <i class="ki-duotone ki-exit-right fs-1">
                        <span class="path1"></span><span class="path2"></span>
                    </i>
                </a>
            </div>
        </div>
    </div>
</div>