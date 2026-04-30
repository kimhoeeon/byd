<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>QR 스캐너 - BYD 출석체크</title>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://unpkg.com/html5-qrcode" type="text/javascript"></script>

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

        /* 스캐너 모드 선택 토글 UI */
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

        #reader {
            width: 100%;
            max-width: 500px;
            margin: 0 auto;
            border: none !important;
            background: #000;
        }

        .status-box {
            margin-top: 20px;
            padding: 15px;
            border-radius: 8px;
            font-size: 1.1em;
            font-weight: bold;
            width: 90%;
            max-width: 470px;
            margin-left: auto;
            margin-right: auto;
            display: none;
            word-break: keep-all;
        }

        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .btn-back {
            display: inline-block;
            margin-top: 25px;
            padding: 12px 24px;
            background-color: #343a40;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
        }
    </style>
</head>
<body>

    <div class="header-box">
        <h2>현장 출석 스캐너</h2>
        <p>고객의 QR 코드를 사각형 안내선 안에 맞춰주세요.</p>
    </div>

    <!-- 스캐너 모드 선택 (챌린지 vs 시승) -->
    <div class="mode-toggle">
        <input type="radio" id="mode101" name="adminCode" value="101" checked>
        <label for="mode101">챌린지 입장 (101)</label>

        <input type="radio" id="mode202" name="adminCode" value="202">
        <label for="mode202">시승 입장 (202)</label>
    </div>

    <div id="reader"></div>
    <div id="statusBox" class="status-box"></div>

    <a href="/mng/main" class="btn-back">대시보드로 돌아가기</a>

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

            // 현재 선택된 모드 값(101 또는 202) 가져오기
            const selectedAdminCode = $('input[name="adminCode"]:checked').val();

            $.ajax({
                url: '/mng/api/checkArrival',
                type: 'POST',
                data: {
                    qrToken: decodedText,
                    adminCode: selectedAdminCode // 추가된 파라미터 전송
                },
                success: function (response) {
                    if (response.success) {
                        showStatus(response.message, "success");
                    } else {
                        showStatus("❌ " + response.message, "error");
                    }
                },
                error: function () {
                    showStatus("❌ 서버 통신 오류가 발생했습니다. 다시 시도해주세요.", "error");
                },
                complete: function () {
                    setTimeout(function () {
                        $('#statusBox').fadeOut(200);
                        html5QrCode.resume();
                        isScanning = false;
                    }, 2500);
                }
            });
        }

        function onScanFailure(error) {
        }

        const config = {
            fps: 15,
            qrbox: {width: 250, height: 250},
            aspectRatio: 1.0,
            formatsToSupport: [Html5QrcodeSupportedFormats.QR_CODE]
        };

        html5QrCode.start({facingMode: "environment"}, config, onScanSuccess, onScanFailure)
            .catch((err) => {
                alert("카메라를 실행할 수 없습니다.\n브라우저의 카메라 권한을 허용해주세요.");
                console.error(err);
            });

    </script>
</body>
</html>