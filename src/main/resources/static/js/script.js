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

