/* Copyright(C)2018 NSMALL - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited by law.
 * This file is proprietary and confidential.
 *
 * Written by EDSK project team
 */
package com.byd.constants;

public class CommConstants {

    /* SMS Sender */
    public static final String SMS_SENDER_NUM = "1811-7891";

    /* 결과 코드*/
    public static final String RESULT_CODE_SUCCESS = "0";
    public static final String RESULT_CODE_FAIL = "-1";

    /* 결과 메시지*/
    public static final String RESULT_MSG_SUCCESS = "SUCCESS";
    public static final String RESULT_MSG_FAIL = "FAIL";


    /* 승인 여부 */
    public static final String APPROVAL_STATUS_CONF = "승인";
    public static final String APPROVAL_STATUS_REQ = "승인요청";
    public static final String APPROVAL_STATUS_NO = "미승인";
    public static final String APPROVAL_STATUS_ING = "작성중";

    // -----------------------------------------------------------
    // 경기 타입 (Game Type)
    // GameVO 주석 참고: (EXHIBITION, REGULAR, POST, ALLSTAR)
    // -----------------------------------------------------------
    public static final String GAME_TYPE_EXHIBITION = "EXHIBITION"; // 시범경기
    public static final String GAME_TYPE_REGULAR    = "REGULAR";    // 정규시즌
    public static final String GAME_TYPE_POST       = "POST";       // 포스트시즌
    public static final String GAME_TYPE_ALLSTAR    = "ALLSTAR";    // 올스타전
}
