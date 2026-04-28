package com.byd.controller;

import com.byd.dto.MenuItem;
import com.byd.service.AlarmService;
import com.byd.service.MenuService;
import com.byd.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ui.Model;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.multipart.MultipartException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

@Slf4j
@ControllerAdvice
@RequiredArgsConstructor
public class GlobalController {

    private final MenuService menuService;
    private final AlarmService alarmService;

    /**
     * 모든 요청 시 모델에 'menuItems'를 자동으로 담아줌
     * + 현재 접속한 URL을 기준으로 Active 상태를 계산함
     */
    @ModelAttribute("menuItems")
    public List<MenuItem> menuItems(HttpServletRequest request) {

        // 1. 전체 메뉴 목록 가져오기 (DB 또는 메모리)
        List<MenuItem> menus = menuService.getAdminMenuItems();

        // 2. 현재 접속한 페이지의 URI 확인 (예: /mng/members/list)
        String requestUri = request.getRequestURI();

        // 3. 재귀적으로 돌면서 Active 상태 업데이트
        updateMenuStatus(menus, requestUri);

        return menus;
    }

    /**
     * 메뉴 트리 구조를 순회하며 현재 URL과 일치하는 메뉴를 활성화
     * @param menus 탐색할 메뉴 리스트
     * @param currentUri 현재 접속 URL
     * @return 하위 메뉴 중 하나라도 활성화되었다면 true 반환 (부모 메뉴 확장용)
     */
    private boolean updateMenuStatus(List<MenuItem> menus, String currentUri) {
        boolean isGroupActive = false; // 현재 레벨(형제들) 중 하나라도 활성화되었는지 여부

        for (MenuItem menu : menus) {
            // 상태 초기화 (싱글톤 객체가 아니라면 필수)
            menu.setActive(false);

            boolean isSelfActive = false;

            // 1. [본인 확인] 현재 URL과 메뉴 URL이 정확히 일치하는지 확인
            if (menu.getUrl() != null && !menu.getUrl().isEmpty()) {
                if (currentUri.equals(menu.getUrl())) {
                    isSelfActive = true;
                }
                // (옵션) 상세 페이지 등 서브 URL도 활성화하고 싶다면 아래와 같은 로직 추가 가능
                else if (currentUri.startsWith(menu.getUrl())) {
                    isSelfActive = true;
                }
            }

            // 2. [자식 확인] 하위 메뉴가 있다면 재귀 호출
            if (menu.getChildren() != null && !menu.getChildren().isEmpty()) {
                boolean isChildActive = updateMenuStatus(menu.getChildren(), currentUri);
                // 자식이 활성화되었다면 부모(나)도 활성화 (Accordion 펼치기 위해)
                if (isChildActive) {
                    isSelfActive = true;
                }
            }

            // 3. 최종 상태 적용
            if (isSelfActive) {
                menu.setActive(true);
                isGroupActive = true;
            }
        }

        return isGroupActive;
    }

    // 모든 요청에 대해 실행되어 jsp에서 ${hasUnreadAlarm} 사용 가능하게 함
    @ModelAttribute
    public void addGlobalAttributes(HttpServletRequest request, Model model) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
            if (loginMember != null) {
                // 읽지 않은 알림 체크
                int unreadCount = alarmService.getUnreadCount(loginMember.getMemberId());
                model.addAttribute("hasUnreadAlarm", unreadCount > 0);
            }
        }
    }

    /**
     * 405 Method Not Allowed 예외 처리
     * 잘못된 HTTP 메서드 요청 시 경고 로그를 남기고 메인으로 리다이렉트
     */
    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    public String handleMethodNotSupported(HttpRequestMethodNotSupportedException e, HttpServletRequest request) {
        log.warn("잘못된 요청 감지 (405): {} {}", request.getMethod(), request.getRequestURI());
        return "redirect:/"; // 메인 페이지로 이동
    }

    // 업로드 도중 연결이 끊겼을 때 긴 스택 트레이스 없이 한 줄 로그만 남김
    @ExceptionHandler(MultipartException.class)
    public void handleMultipartException(MultipartException e) {
        log.warn(">>> [비정상 접근] Multipart 요청 처리 중 연결이 끊겼습니다: {}", e.getMessage());
        // 특별히 클라이언트에게 뭘 리턴할 필요 없이 무시하면 됩니다. (어차피 클라이언트가 먼저 도망간 상태임)
    }

}