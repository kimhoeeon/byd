package com.byd.service;

import com.byd.mapper.ContentMngMapper;
import com.byd.util.FileUtil;
import com.byd.vo.ContentClickLogVO;
import com.byd.vo.EventVO;
import com.byd.vo.MemberVO;
import com.byd.vo.TeamContentVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Slf4j
@Service
@RequiredArgsConstructor
public class ContentMngService {

    private final ContentMngMapper contentMngMapper;

    // ==========================================
    // 1. 이벤트 관리 (기존 Controller 로직 이동)
    // ==========================================
    public List<EventVO> getEventList() {
        return contentMngMapper.selectEventList();
    }

    // 사용자용 이벤트 목록
    public List<EventVO> getActiveEventList() {
        return contentMngMapper.selectActiveEventList();
    }

    public EventVO getEvent(Long eventId) {
        return contentMngMapper.selectEventById(eventId);
    }

    @Transactional
    public void insertEvent(EventVO vo) {
        contentMngMapper.insertEvent(vo);
    }

    @Transactional
    public void updateEvent(EventVO vo) {
        contentMngMapper.updateEvent(vo);
    }

    @Transactional
    public void deleteEvent(Long eventId) {
        contentMngMapper.deleteEvent(eventId);
    }

    // ==========================================
    // 2. 구단 콘텐츠 관리
    // ==========================================

    // 목록 조회 (필터 추가)
    public List<TeamContentVO> getTeamContentList(String teamCode) {
        return contentMngMapper.selectTeamContentList(teamCode);
    }

    // 사용자용 구단 콘텐츠 목록
    public List<TeamContentVO> getActiveTeamContentList(String teamCode, Integer limit) {
        return contentMngMapper.selectActiveTeamContentList(teamCode, limit);
    }

    // 상세 조회
    public TeamContentVO getTeamContent(Long contentId) {
        return contentMngMapper.selectTeamContentById(contentId);
    }

    // 등록/수정 (OG 태그 추출 로직 포함)
    @Transactional
    public void saveTeamContent(TeamContentVO vo, MultipartFile file) {
        // 1. 파일 업로드 처리
        if (file != null && !file.isEmpty()) {
            try {
                String savedUrl = FileUtil.uploadFile(file, "content");
                vo.setImageUrl(savedUrl);
            } catch (Exception e) {
                log.error("파일 업로드 실패", e);
            }
        }
        // 2. 파일이 없고 URL만 있는 경우 -> OG 태그 추출 시도
        else if ((vo.getImageUrl() == null || vo.getImageUrl().isEmpty())
                && vo.getContentUrl() != null && vo.getContentUrl().startsWith("http")) {
            String ogImage = extractOgImage(vo.getContentUrl());
            if (ogImage != null) {
                vo.setImageUrl(ogImage);
            }
        }

        if (vo.getContentId() == null) {
            vo.setSortOrder(contentMngMapper.selectMaxSortOrder() + 1); // 순서 채번
            contentMngMapper.insertTeamContent(vo);
        } else {
            contentMngMapper.updateTeamContent(vo);
        }
    }

    @Transactional
    public void deleteTeamContent(Long contentId) {
        contentMngMapper.deleteTeamContent(contentId);
    }

    // 순서 변경
    @Transactional
    public void changeSortOrder(Long contentId, String direction) {
        // 1. 현재 항목 조회
        TeamContentVO current = contentMngMapper.selectTeamContentById(contentId);
        if (current == null) return;

        // 2. 맞교환 대상 조회 (같은 팀 내에서, 위/아래 인접한 항목)
        TeamContentVO target = contentMngMapper.selectTargetContentForSwap(
                current.getTeamCode(),
                current.getSortOrder(),
                direction
        );

        // 3. 대상이 존재하면 순서(sortOrder) 값을 서로 교체 (Swap)
        if (target != null) {
            int currentOrder = current.getSortOrder();
            int targetOrder = target.getSortOrder();

            contentMngMapper.updateSortOrder(current.getContentId(), targetOrder);
            contentMngMapper.updateSortOrder(target.getContentId(), currentOrder);
        }
    }

    // 통계 조회
    public Map<String, Object> getStats(Long contentId) {
        Map<String, Object> stats = new HashMap<>();
        stats.put("age", contentMngMapper.selectAgeStats(contentId));
        stats.put("daily", contentMngMapper.selectDailyStats(contentId));
        return stats;
    }

    // OG 태그 이미지 추출
    public String extractOgImage(String urlString) {
        if (urlString == null || urlString.isEmpty()) return null;

        try {
            // 1-1. 유튜브 썸네일 우선 처리 (고화질)
            String youtubePattern = "(?<=watch\\?v=|/videos/|embed\\/|youtu.be\\/|\\/v\\/|\\/e\\/|watch\\?v%3D|watch\\?feature=player_embedded&v=|%2Fvideos%2F|embed%2F|youtu.be%2F|%2Fv%2F)[^#\\&\\?\\n]*";
            Pattern compiledPattern = Pattern.compile(youtubePattern);
            Matcher matcher = compiledPattern.matcher(urlString);
            if (matcher.find()) {
                return "https://img.youtube.com/vi/" + matcher.group() + "/mqdefault.jpg";
            }

            // 1-2. 일반 사이트 (Instagram 등) OG 태그 파싱
            URL url = new URL(urlString);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setConnectTimeout(5000); // 5초 타임아웃
            conn.setReadTimeout(5000);    // 읽기 타임아웃 추가

            // [핵심 변경 1] 인스타그램 등 소셜 미디어의 로그인 벽을 우회하기 위해
            // Facebook 공식 크롤러인 것처럼 User-Agent를 위장합니다.
            conn.setRequestProperty("User-Agent", "facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)");

            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            StringBuilder html = new StringBuilder();
            String inputLine;

            // HTML의 <head> 영역(주로 앞부분)만 읽도록 최대 5만자 제한
            while ((inputLine = in.readLine()) != null) {
                html.append(inputLine).append(" ");
                if (html.length() > 50000) break;
            }
            in.close();

            // [핵심 변경 2] 기존의 에러를 유발하던 indexOf 대신 안전한 정규표현식 사용
            // property="og:image" content="..." 또는 content="..." property="og:image" 두 가지 패턴 모두 대응
            Pattern ogPattern = Pattern.compile("<meta[^>]+property=[\"']og:image[\"'][^>]+content=[\"']([^\"']+)[\"']|<meta[^>]+content=[\"']([^\"']+)[\"'][^>]+property=[\"']og:image[\"']");
            Matcher m = ogPattern.matcher(html.toString());

            if (m.find()) {
                // 정규표현식 그룹 1번 또는 2번에서 추출된 썸네일 URL을 반환 (HTML 엔티티 디코딩 포함)
                String ogImage = m.group(1) != null ? m.group(1) : m.group(2);
                return ogImage.replace("&amp;", "&");
            }

            return null; // 못 찾으면 null

        } catch (Exception e) {
            log.warn("썸네일 추출 실패 [{}]: {}", urlString, e.getMessage());
            return null; // 에러가 나도 전체 저장 로직이 터지지 않도록 null 반환
        }
    }

    // --- [사용자용] 메인 화면 노출 및 집계 ---

    /**
     * 랜덤 콘텐츠 1개 조회
     */
    public TeamContentVO getRandomTeamContent(String teamCode) {
        if (teamCode == null || "NONE".equals(teamCode) || teamCode.isEmpty()) {
            teamCode = "ALL";
        }
        return contentMngMapper.selectRandomActiveContent(teamCode);
    }

    @Transactional
    public void increaseClickCount(Long contentId) {
        contentMngMapper.increaseClickCount(contentId);
    }

    // 사용자 콘텐츠 클릭 시 로그 기록 + 조회수 증가 처리
    @Transactional
    public void logContentClick(Long contentId, MemberVO member) {
        // 1. 조회수 1 증가
        contentMngMapper.increaseClickCount(contentId);

        // 2. 로그 정보 세팅
        ContentClickLogVO logVO = new ContentClickLogVO();
        logVO.setContentId(contentId);

        if (member != null) {
            logVO.setMemberId(member.getMemberId());
            logVO.setGender(member.getGender());

            // 생년월일(YYYY-MM-DD)을 기반으로 연령대(10대, 20대..) 계산
            String ageGroup = "알수없음";
            if (member.getBirthdate() != null) {
                String birthStr = String.valueOf(member.getBirthdate());
                if (birthStr.length() >= 4) {
                    try {
                        int birthYear = Integer.parseInt(birthStr.substring(0, 4));
                        int currentYear = LocalDate.now().getYear();
                        int age = currentYear - birthYear;
                        int group = (age / 10) * 10;
                        ageGroup = group + "대";
                    } catch (Exception e) {
                        log.warn("연령대 계산 실패", e);
                    }
                }
            }
            logVO.setAgeGroup(ageGroup);
        } else {
            // 비회원일 경우
            logVO.setGender("U");
            logVO.setAgeGroup("알수없음");
        }

        // 3. 로그 DB INSERT
        contentMngMapper.insertClickLog(logVO);
    }

    public void deleteContentCommentByAdmin(Long commentId) {
        contentMngMapper.deleteContentCommentByAdmin(commentId);
    }

}