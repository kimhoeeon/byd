<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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

    <title>일기 수정 | 승요일기</title>

    <style>
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
                <div class="page-tit">일기 수정</div>
            </div>

            <form id="diaryForm" action="/diary/update" method="post" enctype="multipart/form-data">
                <input type="hidden" name="diaryId" value="${diary.diaryId}">
                <input type="hidden" name="gameId" value="${diary.gameId}">

                <div class="page-main_wrap">
                    <div class="history">
                        <div class="history-list mt-24">
                            <div class="diary_write_form">

                                <div class="diary_write_list req diary_character">
                                    <div class="tit">직관한 경기</div>
                                    <button type="button" class="select-field" disabled style="opacity: 1; cursor: default;">
                                        <span class="select-field_value" style="color:#000; font-weight:bold;">
                                            [${diary.stadiumName}] ${diary.awayTeamName} vs ${diary.homeTeamName}
                                            <span style="font-weight:400; font-size:13px; margin-left:4px;">
                                                (${fn:substring(diary.gameDate, 5, 7)}.${fn:substring(diary.gameDate, 8, 10)})
                                            </span>
                                        </span>
                                    </button>
                                </div>

                                <div class="diary_write_list req diary_character yellow ${isScoreEditable ? 'clr' : ''}">
                                    <div class="tit">
                                        <c:choose>
                                            <c:when test="${isScoreEditable}">스코어를 수정하시겠어요?</c:when>
                                            <c:otherwise>내가 예상한 스코어 <span style="font-size:12px; color:#ff4d4d; font-weight:normal;">(스코어 수정 불가)</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="card_item">
                                        <div class="game-board">
                                            <div class="row row-center gap-6">

                                                <div class="team">
                                                    <div class="team-logo mb-8">
                                                        <img src="${diary.awayTeamLogo}" alt="${diary.awayTeamName}" style="height: 48px; width: auto; object-fit: contain;">
                                                    </div>

                                                    <div class="team-name">${diary.awayTeamName}</div>
                                                    <div class="starting mt-4">${diary.awayStarter}</div>
                                                </div>

                                                <div class="game-score schedule">
                                                    <div class="left-team-score">
                                                        <c:choose>
                                                            <c:when test="${isScoreEditable}">
                                                                <input type="number" name="predScoreAway" value="${diary.predScoreAway}" min="0" max="99" oninput="if(this.value > 99) this.value = 99; if(this.value !== '' && this.value < 0) this.value = 0;" placeholder="0">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <input type="number" name="predScoreAway" value="${diary.predScoreAway}" readonly style="background:transparent; border:none; text-align:center; font-size:24px; font-weight:bold; color:#000;" min="0" max="99" oninput="if(this.value > 99) this.value = 99; if(this.value !== '' && this.value < 0) this.value = 0;" placeholder="0">
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="game-info-wrap">VS</div>
                                                    <div class="right-team-score">
                                                        <c:choose>
                                                            <c:when test="${isScoreEditable}">
                                                                <input type="number" name="predScoreHome" value="${diary.predScoreHome}" min="0" max="99" oninput="if(this.value > 99) this.value = 99; if(this.value !== '' && this.value < 0) this.value = 0;" placeholder="0">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <input type="number" name="predScoreHome" value="${diary.predScoreHome}" readonly style="background:transparent; border:none; text-align:center; font-size:24px; font-weight:bold; color:#000;" min="0" max="99" oninput="if(this.value > 99) this.value = 99; if(this.value !== '' && this.value < 0) this.value = 0;" placeholder="0">
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>

                                                <div class="team">
                                                    <div class="team-logo mb-8">
                                                        <img src="${diary.homeTeamLogo}" alt="${diary.homeTeamName}" style="height: 48px; width: auto; object-fit: contain;">
                                                    </div>

                                                    <div class="team-name">${diary.homeTeamName}</div>
                                                    <div class="starting mt-4">${diary.homeStarter}</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="diary_write_list clr">
                                    <div class="tit">오늘의 히어로는 누구일까?</div>
                                    <input type="text" name="heroName" id="heroName" value="${diary.heroName}" maxlength="100" placeholder="최대 100자까지 입력하실 수 있습니다.">
                                </div>

                                <div class="diary_write_list clr">
                                    <div class="tit">오늘의 경기를 한 마디로 평가한다면?!</div>
                                    <input type="text" name="oneLineComment" id="oneLine" value="${diary.oneLineComment}" maxlength="100" placeholder="최대 100자까지 입력하실 수 있습니다.">
                                </div>

                                <div class="diary_write_list clr">
                                    <div class="tit">오늘의 경기를 기록해 보세요</div>
                                    <textarea name="content" maxlength="1000" placeholder="최대 1,000자까지 입력하실 수 있습니다.">${diary.content}</textarea>
                                </div>

                                <div class="diary_write_list clr">
                                    <div class="tit">오늘 경기 사진을 올려보세요</div>
                                    <button type="button" class="btn btn-primary gap-4" onclick="document.getElementById('fileUpload').click();">
                                        사진 변경하기 (최대 4장)
                                        <span><img src="/img/ico_plus.svg" alt="플러스 아이콘"></span>
                                    </button>
                                    <input type="file" id="fileUpload" name="files" style="display:none;" accept="image/jpeg, image/png" multiple onchange="handleFileSelect(this)">

                                    <div class="upload" id="imagePreviewBox" style="display:none; margin-top:12px; white-space: nowrap; overflow-x: auto; padding-bottom: 8px;"></div>
                                    <div class="file-mes"><img src="/img/ico_not_mark_blue.svg" alt="주의 아이콘">최대 10MB 의 JPG, PNG만 등록 가능합니다.</div>
                                </div>

                                <div class="diary_write_list">
                                    <ul class="disClose">
                                        <li>
                                            <label class="check">
                                                <input type="radio" name="isPublic" value="PUBLIC" ${diary.isPublic eq 'PUBLIC' ? 'checked' : ''}>
                                                전체공개
                                            </label>
                                        </li>
                                        <li>
                                            <label class="check">
                                                <input type="radio" name="isPublic" value="FRIENDS" ${diary.isPublic eq 'FRIENDS' ? 'checked' : ''}>
                                                맞팔 공개
                                            </label>
                                        </li>
                                        <li>
                                            <label class="check">
                                                <input type="radio" name="isPublic" value="PRIVATE" ${diary.isPublic eq 'PRIVATE' ? 'checked' : ''}>
                                                비공개
                                            </label>
                                        </li>
                                    </ul>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>

        <div class="bottom-action bottom-main">
            <button type="button" class="btn btn-primary" onclick="submitDiary()">
                수정 완료
            </button>
        </div>

    </div>

    <%@ include file="../include/popup.jsp" %>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>

    <script>
        let existingImages = [];
        // 서버에서 받아온 콤마 구분자 이미지를 배열에 초기 세팅
        <c:if test="${not empty diary.imageUrl}">
            <c:set var="imgArr" value="${fn:split(diary.imageUrl, ',')}" />
            <c:forEach var="imgSrc" items="${imgArr}">
                existingImages.push('${imgSrc}');
            </c:forEach>
        </c:if>

        let selectedFiles = [];
        const MAX_FILES = 4;

        $(document).ready(function() {
            renderPreviews(); // 진입 시 기존 이미지 렌더링
        });

        function handleFileSelect(input) {
            const files = input.files;
            if (!files || files.length === 0) return;

            let total = existingImages.length + selectedFiles.length + files.length;
            if (total > MAX_FILES) {
                alert('사진은 최대 4장까지 업로드 가능합니다.');
            }

            // 용량 및 확장자 체크 기준 설정
            const maxSize = 10 * 1024 * 1024; // 10MB
            const validTypes = ['image/jpeg', 'image/png'];

            for (let i = 0; i < files.length; i++) {
                const file = files[i];

                // 1. 용량 검사
                if (file.size > maxSize) {
                    alert('[' + file.name + '] 파일 용량이 10MB를 초과합니다.');
                    continue;
                }

                // 2. 확장자 검사
                if (!validTypes.includes(file.type)) {
                    alert('[' + file.name + '] JPG, PNG 파일만 업로드 가능합니다.');
                    continue;
                }

                // 조건 통과 & (기존 이미지 + 새로 선택한 이미지)가 최대 4장 이내일 때 추가
                if (existingImages.length + selectedFiles.length < MAX_FILES) {
                    selectedFiles.push(file);
                }
            }
            renderPreviews();
            input.value = '';
        }

        function removeFile(index) {
            selectedFiles.splice(index, 1);
            renderPreviews();
        }

        function removeExistingImage(index) {
            existingImages.splice(index, 1); // 기존 이미지 삭제 시 배열에서 제거
            renderPreviews();
        }

        function renderPreviews() {
            const box = $('#imagePreviewBox');
            box.empty();
            if (selectedFiles.length === 0 && existingImages.length === 0) {
                box.hide(); return;
            }
            box.show();

            // 1. 기존 이미지 노출 (hidden 폼 전송 포함)
            existingImages.forEach((url, index) => {
                const html = `<div style="position:relative; display:inline-block; margin-right:8px; width:80px; height:80px;">
                                <img src="\${url}" style="width:100%; height:100%; object-fit:cover; border-radius:8px;">
                                <button type="button" onclick="removeExistingImage(\${index})" style="position:absolute; top:-6px; right:-6px; background:#fff; border-radius:50%; padding:2px; border:1px solid #ddd; width:24px; height:24px; display:flex; align-items:center; justify-content:center;">
                                    <img src="/img/ico_del.svg" style="width:14px;">
                                </button>
                                <input type="hidden" name="existingImages" value="\${url}">
                              </div>`;
                box.append(html);
            });

            // 2. 신규 추가 파일 노출
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

        // 제출
        function submitDiary() {
            // 1) 필수값 체크: 스코어 (수정 가능 상태일 때만 검사)
            const isScoreEditable = ${isScoreEditable};

            if (isScoreEditable) {
                var scoreHome = $('input[name="predScoreHome"]');
                var scoreAway = $('input[name="predScoreAway"]');

                if (scoreHome.val() === '' || scoreAway.val() === '') {
                    alert('스코어를 입력해주세요!', function() {
                        if(scoreHome.val() === '') scoreHome.focus();
                        else scoreAway.focus();
                    });
                    return;
                }
            }

            // 폼 전송 직전, 배열에 새로 추가한 파일들을 실제 input에 옮겨 담기
            const dataTransfer = new DataTransfer();
            selectedFiles.forEach(file => {
                dataTransfer.items.add(file);
            });
            document.getElementById('fileUpload').files = dataTransfer.files;

            // 폼 전송
            document.getElementById('diaryForm').submit();
        }
    </script>
</body>
</html>