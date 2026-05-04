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

        /* 컨트롤러에서 전달받은 테마 컬러로 뱃지 스타일링 */
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
            /* 카메라 테두리도 각 테마 컬러로 표시하여 직관성 극대화 */
            border: 5px solid ${themeColor} !important;
            border-radius: 12px;
            overflow: hidden;
            background: #000;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
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
    <div class="event-badge">${eventName} 전용 (코드: ${adminCode})</div>
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

    function playBeep() {
        try {
            const ctx = new (window.AudioContext || window.webkitAudioContext)();
            const osc = ctx.createOscillator();
            osc.type = 'sine';
            osc.frequency.setValueAtTime(800, ctx.currentTime);
            osc.connect(ctx.destination);
            osc.start();
            osc.stop(ctx.currentTime + 0.1);
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

        // 히든 인풋에서 고정된 adminCode를 가져옴
        const currentAdminCode = $('#adminCode').val();

        $.ajax({
            url: '/mng/api/checkArrival',
            type: 'POST',
            data: {
                qrToken: decodedText,
                adminCode: currentAdminCode
            },
            success: function (response) {
                if (response.success) {
                    showStatus(response.message, "success");
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
                    html5QrCode.resume();
                    isScanning = false;
                }, delay);
            }
        });
    }

    function onScanFailure(error) {
        // 실패 로그 무시
    }

    const config = {
        fps: 15,
        qrbox: { width: 250, height: 250 },
        disableFlip: false
    };

    html5QrCode.start({facingMode: "environment"}, config, onScanSuccess, onScanFailure)
        .catch((err) => {
            alert("카메라를 실행할 수 없습니다.\n브라우저의 카메라 권한을 허용해주세요.");
            console.error(err);
        });

</script>
</body>
</html>