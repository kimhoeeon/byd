<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!doctype html>
<html lang="ko">
<head>
    <meta name="naver-site-verification" content="07e0fdf4e572854d6fbe274f47714d3e7bbb9fbd" />
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" />
    <meta name="format-detection" content="telephone=no,email=no,address=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="mobile-web-app-capable" content="yes" />

    <meta property="og:type" content="website">
    <meta property="og:locale" content="ko_KR">
    <meta property="og:site_name" content="승요일기">
    <meta property="og:title" content="승요일기 | 야구 직관 기록 앱">
    <meta property="og:description" content="야구 직관 기록을 더 쉽고 재미있게! 경기 결과, 기록, 사진과 함께 나만의 야구 직관일기를 남겨보세요.">
    <meta name="keywords" content="승요일기 / 야구 직관 / 프로야구 직관 / 직관 후기 / 직관일기 / KBO / KBO 직관 / 프로야구 앱 / 야구팬 앱">
    <meta property="og:url" content="https://myseungyo.com/">
    <meta property="og:image" content="https://myseungyo.com/img/og_img.jpg">

    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="manifest" href="/site.webmanifest" />

    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">

    <title>약관 동의 | 승요일기</title>

    <style>
        /* 팝업 로딩 및 에러 메시지 스타일 */
        .is-loading-text {
            color: #999;
            text-align: center;
            padding: 40px 0;
            font-size: 14px;
        }
        /* 불러온 약관 내용 스타일 보정 */
        .fetched-policy-content {
            font-size: 14px;
            line-height: 1.6;
            color: #333;
            text-align: left;
        }
    </style>

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body class="page-login">

    <header class="app-header">
        <button class="app-header_btn app-header_back" type="button" onclick="location.href='/member/login'">
            <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
        </button>
    </header>

    <div class="page-login_wrap">
        <div class="login-card">
            <div class="login">
                <img src="/img/ico_check.svg" alt="체크이미지">
                <div class="login-txt">
                    <h1 class="login_title">서비스 이용을 위한 동의 안내</h1>
                    <p class="login_desc">서비스 이용에 꼭 필요한 사항입니다.<br />정책 및 약관을 클릭해 모든 내용을 확인해 주세요.</p>
                </div>
            </div>

            <div class="login-form gap-50">
                <div class="agree-field_wrap">
                    <div class="agree-field">
                        <div class="terms-all">
                            <label class="terms-check">
                                <input type="checkbox" id="agreeAll">
                                <span class="terms-check_box" aria-hidden="true"></span>
                                <span class="terms-check_label">
                                        모두 동의합니다
                                    </span>
                            </label>
                        </div>
                        <ul class="terms-list">

                            <li class="terms-item">
                                <label class="terms-check">
                                    <input type="checkbox" class="agree-item" data-required="true" id="agreeService">
                                    <span class="terms-check_box" aria-hidden="true"></span>
                                    <span class="terms-check_label">
                                            [필수] 서비스 이용약관 동의
                                        </span>
                                </label>
                                <button type="button" class="btn-open-terms" data-terms="service" data-title="서비스 이용약관">
                                    <img src="/img/ico_back_arrow.svg" alt="약관 보기">
                                </button>
                            </li>

                            <li class="terms-item">
                                <label class="terms-check">
                                    <input type="checkbox" class="agree-item" data-required="true" id="agreePrivacy">
                                    <span class="terms-check_box" aria-hidden="true"></span>
                                    <span class="terms-check_label">
                                            [필수] 개인정보 처리방침 동의
                                        </span>
                                </label>
                                <button type="button" class="btn-open-terms" data-terms="privacy" data-title="개인정보 처리방침">
                                    <img src="/img/ico_back_arrow.svg" alt="약관 보기">
                                </button>
                            </li>

                            <li class="terms-item">
                                <label class="terms-check">
                                    <input type="checkbox" class="agree-item" data-required="false" id="agreeLocation">
                                    <span class="terms-check_box" aria-hidden="true"></span>
                                    <span class="terms-check_label">
                                            [선택] 위치정보 이용약관 동의
                                        </span>
                                </label>
                                <button type="button" class="btn-open-terms" data-terms="location" data-title="위치정보 이용약관">
                                    <img src="/img/ico_back_arrow.svg" alt="약관 보기">
                                </button>
                            </li>

                        </ul>
                    </div>
                </div>
                <div class="login-bottom">
                    <div class="login-actions">
                        <button class="join-btn btn-primary" id="termsNext" disabled onclick="goNext()">
                            다음
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="center-popup-backdrop terms" id="centerPopup">
        <div class="center-popup">
            <div class="center-popup_body">
                <div class="center-popup_title" id="centerPopupTitle"></div>
                <div class="center-popup_txt terms-txt" id="centerPopupTxt"></div>
            </div>
            <div class="one_btn">
                <button type="button" class="btn btn-primary st2" data-popup="center-confirm" onclick="closePopup()">
                    확인
                </button>
            </div>
        </div>
    </div>

    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>

    <script>
        // [세션 관리] 로그인 페이지에서 직접 왔을 때만 초기화
        // 소셜 로그인 콜백(appleLoginCallback, kakao/callback)에서 온 경우는 유지해야 함
        const ref = document.referrer;
        const isSocialCallback = ref.indexOf('appleLoginCallback') > -1 || ref.indexOf('kakao/callback') > -1;

        if (ref.indexOf('/member/login') > -1 || (ref.indexOf('/member/join') === -1 && !isSocialCallback)) {
            // 소셜 콜백에서 온 게 아닐 때만 삭제
            sessionStorage.clear();
        }

        // [기능 1] 다음 단계 이동
        function goNext() {
            // 선택 약관 체크 여부 확인
            const isLocationAgreed = document.getElementById('agreeLocation').checked;

            // 데이터 저장 (세션 스토리지)
            sessionStorage.setItem('join_agree', 'Y');
            sessionStorage.setItem('join_marketing', isLocationAgreed ? 'Y' : 'N'); // DB 컬럼명에 맞춰 마케팅으로 저장하되 내용은 위치정보

            const joinProvider = sessionStorage.getItem('join_provider');
            //const savedEmail = sessionStorage.getItem('join_email');

            // 소셜 가입자(APPLE, KAKAO)이고 이메일이 세션에 있다면
            // Step 2(이메일 입력)를 건너뛰고 Step 3(비밀번호 입력)으로 바로 이동
            if (joinProvider && (joinProvider === 'KAKAO' || joinProvider === 'APPLE')) {
                //if (savedEmail && savedEmail !== 'null' && savedEmail.trim() !== '') {
                    location.href = '/member/join/step4';
                    return;
                //}
            }

            location.href = '/member/join/step2';
        }

        // [기능 2] 약관 팝업 열기 (AJAX)
        document.addEventListener('DOMContentLoaded', () => {
            const popupBackdrop = document.getElementById('centerPopup');
            const popupTitle = document.getElementById('centerPopupTitle');
            const popupContent = document.getElementById('centerPopupTxt');
            const openBtns = document.querySelectorAll('.btn-open-terms');

            openBtns.forEach(btn => {
                btn.addEventListener('click', () => {
                    const type = btn.dataset.terms;
                    const title = btn.dataset.title;
                    let url = '';

                    // Controller 매핑 확인
                    if (type === 'service') url = '/policy/terms';
                    else if (type === 'privacy') url = '/policy/privacy';
                    else if (type === 'location') url = '/policy/location';

                    popupTitle.textContent = title;
                    popupContent.innerHTML = '<div class="is-loading-text">내용을 불러오는 중입니다...</div>';

                    // 팝업 노출
                    popupBackdrop.classList.add('is-open');
                    popupBackdrop.style.display = 'flex'; // base.css에 정의된 flex 사용

                    // AJAX 호출
                    if (url) {
                        $.get(url, function(data) {
                            // 전체 HTML에서 .policy-content 클래스만 추출
                            const parser = new DOMParser();
                            const doc = parser.parseFromString(data, 'text/html');
                            const content = doc.querySelector('.terms_wrap');

                            if (content) {
                                // 추출한 내용에 클래스 추가하여 스타일 적용
                                content.classList.add('fetched-policy-content');
                                popupContent.innerHTML = '';
                                popupContent.appendChild(content);
                            } else {
                                popupContent.innerHTML = '<div class="is-loading-text">약관 내용을 찾을 수 없습니다.</div>';
                            }
                        }).fail(function() {
                            popupContent.innerHTML = '<div class="is-loading-text">내용을 불러오는데 실패했습니다.<br>잠시 후 다시 시도해주세요.</div>';
                        });
                    }
                });
            });

            // 팝업 닫기 (배경 클릭)
            popupBackdrop.addEventListener('click', (e) => {
                if (e.target === popupBackdrop) closePopup();
            });
        });

        function closePopup() {
            const popupBackdrop = document.getElementById('centerPopup');
            popupBackdrop.classList.remove('is-open');
            popupBackdrop.style.display = 'none';
        }

        // [기능 3] 체크박스 전체 동의 및 버튼 활성화 로직
        document.addEventListener('DOMContentLoaded', () => {
            const agreeAll = document.getElementById('agreeAll');
            const items = document.querySelectorAll('.agree-item');
            const nextBtn = document.getElementById('termsNext');

            function updateState() {
                // 전체 체크 여부
                const allChecked = Array.from(items).every(i => i.checked);
                if(agreeAll) agreeAll.checked = allChecked;

                // 필수 항목 체크 여부 (data-required="true")
                const requiredOk = Array.from(items)
                    .filter(i => i.dataset.required === 'true')
                    .every(i => i.checked);

                if(nextBtn) nextBtn.disabled = !requiredOk;
            }

            // 전체 동의 클릭
            if(agreeAll) {
                agreeAll.addEventListener('change', () => {
                    items.forEach(i => i.checked = agreeAll.checked);
                    updateState();
                });
            }

            // 개별 항목 클릭
            items.forEach(i => i.addEventListener('change', updateState));

            // 초기 상태 실행
            updateState();
        });
    </script>
</body>
</html>