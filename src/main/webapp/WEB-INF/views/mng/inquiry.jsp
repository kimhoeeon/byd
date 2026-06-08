<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>참가자 수동 조회 - BYD 현장운영</title>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/signature_pad@4.0.0/dist/signature_pad.umd.min.js"></script>

    <style>
        /* 기본 레이아웃 스타일 */
        body {
            margin: 0;
            padding: 0;
            background-color: #f4f6f9;
            font-family: 'Noto Sans KR', sans-serif;
            text-align: center;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .header-box {
            padding: 15px;
            background: #fff;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }

        .header-box h2 {
            margin: 0 0 5px 0;
            font-size: 1.4em;
            color: #333;
        }

        .header-box p {
            margin: 0;
            color: #666;
            font-size: 0.9em;
        }

        .scanner-container {
            width: 100%;
            max-width: 500px;
            margin: 0 auto;
            position: relative;
            background: #000;
            flex-grow: 1;
        }

        #reader {
            width: 100%;
            height: 100%;
        }

        #reader video {
            transform: scaleX(-1) !important; /* 전면 카메라 거울 모드 */
            object-fit: cover;
            width: 100%;
            height: 100%;
        }

        .status-box {
            position: fixed;
            bottom: 30px;
            left: 50%;
            transform: translateX(-50%);
            width: 90%;
            max-width: 400px;
            padding: 15px;
            border-radius: 10px;
            font-size: 18px;
            font-weight: bold;
            color: #fff;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0,0,0,0.3);
            display: none;
            z-index: 1000;
        }
        .status-box.success { background-color: #28a745; }
        .status-box.error { background-color: #dc3545; }

        /* ============================================== */
        /* [통일됨] 서명 모달 전용 스타일 (inquiry.jsp와 동일) */
        /* ============================================== */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.7);
            z-index: 9998;
        }
        .modal-content {
            display: none;
            position: fixed;
            top: 50%; left: 50%;
            transform: translate(-50%, -50%);
            background: #252728;
            width: 90%;
            max-width: 500px;
            max-height: 90vh;
            overflow-y: auto;
            border-radius: 10px;
            padding: 20px;
            z-index: 9999;
            box-sizing: border-box;
            text-align: left;
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            border-bottom: 1px solid #2A466C;
            padding-bottom: 10px;
        }
        .modal-header button{background: inherit; border: none; color: #fff; font-size: 26px; }
        .modal-header h3 { margin: 0; color: #fff; font-size: 1.3em; font-weight: 500;}

        .modal-body .info-row { display: flex; gap: 10px; margin-bottom: 20px; }
        .modal-body .info-row > div { flex: 1; }
        .modal-body .info-row label { font-size: 14px; color: #fff; font-weight: 400; display: block; margin-bottom: 5px; }
        .modal-body .info-row input { padding: 15px; border: 1px solid #2A466C; background: #252728; font-weight: 300; color: #fff; width: 100%; box-sizing: border-box; }

        .modal-body .terms-check { margin-bottom: 20px; text-align: left; }
        .modal-body .terms-check label { display: flex; align-items: flex-start;gap: 5px; cursor: pointer; font-size: 14px; font-weight: 300; color: #fff; margin-bottom: 10px; line-height: 1.3;}
        .modal-body .terms-check input[type="checkbox"] { margin: 0; border: 1px solid #CBCBCA;background: #fff;vertical-align: middle;width: 20px;height: 20px; }
        .modal-body .terms-check input[type="checkbox"]:checked{border: 5px solid #bb0a0a;}
        .modal-body .terms-check textarea {
            width: 100%; height: 90px;font-family: 'Noto Sans KR', sans-serif; padding: 10px; border: none;border: 1px solid #2A466C;background: none; color: #CBCBCA;font-size: 12px; line-height: 1.5; resize: none; box-sizing: border-box;
        }

        .modal-body .canvas-container { border: 1px dashed #2A466C; background: #252728; margin-bottom: 15px; }
        .modal-body canvas { width: 100%; height: 160px; touch-action: none; }

        .modal-body h4{font-weight: 400;}
        .modal-footer { display: flex; gap: 10px; }
        .modal-footer button { padding: 12px; border: none; font-weight: bold; font-size: 1em; cursor: pointer; }
        .btn-clear { background: #9c9c9c; color: #fff; flex: 1; }
        .btn-cancel { background: #bb0a0a; color: #fff; flex: 1; }
        .btn-submit { background: linear-gradient(90deg,rgba(16, 58, 187, 1) 0%, rgba(61, 102, 228, 1) 100%); color: #fff; flex: 2; }

        input, textarea { -webkit-appearance: none; -moz-appearance: none; appearance: none; -webkit-border-radius: 0; } 
        textarea::placeholder {color: #CBCBCA;}


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

<div class="floating-bottom">
    <a href="/mng/scanner?type=challenge" class="btn-scanner-link" style="background-color: #009ef7;">📷 챌린지 스캐너</a>
    <a href="/mng/scanner?type=drive" class="btn-scanner-link" style="background-color: #28a745;">📷 시승 스캐너</a>
    <a href="/mng/scanner?type=gift" class="btn-scanner-link" style="background-color: #f6c23e;">📷 경품 스캐너</a>
</div>

<div class="modal-overlay" id="modalOverlay"></div>
<div class="modal-content" id="signatureModal">
    <div class="modal-header">
        <h3>시승 동의서 및 서명</h3>
        <button class="btn-close" onclick="closeSignatureModal()">×</button>
    </div>
    <div class="modal-body">
        <div class="info-row">
            <div>
                <label>이름</label>
                <input type="text" id="signName" readonly>
            </div>
            <div>
                <label>연락처</label>
                <input type="text" id="signPhone" readonly>
            </div>
        </div>
        <div class="terms-check">
            <label>
                <input type="checkbox" id="modalAgree1">
                (필수) 시승차 이용 및 서비스 이용에 따른 주요 고지사항 및 이용약관 안내
            </label>
            <textarea readonly>1. 유의사항&#10;①고객님의 시승차 운전이 불가하다고 판단 시 귀사 직원의 판단에 따라 즉시 시승이 중단/취소될 수 있으며 향후 시승 이용이 제한될 수 있습니다.&#10;(음주, 심신미약, 운전미숙, 과속 및 난폭운전, 기상악화 등 안전상 위험하다고 판단되는 경우)&#10;&#10;②시승서비스 이용을 위해서는 시승 전 반드시 운전면허증을 제시해야 합니다.&#10;③시승차는 보험 적용 기준에 따라 만 21세 이상만 운행 가능합니다.&#10;④다음 시승 신청 고객님들을 위해 시승 신청시간을 준수해 주시기 바랍니다.&#10;신청 변동사항이 있을 경우 BYD 시승 안내데스크 혹은 담당 영업사원에게 사전 연락을 부탁드립니다.&#10;고객님과 연락이 두절되는 경우 시승 신청이 자동 취소될 수 있습니다.&#10;시승시간은 총 30분입니다. (시승시간은 예약 시간대별로 상이하며 거점별 운영 상황에 따라 변경될 수 있습니다.)&#10;* long-time 시승 (총 1시간)을 원하시는 경우 방문 희망 BYD시승부스로 유선 연락 주시길 바랍니다.&#10;해당 드라이빙라운지 예약 상황에 따라 희망하시는 차종의 시승 가능 여부를 안내드립니다.&#10;&#10;⑤시승 고객님의 안전한 운행을 위해 동승 시승을 희망하시는 경우 인스트럭터가 동승합니다.&#10;⑥계약 이력 또는 담당 영업사원 있는 고객님이 동승 시승을 희망하시는 경우 담당 영업사원과 동승 시승 가능 여부 확인 후 예약이 확정됩니다. &#10;   계약 이력이 있는 고객님은 담당 영업사원 동승이 불가능한 경우, 동승 시승 서비스 이용이 제한될 수 있습니다.&#10;⑦시승서비스는 고객님께서 차량을 구매하기 전 관심 차종을 경험할 수 있는 기회를 드리고자 제공되는 서비스입니다. 따라서 개인적 용도로 시승차를 이용하려는 경우 시승이 제한될 수 있습니다.&#10;2. 보험사항&#10;상기 차량은 대인배상(Ⅰ,Ⅱ), 대물배상, 자기 신체, 자기 차량, 무보험 등의 보험에 가입되어 있으나, 보험 가액을 초과하는 부분 및 보험 미적용 부분 (운전자 연령 한정 운전 특약 위반, 차량 사고 시 자차 부담금 최대 10만원 고객 부담) 등에 대해서는 본인이 스스로 책임을 지는 동시에 귀사에 발생한 모든 손해를 배상할 것을 약속합니다.&#10;3. 금지사항&#10;본인은 귀사가 제공한 상기 차량을 상업적으로 이용하는 등 비정상적으로 운행하거나, 본인 외 제3자에게 운행, 양도, 대여, 담보의 목적으로 제공하는 등의 행위를 일절 하지 않을 것을 약속합니다. 또한 주행 보조 기능 (AEB 자동 긴급 제동 시스템, FCA 전방 충돌 방지 보조 등) 작동을 위하여 위험한 운전을 시도하지 않으며, 항상 안전하게 운전할 것을 약속합니다.&#10;4. 책임사항&#10;①본인은 위 보험 사항 및 금지사항, 유의사항을 위반하여 발생한 모든 민·형사상 책임을 부담합니다.&#10;②본인은 약정된 차량 반납 일시까지 상기 차량을 지정된 반납 장소에 반납하지 않거나 차량 반납 시 차량 상태가 변동된 경우, 이로 인해 발생한 모든 손해에 대한 배상 책임을 부담합니다.&#10;③본인은 교통법규 미준수로 인한 벌금, 과태료 및 시승 운행 시 발생한 도로교통비 등을 부담합니다.&#10;위치정보 수집장치 부착 사실 고지&#10;시승차량에 장착된 블루링크 단말을 통해 시승서비스 이용 시간 동안 시승차량 및 고객님의 위치정보가 수집됨을 알려드립니다.</textarea>
        </div>

        <div class="terms-check">
            <label>
                <input type="checkbox" id="modalAgree2">
                (필수) 시승신청 개인정보 수집 및 이용 동의
            </label>
            <textarea readonly>개인정보 수집 및 이용 목적&#10;- 시승서비스 제공, 시승차량 사고 발생 시 보험처리 등&#10;- 사고 대응, 시승차량 도난 방지 및 운행 관리, 고객 불만 등&#10;- 민원사항 처리, 분쟁 발생 시 대응, 소비자 의견 조사,고객 관리 서비스 제공&#10;- 교통법규 미준수로 인한 벌금, 과태료처리&#10;&#10;개인정보의 수집 항목&#10;[필수 항목]&#10;&#10;- 고객 성명, 휴대전화 번호, 생년월일, 성별, 연계정보(CI), 주소(자택/직장), 시승정보(시승차종, 차량번호, 시승일시), 시승차량 위치정보&#10;&#10;[선택 항목]&#10;&#10;- 자동차 운전경력, 보유차종 및 연식, 기타 시승 관련 요청사항&#10;&#10;개인정보의 보유 및 이용기간&#10;- 시승일 기준 2년 (※ 단, 시승차량 위치정보는 수집일로부터 14일)&#10;&#10;고객님은 위의 개인정보 수집 이용에 대한 동의를 거부하실 수 있습니다.&#10;그러나, 동의 거부 시 시승서비스 이용이 불가합니다.</textarea>
        </div>
        <h4 style="margin: 0 0 10px 0; color: #fff; font-size: 14px;">서명 (필수)</h4>
        <div class="canvas-container">
            <canvas id="signatureCanvas"></canvas>
        </div>
    </div>
    <div class="modal-footer">
        <button type="button" class="btn-clear" onclick="signaturePad.clear();">다시 쓰기</button>
        <button type="button" class="btn-submit" onclick="submitSignature()">동의 및 제출</button>
    </div>
</div>

<script>
    $(document).ready(function() {

        // 검색창(#keyword) 자동 포맷팅 (이 부분은 남겨두세요!)
        $('#keyword').on('input', function() {
            var searchType = $('#searchType').val();

            if (searchType === 'phone') {
                var val = $(this).val().replace(/[^0-9]/g, '');
                if (val.length > 11) val = val.substring(0, 11);
                var formatted = '';
                if (val.length < 4) formatted = val;
                else if (val.length < 7) formatted = val.substring(0, 3) + '-' + val.substring(3);
                else if (val.length < 11) formatted = val.substring(0, 3) + '-' + val.substring(3, 6) + '-' + val.substring(6);
                else formatted = val.substring(0, 3) + '-' + val.substring(3, 7) + '-' + val.substring(7);
                $(this).val(formatted);
            } else {
                var val = $(this).val().replace(/\s/g, '');
                $(this).val(val);
            }
        });

        $('#searchType').on('change', function() {
            $('#keyword').val('').focus();
        });

        // 라디오 버튼(탭)이 변경될 때마다 화면 즉시 새로고침
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
                            // [수정] 모달에 번호를 전달하기 위해 phone 인자 추가
                            html += '<button class="btn-checkin" onclick="processCheckIn(' + item.seq + ', \'' + item.name + '\', \'' + item.phone + '\')">' + btnLabel + '</button>';
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

    // 서명 관련 변수 및 함수
    let signaturePad;
    let currentSignSeq = null;

    $(document).ready(function() {
        const canvas = document.getElementById('signatureCanvas');
        if (canvas) {
            signaturePad = new SignaturePad(canvas, { penColor: "rgb(0, 0, 0)" });

            // 모달이 열려있을 때 창크기가 변하면 캔버스 해상도 대응
            window.addEventListener("resize", function() {
                if ($('#signatureModal').is(':visible')) {
                    const ratio = Math.max(window.devicePixelRatio || 1, 1);
                    canvas.width = canvas.offsetWidth * ratio;
                    canvas.height = canvas.offsetHeight * ratio;
                    canvas.getContext("2d").scale(ratio, ratio);
                    signaturePad.clear();
                }
            });
        }
    });

    function openSignatureModal() {

        $('#modalAgree1').prop('checked', false);
        $('#modalAgree2').prop('checked', false);

        $('#modalOverlay').fadeIn(200);
        $('#signatureModal').fadeIn(200);

        // Canvas Resize
        const canvas = document.getElementById('signatureCanvas');
        const ratio = Math.max(window.devicePixelRatio || 1, 1);
        canvas.width = canvas.offsetWidth * ratio;
        canvas.height = canvas.offsetHeight * ratio;
        canvas.getContext("2d").scale(ratio, ratio);
        signaturePad.clear();
    }

    function closeSignatureModal() {
        $('#modalOverlay').fadeOut(200);
        $('#signatureModal').fadeOut(200);
        currentSignSeq = null;
    }

    function submitSignature() {
        // 1. 필수 약관 체크 확인 로직
        if (!$('#modalAgree1').is(':checked') || !$('#modalAgree2').is(':checked')) {
            alert("필수 약관에 모두 동의해 주세요.");
            return;
        }

        // 2. 전자 서명 여부 확인
        if (signaturePad.isEmpty()) {
            alert("반드시 서명을 입력해 주세요.");
            return;
        }

        const signatureData = signaturePad.toDataURL("image/png");

        $.ajax({
            url: '/mng/api/submitSignature',
            type: 'POST',
            data: {
                seq: currentSignSeq,
                adminCode: '202', // 시승 스캐너 코드 (서명 포함)
                signatureData: signatureData
            },
            success: function(res) {
                if(res.success) {
                    alert("✅ 약관 동의 및 시승 출석 처리가 완료되었습니다.");
                    closeSignatureModal();
                    searchData(); // 목록 갱신
                } else {
                    alert("❌ " + res.message);
                }
            },
            error: function() {
                alert("❌ 서버 통신 오류가 발생했습니다.");
            }
        });
    }

    function processCheckIn(seq, name, phone) {
        const eventType = $('input[name="eventType"]:checked').val();
        const typeText = eventType === 'challenge' ? '챌린지' : eventType === 'drive' ? '시승체험' : '경품';
        const checkText = eventType === 'gift' ? '수령' : '출석';

        // [핵심 변경] 시승체험일 경우 일반 manualArrival API 대신 서명 모달 띄우기
        if (eventType === 'drive') {
            currentSignSeq = seq;
            $('#signName').val(name);
            $('#signPhone').val(phone || '');
            openSignatureModal();
            return;
        }

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