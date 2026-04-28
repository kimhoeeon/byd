"use strict";

// Class definition
let KTProjectList = function () {

    let initChart1 = function () {

        let colors = [
            '#267ec3', //상시신청
            '#26e7a6', //해상엔진 테크니션 (선내기/선외기)
            '#febc3b', //FRP 레저보트 선체 정비 테크니션
            '#ff6178', //선외기 기초정비실습 과정
            '#8b75d7', //선내기 기초정비실습 과정
            '#46b3a9', //세일요트 기초정비실습 과정
            '#d830eb', //고마력 선외기 정비 중급 테크니션
            '#a10000', //자가정비 심화과정 (고마력 선외기)
            '#138ccb', //고마력 선외기 정비 중급 테크니션 (특별반)
            '#de7abd', //스턴드라이브 정비 전문가과정
            '#de3618', //스턴드라이브 정비 전문가과정 (특별반)
            '#c1f119', //기초정비교육
            '#4a18de', //응급조치교육
            '#5fa7c5', //발전기 정비 교육
            '#c51d9e', //선외기/선내기 직무역량 강화과정
            '#f3bb05', //선내기 팸투어
            '#78d3a7', //선외기 팸투어
        ];

        // init chart
        let element = document.getElementById("kt_project_list_chart1");

        if (!element) {
            return;
        }

        let chart = {
            self: null,
            rendered: false
        };

        let initChart_opt = function(){
            let options = {
                series: [],/*44, 55, 13, 43, 22*/
                labels: [],
                colors: colors,
                chart: {
                    id: 'pieChart',
                    width: 500,
                    height: 400,
                    type: 'pie',
                },
                responsive: [{
                    breakpoint: 480,
                    options: {
                        chart: {
                            width: 200
                        },
                        legend: {
                            position: 'bottom'
                        }
                    }
                }]
            };

            chart.self = new ApexCharts(element, options);
            chart.self.render();
            chart.rendered = true;

            $.getJSON('/mng/main/statistics/train/member.do', function(response) {
                chart.self.updateOptions(
                        /*series: [10,20,30],
                        labels: ['Active', 'Completed', 'Yet to start']*/
                        response
                )
            })
        }

        initChart_opt();

        // Update chart on theme mode change
        KTThemeMode.on("kt.thememode.change", function() {
            if (chart.rendered) {
                chart.self.destroy();
            }

            initChart_opt();
        });

    }

    let initChart2 = function () {

        // init chart
        let element = document.getElementById("kt_project_list_chart2");

        if (!element) {
            return;
        }

        let chart = {
            self: null,
            rendered: false
        };

        let initChart2_opt = function(){
            let colors = [
                '#267ec3',
                '#26e7a6',
                '#febc3b',
                '#ff6178',
                '#8b75d7',
                '#46b3a9',
                '#d830eb',
                '#de7abd'
            ];

            let options = {
                series: [],
                chart: {
                    toolbar: {
                        show: false
                    },
                    width: 600,
                    height: 350,
                    type: 'bar',
                    events: {
                        click: function(chart, w, e) {
                            // console.log(chart, w, e)
                        }
                    }
                },
                colors: colors,
                plotOptions: {
                    bar: {
                        borderRadius: 3,
                        horizontal: true,
                        columnWidth: '10%',
                        distributed: true,
                    }
                },
                dataLabels: {
                    enabled: false
                },
                legend: {
                    show: false
                },
                xaxis: {
                    categories: [
                        '요트·보트전',
                        '무동력보트전',
                        '워크보트전',
                        '해양레저관',
                        '카라반쇼',
                        '해양부품·안전·마리나산업전',
                        '친환경 특별전',
                        '한국해양관광전',
                    ],
                    labels: {
                        style: {
                            colors: colors,
                            fontSize: '12px'
                        }
                    }
                }
            };

            chart.self = new ApexCharts(element, options);
            chart.self.render();
            chart.rendered = true;

            $.getJSON('/mng/main/statistics/company/fieldPart.do', function(response) {
                chart.self.updateSeries([{
                    data: response
                }])
            })
        }

        initChart2_opt();

        // Update chart on theme mode change
        KTThemeMode.on("kt.thememode.change", function() {
            if (chart.rendered) {
                chart.self.destroy();
            }

            initChart2_opt();
        });
    }

    // Public methods
    return {
        init: function () {
            initChart1();
            initChart2();
        }
    }
}();

// On document ready
KTUtil.onDOMContentLoaded(function() {
    KTProjectList.init();
});