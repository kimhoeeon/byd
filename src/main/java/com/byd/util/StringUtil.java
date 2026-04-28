/* Copyright(C)2018 NSMALL - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited by law.
 * This file is proprietary and confidential.
 *
 * Written by EDSK project team
 */
package com.byd.util;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

/**
 * 공통 String Util
 * org.apache.commons.lang.StringUtils 상속후 필요 메소드 추가
 * 자세한 기타 자세한 스펙은 org.apache.commons.lang.StringUtils 참조
 */
public class StringUtil {

    public static final String EMPTY = "";

    // 발주사 제공 금칙어 + 추가 금칙어 통합 리스트
    private static final List<String> BANNED_WORDS = Arrays.asList(
            // [발주사 제공 금칙어]
            "시발", "씨발", "씨빨", "씨팔", "씨바", "시바", "씹", "씹새끼", "씹새", "씹련", "씹년", "씹놈",
            "씹자지", "씹보지", "씹창", "씹탱", "씹탱이", "씹덕", "씹또라이", "씹미친", "씹할",
            "병신", "븅신", "빙신", "ㅂㅅ", "병쉰", "병싄", "병시나", "병시ㄴ", "등신", "머저리",
            "또라이", "또라2", "또라이새끼", "미친놈", "미친년", "미친새끼", "미친", "미쳤냐",
            "개새끼", "개세끼", "개색기", "개색끼", "개쉐이", "개쉑", "개쉐리", "개자식", "개놈", "개년",
            "개같네", "개같은", "개지랄", "지랄", "지럴", "지1랄", "염병", "옘병", "젠장",
            "좆", "존나", "졸라", "좃", "좃나", "죶", "좆같네", "좆같은", "좆밥", "좆까", "좆까라",
            "좆됐네", "좆망", "좆병신", "좆또", "좆집", "좆도", "좆같다", "좆나", "좆되는", "좆되는줄", "좇",
            "자지", "고추새끼", "보지", "보짓물", "보지털",
            "걸레", "걸레년", "창녀", "창년", "창놈", "걸창", "몸파는년", "몸파는놈",
            "섹스", "야스", "애널", "오럴", "딸딸이", "딸치기", "자위", "자위충", "성노리개",
            "강간", "강간범", "강간마", "윤간", "성폭행", "성희롱", "성추행", "몰카", "몰래카메라", "리벤지포르노", "n번방",
            "죽어", "죽여버린다", "죽이고싶다", "죽고싶냐", "뒤져", "뒤져라", "꺼져", "꺼져라",
            "닥쳐", "닥치라", "입닥쳐", "패죽인다", "패버린다", "조져버린다", "가만안둔다", "찢어버린다", "담가버린다", "매장시킨다",
            "신상털이", "신상까", "주소까", "전화번호까",
            "애미", "니애미", "느금마", "느금", "니엄마", "니애비", "니아빠", "애비", "애미없", "애미뒤진", "애비뒤진", "부모없는", "고아새끼", "엄창",
            "맘충", "한남", "한남충", "김치녀", "된장녀", "보슬아치", "보슬", "메갈", "페미나치",
            "틀딱", "급식충", "잼민이", "틀니충", "틀딱충", "장애새끼", "장애년", "장애놈", "병자새끼", "정신병자", "정박아", "저능아", "난쟁이",
            "흑형", "짱깨", "쪽바리", "왜놈", "일베충", "홍어", "빨갱이새끼", "꼴통좌파", "수꼴",
            "게이새끼", "레즈년", "트젠새끼", "보빨", "보추", "노예년", "노예새끼", "개돼지", "버러지", "벌레새끼", "역겨운새끼", "토나온다", "혐오스럽다",
            "썅", "썅년", "썅놈", "쌍년", "쌍놈", "상놈새끼", "호로새끼", "호로자식", "후레자식", "싸가지없네", "싸가지", "재수없네", "재수털려", "재수없다", "염병할",
            "좆병신새끼", "씹병신", "개병신", "좆같이", "씨발년", "씨발놈", "씨발새끼", "시발놈", "시발년", "개좆", "개보지", "개자지", "좆보지", "좆자지",
            "ㅅㅂ", "ㅆㅂ", "ㅂㅅ", "ㅄ", "ㅈㄴ", "ㅈㄹ", "ㅁㅊ", "ㄲㅈ", "ㄷㅈ", "ㅆㅂㄹㅁ", "ㅅㅂㄴ", "ㅅ1ㅂ", "ㅂ1ㅅ", "ㅈ1랄", "ㅈㄴ게", "ㅁ친", "미췬", "병1신", "개1새끼", "좃같", "죶같", "ㅆ발", "시1발", "씨1발",

            // [자체 추가 금칙어: 성매매, 특정 혐오단어, 자살유도 등]
            "새기", "쉑", "느개비", "앱충", "한녀", "김치남", "도태남", "도태녀",
            "룸빵", "창녀촌", "성매매", "조건만남", "원조교제",
            "자살해", "재기해", "이기야", "운지", "창뇬", "엠창", "애자", "호구", "빠가"
    );

    /**
     * 문자열에 금칙어가 포함되어 있는지 검사하는 메서드
     * @param input 검사할 대상 문자열
     * @return 금칙어가 포함되어 있으면 true, 아니면 false
     */
    public static boolean containsBannedWord(String input) {
        if (isEmpty(input)) return false;

        // 공백을 띄어쓰기 꼼수("개 새 끼" 등) 방어를 위해 공백 제거 후 소문자 변환 검사
        String cleanInput = input.replaceAll("\\s+", "").toLowerCase();

        for (String word : BANNED_WORDS) {
            if (cleanInput.contains(word)) {
                return true;
            }
        }
        return false;
    }

    /**
     * 문자열 좌측의 공백을 제거하는 메소드
     *
     * @param str 대상 문자열
     * @return trimed string with white space removed from the front.
     */
    public static String ltrim(String str) {
        int len = str.length();
        int idx = 0;
        while ((idx < len) && (str.charAt(idx) <= ' ')) {
            idx++;
        }
        return str.substring(idx, len);
    }

    /**
     * 문자열 우측의 공백을 제거하는 메소드
     *
     * @param str 대상 문자열
     * @return trimed string with white space removed from the end.
     */
    public static String rtrim(String str) {
        int len = str.length();
        while ((0 < len) && (str.charAt(len - 1) <= ' ')) {
            len--;
        }
        return str.substring(0, len);
    }

    public static String defaultString(final Object str) {
        return str == null ? EMPTY : str.toString();
    }

    public static String defaultString(final Object str, final String defaultStr) {
        return str == null ? defaultStr : str.toString();
    }

    /**
     * String을 int형으로
     *
     * @param value
     * @return
     */
    public static int parseInt(String value) {
        return parseInt(value, 0);
    }

    /**
     * Object를 int형으로
     * Object가 null이면 defaultValue return
     *
     * @param value
     * @param defaultValue
     * @return
     */
    public static int parseInt(String value, int defaultValue) {
        String valueStr = defaultString(value, String.valueOf(defaultValue));
        return Integer.parseInt(valueStr);
    }

    /**
     * String 앞 또는 뒤를 특정문자로 지정한 길이만큼 채워주는 함수    <BR>
     * (예) pad("1234","0", 6, 1) --> "123400"   <BR>
     *
     * @param src    Source string
     * @param pad    pad string
     * @param totLen total length
     * @param mode   앞/뒤 구분 (-1:front, 1:back)
     * @return String
     */
    public static String pad(String src, String pad, int totLen, int mode) {
        String paddedString = "";
        if (src == null)
            return "";
        int srcLen = src.length();
        if ((totLen < 1) || (srcLen >= totLen))
            return src;
        for (int i = 0; i < (totLen - srcLen); i++) {
            paddedString += pad;
        }
        if (mode == -1)
            paddedString += src; // front padding
        else
            paddedString = src + paddedString; //back padding
        return paddedString;
    }

    /**
     * str을 원하는 byte만큼 잘라 리턴한다.
     *
     * @param str
     * @param byteLength
     * @param sizePerLetter (UTF-8 : 3 , EUC-KR : 2)
     * @return string cut
     */
    public static String subStringBytes(String str, int byteLength, int sizePerLetter) {
        int retLength = 0;
        int tempSize = 0;
        int asc;
        if (str == null || "".equals(str) || "null".equals(str)) {
            str = "";
        }

        int length = str.length();

        for (int i = 1; i <= length; i++) {
            asc = str.charAt(i - 1);
            if (asc > 127) {
                if (byteLength >= tempSize + sizePerLetter) {
                    tempSize += sizePerLetter;
                    retLength++;
                }
            } else {
                if (byteLength > tempSize) {
                    tempSize++;
                    retLength++;
                }
            }
        }

        return str.substring(0, retLength);
    }

    public static String removeCRLF(String parameter) {
        return parameter.replaceAll("\r", "").replaceAll("\n", "");
    }

    /**
     * String 형태의 날짜의 포맷을 변경 필요한 부분은 추가.
     *
     * @param date yyyy-MM-dd 날짜
     * @param type 변환할타입 dd-MMM-yyyy
     * @return String changeDate
     */
    public static String dateFormatChange(String date, String type) {

        String changeDate = "";

        DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy", Locale.ENGLISH);

        if ("01".equals(type)) {
            try {
                changeDate = sdf.format(formatter.parse(date));
            } catch (ParseException e) {
                changeDate = date;
            }
        } else if ("02".equals(type)) {
            try {
                changeDate = sdf.format(formatter.parse(date)) + " 00:00:00";
            } catch (ParseException e) {
                changeDate = date;
            }
        } else if ("03".equals(type)) {
            try {
                changeDate = sdf.format(formatter.parse(date)) + " 23:59:59";
            } catch (ParseException e) {
                changeDate = date;
            }
        } else {
            changeDate = date;
        }

        return changeDate;
    }

    public static String cutKorean(String inputString, int koreanByte, int maxByte) {
        byte[] inputByte = inputString.getBytes();
        int cutByte = 0;
        for (int i = 0; i < inputString.length() - 1; i++) {
            if (isIncludeKorean(inputString.substring(i, i + 1))) {
                if (cutByte + koreanByte > maxByte) {
                    break;
                }
                cutByte += koreanByte;
            } else {
                if (cutByte + 1 > maxByte) {
                    break;
                }
                cutByte += 1;
            }
        }
        return new String(inputByte, 0, cutByte);
    }

    private static boolean isIncludeKorean(String input) {
        boolean returnFlag = false;
        for (int i = 0; i < input.length(); i++) {
            if (Character.getType(input.charAt(i)) == Character.OTHER_LETTER) {
                returnFlag = true;
            }
        }
        return returnFlag;
    }

    public static String nvl(Object oValue) {

        String stNew = "";
        if (oValue != null) {
            stNew = nvl(oValue.toString());
        }
        return stNew;
    }

    public static String nvl(Object oValue, String stNew) {

        if (oValue != null) {
            String str = nvl(oValue.toString());
            stNew = nvl(str, stNew);
        }
        return stNew;
    }

    public static String nvl(String stValue) {

        String stNew = nvl(stValue, "");
        return stNew;
    }

    public static String nvl(String stValue, String stNew) {

        String stResult = null;

        if (isEmpty(stValue)) {
            stResult = stNew;
        } else {
            stResult = stValue.trim();
        }

        return stResult;
    }

    /**
     * NULL값을 공백값으로 치환
     *
     * @param lvalue
     * @return String
     */
    public static String defaultString(Long lvalue) {

        return defaultString(lvalue, EMPTY);
    }

    /**
     * NULL값을 default 문자열로 치환
     *
     * @param lvalue
     * @param defaultString
     * @return
     */
    public static String defaultString(Long lvalue, String defaultString) {

        if (lvalue == null) {
            return defaultString;
        } else {
            return String.valueOf(lvalue);
        }
    }

    public static boolean equalsOr(String org, String... compares) {
        return equalsOr(org, Arrays.asList(compares));
    }

    /**
     * 같은 문자열이 있는지 체크
     *
     * @param org(기준문자열)
     * @return
     */
    public static boolean equalsOr(String org, List<String> commpares) {
        if (org == null) {
            return false;
        }
        if (commpares == null) {
            return false;
        }

        for (String compare : commpares) {
            if (compare == null) {
                continue;
            }

            if (org.equals(compare)) {
                return true;
            }
        }

        return false;
    }

    /**
     * <p>Checks if a CharSequence is empty (""), null or whitespace only.</p>
     *
     * <p>Whitespace is defined by {@link Character#isWhitespace(char)}.</p>
     *
     * <pre>
     * StringUtils.isBlank(null)      = true
     * StringUtils.isBlank("")        = true
     * StringUtils.isBlank(" ")       = true
     * StringUtils.isBlank("bob")     = false
     * StringUtils.isBlank("  bob  ") = false
     * </pre>
     *
     * @param cs the CharSequence to check, may be null
     * @return {@code true} if the CharSequence is null, empty or whitespace only
     * @since 2.0
     * @since 3.0 Changed signature from isBlank(String) to isBlank(CharSequence)
     */
    public static boolean isBlank(final CharSequence cs) {
        int strLen;
        if (cs == null || (strLen = cs.length()) == 0) {
            return true;
        }
        for (int i = 0; i < strLen; i++) {
            if (!Character.isWhitespace(cs.charAt(i))) {
                return false;
            }
        }
        return true;
    }

    // Empty checks
    //-----------------------------------------------------------------------

    /**
     * <p>Checks if a CharSequence is empty ("") or null.</p>
     *
     * <pre>
     * StringUtils.isEmpty(null)      = true
     * StringUtils.isEmpty("")        = true
     * StringUtils.isEmpty(" ")       = false
     * StringUtils.isEmpty("bob")     = false
     * StringUtils.isEmpty("  bob  ") = false
     * </pre>
     *
     * <p>NOTE: This method changed in Lang version 2.0.
     * It no longer trims the CharSequence.
     * That functionality is available in isBlank().</p>
     *
     * @param cs the CharSequence to check, may be null
     * @return {@code true} if the CharSequence is empty or null
     * @since 3.0 Changed signature from isEmpty(String) to isEmpty(CharSequence)
     */
    public static boolean isEmpty(final CharSequence cs) {
        return cs == null || cs.length() == 0;
    }

    public static boolean isEmpty(final Collection<?> coll) {
        return coll == null || coll.isEmpty();
    }

    /**
     * 이메일 마스킹 처리 (앞 3자리 노출 후 *** 마스킹)
     * 예: abcdefg@naver.com -> abc***@naver.com
     * 예: ab@naver.com -> a***@naver.com (3자리 미만 시 1자리 노출)
     */
    public static String maskEmail(String email) {
        if (isEmpty(email)) return "";

        int atIndex = email.indexOf("@");
        if (atIndex < 0) return email; // 이메일 형식이 아니면 그대로 반환

        String id = email.substring(0, atIndex);
        String domain = email.substring(atIndex);

        if (id.length() <= 3) {
            // 아이디가 3자리 이하인 경우 첫 글자만 보여주고 마스킹
            return id.substring(0, 1) + "***" + domain;
        } else {
            // 아이디가 3자리 초과인 경우 앞 3자리 보여주고 마스킹
            return id.substring(0, 3) + "***" + domain;
        }
    }

    /**
     * 지정된 길이의 랜덤 문자열(영대문자+숫자) 생성
     * @param length 생성할 문자열 길이
     * @return Random String
     */
    public static String getRandomString(int length) {
        StringBuilder sb = new StringBuilder();
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        for (int i = 0; i < length; i++) {
            int index = (int) (Math.random() * chars.length());
            sb.append(chars.charAt(index));
        }
        return sb.toString();
    }

    /**
     * 전화번호 하이픈(-) 추가
     * @param phone 전화번호 (예: 01012345678)
     * @return 하이픈이 추가된 번호 (예: 010-1234-5678)
     */
    public static String formatPhone(String phone) {
        if (isEmpty(phone)) return "-";

        // 숫자만 남기기 (특수문자 등 제거)
        String onlyNum = phone.replaceAll("[^0-9]", "");

        if (onlyNum.length() == 11) {
            return onlyNum.replaceFirst("(\\d{3})(\\d{4})(\\d{4})", "$1-$2-$3");
        } else if (onlyNum.length() == 10) {
            if (onlyNum.startsWith("02")) {
                return onlyNum.replaceFirst("(\\d{2})(\\d{4})(\\d{4})", "$1-$2-$3");
            } else {
                return onlyNum.replaceFirst("(\\d{3})(\\d{3})(\\d{4})", "$1-$2-$3");
            }
        } else if (onlyNum.length() == 9) {
            return onlyNum.replaceFirst("(\\d{2})(\\d{3})(\\d{4})", "$1-$2-$3");
        } else if (onlyNum.length() == 8) {
            return onlyNum.replaceFirst("(\\d{4})(\\d{4})", "$1-$2");
        }
        return phone; // 자리수가 맞지 않으면 원본 반환
    }

}