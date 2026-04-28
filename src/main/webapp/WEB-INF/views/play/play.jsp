<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

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

    <title>경기 | 승요일기</title>

    <style>
        /* 팝업 및 공통 스타일 */
        .popup-dim {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.6);
            z-index: 1000;
            display: none;
        }
        .popup-box {
            background: #fff; width: 90%; max-width: 320px;
            border-radius: 16px; padding: 24px;
            box-sizing: border-box;
            position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);
        }
        .popup-head { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .popup-tit { font-size: 18px; font-weight: 700; color: #111; }
        .popup-close { width: 24px; height: 24px; padding: 0; border: none; background: none; cursor: pointer; }
        .popup-close img { width: 100%; height: 100%; }

        .team-select-btn {
            width: 100%; height: 48px; border-radius: 12px;
            border: 1px solid #ddd; background: #fff;
            font-size: 16px; font-weight: 600; color: #999; cursor: pointer;
        }
        .team-select-btn.active {
            border-color: #FF2F32; color: #FF2F32; background: #FFF0F0;
        }

        .team img { width: 48px; height: 48px; object-fit: contain; display: block; margin: 0 auto; }
        .team::before { display: none !important; }
        .sheet-backdrop { display: none; align-items: flex-end; justify-content: center; }
        .sheet-backdrop.is-open { display: flex; }
        .month-match.is-show { display: block; }
        .no-data { text-align: center; padding: 40px 0; color: #999; }

        .game-sub-info { font-size: 12px; color: #888; margin-top: 4px; text-align: center; }
        .cancel-reason { font-size: 12px; color: #FF2F32; margin-top: 4px; text-align: center; font-weight: 500;}
        .pitcher-name { font-size: 11px; color: #666; display: block; margin-top: 2px; text-align: center;}

        /* 승리 팀 스타일 */
        .team.win .team-name {
            font-weight: 700;
            color: #000;
        }
        .team.win img {
            border: 2px solid #FF2F32; /* 승리 팀 로고 테두리 강조 (선택사항) */
            border-radius: 50%;
        }
        .left-team-score.high, .right-team-score.high {
            color: #FF2F32; /* 높은 점수 빨간색 강조 */
            font-weight: 800;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
</head>

<body>
    <div class="app">
        <div class="top_wrap">
            <div class="main-top">
                <div class="main-title">
                    경기
                    <%--<span id="userName">${sessionScope.loginMember.nickname}</span>님--%>
                </div>

                <button class="noti-btn ${hasUnreadAlarm ? 'has-badge' : ''}" onclick="location.href='/alarm/list'">
                    <span class="noti-btn_icon" aria-hidden="true"><img src="/img/ico_noti.svg" alt="알림 아이콘"></span>
                    <span class="noti-dot" aria-hidden="true"></span>
                </button>
            </div>
        </div>

        <div class="app-main">
            <div class="page-main_wrap">
                <div class="history">

                    <div class="card schedule-picker">
                        <div class="schedule-header">
                            <button type="button" class="week-btn" id="prevWeek" aria-label="저번 주">
                                <img src="/img/picker_prev.svg" alt="저번 주">
                            </button>
                            <div class="week-label" id="weekLabel"></div>
                            <button type="button" class="week-btn" id="nextWeek" aria-label="다음 주">
                                <img src="/img/picker_next.svg" alt="다음 주">
                            </button>
                            <button class="picker-popup" id="pickerPopupBtn">
                                <img src="/img/ico_picker.svg" alt="달력 모달">
                            </button>
                        </div>

                        <div class="schedule-weekdays">
                            <span>일</span><span>월</span><span>화</span><span>수</span><span>목</span><span>금</span><span>토</span>
                        </div>
                        <div class="schedule-grid" id="dateGrid"></div>
                        <input type="hidden" id="selectedDate" value="${today}">
                    </div>

                    <div class="sheet-backdrop" id="monthPickerSheet">
                        <div class="sheet month-sheet" role="dialog" aria-modal="true" aria-labelledby="monthSheetTitle">
                            <div class="month-sheet_header">
                                <button type="button" class="month-sheet_close" id="monthCloseBtn" aria-label="닫기">
                                    <img src="/img/ico_close.svg" alt="닫기">
                                </button>
                            </div>
                            <div class="month-sheet_nav">
                                <button type="button" class="month-nav_btn" id="monthPrev" aria-label="이전 달"><img src="/img/picker_prev.svg" alt="이전 달"></button>
                                <div class="month-label" id="monthLabel"></div>
                                <button type="button" class="month-nav_btn" id="monthNext" aria-label="다음 달"><img src="/img/picker_next.svg" alt="다음 달"></button>
                            </div>
                            <div class="month-weekdays">
                                <span class="sun">일</span><span>월</span><span>화</span><span>수</span><span>목</span><span>금</span><span class="sat">토</span>
                            </div>
                            <div class="month-grid-wrap"><div class="month-grid" id="monthGrid"></div></div>
                            <div class="match-notice">날짜를 선택하면 그날의 경기를 볼 수 있어요.</div>
                            <div class="month-match">
                                <div class="month-match_label" id="monthMatchLabel">오늘의 경기</div>
                                <div class="month-match_text" id="monthMatchText"></div>
                            </div>
                            <div class="month-sheet_footer">
                                <button type="button" class="btn btn-primary" id="monthApplyBtn" disabled>보기</button>
                            </div>
                        </div>
                    </div>

                    <div class="history-list">
                        <label class="check myTeam_check">
                            <input type="checkbox" name="myTeam" id="myTeam" onchange="filterMyTeam()" />
                            우리팀만 보기
                        </label>

                        <div class="card_wrap play_wrap gap-16" id="gameListArea">
                            <div class="no-data" style="padding: 20px;">
                                <div class="nodt_tit">경기 정보를 불러오는 중...</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="../include/tabbar.jsp" %>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
    <script>
        const MY_TEAM_CODE = "${sessionScope.loginMember.myTeamCode}";

        function handleLogoError(img, teamCode) {
            const localPath = `/img/logo/logo_\${teamCode}.svg`;
            if (img.getAttribute('data-tried') === 'local') {
                img.onerror = null;
                img.src = '/img/team_default.svg';
            } else {
                img.setAttribute('data-tried', 'local');
                img.src = localPath;
            }
        }

        // 캘린더 로직 (IIFE)
        (function() {
            const weekLabelEl = document.getElementById('weekLabel');
            const dateGridEl = document.getElementById('dateGrid');
            const selectedInput = document.getElementById('selectedDate');
            const pickerPopupBtn = document.getElementById('pickerPopupBtn');
            const prevWeekBtn = document.getElementById('prevWeek');
            const nextWeekBtn = document.getElementById('nextWeek');

            const monthSheetBackdrop = document.getElementById('monthPickerSheet');
            const monthCloseBtn = document.getElementById('monthCloseBtn');
            const monthPrevBtn = document.getElementById('monthPrev');
            const monthNextBtn = document.getElementById('monthNext');
            const monthLabelEl = document.getElementById('monthLabel');
            const monthGridEl = document.getElementById('monthGrid');
            const monthApplyBtn = document.getElementById('monthApplyBtn');
            const monthMatchBox = document.querySelector('.month-match');
            const monthMatchText = document.getElementById('monthMatchText');

            let currentWeekDate = new Date();
            let monthCursor = new Date();
            let popupSelectedDateStr = '';

            const monthlyScheduleCache = {};

            function formatYMD(date) {
                const y = date.getFullYear();
                const m = String(date.getMonth() + 1).padStart(2, '0');
                const d = String(date.getDate()).padStart(2, '0');
                return `\${y}-\${m}-\${d}`;
            }
            function parseYMD(str) {
                if (!str) return null;
                const parts = str.split('-');
                return new Date(parts[0], parts[1] - 1, parts[2]);
            }
            function getSundayOfWeek(date) {
                const copy = new Date(date);
                const dow  = copy.getDay();
                copy.setDate(copy.getDate() - dow);
                return copy;
            }
            function getWeekLabel(date) {
                const year  = date.getFullYear();
                const month = date.getMonth();
                const day   = date.getDate();
                const yy = String(year).slice(-2);
                const firstOfMonth = new Date(year, month, 1);
                const firstDow     = firstOfMonth.getDay();
                const weekIndex = Math.floor((firstDow + day - 1) / 7) + 1;
                return `\${yy}년 \${month + 1}월 \${weekIndex}주`;
            }

            function renderWeekView() {
                if (!weekLabelEl || !dateGridEl) return;
                weekLabelEl.textContent = getWeekLabel(currentWeekDate);
                dateGridEl.innerHTML = '';
                const sunday = getSundayOfWeek(currentWeekDate);
                const selectedStr = selectedInput.value || formatYMD(new Date());
                for (let i = 0; i < 7; i++) {
                    const d = new Date(sunday);
                    d.setDate(sunday.getDate() + i);
                    const ymd = formatYMD(d);
                    const span = document.createElement('span');
                    span.className = 'schedule-day';
                    span.textContent = d.getDate();
                    span.dataset.date = ymd;
                    if (ymd === selectedStr) span.classList.add('is-selected');
                    span.addEventListener('click', () => {
                        selectedInput.value = ymd;
                        const activeEl = dateGridEl.querySelector('.schedule-day.is-selected');
                        if(activeEl) activeEl.classList.remove('is-selected');
                        span.classList.add('is-selected');
                        loadGames(ymd);
                    });
                    dateGridEl.appendChild(span);
                }
            }

            function renderMonthView() {
                const year = monthCursor.getFullYear();
                const month = monthCursor.getMonth();

                monthLabelEl.textContent = `\${year}년 \${month + 1}월`;
                monthGridEl.innerHTML = '';

                const firstDay = new Date(year, month, 1);
                const firstDow = firstDay.getDay();
                const lastDay = new Date(year, month + 1, 0).getDate();
                const todayStr = formatYMD(new Date());
                for (let i = 0; i < firstDow; i++) monthGridEl.appendChild(document.createElement('div'));
                for (let d = 1; d <= lastDay; d++) {
                    const btn = document.createElement('button');
                    btn.type = 'button';
                    btn.className = 'month-day';
                    btn.textContent = d;

                    const ymd = formatYMD(new Date(year, month, d));
                    btn.dataset.date = ymd;
                    if (ymd === todayStr) btn.classList.add('is-today');
                    if (ymd === popupSelectedDateStr) btn.classList.add('is-selected');
                    btn.addEventListener('click', () => {
                        const prev = monthGridEl.querySelector('.month-day.is-selected');
                        if(prev) prev.classList.remove('is-selected');
                        btn.classList.add('is-selected');

                        popupSelectedDateStr = ymd;
                        monthApplyBtn.disabled = false;
                        updateMonthMatchInfo(ymd);
                    });
                    monthGridEl.appendChild(btn);
                }

                loadMonthlyDots(year, month + 1);
            }

            function loadMonthlyDots(year, month) {
                const cacheKey = `\${year}-\${month}`;

                if (monthlyScheduleCache[cacheKey]) {
                    applyDotsToCalendar(monthlyScheduleCache[cacheKey]);
                    return;
                }

                $.get('/play/monthly-schedule', { year: year, month: month }, function(dates) {
                    if (dates) {
                        monthlyScheduleCache[cacheKey] = dates;
                        applyDotsToCalendar(dates);
                    }
                });
            }

            function applyDotsToCalendar(dateList) {
                dateList.forEach(dateStr => {
                    const btn = monthGridEl.querySelector(`.month-day[data-date="\${dateStr}"]`);
                    if (btn) {
                        btn.classList.add('is-mark');
                    }
                });
            }

            // =======================================================================
            // 캘린더 일자 클릭 시 하단 팝업에 경기 목록을 렌더링하는 함수
            // 1. AJAX 통신으로 데이터를 받아옴
            // 2. 퍼블리싱 원본 레이아웃(로고-vs-로고) 적용 및 엑스박스 방어 (시간, 뱃지 제외)
            // =======================================================================
            function updateMonthMatchInfo(dateStr) {
                const monthMatchText = document.getElementById('monthMatchText');
                const monthMatchBox = document.querySelector('.month-match');
                if (!monthMatchText) return;

                // 로딩 중 UI 표시
                monthMatchText.innerHTML = '<div style="padding:10px; text-align:center; color:#888;">경기 정보를 불러오는 중...</div>';
                monthMatchBox.classList.add('is-show');

                // 선택한 날짜의 경기 데이터를 서버에서 가져옴
                $.get('/play/games', { date: dateStr }, function(games) {
                    if (games && games.length > 0) {
                        // 퍼블리싱 원본 <ul> 클래스 적용
                        let html = '<ul class="month-match_list">';

                        games.forEach(function(game) {
                            // 1. 구단 로고 세팅 및 이미지 깨짐 방어 로직
                            const awayCodeLower = (game.awayTeamCode || '').toLowerCase();
                            const homeCodeLower = (game.homeTeamCode || '').toLowerCase();

                            let awayLogo = game.awayTeamLogo ? game.awayTeamLogo : '/img/logo/logo_' + awayCodeLower + '.svg';
                            let homeLogo = game.homeTeamLogo ? game.homeTeamLogo : '/img/logo/logo_' + homeCodeLower + '.svg';

                            // 2. 퍼블리싱된 순정 HTML 구조(DOM) 생성
                            html += '<li class="month-match_item">';

                            // [원정팀 로고]
                            html += '<div class="month-match_team"><img src="' + awayLogo + '" alt="' + game.awayTeamName + '" onerror="this.src=\'/img/team_default.svg\'"></div>';

                            // [가운데 VS 마크]
                            html += '<div class="month-match_vs">vs</div>';

                            // [홈팀 로고]
                            html += '<div class="month-match_team"><img src="' + homeLogo + '" alt="' + game.homeTeamName + '" onerror="this.src=\'/img/team_default.svg\'"></div>';

                            html += '</li>';
                        });

                        html += '</ul>';
                        monthMatchText.innerHTML = html; // 팝업 내 렌더링

                    } else {
                        // 경기가 없을 경우의 UI
                        monthMatchText.innerHTML = '<div style="color:#999;">해당 날짜에는 등록된 경기가 없습니다.</div>';
                    }
                }).fail(function() {
                    monthMatchText.innerHTML = '<div style="color:var(--color-danger, #ff4d4d);">데이터를 불러오는데 실패했습니다.</div>';
                });
            }

            pickerPopupBtn.addEventListener('click', () => {
                const base = parseYMD(selectedInput.value) || new Date();
                monthCursor = new Date(base.getFullYear(), base.getMonth(), 1);
                popupSelectedDateStr = selectedInput.value;
                renderMonthView();

                monthSheetBackdrop.classList.add('is-open');

                if (popupSelectedDateStr) {
                    updateMonthMatchInfo(popupSelectedDateStr);
                    monthApplyBtn.disabled = false;
                }
            });
            monthCloseBtn.addEventListener('click', () => monthSheetBackdrop.classList.remove('is-open'));
            monthPrevBtn.addEventListener('click', () => { monthCursor.setMonth(monthCursor.getMonth() - 1); renderMonthView(); });
            monthNextBtn.addEventListener('click', () => { monthCursor.setMonth(monthCursor.getMonth() + 1); renderMonthView(); });
            monthApplyBtn.addEventListener('click', () => {
                if(!popupSelectedDateStr) return;
                selectedInput.value = popupSelectedDateStr;
                currentWeekDate = parseYMD(popupSelectedDateStr);
                renderWeekView();
                loadGames(popupSelectedDateStr);
                monthSheetBackdrop.classList.remove('is-open');
            });
            function moveWeekAndSelectMonday(direction) {
                currentWeekDate.setDate(currentWeekDate.getDate() + (direction * 7));
                const sunday = getSundayOfWeek(currentWeekDate);
                const monday = new Date(sunday);
                monday.setDate(sunday.getDate() + 1);

                const monStr = formatYMD(monday);
                selectedInput.value = monStr;

                renderWeekView();
                loadGames(monStr);
            }

            prevWeekBtn.addEventListener('click', () => moveWeekAndSelectMonday(-1));
            nextWeekBtn.addEventListener('click', () => moveWeekAndSelectMonday(1));

            const initD = parseYMD(selectedInput.value);
            if(initD) currentWeekDate = initD;
            renderWeekView();
        })();

        // AJAX 경기 목록 로드
        let cachedGames = [];

        function loadGames(dateStr) {
            $.get('/play/games', { date: dateStr }, function(data) {
                cachedGames = data || [];
                renderGameList();
            });
        }

        function filterMyTeam() {
            const isChecked = $('#myTeam').is(':checked');
            localStorage.setItem('myTeamOnly', isChecked);
            renderGameList();
        }

        function renderGameList() {
            const list = $('#gameListArea');
            list.empty();

            const isMyTeamOnly = $('#myTeam').is(':checked');
            let games = cachedGames;

            if (isMyTeamOnly) {
                games = games.filter(g => g.homeTeamCode === MY_TEAM_CODE || g.awayTeamCode === MY_TEAM_CODE);
            }

            if (games.length === 0) {
                list.html('<div class="no-data"><div class="nodt_tit">해당 날짜에는 등록된 경기가 없습니다.</div></div>');
                return;
            }

            games.forEach(game => {
                const homeCodeLower = (game.homeTeamCode || '').toLowerCase();
                const awayCodeLower = (game.awayTeamCode || '').toLowerCase();
                const homeSrc = game.homeTeamLogo ? game.homeTeamLogo : `/img/logo/logo_\${homeCodeLower}.svg`;
                const awaySrc = game.awayTeamLogo ? game.awayTeamLogo : `/img/logo/logo_\${awayCodeLower}.svg`;

                let cancelReasonHtml = '';
                if(game.status === 'CANCELLED' && game.cancelReason) {
                    cancelReasonHtml = `<div class="cancel-reason">(\${game.cancelReason})</div>`;
                }

                let homeStarterHtml = '';
                let awayStarterHtml = '';
                if(game.status !== 'CANCELLED' && game.status !== 'FINISHED') {
                    if(game.homeStarter) homeStarterHtml = `<div class="pitcher-name">\${game.homeStarter}</div>`;
                    if(game.awayStarter) awayStarterHtml = `<div class="pitcher-name">\${game.awayStarter}</div>`;
                }

                let winClassHome = (game.status === 'FINISHED' && game.scoreHome > game.scoreAway) ? 'win' : '';
                let winClassAway = (game.status === 'FINISHED' && game.scoreAway > game.scoreHome) ? 'win' : '';

                let myTeamBadgeHome = (game.homeTeamCode === MY_TEAM_CODE) ? '<div class="my-team">MY</div>' : '';
                let myTeamBadgeAway = (game.awayTeamCode === MY_TEAM_CODE) ? '<div class="my-team">MY</div>' : '';

                let statusClass = 'schedule';
                let statusText = '예정';
                if(game.status === 'LIVE') { statusClass = 'during'; statusText = '경기중'; }
                else if(game.status === 'FINISHED') { statusClass = 'end'; statusText = '종료'; }
                else if(game.status === 'CANCELLED') { statusClass = 'cancel'; statusText = '취소'; }

                let scoreHome = (game.status === 'SCHEDULED') ? '0' : game.scoreHome;
                let scoreAway = (game.status === 'SCHEDULED') ? '0' : game.scoreAway;

                let btnHtml = '';
                let diaryBtnHtml = '';
                const isWritten = (game.diaryId && game.diaryId > 0);

                if (isWritten) {
                    diaryBtnHtml = `<a href="/diary/detail?diaryId=\${game.diaryId}" class="btn btn-primary mt-8" style="background-color:#EBF4FF; color:#1A7CFF; border:none;">일기 보기</a>`;
                } else {
                    diaryBtnHtml = `<a href="/diary/write?gameId=\${game.gameId}" class="btn btn-primary mt-8">직관 인증하기<span><img src="/img/ico_right_arrow.svg" alt=""></span></a>`;
                }

                btnHtml = diaryBtnHtml;

                let html = `
                        <div class="card_item game-item" data-home="\${game.homeTeamCode}" data-away="\${game.awayTeamCode}">
                            <div class="game-board">
                                <div class="row row-center gap-6">
                                    <div class="team \${winClassAway}">
                                        \${myTeamBadgeAway}
                                        <img src="\${awaySrc}" alt="\${game.awayTeamName}" onerror="handleLogoError(this, '\${awayCodeLower}')">
                                        <div class="team-name mt-4">\${game.awayTeamName}</div>
                                        \${awayStarterHtml}
                                    </div>

                                    <div class="game-score \${statusClass}">
                                        <div class="left-team-score \${game.scoreAway > game.scoreHome ? 'high' : ''}">\${scoreAway}</div>
                                        <div class="game-info-wrap">
                                            <div class="badge">\${statusText}</div>
                                            \${cancelReasonHtml}
                                            <div class="game-info">
                                                <div class="day">\${game.gameTime ? game.gameTime.substring(0,5) : ''}</div>
                                                <div class="place">\${game.stadiumName}</div>
                                            </div>
                                        </div>
                                        <div class="right-team-score \${game.scoreHome > game.scoreAway ? 'high' : ''}">\${scoreHome}</div>
                                    </div>

                                    <div class="team \${winClassHome}">
                                        \${myTeamBadgeHome}
                                        <img src="\${homeSrc}" alt="\${game.homeTeamName}" onerror="handleLogoError(this, '\${homeCodeLower}')">
                                        <div class="team-name mt-4">\${game.homeTeamName}</div>
                                        \${homeStarterHtml}
                                    </div>
                                </div>
                            </div>
                            \${btnHtml}
                        </div>
                    `;
                list.append(html);
            });
        }

        // 초기 로딩 시 데이터 조회
        $(document).ready(function() {
            const savedState = localStorage.getItem('myTeamOnly');
            if (savedState === 'true') {
                $('#myTeam').prop('checked', true);
            } else {
                $('#myTeam').prop('checked', false);
            }

            const initDate = $('#selectedDate').val();
            if (initDate) {
                loadGames(initDate);
            }
        });
    </script>
</body>
</html>