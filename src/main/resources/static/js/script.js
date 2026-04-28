/**
 * [공통] 브라우저 기본 Alert 오버라이딩
 * 기본 alert() 호출 시 커스텀 팝업(showPopup)이 뜨도록 변경
 * 사용법: alert('메시지', function() { 페이지이동 등 후속작업 });
 */
const nativeAlert = window.alert; // 기본 alert 백업

window.alert = function(message, callback) {
    // showPopup 함수가 정의되어 있으면(popup.jsp가 include된 페이지면) 커스텀 팝업 사용
    if (typeof showPopup === 'function') {

        // 줄바꿈 문자(\n)를 HTML 태그(<br>)로 자동 변환
        let msgHtml = message;
        if (typeof message === 'string') {
            msgHtml = message.replace(/\n/g, '<br>');
        }

        showPopup('alert', msgHtml, callback);
    } else {
        // popup.jsp가 없는 페이지라면 기본 alert 사용
        nativeAlert(message);
        if (callback) callback();
    }
};

// [옵션] Confirm도 커스텀으로 쓰고 싶다면 아래 함수 사용 (기존 confirm은 동기식이라 오버라이딩 불가)
window.customConfirm = function(message, callback, cancelCallback) {
    if (typeof showPopup === 'function') {

        // Confirm 메시지도 줄바꿈 처리
        let msgHtml = message;
        if (typeof message === 'string') {
            msgHtml = message.replace(/\n/g, '<br>');
        }

        // showPopup이 취소 콜백을 4번째 인자로 지원한다고 가정 (또는 수정 필요)
        showPopup('confirm', msgHtml, callback, cancelCallback);
    } else {
        if(confirm(message)) {
            if(callback) callback();
        } else {
            // 기본 confirm에서 취소 시 실행
            if(cancelCallback) cancelCallback();
        }
    }
};

// ios 높이 대응
function setVH() {
  document.documentElement.style.setProperty('--vh', (window.innerHeight * 0.01) + 'px');
}
setVH();
window.addEventListener('resize', setVH);

// 로그인
const form = document.getElementById('loginForm');
const btn = document.getElementById('loginBtn');

const idInput = document.getElementById('loginId');
const pwInput = document.getElementById('loginPw');
const pwConfirmInput = document.getElementById('loginPwConfirm');

const idField = idInput ? idInput.closest('.login-field') : null;
const pwField = pwInput ? pwInput.closest('.login-field') : null;

const pwConfirmField = pwConfirmInput ? pwConfirmInput.closest('.login-field') : null;

const togglePw = document.getElementById('togglePw');
const togglePwCheck = document.getElementById('togglePwCheck');

const currentPasswordInput = document.getElementById('currentPassword');
const togglePwBasic = document.getElementById('togglePwBasic');

const newPasswordInput = document.getElementById('newPassword');
const toggleNewPwBasic = document.getElementById('toggleNewPwBasic');

const confirmPasswordInput = document.getElementById('confirmPassword');
const toggleConfPwBasic = document.getElementById('toggleConfPwBasic');

const joinBtn = document.getElementById('joinBtn');
const loginMessage = document.getElementById('loginMessage');

function clearFormErrorUI(config) {
    const { fields, messageEl } = config || {};

    if (fields) {
        Object.values(fields).forEach(el => {
            if (el) el.classList.remove('is-error');
        });
    }

    if (messageEl) {
        messageEl.textContent = '';
        messageEl.className = 'login-message';
        messageEl.classList.remove('is-show', 'is-error');
    }
}

function showFormErrorUI(config, { message = '', errorFields = [] } = {}) {
    const { fields, messageEl } = config || {};

    if (fields) {
        Object.entries(fields).forEach(([name, el]) => {
        if (!el) return;
            el.classList.toggle('is-error', errorFields.includes(name));
        });
    }

    if (messageEl && message) {
        messageEl.textContent = message;
            messageEl.classList.add('is-show', 'is-error');
    }
}

const LOGIN_UI = {
    fields: {
        loginId: idField,
        loginPw: pwField,
        loginPwConfirm: pwConfirmField
    },
    messageEl: loginMessage
};

function clearLoginErrorUI() {
    clearFormErrorUI(LOGIN_UI);
}

function showLoginErrorUI({ message = '', errorFields = [] }) {
    showFormErrorUI(LOGIN_UI, { message, errorFields });
}


function setupPasswordToggle(inputEl, btnEl) {
    if (!inputEl || !btnEl) return;
        const img = btnEl.querySelector('img');
    if (!img) return;

    btnEl.addEventListener('click', () => {
        const isHidden = inputEl.type === 'password';

        inputEl.type = isHidden ? 'text' : 'password';

        img.src = isHidden ? '/img/pass_on.svg' : '/img/pass_off.svg';

        img.alt = isHidden ? '비밀번호 숨김' : '비밀번호 보기';
        btnEl.setAttribute('aria-label', isHidden ? '비밀번호 숨김' : '비밀번호 표시');
    });
}

setupPasswordToggle(currentPasswordInput, togglePwBasic);
setupPasswordToggle(newPasswordInput, toggleNewPwBasic);
setupPasswordToggle(confirmPasswordInput, toggleConfPwBasic);

setupPasswordToggle(pwInput, togglePw);
setupPasswordToggle(pwConfirmInput, togglePwCheck);

// 로그인폼
/*if (form && btn) {
    form.addEventListener('submit', async (e) => {
        e.preventDefault();

        clearLoginErrorUI();

        btn.classList.add('is-loading');
        btn.disabled = true;

        await new Promise(r => setTimeout(r, 700));

        const serverResponse = {
            success: false,
            message: '입력하신 정보를 다시 확인해 주세요.',
            error_fields: ['loginId', 'loginPw']
        };

        btn.classList.remove('is-loading');
        btn.disabled = false;

        if (serverResponse.success) return;

        showLoginErrorUI({
        message: serverResponse.message,
        errorFields: serverResponse.error_fields || []
        });

        const first = (serverResponse.error_fields || [])[0];
        if (first === 'loginId' && idInput) idInput.focus();
        if (first === 'loginPw' && pwInput) pwInput.focus();
    });
}*/

// 인증번호 입력 6자리
const numberCert = document.getElementById('number_cert');
const certCheckIcon = document.getElementById('certCheckIcon');

if (numberCert && certCheckIcon) {
    numberCert.addEventListener('input', () => {
        const v = numberCert.value.trim();

        if (v.length === 6) {
        certCheckIcon.classList.add('is-show');
        } else {
        certCheckIcon.classList.remove('is-show');
        }
    });
}

const keyRadios = document.querySelectorAll('.car-info_box .btn_wrap input');

if (keyRadios.length && typeof enableNext === 'function') {
    keyRadios.forEach(radio => {
        radio.addEventListener('change', () => {
            enableNext();
        });
    });
}

document.body.classList.add('is-loading');

// API 완료 후
document.body.classList.remove('is-loading');


// 회원가입 동의하기
document.addEventListener('DOMContentLoaded', () => {
    const agreeAll = document.getElementById('agreeAll');
    const items = document.querySelectorAll('.agree-item');
    const nextBtn = document.getElementById('termsNext');

    if (!agreeAll || !items.length || !nextBtn) return;

    function updateStateFromItems() {
        // 모든 항목이 체크됐는지
        const allChecked = Array.from(items).every(i => i.checked);
        agreeAll.checked = allChecked;

        // 필수 항목이 모두 체크됐는지
        const requiredOk = Array.from(items)
        .filter(i => i.dataset.required === 'true')
        .every(i => i.checked);

        nextBtn.disabled = !requiredOk;
    }

    // 모두 동의 클릭 시 → 전체 동기화
    agreeAll.addEventListener('change', () => {
        const checked = agreeAll.checked;
        items.forEach(i => {
        i.checked = checked;
        });
        updateStateFromItems();
    });

    // 각 항목 변화 시 → 전체/다음버튼 상태 갱신
    items.forEach(i => {
        i.addEventListener('change', updateStateFromItems);
    });

    // 초기 상태 한 번 맞춰주기
    updateStateFromItems();

    // (옵션) 다음 버튼 클릭 시 값 확인
    nextBtn.addEventListener('click', () => {
        const result = {
            all: agreeAll.checked,
            service: document.getElementById('agreeService')?.checked || false,
            privacy: document.getElementById('agreePrivacy')?.checked || false,
            marketing: document.getElementById('agreeMarketing')?.checked || false
        };
        //console.log('약관 동의 상태:', result);
        // TODO: 서버 전송 or 다음 페이지 이동
    });
});

// 모달
document.addEventListener('DOMContentLoaded', () => {
    const sheetBackdrop = document.getElementById('selectSheet');
    const sheetTitleEl  = document.getElementById('selectSheetTitle');
    const sheetListEl   = document.getElementById('selectSheetList');
    const sheetApplyBtn = document.getElementById('selectSheetApply');
    const sheetCloseBtn = document.getElementById('selectSheetClose');
    const sheetCancelBtn = document.getElementById('selectSheetCancel');

    if (!sheetBackdrop || !sheetListEl || !sheetApplyBtn) return;

    let currentTrigger = null;
    let currentName    = '';
    let currentValue   = '';
    let tempValue      = '';

    function openSelectSheet() {
        sheetBackdrop.classList.add('is-open');
    }

    function closeSelectSheet() {
        sheetBackdrop.classList.remove('is-open');
        currentTrigger = null;
        currentName = '';
        currentValue = '';
        tempValue = '';
        sheetApplyBtn.disabled = true;
    }

    function renderOptions(options = []) {
        sheetListEl.innerHTML = '';

        const extraClass = currentTrigger?.dataset.selectClass || '';

        options.forEach(label => {
            const btn = document.createElement('button');
                btn.type = 'button';
                btn.className = `select-sheet_option ${extraClass}`;
                btn.dataset.value = label;
                btn.innerHTML = `<span>${label}</span>`;

                if (label === currentValue) {
                btn.classList.add('is-selected');
                tempValue = currentValue;
                sheetApplyBtn.disabled = false;
            }

            btn.addEventListener('click', () => {
                sheetListEl
                    .querySelectorAll('.select-sheet_option.is-selected')
                    .forEach(el => el.classList.remove('is-selected'));

                btn.classList.add('is-selected');
                tempValue = btn.dataset.value;
                sheetApplyBtn.disabled = false;
            });

            sheetListEl.appendChild(btn);
        });
    }

    document.querySelectorAll('.select-field').forEach(field => {
        field.addEventListener('click', () => {
        currentTrigger = field;

        currentName = field.dataset.selectName || '';
        if (!currentName) return;

        const optionList = SELECT_DATA[currentName] || [];
        const hiddenInput = document.querySelector(`input[name="${currentName}"]`);
        currentValue = hiddenInput?.value || '';

        if (sheetTitleEl) {
            sheetTitleEl.textContent = field.dataset.selectTitle || '항목 선택';
        }

        renderOptions(optionList);
        openSelectSheet();
        });
    });
    
    const SELECT_DATA = {
            game: [
                "[잠실 야구장] LG vs 두산 12. 08 18:30",
                "[잠실 야구장] LG vs 두산 12. 09 18:30",
                "[잠실 야구장] LG vs 두산 12. 10 18:30",
                "[잠실 야구장] LG vs 두산 12. 11 18:30",
                "[잠실 야구장] LG vs 두산 12. 12 18:30"
            ],

            ace: [
                "[LG트윈스] 김엘지1",
                "[LG트윈스] 김엘지2",
                "[LG트윈스] 김엘지3",
                "[LG트윈스] 김엘지4",
                "[LG트윈스] 김엘지5",
                "[LG트윈스] 김엘지6",
                "[LG트윈스] 김엘지7",
                "[LG트윈스] 김엘지8",
                "[LG트윈스] 김엘지9"
            ]
        };

    sheetApplyBtn.addEventListener('click', () => {
        if (!currentTrigger || !currentName || !tempValue) {
            closeSelectSheet();
            return;
        }

        const hiddenInput = document.querySelector(`input[name="${currentName}"]`);
        if (hiddenInput) hiddenInput.value = tempValue;

        const valueSpan = currentTrigger.querySelector('.select-field_value');
        if (valueSpan) {
        valueSpan.textContent = tempValue;
        valueSpan.classList.remove('is-placeholder');
        }

        closeSelectSheet();
    });

    sheetCloseBtn?.addEventListener('click', closeSelectSheet);

    sheetBackdrop.addEventListener('click', e => {
        if (e.target === sheetBackdrop) closeSelectSheet();
    });
    sheetCancelBtn?.addEventListener('click', () => {
    // 그냥 닫기만
    closeSelectSheet();
    });
});

// 팀선택
document.addEventListener('DOMContentLoaded', () => {
    const teamBtns = document.querySelectorAll('.team_info-btn');

    if (!teamBtns.length) return;

    teamBtns.forEach(btn => {
        btn.addEventListener('click', () => {

            teamBtns.forEach(b => b.classList.remove('is-select'));
                btn.classList.add('is-select');
        });
    });
});

// 친구 탭
document.addEventListener('DOMContentLoaded', () => {
    const tabs = document.querySelectorAll('.tab-pill_btn');
    const panels = document.querySelectorAll('.tab-panel');

    if (!tabs.length) return;

    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
        const key = tab.dataset.tab;

        tabs.forEach(t => {
            t.classList.remove('on');
            t.setAttribute('aria-selected', 'false');
        });

        tab.classList.add('on');
        tab.setAttribute('aria-selected', 'true');

        // 패널 전환
        if (panels.length) {
            panels.forEach(p => p.classList.toggle('on', p.dataset.panel === key));
        }
        });
    });
});


document.addEventListener('DOMContentLoaded', () => {
    const tabs = document.querySelectorAll('.tab_menu li');
    const conts = document.querySelectorAll('.tab_cont');

    if (!tabs.length || !conts.length) return;

    tabs.forEach((tab, idx) => {
        tab.addEventListener('click', () => {

            tabs.forEach(t => t.classList.remove('on'));
            conts.forEach(c => c.classList.remove('on'));

            tab.classList.add('on');
            if (conts[idx]) conts[idx].classList.add('on');
        });
    });
});

// 스와이퍼
if (document.querySelector('.swiperMainCnt')) {
    const swiperMainCnt = new Swiper('.swiperMainCnt', {
        slidesPerView: 'auto',
        spaceBetween: 20,
        direction: getDirection(),
        loop: true,
        speed: 700,
        preventClicks: false,
        preventClicksPropagation: false,
        autoHeight: false,
        navigation: {
            prevEl: '.swiperMainCntPrev',
            nextEl: '.swiperMainCntNext'
        },
        breakpoints: {
            1199: {
                spaceBetween: 0,
            },
        },
    });
}

function getDirection() {
    var windowWidth = window.innerWidth;
    var direction = window.innerWidth <= 0 ? 'vertical' : 'horizontal';

    return direction;
}

document.addEventListener('DOMContentLoaded', () => {

    const moreBtn = document.querySelector('.more-btn');
    const diaryDesc = document.querySelector('.diary_desc');

    if(!moreBtn || !diaryDesc) return;

    moreBtn.addEventListener('click', () => {

        diaryDesc.classList.toggle('is-open');

        if(diaryDesc.classList.contains('is-open')){
            moreBtn.textContent = '- 일기 숨기기';
        }else{
            moreBtn.textContent = '+ 일기 전체보기';
        }

    });

});