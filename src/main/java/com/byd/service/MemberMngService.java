package com.byd.service;

import com.byd.dto.SmsDTO;
import com.byd.mapper.MemberMngMapper;
import com.byd.util.SHA512;
import com.byd.util.StringUtil;
import com.byd.vo.Criteria;
import com.byd.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.util.List;

@Service
@RequiredArgsConstructor
public class MemberMngService {

    private final MemberMngMapper memberMngMapper;
    private final SHA512 sha512;
    private final SmsService smsService; // SMS 발송 서비스

    public List<MemberVO> getMemberList(Criteria cri) {
        return memberMngMapper.selectMemberListWithPaging(cri);
    }

    public int getTotal(Criteria cri) {
        return memberMngMapper.getTotalCount(cri);
    }

    public MemberVO getMember(Long memberId) {
        return memberMngMapper.selectMemberById(memberId);
    }

    @Transactional
    public void updateStatus(Long memberId, String status) {
        memberMngMapper.updateMemberStatus(memberId, status);
    }

    @Transactional
    public String resetPassword(Long memberId) {
        MemberVO member = memberMngMapper.selectMemberById(memberId);
        if (member == null) return "not_found";

        // 소셜 가입자인 경우 초기화 요청 차단 로직 추가
        if (member.getSocialProvider() != null &&
                ("KAKAO".equals(member.getSocialProvider()) || "APPLE".equals(member.getSocialProvider()))) {
            return "is_social";
        }

        try {
            // 1. 임시 비밀번호 생성 (8자리 랜덤)
            String tempPw = StringUtil.getRandomString(8);

            // 2. 비밀번호 암호화 및 DB 업데이트 (사용자단과 똑같이 SHA512 사용)
            String encPw = sha512.hash(tempPw);
            member.setPassword(encPw);
            memberMngMapper.updatePassword(member);

            // 3. SMS 발송
            if (member.getPhoneNumber() != null && !member.getPhoneNumber().isEmpty()) {
                String msg = "[승요일기] 임시 비밀번호는 [" + tempPw + "] 입니다. 로그인 후 변경해주세요.";
                SmsDTO smsDTO = SmsDTO.builder()
                        .receiver(member.getPhoneNumber())
                        .sender("07080953937") // 실제 운영시 등록된 발신번호 필수
                        .message(msg)
                        .testmode_yn("N")
                        .build();

                smsService.smsSend(smsDTO);
                return "ok";
            } else {
                return "no_phone";
            }
        } catch (Exception e) {
            return "fail";
        }
    }

    // 관리자: 회원 정보 업데이트 (닉네임, 연락처)
    @Transactional
    public void updateAdminMemberInfo(MemberVO member) {
        memberMngMapper.updateAdminMemberInfo(member);
    }

    // 엑셀 다운로드 서비스
    public void downloadExcel(HttpServletResponse response) throws Exception {
        // 1. 엑셀용 전체 데이터 조회
        List<MemberVO> list = memberMngMapper.selectMemberListForExcel();

        // 2. 워크북 및 시트 생성
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("회원 목록");

        // 3. 엑셀 스타일 정의 (헤더용 / 데이터용)
        CellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setAlignment(HorizontalAlignment.CENTER);
        headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        headerStyle.setFillForegroundColor(IndexedColors.PALE_BLUE.getIndex()); // 연한 파란색 배경
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setBorderTop(BorderStyle.THIN);
        headerStyle.setBorderBottom(BorderStyle.THIN);
        headerStyle.setBorderLeft(BorderStyle.THIN);
        headerStyle.setBorderRight(BorderStyle.THIN);

        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);

        CellStyle centerStyle = workbook.createCellStyle();
        centerStyle.setAlignment(HorizontalAlignment.CENTER);
        centerStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        centerStyle.setBorderTop(BorderStyle.THIN);
        centerStyle.setBorderBottom(BorderStyle.THIN);
        centerStyle.setBorderLeft(BorderStyle.THIN);
        centerStyle.setBorderRight(BorderStyle.THIN);

        CellStyle leftStyle = workbook.createCellStyle();
        leftStyle.setAlignment(HorizontalAlignment.LEFT);
        leftStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        leftStyle.setBorderTop(BorderStyle.THIN);
        leftStyle.setBorderBottom(BorderStyle.THIN);
        leftStyle.setBorderLeft(BorderStyle.THIN);
        leftStyle.setBorderRight(BorderStyle.THIN);

        // 4. 헤더(첫 줄) 작성
        Row headerRow = sheet.createRow(0);
        headerRow.setHeight((short) 500);
        String[] headers = {
                "No.", "상태", "닉네임", "이메일", "가입경로", "연락처",
                "응원팀", "이번달 직관", "팔로잉", "팔로워", "승(요정)", "무", "패(요정)", "승률(%)", "가입일시"
        };

        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        // 5. 데이터 행 작성
        int rowNum = 1;
        for (MemberVO member : list) {
            Row row = sheet.createRow(rowNum++);
            int colNum = 0;

            Cell cell0 = row.createCell(colNum++);
            cell0.setCellValue(rowNum - 1);
            cell0.setCellStyle(centerStyle);

            String statusStr = member.getStatus();
            if ("ACTIVE".equals(statusStr)) statusStr = "정상";
            else if ("SUSPENDED".equals(statusStr)) statusStr = "정지";
            else if ("WITHDRAWN".equals(statusStr)) statusStr = "탈퇴";

            Cell cell1 = row.createCell(colNum++);
            cell1.setCellValue(statusStr);
            cell1.setCellStyle(centerStyle);

            Cell cell2 = row.createCell(colNum++);
            cell2.setCellValue(member.getNickname());
            cell2.setCellStyle(centerStyle);

            Cell cell3 = row.createCell(colNum++);
            cell3.setCellValue(member.getEmail());
            cell3.setCellStyle(leftStyle);

            String provider = member.getSocialProvider();
            if (provider == null || "NONE".equals(provider)) {
                provider = "EMAIL";
            }
            Cell cell4 = row.createCell(colNum++);
            cell4.setCellValue(provider);
            cell4.setCellStyle(centerStyle);

            Cell cell5 = row.createCell(colNum++);
            cell5.setCellValue(member.getFormattedPhoneNumber());
            cell5.setCellStyle(centerStyle);

            Cell cell6 = row.createCell(colNum++);
            cell6.setCellValue(member.getMyTeamName() != null ? member.getMyTeamName() : "미설정");
            cell6.setCellStyle(centerStyle);

            Cell cell7 = row.createCell(colNum++);
            cell7.setCellValue(member.getMonthlyAttendanceCount() != null ? member.getMonthlyAttendanceCount() : 0);
            cell7.setCellStyle(centerStyle);

            Cell cell8 = row.createCell(colNum++);
            cell8.setCellValue(member.getFollowingCount() != null ? member.getFollowingCount() : 0);
            cell8.setCellStyle(centerStyle);

            Cell cell9 = row.createCell(colNum++);
            cell9.setCellValue(member.getFollowerCount() != null ? member.getFollowerCount() : 0);
            cell9.setCellStyle(centerStyle);

            // 승, 무, 패, 승률 계산
            int win = member.getWinCount() != null ? member.getWinCount() : 0;
            int draw = member.getDrawCount() != null ? member.getDrawCount() : 0;
            int lose = member.getLoseCount() != null ? member.getLoseCount() : 0;
            int total = win + lose;
            double winRate = total > 0 ? (win * 100.0) / total : 0.0;

            Cell cell10 = row.createCell(colNum++);
            cell10.setCellValue(win);
            cell10.setCellStyle(centerStyle);

            Cell cell11 = row.createCell(colNum++);
            cell11.setCellValue(draw);
            cell11.setCellStyle(centerStyle);

            Cell cell12 = row.createCell(colNum++);
            cell12.setCellValue(lose);
            cell12.setCellStyle(centerStyle);

            Cell cell13 = row.createCell(colNum++);
            cell13.setCellValue(Double.parseDouble(String.format("%.1f", winRate)));
            cell13.setCellStyle(centerStyle);

            String cDate = member.getCreatedAt() != null ? String.valueOf(member.getCreatedAt()).replace("T", " ") : "-";
            if (cDate.length() > 19) cDate = cDate.substring(0, 19);

            Cell cell14 = row.createCell(colNum++);
            cell14.setCellValue(cDate);
            cell14.setCellStyle(centerStyle);
        }

        // 6. 셀 너비 자동 맞춤
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
            sheet.setColumnWidth(i, sheet.getColumnWidth(i) + 1024);
        }

        // 7. 엑셀 파일 전송
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        String fileName = URLEncoder.encode("전체회원목록_통계포함", "UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + ".xlsx\"");

        workbook.write(response.getOutputStream());
        workbook.close();
    }

}