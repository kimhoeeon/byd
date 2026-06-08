<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>${eventName} 전용 스캐너 - 출석체크 및 전자서명</title>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://unpkg.com/html5-qrcode" type="text/javascript"></script>
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

<input type="hidden" id="adminCode" value="${adminCode}">

<div class="header-box">
    <h2 style="color: ${themeColor};">${eventName} 전용 관리자 스캐너</h2>
    <p>고객의 모바일 티켓 QR코드를 화면에 비춰주세요.</p>
</div>

<!-- <div class="scanner-container">
    <div id="reader"></div>
</div> -->

<div id="statusBox" class="status-box"></div>

<div class="modal-overlay" id="modalOverlay"></div>
<div class="modal-content" id="signatureModal">
    <div class="modal-header">
        <h3>시승 동의서 및 서명</h3>
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
        <button type="button" class="btn-cancel" id="btnCancel">취소</button>
        <button type="button" class="btn-clear" id="btnClear">다시 쓰기</button>
        <button type="button" class="btn-submit" id="btnSubmit">동의 및 제출</button>
    </div>
</div>

<script>
    let isScanning = false;
    const html5QrCode = new Html5Qrcode("reader");

    let audioCtx = null;
    let signaturePad;
    let currentScanSeq = null;

    $(document).ready(function() {
        $(document).one('click touchstart', function() {
            try {
                if (!audioCtx) {
                    audioCtx = new (window.AudioContext || window.webkitAudioContext)();
                }
                if (audioCtx.state === 'suspended') {
                    audioCtx.resume();
                }
            } catch (e) {
                console.log("초기 오디오 활성화 실패");
            }
        });

        const canvas = document.getElementById('signatureCanvas');
        function resizeCanvas() {
            if ($('#signatureModal').is(':hidden')) return;

            const ratio = Math.max(window.devicePixelRatio || 1, 1);
            canvas.width = canvas.offsetWidth * ratio;
            canvas.height = canvas.offsetHeight * ratio;
            canvas.getContext("2d").scale(ratio, ratio);
            if(signaturePad) signaturePad.clear();
        }

        window.addEventListener("resize", resizeCanvas);
        signaturePad = new SignaturePad(canvas, { penColor: "rgb(0, 0, 0)" });

        $('#btnClear').click(function() {
            signaturePad.clear();
        });

        $('#btnCancel').click(function() {
            $('#modalOverlay').fadeOut(200);
            $('#signatureModal').fadeOut(200);
            signaturePad.clear();
            currentScanSeq = null;
            $('#signName').val('');
            $('#signPhone').val('');
            showStatus("취소되었습니다.", "error");

            setTimeout(function() {
                $('#statusBox').fadeOut(200);
                if (html5QrCode.getState() === Html5QrcodeScannerState.PAUSED) {
                    html5QrCode.resume();
                }
                isScanning = false;
            }, 1500);
        });

        $('#btnSubmit').click(function() {
            if (!$('#modalAgree1').is(':checked') || !$('#modalAgree2').is(':checked')) {
                alert("필수 약관에 모두 동의해 주세요.");
                return;
            }
            if (signaturePad.isEmpty()) {
                alert("반드시 서명을 입력해 주세요.");
                return;
            }
            const dataUrl = signaturePad.toDataURL("image/png");
            submitSignatureData(dataUrl);
        });

        window.initSignatureCanvas = function() {
            $('#modalAgree1').prop('checked', false);
            $('#modalAgree2').prop('checked', false);
            resizeCanvas();
        };
    });

    function playBeep() {
        try {
            if (!audioCtx) {
                audioCtx = new (window.AudioContext || window.webkitAudioContext)();
            }
            if (audioCtx.state === 'suspended') {
                audioCtx.resume();
            }

            const osc = audioCtx.createOscillator();
            osc.type = 'sine';
            osc.frequency.setValueAtTime(800, audioCtx.currentTime);
            osc.connect(audioCtx.destination);
            osc.start();
            osc.stop(audioCtx.currentTime + 0.1);
        } catch (e) {
            console.log("오디오 지원 안됨");
        }
    }

    function showStatus(msg, type) {
        const $box = $('#statusBox');
        $box.removeClass('success error').addClass(type).html(msg).fadeIn(200);
    }

    function onScanSuccess(decodedText, decodedResult) {
        if (isScanning) return;
        isScanning = true;

        playBeep();
        showStatus("참가자 자격 검증 중...", "success");
        html5QrCode.pause();

        const adminCode = $('#adminCode').val();

        $.ajax({
            url: '/mng/api/verifyQr',
            type: 'POST',
            data: {
                qrToken: decodedText,
                adminCode: adminCode
            },
            success: function (response) {
                if (response.success) {
                    currentScanSeq = response.seq;

                    if (adminCode === '202') {
                        $('#signName').val(response.name);
                        $('#signPhone').val(response.phone);

                        $('#statusBox').hide();
                        $('#modalOverlay').fadeIn(200);
                        $('#signatureModal').fadeIn(200);
                        window.initSignatureCanvas();
                        signaturePad.clear();
                    } else {
                        submitSignatureData("");
                    }
                } else {
                    showStatus("❌<br>" + response.message, "error");
                    setTimeout(function () {
                        $('#statusBox').fadeOut(200);
                        if (html5QrCode.getState() === Html5QrcodeScannerState.PAUSED) {
                            html5QrCode.resume();
                        }
                        isScanning = false;
                    }, 2500);
                }
            },
            error: function () {
                showStatus("❌<br>서버 통신 오류가 발생했습니다.<br>다시 시도해주세요.", "error");
                setTimeout(function () {
                    $('#statusBox').fadeOut(200);
                    if (html5QrCode.getState() === Html5QrcodeScannerState.PAUSED) {
                        html5QrCode.resume();
                    }
                    isScanning = false;
                }, 2500);
            }
        });
    }

    function submitSignatureData(signatureData) {
        const adminCode = $('#adminCode').val();
        const statusMsg = (adminCode === '202') ? "약관 동의 및 서명 저장 중..." : "출석 데이터 저장 중...";

        showStatus(statusMsg, "success");

        $.ajax({
            url: '/mng/api/submitSignature',
            type: 'POST',
            data: {
                seq: currentScanSeq,
                adminCode: adminCode,
                signatureData: signatureData
            },
            success: function(response) {
                if (response.success) {
                    showStatus("✅<br>" + response.message, "success");
                } else {
                    showStatus("❌<br>" + response.message, "error");
                }
            },
            error: function() {
                showStatus("❌<br>서버 저장 중 오류가 발생했습니다.", "error");
            },
            complete: function() {
                $('#modalOverlay').fadeOut(200);
                $('#signatureModal').fadeOut(200);
                setTimeout(function() {
                    $('#statusBox').fadeOut(200);
                    if (html5QrCode.getState() === Html5QrcodeScannerState.PAUSED) {
                        html5QrCode.resume();
                    }
                    isScanning = false;
                    currentScanSeq = null;
                    $('#signName').val('');
                    $('#signPhone').val('');
                }, 2000);
            }
        });
    }

    function onScanFailure(error) {
        // 실패 로그 무시
    }

    function startScanner() {
        const config = {
            fps: 15,
            disableFlip: false,
            qrbox: function(viewfinderWidth, viewfinderHeight) {
                const minEdgeSize = Math.min(viewfinderWidth, viewfinderHeight);
                const qrboxSize = Math.floor(minEdgeSize * 0.8);
                return { width: qrboxSize, height: qrboxSize };
            }
        };

        Html5Qrcode.getCameras().then(devices => {
            if (devices && devices.length) {
                let cameraId = devices[0].id;

                for (let i = 0; i < devices.length; i++) {
                    let label = devices[i].label.toLowerCase();
                    if (label.includes('front') || label.includes('전면') || label.includes('user')) {
                        cameraId = devices[i].id;
                        break;
                    }
                }

                html5QrCode.start(cameraId, config, onScanSuccess, onScanFailure)
                    .catch((err) => {
                        alert("카메라 실행 실패! (다른 앱에서 사용중이거나 기기 설정 오류)\n사유: " + err);
                    });
            } else {
                alert("기기에서 카메라를 찾을 수 없습니다.");
            }
        }).catch(err => {
            alert("🚨 권한 차단됨!\n\n1. 상단바를 내려서 '카메라 사용' 버튼이 켜져있는지 확인\n2. 열려있는 다른 앱(카메라 등) 모두 닫기\n사유: " + err);
        });
    }

    startScanner();

    window.addEventListener("orientationchange", function() {
        isScanning = true;

        if (html5QrCode.getState() !== Html5QrcodeScannerState.NOT_STARTED) {
            html5QrCode.stop().then(() => {
                setTimeout(() => {
                    startScanner();
                    isScanning = false;
                }, 300);
            }).catch((err) => {
                console.error("카메라 재시작 오류:", err);
                isScanning = false;
            });
        } else {
            isScanning = false;
        }
    });

</script>
</body>
</html>