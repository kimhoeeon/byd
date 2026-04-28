<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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

    <title>일기 작성 | 승요일기</title>

    <style>
        /* 선택된 항목 하이라이트 스타일 */
        .select-sheet_list li button.active {
            background-color: #f5f5f5;
            color: #2c7fff; /* 메인 컬러(파랑) */
            font-weight: 700;
        }

        /* 이미지 미리보기 스타일 보정 */
        .upload img {
            width: 90%;
            height: 100%;
            object-fit: cover;
            border-radius: 8px;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
</head>

<body>
  <div class="app">

      <header class="app-header">
          <button class="app-header_btn app-header_back" type="button" onclick="history.back()">
              <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
          </button>
      </header>

      <div class="app-main">

          <div class="app-tit">
              <div class="page-tit">직관일기</div>

              <div class="location-certify">
                  <button class="btn btn-certify w-auto" type="button" id="btnVerify"
                          <c:if test="${not empty selectedGame and not isVerifyPossible}">disabled style="background-color:#ccc; border:none; color:#fff; cursor:not-allowed;"</c:if>
                          onclick="certifyLocation()">
                      <c:choose>
                          <c:when test="${not empty selectedGame and not isVerifyPossible}">
                              ${not empty verifyRejectReason ? verifyRejectReason : '인증 불가'}
                          </c:when>
                          <c:otherwise>직관 인증하기</c:otherwise>
                      </c:choose>
                  </button>
                  <button class="btn btn-certify-comp w-auto" type="button" id="verifyComplete" style="display:none;">
                      직관 인증완료!
                  </button>
              </div>
          </div>

          <ul class="comment">
              <li>직관일기는 한 경기당 1개만 기록할 수 있어요.</li>
              <li>경기 시작 1시간 전까지는 다시 수정할 수 있어요.</li>
          </ul>

          <form id="diaryForm" action="/diary/write" method="post" enctype="multipart/form-data">
              <input type="hidden" name="gameId" id="gameId" value="${targetGameId}">
              <input type="hidden" name="verified" id="isVerified" value="false">
              <input type="hidden" name="rating" value="5">

              <div class="page-main_wrap">
                  <div class="history">
                      <div class="history-list mt-24">
                          <div class="diary_write_form">

                              <div class="diary_write_list req clr diary_character">
                                  <div class="tit">오늘, 직관 가세요?</div>
                                  <button type="button" class="select-field"
                                          <c:if test="${not isScoreEditable}">disabled style="background-color:#f5f5f5; cursor:not-allowed;"</c:if>
                                          <c:if test="${isScoreEditable}">onclick="openGameSheet()"</c:if> >
                                      <c:choose>
                                          <c:when test="${not empty selectedGame}">
                                              <span class="select-field_value" style="color:#000; font-weight:bold;">
                                                  ${selectedGame.awayTeamName} vs ${selectedGame.homeTeamName}
                                              </span>
                                          </c:when>
                                          <c:otherwise>
                                              <span class="select-field_value" id="gameSelectText">경기를 선택해주세요</span>
                                          </c:otherwise>
                                      </c:choose>
                                  </button>
                              </div>

                              <div class="diary_write_list req clr diary_character yellow" id="scoreInputWrap">
                                  <div class="tit">오늘의 스코어 예상해 본다면?</div>
                                  <div class="card_item">
                                      <div class="game-board">
                                          <div class="row row-center gap-6">
                                              <div class="team" id="awayTeamBox">
                                                  <div class="my-team" id="awayMyTeam" style="display:none;">MY</div>
                                                  <div class="team-logo mb-4">
                                                      <img id="awayTeamLogo" src="/img/team_default.svg" alt="원정팀" style="width: 48px; height: 48px; object-fit: contain;">
                                                  </div>
                                                  <div class="team-name" id="awayTeamName">AWAY</div>
                                              </div>

                                              <div class="game-score schedule">
                                                  <div class="left-team-score">
                                                      <input type="number" name="predScoreAway" min="0" max="99"
                                                             <c:if test="${not isScoreEditable}">readonly placeholder="-" style="background-color:transparent; color:#999;"</c:if>
                                                             <c:if test="${isScoreEditable}">oninput="if(this.value > 99) this.value = 99; if(this.value !== '' && this.value < 0) this.value = 0;" placeholder="0"</c:if> >
                                                  </div>
                                                  <div class="game-info-wrap">VS</div>
                                                  <div class="right-team-score">
                                                      <input type="number" name="predScoreHome" min="0" max="99"
                                                             <c:if test="${not isScoreEditable}">readonly placeholder="-" style="background-color:transparent; color:#999;"</c:if>
                                                             <c:if test="${isScoreEditable}">oninput="if(this.value > 99) this.value = 99; if(this.value !== '' && this.value < 0) this.value = 0;" placeholder="0"</c:if> >
                                                  </div>
                                              </div>

                                              <div class="team" id="homeTeamBox">
                                                  <div class="my-team" id="homeMyTeam" style="display:none;">MY</div>
                                                  <div class="team-logo mb-4">
                                                      <img id="homeTeamLogo" src="/img/team_default.svg" alt="홈팀" style="width: 48px; height: 48px; object-fit: contain;">
                                                  </div>
                                                  <div class="team-name" id="homeTeamName">HOME</div>
                                              </div>
                                          </div>
                                      </div>
                                  </div>
                              </div>

                              <div class="diary_write_list">
                                  <div class="tit">오늘의 히어로는 누구일까?</div>
                                  <input type="text" name="heroName" id="heroName" maxlength="100" placeholder="최대 100자까지 입력하실 수 있습니다.">
                              </div>

                              <div class="diary_write_list">
                                  <div class="tit">오늘의 경기를 한 마디로 평가한다면?!</div>
                                  <input type="text" name="oneLineComment" id="oneLine" maxlength="100" placeholder="최대 100자까지 입력하실 수 있습니다.">
                              </div>

                              <div class="diary_write_list">
                                  <div class="tit">오늘의 경기를 기록해 보세요</div>
                                  <textarea name="content" maxlength="1000" placeholder="최대 1,000자까지 입력하실 수 있습니다."></textarea>
                              </div>

                              <div class="diary_write_list">
                                  <div class="tit">오늘 경기 사진을 올려보세요</div>
                                  <button type="button" class="btn btn-primary gap-4" onclick="document.getElementById('fileUpload').click();">
                                      사진 올리기 (최대 4장)
                                      <span><img src="/img/ico_plus.svg" alt="플러스 아이콘"></span>
                                  </button>
                                  <input type="file" id="fileUpload" name="files" style="display:none;" accept="image/jpeg, image/png" multiple onchange="handleFileSelect(this)">

                                  <div class="upload" id="imagePreviewBox" style="display:none; margin-top:12px; white-space: nowrap; overflow-x: auto; padding-bottom: 8px;"></div>
                                  <div class="file-mes"><img src="/img/ico_not_mark_blue.svg" alt="주의 아이콘">최대 10MB 의 JPG, PNG만 등록 가능합니다.</div>
                              </div>

                              <ul class="disClose">
                                  <li>
                                      <label class="check">
                                          <input type="radio" name="isPublic" value="PUBLIC" checked>
                                          전체공개
                                      </label>
                                  </li>
                                  <li>
                                      <label class="check">
                                          <input type="radio" name="isPublic" value="FRIENDS">
                                          맞팔 공개
                                      </label>
                                  </li>
                                  <li>
                                      <label class="check">
                                          <input type="radio" name="isPublic" value="PRIVATE">
                                          비공개
                                      </label>
                                  </li>
                              </ul>
                          </div>
                      </div>
                  </div>
              </div>
          </form>
      </div>

      <div class="bottom-action bottom-main">
          <button type="button" class="btn btn-primary" id="btnNext" onclick="submitDiary()">
              기록하기
          </button>
      </div>

      <div class="sheet-backdrop" id="selectSheet">
          <div class="sheet select-sheet" role="dialog" aria-modal="true">
              <div class="select-sheet_header">
                  <div class="select-sheet_title">경기를 선택해주세요</div>
              </div>

              <div class="select-sheet_body">
                  <ul class="select-sheet_list" id="selectSheetList">
                  </ul>
              </div>

              <div class="select-sheet_footer">
                  <button type="button" class="btn btn-gray" onclick="closeGameSheet()">취소</button>
                  <button type="button" class="btn btn-primary" id="selectSheetApply" disabled
                          onclick="applyGameSelection()">저장
                  </button>
              </div>
          </div>
      </div>

  </div>

  <%@ include file="../include/popup.jsp" %>

  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="/js/script.js"></script>
  <script src="/js/app_interface.js"></script>
  <script>
      // 임시 저장용 변수 (팝업 내 선택값)
      let tempSelectedGame = null;

      $(document).ready(function () {
          // 초기 로드 시 선택된 경기 UI 세팅
          if ('${targetGameId}' !== '') {
              // 원정 무조건 왼쪽, 홈 무조건 오른쪽
              $('#awayTeamName').text('${selectedGame.awayTeamName}');
              $('#homeTeamName').text('${selectedGame.homeTeamName}');

              const aCode = '${selectedGame.awayTeamCode}';
              const hCode = '${selectedGame.homeTeamCode}';

              // DB에서 가져온 로고 이미지 URL 직접 할당 (없을 경우 기본 이미지)
              $('#awayTeamLogo').attr('src', '${selectedGame.awayTeamLogo}' || '/img/team_default.svg');
              $('#homeTeamLogo').attr('src', '${selectedGame.homeTeamLogo}' || '/img/team_default.svg');

              // MY 팀 배지 처리
              const myTeam = '${sessionScope.loginMember.myTeamCode}';
              if (aCode === myTeam) $('#awayMyTeam').show();
              if (hCode === myTeam) $('#homeMyTeam').show();

              $('#btnNext').prop('disabled', false);
          }
      });

      // 1. 경기 선택 팝업 열기
      function openGameSheet() {
          $('#selectSheet').addClass('is-open');

          // 팝업 열 때마다 초기화
          tempSelectedGame = null;
          $('#selectSheetApply').prop('disabled', true);

          $.get('/diary/api/games', function (data) {
              const list = $('#selectSheetList');
              list.empty();

              if (!data || data.length === 0) {
                  list.append('<li style="text-align:center; padding:20px;">경기 일정이 없습니다.</li>');
                  return;
              }

              data.forEach(game => {
                  const title = game.awayTeamName + ' vs ' + game.homeTeamName;
                  const itemHtml = `
                          <li>
                              <button type="button"
                                  data-id="\${game.gameId}"
                                  data-home-name="\${game.homeTeamName}"
                                  data-away-name="\${game.awayTeamName}"
                                  data-home-code="\${game.homeTeamCode}"
                                  data-away-code="\${game.awayTeamCode}"
                                  data-home-logo="\${game.homeTeamLogo}"
                                  data-away-logo="\${game.awayTeamLogo}"
                                  data-status="\${game.status}"
                                  data-date="\${game.gameDate}"
                                  data-time="\${game.gameTime}"
                                  onclick="selectGameItem(this)">
                                  <span class="match">\${title}</span>
                                  <span class="place">(\${game.stadiumName})</span>
                              </button>
                          </li>
                      `;
                  list.append(itemHtml);
              });
          });
      }

      function closeGameSheet() {
          $('#selectSheet').removeClass('is-open');
      }

      // 리스트 아이템 클릭 시 (바로 닫지 않고 선택 상태만 변경)
      function selectGameItem(btn) {
          // 스타일 변경 (모든 버튼 active 제거 -> 현재 버튼 active 추가)
          $('#selectSheetList button').removeClass('active');
          $(btn).addClass('active');

          // 데이터 임시 저장
          tempSelectedGame = {
              id: $(btn).data('id'),
              homeName: $(btn).data('home-name'),
              awayName: $(btn).data('away-name'),
              homeCode: $(btn).data('home-code'),
              awayCode: $(btn).data('away-code'),
              homeLogo: $(btn).data('home-logo'),
              awayLogo: $(btn).data('away-logo'),
              status: $(btn).data('status'),
              date: $(btn).data('date'),
              time: $(btn).data('time')
          };

          // 저장 버튼 활성화
          $('#selectSheetApply').prop('disabled', false);
      }

      /**
       * [최종] 경기 선택 적용 함수
       * 1. UI: 내 응원팀을 무조건 왼쪽(HOME 위치)에 배치하여 입력 편의성 제공
       * 2. Data: 실제 홈/원정 여부에 따라 input name 속성을 동적으로 변경하여 서버 데이터 정합성 유지
       */
      function applyGameSelection() {
          if (!tempSelectedGame) return;

          const g = tempSelectedGame;
          const myTeamCode = '${sessionScope.loginMember.myTeamCode}';

          // 1. 게임 ID 설정
          $('#gameId').val(g.id);

          // 2. 상단 텍스트 표기
          $('#gameSelectText').text(g.awayName + ' vs ' + g.homeName)
              .css('color', '#000').css('font-weight', 'bold');

          // 3. 화면 업데이트 (원정은 무조건 왼쪽, 홈은 무조건 오른쪽)
          $('#awayTeamName').text(g.awayName);
          $('#homeTeamName').text(g.homeName);

          // DB에 저장된 로고 경로를 바로 적용 (없을 경우 기본 이미지 매핑)
          $('#awayTeamLogo').attr('src', g.awayLogo || '/img/team_default.svg');
          $('#homeTeamLogo').attr('src', g.homeLogo || '/img/team_default.svg');

          // 4. MY 뱃지 표시 제어
          if (g.awayCode === myTeamCode) $('#awayMyTeam').show();
          else $('#awayMyTeam').hide();
          if (g.homeCode === myTeamCode) $('#homeMyTeam').show(); else $('#homeMyTeam').hide();

          // 경기 상태에 따른 스코어 입력창 활성/비활성 처리
          let isEditable = true;
          let isVerifyPos = true;
          let rejectReason = "";

          if (g.status === 'FINISHED' || g.status === 'CANCELLED') {
              isEditable = false;
              isVerifyPos = false;
              rejectReason = "종료된 경기";
          } else {
              if (g.date && g.time) {
                  let t = g.time.length === 5 ? g.time + ':00' : g.time;
                  let start = new Date(g.date + 'T' + t);
                  let now = new Date();

                  // 스코어 제어: 시작 1시간 전
                  let editStart = new Date(start.getTime());
                  editStart.setHours(editStart.getHours() - 1);
                  if (now > editStart) isEditable = false;

                  // 인증 제어: 시작 2시간 전 미만이거나 1시간 후면 불가
                  let verifyStart = new Date(start.getTime());
                  verifyStart.setHours(verifyStart.getHours() - 2);

                  let verifyEnd = new Date(start.getTime());
                  verifyEnd.setHours(verifyEnd.getHours() + 1);

                  if (now < verifyStart) {
                      isVerifyPos = false;
                      rejectReason = "인증 시간 전";
                  } else if (now > verifyEnd) {
                      isVerifyPos = false;
                      rejectReason = "인증 시간 초과";
                  }
              }
          }

          // 인증 버튼 UI 동적 변경
          if (!isVerifyPos) {
              $('#btnVerify').prop('disabled', true)
                  .css({'background-color':'#ccc', 'border':'none', 'color':'#fff', 'cursor':'not-allowed'})
                  .text(rejectReason);
          } else {
              $('#btnVerify').prop('disabled', false)
                  .css({'background-color':'', 'border':'', 'color':'', 'cursor':'pointer'})
                  .text('직관 인증하기');
          }

          window.isScoreEditableDynamic = isEditable;
          // 전역 플래그 업데이트

          const $scoreAway = $('input[name="predScoreAway"]');
          const $scoreHome = $('input[name="predScoreHome"]');

          if (!isEditable) {
              $scoreAway.prop('readonly', true).css({'background-color':'transparent', 'color':'#999'}).val('').attr('placeholder', '-');
              $scoreHome.prop('readonly', true).css({'background-color':'transparent', 'color':'#999'}).val('').attr('placeholder', '-');
              // 스코어 수정 불가 시 띠를 회색으로 변경
              $('#scoreInputWrap').removeClass('clr');
          } else {
              $scoreAway.prop('readonly', false).css({'background-color':'', 'color':'#000'}).val('').attr('placeholder', '0');
              $scoreHome.prop('readonly', false).css({'background-color':'', 'color':'#000'}).val('').attr('placeholder', '0');
              // 스코어 수정 가능 시 띠를 초록색으로 복구
              $('#scoreInputWrap').addClass('clr');
          }

          $('#btnNext').prop('disabled', false);
          closeGameSheet();
      }

      // [직관 인증 함수]
      async function certifyLocation() {
          // 1. 경기 선택 여부 확인
          const gameId = $('#gameId').val();
          if (!gameId) {
              alert('먼저 경기를 선택해주세요.');
              openGameSheet();
              return;
          }

          // UI 로딩 처리
          const $btn = $('#btnVerify');
          const originalText = $btn.text();
          $btn.text('위치 확인 중...').prop('disabled', true);

          let lat = 0;
          let lon = 0;

          try {
              // ----------------------------------------------------
              // [CASE 1] Appify 앱 환경
              // ----------------------------------------------------
              if (typeof appify !== 'undefined' && appify.isWebview) {
                  // 1) 권한 통합 체크 (문서 19.txt)
                  const permStatus = await appify.permission.check('location');
                  if (permStatus === 'denied') {
                      customConfirm("위치 권한이 필요합니다. 설정으로 이동하시겠습니까?", async function() {
                          await appify.linking.openSettings();
                      });
                      // 팝업이 뜨는 동안 버튼 상태를 원래대로 복구하고 함수 종료 (에러 throw 대신)
                      $btn.text(originalText).prop('disabled', false);
                      return;
                  } else if (permStatus === 'undetermined') {
                      const reqStatus = await appify.permission.request('location');
                      if (reqStatus !== 'granted') throw new Error("권한 요청 거부됨");
                  }

                  // 2) 위치 정보 가져오기 (문서 12.txt)
                  const position = await appify.location.getCurrentPosition();
                  lat = position.latitude;
                  lon = position.longitude;
              }
                  // ----------------------------------------------------
                  // [CASE 2] 일반 모바일 웹 (표준 API)
              // ----------------------------------------------------
              else {
                  if (!navigator.geolocation) {
                      alert("위치 정보를 사용할 수 없는 브라우저입니다.");
                      throw new Error("Geolocation 미지원");
                  }
                  const position = await new Promise((resolve, reject) => {
                      navigator.geolocation.getCurrentPosition(resolve, reject, {
                          enableHighAccuracy: true, timeout: 10000
                      });
                  });
                  lat = position.coords.latitude;
                  lon = position.coords.longitude;
              }

              console.log('좌표 획득 성공: ', lat, lon);

              // 3. 서버 검증 요청 (기존 로직 유지)
              $.ajax({
                  url: '/diary/verify/gps',
                  type: 'POST',
                  data: { gameId: gameId, lat: lat, lon: lon },
                  success: function(res) {
                      if (res === 'ok') {
                          alert('직관 인증 성공! 🎉');
                          $('#btnVerify').hide();
                          $('#verifyComplete').show();
                          $('#isVerified').val('true');
                      } else if (res === 'fail:distance') {
                          alert('경기장과 거리가 너무 멀어요! 🏟️\n경기장 근처에서 다시 시도해주세요.');
                          $btn.text(originalText).prop('disabled', false); // 버튼 복구
                      } else if (res === 'fail:not_yet') {
                          alert('직관 인증은 경기 시작 2시간 전부터 가능합니다.');
                          $btn.text('인증 시간 전').prop('disabled', true).css({'background-color':'#ccc', 'border':'none', 'color':'#fff', 'cursor':'not-allowed'});
                      } else if (res === 'fail:timeout') {
                          alert('경기 시작 후 1시간이 지나 직관 인증을 할 수 없습니다.');
                          // 팝업 확인 후 버튼을 아예 막아버림
                          $btn.text('인증 시간 초과').prop('disabled', true).css({'background-color':'#ccc', 'border':'none', 'color':'#fff', 'cursor':'not-allowed'});
                      } else if (res === 'fail:game_ended') {
                          alert('이미 종료되거나 취소된 경기입니다.');
                          $btn.text('인증 불가').prop('disabled', true).css({'background-color':'#ccc', 'border':'none', 'color':'#fff', 'cursor':'not-allowed'});
                      } else {
                          alert('인증 실패: ' + res);
                          $btn.text(originalText).prop('disabled', false);
                      }
                  },
                  error: function() {
                      alert('서버 통신 오류가 발생했습니다.');
                      $btn.text(originalText).prop('disabled', false);
                  }
              });

          } catch (error) {
              console.error(error);
              // 앱이 아니거나 단순 오류일 경우 메시지 처리
              if (error.message !== "권한 거부됨") {
                  alert("위치 정보를 가져올 수 없습니다.\nGPS가 켜져 있는지 확인해주세요.");
              }
              $btn.text(originalText).prop('disabled', false);
          }
      }

      // 3. 이미지 미리보기
      // 사진 다중 업로드 관리 로직
      let selectedFiles = [];
      const MAX_FILES = 4;

      function handleFileSelect(input) {
          const files = input.files;
          if (!files || files.length === 0) return;

          let total = selectedFiles.length + files.length;
          if (total > MAX_FILES) {
              alert('사진은 최대 4장까지 업로드 가능합니다.');
          }

          // 용량 및 확장자 체크 기준 설정
          const maxSize = 10 * 1024 * 1024; // 10MB
          const validTypes = ['image/jpeg', 'image/png'];

          for (let i = 0; i < files.length; i++) {
              const file = files[i];

              // 1. 용량 검사 (10MB 초과 시 통과 안 됨)
              if (file.size > maxSize) {
                  alert('[' + file.name + '] 파일 용량이 10MB를 초과합니다.');
                  continue;
              }

              // 2. 확장자 검사 (JPG, PNG 외 통과 안 됨)
              if (!validTypes.includes(file.type)) {
                  alert('[' + file.name + '] JPG, PNG 파일만 업로드 가능합니다.');
                  continue;
              }

              // 조건 통과 & 최대 4장 제한에 걸리지 않는 파일만 최종 배열에 추가
              if (selectedFiles.length < MAX_FILES) {
                  selectedFiles.push(file);
              }
          }
          renderPreviews();
          input.value = ''; // 재선택 가능하도록 초기화
      }

      function removeFile(index) {
          selectedFiles.splice(index, 1);
          renderPreviews();
      }

      function renderPreviews() {
          const box = $('#imagePreviewBox');
          box.empty();
          if (selectedFiles.length === 0) {
              box.hide();
              return;
          }
          box.show();

          selectedFiles.forEach((file, index) => {
              const divId = 'preview_new_' + index;
              const html = `<div id="\${divId}" style="position:relative; display:inline-block; margin-right:8px; width:80px; height:80px;">
                                <img src="" style="width:100%; height:100%; object-fit:cover; border-radius:8px;">
                                <button type="button" onclick="removeFile(\${index})" style="position:absolute; top:-6px; right:-6px; background:#fff; border-radius:50%; padding:2px; border:1px solid #ddd; width:24px; height:24px; display:flex; align-items:center; justify-content:center;">
                                    <img src="/img/ico_del.svg" style="width:14px;">
                                </button>
                              </div>`;
              box.append(html);

              const reader = new FileReader();
              reader.onload = function(e) {
                  $('#' + divId + ' img').first().attr('src', e.target.result);
              };
              reader.readAsDataURL(file);
          });
      }

      // 4. 제출
      function submitDiary() {

          // 터치 시 짧은 진동 피드백
          if (typeof vibrateSuccess === 'function') vibrateSuccess();

          // 1) 필수값 체크: 경기 선택 (req 클래스 항목)
          if (!$('#gameId').val()) {
              if (typeof vibrateError === 'function') vibrateError(); // 에러 진동
              alert('경기를 선택해주세요.', function() {
                  openGameSheet();
              });
              return;
          }

          // 2) 필수값 체크: 스코어 (작성 가능 기간일 때만 필수 검사)
          const isScoreEditable = window.isScoreEditableDynamic !== undefined ? window.isScoreEditableDynamic : ${isScoreEditable};
          if (isScoreEditable) {
              var scoreHome = $('input[name="predScoreHome"]');
              var scoreAway = $('input[name="predScoreAway"]');

              if (scoreHome.val() === '' || scoreAway.val() === '') {
                  alert('예상 스코어를 입력해주세요!', function() {
                      if(scoreHome.val() === '') scoreHome.focus();
                      else scoreAway.focus();
                  });
                  return;
              }
          }

          // 폼 전송 직전, 배열에 모아둔 파일들을 실제 input에 옮겨 담기
          const dataTransfer = new DataTransfer();
          selectedFiles.forEach(file => {
              dataTransfer.items.add(file);
          });
          document.getElementById('fileUpload').files = dataTransfer.files;

          // 3) 직관 인증 여부 확인 (미인증 시 컨펌)
          const isVerified = $('#isVerified').val();

          if (isVerified !== 'true') {
              customConfirm("정말로 직관 인증을 하지 않고 저장하시겠어요?\n인증 시, 승률 계산에 반영돼요!",
                  function() {
                      // [확인] 제출 진행
                      $('#diaryForm').submit();
                  },
                  function() {
                      // [취소] 인증 버튼으로 포커스 이동
                      $('#btnVerify').focus();
                  }
              );
          } else {
              // 인증된 상태면 바로 제출
              $('#diaryForm').submit();
          }
      }
  </script>
</body>
</html>