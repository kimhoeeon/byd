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

    <title>알림 설정 | 승요일기</title>

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
</head>

<body>
    <div class="app">

        <header class="app-header">
            <button class="app-header_btn app-header_back" type="button" onclick="history.back()">
                <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
            </button>
        </header>

        <div class="app-main column">

            <div class="app-tit">
                <div class="page-tit">알림 설정</div>
            </div>

            <div class="stack mt-24">

                <div class="my-alarm-info">

                    <div class="my-alarm-item">
                        <div class="txt-wrap">
                            <div class="tit">전체 알림</div>
                            <div class="desc" style="font-size:13px; color:#8B95A1; margin-top:4px;">승요일기의 모든 푸시 알림을 설정합니다.</div>
                        </div>
                        <div class="action">
                            <label class="toggle">
                                <input type="checkbox" id="toggleAll" class="toggle_input"
                                       onchange="updateMasterAlarm(this)"
                                ${empty member.pushYn or member.pushYn eq 'Y' ? 'checked' : ''}>
                                <span class="toggle_track">
                                    <span class="toggle_thumb"></span>
                                </span>
                            </label>
                        </div>
                    </div>

                    <div class="divider" style="height:1px; background:var(--color-border); margin: 0;"></div>

                    <div class="my-alarm-item">
                        <div class="txt-wrap">
                            <div class="tit">경기 시작 알림</div>
                            <div class="desc" style="font-size:13px; color:#8B95A1; margin-top:4px;">마이팀 경기 시작 30분 전 알려드려요.</div>
                        </div>
                        <div class="action">
                            <label class="toggle">
                                <input type="checkbox" id="toggleGame" class="toggle_input sub-alarm"
                                       onchange="updateAlarm('game', this)"
                                ${member.gameAlarm == 'Y' ? 'checked' : ''}>
                                <span class="toggle_track">
                                    <span class="toggle_thumb"></span>
                                </span>
                            </label>
                        </div>
                    </div>

                    <div class="my-alarm-item">
                        <div class="txt-wrap">
                            <div class="tit">친구 활동 알림</div>
                            <div class="desc" style="font-size:13px; color:#8B95A1; margin-top:4px;">친구가 나를 팔로우하거나 내 일기를 조회했을 때 알려드려요.</div>
                        </div>
                        <div class="action">
                            <label class="toggle">
                                <input type="checkbox" id="toggleFriend" class="toggle_input sub-alarm"
                                       onchange="updateAlarm('friend', this)"
                                ${member.friendAlarm == 'Y' ? 'checked' : ''}>
                                <span class="toggle_track">
                                    <span class="toggle_thumb"></span>
                                </span>
                            </label>
                        </div>
                    </div>

                    <div class="my-alarm-item b-0">
                        <div class="txt-wrap">
                            <div class="tit">마케팅 정보 알림</div>
                            <div class="desc" style="font-size:13px; color:#8B95A1; margin-top:4px;">이벤트 및 혜택 정보를 받아보실 수 있어요.</div>
                        </div>
                        <div class="action">
                            <label class="toggle">
                                <input type="checkbox" id="toggleMarketing" class="toggle_input sub-alarm"
                                       onchange="updateAlarm('marketing', this)"
                                ${member.marketingAgree == 'Y' ? 'checked' : ''}>
                                <span class="toggle_track">
                                    <span class="toggle_thumb"></span>
                                </span>
                            </label>
                        </div>
                    </div>

                    <div class="pre">
                        전체 알림을 끄시면 설정된 개별 알림도 오지 않습니다.<br>
                        기기 설정 > 알림 > 승요일기 에서도 알림 허용이 필요합니다.
                    </div>

                    <div class="alarm-setting-section" style="margin-top: 30px; padding: 20px; background-color: #f9f9f9; border-radius: 12px;">
                        <p style="font-size: 14px; color: #666; margin-bottom: 12px;">혹시 푸시 알림이 오지 않나요?</p>
                        <button type="button" class="btn btn-outline-secondary btn-sm" onclick="openAppSettings()" style="width: 100%;">
                            기기 알림 설정 바로가기 >
                        </button>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
    <script>
        $(document).ready(function() {
            // 페이지 로드 시 전체 알림 상태에 따라 하위 토글 제어
            const isMasterOn = $('#toggleAll').is(':checked');
            toggleSubSwitches(isMasterOn);
        });

        // 1. 전체 알림 제어
        function updateMasterAlarm(element) {
            const isChecked = element.checked;
            const value = isChecked ? 'Y' : 'N';

            toggleSubSwitches(isChecked);

            $.post('/member/alarm/update', { type: 'PUSH', value: value }, function(res) {
                if(res !== 'ok') {
                    alert('설정 변경에 실패했습니다.');
                    rollback(element, !isChecked);
                    toggleSubSwitches(!isChecked);
                }
            }).fail(function() {
                alert('서버 통신 오류가 발생했습니다.');
                rollback(element, !isChecked);
                toggleSubSwitches(!isChecked);
            });
        }

        // 2. 개별 알림 제어
        function updateAlarm(type, element) {
            // 전체 알림이 꺼져있으면 개별 설정 시도 차단
            if (!$('#toggleAll').is(':checked')) {
                alert('전체 알림을 먼저 켜주세요.');
                rollback(element, !element.checked);
                return;
            }

            const isChecked = element.checked;
            const value = isChecked ? 'Y' : 'N';

            $.post('/member/alarm/update', { type: type.toUpperCase(), value: value }, function(res) {
                if(res !== 'ok') {
                    alert('설정 변경에 실패했습니다.');
                    rollback(element, !isChecked);
                }
            }).fail(function() {
                alert('서버 통신 오류가 발생했습니다.');
                rollback(element, !isChecked);
            });
        }

        // 하위 스위치 활성/비활성 처리
        function toggleSubSwitches(isEnabled) {
            // toggle_input이면서 sub-alarm인 요소들 제어
            $('.toggle_input.sub-alarm').each(function() {
                const $el = $(this);

                // 전체 알림 상태에 맞춰 하위 스위치 체크(checked) 상태도 동기화
                $el.prop('checked', isEnabled);

                // disabled 속성 토글 (base.css의 :disabled 스타일 자동 적용됨)
                $el.prop('disabled', !isEnabled);

                // (선택사항) 텍스트 등 전체 영역을 흐리게 처리하여 UX 강화
                const $parent = $el.closest('.my-alarm-item');
                if (!isEnabled) {
                    $parent.css('opacity', '0.5');
                } else {
                    $parent.css('opacity', '1');
                }
            });
        }

        function rollback(element, originalStatus) {
            element.checked = originalStatus;
        }

        // [앱 설정창 열기]
        async function openAppSettings() {
            try {
                if (typeof appify !== 'undefined' && appify.isWebview) {
                    // Appify SDK 표준 API 사용 (문서 16.txt)
                    await appify.linking.openSettings();
                } else {
                    // 일반 웹일 경우 안내
                    alert("모바일 앱 환경설정에서 알림을 켜주세요.");
                }
            } catch (e) {
                console.error("설정창 열기 실패:", e);
                alert("설정창을 열 수 없습니다.");
            }
        }
    </script>
</body>
</html>