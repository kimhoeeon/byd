<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <!-- 모바일 기기에서 화면 확대 방지 및 꽉 찬 화면 유지 -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>QR 스캐너 - BYD 출석체크</title>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- 인식률이 가장 뛰어난 html5-qrcode 라이브러리 CDN -->
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

        /* 스캐너 화면을 꽉 차게, 안내선은 뚜렷하게 세팅 */
        #reader {
            width: 100%;
            max-width: 500px;
            margin: 0 auto;
            border: none !important;
            background: #000;
        }

        /* 피드백 박스 UI */
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

    <!-- 카메라 화면 출력 영역 -->
    <div id="reader"></div>

    <!-- 결과 알림 노출 영역 -->
    <div id="statusBox" class="status-box"></div>

    <a href="/mng/main" class="btn-back">대시보드로 돌아가기</a>

    <script>
        let isScanning = false; // 중복 스캔 방지용 플래그
        const html5QrCode = new Html5Qrcode("reader");

        // [효과음] 스캔 성공 시 삑 소리 재생
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

        // [알럿] 상태 메시지 노출 컨트롤
        function showStatus(msg, type) {
            const $box = $('#statusBox');
            $box.removeClass('success error').addClass(type).html(msg).fadeIn(200);
        }

        // 스캔 성공 시 실행되는 함수
        function onScanSuccess(decodedText, decodedResult) {
            // 이미 처리 중이면 추가 스캔 방지
            if (isScanning) return;
            isScanning = true;

            playBeep(); // 삑!
            showStatus("데이터 조회 중...", "success");

            // 안정적인 처리를 위해 잠시 스캐너 화면 정지
            html5QrCode.pause();

            // 서버로 출석 정보 전송
            $.ajax({
                url: '/mng/api/checkArrival',
                type: 'POST',
                data: {qrToken: decodedText}, // Controller에 맞춘 qrToken 파라미터
                success: function (response) {
                    if (response.success) {
                        showStatus(response.message, "success"); // "출석 처리 완료! [홍길동님...]"
                    } else {
                        showStatus("❌ " + response.message, "error"); // "이미 출석 처리됨" 등
                    }
                },
                error: function () {
                    showStatus("❌ 서버 통신 오류가 발생했습니다. 다시 시도해주세요.", "error");
                },
                complete: function () {
                    // 스태프가 결과를 확인할 수 있도록 2.5초 대기 후 스캐너 재가동
                    setTimeout(function () {
                        $('#statusBox').fadeOut(200);
                        html5QrCode.resume();
                        isScanning = false;
                    }, 2500);
                }
            });
        }

        function onScanFailure(error) {
            // 인식 실패는 프레임 단위로 수십 번 발생하므로 조용히 무시합니다.
        }

        // 스캐너 최적화 세팅
        const config = {
            fps: 15, // 프레임 레이트를 높여 스치기만 해도 인식되게 설정
            qrbox: {width: 250, height: 250}, // 사용자에게 초점을 맞출 사각형 가이드라인 제공
            aspectRatio: 1.0, // 정사각형 비율 유지
            formatsToSupport: [Html5QrcodeSupportedFormats.QR_CODE] // QR만 집중 스캔하여 성능 극대화
        };

        // 스캐너 실행 (모바일 환경에서 무조건 후면 카메라 강제)
        html5QrCode.start({facingMode: "environment"}, config, onScanSuccess, onScanFailure)
            .catch((err) => {
                alert("카메라를 실행할 수 없습니다.\n브라우저의 카메라 권한을 허용해주세요.");
                console.error(err);
            });

    </script>
</body>
</html>