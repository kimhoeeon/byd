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

    <title>직관 일기 메인 | 승요일기</title>

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
</head>

<body>
    <div class="app">
        <div class="top_wrap">
            <div class="main-top">
                <div class="main-title">
                    직관일기
                </div>

                <button class="noti-btn ${hasUnreadAlarm ? 'has-badge' : ''}" onclick="location.href='/alarm/list'">
                    <span class="noti-btn_icon" aria-hidden="true"><img src="/img/ico_noti.svg" alt="알림 아이콘"></span>
                    <span class="noti-dot" aria-hidden="true"></span>
                </button>
            </div>
        </div>

        <div class="app-main">

            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">

                <div class="tab-pill" style="margin-bottom: 0; margin-top: 0;">
                    <button type="button" class="tab-pill_btn on" onclick="location.href='/diary/all'">전체 보기</button>
                    <button type="button" class="tab-pill_btn" onclick="location.href='/diary/winyo'">나의 기록</button>
                    <button type="button" class="tab-pill_btn" onclick="location.href='/diary/friend/list'">친구 일기</button>
                </div>

                <a href="/member/search" class="btn-friend-search" style="display: flex; align-items: center; gap: 4px; font-size: 13px; font-weight: 600; color: #555;">
                    <img src="/img/ico_friend.svg" alt="검색" style="width: 18px; height: 18px;">
                    친구찾기
                </a>
            </div>

            <div class="page-main_wrap">

                <div class="history">
                    <!-- 이번 주 HOT 직관 일기 -->
                    <div class="card_wrap content">
                        <div class="card_item">
                            <div class="row history-head">
                                <div class="tit content_tit">이번 주 HOT 직관 일기</div>
                                <%--<a href="/diary/list">
                                    <img src="/img/ico_next_arrow.svg" alt="모두 보기">
                                </a>--%>
                            </div>
                            <c:choose>
                                <c:when test="${not empty popularDiaries}">
                                    <div class="score_wrap">
                                        <c:forEach var="diary" items="${popularDiaries}">
                                            <div class="score_list" onclick="location.href='/diary/detail?diaryId=${diary.diaryId}'" style="cursor:pointer;">
                                                <div class="img">
                                                    <c:set var="firstImage" value="" />
                                                    <c:if test="${not empty diary.imageUrl}">
                                                        <c:set var="imgArr" value="${fn:split(diary.imageUrl, ',')}" />
                                                        <c:set var="firstImage" value="${imgArr[0]}" />
                                                    </c:if>
                                                    <img src="${not empty firstImage ? firstImage : '/img/card_defalut.svg'}"
                                                         alt="스코어카드 이미지" onerror="this.src='/img/card_defalut.svg'"
                                                         style="width:100%; height:100%; object-fit:cover;">
                                                </div>
                                                <div class="score_txt">
                                                    <div class="txt_box">
                                                        <div class="tit">
                                                            ${diary.awayTeamName} vs ${diary.homeTeamName}
                                                        </div>
                                                        <div class="date">
                                                            <c:if test="${not empty diary.gameDate}">
                                                                ${fn:substring(diary.gameDate, 0, 10)}
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="nodt_wrap only_txt">
                                        <div class="cont"><div class="nodt_txt">아직 등록된 인기 콘텐츠가 없어요.</div></div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <!-- 이번 주 HOT 직관 일기 -->

                    <div class="card schedule-picker mt-24">
                        <div class="schedule-header">
                            <button type="button" class="week-btn" id="diaryPrevWeek" aria-label="저번 주">
                                <img src="/img/picker_prev.svg" alt="저번 주">
                            </button>
                            <div class="week-label" id="diaryWeekLabel"></div>
                            <button type="button" class="week-btn" id="diaryNextWeek" aria-label="다음 주">
                                <img src="/img/picker_next.svg" alt="다음 주">
                            </button>
                            <button class="picker-popup" id="diaryOpenMonthPicker">
                                <img src="/img/ico_picker.svg" alt="달력 모달">
                            </button>
                        </div>

                        <div class="schedule-weekdays">
                            <span>일</span><span>월</span><span>화</span><span>수</span><span>목</span><span>금</span><span>토</span>
                        </div>

                        <div class="schedule-grid" id="diaryDateGrid">
                        </div>
                    </div>

                    <div class="sheet-backdrop" id="diaryMonthPickerSheet">
                        <div class="sheet month-sheet" role="dialog" aria-modal="true">
                            <div class="month-sheet_header">
                                <button type="button" class="month-sheet_close" id="diaryMonthCloseBtn" aria-label="닫기">
                                    <img src="/img/ico_close.svg" alt="닫기">
                                </button>
                            </div>

                            <div class="month-sheet_nav">
                                <button type="button" class="month-nav_btn" id="diaryMonthPrev" aria-label="이전 달">
                                    <img src="/img/picker_prev.svg" alt="이전 달">
                                </button>
                                <div class="month-label" id="diaryMonthLabel"></div>
                                <button type="button" class="month-nav_btn" id="diaryMonthNext" aria-label="다음 달">
                                    <img src="/img/picker_next.svg" alt="다음 달">
                                </button>
                            </div>

                            <div class="month-weekdays">
                                <span class="sun">일</span><span>월</span><span>화</span><span>수</span><span>목</span><span>금</span><span class="sat">토</span>
                            </div>
                            <div class="month-grid-wrap">
                                <div class="month-grid" id="diaryMonthGrid">
                                </div>
                            </div>
                            <div class="match-notice">날짜를 선택하면 그날의 직관일기를 볼 수 있어요.</div>

                            <div class="month-sheet_footer">
                                <button type="button" class="btn btn-primary" id="diaryMonthApplyBtn" disabled>
                                    보기
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="history-list">
                        <label class="check myTeam_check">
                            <input type="checkbox" name="myTeam" id="myTeamFilter" />
                            우리팀만 보기
                        </label>
                        <div class="card_item gap-16">
                            <div class="score_wrap row_wrap" id="diaryListContainer">
                                <div class="nodt_wrap only_txt" style="width:100%;">
                                    <div class="cont">
                                        <div class="nodt_txt">날짜를 선택해 주세요.</div>
                                    </div>
                                </div>
                            </div>
                            <div class="add_btn" id="loadMoreBtnWrap" style="display:none;">
                                <button id="loadMoreBtn">
                                    <img src="/img/ico_back_down_arrow.svg" alt="더보기">
                                </button>
                            </div>
                        </div>
                    </div>


                </div>

            </div>
        </div>

        <%@ include file="../include/tabbar.jsp" %>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>

    <script>
        // 전역 변수 설정: 오늘 날짜 기본 세팅
        let currentDate = new Date();
        let currentSelectedDateStr = formatYMD(currentDate); // 오늘 날짜 포맷
        const myTeamCode = '${myTeamCode}';
        let currentPage = 1;
        const pageSize = 5; // 한 번에 5개씩 노출

        $(document).ready(function() {
            // 진입 시 오늘 날짜 기준으로 화면 렌더링
            renderWeekCalendar(currentDate);
            loadDiaryList(currentSelectedDateStr, true);

            // 우리팀 필터
            $('#myTeamFilter').on('change', function() {
                if(currentSelectedDateStr) loadDiaryList(currentSelectedDateStr, true);
            });

            // 더보기 (페이징)
            $('#loadMoreBtn').on('click', function() {
                currentPage++;
                fetchDiaryData(currentSelectedDateStr, $('#myTeamFilter').is(':checked'), currentPage, true);
            });

            // 주간 화살표
            $('#diaryPrevWeek').click(function() {
                currentDate.setDate(currentDate.getDate() - 7);
                renderWeekCalendar(currentDate);
            });
            $('#diaryNextWeek').click(function() {
                currentDate.setDate(currentDate.getDate() + 7);
                renderWeekCalendar(currentDate);
            });

            // 모달 열기/닫기
            $('#diaryOpenMonthPicker').click(function() {
                $('#diaryMonthPickerSheet').addClass('is-open');
                renderMonthCalendar(currentDate);
            });
            $('#diaryMonthCloseBtn').click(function() {
                $('#diaryMonthPickerSheet').removeClass('is-open');
            });
            // 딤(배경) 클릭 시 닫기
            $('#diaryMonthPickerSheet').click(function(e) {
                if(e.target.id === 'diaryMonthPickerSheet') {
                    $(this).removeClass('is-open');
                }
            });

            // 모달 달 변경
            $('#diaryMonthPrev').click(function() {
                currentDate.setMonth(currentDate.getMonth() - 1);
                renderMonthCalendar(currentDate);
            });
            $('#diaryMonthNext').click(function() {
                currentDate.setMonth(currentDate.getMonth() + 1);
                renderMonthCalendar(currentDate);
            });

            // 모달 적용 (보기 버튼)
            $('#diaryMonthApplyBtn').click(function() {
                let tempDate = $('#diaryMonthGrid button.is-selected').attr('data-date');
                if(tempDate) {
                    currentDate = new Date(tempDate);
                    currentSelectedDateStr = tempDate;
                    renderWeekCalendar(currentDate);
                    loadDiaryList(tempDate, true);
                    $('#diaryMonthPickerSheet').removeClass('is-open');
                }
            });
        });

        // 리스트 호출 함수
        function loadDiaryList(dateStr, isReset) {
            currentSelectedDateStr = dateStr;
            if(isReset) currentPage = 1;
            const isMyTeamOnly = $('#myTeamFilter').is(':checked');
            fetchDiaryData(dateStr, isMyTeamOnly, currentPage, !isReset);
        }

        function fetchDiaryData(dateStr, isMyTeamOnly, page, isAppend) {
            let reqData = { date: dateStr, page: page, limit: pageSize };
            if(isMyTeamOnly) reqData.teamCode = myTeamCode;

            $.ajax({
                url: '/diary/api/list-by-date',
                data: reqData,
                success: function(list) {
                    let html = '';
                    if(list.length > 0) {
                        list.forEach(diary => {
                            let imgUrl = diary.imageUrl ? diary.imageUrl.split(',')[0] : '/img/card_defalut.svg';
                            let winMark = (diary.gameResult === 'WIN') ? `<div class="score_win"><img src="/img/ico_check.svg" alt="승리"></div>` : '';
                            html += `
                                <div class="score_list" onclick="location.href='/diary/detail?diaryId=\${diary.diaryId}'" style="cursor:pointer;">
                                    <div class="img">
                                        <img src="\${imgUrl}" alt="스코어카드" onerror="this.src='/img/card_defalut.svg'" style="width:100%; height:100%; object-fit:cover;">
                                    </div>
                                    <div class="score_txt">
                                        <div class="txt_box">
                                            <div class="tit">\${diary.awayTeamName} \${diary.scoreAway} vs \${diary.scoreHome} \${diary.homeTeamName}</div>
                                            <div class="userName">\${diary.nickname}</div>
                                            <div class="date">\${dateStr}</div>
                                        </div>
                                        \${winMark}
                                    </div>
                                </div>
                            `;
                        });
                        if(isAppend) $('#diaryListContainer').append(html);
                        else $('#diaryListContainer').html(html);

                        if(list.length >= pageSize) $('#loadMoreBtnWrap').show();
                        else $('#loadMoreBtnWrap').hide();
                    } else {
                        if(!isAppend) {
                            $('#diaryListContainer').html(`
                                <div class="nodt_wrap only_txt" style="width:100%;">
                                    <div class="cont"><div class="nodt_txt">해당 날짜에 등록된 일기가 없습니다.</div></div>
                                </div>`);
                        }
                        $('#loadMoreBtnWrap').hide();
                    }
                }
            });
        }

        // ==========================================
        // UI 렌더링 (date-picker.js CSS 100% 호환)
        // ==========================================
        function renderWeekCalendar(baseDate) {
            $('#diaryWeekLabel').text(getWeekLabel(baseDate));
            let startOfWeek = getSundayOfWeek(baseDate);
            let monthStr = baseDate.getFullYear() + "-" + String(baseDate.getMonth() + 1).padStart(2, '0');

            $.ajax({
                url: '/diary/api/calendar-dates',
                data: { month: monthStr },
                success: function(activeDates) {
                    let html = '';
                    let ctxMonth = baseDate.getMonth();

                    for(let i=0; i<7; i++) {
                        let d = new Date(startOfWeek);
                        d.setDate(d.getDate() + i);
                        let dateStr = formatYMD(d);

                        let isSelected = (dateStr === currentSelectedDateStr) ? 'is-selected' : '';
                        let isToday = (dateStr === formatYMD(new Date())) ? 'is-today' : '';
                        let isOtherMonth = (d.getMonth() !== ctxMonth) ? 'is-other-month' : '';
                        let hasData = activeDates.includes(dateStr) ? '<div class="dot"></div>' : '';

                        html += `
                            <button type="button" class="schedule-day \${isSelected} \${isToday} \${isOtherMonth}" data-date="\${dateStr}" onclick="selectDate(this)">
                                <span>\${d.getDate()}</span>\${hasData}
                            </button>
                        `;
                    }
                    $('#diaryDateGrid').html(html);
                }
            });
        }

        function renderMonthCalendar(baseDate) {
            let year = baseDate.getFullYear();
            let month = baseDate.getMonth();
            $('#diaryMonthLabel').text(`\${year}년 \${month + 1}월`);
            let monthStr = year + "-" + String(month + 1).padStart(2, '0');

            $.ajax({
                url: '/diary/api/calendar-dates',
                data: { month: monthStr },
                success: function(activeDates) {
                    let firstDow = new Date(year, month, 1).getDay();
                    let lastDay = new Date(year, month + 1, 0).getDate();

                    let html = '';
                    for(let i=0; i<firstDow; i++) { html += `<div class="month-day is-empty"></div>`; }
                    for(let d=1; d<=lastDay; d++) {
                        let curD = new Date(year, month, d);
                        let dateStr = formatYMD(curD);

                        let isSelected = (dateStr === currentSelectedDateStr) ? 'is-selected' : '';
                        let isToday = (dateStr === formatYMD(new Date())) ? 'is-today' : '';
                        let isSun = (curD.getDay() === 0) ? 'is-sun' : '';
                        let isSat = (curD.getDay() === 6) ? 'is-sat' : '';
                        let hasDataClass = activeDates.includes(dateStr) ? 'is-mark' : '';

                        html += `
                            <button type="button" class="month-day \${isSelected} \${isToday} \${isSun} \${isSat} \${hasDataClass}" data-date="\${dateStr}" onclick="selectMonthDate(this)">
                                <span>\${d}</span>
                            </button>
                        `;
                    }
                    $('#diaryMonthGrid').html(html);

                    if($('#diaryMonthGrid button.is-selected').length > 0) $('#diaryMonthApplyBtn').prop('disabled', false);
                    else $('#diaryMonthApplyBtn').prop('disabled', true);
                }
            });
        }

        function selectDate(btn) {
            $('#diaryDateGrid button').removeClass('is-selected');
            $(btn).addClass('is-selected');
            let dateStr = $(btn).attr('data-date');
            loadDiaryList(dateStr, true);
        }

        function selectMonthDate(btn) {
            $('#diaryMonthGrid button').removeClass('is-selected');
            $(btn).addClass('is-selected');
            $('#diaryMonthApplyBtn').prop('disabled', false);
        }

        // 유틸 함수
        function formatYMD(date) {
            let y = date.getFullYear();
            let m = String(date.getMonth() + 1).padStart(2, '0');
            let d = String(date.getDate()).padStart(2, '0');
            return `\${y}-\${m}-\${d}`;
        }
        function getSundayOfWeek(date) {
            let copy = new Date(date);
            copy.setDate(copy.getDate() - copy.getDay());
            return copy;
        }
        function getWeekLabel(date) {
            let year = date.getFullYear();
            let month = date.getMonth();
            let day = date.getDate();
            let yy = String(year).slice(-2);
            let firstDow = new Date(year, month, 1).getDay();
            let weekIndex = Math.floor((firstDow + day - 1) / 7) + 1;
            return `\${yy}년 \${month + 1}월 \${weekIndex}주`;
        }
    </script>
</body>
</html>