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
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            z-index: 10;
        }

        .header-box h2 {
            margin: 0 0 5px 0;
            font-size: 1.5em;
            color: #333;
        }

        .event-badge {
            display: inline-block;
            margin-top: 10px;
            padding: 10px 25px;
            background-color: ${themeColor};
            color: white;
            font-size: 1.3em;
            font-weight: bold;
            border-radius: 30px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
        }

        .scanner-container {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            position: relative;
            padding: 0 15px;
            margin-top: 20px;
        }

        #reader {
            width: 100%;
            max-width: 600px;
            border: 5px solid ${themeColor} !important;
            border-radius: 12px;
            overflow: hidden;
            background: #000;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        /* 전면 카메라 거울 모드 (좌우 반전) 적용 */
        #reader video {
            transform: scaleX(-1) !important;
        }

        .status-box {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            padding: 20px;
            border-radius: 12px;
            font-size: 1.3em;
            font-weight: bold;
            width: 80%;
            max-width: 400px;
            display: none;
            word-break: keep-all;
            z-index: 100;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
        }

        .success {
            background-color: rgba(212, 237, 218, 0.95);
            color: #155724;
            border: 2px solid #c3e6cb;
        }

        .error {
            background-color: rgba(248, 215, 218, 0.95);
            color: #721c24;
            border: 2px solid #f5c6cb;
        }

        .btn-back {
            display: block;
            margin: 20px auto;
            padding: 15px 30px;
            background-color: #343a40;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
            font-size: 1.1em;
            width: 80%;
            max-width: 300px;
        }
    </style>
</head>
<body>

<div class="header-box">
    <h2>현장 출석 스캐너</h2>
    <p>고객의 QR 코드를 사각형 안내선 안에 맞춰주세요.</p>
    <div class="event-badge">${eventName} 전용</div>
</div>

<input type="hidden" id="adminCode" value="${adminCode}">

<div class="scanner-container">
    <div id="reader"></div>
    <div id="statusBox" class="status-box"></div>
</div>

<a href="/mng/inquiry" class="btn-back">수동 조회 화면으로 이동</a>

<div id="signatureModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.8); z-index:9999; justify-content:center; align-items:center;">
    <div style="background:#fff; padding:20px; border-radius:10px; width:90%; max-width:500px; text-align:center;">
        <h3 style="margin-top:0; margin-bottom:15px; color:#111;">시승 동의서 및 서명</h3>

        <div style="display:flex; gap:10px; margin-bottom:15px;">
            <div style="flex:1; text-align:left;">
                <label style="font-size:12px; color:#555; font-weight:bold; display:block; margin-bottom:5px;">이름</label>
                <input type="text" id="signName" readonly style="width:100%; padding:10px; border:1px solid #ddd; border-radius:5px; background:#f4f6f9; font-weight:bold; color:#333; box-sizing:border-box;">
            </div>
            <div style="flex:1; text-align:left;">
                <label style="font-size:12px; color:#555; font-weight:bold; display:block; margin-bottom:5px;">연락처</label>
                <input type="text" id="signPhone" readonly style="width:100%; padding:10px; border:1px solid #ddd; border-radius:5px; background:#f4f6f9; font-weight:bold; color:#333; box-sizing:border-box;">
            </div>
        </div>

        <div style="height:120px; overflow-y:auto; border:1px solid #ddd; border-radius:5px; padding:10px; text-align:left; font-size:13px; line-height:1.5; margin-bottom:15px; background:#fcfcfc; color:#444;">
            1. 본인은 유효한 운전면허를 소지하고 있으며, 도로교통법을 준수합니다.<br>
            2. 시승 중 본인의 과실로 발생한 사고 및 범칙금은 본인이 부담합니다.<br>
            3. 차량의 파손 및 손해 발생 시 그에 대한 배상 책임을 집니다.<br>
            4. 안전 통제 요원의 지시에 적극적으로 따를 것을 동의합니다.
        </div>

        <h4 style="margin:0 0 10px 0; text-align:left; color:#111;">서명 (필수)</h4>
        <div style="border:2px dashed #333; border-radius:5px; background:#fff; margin-bottom:15px;">
            <canvas id="signatureCanvas" style="width:100%; height:180px; touch-action:none;"></canvas>
        </div>

        <div style="display:flex; justify-content:space-between; gap:10px;">
            <button type="button" id="btnClear" style="flex:1; padding:12px; background:#6c757d; color:#fff; border:none; border-radius:5px; font-weight:bold;">다시 쓰기</button>
            <button type="button" id="btnCancel" style="flex:1; padding:12px; background:#dc3545; color:#fff; border:none; border-radius:5px; font-weight:bold;">취소</button>
            <button type="button" id="btnSubmit" style="flex:2; padding:12px; background:#000; color:#fff; border:none; border-radius:5px; font-weight:bold;">동의 및 제출</button>
        </div>
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
            $('#signatureModal').hide();
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
            if (signaturePad.isEmpty()) {
                alert("반드시 서명을 입력해 주세요.");
                return;
            }
            const dataUrl = signaturePad.toDataURL("image/png");
            submitSignatureData(dataUrl);
        });

        window.initSignatureCanvas = resizeCanvas;
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
                        // [추가] 받아온 이름과 연락처를 input 필드에 자동 매핑
                        $('#signName').val(response.name);
                        $('#signPhone').val(response.phone);

                        $('#statusBox').hide();
                        $('#signatureModal').css('display', 'flex');
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
        const statusMsg = (adminCode === '202') ? "서명 및 출석 데이터 저장 중..." : "출석 데이터 저장 중...";

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
                $('#signatureModal').hide();
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