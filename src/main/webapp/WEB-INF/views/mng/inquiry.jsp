<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>참가자 수동 조회 - BYD 현장운영</title>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
        body {
            margin: 0;
            padding: 0;
            background-color: #f4f6f9;
            font-family: 'Noto Sans KR', sans-serif;
            text-align: center;
        }

        .header-box {
            padding: 20px 15px;
            background: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            margin-bottom: 20px;
        }

        .header-box h2 {
            margin: 0 0 5px 0;
            font-size: 1.5em;
            color: #333;
        }

        .header-box p {
            margin: 0;
            color: #666;
            font-size: 0.9em;
        }

        .mode-toggle {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-bottom: 20px;
        }

        .mode-toggle input[type="radio"] {
            display: none;
        }

        .mode-toggle label {
            padding: 10px 20px;
            background-color: #e4e6ef;
            color: #333;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: all 0.3s;
        }

        .mode-toggle input[type="radio"]:checked + label {
            background-color: #009ef7;
            color: #fff;
        }

        .search-area {
            background: #fff;
            margin: 0 15px 20px 15px;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            display: flex;
            gap: 10px;
            align-items: center;
            justify-content: center;
            flex-wrap: wrap;
        }

        .search-area select, .search-area input {
            padding: 12px;
            font-size: 16px;
            border: 1px solid #ced4da;
            border-radius: 5px;
            box-sizing: border-box;
        }

        .search-area input {
            flex: 1;
            min-width: 150px;
        }

        .btn-search {
            padding: 12px 20px;
            background-color: #343a40;
            color: white;
            border: none;
            border-radius: 5px;
            font-weight: bold;
            font-size: 16px;
            cursor: pointer;
        }

        .result-list {
            padding: 0 15px;
            text-align: left;
            padding-bottom: 80px;
        }

        .result-card {
            background: #fff;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-left: 4px solid #009ef7;
        }

        .result-info strong {
            font-size: 1.1em;
            color: #333;
        }

        .result-info p {
            margin: 5px 0 0 0;
            font-size: 0.9em;
            color: #555;
        }

        .btn-checkin {
            padding: 10px 15px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            font-weight: bold;
            cursor: pointer;
        }

        .btn-checkin:hover {
            opacity: 0.8;
        }

        /* 하단 고정 스캐너 전환 버튼 컨테이너 */
        .floating-bottom {
            position: fixed;
            bottom: 0;
            left: 0;
            width: 100%;
            background: #fff;
            padding: 15px 0;
            box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: center;
            gap: 15px;
        }

        .btn-scanner-link {
            display: inline-block;
            padding: 12px 20px;
            color: white;
            text-decoration: none;
            border-radius: 30px;
            font-weight: bold;
            font-size: 1.1em;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }
    </style>
</head>
<body>

<div class="header-box">
    <h2>현장 참가자 수동 조회</h2>
    <p>QR 코드가 없는 고객을 검색하여 출석 처리합니다.</p>
</div>

<div class="mode-toggle">
    <input type="radio" id="modeChallenge" name="eventType" value="challenge" checked>
    <label for="modeChallenge">챌린지</label>

    <input type="radio" id="modeDrive" name="eventType" value="drive">
    <label for="modeDrive">시승체험</label>

    <input type="radio" id="modeGift" name="eventType" value="gift">
    <label for="modeGift">경품수령</label>
</div>

<div class="search-area">
    <select id="searchType">
        <option value="name">이름</option>
        <option value="phone">연락처</option>
    </select>
    <input type="text" id="keyword" placeholder="검색어 입력">
    <button type="button" class="btn-search" onclick="searchData()">조회</button>
</div>

<div id="resultList" class="result-list">
    <div style="text-align: center; color: #888; margin-top: 30px;">
        고객의 <strong>이름</strong> 또는 <strong>연락처</strong>를 2글자 이상 입력하여 검색해주세요.
    </div>
</div>

<!-- 분리된 스캐너 링크 버튼 -->
<div class="floating-bottom">
    <a href="/mng/scanner?type=challenge" class="btn-scanner-link" style="background-color: #009ef7;">📷 챌린지 스캐너</a>
    <a href="/mng/scanner?type=drive" class="btn-scanner-link" style="background-color: #28a745;">📷 시승 스캐너</a>
    <a href="/mng/scanner?type=gift" class="btn-scanner-link" style="background-color: #f6c23e;">📷 경품 스캐너</a>
</div>

<script>
    $(document).ready(function() {
        // [핵심 추가] 라디오 버튼(탭)이 변경될 때마다 화면 즉시 새로고침
        $('input[name="eventType"]').on('change', function() {
            const keyword = $('#keyword').val().trim();
            if (keyword.length >= 2) {
                // 이미 검색된 결과가 있다면 바뀐 탭(모드)에 맞춰 즉시 재검색하여 버튼 갱신
                searchData();
            } else {
                // 검색어가 없다면 리스트 초기화 안내 문구 노출
                $('#resultList').html('<div style="text-align: center; color: #888; margin-top: 30px;">고객의 <strong>이름</strong> 또는 <strong>연락처</strong>를 2글자 이상 입력하여 검색해주세요.</div>');
            }
        });

        // 엔터키 검색 지원
        $('#keyword').on('keypress', function (e) {
            if (e.which === 13) {
                searchData();
            }
        });
    });

    function searchData() {
        const searchType = $('#searchType').val();
        const keyword = $('#keyword').val().trim();

        if (keyword.length < 2) {
            alert('정확한 검색을 위해 2글자 이상 입력해주세요.');
            $('#keyword').focus();
            return;
        }

        $('#resultList').html('<div style="text-align:center;">검색 중...</div>');

        const currentEventType = $('input[name="eventType"]:checked').val();

        $.ajax({
            url: '/mng/api/searchParticipant',
            type: 'GET',
            data: {
                searchType: searchType,
                keyword: keyword
            },
            dataType: 'json',
            success: function (list) {
                let html = '';
                if (list.length === 0) {
                    html = '<div style="text-align:center; color: #dc3545; margin-top: 30px; font-weight:bold;">검색 결과가 없습니다.</div>';
                } else {
                    $.each(list, function (index, item) {
                        html += '<div class="result-card">';
                            html += '<div class="result-info">';
                                html += '<strong>' + item.name + '</strong><span style="font-size:0.85em; color:#999;">(' + item.phone + ')</span>';
                                html += '<p>관심모델: ' + item.carModel + ' | 시간: ' + (item.testDriveTime ? item.testDriveTime : '미지정') + '</p>';
                            html += '</div>';

                        // 렌더링될 버튼 텍스트를 이벤트 타입에 맞게 설정
                        let btnLabel = '출석 처리';
                        let isAlreadyChecked = false;

                        if (currentEventType === 'challenge') {
                            if (item.challengeCheckYn === 'Y') isAlreadyChecked = true;
                        } else if (currentEventType === 'drive') {
                            if (item.driveCheckYn === 'Y') isAlreadyChecked = true;
                        } else if (currentEventType === 'gift') {
                            btnLabel = '경품 수령';
                            if (item.giftCheckYn === 'Y') isAlreadyChecked = true;
                        }

                        // 처리 완료된 대상은 빨간색 "상태 취소" 버튼 노출
                        if (isAlreadyChecked) {
                            html += '<button class="btn-checkin" style="background-color: #dc3545;" onclick="processCancel(' + item.seq + ', \'' + item.name + '\')">상태 취소</button>';
                        } else {
                            html += '<button class="btn-checkin" onclick="processCheckIn(' + item.seq + ', \'' + item.name + '\')">' + btnLabel + '</button>';
                        }

                        html += '</div>';
                    });
                }
                $('#resultList').html(html);
            },
            error: function () {
                alert('서버 통신 오류가 발생했습니다.');
                $('#resultList').html('');
            }
        });
    }

    function processCheckIn(seq, name) {
        const eventType = $('input[name="eventType"]:checked').val();
        const typeText = eventType === 'challenge' ? '챌린지' : eventType === 'drive' ? '시승체험' : '경품';
        const checkText = eventType === 'gift' ? '수령' : '출석';

        if (!confirm(name + ' 고객님을 [ ' + typeText + ' ] ' + checkText + ' 처리하시겠습니까?')) {
            return;
        }

        $.ajax({
            url: '/mng/api/manualArrival',
            type: 'POST',
            data: {
                seq: seq,
                type: eventType,
                status: true
            },
            dataType: 'json',
            success: function (response) {
                if (response.success) {
                    alert('✅ ' + typeText + ' ' + checkText + ' 처리가 완료되었습니다.');
                    searchData();
                } else {
                    alert('❌ ' + response.message);
                }
            },
            error: function () {
                alert('❌ 서버와의 통신에 실패했습니다.');
            }
        });
    }

    // 출석(수령) 취소 함수
    function processCancel(seq, name) {
        const eventType = $('input[name="eventType"]:checked').val();
        const typeText = eventType === 'challenge' ? '챌린지' : eventType === 'drive' ? '시승체험' : '경품';
        const checkText = eventType === 'gift' ? '수령' : '출석';

        if (!confirm(name + ' 고객님의 [' + typeText + '] ' + checkText + ' 상태를 취소하시겠습니까?')) {
            return;
        }

        $.ajax({
            url: '/mng/api/manualArrival',
            type: 'POST',
            data: {
                seq: seq,
                type: eventType,
                status: false // 상태 원복
            },
            dataType: 'json',
            success: function (response) {
                if (response.success) {
                    alert('✅ ' + typeText + ' ' + checkText + ' 취소 처리가 완료되었습니다.');
                    searchData();
                } else {
                    alert('❌ 처리 중 오류가 발생했습니다.');
                }
            },
            error: function () {
                alert('❌ 서버와의 통신에 실패했습니다.');
            }
        });
    }
</script>
</body>
</html>