/* ==========================================
   [Appify SDK] 초기화 및 푸시 토큰 연동
   ========================================== */
document.addEventListener('DOMContentLoaded', async function() {
    // 1. SDK 로드 여부 확인
    if (typeof appify === 'undefined') return;

    try {
        // [초기화] 디버그 모드 활성화 (개발 중: true, 배포 시: false 권장)
        await appify.initialize({
            debug: false,
            enableRefresh: true,
            hideScrollbar: true, // 스크롤바 숨김 처리로 네이티브 앱 느낌 부여
            bounces: false       // iOS 오버스크롤 바운스 방지
        });

        // 2. 앱 환경인지 확인
        if (appify.isWebview) {
            console.log("Appify 앱 환경 감지됨 📱");

            // [푸시 알림] 권한 확인 및 토큰 획득
            const isAllowed = await appify.notification.checkPermission();
            if (isAllowed) {
                const token = await appify.notification.getToken();
                if (token) {
                    updateServerToken(token); // 서버 전송
                }
            }
        }
    } catch (e) {
        console.error("Appify SDK 초기화 오류:", e);
    }
});

// [서버 통신] 토큰 DB 저장 (중복 호출 방지)
function updateServerToken(token) {
    // 기기 캐시(localStorage) 검사 로직 삭제!
    // 기기는 같아도 로그인한 유저가 다를 수 있으므로 앱 실행 시마다 무조건 서버 갱신을 시도합니다.
    // (서버의 /member/updateToken 컨트롤러에서 비로그인 상태면 알아서 차단해 주므로 안전합니다.)

    $.post('/member/updateToken', { token: token }, function(res) {
        if(res === 'ok') {
            localStorage.setItem("fcm_token", token);
        }
    });
}

/* ==========================================
   [Appify] 외부 링크 처리 (시스템 브라우저로 열기)
   ========================================== */
$(document).on('click', 'a', function(e) {
    const url = $(this).attr('href');

    // http로 시작하고, 우리 도메인이 아닌 경우 외부 브라우저로 열기
    if (url && (url.startsWith('http') || url.startsWith('https'))) {
        const isMyDomain = url.includes(window.location.host);

        if (!isMyDomain) {
            e.preventDefault();
            if (typeof appify !== 'undefined' && appify.isWebview) {
                appify.linking.inappBrowser(url);
            } else {
                window.open(url, '_blank');
            }
        }
    }
});

/* ==========================================
   [UX] 햅틱 피드백 (진동)
   ========================================== */
function vibrateSuccess() {
    // 짧게 한 번 진동 (안드로이드/iOS 웹뷰 지원 시 동작)
    if (navigator.vibrate) {
        navigator.vibrate(10); // 10ms (아주 짧게)
    }
}

function vibrateError() {
    // 실패 시 웅-웅 두 번
    if (navigator.vibrate) {
        navigator.vibrate([30, 50, 30]);
    }
}