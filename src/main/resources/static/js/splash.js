/**
 * splash.js
 * 앱 초기 실행 및 버전/점검 체크 로직
 */

document.addEventListener('DOMContentLoaded', async () => {
    // 스크롤 방지
    document.body.classList.add('no-scroll');

    // Appify가 로드되었는지 확인 (앱 환경 체크)
    if (typeof appify !== 'undefined' && appify.system && appify.system.os) {
        try {
            await checkAppStatus();
        } catch (error) {
            console.error("Status Check Error:", error);
            startSplashAnimation(); // 에러 시에도 앱 진입은 허용
        }
    } else {
        // 웹 브라우저 환경: 바로 스플래시 애니메이션 진행
        console.log("Web Environment: Skip app status check");
        startSplashAnimation();
    }
});

/**
 * 앱 점검 및 업데이트 상태 체크 API 호출 및 분기 처리
 */
async function checkAppStatus() {
    // 1. 현재 앱 정보 가져오기 (Appify SDK 활용)
    // 서버는 'AOS', 'IOS'를 기대하므로 매핑 처리
    const currentOs = appify.system.os === 'ios' ? 'IOS' : 'AOS';
    const currentBuild = appify.system.build || 0; // 빌드 번호 (int)

    console.log(`[App Info] OS: ${currentOs}, Build: ${currentBuild}`);

    // 2. 서버에 최신 상태(점검 여부, 버전 정보) 통합 요청
    try {
        const response = await $.ajax({
            url: '/api/v1/system/init',
            type: 'GET',
            data: { osType: currentOs, versionCode: currentBuild },
            dataType: 'json'
        });

        if (response) {
            // [1순위] 점검 모드 확인
            if (response.isMaintenance) {
                // 점검 시 경고창 띄우고 앱 강제 종료
                alert(response.maintenanceMessage || "현재 서버 점검 중입니다.\n이용에 불편을 드려 죄송합니다.");

                // Appify SDK 앱 종료 명령어
                if(typeof appify.app !== 'undefined' && appify.app.exit) {
                    appify.app.exit();
                }
                return; // 진입 차단 (함수 종료)
            }

            // [2순위] 앱 강제 업데이트 확인
            if (response.isForceUpdate) {
                // 커스텀 팝업(showPopup)으로 취소 불가능한 스토어 이동 유도
                showPopup({
                    title: '업데이트 안내',
                    msg: response.updateMessage || "더 나은 서비스를 위해 앱 업데이트가 필요합니다.",
                    btn: '업데이트 하러가기',
                    cancel: false // 취소 버튼 숨김 (닫기 불가)
                }, function() {
                    moveToStore(currentOs);
                });
                return; // 진입 차단
            }

            // [3순위] 선택 업데이트 확인
            if (response.isUpdateRequired) {
                showPopup({
                    title: '업데이트 안내',
                    msg: response.updateMessage || "새로운 버전이 출시되었습니다.",
                    btn: '업데이트',
                    cancel: true,
                    cancelBtn: '다음에 하기'
                }, function() {
                    // 확인 클릭 시 스토어 이동
                    moveToStore(currentOs);
                }, function() {
                    // 취소 클릭 시 -> 정상적으로 앱 진입
                    startSplashAnimation();
                });
                return;
            }

            // [4순위] 점검도 없고 최신 버전일 경우 -> 정상 진입
            startSplashAnimation();

        } else {
            // 서버 응답이 비정상일 경우 -> 앱 진입 허용
            startSplashAnimation();
        }
    } catch (e) {
        console.error("Init API Call Failed", e);
        startSplashAnimation();
    }
}

/**
 * 스플래시 애니메이션 및 로그인/메인 페이지 이동 로직
 */
function startSplashAnimation() {
    const splash = document.getElementById('splash');
    if (!splash) return;

    // 2.5초 후 페이드 아웃
    setTimeout(() => {
        splash.style.opacity = '0';

        // 0.3초 뒤(페이드 아웃 후) 요소 제거 및 페이지 이동
        setTimeout(() => {
            splash.style.display = 'none';
            document.body.classList.remove('no-scroll');

            // 애니메이션이 끝나면 로그인 페이지로 이동
            location.replace('/member/login');
        }, 300);
    }, 2500);
}

/**
 * 스토어 이동 함수
 */
function moveToStore(os) {
    if (os === 'AOS') {
        const packageId = 'com.byd';
        location.href = `market://details?id=${packageId}`;
    } else if (os === 'IOS') {
        // 실제 iOS 앱스토어 ID 입력 필요
        const appId = '123456789';
        location.href = `itms-apps://itunes.apple.com/app/id${appId}`;
    }
}

// 스크롤 방지 이벤트 리스너
document.addEventListener('touchmove', preventScroll, { passive: false });

function preventScroll(e) {
    if (document.body.classList.contains('no-scroll')) {
        e.preventDefault();
    }
}