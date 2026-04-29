<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 QR 스캐너</title>
    <script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
    <!-- HTML5 QR Scanner Library -->
    <script src="https://unpkg.com/html5-qrcode"></script>
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f5f8fa;
            text-align: center;
            padding: 20px;
        }

        .scanner-container {
            max-width: 500px;
            margin: 0 auto;
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        #reader {
            width: 100%;
            border-radius: 10px;
            overflow: hidden;
        }

        #result {
            margin-top: 20px;
            padding: 15px;
            font-size: 16px;
            font-weight: bold;
            border-radius: 8px;
            display: none;
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
    </style>
</head>
<body>

<div class="scanner-container">
    <h2 style="margin-bottom: 10px;">시승 고객 QR 출석 체크</h2>
    <p style="margin-bottom: 20px; color: #666;">카메라 영역에 고객의 모바일 티켓을 스캔하세요.</p>

    <!-- 카메라 뷰 영역 -->
    <div id="reader"></div>

    <!-- 스캔 결과 메시지 -->
    <div id="result"></div>
</div>

<script>
    $(document).ready(function () {
        let isScanning = false;

        function onScanSuccess(decodedText, decodedResult) {
            if (isScanning) return;
            isScanning = true;

            // QR코드에서 URL 추출 및 seq 파싱
            let url;
            try {
                url = new URL(decodedText);
            } catch (e) {
                showResult("유효하지 않은 QR 코드 형식입니다.", false);
                resetScanState();
                return;
            }

            let seq = url.searchParams.get("seq");

            if (!seq) {
                showResult("QR 코드에 회원 정보가 없습니다.", false);
                resetScanState();
                return;
            }

            // 서버로 출석 체크 요청
            $.ajax({
                url: '/mng/api/checkArrival',
                type: 'POST',
                data: {seq: seq},
                success: function (res) {
                    showResult(res.message, res.success);
                },
                error: function () {
                    showResult("서버 통신 오류가 발생했습니다.", false);
                },
                complete: function () {
                    resetScanState();
                }
            });
        }

        function showResult(message, isSuccess) {
            let $result = $('#result');
            $result.text(message).removeClass('success error');
            if (isSuccess) {
                $result.addClass('success');
            } else {
                $result.addClass('error');
            }
            $result.fadeIn();
        }

        function resetScanState() {
            // 3초 후 다음 스캔 대기 상태로 전환
            setTimeout(function () {
                isScanning = false;
                $('#result').fadeOut();
            }, 3000);
        }

        // QR 스캐너 초기화 (초당 10프레임)
        let html5QrcodeScanner = new Html5QrcodeScanner("reader", {fps: 10, qrbox: {width: 250, height: 250}}, false);
        html5QrcodeScanner.render(onScanSuccess);
    });
</script>
</body>
</html>