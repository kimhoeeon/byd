package com.byd.service;

import com.byd.mapper.QuizLiveMapper;
import com.byd.vo.QuizLiveSessionVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class QuizLiveService {

    private final QuizLiveMapper quizLiveMapper;

    // 현재 세션 상태 가져오기
    public QuizLiveSessionVO getCurrentLiveSession(String playDate, int sessionNo) {
        return quizLiveMapper.getLiveSession(playDate, sessionNo);
    }

    // MC가 새로운 회차 시작하기 (랜덤 10문제 고정 출제)
    @Transactional
    public boolean startNewLiveSession(String playDate, int sessionNo) {
        QuizLiveSessionVO existing = quizLiveMapper.getLiveSession(playDate, sessionNo);
        if (existing != null) {
            return false; // 이미 생성됨
        }

        List<Integer> questionIds = quizLiveMapper.getRandomQuestionIds(10);
        String assignedQuestions = questionIds.stream()
                .map(String::valueOf)
                .collect(Collectors.joining(","));

        QuizLiveSessionVO newSession = new QuizLiveSessionVO();
        newSession.setPlayDate(playDate);
        newSession.setSessionNo(sessionNo);
        newSession.setCurrentQuestionNo(0);
        newSession.setStatus("READY");
        newSession.setAssignedQuestions(assignedQuestions);

        quizLiveMapper.insertLiveSession(newSession);
        return true;
    }

    // MC 클리커 컨트롤 로직 (문제 변경 / 상태 변경)
    @Transactional
    public void controlLiveSession(String playDate, int sessionNo, int targetQuestionNo, String targetStatus) {
        QuizLiveSessionVO vo = new QuizLiveSessionVO();
        vo.setPlayDate(playDate);
        vo.setSessionNo(sessionNo);
        vo.setCurrentQuestionNo(targetQuestionNo);
        vo.setStatus(targetStatus);

        quizLiveMapper.updateLiveSession(vo);
    }

    // 비상시 세션 완전 초기화 (참가자 이력까지 싹 지워서 카운트를 0으로 만듦)
    @Transactional
    public void resetLiveSession(String playDate, int sessionNo) {
        quizLiveMapper.deleteLiveSession(playDate, sessionNo);
        quizLiveMapper.deleteHistoryBySession(playDate, sessionNo);
    }

    // 유저 답안 실시간 저장 (Auto-save)
    @Transactional
    public void saveUserAnswer(int userSeq, String playDate, int sessionNo, int questionIndex, int answerId) {
        String currentAnswersStr = quizLiveMapper.getUserAnswers(userSeq, playDate, sessionNo);

        if(currentAnswersStr == null || currentAnswersStr.isEmpty()) {
            currentAnswersStr = "0,0,0,0,0,0,0,0,0,0";
        }

        String[] answersArr = currentAnswersStr.split(",");

        if(questionIndex >= 1 && questionIndex <= 10) {
            answersArr[questionIndex - 1] = String.valueOf(answerId);
        }

        String updatedAnswers = String.join(",", answersArr);
        quizLiveMapper.updateUserAnswers(userSeq, playDate, sessionNo, updatedAnswers);
    }

    // 현재 접속 완료된 참가자 수 반환
    public int getLiveParticipantCount(String playDate, int sessionNo) {
        return quizLiveMapper.getParticipantCount(playDate, sessionNo);
    }

    // 특정 회차 만점자 목록 가져오기
    public List<Map<String, Object>> getPerfectScorers(String playDate, int sessionNo) {
        return quizLiveMapper.getPerfectScorers(playDate, sessionNo);
    }
}