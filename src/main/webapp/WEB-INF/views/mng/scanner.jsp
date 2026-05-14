<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>${eventName} 전용 스캐너 - BYD 출석체크</title>

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
    <div class="event-badge">${eventName} 전용<%-- (코드: ${adminCode})--%></div>
</div>

<!-- 백엔드에서 전달받은 스캐너 용도 고정 코드 -->
<input type="hidden" id="adminCode" value="${adminCode}">

<div class="scanner-container">
    <div id="reader"></div>
    <div id="statusBox" class="status-box"></div>
</div>

<a href="/mng/inquiry" class="btn-back">수동 조회 화면으로 이동</a>

<script>
    let isScanning = false;
    const html5QrCode = new Html5Qrcode("reader");

    // 오디오 컨텍스트를 전역 변수로 한 번만 선언하여 메모리 누수 차단
    let audioCtx = null;

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

    function playBeep() {
        try {
            if (!audioCtx) {
                audioCtx = new (window.AudioContext || window.webkitAudioContext)();
            }
            // 브라우저 정책상 잠겨있는 오디오를 깨움
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
        showStatus("데이터 조회 중...", "success");
        html5QrCode.pause();

        const adminCode = $('#adminCode').val();

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
                showStatus("❌<br>서버 통신 오류가 발생했습니다.<br>다시 시도해주세요.", "error");
            },
            complete: function (jqXHR) {
                const res = jqXHR.responseJSON;
                const delay = (res && !res.success) ? 1500 : 2500;

                setTimeout(function () {
                    $('#statusBox').fadeOut(200);
                    if (html5QrCode.getState() === Html5QrcodeScannerState.PAUSED) {
                        html5QrCode.resume();
                    }
                    isScanning = false;
                }, delay);
            }
        });
    }

    function onScanFailure(error) {
        // 실패 로그 무시
    }

    // 1. 카메라 시작 로직을 별도의 함수로 분리합니다.
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
            // [수정 3] 엔터(줄바꿈) 구문 수정 및 \\n 정상화
            alert("🚨 권한 차단됨!\n\n1. 상단바를 내려서 '카메라 사용' 버튼이 켜져있는지 확인\n2. 열려있는 다른 앱(카메라 등) 모두 닫기\n사유: " + err);
        });
    }

    // 2. 최초 진입 시 카메라 켜기
    startScanner();

    // 3. 기기 회전(방향 전환) 이벤트 감지 및 카메라 재시작 로직 추가
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