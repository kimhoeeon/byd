<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" />
    <title>${eventName} 전용 스캐너 - 출석체크 및 전자서명</title>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://unpkg.com/html5-qrcode" type="text/javascript"></script>

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
            transform: scaleX(-1) !important;
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

        /* 하단 복귀 버튼 */
        .floating-bottom {
            position: fixed;
            bottom: 15px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 999;
        }

        .btn-back {
            display: inline-block;
            padding: 12px 30px;
            background: rgba(0, 0, 0, 0.6);
            color: white;
            text-decoration: none;
            border-radius: 30px;
            font-weight: bold;
            font-size: 1em;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(5px);
        }
    </style>
</head>
<body>

<input type="hidden" id="adminCode" value="${adminCode}">

<div class="header-box">
    <h2 style="color: ${themeColor};">${eventName} 전용 스캐너</h2>
    <p>고객의 모바일 티켓 QR코드를 화면에 비춰주세요.</p>
</div>

<div class="scanner-container">
    <div id="reader"></div>
</div>
<div id="statusBox" class="status-box"></div>

<div class="floating-bottom">
    <a href="/mng/inquiry" class="btn-back">🔙 수동조회 목록으로 돌아가기</a>
</div>

<script>
    let isScanning = false;
    let html5QrCode = null;
    let audioCtx = null;

    $(document).ready(function() {
        if (document.getElementById("reader") == null) {
            alert("시스템 오류: 카메라 영역이 존재하지 않습니다.");
            return;
        }

        try {
            html5QrCode = new Html5Qrcode("reader");
        } catch (e) {
            alert("카메라 초기화 실패: " + e);
            return;
        }

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

        startScanner();
    });

    function startScanner() {
        if (!html5QrCode) return;
        const config = {
            fps: 15,
            disableFlip: false,
            qrbox: function(viewfinderWidth, viewfinderHeight) {
                const minEdgeSize = Math.min(viewfinderWidth, viewfinderHeight);
                const qrboxSize = Math.floor(minEdgeSize * 0.8);
                return { width: qrboxSize, height: qrboxSize };
            }
        };

        html5QrCode.start({ facingMode: "environment" }, config, onScanSuccess, onScanFailure)
            .catch((err) => {
                console.log("facingMode failed, falling back to getCameras:", err);
                Html5Qrcode.getCameras().then(devices => {
                    if (devices && devices.length) {
                        let cameraId = devices[devices.length - 1].id; // 보통 마지막 요소가 후면 카메라
                        html5QrCode.start(cameraId, config, onScanSuccess, onScanFailure);
                    }
                }).catch(e => {
                    alert("카메라 실행 실패! 브라우저의 카메라 권한을 확인해주세요.");
                });
            });
    }

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
        showStatus("참여 정보를 확인 중입니다...", "success");
        html5QrCode.pause();

        const adminCode = $('#adminCode').val();

        // 불필요한 이중 통신 제거, 다이렉트로 업데이트 처리
        $.ajax({
            url: '/mng/api/checkArrival',
            type: 'POST',
            data: {
                qrToken: decodedText,
                adminCode: adminCode
            },
            success: function (response) {
                if (response.success) {
                    showStatus("✅<br>" + response.message, "success");
                } else {
                    showStatus("❌<br>" + response.message, "error");
                }
            },
            error: function () {
                showStatus("❌<br>서버 통신 오류가 발생했습니다.<br>잠시 후 다시 시도해주세요.", "error");
            },
            complete: function () {
                setTimeout(function () {
                    $('#statusBox').fadeOut(200);
                    if (html5QrCode && html5QrCode.getState() === Html5QrcodeScannerState.PAUSED) {
                        html5QrCode.resume();
                    }
                    isScanning = false;
                }, 2500); // 2.5초 후 카메라 스캔 재개
            }
        });
    }

    function onScanFailure(error) {
        // 백그라운드 프레임 스캔 실패 로그 무시
    }

    window.addEventListener("orientationchange", function() {
        isScanning = true;

        if (html5QrCode && html5QrCode.getState() !== Html5QrcodeScannerState.NOT_STARTED) {
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