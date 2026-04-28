<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!doctype html>
<html lang="ko">
<head>
    <meta name="naver-site-verification" content="07e0fdf4e572854d6fbe274f47714d3e7bbb9fbd" />
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" />
    <meta name="format-detection" content="telephone=no,email=no,address=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="mobile-web-app-capable" content="yes" />

    <meta property="og:type" content="website">
    <meta property="og:locale" content="ko_KR">
    <meta property="og:site_name" content="승요일기">
    <meta property="og:title" content="승요일기 | 야구 직관 기록 앱">
    <meta property="og:description" content="야구 직관 기록을 더 쉽고 재미있게! 경기 결과, 기록, 사진과 함께 나만의 야구 직관일기를 남겨보세요.">
    <meta name="keywords" content="승요일기 / 야구 직관 / 프로야구 직관 / 직관 후기 / 직관일기 / KBO / KBO 직관 / 프로야구 앱 / 야구팬 앱">
    <meta property="og:url" content="https://myseungyo.com/">
    <meta property="og:image" content="https://myseungyo.com/img/og_img.jpg">

    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="manifest" href="/site.webmanifest" />

    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">

    <title>프로필 수정 | 승요일기</title>

    <style>
        .input { position: relative; }
        .btn-del {
            position: absolute;
            right: 0;
            top: 50%;
            transform: translateY(-50%);
            width: 30px;
            height: 100%;
            background: url(/img/ico_del.svg) no-repeat center;
            border: none;
            cursor: pointer;
            display: none; /* 기본 숨김 */
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
</head>

<body>
    <div class="app">

        <header class="app-header">
            <button class="app-header_btn app-header_back" type="button" onclick="history.back()">
                <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
            </button>
        </header>

        <div class="app-main column">

            <div class="app-tit">
                <div class="page-tit">프로필 수정</div>
            </div>

            <form id="profileForm" action="/member/update/profile" method="post" enctype="multipart/form-data">

                <div class="stack mt-24">

                    <div class="profile-img-area" style="text-align:center; margin-bottom:30px;">
                        <div class="img-box" style="position:relative; width:100px; height:100px; margin:0 auto; border-radius:50%; overflow:hidden; background:#f5f5f5;">
                            <img id="previewImg"
                                 src="${not empty member.profileImage ? member.profileImage : '/img/ico_user.svg'}"
                                 alt="프로필 이미지"
                                 style="width:100%; height:100%; object-fit:cover;">
                        </div>

                        <input type="file" id="profileFile" name="file" accept="image/*" style="display:none;" onchange="previewImage(this)">
                        <button type="button" class="btn btn-xs btn-secondary mt-12" onclick="document.getElementById('profileFile').click()">
                            사진 변경
                        </button>
                    </div>

                    <div class="profile_info">
                        <div class="profile-info_item">
                            <div class="gu">현재 닉네임 : <span class="nickname">${member.nickname}</span></div>
                            <div class="nae">
                                <div class="input">
                                    <input type="text" id="newNickname" name="nickname"
                                           value="${member.nickname}"
                                           placeholder="변경할 닉네임을 입력해 주세요." autocomplete="off">

                                    <button type="button" class="btn-del" id="clearBtn"></button>
                                </div>

                                <div id="validMsg" class="login-message is-error" style="display:none; margin-top:5px; color:#ff0000; font-size:12px;"></div>

                                <c:if test="${not empty error}">
                                    <div id="serverMsg" class="login-message is-show is-error" style="margin-top:5px; color:#ff0000; font-size:12px;">${error}</div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
            <div class="one-time"><img src="/img/ico_not_mark_blue.svg" alt="주의 아이콘">닉네임 변경은 월 1회 가능합니다.</div>
        </div>
    </div>

    <div class="bottom-action bottom-main">
        <button type="button" class="btn btn-primary" id="submitBtn" disabled onclick="submitForm()">변경 완료</button>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
    <script>
        const input = document.getElementById('newNickname');
        const clearBtn = document.getElementById('clearBtn');
        const submitBtn = document.getElementById('submitBtn');
        const validMsg = document.getElementById('validMsg');
        const serverMsg = document.getElementById('serverMsg');

        // 닉네임 정규식 (한글, 영문 대소문자, 숫자 허용 2~6자리)
        const nickRegex = /^[가-힣a-zA-Z0-9]{2,6}$/;

        input.addEventListener('input', function() {
            // 1. 입력값 있으면 삭제 버튼 표시
            if (this.value.length > 0) {
                clearBtn.style.display = 'block';
            } else {
                clearBtn.style.display = 'none';
            }

            // 서버 에러 메시지 숨김
            if(serverMsg) serverMsg.style.display = 'none';

            // 2. 유효성 검사
            if (nickRegex.test(this.value)) {
                validMsg.style.display = 'none';
                submitBtn.disabled = false;
            } else {
                if (this.value.length > 0) {
                    validMsg.innerText = '2~6자리의 한글 또는 영문, 숫자 중 2개 이상 조합하여 가능합니다.';
                    validMsg.className = 'login-message is-show is-error';
                    validMsg.style.display = 'block';
                } else {
                    validMsg.style.display = 'none';
                }
                submitBtn.disabled = true;
            }
        });

        // 삭제 버튼 클릭 시 초기화
        clearBtn.addEventListener('click', function() {
            input.value = '';
            this.style.display = 'none';
            validMsg.style.display = 'none';
            submitBtn.disabled = true;
            input.focus();
        });

        // AJAX 전송 및 결과 팝업 처리
        function submitForm() {
            const nicknameVal = input.value;
            if (!nickRegex.test(nicknameVal)) {
                alert('닉네임 형식이 올바르지 않습니다.');
                return;
            }

            // FormData 객체 생성 (파일 + 텍스트 데이터)
            const form = document.getElementById('profileForm');
            const formData = new FormData(form);

            $.ajax({
                type: 'POST',
                url: '/member/update/profile',
                data: formData,
                processData: false, // 파일 전송 시 필수
                contentType: false, // 파일 전송 시 필수
                success: function(res) {
                    if (res === 'ok') {
                        // 성공 팝업 (확인 클릭 시 마이페이지 이동)
                        alert('프로필이 수정되었습니다.', function() {
                            location.href = '/member/mypage';
                        });
                    } else {
                        // 실패 팝업
                        alert(res);
                    }
                },
                error: function() {
                    alert('서버 통신 중 오류가 발생했습니다.');
                }
            });
        }

        function previewImage(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('previewImg').src = e.target.result;
                };
                reader.readAsDataURL(input.files[0]);

                // 사진을 바꾸면 [변경 완료] 버튼 활성화 로직도 필요하면 추가
                document.getElementById('submitBtn').disabled = false;
            }
        }
    </script>
</body>
</html>