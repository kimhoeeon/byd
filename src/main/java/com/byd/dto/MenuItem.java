package com.byd.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MenuItem {

    private String title;       // 메뉴명 (예: 대시보드)
    private String url;         // 이동할 주소 (예: /mng/main.do)
    private String icon;        // 아이콘 클래스명 (예: ki-element-11)
    private int pathCount;      // 아이콘의 path 개수 (Metronic duotone 아이콘 깨짐 방지용)
    private boolean active;     // 현재 메뉴 활성화 여부 (CSS highlight용)
    private List<MenuItem> children; // 하위 메뉴 리스트

    /**
     * 하위 메뉴가 없는 단일 메뉴용 생성자
     * @param title 메뉴명
     * @param url 이동 주소
     * @param icon 아이콘 클래스
     * @param pathCount 아이콘 path 개수
     */
    public MenuItem(String title, String url, String icon, int pathCount) {
        this.title = title;
        this.url = url;
        this.icon = icon;
        this.pathCount = pathCount;
        this.active = false; // 기본값
        this.children = null;
    }

    /**
     * 하위 메뉴가 있는 그룹 메뉴용 생성자
     * @param title 메뉴명
     * @param url 이동 주소 (보통 #)
     * @param icon 아이콘 클래스
     * @param pathCount 아이콘 path 개수
     * @param children 하위 메뉴 리스트
     */
    public MenuItem(String title, String url, String icon, int pathCount, List<MenuItem> children) {
        this.title = title;
        this.url = url;
        this.icon = icon;
        this.pathCount = pathCount;
        this.active = false;
        this.children = children;
    }
}