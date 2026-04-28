/**
 * [공통] Summernote 에디터 초기화 함수
 * @param {String} selector - 에디터 적용할 태그 ID (예: '#content')
 * @param {Number} height   - 에디터 높이 (기본값: 400)
 */
function initSummernote(selector, height = 400) {
    $(selector).summernote({
        height: height,
        lang: 'ko-KR',
        placeholder: '내용을 입력해주세요 (이미지 드래그 앤 드롭 가능)',
        toolbar: [
            ['style', ['style']],
            ['font', ['bold', 'underline', 'clear']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['table', ['table']],
            ['insert', ['link', 'picture', 'video']],
            ['view', ['fullscreen', 'codeview', 'help']]
        ],
        callbacks: {
            // 이미지 파일 업로드 시 콜백
            onImageUpload: function(files) {
                // 여러 개 파일도 처리 가능하도록 반복문 사용
                for (let i = 0; i < files.length; i++) {
                    uploadEditorImage(files[i], this);
                }
            }
        }
    });
}

/**
 * [내부] 에디터 이미지 서버 전송 (AJAX)
 */
function uploadEditorImage(file, editor) {
    const data = new FormData();
    data.append("file", file);

    $.ajax({
        url: '/api/common/upload/editor', // 위에서 만든 Controller 주소
        type: 'POST',
        data: data,
        contentType: false,
        processData: false,
        success: function(imageUrl) {
            // 서버에 저장된 이미지 경로를 에디터에 삽입
            // imageUrl 예: /upload/editor/uuid_파일명.jpg
            $(editor).summernote('insertImage', imageUrl);
        },
        error: function(err) {
            console.error(err);
            alert('이미지 업로드에 실패했습니다.');
        }
    });
}