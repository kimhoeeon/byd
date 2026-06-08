$(document).ready(function () {
    // 모바일 슬라이드 메뉴
    $('.m_menu').on('click', function () {
        $(this).toggleClass('on');
        $('.aside').toggleClass('on');
        $('.aside_bg').toggleClass('on');
    });


    // 영문 더보기   
    $('.moreView').on('click', function () {
        $(this).siblings('.viewEng').slideToggle(300);
    });

    // 맵 보기    
    $('#viewMapBtn, #viewMap .close').on('click', function () {
        $('#viewMap').toggleClass('on');
        $('body').toggleClass('lock_scroll')
    });

    // 영상 팝업 재생
    // $('#viewVideoBtn, #viewVideo .close').on('click', function() {
    //     $('#viewVideo').toggleClass('on');
    //     $('body').toggleClass('lock_scroll');
    //     var video = $('#playVideo')[0];

    //     if (video.paused) {
    //         video.currentTime = 0;
    //         video.play();
    //     } else {
    //         video.pause();
    //     }
    // });

    // 영상 소리 제어
    $('#viewVideoBtn').on('click', function () {
        var video = $('#mutedOn')[0];
        video.muted = !video.muted; // 소리를 토글(켜기/끄기)
    });



    // 직원확인용팝업    
    $('#enterCodeBtn, .enterCode .btn a').on('click', function () {
        $('.enterCode').toggleClass('on');
        $('body').toggleClass('lock_scroll')
    });


    // 숫자만 입력
    $('.onlyNum').on("keyup", function () {
        $(this).val($(this).val().replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1'));
    });


    //코스 슬라이드
    var swiper = new Swiper('.swiper_gallery', {
        // direction: "vertical",
        slidesPerView: 1,
        spaceBetween: 20,
        autoHeight: true,
        loop: false,
        navigation: {
            nextEl: '.swiper_gallery_next',
            prevEl: '.swiper_gallery_prev',
        },
        on: {
            resize: function () {
                swiper.changeDirection(getDirection());
            },

        },

    });

    function getDirection() {
        var windowWidth = window.innerWidth;
        var direction = window.innerWidth <= 0 ? 'vertical' : 'horizontal';

        return direction;
    }



});


$(document).ready(function () {
    const questions = [
        {
            type: 'multi',
            question: 'BYD는 어느 나라 브랜드일까요?',
            options: ['독일', '일본', '중국', '프랑스'],
            correctAnswer: 4
        },
        {
            type: 'multi',
            question: 'BYD가 처음 시작한 분야는?',
            options: ['타이어', '엔진', '시트', '배터리'],
            correctAnswer: 4
        },
        {
            type: 'multi',
            question: 'BYD는 어느해에 설립 되었나요?',
            options: ['1990', '1992', '1994', '1996'],
            correctAnswer: 3
        },
        {
            type: 'multi',
            question: 'BYD가 순수 내연기관 차량 생산을 중단한 시기는 언제일까요?',
            options: ['2018년', '2020년', '2022년', '2024년'],
            correctAnswer: 3
        },
        {
            type: 'multi',
            question: 'BYD의 대표적인 배터리 기술은? ',
            options: ['스마트폰 배터리', '원통형 배터리', '건전지 배터리', '블레이드 배터리'],
            correctAnswer: 4
        },
        {
            type: 'multi',
            question: '블레이드 배터리의 특징이 아닌것은? ',
            options: ['안전성', '초저비용', '고강도', '고출력'],
            correctAnswer: 2
        },
        {
            type: 'multi',
            question: '블레이드 배터리의 출시년도는?',
            options: ['2019년', '2020년', '2021년', '2022년'],
            correctAnswer: 2
        },
        {
            type: 'multi',
            question: 'BYD의 브랜드명 BYD는 무엇의 약자일까요?',
            options: ['Battery Your Drive ', 'Build Your Dream', 'Build Your Drive', 'Build Your Dreams'],
            correctAnswer: 4
        },
        {
            type: 'multi',
            question: 'BYD 글로벌 디자인 총괄의 이름은?',
            options: ['스티브 잡스', '일론 머스크', '볼프강 에거', '조르지오 아르마니'],
            correctAnswer: 3
        },
        {
            type: 'multi',
            question: 'BYD의 본사가 있는 도시는?',
            image: '../img/img_quiz_03.png',
            options: ['상하이', '선전', '베이징', '광저우'],
            correctAnswer: 2
        }
    ];

    let currentQuestionIndex = 0;
    let timer = 10;
    let countdownInterval;
    let correctCount = 0;
    let isAnswerShown = false;

    const isHostMode = $('body').hasClass('host');

    const corrElement = $('#header .corr');
    const timerElement = $('#timer');
    const nextButton = $('.btn_box .btn_st05');

    function updateProgress() {
        $('.quiz_progress .progress_item').removeClass('on');

        $('.quiz_progress .progress_item').each(function (index) {
            if (index <= currentQuestionIndex) {
                $(this).addClass('on');
            }
        });
    }

    function updateTimerDisplay() {
        if (!timerElement.length) return;

        timerElement.html(`
            <div class="timer_wrap">
                <svg class="timer_svg" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
                    <g class="timer_circle">
                        <circle class="timer_path_elapsed" cx="50" cy="50" r="45"></circle>
                        <path
                            id="timer_path_remaining"
                            stroke-dasharray="${283 * (timer / 10)} 283"
                            class="timer_path_remaining"
                            d="
                                M 50, 50
                                m -45, 0
                                a 45,45 0 1,0 90,0
                                a 45,45 0 1,0 -90,0
                            "
                        ></path>
                    </g>
                </svg>
                <span id="timer_label" class="timer_label">${timer}</span>
            </div>
        `);
    }

    function startTimer() {
        clearInterval(countdownInterval);
        timer = 10;
        updateTimerDisplay();

        countdownInterval = setInterval(function () {
            timer--;
            updateTimerDisplay();

            if (timer <= 0) {
                clearInterval(countdownInterval);
                timer = 0;
                updateTimerDisplay();
            }
        }, 1000);
    }

    function resetChoiceState() {
        $('.btn_multi label').removeClass('correct wrong');

        $('input[name="choice"]').prop({
            checked: false,
            disabled: false
        });
    }

    function loadQuestion() {
        const currentQuestion = questions[currentQuestionIndex];

        isAnswerShown = false;

        $('.quiz_explanation').empty().hide();
        $('.quiz_result_image').empty().hide();

        $('.quiz_a .ask').html(currentQuestion.question);
        $('.quiz_a .numb').text(currentQuestionIndex + 1);

        resetChoiceState();

        const optionElements = $('.multi .btn_multi');
        optionElements.hide();

        currentQuestion.options.forEach(function (option, index) {
            const optionElement = optionElements.eq(index);

            optionElement.find('input').val(index + 1);
            optionElement.find('label').text(option);
            optionElement.show();
        });

        if ($('.quiz_img').length) {
            if (currentQuestion.image) {
                $('.quiz_img img').attr('src', currentQuestion.image);
                $('.quiz_img').show();
            } else {
                $('.quiz_img').hide();
            }
        }

        if (currentQuestionIndex === questions.length - 1) {
            nextButton.text('완료');
        } else {
            nextButton.text('다음');
        }

        updateProgress();
        startTimer();
    }

    function checkAnswer() {
        const selectedOption = $('input[name="choice"]:checked').val();
        const currentQuestion = questions[currentQuestionIndex];

        if (selectedOption && parseInt(selectedOption) === currentQuestion.correctAnswer) {
            correctCount++;
        }

        corrElement.text(correctCount);
    }

    function showAnswer() {
        if (isAnswerShown) return;

        const currentQuestion = questions[currentQuestionIndex];
        const selectedOption = $('input[name="choice"]:checked').val();

        $('.btn_multi').each(function () {
            const inputValue = parseInt($(this).find('input').val());
            const label = $(this).find('label');

            if (inputValue === currentQuestion.correctAnswer) {
                label.addClass('correct');
            }
        });

        if (selectedOption && parseInt(selectedOption) !== currentQuestion.correctAnswer) {
            $('input[name="choice"]:checked').next('label').addClass('wrong');
        }

        $('input[name="choice"]').prop('disabled', true);

        checkAnswer();
        isAnswerShown = true;
    }

    function goNextQuestion() {
        currentQuestionIndex++;

        if (currentQuestionIndex < questions.length) {
            loadQuestion();
        } else {
            window.location.href = 'end.html';
        }
    }

    if (isHostMode) {
        $(document).on('click', function (e) {
            if ($(e.target).closest('a').length) return;

            if (!isAnswerShown) {
                showAnswer();
            } else {
                clearInterval(countdownInterval);
                goNextQuestion();
            }
        });

        $('.multi').on('click', function (e) {
            e.stopPropagation();
        });

        $('.btn_multi label').on('click', function (e) {
            e.stopPropagation();
        });
    } else {
        nextButton.on('click', function () {
            clearInterval(countdownInterval);
            checkAnswer();
            goNextQuestion();
        });
    }

    loadQuestion();

});
