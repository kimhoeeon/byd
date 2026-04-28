"use strict";

let DTCustomerMember = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[0, 'desc']],
            'columnDefs': [
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 8,
                    'render': function (data) {
                        if (data === '1') {
                            return 'O'
                        } else {
                            return 'X'
                        }
                    }
                },
                {
                    'targets': 10,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [1] }
            ],
            columns: [
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'applyStatus'},
                { data: 'grade'},
                { data: 'id'},
                { data: 'name'},
                { data: 'sex'},
                { data: 'phone'},
                { data: 'smsYn'},
                { data: 'initRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        renderHTML += '<div id="kt_menu_item" class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_member_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_member_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">수정</a>';
        renderHTML += '</div>';
        /*renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_member_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';*/
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_customer_member_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_customer_member_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 0, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_customer_member_search();

        }
    };
}();

let DTCustomerResume = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[1, 'desc']],
            'columnDefs': [
                { orderable: false, targets: [0,9] }, // Disable ordering on column 0 (checkbox)
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 0,
                    'render': function (data, type, row) { return renderCheckBoxCell(data, type, row); }
                },
                {
                    'targets': 4,
                    'render': function (data, type, row) { return renderNameCell(data, type, row); }
                },
                {
                    'targets': 5,
                    'render': function (data, type, row) { return renderContactCell(data, type, row); }
                },
                {
                    'targets': 9,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [2] }
            ],
            columns: [
                { data: '' },
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'id'},
                { data: 'name'},
                { data: 'contact'},
                { data: 'sex'},
                { data: 'initRegiDttm' },
                { data: 'finalRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderContactCell(data, type, row) {
        let renderHTML = '';
        let phone = row.phone;
        if(nvl(phone,'') !== ''){
            renderHTML += phone;
        }else{
            renderHTML += '-';
        }
        renderHTML += '</br>';
        let email = row.email;
        if(nvl(email,'') !== ''){
            renderHTML += email;
        }else{
            renderHTML += '-';
        }

        return renderHTML;
    }

    function renderCheckBoxCell(data, type, row){
        let renderHTML = '<div class="train_check form-check form-check-sm form-check-custom form-check-solid">' +
            '<input class="form-check-input" type="checkbox" value="'+ row.seq +'" data-value="' + row.nameKo + '"/>' +
            '</div>';
        return renderHTML;
    }

    function renderNameCell(data, type, row) {
        let renderHTML = '';
        let nameKo = row.nameKo;
        let nameEn = row.nameEn;
        if(nvl(nameKo,'') !== ''){
            renderHTML += nameKo;
        }else{
            renderHTML += '-';
        }
        if(nvl(nameEn,'') !== ''){
            renderHTML += '<br>' + nameEn;
        }else{
            renderHTML += '<br>-';
        }

        return renderHTML;
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        /*renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_resume_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';*/
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a href="/mng/customer/resume/detail.do?seq=' + seq + '" class="menu-link px-3" onclick="window.open(this.href, \'_blank\', \'width=900, height=900, location=no, status=no, toolbar=no, menubar=no\'); return false;">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_customer_resume_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_customer_resume_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 1, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_customer_resume_search();
        }
    };
}();

let DTCustomerRegular = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[1, 'desc']],
            'columnDefs': [
                { orderable: false, targets: 0 }, // Disable ordering on column 0 (checkbox)
                {
                    'targets': [0,1,2,3,4,6,7,8,9,10,11,12]/*'_all'*/,
                    'className': 'text-center'
                },
                {
                    'targets': 0,
                    'render': function (data, type, row) { return renderCheckBoxCell(data, type, row); }
                },
                {
                    'targets': 3,
                    'render': function (data, type, row) { return renderApplyStatusCell(data, type, row); }
                },
                {
                    'targets': 4,
                    'render': function (data, type, row) { return renderGradeCell(data, type, row); }
                },
                {
                    'targets': 5,
                    'render': function (data, type, row) { return renderFieldCell(data, type, row); }
                },
                {
                    'targets': 6,
                    'render': function (data, type, row) { return renderIdCell(data, type, row); }
                },
                {
                    'targets': 7,
                    'render': function (data, type, row) { return renderNameCell(data, type, row); }
                },
                {
                    'targets': 8,
                    'render': function (data, type, row) { return renderContactCell(data, type, row); }
                },
                {
                    'targets': 10,
                    'render': function (data, type, row) { return renderTrainInfoListCell(data, type, row); }
                },
                {
                    'targets': 12,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [2] }
            ],
            columns: [
                { data: '' },
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'applyStatus'},
                { data: 'grade'},
                { data: 'applicationField'},
                { data: 'id'},
                { data: 'name'},
                { data: 'contact'},
                { data: 'ageGroup'},
                { data: 'trainInfoList'},
                { data: 'initRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderTrainInfoListCell(data, type, row){
        let renderHTML = 'X';
        let trainInfoList = row.trainInfoList;
        if(nvl(trainInfoList,'') !== ''){
            renderHTML = 'O';
        }

        return renderHTML;
    }

    function renderNameCell(data, type, row){
        let renderHTML = '';

        let name = row.name;
        let nameEn = row.nameEn;
        if(nvl(name, '') !== ''){
            renderHTML = name;
        }else{
            renderHTML = '-';
        }
        renderHTML += '<br>';
        if(nvl(nameEn, '') !== ''){
            renderHTML += nameEn;
        }else{
            renderHTML += '-';
        }

        return renderHTML;
    }

    function renderIdCell(data, type, row){
        let renderHTML = '';

        let id = row.id;
        if(nvl(id, '') !== ''){
            renderHTML = id;
        }else{
            renderHTML = '-';
        }

        return renderHTML;
    }

    function renderGradeCell(data, type, row){
        let renderHTML = '';

        let grade = row.grade;
        if(nvl(grade, '') !== ''){
            renderHTML = grade;
        }else{
            renderHTML = '-';
        }

        return renderHTML;
    }

    function renderApplyStatusCell(data, type, row) {
        let renderHTML = '-';
        let applyStatus = row.applyStatus;
        /*if(applyStatus.includes('취소')){
            renderHTML += '<div class="badge badge-light-danger fw-bold">';
        }else{
            renderHTML += '<div class="badge badge-light-primary fw-bold">';
        }

        renderHTML += applyStatus;
        renderHTML += '</div>';*/
        if(nvl(applyStatus, '') !== ''){
            renderHTML = '<div class="badge badge-light-primary fw-bold">';
            renderHTML += '상시신청';
            renderHTML += '</div>';
        }

        return renderHTML;
    }

    function renderCheckBoxCell(data, type, row){
        let renderHTML = '<div class="train_check form-check form-check-sm form-check-custom form-check-solid">' +
            '<input class="form-check-input" type="checkbox" value="'+ row.seq +'" data-value="' + row.name  + ' / ' + row.applyStatus + '"/>' +
            '</div>';
        return renderHTML;
    }

    function renderMajorCell(data, type, row){
        let renderHTML = '';

        let major = row.major;
        if(nvl(major, '') !== ''){
            renderHTML = major;
        }else{
            renderHTML = '-';
        }

        return renderHTML;
    }

    function renderContactCell(data, type, row){
        let renderHTML = '';

        let phone = row.phone;
        if(nvl(phone, '') !== ''){
            renderHTML = phone;
        }else{
            renderHTML = '-';
        }

        let email = row.email;
        if(nvl(email, '') !== ''){
            renderHTML += '<br>' + email;
        }else{
            renderHTML += '<br>' + '-';
        }

        return renderHTML;
    }

    function renderFieldCell(data, type, row){
        let renderHTML = '1순위) ';
        let firstApplicationField = row.firstApplicationField;
        if(nvl(firstApplicationField,'') !== ''){
            renderHTML += firstApplicationField;
        }else{
            renderHTML += '-';
        }
        let secondApplicationField = row.secondApplicationField;
        if(nvl(secondApplicationField,'') !== ''){
            renderHTML += '<br>2순위) ';
            renderHTML += secondApplicationField;
        }else{
            renderHTML += '<br>2순위) -';
        }
        let thirdApplicationField = row.thirdApplicationField;
        if(nvl(thirdApplicationField,'') !== ''){
            renderHTML += '<br>3순위) ';
            renderHTML += thirdApplicationField;
        }else{
            renderHTML += '<br>3순위) -';
        }
        return renderHTML;
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        renderHTML += '<div id="kt_menu_item" class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_regular_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';
        /*renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_regular_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">수정</a>';
        renderHTML += '</div>';*/
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_regular_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_customer_regular_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_customer_regular_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 1, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_customer_regular_search();
        }
    };
}();

let DTCustomerBoarder = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[1, 'desc']],
            'columnDefs': [
                { orderable: false, targets: 0 }, // Disable ordering on column 0 (checkbox)
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 0,
                    'render': function (data, type, row) { return renderCheckBoxCell(data, type, row); }
                },
                {
                    'targets': 3,
                    'render': function (data, type, row) { return renderYearCell(data, type, row); }
                },
                {
                    'targets': 4,
                    'render': function (data, type, row) { return renderNextTimeCell(data, type, row); }
                },
                {
                    'targets': 5,
                    'render': function (data, type, row) { return renderApplyStatusCell(data, type, row); }
                },
                {
                    'targets': 6,
                    'render': function (data, type, row) { return renderGradeCell(data, type, row); }
                },
                {
                    'targets': 7,
                    'render': function (data, type, row) { return renderIdCell(data, type, row); }
                },
                {
                    'targets': 8,
                    'render': function (data, type, row) { return renderNameCell(data, type, row); }
                },
                {
                    'targets': 9,
                    'render': function (data, type, row) { return renderContactCell(data, type, row); }
                },
                {
                    'targets': 12,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [2] }
            ],
            columns: [
                { data: '' },
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'year'},
                { data: 'nextTime'},
                { data: 'applyStatus'},
                { data: 'grade'},
                { data: 'id'},
                { data: 'name'},
                { data: 'contact'},
                { data: 'jobSupportGbn'},
                { data: 'initRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderYearCell(data, type, row) {
        let renderHTML = '-';
        let year = row.trainStartDttm;
        if(nvl(year,'') !== ''){
            renderHTML = year.toString().substring(0, year.toString().indexOf('.'));
        }

        return renderHTML;
    }

    function renderNextTimeCell(data, type, row) {
        let renderHTML = '-';
        let nextTime = row.nextTime;
        if(nvl(nextTime,'') !== ''){
            renderHTML = nextTime + '차';
        }

        return renderHTML;
    }

    function renderGradeCell(data, type, row) {
        let renderHTML = '-';
        let grade = row.grade;
        if(nvl(grade,'') !== ''){
            renderHTML = grade;
        }

        return renderHTML;
    }

    function renderIdCell(data, type, row) {
        let renderHTML = '-';
        let id = row.id;
        if(nvl(id,'') !== ''){
            renderHTML = id;
        }

        return renderHTML;
    }

    function renderContactCell(data, type, row) {
        let renderHTML = '';
        let phone = row.phone;
        if(nvl(phone,'') !== ''){
            renderHTML += phone;
        }else{
            renderHTML += '-';
        }
        renderHTML += '</br>';
        let email = row.email;
        if(nvl(email,'') !== ''){
            renderHTML += email;
        }else{
            renderHTML += '-';
        }

        return renderHTML;
    }

    function renderCheckBoxCell(data, type, row){
        let renderHTML = '<div class="train_check form-check form-check-sm form-check-custom form-check-solid">' +
            '<input class="form-check-input" type="checkbox" value="'+ row.seq +'" data-value="' + row.nameKo  + ' / ' + row.applyStatus + '"/>' +
            '</div>';
        return renderHTML;
    }

    function renderApplyStatusCell(data, type, row) {
        let renderHTML = '';
        let payMethod = row.payMethod;
        let cancelGbn = row.cancelGbn;
        let applyStatus = row.applyStatus;
        if(applyStatus.includes('취소')){
            renderHTML += '<div class="badge badge-light-danger fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }else{
            renderHTML += '<div class="badge badge-light-primary fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }

        renderHTML += '<div>';
        if(nvl(payMethod,'') !== ''){
            payMethod = payMethod.toString().toLowerCase();
            if(payMethod.includes('card')){
                renderHTML += '( 카드 )';
            }else{
                renderHTML += '( 계좌 )';
            }
        }else{
            renderHTML += '( - )';
        }
        if(nvl(cancelGbn,'') !== ''){
            if(cancelGbn === 'ALL'){
                renderHTML += '<br>';
                renderHTML += '( 전액 )';
            }else{
                renderHTML += '<br>';
                renderHTML += '( 부분 )';
            }
        }else{
            renderHTML += '<br>';
            renderHTML += '( - )';
        }
        renderHTML += '</div>';

        return renderHTML;
    }

    function renderNameCell(data, type, row) {
        let renderHTML = '';
        let nameKo = row.nameKo;
        let nameEn = row.nameEn;
        if(nvl(nameKo,'') !== ''){
            renderHTML += nameKo;
        }else{
            renderHTML += '-';
        }
        if(nvl(nameEn,'') !== ''){
            renderHTML += '<br>' + nameEn;
        }else{
            renderHTML += '<br>-';
        }

        return renderHTML;
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let name = row.nameKo;
        let applyStatus = row.applyStatus;
        let nextTime = row.nextTime;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        /*renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_boarder_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';*/
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_boarder_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_boarder_train_change_modal_set(' + '\'' + seq + '\',\'' + name + '\',\'' + applyStatus + '\',\'' + nextTime + '\')" class="menu-link px-3" data-bs-target="#kt_modal_apply_edu_change">교육변경</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_boarder_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_customer_boarder_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_customer_boarder_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 1, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_customer_boarder_search();
        }
    };
}();

let DTCustomerFrp = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[1, 'desc']],
            'columnDefs': [
                { orderable: false, targets: 0 }, // Disable ordering on column 0 (checkbox)
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 0,
                    'render': function (data, type, row) { return renderCheckBoxCell(data, type, row); }
                },
                {
                    'targets': 3,
                    'render': function (data, type, row) { return renderYearCell(data, type, row); }
                },
                {
                    'targets': 4,
                    'render': function (data, type, row) { return renderNextTimeCell(data, type, row); }
                },
                {
                    'targets': 5,
                    'render': function (data, type, row) { return renderApplyStatusCell(data, type, row); }
                },
                {
                    'targets': 6,
                    'render': function (data, type, row) { return renderGradeCell(data, type, row); }
                },
                {
                    'targets': 7,
                    'render': function (data, type, row) { return renderIdCell(data, type, row); }
                },
                {
                    'targets': 8,
                    'render': function (data, type, row) { return renderNameCell(data, type, row); }
                },
                {
                    'targets': 9,
                    'render': function (data, type, row) { return renderContactCell(data, type, row); }
                },
                {
                    'targets': 12,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [2] }
            ],
            columns: [
                { data: '' },
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'year'},
                { data: 'nextTime'},
                { data: 'applyStatus'},
                { data: 'grade'},
                { data: 'id'},
                { data: 'name'},
                { data: 'contact'},
                { data: 'jobSupportGbn'},
                { data: 'initRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderYearCell(data, type, row) {
        let renderHTML = '-';
        let year = row.trainStartDttm;
        if(nvl(year,'') !== ''){
            renderHTML = year.toString().substring(0, year.toString().indexOf('.'));
        }

        return renderHTML;
    }

    function renderNextTimeCell(data, type, row) {
        let renderHTML = '-';
        let nextTime = row.nextTime;
        if(nvl(nextTime,'') !== ''){
            renderHTML = nextTime + '차';
        }

        return renderHTML;
    }

    function renderGradeCell(data, type, row) {
        let renderHTML = '-';
        let grade = row.grade;
        if(nvl(grade,'') !== ''){
            renderHTML = grade;
        }

        return renderHTML;
    }

    function renderIdCell(data, type, row) {
        let renderHTML = '-';
        let id = row.id;
        if(nvl(id,'') !== ''){
            renderHTML = id;
        }

        return renderHTML;
    }

    function renderContactCell(data, type, row) {
        let renderHTML = '';
        let phone = row.phone;
        if(nvl(phone,'') !== ''){
            renderHTML += phone;
        }else{
            renderHTML += '-';
        }
        renderHTML += '</br>';
        let email = row.email;
        if(nvl(email,'') !== ''){
            renderHTML += email;
        }else{
            renderHTML += '-';
        }

        return renderHTML;
    }

    function renderCheckBoxCell(data, type, row){
        let renderHTML = '<div class="train_check form-check form-check-sm form-check-custom form-check-solid">' +
            '<input class="form-check-input" type="checkbox" value="'+ row.seq +'" data-value="' + row.nameKo  + ' / ' + row.applyStatus + '"/>' +
            '</div>';
        return renderHTML;
    }

    function renderApplyStatusCell(data, type, row) {
        let renderHTML = '';
        let payMethod = row.payMethod;
        let cancelGbn = row.cancelGbn;
        let applyStatus = row.applyStatus;
        if(applyStatus.includes('취소')){
            renderHTML += '<div class="badge badge-light-danger fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }else{
            renderHTML += '<div class="badge badge-light-primary fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }

        renderHTML += '<div>';
        if(nvl(payMethod,'') !== ''){
            payMethod = payMethod.toString().toLowerCase();
            if(payMethod.includes('card')){
                renderHTML += '( 카드 )';
            }else{
                renderHTML += '( 계좌 )';
            }
        }else{
            renderHTML += '( - )';
        }
        if(nvl(cancelGbn,'') !== ''){
            if(cancelGbn === 'ALL'){
                renderHTML += '<br>';
                renderHTML += '( 전액 )';
            }else{
                renderHTML += '<br>';
                renderHTML += '( 부분 )';
            }
        }else{
            renderHTML += '<br>';
            renderHTML += '( - )';
        }
        renderHTML += '</div>';

        return renderHTML;
    }

    function renderNameCell(data, type, row) {
        let renderHTML = '';
        let nameKo = row.nameKo;
        let nameEn = row.nameEn;
        if(nvl(nameKo,'') !== ''){
            renderHTML += nameKo;
        }else{
            renderHTML += '-';
        }
        if(nvl(nameEn,'') !== ''){
            renderHTML += '<br>' + nameEn;
        }else{
            renderHTML += '<br>-';
        }

        return renderHTML;
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let name = row.nameKo;
        let applyStatus = row.applyStatus;
        let nextTime = row.nextTime;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        /*renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_frp_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';*/
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_frp_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_frp_train_change_modal_set(' + '\'' + seq + '\',\'' + name + '\',\'' + applyStatus + '\',\'' + nextTime + '\')" class="menu-link px-3" data-bs-target="#kt_modal_apply_edu_change">교육변경</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_frp_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_customer_frp_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_customer_frp_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 1, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_customer_frp_search();
        }
    };
}();

let DTCustomerBasic = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[1, 'desc']],
            'columnDefs': [
                { orderable: false, targets: 0 }, // Disable ordering on column 0 (checkbox)
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 0,
                    'render': function (data, type, row) { return renderCheckBoxCell(data, type, row); }
                },
                {
                    'targets': 4,
                    'render': function (data, type, row) { return renderYearCell(data, type, row); }
                },
                {
                    'targets': 5,
                    'render': function (data, type, row) { return renderNextTimeCell(data, type, row); }
                },
                {
                    'targets': 6,
                    'render': function (data, type, row) { return renderApplyStatusCell(data, type, row); }
                },
                {
                    'targets': 7,
                    'render': function (data, type, row) { return renderGradeCell(data, type, row); }
                },
                {
                    'targets': 8,
                    'render': function (data, type, row) { return renderIdCell(data, type, row); }
                },
                {
                    'targets': 9,
                    'render': function (data, type, row) { return renderNameCell(data, type, row); }
                },
                {
                    'targets': 10,
                    'render': function (data, type, row) { return renderContactCell(data, type, row); }
                },
                {
                    'targets': 12,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [2] }
            ],
            columns: [
                { data: '' },
                { data: 'rownum' },
                { data: 'seq' },
                { data: 'boarderGbn' },
                { data: 'year' },
                { data: 'nextTime' },
                { data: 'applyStatus' },
                { data: 'grade' },
                { data: 'id' },
                { data: 'name' },
                { data: 'contact' },
                { data: 'initRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderYearCell(data, type, row) {
        let renderHTML = '-';
        let year = row.trainStartDttm;
        if(nvl(year,'') !== ''){
            renderHTML = year.toString().substring(0, year.toString().indexOf('.'));
        }

        return renderHTML;
    }

    function renderNextTimeCell(data, type, row) {
        let renderHTML = '-';
        let nextTime = row.nextTime;
        if(nvl(nextTime,'') !== ''){
            renderHTML = nextTime + '차';
        }

        return renderHTML;
    }

    function renderGradeCell(data, type, row) {
        let renderHTML = '-';
        let grade = row.grade;
        if(nvl(grade,'') !== ''){
            renderHTML = grade;
        }

        return renderHTML;
    }

    function renderIdCell(data, type, row) {
        let renderHTML = '-';
        let id = row.id;
        if(nvl(id,'') !== ''){
            renderHTML = id;
        }

        return renderHTML;
    }

    function renderContactCell(data, type, row) {
        let renderHTML = '';
        let phone = row.phone;
        if(nvl(phone,'') !== ''){
            renderHTML += phone;
        }else{
            renderHTML += '-';
        }
        renderHTML += '</br>';
        let email = row.email;
        if(nvl(email,'') !== ''){
            renderHTML += email;
        }else{
            renderHTML += '-';
        }

        return renderHTML;
    }

    function renderCheckBoxCell(data, type, row){
        let renderHTML = '<div class="train_check form-check form-check-sm form-check-custom form-check-solid">' +
            '<input class="form-check-input" type="checkbox" value="'+ row.seq +'" data-value="' + row.nameKo  + ' / ' + row.applyStatus + '"/>' +
            '</div>';
        return renderHTML;
    }

    function renderApplyStatusCell(data, type, row) {
        let renderHTML = '';
        let payMethod = row.payMethod;
        let cancelGbn = row.cancelGbn;
        let applyStatus = row.applyStatus;
        if(applyStatus.includes('취소')){
            renderHTML += '<div class="badge badge-light-danger fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }else{
            renderHTML += '<div class="badge badge-light-primary fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }

        renderHTML += '<div>';
        if(nvl(payMethod,'') !== ''){
            payMethod = payMethod.toString().toLowerCase();
            if(payMethod.includes('card')){
                renderHTML += '( 카드 )';
            }else{
                renderHTML += '( 계좌 )';
            }
        }else{
            renderHTML += '( - )';
        }
        if(nvl(cancelGbn,'') !== ''){
            if(cancelGbn === 'ALL'){
                renderHTML += '<br>';
                renderHTML += '( 전액 )';
            }else{
                renderHTML += '<br>';
                renderHTML += '( 부분 )';
            }
        }else{
            renderHTML += '<br>';
            renderHTML += '( - )';
        }
        renderHTML += '</div>';

        return renderHTML;
    }

    function renderNameCell(data, type, row) {
        let renderHTML = '';
        let nameKo = row.nameKo;
        let nameEn = row.nameEn;
        if(nvl(nameKo,'') !== ''){
            renderHTML += nameKo;
        }else{
            renderHTML += '-';
        }
        if(nvl(nameEn,'') !== ''){
            renderHTML += '<br>' + nameEn;
        }else{
            renderHTML += '<br>-';
        }

        return renderHTML;
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let name = row.nameKo;
        let applyStatus = row.applyStatus;
        let nextTime = row.nextTime;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        /*renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_basic_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';*/
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_basic_modify_init_set(' + '\'' + seq + '\')" class="menu-link px-3">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_basic_train_change_modal_set(' + '\'' + seq + '\',\'' + name + '\',\'' + applyStatus + '\',\'' + nextTime + '\')" class="menu-link px-3" data-bs-target="#kt_modal_apply_edu_change">교육변경</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_basic_remove(' + '\'' + seq + '\')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_customer_basic_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_customer_basic_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 1, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_customer_basic_search();
        }
    };
}();

let DTCustomerEmergency = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[1, 'desc']],
            'columnDefs': [
                { orderable: false, targets: 0 }, // Disable ordering on column 0 (checkbox)
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 0,
                    'render': function (data, type, row) { return renderCheckBoxCell(data, type, row); }
                },
                {
                    'targets': 4,
                    'render': function (data, type, row) { return renderYearCell(data, type, row); }
                },
                {
                    'targets': 5,
                    'render': function (data, type, row) { return renderNextTimeCell(data, type, row); }
                },
                {
                    'targets': 6,
                    'render': function (data, type, row) { return renderApplyStatusCell(data, type, row); }
                },
                {
                    'targets': 7,
                    'render': function (data, type, row) { return renderGradeCell(data, type, row); }
                },
                {
                    'targets': 8,
                    'render': function (data, type, row) { return renderIdCell(data, type, row); }
                },
                {
                    'targets': 9,
                    'render': function (data, type, row) { return renderNameCell(data, type, row); }
                },
                {
                    'targets': 10,
                    'render': function (data, type, row) { return renderContactCell(data, type, row); }
                },
                {
                    'targets': 12,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [2] }
            ],
            columns: [
                { data: '' },
                { data: 'rownum' },
                { data: 'seq' },
                { data: 'boarderGbn' },
                { data: 'year' },
                { data: 'nextTime' },
                { data: 'applyStatus' },
                { data: 'grade' },
                { data: 'id' },
                { data: 'name' },
                { data: 'contact' },
                { data: 'initRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderYearCell(data, type, row) {
        let renderHTML = '-';
        let year = row.trainStartDttm;
        if(nvl(year,'') !== ''){
            renderHTML = year.toString().substring(0, year.toString().indexOf('.'));
        }

        return renderHTML;
    }

    function renderNextTimeCell(data, type, row) {
        let renderHTML = '-';
        let nextTime = row.nextTime;
        if(nvl(nextTime,'') !== ''){
            renderHTML = nextTime + '차';
        }

        return renderHTML;
    }

    function renderGradeCell(data, type, row) {
        let renderHTML = '-';
        let grade = row.grade;
        if(nvl(grade,'') !== ''){
            renderHTML = grade;
        }

        return renderHTML;
    }

    function renderIdCell(data, type, row) {
        let renderHTML = '-';
        let id = row.id;
        if(nvl(id,'') !== ''){
            renderHTML = id;
        }

        return renderHTML;
    }

    function renderContactCell(data, type, row) {
        let renderHTML = '';
        let phone = row.phone;
        if(nvl(phone,'') !== ''){
            renderHTML += phone;
        }else{
            renderHTML += '-';
        }
        renderHTML += '</br>';
        let email = row.email;
        if(nvl(email,'') !== ''){
            renderHTML += email;
        }else{
            renderHTML += '-';
        }

        return renderHTML;
    }

    function renderCheckBoxCell(data, type, row){
        let renderHTML = '<div class="train_check form-check form-check-sm form-check-custom form-check-solid">' +
            '<input class="form-check-input" type="checkbox" value="'+ row.seq +'" data-value="' + row.nameKo  + ' / ' + row.applyStatus + '"/>' +
            '</div>';
        return renderHTML;
    }

    function renderApplyStatusCell(data, type, row) {
        let renderHTML = '';
        let payMethod = row.payMethod;
        let cancelGbn = row.cancelGbn;
        let applyStatus = row.applyStatus;
        if(applyStatus.includes('취소')){
            renderHTML += '<div class="badge badge-light-danger fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }else{
            renderHTML += '<div class="badge badge-light-primary fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }

        renderHTML += '<div>';
        if(nvl(payMethod,'') !== ''){
            payMethod = payMethod.toString().toLowerCase();
            if(payMethod.includes('card')){
                renderHTML += '( 카드 )';
            }else{
                renderHTML += '( 계좌 )';
            }
        }else{
            renderHTML += '( - )';
        }
        if(nvl(cancelGbn,'') !== ''){
            if(cancelGbn === 'ALL'){
                renderHTML += '<br>';
                renderHTML += '( 전액 )';
            }else{
                renderHTML += '<br>';
                renderHTML += '( 부분 )';
            }
        }else{
            renderHTML += '<br>';
            renderHTML += '( - )';
        }
        renderHTML += '</div>';

        return renderHTML;
    }

    function renderNameCell(data, type, row) {
        let renderHTML = '';
        let nameKo = row.nameKo;
        let nameEn = row.nameEn;
        if(nvl(nameKo,'') !== ''){
            renderHTML += nameKo;
        }else{
            renderHTML += '-';
        }
        if(nvl(nameEn,'') !== ''){
            renderHTML += '<br>' + nameEn;
        }else{
            renderHTML += '<br>-';
        }

        return renderHTML;
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let name = row.nameKo;
        let applyStatus = row.applyStatus;
        let nextTime = row.nextTime;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        /*renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_emergency_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';*/
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_emergency_modify_init_set(' + '\'' + seq + '\')" class="menu-link px-3">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_emergency_train_change_modal_set(' + '\'' + seq + '\',\'' + name + '\',\'' + applyStatus + '\',\'' + nextTime + '\')" class="menu-link px-3" data-bs-target="#kt_modal_apply_edu_change">교육변경</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_emergency_remove(' + '\'' + seq + '\')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_customer_emergency_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_customer_emergency_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 1, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_customer_emergency_search();
        }
    };
}();

let DTCustomerOutboarder = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[1, 'desc']],
            'columnDefs': [
                { orderable: false, targets: 0 }, // Disable ordering on column 0 (checkbox)
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 0,
                    'render': function (data, type, row) { return renderCheckBoxCell(data, type, row); }
                },
                {
                    'targets': 3,
                    'render': function (data, type, row) { return renderYearCell(data, type, row); }
                },
                {
                    'targets': 4,
                    'render': function (data, type, row) { return renderNextTimeCell(data, type, row); }
                },
                {
                    'targets': 5,
                    'render': function (data, type, row) { return renderApplyStatusCell(data, type, row); }
                },
                {
                    'targets': 6,
                    'render': function (data, type, row) { return renderGradeCell(data, type, row); }
                },
                {
                    'targets': 7,
                    'render': function (data, type, row) { return renderIdCell(data, type, row); }
                },
                {
                    'targets': 8,
                    'render': function (data, type, row) { return renderNameCell(data, type, row); }
                },
                {
                    'targets': 9,
                    'render': function (data, type, row) { return renderContactCell(data, type, row); }
                },
                {
                    'targets': 11,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [2] }
            ],
            columns: [
                { data: '' },
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'year'},
                { data: 'nextTime'},
                { data: 'applyStatus'},
                { data: 'grade'},
                { data: 'id'},
                { data: 'name'},
                { data: 'contact'},
                { data: 'initRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderYearCell(data, type, row) {
        let renderHTML = '-';
        let year = row.trainStartDttm;
        if(nvl(year,'') !== ''){
            renderHTML = year.toString().substring(0, year.toString().indexOf('.'));
        }

        return renderHTML;
    }

    function renderNextTimeCell(data, type, row) {
        let renderHTML = '-';
        let nextTime = row.nextTime;
        if(nvl(nextTime,'') !== ''){
            renderHTML = nextTime + '차';
        }

        return renderHTML;
    }

    function renderGradeCell(data, type, row) {
        let renderHTML = '-';
        let grade = row.grade;
        if(nvl(grade,'') !== ''){
            renderHTML = grade;
        }

        return renderHTML;
    }

    function renderIdCell(data, type, row) {
        let renderHTML = '-';
        let id = row.id;
        if(nvl(id,'') !== ''){
            renderHTML = id;
        }

        return renderHTML;
    }

    function renderContactCell(data, type, row) {
        let renderHTML = '';
        let phone = row.phone;
        if(nvl(phone,'') !== ''){
            renderHTML += phone;
        }else{
            renderHTML += '-';
        }
        renderHTML += '</br>';
        let email = row.email;
        if(nvl(email,'') !== ''){
            renderHTML += email;
        }else{
            renderHTML += '-';
        }

        return renderHTML;
    }

    function renderCheckBoxCell(data, type, row){
        let renderHTML = '<div class="train_check form-check form-check-sm form-check-custom form-check-solid">' +
            '<input class="form-check-input" type="checkbox" value="'+ row.seq +'" data-value="' + row.nameKo  + ' / ' + row.applyStatus + '"/>' +
            '</div>';
        return renderHTML;
    }

    function renderApplyStatusCell(data, type, row) {
        let renderHTML = '';
        let payMethod = row.payMethod;
        let cancelGbn = row.cancelGbn;
        let applyStatus = row.applyStatus;
        if(applyStatus.includes('취소')){
            renderHTML += '<div class="badge badge-light-danger fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }else{
            renderHTML += '<div class="badge badge-light-primary fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }

        renderHTML += '<div>';
        if(nvl(payMethod,'') !== ''){
            payMethod = payMethod.toString().toLowerCase();
            if(payMethod.includes('card')){
                renderHTML += '( 카드 )';
            }else{
                renderHTML += '( 계좌 )';
            }
        }else{
            renderHTML += '( - )';
        }
        if(nvl(cancelGbn,'') !== ''){
            if(cancelGbn === 'ALL'){
                renderHTML += '<br>';
                renderHTML += '( 전액 )';
            }else{
                renderHTML += '<br>';
                renderHTML += '( 부분 )';
            }
        }else{
            renderHTML += '<br>';
            renderHTML += '( - )';
        }
        renderHTML += '</div>';

        return renderHTML;
    }

    function renderNameCell(data, type, row) {
        let renderHTML = '';
        let nameKo = row.nameKo;
        let nameEn = row.nameEn;
        if(nvl(nameKo,'') !== ''){
            renderHTML += nameKo;
        }else{
            renderHTML += '-';
        }
        if(nvl(nameEn,'') !== ''){
            renderHTML += '<br>' + nameEn;
        }else{
            renderHTML += '<br>-';
        }

        return renderHTML;
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let name = row.nameKo;
        let applyStatus = row.applyStatus;
        let nextTime = row.nextTime;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        /*renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_outboarder_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';*/
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_outboarder_modify_init_set(' + '\'' + seq + '\')" class="menu-link px-3">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_outboarder_train_change_modal_set(' + '\'' + seq + '\',\'' + name + '\',\'' + applyStatus + '\',\'' + nextTime + '\')" class="menu-link px-3" data-bs-target="#kt_modal_apply_edu_change">교육변경</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_outboarder_remove(' + '\'' + seq + '\')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_customer_outboarder_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_customer_outboarder_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 1, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_customer_outboarder_search();
        }
    };
}();

let DTCustomerInboarder = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[1, 'desc']],
            'columnDefs': [
                { orderable: false, targets: 0 }, // Disable ordering on column 0 (checkbox)
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 0,
                    'render': function (data, type, row) { return renderCheckBoxCell(data, type, row); }
                },
                {
                    'targets': 3,
                    'render': function (data, type, row) { return renderYearCell(data, type, row); }
                },
                {
                    'targets': 4,
                    'render': function (data, type, row) { return renderNextTimeCell(data, type, row); }
                },
                {
                    'targets': 5,
                    'render': function (data, type, row) { return renderApplyStatusCell(data, type, row); }
                },
                {
                    'targets': 6,
                    'render': function (data, type, row) { return renderGradeCell(data, type, row); }
                },
                {
                    'targets': 7,
                    'render': function (data, type, row) { return renderIdCell(data, type, row); }
                },
                {
                    'targets': 8,
                    'render': function (data, type, row) { return renderNameCell(data, type, row); }
                },
                {
                    'targets': 9,
                    'render': function (data, type, row) { return renderContactCell(data, type, row); }
                },
                {
                    'targets': 11,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [2] }
            ],
            columns: [
                { data: '' },
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'year'},
                { data: 'nextTime'},
                { data: 'applyStatus'},
                { data: 'grade'},
                { data: 'id'},
                { data: 'name'},
                { data: 'contact'},
                { data: 'initRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderYearCell(data, type, row) {
        let renderHTML = '-';
        let year = row.trainStartDttm;
        if(nvl(year,'') !== ''){
            renderHTML = year.toString().substring(0, year.toString().indexOf('.'));
        }

        return renderHTML;
    }

    function renderNextTimeCell(data, type, row) {
        let renderHTML = '-';
        let nextTime = row.nextTime;
        if(nvl(nextTime,'') !== ''){
            renderHTML = nextTime + '차';
        }

        return renderHTML;
    }

    function renderGradeCell(data, type, row) {
        let renderHTML = '-';
        let grade = row.grade;
        if(nvl(grade,'') !== ''){
            renderHTML = grade;
        }

        return renderHTML;
    }

    function renderIdCell(data, type, row) {
        let renderHTML = '-';
        let id = row.id;
        if(nvl(id,'') !== ''){
            renderHTML = id;
        }

        return renderHTML;
    }

    function renderContactCell(data, type, row) {
        let renderHTML = '';
        let phone = row.phone;
        if(nvl(phone,'') !== ''){
            renderHTML += phone;
        }else{
            renderHTML += '-';
        }
        renderHTML += '</br>';
        let email = row.email;
        if(nvl(email,'') !== ''){
            renderHTML += email;
        }else{
            renderHTML += '-';
        }

        return renderHTML;
    }

    function renderCheckBoxCell(data, type, row){
        let renderHTML = '<div class="train_check form-check form-check-sm form-check-custom form-check-solid">' +
            '<input class="form-check-input" type="checkbox" value="'+ row.seq +'" data-value="' + row.nameKo  + ' / ' + row.applyStatus + '"/>' +
            '</div>';
        return renderHTML;
    }

    function renderApplyStatusCell(data, type, row) {
        let renderHTML = '';
        let payMethod = row.payMethod;
        let cancelGbn = row.cancelGbn;
        let applyStatus = row.applyStatus;
        if(applyStatus.includes('취소')){
            renderHTML += '<div class="badge badge-light-danger fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }else{
            renderHTML += '<div class="badge badge-light-primary fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }

        renderHTML += '<div>';
        if(nvl(payMethod,'') !== ''){
            payMethod = payMethod.toString().toLowerCase();
            if(payMethod.includes('card')){
                renderHTML += '( 카드 )';
            }else{
                renderHTML += '( 계좌 )';
            }
        }else{
            renderHTML += '( - )';
        }
        if(nvl(cancelGbn,'') !== ''){
            if(cancelGbn === 'ALL'){
                renderHTML += '<br>';
                renderHTML += '( 전액 )';
            }else{
                renderHTML += '<br>';
                renderHTML += '( 부분 )';
            }
        }else{
            renderHTML += '<br>';
            renderHTML += '( - )';
        }
        renderHTML += '</div>';

        return renderHTML;
    }

    function renderNameCell(data, type, row) {
        let renderHTML = '';
        let nameKo = row.nameKo;
        let nameEn = row.nameEn;
        if(nvl(nameKo,'') !== ''){
            renderHTML += nameKo;
        }else{
            renderHTML += '-';
        }
        if(nvl(nameEn,'') !== ''){
            renderHTML += '<br>' + nameEn;
        }else{
            renderHTML += '<br>-';
        }

        return renderHTML;
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let name = row.nameKo;
        let applyStatus = row.applyStatus;
        let nextTime = row.nextTime;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        /*renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_inboarder_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';*/
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_inboarder_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_inboarder_train_change_modal_set(' + '\'' + seq + '\',\'' + name + '\',\'' + applyStatus + '\',\'' + nextTime + '\')" class="menu-link px-3" data-bs-target="#kt_modal_apply_edu_change">교육변경</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_inboarder_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_customer_inboarder_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_customer_inboarder_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 1, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_customer_inboarder_search();
        }
    };
}();

let DTCustomerSailyacht = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[1, 'desc']],
            'columnDefs': [
                { orderable: false, targets: 0 }, // Disable ordering on column 0 (checkbox)
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 0,
                    'render': function (data, type, row) { return renderCheckBoxCell(data, type, row); }
                },
                {
                    'targets': 3,
                    'render': function (data, type, row) { return renderYearCell(data, type, row); }
                },
                {
                    'targets': 4,
                    'render': function (data, type, row) { return renderNextTimeCell(data, type, row); }
                },
                {
                    'targets': 5,
                    'render': function (data, type, row) { return renderApplyStatusCell(data, type, row); }
                },
                {
                    'targets': 6,
                    'render': function (data, type, row) { return renderGradeCell(data, type, row); }
                },
                {
                    'targets': 7,
                    'render': function (data, type, row) { return renderIdCell(data, type, row); }
                },
                {
                    'targets': 8,
                    'render': function (data, type, row) { return renderNameCell(data, type, row); }
                },
                {
                    'targets': 9,
                    'render': function (data, type, row) { return renderContactCell(data, type, row); }
                },
                {
                    'targets': 11,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [2] }
            ],
            columns: [
                { data: '' },
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'year'},
                { data: 'nextTime'},
                { data: 'applyStatus'},
                { data: 'grade'},
                { data: 'id'},
                { data: 'name'},
                { data: 'contact'},
                { data: 'initRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderYearCell(data, type, row) {
        let renderHTML = '-';
        let year = row.trainStartDttm;
        if(nvl(year,'') !== ''){
            renderHTML = year.toString().substring(0, year.toString().indexOf('.'));
        }

        return renderHTML;
    }

    function renderNextTimeCell(data, type, row) {
        let renderHTML = '-';
        let nextTime = row.nextTime;
        if(nvl(nextTime,'') !== ''){
            renderHTML = nextTime + '차';
        }

        return renderHTML;
    }

    function renderGradeCell(data, type, row) {
        let renderHTML = '-';
        let grade = row.grade;
        if(nvl(grade,'') !== ''){
            renderHTML = grade;
        }

        return renderHTML;
    }

    function renderIdCell(data, type, row) {
        let renderHTML = '-';
        let id = row.id;
        if(nvl(id,'') !== ''){
            renderHTML = id;
        }

        return renderHTML;
    }

    function renderContactCell(data, type, row) {
        let renderHTML = '';
        let phone = row.phone;
        if(nvl(phone,'') !== ''){
            renderHTML += phone;
        }else{
            renderHTML += '-';
        }
        renderHTML += '</br>';
        let email = row.email;
        if(nvl(email,'') !== ''){
            renderHTML += email;
        }else{
            renderHTML += '-';
        }

        return renderHTML;
    }

    function renderCheckBoxCell(data, type, row){
        let renderHTML = '<div class="train_check form-check form-check-sm form-check-custom form-check-solid">' +
            '<input class="form-check-input" type="checkbox" value="'+ row.seq +'" data-value="' + row.nameKo  + ' / ' + row.applyStatus + '"/>' +
            '</div>';
        return renderHTML;
    }

    function renderApplyStatusCell(data, type, row) {
        let renderHTML = '';
        let payMethod = row.payMethod;
        let cancelGbn = row.cancelGbn;
        let applyStatus = row.applyStatus;
        if(applyStatus.includes('취소')){
            renderHTML += '<div class="badge badge-light-danger fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }else{
            renderHTML += '<div class="badge badge-light-primary fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }

        renderHTML += '<div>';
        if(nvl(payMethod,'') !== ''){
            payMethod = payMethod.toString().toLowerCase();
            if(payMethod.includes('card')){
                renderHTML += '( 카드 )';
            }else{
                renderHTML += '( 계좌 )';
            }
        }else{
            renderHTML += '( - )';
        }
        if(nvl(cancelGbn,'') !== ''){
            if(cancelGbn === 'ALL'){
                renderHTML += '<br>';
                renderHTML += '( 전액 )';
            }else{
                renderHTML += '<br>';
                renderHTML += '( 부분 )';
            }
        }else{
            renderHTML += '<br>';
            renderHTML += '( - )';
        }
        renderHTML += '</div>';

        return renderHTML;
    }

    function renderNameCell(data, type, row) {
        let renderHTML = '';
        let nameKo = row.nameKo;
        let nameEn = row.nameEn;
        if(nvl(nameKo,'') !== ''){
            renderHTML += nameKo;
        }else{
            renderHTML += '-';
        }
        if(nvl(nameEn,'') !== ''){
            renderHTML += '<br>' + nameEn;
        }else{
            renderHTML += '<br>-';
        }

        return renderHTML;
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let name = row.nameKo;
        let applyStatus = row.applyStatus;
        let nextTime = row.nextTime;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        /*renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_sailyacht_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';*/
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_sailyacht_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_sailyacht_train_change_modal_set(' + '\'' + seq + '\',\'' + name + '\',\'' + applyStatus + '\',\'' + nextTime + '\')" class="menu-link px-3" data-bs-target="#kt_modal_apply_edu_change">교육변경</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_sailyacht_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_customer_sailyacht_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_customer_sailyacht_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 1, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_customer_sailyacht_search();
        }
    };
}();

let DTCustomerHighhorsepower = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[1, 'desc']],
            'columnDefs': [
                { orderable: false, targets: 0 }, // Disable ordering on column 0 (checkbox)
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 0,
                    'render': function (data, type, row) { return renderCheckBoxCell(data, type, row); }
                },
                {
                    'targets': 3,
                    'render': function (data, type, row) { return renderYearCell(data, type, row); }
                },
                {
                    'targets': 4,
                    'render': function (data, type, row) { return renderNextTimeCell(data, type, row); }
                },
                {
                    'targets': 5,
                    'render': function (data, type, row) { return renderApplyStatusCell(data, type, row); }
                },
                {
                    'targets': 6,
                    'render': function (data, type, row) { return renderGradeCell(data, type, row); }
                },
                {
                    'targets': 7,
                    'render': function (data, type, row) { return renderIdCell(data, type, row); }
                },
                {
                    'targets': 8,
                    'render': function (data, type, row) { return renderNameCell(data, type, row); }
                },
                {
                    'targets': 9,
                    'render': function (data, type, row) { return renderContactCell(data, type, row); }
                },
                {
                    'targets': 11,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [2] }
            ],
            columns: [
                { data: '' },
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'year'},
                { data: 'nextTime'},
                { data: 'applyStatus'},
                { data: 'grade'},
                { data: 'id'},
                { data: 'name'},
                { data: 'contact'},
                { data: 'initRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderYearCell(data, type, row) {
        let renderHTML = '-';
        let year = row.trainStartDttm;
        if(nvl(year,'') !== ''){
            renderHTML = year.toString().substring(0, year.toString().indexOf('.'));
        }

        return renderHTML;
    }

    function renderNextTimeCell(data, type, row) {
        let renderHTML = '-';
        let nextTime = row.nextTime;
        if(nvl(nextTime,'') !== ''){
            renderHTML = nextTime + '차';
        }

        return renderHTML;
    }

    function renderGradeCell(data, type, row) {
        let renderHTML = '-';
        let grade = row.grade;
        if(nvl(grade,'') !== ''){
            renderHTML = grade;
        }

        return renderHTML;
    }

    function renderIdCell(data, type, row) {
        let renderHTML = '-';
        let id = row.id;
        if(nvl(id,'') !== ''){
            renderHTML = id;
        }

        return renderHTML;
    }

    function renderContactCell(data, type, row) {
        let renderHTML = '';
        let phone = row.phone;
        if(nvl(phone,'') !== ''){
            renderHTML += phone;
        }else{
            renderHTML += '-';
        }
        renderHTML += '</br>';
        let email = row.email;
        if(nvl(email,'') !== ''){
            renderHTML += email;
        }else{
            renderHTML += '-';
        }

        return renderHTML;
    }

    function renderCheckBoxCell(data, type, row){
        let renderHTML = '<div class="train_check form-check form-check-sm form-check-custom form-check-solid">' +
            '<input class="form-check-input" type="checkbox" value="'+ row.seq +'" data-value="' + row.nameKo  + ' / ' + row.applyStatus + '"/>' +
            '</div>';
        return renderHTML;
    }

    function renderApplyStatusCell(data, type, row) {
        let renderHTML = '';
        let payMethod = row.payMethod;
        let cancelGbn = row.cancelGbn;
        let applyStatus = row.applyStatus;
        if(applyStatus.includes('취소')){
            renderHTML += '<div class="badge badge-light-danger fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }else{
            renderHTML += '<div class="badge badge-light-primary fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }

        renderHTML += '<div>';
        if(nvl(payMethod,'') !== ''){
            payMethod = payMethod.toString().toLowerCase();
            if(payMethod.includes('card')){
                renderHTML += '( 카드 )';
            }else{
                renderHTML += '( 계좌 )';
            }
        }else{
            renderHTML += '( - )';
        }
        if(nvl(cancelGbn,'') !== ''){
            if(cancelGbn === 'ALL'){
                renderHTML += '<br>';
                renderHTML += '( 전액 )';
            }else{
                renderHTML += '<br>';
                renderHTML += '( 부분 )';
            }
        }else{
            renderHTML += '<br>';
            renderHTML += '( - )';
        }
        renderHTML += '</div>';

        return renderHTML;
    }

    function renderNameCell(data, type, row) {
        let renderHTML = '';
        let nameKo = row.nameKo;
        let nameEn = row.nameEn;
        if(nvl(nameKo,'') !== ''){
            renderHTML += nameKo;
        }else{
            renderHTML += '-';
        }
        if(nvl(nameEn,'') !== ''){
            renderHTML += '<br>' + nameEn;
        }else{
            renderHTML += '<br>-';
        }

        return renderHTML;
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let name = row.nameKo;
        let applyStatus = row.applyStatus;
        let nextTime = row.nextTime;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        /*renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_highhorsepower_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';*/
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_highhorsepower_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_highhorsepower_train_change_modal_set(' + '\'' + seq + '\',\'' + name + '\',\'' + applyStatus + '\',\'' + nextTime + '\')" class="menu-link px-3" data-bs-target="#kt_modal_apply_edu_change">교육변경</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_highhorsepower_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_customer_highhorsepower_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_customer_highhorsepower_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 1, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_customer_highhorsepower_search();
        }
    };
}();

let DTCustomerHighself = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[1, 'desc']],
            'columnDefs': [
                { orderable: false, targets: 0 }, // Disable ordering on column 0 (checkbox)
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 0,
                    'render': function (data, type, row) { return renderCheckBoxCell(data, type, row); }
                },
                {
                    'targets': 3,
                    'render': function (data, type, row) { return renderYearCell(data, type, row); }
                },
                {
                    'targets': 4,
                    'render': function (data, type, row) { return renderNextTimeCell(data, type, row); }
                },
                {
                    'targets': 5,
                    'render': function (data, type, row) { return renderApplyStatusCell(data, type, row); }
                },
                {
                    'targets': 6,
                    'render': function (data, type, row) { return renderGradeCell(data, type, row); }
                },
                {
                    'targets': 7,
                    'render': function (data, type, row) { return renderIdCell(data, type, row); }
                },
                {
                    'targets': 8,
                    'render': function (data, type, row) { return renderNameCell(data, type, row); }
                },
                {
                    'targets': 9,
                    'render': function (data, type, row) { return renderContactCell(data, type, row); }
                },
                {
                    'targets': 11,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [2] }
            ],
            columns: [
                { data: '' },
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'year'},
                { data: 'nextTime'},
                { data: 'applyStatus'},
                { data: 'grade'},
                { data: 'id'},
                { data: 'name'},
                { data: 'contact'},
                { data: 'initRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderYearCell(data, type, row) {
        let renderHTML = '-';
        let year = row.trainStartDttm;
        if(nvl(year,'') !== ''){
            renderHTML = year.toString().substring(0, year.toString().indexOf('.'));
        }

        return renderHTML;
    }

    function renderNextTimeCell(data, type, row) {
        let renderHTML = '-';
        let nextTime = row.nextTime;
        if(nvl(nextTime,'') !== ''){
            renderHTML = nextTime + '차';
        }

        return renderHTML;
    }

    function renderGradeCell(data, type, row) {
        let renderHTML = '-';
        let grade = row.grade;
        if(nvl(grade,'') !== ''){
            renderHTML = grade;
        }

        return renderHTML;
    }

    function renderIdCell(data, type, row) {
        let renderHTML = '-';
        let id = row.id;
        if(nvl(id,'') !== ''){
            renderHTML = id;
        }

        return renderHTML;
    }

    function renderContactCell(data, type, row) {
        let renderHTML = '';
        let phone = row.phone;
        if(nvl(phone,'') !== ''){
            renderHTML += phone;
        }else{
            renderHTML += '-';
        }
        renderHTML += '</br>';
        let email = row.email;
        if(nvl(email,'') !== ''){
            renderHTML += email;
        }else{
            renderHTML += '-';
        }

        return renderHTML;
    }

    function renderCheckBoxCell(data, type, row){
        let renderHTML = '<div class="train_check form-check form-check-sm form-check-custom form-check-solid">' +
            '<input class="form-check-input" type="checkbox" value="'+ row.seq +'" data-value="' + row.nameKo  + ' / ' + row.applyStatus + '"/>' +
            '</div>';
        return renderHTML;
    }

    function renderApplyStatusCell(data, type, row) {
        let renderHTML = '';
        let payMethod = row.payMethod;
        let cancelGbn = row.cancelGbn;
        let applyStatus = row.applyStatus;
        if(applyStatus.includes('취소')){
            renderHTML += '<div class="badge badge-light-danger fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }else{
            renderHTML += '<div class="badge badge-light-primary fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }

        renderHTML += '<div>';
        if(nvl(payMethod,'') !== ''){
            payMethod = payMethod.toString().toLowerCase();
            if(payMethod.includes('card')){
                renderHTML += '( 카드 )';
            }else{
                renderHTML += '( 계좌 )';
            }
        }else{
            renderHTML += '( - )';
        }
        if(nvl(cancelGbn,'') !== ''){
            if(cancelGbn === 'ALL'){
                renderHTML += '<br>';
                renderHTML += '( 전액 )';
            }else{
                renderHTML += '<br>';
                renderHTML += '( 부분 )';
            }
        }else{
            renderHTML += '<br>';
            renderHTML += '( - )';
        }
        renderHTML += '</div>';

        return renderHTML;
    }

    function renderNameCell(data, type, row) {
        let renderHTML = '';
        let nameKo = row.nameKo;
        let nameEn = row.nameEn;
        if(nvl(nameKo,'') !== ''){
            renderHTML += nameKo;
        }else{
            renderHTML += '-';
        }
        if(nvl(nameEn,'') !== ''){
            renderHTML += '<br>' + nameEn;
        }else{
            renderHTML += '<br>-';
        }

        return renderHTML;
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let name = row.nameKo;
        let applyStatus = row.applyStatus;
        let nextTime = row.nextTime;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        /*renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_highself_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';*/
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_highself_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_highself_train_change_modal_set(' + '\'' + seq + '\',\'' + name + '\',\'' + applyStatus + '\',\'' + nextTime + '\')" class="menu-link px-3" data-bs-target="#kt_modal_apply_edu_change">교육변경</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_highself_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_customer_highself_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_customer_highself_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 1, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_customer_highself_search();
        }
    };
}();

let DTCustomerHighspecial = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[1, 'desc']],
            'columnDefs': [
                { orderable: false, targets: 0 }, // Disable ordering on column 0 (checkbox)
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 0,
                    'render': function (data, type, row) { return renderCheckBoxCell(data, type, row); }
                },
                {
                    'targets': 3,
                    'render': function (data, type, row) { return renderYearCell(data, type, row); }
                },
                {
                    'targets': 4,
                    'render': function (data, type, row) { return renderNextTimeCell(data, type, row); }
                },
                {
                    'targets': 5,
                    'render': function (data, type, row) { return renderApplyStatusCell(data, type, row); }
                },
                {
                    'targets': 6,
                    'render': function (data, type, row) { return renderGradeCell(data, type, row); }
                },
                {
                    'targets': 7,
                    'render': function (data, type, row) { return renderIdCell(data, type, row); }
                },
                {
                    'targets': 8,
                    'render': function (data, type, row) { return renderNameCell(data, type, row); }
                },
                {
                    'targets': 9,
                    'render': function (data, type, row) { return renderContactCell(data, type, row); }
                },
                {
                    'targets': 11,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [2] }
            ],
            columns: [
                { data: '' },
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'year'},
                { data: 'nextTime'},
                { data: 'applyStatus'},
                { data: 'grade'},
                { data: 'id'},
                { data: 'name'},
                { data: 'contact'},
                { data: 'initRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderYearCell(data, type, row) {
        let renderHTML = '-';
        let year = row.trainStartDttm;
        if(nvl(year,'') !== ''){
            renderHTML = year.toString().substring(0, year.toString().indexOf('.'));
        }

        return renderHTML;
    }

    function renderNextTimeCell(data, type, row) {
        let renderHTML = '-';
        let nextTime = row.nextTime;
        if(nvl(nextTime,'') !== ''){
            renderHTML = nextTime + '차';
        }

        return renderHTML;
    }

    function renderGradeCell(data, type, row) {
        let renderHTML = '-';
        let grade = row.grade;
        if(nvl(grade,'') !== ''){
            renderHTML = grade;
        }

        return renderHTML;
    }

    function renderIdCell(data, type, row) {
        let renderHTML = '-';
        let id = row.id;
        if(nvl(id,'') !== ''){
            renderHTML = id;
        }

        return renderHTML;
    }

    function renderContactCell(data, type, row) {
        let renderHTML = '';
        let phone = row.phone;
        if(nvl(phone,'') !== ''){
            renderHTML += phone;
        }else{
            renderHTML += '-';
        }
        renderHTML += '</br>';
        let email = row.email;
        if(nvl(email,'') !== ''){
            renderHTML += email;
        }else{
            renderHTML += '-';
        }

        return renderHTML;
    }

    function renderCheckBoxCell(data, type, row){
        let renderHTML = '<div class="train_check form-check form-check-sm form-check-custom form-check-solid">' +
            '<input class="form-check-input" type="checkbox" value="'+ row.seq +'" data-value="' + row.nameKo  + ' / ' + row.applyStatus + '"/>' +
            '</div>';
        return renderHTML;
    }

    function renderApplyStatusCell(data, type, row) {
        let renderHTML = '';
        let payMethod = row.payMethod;
        let cancelGbn = row.cancelGbn;
        let applyStatus = row.applyStatus;
        if(applyStatus.includes('취소')){
            renderHTML += '<div class="badge badge-light-danger fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }else{
            renderHTML += '<div class="badge badge-light-primary fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }

        renderHTML += '<div>';
        if(nvl(payMethod,'') !== ''){
            payMethod = payMethod.toString().toLowerCase();
            if(payMethod.includes('card')){
                renderHTML += '( 카드 )';
            }else{
                renderHTML += '( 계좌 )';
            }
        }else{
            renderHTML += '( - )';
        }
        if(nvl(cancelGbn,'') !== ''){
            if(cancelGbn === 'ALL'){
                renderHTML += '<br>';
                renderHTML += '( 전액 )';
            }else{
                renderHTML += '<br>';
                renderHTML += '( 부분 )';
            }
        }else{
            renderHTML += '<br>';
            renderHTML += '( - )';
        }
        renderHTML += '</div>';

        return renderHTML;
    }

    function renderNameCell(data, type, row) {
        let renderHTML = '';
        let nameKo = row.nameKo;
        let nameEn = row.nameEn;
        if(nvl(nameKo,'') !== ''){
            renderHTML += nameKo;
        }else{
            renderHTML += '-';
        }
        if(nvl(nameEn,'') !== ''){
            renderHTML += '<br>' + nameEn;
        }else{
            renderHTML += '<br>-';
        }

        return renderHTML;
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let name = row.nameKo;
        let applyStatus = row.applyStatus;
        let nextTime = row.nextTime;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        /*renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_highspecial_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';*/
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_highspecial_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_highspecial_train_change_modal_set(' + '\'' + seq + '\',\'' + name + '\',\'' + applyStatus + '\',\'' + nextTime + '\')" class="menu-link px-3" data-bs-target="#kt_modal_apply_edu_change">교육변경</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_highspecial_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_customer_highspecial_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_customer_highspecial_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 1, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_customer_highspecial_search();
        }
    };
}();

let DTCustomerSterndrive = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[1, 'desc']],
            'columnDefs': [
                { orderable: false, targets: 0 }, // Disable ordering on column 0 (checkbox)
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 0,
                    'render': function (data, type, row) { return renderCheckBoxCell(data, type, row); }
                },
                {
                    'targets': 3,
                    'render': function (data, type, row) { return renderYearCell(data, type, row); }
                },
                {
                    'targets': 4,
                    'render': function (data, type, row) { return renderNextTimeCell(data, type, row); }
                },
                {
                    'targets': 5,
                    'render': function (data, type, row) { return renderApplyStatusCell(data, type, row); }
                },
                {
                    'targets': 6,
                    'render': function (data, type, row) { return renderGradeCell(data, type, row); }
                },
                {
                    'targets': 7,
                    'render': function (data, type, row) { return renderIdCell(data, type, row); }
                },
                {
                    'targets': 8,
                    'render': function (data, type, row) { return renderNameCell(data, type, row); }
                },
                {
                    'targets': 9,
                    'render': function (data, type, row) { return renderContactCell(data, type, row); }
                },
                {
                    'targets': 11,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [2] }
            ],
            columns: [
                { data: '' },
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'year'},
                { data: 'nextTime'},
                { data: 'applyStatus'},
                { data: 'grade'},
                { data: 'id'},
                { data: 'name'},
                { data: 'contact'},
                { data: 'initRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderYearCell(data, type, row) {
        let renderHTML = '-';
        let year = row.trainStartDttm;
        if(nvl(year,'') !== ''){
            renderHTML = year.toString().substring(0, year.toString().indexOf('.'));
        }

        return renderHTML;
    }

    function renderNextTimeCell(data, type, row) {
        let renderHTML = '-';
        let nextTime = row.nextTime;
        if(nvl(nextTime,'') !== ''){
            renderHTML = nextTime + '차';
        }

        return renderHTML;
    }

    function renderGradeCell(data, type, row) {
        let renderHTML = '-';
        let grade = row.grade;
        if(nvl(grade,'') !== ''){
            renderHTML = grade;
        }

        return renderHTML;
    }

    function renderIdCell(data, type, row) {
        let renderHTML = '-';
        let id = row.id;
        if(nvl(id,'') !== ''){
            renderHTML = id;
        }

        return renderHTML;
    }

    function renderContactCell(data, type, row) {
        let renderHTML = '';
        let phone = row.phone;
        if(nvl(phone,'') !== ''){
            renderHTML += phone;
        }else{
            renderHTML += '-';
        }
        renderHTML += '</br>';
        let email = row.email;
        if(nvl(email,'') !== ''){
            renderHTML += email;
        }else{
            renderHTML += '-';
        }

        return renderHTML;
    }

    function renderCheckBoxCell(data, type, row){
        let renderHTML = '<div class="train_check form-check form-check-sm form-check-custom form-check-solid">' +
            '<input class="form-check-input" type="checkbox" value="'+ row.seq +'" data-value="' + row.nameKo  + ' / ' + row.applyStatus + '"/>' +
            '</div>';
        return renderHTML;
    }

    function renderApplyStatusCell(data, type, row) {
        let renderHTML = '';
        let payMethod = row.payMethod;
        let cancelGbn = row.cancelGbn;
        let applyStatus = row.applyStatus;
        if(applyStatus.includes('취소')){
            renderHTML += '<div class="badge badge-light-danger fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }else{
            renderHTML += '<div class="badge badge-light-primary fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }

        renderHTML += '<div>';
        if(nvl(payMethod,'') !== ''){
            payMethod = payMethod.toString().toLowerCase();
            if(payMethod.includes('card')){
                renderHTML += '( 카드 )';
            }else{
                renderHTML += '( 계좌 )';
            }
        }else{
            renderHTML += '( - )';
        }
        if(nvl(cancelGbn,'') !== ''){
            if(cancelGbn === 'ALL'){
                renderHTML += '<br>';
                renderHTML += '( 전액 )';
            }else{
                renderHTML += '<br>';
                renderHTML += '( 부분 )';
            }
        }else{
            renderHTML += '<br>';
            renderHTML += '( - )';
        }
        renderHTML += '</div>';

        return renderHTML;
    }

    function renderNameCell(data, type, row) {
        let renderHTML = '';
        let nameKo = row.nameKo;
        let nameEn = row.nameEn;
        if(nvl(nameKo,'') !== ''){
            renderHTML += nameKo;
        }else{
            renderHTML += '-';
        }
        if(nvl(nameEn,'') !== ''){
            renderHTML += '<br>' + nameEn;
        }else{
            renderHTML += '<br>-';
        }

        return renderHTML;
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let name = row.nameKo;
        let applyStatus = row.applyStatus;
        let nextTime = row.nextTime;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        /*renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_sterndrive_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';*/
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_sterndrive_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_sterndrive_train_change_modal_set(' + '\'' + seq + '\',\'' + name + '\',\'' + applyStatus + '\',\'' + nextTime + '\')" class="menu-link px-3" data-bs-target="#kt_modal_apply_edu_change">교육변경</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_sterndrive_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_customer_sterndrive_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_customer_sterndrive_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 1, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_customer_sterndrive_search();
        }
    };
}();

let DTCustomerSternspecial = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[1, 'desc']],
            'columnDefs': [
                { orderable: false, targets: 0 }, // Disable ordering on column 0 (checkbox)
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 0,
                    'render': function (data, type, row) { return renderCheckBoxCell(data, type, row); }
                },
                {
                    'targets': 3,
                    'render': function (data, type, row) { return renderYearCell(data, type, row); }
                },
                {
                    'targets': 4,
                    'render': function (data, type, row) { return renderNextTimeCell(data, type, row); }
                },
                {
                    'targets': 5,
                    'render': function (data, type, row) { return renderApplyStatusCell(data, type, row); }
                },
                {
                    'targets': 6,
                    'render': function (data, type, row) { return renderGradeCell(data, type, row); }
                },
                {
                    'targets': 7,
                    'render': function (data, type, row) { return renderIdCell(data, type, row); }
                },
                {
                    'targets': 8,
                    'render': function (data, type, row) { return renderNameCell(data, type, row); }
                },
                {
                    'targets': 9,
                    'render': function (data, type, row) { return renderContactCell(data, type, row); }
                },
                {
                    'targets': 11,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [2] }
            ],
            columns: [
                { data: '' },
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'year'},
                { data: 'nextTime'},
                { data: 'applyStatus'},
                { data: 'grade'},
                { data: 'id'},
                { data: 'name'},
                { data: 'contact'},
                { data: 'initRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderYearCell(data, type, row) {
        let renderHTML = '-';
        let year = row.trainStartDttm;
        if(nvl(year,'') !== ''){
            renderHTML = year.toString().substring(0, year.toString().indexOf('.'));
        }

        return renderHTML;
    }

    function renderNextTimeCell(data, type, row) {
        let renderHTML = '-';
        let nextTime = row.nextTime;
        if(nvl(nextTime,'') !== ''){
            renderHTML = nextTime + '차';
        }

        return renderHTML;
    }

    function renderGradeCell(data, type, row) {
        let renderHTML = '-';
        let grade = row.grade;
        if(nvl(grade,'') !== ''){
            renderHTML = grade;
        }

        return renderHTML;
    }

    function renderIdCell(data, type, row) {
        let renderHTML = '-';
        let id = row.id;
        if(nvl(id,'') !== ''){
            renderHTML = id;
        }

        return renderHTML;
    }

    function renderContactCell(data, type, row) {
        let renderHTML = '';
        let phone = row.phone;
        if(nvl(phone,'') !== ''){
            renderHTML += phone;
        }else{
            renderHTML += '-';
        }
        renderHTML += '</br>';
        let email = row.email;
        if(nvl(email,'') !== ''){
            renderHTML += email;
        }else{
            renderHTML += '-';
        }

        return renderHTML;
    }

    function renderCheckBoxCell(data, type, row){
        let renderHTML = '<div class="train_check form-check form-check-sm form-check-custom form-check-solid">' +
            '<input class="form-check-input" type="checkbox" value="'+ row.seq +'" data-value="' + row.nameKo  + ' / ' + row.applyStatus + '"/>' +
            '</div>';
        return renderHTML;
    }

    function renderApplyStatusCell(data, type, row) {
        let renderHTML = '';
        let payMethod = row.payMethod;
        let cancelGbn = row.cancelGbn;
        let applyStatus = row.applyStatus;
        if(applyStatus.includes('취소')){
            renderHTML += '<div class="badge badge-light-danger fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }else{
            renderHTML += '<div class="badge badge-light-primary fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }

        renderHTML += '<div>';
        if(nvl(payMethod,'') !== ''){
            payMethod = payMethod.toString().toLowerCase();
            if(payMethod.includes('card')){
                renderHTML += '( 카드 )';
            }else{
                renderHTML += '( 계좌 )';
            }
        }else{
            renderHTML += '( - )';
        }
        if(nvl(cancelGbn,'') !== ''){
            if(cancelGbn === 'ALL'){
                renderHTML += '<br>';
                renderHTML += '( 전액 )';
            }else{
                renderHTML += '<br>';
                renderHTML += '( 부분 )';
            }
        }else{
            renderHTML += '<br>';
            renderHTML += '( - )';
        }
        renderHTML += '</div>';

        return renderHTML;
    }

    function renderNameCell(data, type, row) {
        let renderHTML = '';
        let nameKo = row.nameKo;
        let nameEn = row.nameEn;
        if(nvl(nameKo,'') !== ''){
            renderHTML += nameKo;
        }else{
            renderHTML += '-';
        }
        if(nvl(nameEn,'') !== ''){
            renderHTML += '<br>' + nameEn;
        }else{
            renderHTML += '<br>-';
        }

        return renderHTML;
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let name = row.nameKo;
        let applyStatus = row.applyStatus;
        let nextTime = row.nextTime;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        /*renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_sternspecial_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';*/
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_sternspecial_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_sternspecial_train_change_modal_set(' + '\'' + seq + '\',\'' + name + '\',\'' + applyStatus + '\',\'' + nextTime + '\')" class="menu-link px-3" data-bs-target="#kt_modal_apply_edu_change">교육변경</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_sternspecial_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_customer_sternspecial_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_customer_sternspecial_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 1, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_customer_sternspecial_search();
        }
    };
}();

let DTCustomerGenerator = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[1, 'desc']],
            'columnDefs': [
                { orderable: false, targets: 0 }, // Disable ordering on column 0 (checkbox)
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 0,
                    'render': function (data, type, row) { return renderCheckBoxCell(data, type, row); }
                },
                {
                    'targets': 3,
                    'render': function (data, type, row) { return renderYearCell(data, type, row); }
                },
                {
                    'targets': 4,
                    'render': function (data, type, row) { return renderNextTimeCell(data, type, row); }
                },
                {
                    'targets': 5,
                    'render': function (data, type, row) { return renderApplyStatusCell(data, type, row); }
                },
                {
                    'targets': 6,
                    'render': function (data, type, row) { return renderGradeCell(data, type, row); }
                },
                {
                    'targets': 7,
                    'render': function (data, type, row) { return renderIdCell(data, type, row); }
                },
                {
                    'targets': 8,
                    'render': function (data, type, row) { return renderNameCell(data, type, row); }
                },
                {
                    'targets': 9,
                    'render': function (data, type, row) { return renderContactCell(data, type, row); }
                },
                {
                    'targets': 11,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [2] }
            ],
            columns: [
                { data: '' },
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'year'},
                { data: 'nextTime'},
                { data: 'applyStatus'},
                { data: 'grade'},
                { data: 'id'},
                { data: 'name'},
                { data: 'contact'},
                { data: 'initRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderYearCell(data, type, row) {
        let renderHTML = '-';
        let year = row.trainStartDttm;
        if(nvl(year,'') !== ''){
            renderHTML = year.toString().substring(0, year.toString().indexOf('.'));
        }

        return renderHTML;
    }

    function renderNextTimeCell(data, type, row) {
        let renderHTML = '-';
        let nextTime = row.nextTime;
        if(nvl(nextTime,'') !== ''){
            renderHTML = nextTime + '차';
        }

        return renderHTML;
    }

    function renderGradeCell(data, type, row) {
        let renderHTML = '-';
        let grade = row.grade;
        if(nvl(grade,'') !== ''){
            renderHTML = grade;
        }

        return renderHTML;
    }

    function renderIdCell(data, type, row) {
        let renderHTML = '-';
        let id = row.id;
        if(nvl(id,'') !== ''){
            renderHTML = id;
        }

        return renderHTML;
    }

    function renderContactCell(data, type, row) {
        let renderHTML = '';
        let phone = row.phone;
        if(nvl(phone,'') !== ''){
            renderHTML += phone;
        }else{
            renderHTML += '-';
        }
        renderHTML += '</br>';
        let email = row.email;
        if(nvl(email,'') !== ''){
            renderHTML += email;
        }else{
            renderHTML += '-';
        }

        return renderHTML;
    }

    function renderCheckBoxCell(data, type, row){
        let renderHTML = '<div class="train_check form-check form-check-sm form-check-custom form-check-solid">' +
            '<input class="form-check-input" type="checkbox" value="'+ row.seq +'" data-value="' + row.nameKo  + ' / ' + row.applyStatus + '"/>' +
            '</div>';
        return renderHTML;
    }

    function renderApplyStatusCell(data, type, row) {
        let renderHTML = '';
        let payMethod = row.payMethod;
        let cancelGbn = row.cancelGbn;
        let applyStatus = row.applyStatus;
        if(applyStatus.includes('취소')){
            renderHTML += '<div class="badge badge-light-danger fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }else{
            renderHTML += '<div class="badge badge-light-primary fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }

        renderHTML += '<div>';
        if(nvl(payMethod,'') !== ''){
            payMethod = payMethod.toString().toLowerCase();
            if(payMethod.includes('card')){
                renderHTML += '( 카드 )';
            }else{
                renderHTML += '( 계좌 )';
            }
        }else{
            renderHTML += '( - )';
        }
        if(nvl(cancelGbn,'') !== ''){
            if(cancelGbn === 'ALL'){
                renderHTML += '<br>';
                renderHTML += '( 전액 )';
            }else{
                renderHTML += '<br>';
                renderHTML += '( 부분 )';
            }
        }else{
            renderHTML += '<br>';
            renderHTML += '( - )';
        }
        renderHTML += '</div>';

        return renderHTML;
    }

    function renderNameCell(data, type, row) {
        let renderHTML = '';
        let nameKo = row.nameKo;
        let nameEn = row.nameEn;
        if(nvl(nameKo,'') !== ''){
            renderHTML += nameKo;
        }else{
            renderHTML += '-';
        }
        if(nvl(nameEn,'') !== ''){
            renderHTML += '<br>' + nameEn;
        }else{
            renderHTML += '<br>-';
        }

        return renderHTML;
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let name = row.nameKo;
        let applyStatus = row.applyStatus;
        let nextTime = row.nextTime;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        /*renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_generator_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';*/
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_generator_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_generator_train_change_modal_set(' + '\'' + seq + '\',\'' + name + '\',\'' + applyStatus + '\',\'' + nextTime + '\')" class="menu-link px-3" data-bs-target="#kt_modal_apply_edu_change">교육변경</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_generator_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_customer_generator_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_customer_generator_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 1, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_customer_generator_search();
        }
    };
}();

let DTCustomerCompetency = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[1, 'desc']],
            'columnDefs': [
                { orderable: false, targets: 0 }, // Disable ordering on column 0 (checkbox)
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 0,
                    'render': function (data, type, row) { return renderCheckBoxCell(data, type, row); }
                },
                {
                    'targets': 3,
                    'render': function (data, type, row) { return renderYearCell(data, type, row); }
                },
                {
                    'targets': 4,
                    'render': function (data, type, row) { return renderNextTimeCell(data, type, row); }
                },
                {
                    'targets': 5,
                    'render': function (data, type, row) { return renderApplyStatusCell(data, type, row); }
                },
                {
                    'targets': 6,
                    'render': function (data, type, row) { return renderGradeCell(data, type, row); }
                },
                {
                    'targets': 7,
                    'render': function (data, type, row) { return renderIdCell(data, type, row); }
                },
                {
                    'targets': 8,
                    'render': function (data, type, row) { return renderNameCell(data, type, row); }
                },
                {
                    'targets': 9,
                    'render': function (data, type, row) { return renderContactCell(data, type, row); }
                },
                {
                    'targets': 11,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [2] }
            ],
            columns: [
                { data: '' },
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'year'},
                { data: 'nextTime'},
                { data: 'applyStatus'},
                { data: 'grade'},
                { data: 'id'},
                { data: 'name'},
                { data: 'contact'},
                { data: 'initRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderYearCell(data, type, row) {
        let renderHTML = '-';
        let year = row.trainStartDttm;
        if(nvl(year,'') !== ''){
            renderHTML = year.toString().substring(0, year.toString().indexOf('.'));
        }

        return renderHTML;
    }

    function renderNextTimeCell(data, type, row) {
        let renderHTML = '-';
        let nextTime = row.nextTime;
        if(nvl(nextTime,'') !== ''){
            renderHTML = nextTime + '차';
        }

        return renderHTML;
    }

    function renderGradeCell(data, type, row) {
        let renderHTML = '-';
        let grade = row.grade;
        if(nvl(grade,'') !== ''){
            renderHTML = grade;
        }

        return renderHTML;
    }

    function renderIdCell(data, type, row) {
        let renderHTML = '-';
        let id = row.id;
        if(nvl(id,'') !== ''){
            renderHTML = id;
        }

        return renderHTML;
    }

    function renderContactCell(data, type, row) {
        let renderHTML = '';
        let phone = row.phone;
        if(nvl(phone,'') !== ''){
            renderHTML += phone;
        }else{
            renderHTML += '-';
        }
        renderHTML += '</br>';
        let email = row.email;
        if(nvl(email,'') !== ''){
            renderHTML += email;
        }else{
            renderHTML += '-';
        }

        return renderHTML;
    }

    function renderCheckBoxCell(data, type, row){
        let renderHTML = '<div class="train_check form-check form-check-sm form-check-custom form-check-solid">' +
            '<input class="form-check-input" type="checkbox" value="'+ row.seq +'" data-value="' + row.nameKo  + ' / ' + row.applyStatus + '"/>' +
            '</div>';
        return renderHTML;
    }

    function renderApplyStatusCell(data, type, row) {
        let renderHTML = '';
        let payMethod = row.payMethod;
        let cancelGbn = row.cancelGbn;
        let applyStatus = row.applyStatus;
        if(applyStatus.includes('취소')){
            renderHTML += '<div class="badge badge-light-danger fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }else{
            renderHTML += '<div class="badge badge-light-primary fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }

        renderHTML += '<div>';
        if(nvl(payMethod,'') !== ''){
            payMethod = payMethod.toString().toLowerCase();
            if(payMethod.includes('card')){
                renderHTML += '( 카드 )';
            }else{
                renderHTML += '( 계좌 )';
            }
        }else{
            renderHTML += '( - )';
        }
        if(nvl(cancelGbn,'') !== ''){
            if(cancelGbn === 'ALL'){
                renderHTML += '<br>';
                renderHTML += '( 전액 )';
            }else{
                renderHTML += '<br>';
                renderHTML += '( 부분 )';
            }
        }else{
            renderHTML += '<br>';
            renderHTML += '( - )';
        }
        renderHTML += '</div>';

        return renderHTML;
    }

    function renderNameCell(data, type, row) {
        let renderHTML = '';
        let nameKo = row.nameKo;
        let nameEn = row.nameEn;
        if(nvl(nameKo,'') !== ''){
            renderHTML += nameKo;
        }else{
            renderHTML += '-';
        }
        if(nvl(nameEn,'') !== ''){
            renderHTML += '<br>' + nameEn;
        }else{
            renderHTML += '<br>-';
        }

        return renderHTML;
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let name = row.nameKo;
        let applyStatus = row.applyStatus;
        let nextTime = row.nextTime;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        /*renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_competency_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';*/
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_competency_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_competency_train_change_modal_set(' + '\'' + seq + '\',\'' + name + '\',\'' + applyStatus + '\',\'' + nextTime + '\')" class="menu-link px-3" data-bs-target="#kt_modal_apply_edu_change">교육변경</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_competency_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_customer_competency_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_customer_competency_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 1, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_customer_competency_search();
        }
    };
}();

let DTCustomerFamtourin = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[1, 'desc']],
            'columnDefs': [
                { orderable: false, targets: 0 }, // Disable ordering on column 0 (checkbox)
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 0,
                    'render': function (data, type, row) { return renderCheckBoxCell(data, type, row); }
                },
                {
                    'targets': 3,
                    'render': function (data, type, row) { return renderYearCell(data, type, row); }
                },
                {
                    'targets': 4,
                    'render': function (data, type, row) { return renderNextTimeCell(data, type, row); }
                },
                {
                    'targets': 5,
                    'render': function (data, type, row) { return renderApplyStatusCell(data, type, row); }
                },
                {
                    'targets': 6,
                    'render': function (data, type, row) { return renderGradeCell(data, type, row); }
                },
                {
                    'targets': 7,
                    'render': function (data, type, row) { return renderIdCell(data, type, row); }
                },
                {
                    'targets': 8,
                    'render': function (data, type, row) { return renderNameCell(data, type, row); }
                },
                {
                    'targets': 9,
                    'render': function (data, type, row) { return renderContactCell(data, type, row); }
                },
                {
                    'targets': 11,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [2] }
            ],
            columns: [
                { data: '' },
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'year'},
                { data: 'nextTime'},
                { data: 'applyStatus'},
                { data: 'grade'},
                { data: 'id'},
                { data: 'name'},
                { data: 'contact'},
                { data: 'initRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderYearCell(data, type, row) {
        let renderHTML = '-';
        let year = row.trainStartDttm;
        if(nvl(year,'') !== ''){
            renderHTML = year.toString().substring(0, year.toString().indexOf('.'));
        }

        return renderHTML;
    }

    function renderNextTimeCell(data, type, row) {
        let renderHTML = '-';
        let nextTime = row.nextTime;
        if(nvl(nextTime,'') !== ''){
            renderHTML = nextTime + '차';
        }

        return renderHTML;
    }

    function renderGradeCell(data, type, row) {
        let renderHTML = '-';
        let grade = row.grade;
        if(nvl(grade,'') !== ''){
            renderHTML = grade;
        }

        return renderHTML;
    }

    function renderIdCell(data, type, row) {
        let renderHTML = '-';
        let id = row.id;
        if(nvl(id,'') !== ''){
            renderHTML = id;
        }

        return renderHTML;
    }

    function renderContactCell(data, type, row) {
        let renderHTML = '';
        let phone = row.phone;
        if(nvl(phone,'') !== ''){
            renderHTML += phone;
        }else{
            renderHTML += '-';
        }
        renderHTML += '</br>';
        let email = row.email;
        if(nvl(email,'') !== ''){
            renderHTML += email;
        }else{
            renderHTML += '-';
        }

        return renderHTML;
    }

    function renderCheckBoxCell(data, type, row){
        let renderHTML = '<div class="train_check form-check form-check-sm form-check-custom form-check-solid">' +
            '<input class="form-check-input" type="checkbox" value="'+ row.seq +'" data-value="' + row.nameKo  + ' / ' + row.applyStatus + '"/>' +
            '</div>';
        return renderHTML;
    }

    function renderApplyStatusCell(data, type, row) {
        let renderHTML = '';
        let applyStatus = row.applyStatus;
        if(applyStatus.includes('취소')){
            renderHTML += '<div class="badge badge-light-danger fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }else{
            renderHTML += '<div class="badge badge-light-primary fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }
        return renderHTML;
    }

    function renderNameCell(data, type, row) {
        let renderHTML = '';
        let nameKo = row.nameKo;
        let nameEn = row.nameEn;
        if(nvl(nameKo,'') !== ''){
            renderHTML += nameKo;
        }else{
            renderHTML += '-';
        }
        if(nvl(nameEn,'') !== ''){
            renderHTML += '<br>' + nameEn;
        }else{
            renderHTML += '<br>-';
        }

        return renderHTML;
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let name = row.nameKo;
        let applyStatus = row.applyStatus;
        let nextTime = row.nextTime;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        /*renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_famtourin_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';*/
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_famtourin_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_famtourin_train_change_modal_set(' + '\'' + seq + '\',\'' + name + '\',\'' + applyStatus + '\',\'' + nextTime + '\')" class="menu-link px-3" data-bs-target="#kt_modal_apply_edu_change">교육변경</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_famtourin_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_customer_famtourin_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_customer_famtourin_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 1, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_customer_famtourin_search();
        }
    };
}();

let DTCustomerFamtourout = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[1, 'desc']],
            'columnDefs': [
                { orderable: false, targets: 0 }, // Disable ordering on column 0 (checkbox)
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 0,
                    'render': function (data, type, row) { return renderCheckBoxCell(data, type, row); }
                },
                {
                    'targets': 3,
                    'render': function (data, type, row) { return renderYearCell(data, type, row); }
                },
                {
                    'targets': 4,
                    'render': function (data, type, row) { return renderNextTimeCell(data, type, row); }
                },
                {
                    'targets': 5,
                    'render': function (data, type, row) { return renderApplyStatusCell(data, type, row); }
                },
                {
                    'targets': 6,
                    'render': function (data, type, row) { return renderGradeCell(data, type, row); }
                },
                {
                    'targets': 7,
                    'render': function (data, type, row) { return renderIdCell(data, type, row); }
                },
                {
                    'targets': 8,
                    'render': function (data, type, row) { return renderNameCell(data, type, row); }
                },
                {
                    'targets': 9,
                    'render': function (data, type, row) { return renderContactCell(data, type, row); }
                },
                {
                    'targets': 11,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [2] }
            ],
            columns: [
                { data: '' },
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'year'},
                { data: 'nextTime'},
                { data: 'applyStatus'},
                { data: 'grade'},
                { data: 'id'},
                { data: 'name'},
                { data: 'contact'},
                { data: 'initRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderYearCell(data, type, row) {
        let renderHTML = '-';
        let year = row.trainStartDttm;
        if(nvl(year,'') !== ''){
            renderHTML = year.toString().substring(0, year.toString().indexOf('.'));
        }

        return renderHTML;
    }

    function renderNextTimeCell(data, type, row) {
        let renderHTML = '-';
        let nextTime = row.nextTime;
        if(nvl(nextTime,'') !== ''){
            renderHTML = nextTime + '차';
        }

        return renderHTML;
    }

    function renderGradeCell(data, type, row) {
        let renderHTML = '-';
        let grade = row.grade;
        if(nvl(grade,'') !== ''){
            renderHTML = grade;
        }

        return renderHTML;
    }

    function renderIdCell(data, type, row) {
        let renderHTML = '-';
        let id = row.id;
        if(nvl(id,'') !== ''){
            renderHTML = id;
        }

        return renderHTML;
    }

    function renderContactCell(data, type, row) {
        let renderHTML = '';
        let phone = row.phone;
        if(nvl(phone,'') !== ''){
            renderHTML += phone;
        }else{
            renderHTML += '-';
        }
        renderHTML += '</br>';
        let email = row.email;
        if(nvl(email,'') !== ''){
            renderHTML += email;
        }else{
            renderHTML += '-';
        }

        return renderHTML;
    }

    function renderCheckBoxCell(data, type, row){
        let renderHTML = '<div class="train_check form-check form-check-sm form-check-custom form-check-solid">' +
            '<input class="form-check-input" type="checkbox" value="'+ row.seq +'" data-value="' + row.nameKo  + ' / ' + row.applyStatus + '"/>' +
            '</div>';
        return renderHTML;
    }

    function renderApplyStatusCell(data, type, row) {
        let renderHTML = '';
        let applyStatus = row.applyStatus;
        if(applyStatus.includes('취소')){
            renderHTML += '<div class="badge badge-light-danger fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }else{
            renderHTML += '<div class="badge badge-light-primary fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }
        return renderHTML;
    }

    function renderNameCell(data, type, row) {
        let renderHTML = '';
        let nameKo = row.nameKo;
        let nameEn = row.nameEn;
        if(nvl(nameKo,'') !== ''){
            renderHTML += nameKo;
        }else{
            renderHTML += '-';
        }
        if(nvl(nameEn,'') !== ''){
            renderHTML += '<br>' + nameEn;
        }else{
            renderHTML += '<br>-';
        }

        return renderHTML;
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let name = row.nameKo;
        let applyStatus = row.applyStatus;
        let nextTime = row.nextTime;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        /*renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_famtourout_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';*/
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_famtourout_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_famtourout_train_change_modal_set(' + '\'' + seq + '\',\'' + name + '\',\'' + applyStatus + '\',\'' + nextTime + '\')" class="menu-link px-3" data-bs-target="#kt_modal_apply_edu_change">교육변경</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_famtourout_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_customer_famtourout_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_customer_famtourout_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 1, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_customer_famtourout_search();
        }
    };
}();

let DTCustomerElectro = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[1, 'desc']],
            'columnDefs': [
                { orderable: false, targets: 0 }, // Disable ordering on column 0 (checkbox)
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 0,
                    'render': function (data, type, row) { return renderCheckBoxCell(data, type, row); }
                },
                {
                    'targets': 3,
                    'render': function (data, type, row) { return renderYearCell(data, type, row); }
                },
                {
                    'targets': 4,
                    'render': function (data, type, row) { return renderNextTimeCell(data, type, row); }
                },
                {
                    'targets': 5,
                    'render': function (data, type, row) { return renderApplyStatusCell(data, type, row); }
                },
                {
                    'targets': 6,
                    'render': function (data, type, row) { return renderGradeCell(data, type, row); }
                },
                {
                    'targets': 7,
                    'render': function (data, type, row) { return renderIdCell(data, type, row); }
                },
                {
                    'targets': 8,
                    'render': function (data, type, row) { return renderNameCell(data, type, row); }
                },
                {
                    'targets': 9,
                    'render': function (data, type, row) { return renderContactCell(data, type, row); }
                },
                {
                    'targets': 11,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [2] }
            ],
            columns: [
                { data: '' },
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'year'},
                { data: 'nextTime'},
                { data: 'applyStatus'},
                { data: 'grade'},
                { data: 'id'},
                { data: 'name'},
                { data: 'contact'},
                { data: 'initRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderYearCell(data, type, row) {
        let renderHTML = '-';
        let year = row.trainStartDttm;
        if(nvl(year,'') !== ''){
            renderHTML = year.toString().substring(0, year.toString().indexOf('.'));
        }

        return renderHTML;
    }

    function renderNextTimeCell(data, type, row) {
        let renderHTML = '-';
        let nextTime = row.nextTime;
        if(nvl(nextTime,'') !== ''){
            renderHTML = nextTime + '차';
        }

        return renderHTML;
    }

    function renderGradeCell(data, type, row) {
        let renderHTML = '-';
        let grade = row.grade;
        if(nvl(grade,'') !== ''){
            renderHTML = grade;
        }

        return renderHTML;
    }

    function renderIdCell(data, type, row) {
        let renderHTML = '-';
        let id = row.id;
        if(nvl(id,'') !== ''){
            renderHTML = id;
        }

        return renderHTML;
    }

    function renderContactCell(data, type, row) {
        let renderHTML = '';
        let phone = row.phone;
        if(nvl(phone,'') !== ''){
            renderHTML += phone;
        }else{
            renderHTML += '-';
        }
        renderHTML += '</br>';
        let email = row.email;
        if(nvl(email,'') !== ''){
            renderHTML += email;
        }else{
            renderHTML += '-';
        }

        return renderHTML;
    }

    function renderCheckBoxCell(data, type, row){
        let renderHTML = '<div class="train_check form-check form-check-sm form-check-custom form-check-solid">' +
            '<input class="form-check-input" type="checkbox" value="'+ row.seq +'" data-value="' + row.nameKo  + ' / ' + row.applyStatus + '"/>' +
            '</div>';
        return renderHTML;
    }

    function renderApplyStatusCell(data, type, row) {
        let renderHTML = '';
        let applyStatus = row.applyStatus;
        if(applyStatus.includes('취소')){
            renderHTML += '<div class="badge badge-light-danger fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }else{
            renderHTML += '<div class="badge badge-light-primary fw-bold">';
            renderHTML += applyStatus;
            renderHTML += '</div>';
        }
        return renderHTML;
    }

    function renderNameCell(data, type, row) {
        let renderHTML = '';
        let nameKo = row.nameKo;
        let nameEn = row.nameEn;
        if(nvl(nameKo,'') !== ''){
            renderHTML += nameKo;
        }else{
            renderHTML += '-';
        }
        if(nvl(nameEn,'') !== ''){
            renderHTML += '<br>' + nameEn;
        }else{
            renderHTML += '<br>-';
        }

        return renderHTML;
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let name = row.nameKo;
        let applyStatus = row.applyStatus;
        let nextTime = row.nextTime;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        /*renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_electro_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';*/
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_electro_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_electro_train_change_modal_set(' + '\'' + seq + '\',\'' + name + '\',\'' + applyStatus + '\',\'' + nextTime + '\')" class="menu-link px-3" data-bs-target="#kt_modal_apply_edu_change">교육변경</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_customer_electro_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_customer_electro_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_customer_electro_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 1, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_customer_electro_search();
        }
    };
}();

let DTEducationTrain = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[0, 'desc']],
            'columnDefs': [
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 2,
                    'render': function (data, type, row) { return renderCategoryCell(data, type, row); }
                },
                {
                    'targets': 3,
                    'render': function (data, type, row) { return renderNextTimeCell(data, type, row); }
                },
                {
                    'targets': 4,
                    'render': function (data, type, row) { return renderGbnCell(data, type, row); }
                },
                {
                    'targets': 5,
                    'render': function (data, type, row) { return renderTrainScheduleCell(data, type, row); }
                },
                {
                    'targets': 6,
                    'render': function (data, type, row) { return renderApplyScheduleCell(data, type, row); }
                },
                {
                    'targets': 7,
                    'render': function (data, type, row) { return renderPaySumCell(data, type, row); }
                },
                {
                    'targets': 8,
                    'render': function (data, type, row) { return renderTrainCntCell(data, type, row); }
                },
                {
                    'targets': 9,
                    'render': function (data, type, row) { return renderStatusCell(data, type, row); }
                },
                {
                    'targets': 11,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [1] }
            ],
            columns: [
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'category'},
                { data: 'nextTime'},
                { data: 'gbn'},
                { data: 'trainSchedule'},
                { data: 'applySchedule'},
                { data: 'paySum'},
                { data: 'trainCnt'},
                { data: 'status'},
                { data: 'initRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderGbnCell(data, type, row){
        let renderHTML = row.gbn;
        let gbnDepth = row.gbnDepth;
        if(nvl(gbnDepth,'') !== ''){
            renderHTML += ' (' + gbnDepth + ')';
        }

        return renderHTML;
    }

    function renderNextTimeCell(data, type, row){
        return row.nextTime + '차';
    }

    function renderCategoryCell(data, type, row){
        let renderHTML = '';
        let category = row.category;

        if(nvl(category,'') !== ''){
            renderHTML = category.toString().replaceAll('과정','');
        }else{
            renderHTML = '-';
        }

        return renderHTML;
    }

    function renderStatusCell(data, type, row){
        let renderHTML = '';

        let date = new Date(); // Data 객체 생성
        let year = date.getFullYear().toString(); // 년도 구하기

        let month = date.getMonth() + 1; // 월 구하기
        month = month < 10 ? '0' + month.toString() : month.toString(); // 10월 미만 0 추가

        let day = date.getDate(); // 날짜 구하기
        day = day < 10 ? '0' + day.toString() : day.toString(); // 10일 미만 0 추가

        let currentDay = year + '.' + month + '.' + day;

        let trainStartDttm = row.trainStartDttm;
        let trainEndDttm = row.trainEndDttm;
        let applyStartDttm = row.applyStartDttm;
        let applyEndDttm = row.applyEndDttm;

        let trainCnt = row.trainCnt;
        let trainApplyCnt = row.trainApplyCnt;
        
        let closingYn = row.closingYn;

        if(closingYn === 'N'){
            if(trainStartDttm <= currentDay && currentDay <= trainEndDttm){
                if(applyStartDttm <= currentDay && currentDay <= applyEndDttm) {
                    if (trainCnt === trainApplyCnt) {
                        renderHTML += '<div class="badge badge-light-danger fw-bold">';
                        renderHTML += '교육신청마감';
                        renderHTML += '</div>';
                    } else {
                        renderHTML += '<div class="badge badge-light-primary fw-bold">';
                        renderHTML += '교육진행중';
                        renderHTML += '</div>';
                    }
                }else{
                    if(applyEndDttm < currentDay){
                        renderHTML += '<div class="badge badge-light-dark fw-bold">';
                        renderHTML += '접수일정종료';
                        renderHTML += '</div>';
                    }else {
                        if(applyStartDttm > currentDay){
                            renderHTML += '<div class="badge badge-light-info fw-bold">';
                            renderHTML += '접수일정대기';
                            renderHTML += '</div>';
                        }else{
                            if (trainCnt === trainApplyCnt) {
                                renderHTML += '<div class="badge badge-light-danger fw-bold">';
                                renderHTML += '접수신청마감';
                                renderHTML += '</div>';
                            } else {
                                renderHTML += '<div class="badge badge-light-primary fw-bold">';
                                renderHTML += '접수신청중';
                                renderHTML += '</div>';
                            }
                        }
                    }
                }
            }else{
                if(trainStartDttm > currentDay){
                    renderHTML += '<div class="badge badge-light-info fw-bold">';
                    renderHTML += '교육일정대기';
                    renderHTML += '</div>';
                }else{
                    if(trainEndDttm >= currentDay){
                        renderHTML += '<div class="badge badge-light-primary fw-bold">';
                        renderHTML += '교육신청중';
                        renderHTML += '</div>';
                    }else{
                        renderHTML += '<div class="badge badge-light-dark fw-bold">';
                        renderHTML += '교육일정종료';
                        renderHTML += '</div>';
                    }
                }
            }
        }else{
            renderHTML += '<div class="badge badge-light-dark fw-bold">';
            renderHTML += '교육마감';
            renderHTML += '</div>';
        }

        return renderHTML;
    }

    function renderTrainCntCell(data, type, row){
        let renderHTML = '';
        let trainCnt = row.trainCnt;
        let trainApplyCnt = row.trainApplyCnt;

        renderHTML = trainCnt + ' (' + trainApplyCnt + ')';

        return renderHTML;
    }

    function renderPaySumCell(data, type, row){
        let renderHTML = Number(row.paySum);
        return '￦ ' + renderHTML.toLocaleString();
    }

    function renderApplyScheduleCell(data, type, row){
        let renderHTML = '';
        let applyStartDttm = row.applyStartDttm;
        let applyEndDttm = row.applyEndDttm;

        renderHTML = applyStartDttm + ' - ' + applyEndDttm;

        return renderHTML;
    }

    function renderTrainScheduleCell(data, type, row){
        let renderHTML = '';
        let trainStartDttm = row.trainStartDttm;
        let trainEndDttm = row.trainEndDttm;

        renderHTML = trainStartDttm + ' - ' + trainEndDttm;

        return renderHTML;
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let gbn = row.gbn;
        let nextTime = row.nextTime;
        let trainApplyCnt = row.trainApplyCnt;
        let applicationSystemType = row.applicationSystemType;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        renderHTML += '<div id="kt_menu_item" class="menu-item px-3">';
        renderHTML += '<a onclick="f_education_train_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_education_train_apply_list(' + '\'' + gbn + '\'' + ',' + '\'' + nextTime + '\'' + ',' + '\'' + trainApplyCnt + '\'' + ',' + '\'' + applicationSystemType + '\'' + ')" class="menu-link px-3">신청명단보기</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_education_train_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">수정</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_education_train_early_closing(' + '\'' + seq + '\'' + ')" class="menu-link px-3">교육마감</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_education_train_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_education_train_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_education_train_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 0, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_education_train_search();
        }
    };
}();

let DTEducationPayment = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[0, 'desc']],
            'columnDefs': [
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                /*{
                    'targets': 0,
                    'render': function (data, type, row) { return renderCheckBoxCell(data, type, row); }
                },*/
                {
                    'targets': 6,
                    'render': function (data, type, row) { return renderNextTimeCell(data, type, row); }
                },
                {
                    'targets': 8,
                    'render': function (data, type, row) { return renderPaySumCell(data, type, row); }
                },
                {
                    'targets': 9,
                    'render': function (data, type, row) { return renderPayMethodCell(data, type, row); }
                },
                {
                    'targets': 10,
                    'render': function (data, type, row) { return renderStatusCell(data, type, row); }
                },
                {
                    'targets': 11,
                    'render': function (data, type, row) { return renderCancelDttmCell(data, type, row); }
                },
                {
                    'targets': 13,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [1,2,5] }
            ],
            columns: [
                /*{ data: '' },*/
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'memberSeq'},
                { data: 'memberName'},
                { data: 'memberPhone'},
                { data: 'trainSeq'},
                { data: 'nextTime'},
                { data: 'trainName'},
                { data: 'paySum'},
                { data: 'payMethod'},
                { data: 'payStatus'},
                { data: 'cancelDttm'},
                { data: 'initRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderPayMethodCell(data, type, row){
        let renderHTML = '미확인';
        let payMethod = row.payMethod;
        if(nvl(payMethod,'') !== ''){
            if(payMethod.toString().toLowerCase().includes('card')){
                renderHTML = '카드';
            }else if(payMethod.toString().toLowerCase().includes('vbank')){
                renderHTML = '가상계좌';
            }else{
                renderHTML = payMethod;
            }
        }

        return renderHTML;
    }

    function renderNextTimeCell(data, type, row){
        return row.nextTime + '차';
    }

    function renderCheckBoxCell(data, type, row){
        let renderHTML = '<div class="pay_check form-check form-check-sm form-check-custom form-check-solid">' +
            '<input class="form-check-input" type="checkbox" value="'+ row.seq +'" data-value="' + row.memberName  + ' / ' + row.trainName + '"/>' +
            '</div>';
        return renderHTML;
    }

    function renderStatusCell(data, type, row){
        let renderHTML = '';
        let payStatus = row.payStatus;
        // 결제대기
        // 결제완료
        // 수강확정
        // 수강완료
        // 환급대기
        // 환급완료
        // 취소신청
        // 취소완료

        if(nvl(payStatus,'') !== ''){
            switch (payStatus){
                case '결제대기':
                    renderHTML += '<div class="badge badge-light-secondary fw-bold">';
                    renderHTML += '결제대기';
                    renderHTML += '</div>';
                    break;
                case '결제완료':
                    renderHTML += '<div class="badge badge-light-primary fw-bold">';
                    renderHTML += '결제완료';
                    renderHTML += '</div>';
                    break;
                case '수강확정':
                    renderHTML += '<div class="badge badge-light-info fw-bold">';
                    renderHTML += '수강확정';
                    renderHTML += '</div>';
                    break;
                case '수강완료':
                    renderHTML += '<div class="badge badge-light-success fw-bold">';
                    renderHTML += '수강완료';
                    renderHTML += '</div>';
                    break;
                case '환급대기':
                    renderHTML += '<div class="badge badge-light-danger fw-bold">';
                    renderHTML += '환급대기';
                    renderHTML += '</div>';
                    break;
                case '환급완료':
                    renderHTML += '<div class="badge badge-light-dark fw-bold">';
                    renderHTML += '환급완료';
                    renderHTML += '</div>';
                    break;
                case '취소신청':
                    renderHTML += '<div class="badge badge-light-danger fw-bold">';
                    renderHTML += '취소신청';
                    renderHTML += '</div>';
                    break;
                case '취소완료':
                    renderHTML += '<div class="badge badge-light-dark fw-bold">';
                    renderHTML += '취소완료';
                    renderHTML += '</div>';
                    break;
                default:
                    renderHTML += '<div class="badge badge-light-info fw-bold">';
                    renderHTML += payStatus;
                    renderHTML += '</div>';
                    break;
            }

        }else{
            renderHTML = '-';
        }

        return renderHTML;
    }

    function renderPaySumCell(data, type, row){
        let renderHTML = Number(row.paySum);
        return '￦ ' + renderHTML.toLocaleString();
    }

    function renderCancelDttmCell(data, type, row){
        let cancelDate = row.cancelDate + row.cancelTime;
        let renderHTML = '-';
        if(nvl(cancelDate,'') !== ''){
            renderHTML = cancelDate.replace(/^(\d{4})(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)$/, '$1-$2-$3 $4:$5:$6');
        }else{
            let prtcDate = row.prtcDate + row.prtcTime;
            if(nvl(prtcDate,'') !== ''){
                renderHTML = prtcDate.replace(/^(\d{4})(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)$/, '$1-$2-$3 $4:$5:$6');
            }
        }
        return renderHTML;
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        renderHTML += '<div id="kt_menu_item" class="menu-item px-3">';
        renderHTML += '<a onclick="f_education_payment_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';
        /*renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_education_payment_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">수정</a>';
        renderHTML += '</div>';*/
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_education_payment_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_education_payment_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_education_payment_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 0, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_education_payment_search();
        }
    };
}();

let DTBoardNotice = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[0, 'desc']],
            'columnDefs': [
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 2,
                    'render': function (data) {
                        if (data === '1') {
                            return 'V'
                        } else {
                            return '-'
                        }
                    }
                },
                {
                    'targets': 8,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [1] }
            ],
            columns: [
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'noticeGbn' },
                { data: 'title' },
                { data: 'writer' },
                { data: 'writeDate' },
                { data: 'finalRegiDttm' },
                { data: 'viewCnt' },
                { data: 'actions' }
            ]
        });
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        renderHTML += '<div id="kt_menu_item" class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_notice_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_notice_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">수정</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_notice_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_board_notice_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_board_notice_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 0, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_board_notice_search();
        }
    };
}();

let DTBoardPress = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[0, 'desc']],
            'columnDefs': [
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 2,
                    'render': function (data) {
                        if (data === '1') {
                            return 'V'
                        } else {
                            return '-'
                        }
                    }
                },
                {
                    'targets': 8,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [1] }
            ],
            columns: [
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'noticeGbn' },
                { data: 'title' },
                { data: 'writer' },
                { data: 'writeDate' },
                { data: 'finalRegiDttm' },
                { data: 'viewCnt' },
                { data: 'actions' }
            ]
        });
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        renderHTML += '<div id="kt_menu_item" class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_press_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_press_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">수정</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_press_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_board_press_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_board_press_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 0, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_board_press_search();
        }
    };
}();

let DTBoardGallery = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[0, 'desc']],
            'columnDefs': [
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 7,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [1] }
            ],
            columns: [
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'title' },
                { data: 'writer' },
                { data: 'writeDate' },
                { data: 'finalRegiDttm' },
                { data: 'viewCnt' },
                { data: 'actions' }
            ]
        });
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        renderHTML += '<div id="kt_menu_item" class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_gallery_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_gallery_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">수정</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_gallery_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_board_gallery_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_board_gallery_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 0, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_board_gallery_search();
        }
    };
}();

let DTBoardMedia = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[0, 'desc']],
            'columnDefs': [
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 7,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [1] }
            ],
            columns: [
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'title' },
                { data: 'writer' },
                { data: 'writeDate' },
                { data: 'finalRegiDttm' },
                { data: 'viewCnt' },
                { data: 'actions' }
            ]
        });
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        renderHTML += '<div id="kt_menu_item" class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_media_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_media_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">수정</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_media_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_board_media_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_board_media_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 0, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_board_media_search();
        }
    };
}();

let DTBoardNewsletter = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[0, 'desc']],
            'columnDefs': [
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 2,
                    'render': function (data) {
                        if (data === '1') {
                            return 'V'
                        } else {
                            return '-'
                        }
                    }
                },
                {
                    'targets': 8,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [1] }
            ],
            columns: [
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'noticeGbn' },
                { data: 'title' },
                { data: 'writer' },
                { data: 'writeDate' },
                { data: 'finalRegiDttm' },
                { data: 'viewCnt' },
                { data: 'actions' }
            ]
        });
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        renderHTML += '<div id="kt_menu_item" class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_newsletter_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_newsletter_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">수정</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_newsletter_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_board_newsletter_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_board_newsletter_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 0, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_board_newsletter_search();
        }
    };
}();

let DTBoardAnnouncement = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[0, 'desc']],
            'columnDefs': [
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 2,
                    'render': function (data) {
                        if (data === 'KO') {
                            return '국문'
                        } else {
                            return '영문'
                        }
                    }
                },
                {
                    'targets': 3,
                    'render': function (data) {
                        if (data === '1') {
                            return 'V'
                        } else {
                            return '-'
                        }
                    }
                },
                {
                    'targets': 9,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [1] }
            ],
            columns: [
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'lang'},
                { data: 'noticeGbn' },
                { data: 'title' },
                { data: 'writer' },
                { data: 'writeDate' },
                { data: 'finalRegiDttm' },
                { data: 'viewCnt' },
                { data: 'actions' }
            ]
        });
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        renderHTML += '<div id="kt_menu_item" class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_announcement_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_announcement_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">수정</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_announcement_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_board_announcement_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_board_announcement_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 0, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_board_announcement_search();
        }
    };
}();

let DTBoardEmployment = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[0, 'desc']],
            'columnDefs': [
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 8,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [1] }
            ],
            columns: [
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'gbn' },
                { data: 'employName' },
                { data: 'employField' },
                { data: 'employAddress' },
                { data: 'initRegiDttm' },
                { data: 'finalRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        renderHTML += '<div id="kt_menu_item" class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_employment_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_employment_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">수정</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_employment_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_board_employment_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_board_employment_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 0, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_board_employment_search();
        }
    };
}();

let DTBoardJob = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[0, 'desc']],
            'columnDefs': [
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 7,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [1] }
            ],
            columns: [
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'title' },
                { data: 'writer' },
                { data: 'writeDate' },
                { data: 'finalRegiDttm' },
                { data: 'viewCnt' },
                { data: 'actions' }
            ]
        });
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        renderHTML += '<div id="kt_menu_item" class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_job_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_job_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">수정</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_job_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_board_job_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_board_job_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 0, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_board_job_search();
        }
    };
}();

let DTBoardCommunity = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[0, 'desc']],
            'columnDefs': [
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 2,
                    'render': function (data) {
                        if (data === '1') {
                            return 'V'
                        } else {
                            return '-'
                        }
                    }
                },
                {
                    'targets': 3,
                    'render': function (data, type, row) { return renderTitleCell(data, type, row); }
                },
                {
                    'targets': 8,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [1] }
            ],
            columns: [
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'gbn'},
                { data: 'title' },
                { data: 'writer' },
                { data: 'writeDate' },
                { data: 'finalRegiDttm' },
                { data: 'viewCnt' },
                { data: 'actions' }
            ]
        });
    }

    function renderTitleCell(data, type, row){
        let title = row.title;
        return title + ' [0]';
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        renderHTML += '<div id="kt_menu_item" class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_community_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_community_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">수정</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_community_reply_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_reply">댓글 정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_community_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_board_community_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_board_community_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 0, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_board_community_search();
        }
    };
}();

let DTBoardFaq = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[0, 'desc']],
            'columnDefs': [
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 7,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [1] }
            ],
            columns: [
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'exposureYn' },
                { data: 'question' },
                { data: 'writer' },
                { data: 'writeDate' },
                { data: 'finalRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        renderHTML += '<div id="kt_menu_item" class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_faq_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_faq_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">수정</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_board_faq_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_board_faq_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_board_faq_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 0, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_board_faq_search();
        }
    };
}();

let DTPopPopup = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[0, 'desc']],
            'columnDefs': [
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 8,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [1] }
            ],
            columns: [
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'useYn'},
                { data: 'title' },
                { data: 'publishedDate' },
                { data: 'expirationDate' },
                { data: 'initRegiDttm' },
                { data: 'finalRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let rowId = row.seq;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_pop_popup_modify_init_set(' + '\'' + rowId + '\'' + ')" class="menu-link px-3">수정</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_pop_popup_remove(' + '\'' + rowId + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_pop_popup_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_pop_popup_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 0, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_pop_popup_search();
        }
    };
}();

let DTPopBanner = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[0, 'desc']],
            'columnDefs': [
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 7,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [1] }
            ],
            columns: [
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'title' },
                { data: 'viewSeq' },
                { data: 'writer' },
                { data: 'initRegiDttm' },
                { data: 'finalRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let rowId = row.seq;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        renderHTML += '<div id="kt_menu_item" class="menu-item px-3">';
        renderHTML += '<a onclick="f_pop_banner_detail_modal_set(' + '\'' + rowId + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_pop_banner_modify_init_set(' + '\'' + rowId + '\'' + ')" class="menu-link px-3">수정</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_pop_banner_remove(' + '\'' + rowId + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_pop_banner_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_pop_banner_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 0, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_pop_banner_search();
        }
    };
}();

let DTNewsletterSubscriber = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[0, 'desc']],
            'columnDefs': [
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 3,
                    'render': function (data, type, row) { return renderSendYnCell(data, type, row); }
                },
                {
                    'targets': 5,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [1] }
            ],
            columns: [
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'email' },
                { data: 'sendYn' },
                { data: 'initRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderSendYnCell(data, type, row){
        let renderHTML = '동의';
        let sendYn = row.sendYn;
        if(sendYn === 'N'){
            renderHTML = '미동의';
        }

        return renderHTML;
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let rowSeq = row.seq;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_newsletter_subscriber_modify_init_set(' + '\'' + rowSeq + '\'' + ')" class="menu-link px-3">수정</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_newsletter_subscriber_remove(' + '\'' + rowSeq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_newsletter_subscriber_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_newsletter_subscriber_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 0, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_newsletter_subscriber_search();
        }
    };
}();

let DTSmsMngSms = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : true,
            'select': false,
            'ordering': true,
            'order': [[0, 'desc']],
            'columnDefs': [
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 6,
                    'render': function (data, type, row) { return renderContentCell(data, type, row); }
                },
                {
                    'targets': 7,
                    'render': function (data, type, row) { return renderSendResultCell(data, type, row); }
                },
                {
                    'targets': 9,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [1] }
            ],
            columns: [
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'smsGroup' },
                { data: 'phone' },
                { data: 'sender' },
                { data: 'senderPhone' },
                { data: 'content' },
                { data: 'sendResult' },
                { data: 'sendDate' },
                { data: 'actions' }
            ]
        });
    }

    function renderContentCell(data, type, row){
        let content = row.content;
        if(nvl(content,'') !== ''){
            if(content.length > 30){
                content = content.substring(0, 30) + '...';
            }
        }else{
            content = '-';
        }
        return content;
    }

    function renderSendResultCell(data, type, row){
        let renderHTML = '';

        let sendResult = row.sendResult;
        if(sendResult === '성공'){
            renderHTML += '<div class="badge badge-light-primary fw-bold">';
        }else{
            renderHTML += '<div class="badge badge-light-danger fw-bold">';
        }

        renderHTML += sendResult;
        renderHTML += '</div>';

        return renderHTML;
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_smsMng_sms_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">상세보기</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_smsMng_sms_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_smsMng_sms_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_smsMng_sms_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 0, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_smsMng_sms_search();
        }
    };
}();

let DTSmsMngSmsTrain = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[1, 'desc']],
            'columnDefs': [
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 0,
                    'render': function (data, type, row) { return renderCheckBoxCell(data, type, row); }
                },
                {
                    'targets': 5,
                    'render': function (data, type, row) { return renderNextTimeCell(data, type, row); }
                },
                {
                    'targets': 7,
                    'render': function (data, type, row) { return renderNameCell(data, type, row); }
                },
                { visible: false, targets: [2,3,4] },
                { orderable: false, targets: 0 } // Disable ordering on column 0 (checkbox)
            ],
            columns: [
                { data: '' },
                { data: 'rownum' },
                { data: 'tableSeq'},
                { data: 'trainSeq'},
                { data: 'memberSeq'},
                { data: 'nextTime'},
                { data: 'id'},
                { data: 'name'},
                { data: 'phone'},
                { data: 'applyStatus'}
            ]
        });
    }

    function renderNextTimeCell(data, type, row){
        return row.nextTime + '차';
    }

    function renderCheckBoxCell(data, type, row){
        let renderHTML = '<div class="form-check form-check-sm form-check-custom form-check-solid">' +
            '<input class="form-check-input sms_send_tr_check" type="checkbox" value="'+ row.phone +'" data-value="' + row.nameKo + '"/>' +
            '</div>';
        return renderHTML;
    }

    function renderNameCell(data, type, row){
        let name = row.name;
        if(nvl(name,'') === ''){
            name = '-';
        }
        return name;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#sms_send_form_train_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#sms_send_form_train_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 1, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

        }
    };
}();

let DTSmsMngSmsExcel = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            info: false,
            paging : false,
            select: false,
            ordering: true,
            dom: 't',
            order: [[1, 'desc']],
            columnDefs: [
                { orderable: false, targets: 0 }, // Disable ordering on column 0 (checkbox)
                {
                    targets: '_all',
                    className: 'text-center'
                },
                {
                    targets: 0,
                    render: function (data, type, row) { return renderCheckBoxCell(data, type, row); }
                },
                {
                    targets: 2,
                    render: function (data, type, row) { return renderNameCell(data, type, row); }
                },
            ],
            columns: [
                { data: '' },
                { data: 'rownum' },
                { data: 'name'},
                { data: 'phone'},
                { data: 'grade'},
                { data: 'trainName'}
            ]
        });

    }

    function renderCheckBoxCell(data, type, row){
        let renderHTML = '<div class="form-check form-check-sm form-check-custom form-check-solid">' +
            '<input class="form-check-input sms_send_ex_check" type="checkbox" value="'+ row.phone +'" data-value="' + row.name + '"/>' +
            '</div>';
        return renderHTML;
    }

    function renderNameCell(data, type, row){
        let name = row.name;
        if(nvl(name,'') === ''){
            name = '-';
        }
        return name;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#sms_send_form_excel_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#sms_send_form_excel_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 1, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();
        }
    };
}();

let DTFileDownload = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[0, 'desc']],
            'columnDefs': [
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 5,
                    'render': function (data, type, row) { return renderTargetMenuCell(data, type, row); }
                },
                { visible: false, targets: [1] }
            ],
            columns: [
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'downloadFileName' },
                { data: 'downloadReason' },
                { data: 'downloadUser' },
                { data: 'targetMenu' },
                { data: 'initRegiDttm' },
            ]
        });
    }

    function renderTargetMenuCell(data, type, row){
        return row.targetMenu.replaceAll('_', ' > ');
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_file_download_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_file_download_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 0, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_file_download_search();
        }
    };
}();

let DTFileTrash = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[0, 'desc']],
            'columnDefs': [
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 2,
                    'render': function (data, type, row) { return renderTargetMenuCell(data, type, row); }
                },
                {
                    'targets': 5,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [1] }
            ],
            columns: [
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'targetMenu' },
                { data: 'deleteReason' },
                { data: 'initRegiDttm' },
                { data: 'actions' },
            ]
        });
    }

    function renderTargetMenuCell(data, type, row){
        return row.targetMenu.replaceAll('_', ' > ');
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        /*renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_file_trash_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';*/
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_file_trash_restore(' + '\'' + seq + '\'' + ')" class="menu-link px-3">복구</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_file_trash_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">최종삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_file_trash_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_file_trash_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 0, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_file_trash_search();
        }
    };
}();

let DTAdminMngAdmin = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : false,
            'select': false,
            'ordering': true,
            'order': [[0, 'desc']],
            'columnDefs': [
                { orderable: false, targets: 2 }, // Disable ordering on column 2 (checkbox)
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 2,
                    'render': function (data, type, row) { return renderCheckBoxCell(data, type, row); }
                },
                {
                    'targets': 3,
                    'render': function (data, type, row) { return renderGbnCell(data, type, row); }
                },
                {
                    'targets': 5,
                    'render': function (data, type, row) { return renderNameCell(data, type, row); }
                },
                {
                    'targets': 6,
                    'render': function (data, type, row) { return renderContactCell(data, type, row); }
                },
                {
                    'targets': 11,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [1] }
            ],
            columns: [
                { data: 'rownum' },
                { data: 'seq'},
                { data: 'blockYn'},
                { data: 'gbn'},
                { data: 'id'},
                { data: 'cpName'},
                { data: 'contact'},
                { data: 'cpEmail'},
                { data: 'cpDepart'},
                { data: 'lastAccessDttm' },
                { data: 'initRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderGbnCell(data, type, row) {
        return row.gbn + ' 관리자';
    }

    function renderContactCell(data, type, row) {
        let renderHTML = '';

        let cpTel = row.cpTel;
        if(nvl(cpTel,'') !== ''){
            renderHTML += cpTel;
        }else{
            renderHTML += '-';
        }

        renderHTML += '</br>';

        let cpPhone = row.cpPhone;
        if(nvl(cpPhone,'') !== ''){
            renderHTML += cpPhone;
        }else{
            renderHTML += '-';
        }

        return renderHTML;
    }

    function renderCheckBoxCell(data, type, row){
        let blockYn = row.blockYn;
        let renderHTML = '<div class="form-check form-check-sm form-check-custom form-check-solid justify-content-center">';
        renderHTML += '<input class="form-check-input" type="checkbox" id="blockYn" name="blockYn" value="' + row.seq + '"';
        if(blockYn === 'Y'){
            renderHTML += 'checked';
        }
        renderHTML += 'disabled/>';
        renderHTML += '<label class="form-check-label" for="blockYn">';
        renderHTML += '접속차단';
        renderHTML += '</label>';
        renderHTML += '</div>';
        return renderHTML;
    }

    function renderNameCell(data, type, row) {
        let renderHTML = '';
        let cpName = row.cpName;
        if(nvl(cpName,'') !== ''){
            renderHTML += cpName;
        }else{
            renderHTML += '-';
        }
        return renderHTML;
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        /*renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_mng_admin_detail_modal_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3" data-bs-toggle="modal" data-bs-target="#kt_modal_modify_history">상세정보</a>';
        renderHTML += '</div>';*/
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_mng_admin_modify_init_set(' + '\'' + seq + '\'' + ')" class="menu-link px-3">수정</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_mng_admin_remove(' + '\'' + seq + '\'' + ')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_mng_admin_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_mng_admin_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 0, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_mng_admin_search();
        }
    };
}();

let DTRequestList = function () {
    // Shared variables
    let table;
    let datatable;

    // Private functions
    let initDatatable = function () {
        // Init datatable --- more info on datatables: https://datatables.net/manual/
        datatable = $(table).DataTable({
            'info': false,
            'paging' : true,
            'select': false,
            'ordering': true,
            'order': [[1, 'desc']],
            'columnDefs': [
                { orderable: false, targets: 0 }, // Disable ordering on column 0 (checkbox)
                {
                    'targets': '_all',
                    'className': 'text-center'
                },
                {
                    'targets': 0,
                    'render': function (data, type, row) { return renderCheckBoxCell(data, type, row); }
                },
                {
                    'targets': 3,
                    'render': function (data, type, row) { return renderEmergencyYnCell(data, type, row); }
                },
                {
                    'targets': 5,
                    'render': function (data, type, row) { return renderProgressStepCell(data, type, row); }
                },
                {
                    'targets': 6,
                    'render': function (data, type, row) { return renderTitleCell(data, type, row); }
                },
                {
                    'targets': 7,
                    'render': function (data, type, row) { return renderCompleteExpectDateCell(data, type, row); }
                },
                {
                    'targets': 8,
                    'render': function (data, type, row) { return renderWriterCell(data, type, row); }
                },
                {
                    'targets': 10,
                    'data': 'actions',
                    'render': function (data, type, row) { return renderActionsCell(data, type, row); }
                },
                { visible: false, targets: [2] }
            ],
            columns: [
                { data: '' },
                { data: 'rownum' },
                { data: 'seq' },
                { data: 'emergencyYn' },
                { data: 'gbn' },
                { data: 'progressStep' },
                { data: 'title' },
                { data: 'completeExpectDate' },
                { data: 'writer' },
                { data: 'initRegiDttm' },
                { data: 'actions' }
            ]
        });
    }

    function renderCheckBoxCell(data, type, row){
        let renderHTML = '-';
        let title = row.title;
        if(nvl(title,'') !== ''){
            renderHTML = '<div class="request_check form-check form-check-sm form-check-custom form-check-solid">' +
                '<input class="form-check-input" type="checkbox" value="'+ row.seq +'" data-value="' + row.progressStep + ' / ' + title + '"/>' +
                '</div>';
        }
        return renderHTML;
    }

    function renderEmergencyYnCell(data, type, row){
        let emergencyYn = row.emergencyYn;
        let renderHTML = '';
        if(nvl(emergencyYn,'N') === 'N'){
            renderHTML = '<div class="badge badge-secondary fw-bold">';
            renderHTML += '일반';
            renderHTML += '</div>';
        }else{
            renderHTML = '<div class="badge badge-danger fw-bold">';
            renderHTML += '긴급';
            renderHTML += '</div>';
        }

        return renderHTML;
    }

    function renderProgressStepCell(data, type, row) {
        let progressStep = row.progressStep;
        let renderHTML = '';
        if(nvl(progressStep,'') === ''){
            renderHTML = '-';
        }else{
            switch (progressStep){
                case '처리대기':
                    renderHTML = '<div class="badge badge-light-success fw-bold">';
                    break;
                case '진행중':
                    renderHTML = '<div class="badge badge-light-primary fw-bold">';
                    break;
                case '완료':
                    renderHTML = '<div class="badge badge-light-secondary fw-bold">';
                    break;
                case '논의필요':
                    renderHTML = '<div class="badge badge-light-warning fw-bold">';
                    break;
                case '처리불가':
                    renderHTML = '<div class="badge badge-light-danger fw-bold">';
                    break;
                default:
                    renderHTML = '<div>-';
                    break;
            }

            renderHTML += progressStep;
            renderHTML += '</div>';
        }

        return renderHTML;
    }

    function renderCompleteExpectDateCell(data, type, row) {
        let completeExpectDate = row.completeExpectDate;
        let renderHTML = '-';
        if(nvl(completeExpectDate,'') !== ''){
            renderHTML = completeExpectDate;
        }

        return renderHTML;
    }

    function renderTitleCell(data, type, row) {
        let seq = row.seq;
        let title = row.title;
        let replyCnt = row.replyCnt;
        let renderHTML = '-';
        if(nvl(title,'') !== ''){
            renderHTML = '<span class="fw-bold">';
            renderHTML += '<a href="javascript:void(0);" onclick="f_request_list_detail_set(\'' + seq + '\')">';
            renderHTML += title;
            if(nvl(replyCnt,'0') !== '0'){
                renderHTML += ' ( ' + replyCnt + ' )';
            }
            renderHTML += '</a>';
            renderHTML += '</span>';
        }

        return renderHTML;
    }

    function renderWriterCell(data, type, row) {
        let writer = row.writer;
        let renderHTML = '-';
        if(nvl(writer,'') !== ''){
            if(writer === 'admin' || writer === 'meetingfan1'){
                renderHTML = '개발사';
            }else{
                renderHTML = '관리자';
            }
        }

        return renderHTML;
    }

    function renderActionsCell(data, type, row){
        //console.log(row.id);
        let seq = row.seq;
        let renderHTML = '<button type="button" onclick="KTMenu.createInstances()" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">';
        renderHTML += 'Actions';
        renderHTML += '<i class="ki-duotone ki-down fs-5 ms-1"></i></button>';
        renderHTML += '<div id="kt_menu" class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_request_list_detail_set(\'' + seq + '\')" class="menu-link px-3">상세/수정</a>';
        renderHTML += '</div>';
        renderHTML += '<div class="menu-item px-3">';
        renderHTML += '<a onclick="f_request_list_remove(\'' + seq + '\')" class="menu-link px-3">삭제</a>';
        renderHTML += '</div>';
        renderHTML += '</div>';
        return renderHTML;
    }

    // Public methods
    return {
        init: function () {
            table = document.querySelector('#mng_request_list_table');

            if (!table) {
                return;
            }

            initDatatable();

            /* Data row clear */
            let dataTbl = $('#mng_request_list_table').DataTable();
            dataTbl.clear();
            dataTbl.draw(false);

            dataTbl.on('order.dt search.dt', function () {
                let i = dataTbl.rows().count();
                dataTbl.cells(null, 1, { search: 'applied', order: 'applied' })
                    .every(function (cell) {
                        this.data(i--);
                    });
            }).draw();

            /* 조회 */
            f_request_list_search();
        }
    };
}();

// On document ready
KTUtil.onDOMContentLoaded(function () {

    // 회원/신청>회원관리
    // 전체 회원 목록
    DTCustomerMember.init(); // /mng/customer/member.do
    // 나의 이력서 목록
    DTCustomerResume.init(); // /mng/customer/resume.do

    // 회원/신청>신청자 목록
    // 상시사전신청
    DTCustomerRegular.init(); // /mng/customer/regular.do
    // 해상엔진 테크니션 (선내기/선외기)
    DTCustomerBoarder.init(); // /mng/customer/boarder.do
    // FRP 정비 테크니션
    DTCustomerFrp.init(); // /mng/customer/frp.do
    // 기초정비교육
    DTCustomerBasic.init(); // /mng/customer/basic.do
    // 응급조치교육
    DTCustomerEmergency.init(); // /mng/customer/emergency.do
    // 선외기_기초정비_실습과정
    DTCustomerOutboarder.init(); // /mng/customer/outboarder.do
    // 선내기_기초정비_실습과정
    DTCustomerInboarder.init(); // /mng/customer/inboarder.do
    // 세일요트_기초정비_실습과정
    DTCustomerSailyacht.init(); // /mng/customer/sailyacht.do
    // 고마력 선외기 정비 중급 테크니션
    DTCustomerHighhorsepower.init(); // /mng/customer/highhorsepower.do
    // 자가정비 심화과정 (고마력 선외기)
    DTCustomerHighself.init(); // /mng/customer/highself.do
    // 고마력 선외기 정비 중급 테크니션 (특별반)
    DTCustomerHighspecial.init(); // /mng/customer/highspecial.do
    // 스턴드라이브 정비 전문가과정
    DTCustomerSterndrive.init(); // /mng/customer/sterndrive.do
    // 스턴드라이브 정비 전문가과정 (특별반)
    DTCustomerSternspecial.init(); // /mng/customer/sternspecial.do
    // 발전기 정비 교육
    DTCustomerGenerator.init(); // /mng/customer/generator.do
    // 선외기/선내기 직무역량 강화과정
    DTCustomerCompetency.init(); // /mng/customer/competency.do
    // 선내기 팸투어
    DTCustomerFamtourin.init(); // /mng/customer/famtourin.do
    // 선외기 팸투어
    DTCustomerFamtourout.init(); // /mng/customer/famtourout.do
    // 레저선박 해양전자장비 교육
    DTCustomerElectro.init(); // /mng/customer/electro.do

    // 교육>교육관리
    // 교육현황
    DTEducationTrain.init(); // /mng/education/train.do
    // 결제/환불현황
    DTEducationPayment.init(); // /mng/education/payment.do

    // 정보센터>게시판관리
    // 공지사항
    DTBoardNotice.init(); // /mng/board/notice.do
    // 보도자료
    DTBoardPress.init(); // /mng/board/press.do
    // 사진자료
    DTBoardGallery.init(); // /mng/board/gallery.do
    // 영상자료
    DTBoardMedia.init(); // / mng/board/media.do
    // 뉴스레터
    DTBoardNewsletter.init(); // /mng/board/newsletter.do
    // 채용공고
    DTBoardAnnouncement.init(); // /mng/board/announcement.do
    // 취/창업현황
    DTBoardEmployment.init(); // /mng/board/employment.do
    // 취/창업성공후기
    DTBoardJob.init(); // /mng/board/job.do
    // 커뮤니티
    DTBoardCommunity.init(); // /mng/board/community.do
    // FAQ
    DTBoardFaq.init(); // /mng/board/faq.do

    // 정보센터>팝업/배너 관리
    // 팝업관리
    DTPopPopup.init(); // /mng/pop/popup.do
    // 배너관리
    DTPopBanner.init(); // /mng/pop/banner.do

    // 정보센터>뉴스레터관리
    // 뉴스레터구독자관리
    DTNewsletterSubscriber.init(); // /mng/newsletter/subscriber.do

    // 정보센터>SMS관리
    // SMS 발송 관리
    DTSmsMngSms.init(); // /mng/smsMng/sms.do

    DTSmsMngSmsTrain.init(); // /mng/smsMng/sms/send.do
    DTSmsMngSmsExcel.init(); // /mng/smsMng/sms/send.do

    // 파일>파일관리
    // 다운로드 내역
    DTFileDownload.init(); // /mng/file/download.do
    // 임시휴지통
    DTFileTrash.init(); // /mng/file/trash.do

    // 관리자 관리
    DTAdminMngAdmin.init(); // /mng/adminMng/admin.do

    //개발사>요청사항&문의
    //요청사항&문의 관리
    DTRequestList.init(); // /mng/request/list.do

});