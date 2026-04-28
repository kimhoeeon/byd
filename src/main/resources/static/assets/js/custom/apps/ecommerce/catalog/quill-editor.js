"use strict";

// specify the fonts you would
var fonts = ['Arial', 'Courier', 'Garamond', 'Tahoma', 'Verdana', 'Dotum', 'Roboto'];
// generate code friendly names
function getFontName(font) {
    return font.toLowerCase().replace(/\s/g, "-");
}
var fontNames = fonts.map(font => getFontName(font));
// add fonts to style
var fontStyles = "";
fonts.forEach(function(font) {
    var fontName = getFontName(font);
    fontStyles += ".ql-snow .ql-picker.ql-font .ql-picker-label[data-value=" + fontName + "]::before, .ql-snow .ql-picker.ql-font .ql-picker-item[data-value=" + fontName + "]::before {" +
        "content: '" + font + "';" +
        "font-family: '" + font + "', sans-serif;" +
        "}" +
        ".ql-font-" + fontName + "{" +
        " font-family: '" + font + "', sans-serif;" +
        "}";
});
var node = document.createElement('style');
node.innerHTML = fontStyles;
document.body.appendChild(node);

// Class definition
var KTQuillEditor = function () {

    // Add fonts to whitelist
    var Font = Quill.import('formats/font');
    Font.whitelist = fontNames;
    Quill.register(Font, true);

    // Private functions
    var toolbarOptions = [
        [{ 'font': fontNames }],
        ['bold', 'italic', 'underline'],
        [{ 'list': 'ordered'}, { 'list': 'bullet' }],
        [{ 'indent': '-1'}, { 'indent': '+1' }],
        [{ 'size': ['small', false, 'large', 'huge'] }],
        [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
        [{ 'color': [] }, { 'background': [] }],
        [{ 'align': [] }],
        ['image'],
        ['link']
    ];

    // Init quill editor
    const initQuill = () => {

        // Init quill --- more info: https://quilljs.com/docs/quickstart/
        var quill = new Quill('#quill_editor_content', {
            modules: {
                toolbar: toolbarOptions
            },
            placeholder: '내용을 입력하세요.',
            theme: 'snow' // or 'bubble'
        });

        quill.on('text-change', function() {
            let inputHTML = quill.root.innerHTML.replaceAll('&lt;','<').replaceAll('&gt;','>').replaceAll('&nbsp;','');
            document.getElementById("quill_content").value = inputHTML;
            quill.clipboard.convert(inputHTML);
        });

        quill.getModule('toolbar').addHandler('image', function () {
            selectLocalImage(quill);
        });
    }

    function selectLocalImage(quill) {
        const fileInput = document.createElement('input');
        fileInput.setAttribute('type', 'file');

        fileInput.click();

        fileInput.addEventListener("change", function () {  // change 이벤트로 input 값이 바뀌면 실행
            let formData = new FormData();
            const file = fileInput.files[0];
            formData.append('uploadFile', file);

            fetch('/file/upload.do?gbn=quill', {
                method: 'POST',
                body: formData
            })
                .then(res => res.json())
                .then(res => {
                    const range = quill.getSelection(); // 사용자가 선택한 에디터 범위
                    // uploadPath에 역슬래시(\) 때문에 경로가 제대로 인식되지 않는 것을 슬래시(/)로 변환
                    res.uploadPath = res.uploadPath.replace(/\\/g, '/');

                    quill.insertEmbed(range.index, 'image', "/board/uploadFileGet?fileName=" + res.uploadPath + "/" + res.fileName);
                });

        });
    }

    // Public methods
    return {
        init: function () {
            // Init forms
            initQuill();
        }
    };
}();

// On document ready
KTUtil.onDOMContentLoaded(function () {
    KTQuillEditor.init();
});