<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div id="kt_app_sidebar" class="app-sidebar flex-column"
     data-kt-drawer="true" data-kt-drawer-name="app-sidebar" data-kt-drawer-activate="{default: true, lg: false}"
     data-kt-drawer-overlay="true" data-kt-drawer-width="225px" data-kt-drawer-direction="start"
     data-kt-drawer-toggle="#kt_app_sidebar_mobile_toggle">

    <div class="app-sidebar-logo px-6 justify-content-center" id="kt_app_sidebar_logo">
        <a href="/mng/main.do">
            <img alt="Logo" src="/img/logo.svg" class="h-40px app-sidebar-logo-default theme-light-show" style="object-fit: contain;" />
            <img alt="Logo" src="/img/logo.svg" class="h-25px app-sidebar-logo-minimize" style="object-fit: contain;" />
        </a>

        <div id="kt_app_sidebar_toggle" class="app-sidebar-toggle btn btn-icon btn-shadow btn-sm btn-color-muted btn-active-color-primary body-bg h-30px w-30px position-absolute top-50 start-100 translate-middle rotate"
             data-kt-toggle="true" data-kt-toggle-state="active" data-kt-toggle-target="body" data-kt-toggle-name="app-sidebar-minimize">
            <i class="ki-duotone ki-double-left fs-2 rotate-180">
                <span class="path1"></span><span class="path2"></span>
            </i>
        </div>
    </div>

    <div class="app-sidebar-menu overflow-hidden flex-column-fluid">
        <div id="kt_app_sidebar_menu_wrapper" class="app-sidebar-wrapper hover-scroll-overlay-y my-5"
             data-kt-scroll="true" data-kt-scroll-activate="true" data-kt-scroll-height="auto"
             data-kt-scroll-dependencies="#kt_app_sidebar_logo, #kt_app_sidebar_footer"
             data-kt-scroll-wrappers="#kt_app_sidebar_menu" data-kt-scroll-offset="5px" data-kt-scroll-save-state="true">

            <div class="menu menu-column menu-rounded menu-sub-indention fw-semibold px-3" id="kt_app_sidebar_menu" data-kt-menu="true" data-kt-menu-expand="false">

                <c:forEach var="menu" items="${menuItems}">
                    <c:if test="${not empty menu.children}">
                        <div data-kt-menu-trigger="click" class="menu-item menu-accordion ${menu.active ? 'here show' : ''}">
                            <span class="menu-link">
                                <span class="menu-icon">
                                    <i class="ki-duotone ${menu.icon} fs-2">
                                        <c:if test="${menu.pathCount > 0}">
                                            <c:forEach begin="1" end="${menu.pathCount}" var="i">
                                                <span class="path${i}"></span>
                                            </c:forEach>
                                        </c:if>
                                    </i>
                                </span>
                                <span class="menu-title">${menu.title}</span>
                                <span class="menu-arrow"></span>
                            </span>
                            <div class="menu-sub menu-sub-accordion">
                                <c:forEach var="sub" items="${menu.children}">
                                    <div class="menu-item">
                                        <a class="menu-link ${sub.active ? 'active' : ''}" href="${sub.url}">
                                            <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                                            <span class="menu-title">${sub.title}</span>
                                        </a>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${empty menu.children}">
                        <div class="menu-item">
                            <a class="menu-link ${menu.active ? 'active' : ''}" href="${menu.url}">
                                <span class="menu-icon">
                                    <i class="ki-duotone ${menu.icon} fs-2">
                                        <c:if test="${menu.pathCount > 0}">
                                            <c:forEach begin="1" end="${menu.pathCount}" var="i">
                                                <span class="path${i}"></span>
                                            </c:forEach>
                                        </c:if>
                                    </i>
                                </span>
                                <span class="menu-title">${menu.title}</span>
                            </a>
                        </div>
                    </c:if>
                </c:forEach>

            </div>
        </div>
    </div>
</div>