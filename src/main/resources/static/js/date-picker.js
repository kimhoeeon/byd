document.addEventListener('DOMContentLoaded', function () {

  // 보이는 달력
  (function () {
    const dobWrap = document.querySelector('.dob-wrap, #dob-wrap');
    if (!dobWrap) return; 

    const yearWheel  = dobWrap.querySelector('.dob-picker_wheel[data-type="year"]');
    const monthWheel = dobWrap.querySelector('.dob-picker_wheel[data-type="month"]');
    const dayWheel   = dobWrap.querySelector('.dob-picker_wheel[data-type="day"]');
    if (!yearWheel || !monthWheel || !dayWheel) return;

    const YEAR_START = 1950;
    const YEAR_END   = new Date().getFullYear();
    const ITEM_HEIGHT = 50;

    function createPlaceholder() {
      const placeholder = document.createElement('div');
      placeholder.className = 'dob-picker_item dob-picker_placeholder';
      placeholder.textContent = '';
      return placeholder;
    }

    function createYearWheel() {
      yearWheel.innerHTML = '';
      yearWheel.appendChild(createPlaceholder());
      for (let y = YEAR_START; y <= YEAR_END; y++) {
        const item = document.createElement('div');
        item.className = 'dob-picker_item';
        item.dataset.value = y;
        item.textContent = y + '년';
        yearWheel.appendChild(item);
      }
      yearWheel.appendChild(createPlaceholder());
    }

    function createMonthWheel() {
      monthWheel.innerHTML = '';
      monthWheel.appendChild(createPlaceholder());
      for (let m = 1; m <= 12; m++) {
        const item = document.createElement('div');
        item.className = 'dob-picker_item';
        item.dataset.value = m;
        item.textContent = m + '월';
        monthWheel.appendChild(item);
      }
      monthWheel.appendChild(createPlaceholder());
    }

    function getDaysInMonth(year, month) {
      return new Date(year, month, 0).getDate();
    }

    function createDayWheel(year, month, currentDay) {
      dayWheel.innerHTML = '';
      dayWheel.appendChild(createPlaceholder());

      const days = getDaysInMonth(year, month);
      for (let d = 1; d <= days; d++) {
        const item = document.createElement('div');
        item.className = 'dob-picker_item';
        item.dataset.value = d;
        item.textContent = d + '일';
        dayWheel.appendChild(item);
      }

      dayWheel.appendChild(createPlaceholder());

      let targetDay = currentDay && currentDay <= days ? currentDay : days;
      snapToValue(dayWheel, targetDay);
      markSelected(dayWheel);
    }

    // 센터 정렬
    function snapToNearest(wheel) {
      const scroll = wheel.scrollTop;
      const items = wheel.querySelectorAll('.dob-picker_item');
      const minIndex = 1;
      const maxIndex = items.length - 2;

      let indexApprox = Math.round(scroll / ITEM_HEIGHT);
      let index = Math.min(Math.max(indexApprox, minIndex), maxIndex);

      const targetScrollTop = index * ITEM_HEIGHT;
      wheel.scrollTo({
        top: targetScrollTop,
        behavior: 'smooth'
      });

      setTimeout(() => {
        markSelected(wheel);
        updateDob();
      }, 150);
    }

    function snapToValue(wheel, value) {
      const items = wheel.querySelectorAll('.dob-picker_item');
      let index = 1;
      items.forEach((item, i) => {
        if (item.dataset.value && Number(item.dataset.value) === Number(value)) {
          index = i;
        }
      });
      const targetScrollTop = index * ITEM_HEIGHT;
      wheel.scrollTop = targetScrollTop;
      markSelected(wheel);
    }

    function markSelected(wheel) {
      const scroll = wheel.scrollTop;
      const items = wheel.querySelectorAll('.dob-picker_item');
      const minIndex = 1;
      const maxIndex = items.length - 2;

      let index = Math.round(scroll / ITEM_HEIGHT);
      index = Math.min(Math.max(index, minIndex), maxIndex);

      items.forEach((item, i) => {
        item.classList.toggle('is-selected', i === index);
      });
    }

    function getSelectedValue(wheel) {
      const item = wheel.querySelector('.dob-picker_item.is-selected');
      return item ? Number(item.dataset.value) : null;
    }

    function updateDob() {
      const y = getSelectedValue(yearWheel);
      const m = getSelectedValue(monthWheel);
      const d = getSelectedValue(dayWheel);
      if (!y || !m || !d) return;
    }

    function attachScrollSnap(wheel, onAfterSnap) {
      let timer = null;
      wheel.addEventListener('scroll', () => {
        if (timer) clearTimeout(timer);
        timer = setTimeout(() => {
          snapToNearest(wheel);
          if (onAfterSnap) onAfterSnap();
        }, 80);
      });
    }

    const today = new Date();
    const base = new Date(
      today.getFullYear() - 14,
      today.getMonth(),
      today.getDate()
    );
    const initYear = base.getFullYear();
    const initMonth = base.getMonth() + 1;
    const initDay = base.getDate();

    createYearWheel();
    createMonthWheel();
    snapToValue(yearWheel, initYear);
    snapToValue(monthWheel, initMonth);
    createDayWheel(initYear, initMonth, initDay);

    attachScrollSnap(yearWheel, () => {
      const y = getSelectedValue(yearWheel) || initYear;
      const m = getSelectedValue(monthWheel) || 1;
      const currentDay = getSelectedValue(dayWheel) || 1;
      createDayWheel(y, m, currentDay);
      updateDob();
    });

    attachScrollSnap(monthWheel, () => {
      const y = getSelectedValue(yearWheel) || initYear;
      const m = getSelectedValue(monthWheel) || 1;
      const currentDay = getSelectedValue(dayWheel) || 1;
      createDayWheel(y, m, currentDay);
      updateDob();
    });

    attachScrollSnap(dayWheel, () => {
      updateDob();
    });

    updateDob();
  })();

  // 팝업 스피너
  (function () {
    const popup       = document.getElementById('dobPopup');
    const pickerInput = document.getElementById('picker');

    if (!popup || !pickerInput) return;

    const yearWheel  = popup.querySelector('.dob-pop-wheel[data-type="year"]');
    const monthWheel = popup.querySelector('.dob-pop-wheel[data-type="month"]');
    const dayWheel   = popup.querySelector('.dob-pop-wheel[data-type="day"]');

    const btnCancel  = popup.querySelector('.btn-cancel');
    const btnApply   = popup.querySelector('.btn-apply');
    const dim        = popup.querySelector('.dob-pop-dim');

    if (!yearWheel || !monthWheel || !dayWheel) return;

    const YEAR_START  = 1950;
    const YEAR_END    = new Date().getFullYear(); 
    const ITEM_HEIGHT = 50;

    let selectedYear  = null;
    let selectedMonth = null;
    let selectedDay   = null;

    // 적용 후 데이터
    let hasApplied = false;
    let lastYear   = null;
    let lastMonth  = null;
    let lastDay    = null;

    let wheelsInited = false;

    function getBase14Date() {
      const today = new Date();
      const base = new Date(
        today.getFullYear() - 14,
        today.getMonth(),
        today.getDate()
      );
      if (base.getFullYear() < YEAR_START) {
        base.setFullYear(YEAR_START, 0, 1);
      }
      return base;
    }

    function createPlaceholder() {
      const el = document.createElement('div');
      el.className = 'dob-pop-item dob-picker_placeholder';
      el.textContent = '';
      return el;
    }

    function createYearWheel() {
      yearWheel.innerHTML = '';
      yearWheel.appendChild(createPlaceholder());
      for (let y = YEAR_START; y <= YEAR_END; y++) {
        const item = document.createElement('div');
        item.className = 'dob-pop-item';
        item.dataset.value = y;
        item.textContent = y + '년';
        yearWheel.appendChild(item);
      }
      yearWheel.appendChild(createPlaceholder());
    }

    function createMonthWheel() {
      monthWheel.innerHTML = '';
      monthWheel.appendChild(createPlaceholder());
      for (let m = 1; m <= 12; m++) {
        const item = document.createElement('div');
        item.className = 'dob-pop-item';
        item.dataset.value = m;
        item.textContent = m + '월';
        monthWheel.appendChild(item);
      }
      monthWheel.appendChild(createPlaceholder());
    }

    function getDaysInMonth(year, month) {
      return new Date(year, month, 0).getDate();
    }

    function createDayWheel(year, month, keepDay) {
      dayWheel.innerHTML = '';
      dayWheel.appendChild(createPlaceholder());

      const days = getDaysInMonth(year, month);
      for (let d = 1; d <= days; d++) {
        const item = document.createElement('div');
        item.className = 'dob-pop-item';
        item.dataset.value = d;
        item.textContent = d + '일';
        dayWheel.appendChild(item);
      }
      dayWheel.appendChild(createPlaceholder());

      const targetDay = keepDay && keepDay <= days ? keepDay : days;
      snapToValue(dayWheel, targetDay);
      markSelected(dayWheel);
    }

    function setSelectedByValue(wheel, value) {
    const items = wheel.querySelectorAll('.dob-pop-item');
    if (!items.length) return;

    let found = false;
    items.forEach((item, i) => {
      if (item.dataset.value && Number(item.dataset.value) === Number(value)) {
        item.classList.add('is-selected');
        found = true;
      } else {
        item.classList.remove('is-selected');
      }
    });

    if (!found) {
      items.forEach((item, i) => {
        item.classList.toggle('is-selected', i === 1);
      });
    }
  }

    function scrollToSelected(wheel) {
      const selected = wheel.querySelector('.dob-pop-item.is-selected, .dob-picker_item.is-selected');
      if (!selected) return;

      const itemTop = selected.offsetTop;
      const itemHeight = selected.offsetHeight;
      const centerOffset = (wheel.clientHeight - itemHeight) / 2;

      let targetScrollTop = itemTop - centerOffset;

      const maxScroll = wheel.scrollHeight - wheel.clientHeight;
      if (targetScrollTop < 0) targetScrollTop = 0;
      if (targetScrollTop > maxScroll) targetScrollTop = maxScroll;

      wheel.scrollTop = targetScrollTop;

      //console.log(selected.offsetTop, wheel.clientHeight, selected.offsetHeight, wheel.scrollTop);
    }

    function markSelected(wheel) {
      const items = wheel.querySelectorAll('.dob-pop-item');
      if (!items.length) return;

      const minIndex = 1;
      const maxIndex = items.length - 2;

      const centerOffset = (wheel.clientHeight - ITEM_HEIGHT) / 2;
      const centerPos    = wheel.scrollTop + centerOffset;

      let index = Math.round(centerPos / ITEM_HEIGHT);
      index = Math.min(Math.max(index, minIndex), maxIndex);

      items.forEach((item, i) => {
        item.classList.toggle('is-selected', i === index);
      });
    }

    function getSelectedValue(wheel) {
      const item = wheel.querySelector('.dob-pop-item.is-selected');
      return item ? Number(item.dataset.value) : null;
    }

    function snapToValue(wheel, value) {
      const items = wheel.querySelectorAll('.dob-pop-item');
      if (!items.length) return;

      let index = -1;

      items.forEach((item, i) => {
        if (item.dataset.value && Number(item.dataset.value) === Number(value)) {
          index = i;
        }
      });

      if (index === -1) {
        if (wheel === yearWheel) {
          index = (Number(value) - YEAR_START) + 1;  
        } else {
          index = Number(value) + 1;
        }
      }

      const centerOffset = (wheel.clientHeight - ITEM_HEIGHT) / 2;
        let targetScrollTop = index * ITEM_HEIGHT - centerOffset;

        const maxScroll = wheel.scrollHeight - wheel.clientHeight;
        if (targetScrollTop < 0) targetScrollTop = 0;
        if (targetScrollTop > maxScroll) targetScrollTop = maxScroll;

        wheel.scrollTop = targetScrollTop;
        markSelected(wheel);
      }

    function snapToNearest(wheel, onAfter) {
      const items = wheel.querySelectorAll('.dob-pop-item');
          if (!items.length) return;

          const minIndex = 1;
          const maxIndex = items.length - 2;

          const centerOffset = (wheel.clientHeight - ITEM_HEIGHT) / 2;
          const centerPos    = wheel.scrollTop + centerOffset;

          let index = Math.round(centerPos / ITEM_HEIGHT);
          index = Math.min(Math.max(index, minIndex), maxIndex);

          let targetScrollTop = index * ITEM_HEIGHT - centerOffset;

          const maxScroll = wheel.scrollHeight - wheel.clientHeight;

          if (targetScrollTop < 0) targetScrollTop = 0;
          if (targetScrollTop > maxScroll) targetScrollTop = maxScroll;

          wheel.scrollTo({
            top: targetScrollTop,
            behavior: 'smooth'
          });

        setTimeout(() => {
          markSelected(wheel);
          if (typeof onAfter === 'function') onAfter();
        }, 120);
    }

    function attachScrollSnap(wheel, onAfterSnap) {
      let timer = null;
      wheel.addEventListener('scroll', () => {
        if (timer) clearTimeout(timer);
        timer = setTimeout(() => {
          snapToNearest(wheel, onAfterSnap);
        }, 80);
      });
    }

    function updateSelectedValues() {
      selectedYear  = getSelectedValue(yearWheel);
      selectedMonth = getSelectedValue(monthWheel);
      selectedDay   = getSelectedValue(dayWheel);
    }

    function getFormattedDate() {
      if (!selectedYear || !selectedMonth || !selectedDay) return '';
      const y = selectedYear;
      const m = String(selectedMonth).padStart(2, '0');
      const d = String(selectedDay).padStart(2, '0');
      return `${y}-${m}-${d}`;
    }

    function getBaseDateForOpen() {
      if (hasApplied && lastYear && lastMonth && lastDay) {
        return new Date(lastYear, lastMonth - 1, lastDay);
      }

      return getBase14Date();
    }

    function initForOpen() {
      const baseDate  = getBaseDateForOpen();
      const baseYear  = baseDate.getFullYear();
      const baseMonth = baseDate.getMonth() + 1;
      const baseDay   = baseDate.getDate();

      createYearWheel();
      createMonthWheel();
      createDayWheel(baseYear, baseMonth, baseDay);

      setSelectedByValue(yearWheel, baseYear);
      setSelectedByValue(monthWheel, baseMonth);
      setSelectedByValue(dayWheel, baseDay);

      scrollToSelected(yearWheel);
      scrollToSelected(monthWheel);
      scrollToSelected(dayWheel);
      
      updateSelectedValues();
    }

    function openPopup() {
      popup.style.display = 'block';
        setTimeout(() => {
            initForOpen();
        }, 0);

        if (!wheelsInited) {
          attachScrollSnap(yearWheel, () => {
            const y = getSelectedValue(yearWheel);
            const m = getSelectedValue(monthWheel) || 1;
            const d = getSelectedValue(dayWheel) || 1;
            if (!y || !m) return;
            createDayWheel(y, m, d);
            updateSelectedValues();
          });

          attachScrollSnap(monthWheel, () => {
            const y = getSelectedValue(yearWheel);
            const m = getSelectedValue(monthWheel);
            const d = getSelectedValue(dayWheel) || 1;
            if (!y || !m) return;
            createDayWheel(y, m, d);
            updateSelectedValues();
          });

          attachScrollSnap(dayWheel, () => {
            updateSelectedValues();
          });

          wheelsInited = true;
        }

        popup.style.display = 'block';
      }

      function closePopup() {
        popup.style.display = 'none';
      }

      pickerInput.addEventListener('click', openPopup);

      if (btnCancel) {
        btnCancel.addEventListener('click', closePopup);
      }

      if (btnApply) {
        btnApply.addEventListener('click', function () {
          const val = getFormattedDate();
          if (val) {
            pickerInput.value = val;
            hasApplied = true;
            lastYear   = selectedYear;
            lastMonth  = selectedMonth;
            lastDay    = selectedDay;
          }
          closePopup();
        });
      }

      if (dim) {
        dim.addEventListener('click', closePopup);
      }
  })();

  // 경기 달력
  (function () {
    const weekLabelEl    = document.getElementById('weekLabel');
    const dateGridEl     = document.getElementById('dateGrid');
    const prevWeekBtn    = document.getElementById('prevWeek');
    const nextWeekBtn    = document.getElementById('nextWeek');
    const selectedInput  = document.getElementById('selectedDate');
    const pickerPopupBtn = document.querySelector('.picker-popup');

    // 바텀시트(월 캘린더)
    const monthSheetBackdrop = document.getElementById('monthPickerSheet'); // sheet-backdrop
    const monthSheet         = monthSheetBackdrop
      ? monthSheetBackdrop.querySelector('.sheet')
      : null;
    const monthLabelEl  = document.getElementById('monthLabel');
    const monthGridEl   = document.getElementById('monthGrid');
    const monthPrevBtn  = document.getElementById('monthPrev');
    const monthNextBtn  = document.getElementById('monthNext');
    const monthApplyBtn = document.getElementById('monthApplyBtn');
    const monthCloseBtn = document.getElementById('monthCloseBtn');

    // 오늘의 경기 박스
    const monthMatchBox   = document.querySelector('.month-match');
    const monthMatchLabel = document.getElementById('monthMatchLabel');
    const monthMatchText  = document.getElementById('monthMatchText');

    // ---------- 상태 ----------
    let currentWeekDate = new Date();     // "현재 주" 기준이 되는 날짜
    let monthCursor     = new Date();     // 월 캘린더에서 보고 있는 달의 1일
    monthCursor.setDate(1);

    let popupSelectedDateStr = '';        // 팝업 내에서 선택된 날짜 (YYYY-MM-DD)

    // 날짜별 경기정보
    const matchData = {
      '2026-01-06': ['06(화) 13:00 LG vs 두산','06(화) 13:00 LG vs 두산'],
      '2026-01-07': ['07(수) 13:00 LG vs 두산','07(수) 13:00 LG vs 두산' ],
      '2026-01-08': ['08(목) 13:00 LG vs 두산','08(목) 13:00 LG vs 두산' ],
      '2026-01-09': ['09(금) 13:00 LG vs 두산','09(금) 13:00 LG vs 두산' ],
      '2026-01-10': ['10(토) 13:00 LG vs 두산' ],
      '2026-01-11': ['11(일) 13:00 LG vs 두산' ],
      '2026-01-13': ['13(화) 13:00 LG vs 두산' ],
      '2026-01-14': ['14(수) 13:00 LG vs 두산' ],
      '2026-01-15': ['15(목) 13:00 LG vs 두산' ],
      '2026-01-16': ['16(금) 13:00 LG vs 두산' ],
      '2026-01-17': ['17(토) 13:00 LG vs 두산' ],
      '2026-01-18': ['18(일) 13:00 LG vs 두산' ],
      '2026-01-20': ['20(화) 13:00 LG vs 두산' ],
    };

    // 응원하는 팀 정보
    const MARK_DATES = [
      '2026-01-10',
      '2026-01-18',
      '2026-02-02'
    ];

    // ---------- 유틸 ----------
    function formatYMD(date) {
      const y = date.getFullYear();
      const m = String(date.getMonth() + 1).padStart(2, '0');
      const d = String(date.getDate()).padStart(2, '0');
      return `${y}-${m}-${d}`;
    }

    function parseYMD(str) {
      if (!str) return null;
      const [y, m, d] = str.split('-').map(Number);
      if (!y || !m || !d) return null;
      return new Date(y, m - 1, d);
    }

    function getSundayOfWeek(date) {
      const copy = new Date(date);
      const dow  = copy.getDay(); // 0=일
      copy.setDate(copy.getDate() - dow);
      return copy;
    }

    function getWeekLabel(date) {
      const year  = date.getFullYear();
      const month = date.getMonth(); // 0-based
      const day   = date.getDate();

      const yy = String(year).slice(-2);

      const firstOfMonth = new Date(year, month, 1);
      const firstDow     = firstOfMonth.getDay();

      // 해당 월 기준 몇 번째 주인지
      const weekIndex = Math.floor((firstDow + day - 1) / 7) + 1;
      return `${yy}년 ${month + 1}월 ${weekIndex}주`;
    }

    function setMonthMatchVisible(show) {
      if (!monthMatchBox) return;
      monthMatchBox.classList.toggle('is-show', !!show);
    }

    function updateMonthMatchInfo(dateStr) {
      if (!monthMatchLabel || !monthMatchText) return;

      if (!dateStr) {
        setMonthMatchVisible(false);
        monthMatchText.textContent  = '';
        return;
      }

      const matches  = matchData[dateStr];

      if (matches && matches.length) {
        monthMatchLabel.textContent = '오늘의 경기';

        const lis = matches
          .map(text => `<li class="month-match_item">${text}</li>`)
          .join('');

        monthMatchText.innerHTML = `<ul class="month-match_list">${lis}</ul>`;
        setMonthMatchVisible(true);
      } else {
        monthMatchLabel.textContent = '오늘의 경기';
        monthMatchText.textContent  = '해당 날짜에는 등록된 경기가 없습니다.';
        setMonthMatchVisible(true);
      }
    }

    function updateMonthApplyBtn() {
      if (!monthApplyBtn) return;
      monthApplyBtn.disabled = !popupSelectedDateStr;
    }

    // ---------- 주간 뷰 렌더 ----------
    function renderWeekView() {
      if (!weekLabelEl || !dateGridEl) return;

      weekLabelEl.textContent = getWeekLabel(currentWeekDate);

      dateGridEl.innerHTML = '';

      const ctxYear  = currentWeekDate.getFullYear();
      const ctxMonth = currentWeekDate.getMonth(); // 기준 월

      const sunday = getSundayOfWeek(currentWeekDate);
      const todayStr    = formatYMD(new Date());
      const selectedStr = selectedInput?.value || '';

      for (let i = 0; i < 7; i++) {
        const d = new Date(sunday);
        d.setDate(sunday.getDate() + i);

        const btn = document.createElement('button');
        btn.type = 'button';
        btn.className = 'schedule-day';
        btn.textContent = d.getDate();

        const ymd = formatYMD(d);
        btn.dataset.date = ymd;

        const dYear  = d.getFullYear();
        const dMonth = d.getMonth();

        // 다른 월이면 흐릿하게 처리
        if (dYear !== ctxYear || dMonth !== ctxMonth) {
          btn.classList.add('is-other-month');
        }

        if (ymd === todayStr) {
          btn.classList.add('is-today');
        }
        if (ymd === selectedStr) {
          btn.classList.add('is-selected');
        }

        btn.addEventListener('click', () => {
          const isOtherMonth = (dYear !== ctxYear || dMonth !== ctxMonth);

          // 선택 날짜 갱신
          if (selectedInput) {
            selectedInput.value = ymd;
          }

          if (isOtherMonth) {
            // ✅ 다른 월 날짜를 클릭한 경우:
            // 기준 주/월을 해당 날짜 기준으로 바꾸고 다시 렌더
            currentWeekDate = d;
            renderWeekView();
          } else {
            // 같은 월 안에서는 그냥 선택 상태만 변경
            document
              .querySelectorAll('.schedule-day.is-selected')
              .forEach(el => el.classList.remove('is-selected'));

            btn.classList.add('is-selected');
          }

          // TODO: 여기서 "아래 데이터 변경" 함수 연결
          // updateScheduleDetail(ymd);
        });

        dateGridEl.appendChild(btn);
      }
    }

    // ---------- 초기 selectedDate 세팅 ----------
    (function initWeekBase() {
      const todayStr = formatYMD(new Date());

      if (selectedInput) {
        // 서버에서 "다음 경기 날짜"를 내려줄 수 있음
        if (window.NEXT_MATCH_DATE) {
          selectedInput.value = window.NEXT_MATCH_DATE;
        } else if (!selectedInput.value) {
          selectedInput.value = todayStr;
        }
      }

      const base = parseYMD(selectedInput?.value || todayStr);
      if (base) currentWeekDate = base;
    })();

    // ---------- 주간 이전/다음 ----------
    prevWeekBtn?.addEventListener('click', () => {
      currentWeekDate.setDate(currentWeekDate.getDate() - 7);
      renderWeekView();
    });

    nextWeekBtn?.addEventListener('click', () => {
      currentWeekDate.setDate(currentWeekDate.getDate() + 7);
      renderWeekView();
    });

    // ---------- 월 팝업 ----------
    function renderMonthView() {
      if (!monthLabelEl || !monthGridEl) return;

      const year  = monthCursor.getFullYear();
      const month = monthCursor.getMonth();

      monthLabelEl.textContent = `${year}년 ${month + 1}월`;

      monthGridEl.innerHTML = '';

      const firstDay = new Date(year, month, 1);
      const firstDow = firstDay.getDay();
      const lastDay  = new Date(year, month + 1, 0).getDate();

      const todayStr = formatYMD(new Date());

      // 앞쪽 빈칸
      for (let i = 0; i < firstDow; i++) {
        const empty = document.createElement('div');
        empty.className = 'month-day is-empty';
        monthGridEl.appendChild(empty);
      }

      // 날짜들
      for (let d = 1; d <= lastDay; d++) {
        const btn = document.createElement('button');
        btn.type = 'button';
        btn.className = 'month-day';
        btn.textContent = d;

        const dateObj = new Date(year, month, d);
        const ymd     = formatYMD(dateObj);
        btn.dataset.date = ymd;

        const colIndex = (firstDow + d - 1) % 7;
        if (colIndex === 0) btn.classList.add('is-sun');
        if (colIndex === 6) btn.classList.add('is-sat');

        if (ymd === todayStr) {
          btn.classList.add('is-today');
        }

        if (MARK_DATES.includes(ymd)) {
          btn.classList.add('is-mark');
        }

        if (ymd === popupSelectedDateStr) {
          btn.classList.add('is-selected');
        }

        btn.addEventListener('click', () => {
          document
            .querySelectorAll('.month-day.is-selected')
            .forEach(el => el.classList.remove('is-selected'));
          btn.classList.add('is-selected');

          popupSelectedDateStr = ymd;
          updateMonthApplyBtn();
          updateMonthMatchInfo(ymd);
        });

        monthGridEl.appendChild(btn);
      }
    }

    function openMonthSheet() {
      if (!monthSheetBackdrop) return;

      const baseDate =
        parseYMD(selectedInput?.value || '') ||
        new Date();

      monthCursor = new Date(baseDate.getFullYear(), baseDate.getMonth(), 1);
      popupSelectedDateStr = selectedInput?.value || '';

      renderMonthView();
      updateMonthApplyBtn();
      updateMonthMatchInfo(popupSelectedDateStr || '');

      monthSheetBackdrop.classList.add('is-open');
    }

    function closeMonthSheet() {
      if (!monthSheetBackdrop) return;
      monthSheetBackdrop.classList.remove('is-open');
    }

    pickerPopupBtn?.addEventListener('click', () => {
      openMonthSheet();
    });

    monthCloseBtn?.addEventListener('click', () => {
      closeMonthSheet();
    });

    // 딤 클릭 시 닫기
    monthSheetBackdrop?.addEventListener('click', (e) => {
      if (e.target === monthSheetBackdrop) {
        closeMonthSheet();
      }
    });

    monthPrevBtn?.addEventListener('click', () => {
      monthCursor.setMonth(monthCursor.getMonth() - 1);
      renderMonthView();
    });

    monthNextBtn?.addEventListener('click', () => {
      monthCursor.setMonth(monthCursor.getMonth() + 1);
      renderMonthView();
    });

    monthApplyBtn?.addEventListener('click', () => {
      if (!popupSelectedDateStr) return;

      if (selectedInput) {
        selectedInput.value = popupSelectedDateStr;
      }

      const d = parseYMD(popupSelectedDateStr);
      if (d) {
        currentWeekDate = d;      // ✅ 기준 주를 선택 날짜로 변경
        renderWeekView();
      }

      closeMonthSheet();
    });

    // ---------- 초기 렌더 ----------
    renderWeekView();
    setMonthMatchVisible(false);
    })();
});