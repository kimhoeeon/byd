<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="center-popup-backdrop" id="commonPopup" style="display: none;">
    <div class="center-popup">
        <div class="center-popup_body">
            <div class="center-popup_title" id="commonPopupTitle">
            </div>
        </div>

        <div class="center-popup_footer" id="popupFooterConfirm">
            <button type="button" class="btn btn-gray color-b" id="popupCancelBtn" onclick="closePopup()">
                닫기
            </button>
            <button type="button" class="btn btn-primary" id="popupConfirmBtn">
                확인
            </button>
        </div>

        <div class="one_btn" id="popupFooterAlert" style="display:none;">
            <button type="button" class="btn btn-primary st2" onclick="closePopup()">
                확인
            </button>
        </div>
    </div>
</div>

<script>
    // 팝업 열기 함수
    // type: 'confirm' (취소/확인) or 'alert' (확인만)
    // text: 팝업 내용 (HTML 태그 포함 가능)
    // confirmCallback: 확인 버튼 클릭 시 실행할 함수
    // cancelCallback: 취소 버튼 클릭 시 실행할 함수
    function showPopup(type, text, confirmCallback, cancelCallback) {
        const popup = document.getElementById('commonPopup');
        const title = document.getElementById('commonPopupTitle');
        const footerConfirm = document.getElementById('popupFooterConfirm');
        const footerAlert = document.getElementById('popupFooterAlert');

        // 각 버튼 요소 가져오기
        const confirmBtn = document.getElementById('popupConfirmBtn'); // Confirm용 확인 버튼
        const cancelBtn = document.getElementById('popupCancelBtn'); // 취소 버튼 가져오기
        const alertBtn = footerAlert.querySelector('button');          // Alert용 확인 버튼

        // 텍스트 설정
        title.innerHTML = text;

        // 버튼 타입 설정
        if (type === 'confirm') {
            footerConfirm.style.display = 'flex';
            footerAlert.style.display = 'none';

            // Confirm 확인 버튼 클릭 시
            confirmBtn.onclick = function () {
                closePopup(); // 팝업 닫기
                if (confirmCallback) confirmCallback(); // 콜백 실행
            };

            // [취소] 버튼 이벤트 (수정됨)
            // 기존 onclick="closePopup()"을 덮어쓰고 콜백 실행 추가
            cancelBtn.onclick = function () {
                closePopup();
                if (cancelCallback) cancelCallback();
            };
        } else {
            // Alert 타입
            footerConfirm.style.display = 'none';
            footerAlert.style.display = 'block';

            // Alert 확인 버튼 클릭 시에도 콜백 실행 가능하도록 변경
            alertBtn.onclick = function() {
                closePopup();
                if (confirmCallback) confirmCallback();
            };
        }

        popup.style.display = 'block';
    }

    function closePopup() {
        document.getElementById('commonPopup').style.display = 'none';
    }
</script>