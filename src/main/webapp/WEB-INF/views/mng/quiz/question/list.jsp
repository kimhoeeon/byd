<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <title>BYD ADMIN | 퀴즈 문제 관리</title>
    <link rel="stylesheet" href="/assets/plugins/global/plugins.bundle.css">
    <link rel="stylesheet" href="/assets/css/style.bundle.css">
</head>

<body id="kt_app_body" data-kt-app-layout="dark-sidebar" data-kt-app-header-fixed="true"
      data-kt-app-sidebar-enabled="true" data-kt-app-sidebar-fixed="true" class="app-default">
<div class="d-flex flex-column flex-root app-root">
    <div class="app-page flex-column flex-column-fluid">
        <jsp:include page="/WEB-INF/views/mng/include/header.jsp"/>

        <div class="app-wrapper flex-column flex-row-fluid" id="kt_app_wrapper">
            <jsp:include page="/WEB-INF/views/mng/include/sidebar.jsp"/>

            <div class="app-main flex-column flex-row-fluid" id="kt_app_main">
                <div class="d-flex flex-column flex-column-fluid">
                    <div id="kt_app_content" class="app-content flex-column-fluid mt-8">
                        <div class="app-container container-fluid">

                            <div class="d-flex justify-content-between align-items-center mb-5">
                                <h3 class="fw-bold text-dark mb-0">퀴즈 문제 관리 <span
                                        class="fs-6 text-muted">총 ${qList.size()}문제</span></h3>
                                <div>
                                    <a href="/mng/quiz/list" class="btn btn-dark me-2">신청자 목록</a>
                                    <button type="button" class="btn btn-primary fw-bold" onclick="openModal()">+ 새 문제
                                        추가
                                    </button>
                                </div>
                            </div>

                            <div class="card shadow-sm">
                                <div class="card-body py-4">
                                    <div class="table-responsive">
                                        <table class="table align-middle table-row-dashed fs-6 gy-5 table-hover">
                                            <thead>
                                            <tr class="text-center text-gray-500 fw-bold fs-7 text-uppercase gs-0 bg-light">
                                                <th class="w-50px">No</th>
                                                <th class="min-w-300px text-start">문제 내용</th>
                                                <th class="min-w-80px">정답</th>
                                                <th class="min-w-100px">관리</th>
                                            </tr>
                                            </thead>
                                            <tbody class="fw-semibold text-gray-600 text-center">
                                            <c:if test="${empty qList}">
                                                <tr>
                                                    <td colspan="4" class="py-10">등록된 문제가 없습니다.</td>
                                                </tr>
                                            </c:if>

                                            <c:forEach items="${qList}" var="q">
                                                <tr>
                                                    <td>${q.questionId}</td>
                                                    <td class="text-start">
                                                        <span class="text-dark fw-bold fs-6">${q.questionText}</span>
                                                        <div class="text-muted fs-7 mt-1">
                                                            ① ${q.choice1} / ② ${q.choice2} / ③ ${q.choice3} /
                                                            ④ ${q.choice4}
                                                        </div>
                                                    </td>
                                                    <td><span
                                                            class="badge badge-light-success fs-6 fw-bold">${q.correctAnswer}번</span>
                                                    </td>
                                                    <td>
                                                        <button class="btn btn-sm btn-light-primary me-1" onclick="openModal(${q.questionId})">수정</button>
                                                        <button class="btn btn-sm btn-light-danger" onclick="deleteQuestion(${q.questionId})">삭제</button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="questionModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered mw-900px">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="fw-bold" id="modalTitle">문제 등록</h2>
                <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                    <span class="svg-icon svg-icon-1">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <rect opacity="0.5" x="6" y="17.3137" width="16" height="2" rx="1" transform="rotate(-45 6 17.3137)" fill="currentColor"></rect>
                            <rect x="7.41422" y="6" width="16" height="2" rx="1" transform="rotate(45 7.41422 6)" fill="currentColor"></rect>
                        </svg>
                    </span>
                </div>
            </div>

            <div class="modal-body scroll-y mx-5 mx-xl-15 my-7">
                <form id="questionForm" class="form">
                    <input type="hidden" name="questionId" id="questionId" value="0">

                    <div class="d-flex flex-column mb-7 fv-row">
                        <label class="d-flex align-items-center fs-6 fw-semibold form-label mb-2">
                            <span class="required">문제 텍스트</span></label>
                        <input type="text" class="form-control form-control-solid" name="questionText" id="questionText" required>
                    </div>

                    <div class="row mb-5">
                        <div class="col-md-12 mb-5 fv-row">
                            <label class="fs-6 fw-semibold mb-2">보기 1</label>
                            <input type="text" class="form-control form-control-solid" name="choice1" id="choice1" required>
                        </div>
                        <div class="col-md-12 mb-5 fv-row">
                            <label class="fs-6 fw-semibold mb-2">보기 2</label>
                            <input type="text" class="form-control form-control-solid" name="choice2" id="choice2" required>
                        </div>
                        <div class="col-md-12 mb-5 fv-row">
                            <label class="fs-6 fw-semibold mb-2">보기 3</label>
                            <input type="text" class="form-control form-control-solid" name="choice3" id="choice3" required>
                        </div>
                        <div class="col-md-12 mb-5 fv-row">
                            <label class="fs-6 fw-semibold mb-2">보기 4</label>
                            <input type="text" class="form-control form-control-solid" name="choice4" id="choice4" required>
                        </div>
                    </div>

                    <div class="d-flex flex-column mb-7 fv-row">
                        <label class="fs-6 fw-semibold mb-2"><span class="required">정답 (1~4)</span></label>
                        <select name="correctAnswer" id="correctAnswer" class="form-select form-select-solid" required>
                            <option value="1">1번</option>
                            <option value="2">2번</option>
                            <option value="3">3번</option>
                            <option value="4">4번</option>
                        </select>
                    </div>

                    <div class="text-center pt-15">
                        <button type="button" class="btn btn-light me-3" data-bs-dismiss="modal">취소</button>
                        <button type="button" class="btn btn-primary" onclick="saveQuestion()">
                            <span class="indicator-label">저장하기</span>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="/assets/plugins/global/plugins.bundle.js"></script>
<script src="/assets/js/scripts.bundle.js"></script>
<script>
    const modalEl = document.getElementById('questionModal');
    const bsModal = new bootstrap.Modal(modalEl);

    // 모달 열기 (신규 OR 수정)
    function openModal(questionId = 0) {
        // 폼 초기화
        $('#questionForm')[0].reset();
        $('#questionId').val(questionId);

        if (questionId === 0) {
            $('#modalTitle').text('새 문제 등록');
            bsModal.show();
        } else {
            $('#modalTitle').text('문제 수정');
            // 기존 데이터 가져오기
            $.ajax({
                url: '/mng/quiz/question/api/get',
                type: 'GET',
                data: {questionId: questionId},
                success: function (res) {
                    if (res.success && res.data) {
                        $('#questionText').val(res.data.questionText);
                        $('#choice1').val(res.data.choice1);
                        $('#choice2').val(res.data.choice2);
                        $('#choice3').val(res.data.choice3);
                        $('#choice4').val(res.data.choice4);
                        $('#correctAnswer').val(res.data.correctAnswer);
                        bsModal.show();
                    } else {
                        alert("데이터를 불러올 수 없습니다.");
                    }
                }
            });
        }
    }

    // 문제 저장 (신규/수정 공통)
    function saveQuestion() {
        if (!$('#questionText').val() || !$('#choice1').val() || !$('#choice2').val() || !$('#choice3').val() || !$('#choice4').val()) {
            alert("문제와 보기 4개를 모두 입력해 주세요.");
            return;
        }

        const formData = $('#questionForm').serialize();

        $.ajax({
            url: '/mng/quiz/question/api/save',
            type: 'POST',
            data: formData,
            success: function (res) {
                if (res.success) {
                    alert(res.message);
                    location.reload();
                } else {
                    alert(res.message);
                }
            },
            error: function () {
                alert("통신 오류가 발생했습니다.");
            }
        });
    }

    // 문제 삭제
    function deleteQuestion(questionId) {
        if (confirm("정말 이 문제를 삭제하시겠습니까?")) {
            $.ajax({
                url: '/mng/quiz/question/api/delete',
                type: 'POST',
                data: {questionId: questionId},
                success: function (res) {
                    if (res.success) {
                        alert(res.message);
                        location.reload();
                    } else {
                        alert(res.message);
                    }
                }
            });
        }
    }
</script>
</body>
</html>