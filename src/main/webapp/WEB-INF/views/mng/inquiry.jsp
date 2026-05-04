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

        /* 스캐너 모드 선택 토글 UI (scanner_2.jsp 와 동일한 디자인) */
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

        /* 검색 영역 */
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

        /* 검색 결과 리스트 */
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
            background-color: #218838;
        }

        /* 하단 고정 스캐너 전환 버튼 */
        .floating-bottom {
            position: fixed;
            bottom: 0;
            left: 0;
            width: 100%;
            background: #fff;
            padding: 15px 0;
            box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1);
        }

        .btn-scanner-link {
            display: inline-block;
            padding: 12px 30px;
            background-color: #009ef7;
            color: white;
            text-decoration: none;
            border-radius: 30px;
            font-weight: bold;
            font-size: 1.1em;
        }
    </style>
</head>
<body>

<div class="header-box">
    <h2>현장 참가자 수동 조회</h2>
    <p>QR 코드가 없는 고객을 검색하여 출석 처리합니다.</p>
</div>

<!-- 처리할 담당 코드 선택 -->
<div class="mode-toggle">
    <input type="radio" id="modeChallenge" name="eventType" value="challenge" checked>
    <label for="modeChallenge">챌린지</label>

    <input type="radio" id="modeDrive" name="eventType" value="drive">
    <label for="modeDrive">시승체험</label>
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
    <!-- 검색 결과가 여기에 표시됩니다. -->
    <div style="text-align: center; color: #888; margin-top: 30px;">
        고객의 <strong>전체 이름</strong> 또는 <strong>연락처 뒷자리 4자리</strong>를 검색해주세요.<br>
        (예: 홍길동, 1234)
    </div>
</div>

<div class="floating-bottom">
    <a href="/mng/scanner" class="btn-scanner-link">📷 QR 스캐너 화면으로 전환</a>
</div>

<script>
    // 검색 실행
    function searchData() {
        const searchType = $('#searchType').val();
        const keyword = $('#keyword').val().trim();

        if (keyword.length < 2) {
            alert('정확한 검색을 위해 2글자 이상 입력해주세요.');
            $('#keyword').focus();
            return;
        }

        $('#resultList').html('<div style="text-align:center;">검색 중...</div>');

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
                        html += '  <div class="result-info">';
                        html += '    <strong>' + item.name + '</strong> <span style="font-size:0.85em; color:#999;">(' + item.phone + ')</span>';
                        html += '    <p>관심모델: ' + item.carModel + ' | 시간: ' + (item.testDriveTime ? item.testDriveTime : '미지정') + '</p>';
                        html += '  </div>';
                        html += '  <button class="btn-checkin" onclick="processCheckIn(' + item.seq + ', \'' + item.name + '\')">출석 처리</button>';
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

    // 수동 출석 처리 실행
    function processCheckIn(seq, name) {
        const eventType = $('input[name="eventType"]:checked').val();
        const typeText = eventType === 'challenge' ? '챌린지' : '시승체험';

        if (!confirm(name + ' 고객님을 [' + typeText + '] 출석 처리하시겠습니까?')) {
            return;
        }

        $.ajax({
            url: '/mng/api/manualArrival',
            type: 'POST',
            data: {
                seq: seq,
                type: eventType,
                status: true // true = 출석완료 처리
            },
            dataType: 'json',
            success: function (response) {
                if (response.success) {
                    alert('✅ ' + typeText + ' 출석 처리가 완료되었습니다.');
                    searchData(); // 리스트 갱신
                } else {
                    alert('❌ 처리 중 오류가 발생했습니다.');
                }
            },
            error: function () {
                alert('❌ 서버와의 통신에 실패했습니다.');
            }
        });
    }

    // 엔터키 검색 지원
    $('#keyword').on('keypress', function (e) {
        if (e.which === 13) {
            searchData();
        }
    });
</script>
</body>
</html>