package com.byd.service;

import com.byd.mapper.QuizLiveMapper;
import com.byd.vo.QuizLiveSessionVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
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
        // 1. 이미 생성된 회차인지 확인
        QuizLiveSessionVO existing = quizLiveMapper.getLiveSession(playDate, sessionNo);
        if (existing != null) {
            return false; // 이미 생성됨 (초기화 후 다시 시도해야 함)
        }

        // 2. 서버가 랜덤 10문제를 추출 (해당 회차에 들어오는 모든 유저는 이 문제들만 봄)
        List<Integer> questionIds = quizLiveMapper.getRandomQuestionIds(10);
        String assignedQuestions = questionIds.stream()
                .map(String::valueOf)
                .collect(Collectors.joining(","));

        // 3. 신규 라이브 세션 객체 생성
        QuizLiveSessionVO newSession = new QuizLiveSessionVO();
        newSession.setPlayDate(playDate);
        newSession.setSessionNo(sessionNo);
        newSession.setCurrentQuestionNo(0);
        newSession.setStatus("WAITING"); // 퀴즈 시작 대기 상태
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
        vo.setStatus(targetStatus); // PLAYING, SHOW_ANSWER, ENDED 중 하나

        quizLiveMapper.updateLiveSession(vo);
    }

    // 비상시 세션 완전 초기화
    @Transactional
    public void resetLiveSession(String playDate, int sessionNo) {
        quizLiveMapper.deleteLiveSession(playDate, sessionNo);
    }

    // 유저 답안 실시간 저장 (Auto-save) - 화면 이탈 시에도 마지막 찍은 답으로 인정
    @Transactional
    public void saveUserAnswer(int userSeq, String playDate, int sessionNo, int questionIndex, int answerId) {
        String currentAnswersStr = quizLiveMapper.getUserAnswers(userSeq, playDate, sessionNo);

        // 처음 찍는 거라면 10개의 0으로 초기화
        if(currentAnswersStr == null || currentAnswersStr.isEmpty()) {
            currentAnswersStr = "0,0,0,0,0,0,0,0,0,0";
        }

        String[] answersArr = currentAnswersStr.split(",");

        // 인덱스 안전성 검사 (1번문제=index 1)
        if(questionIndex >= 1 && questionIndex <= 10) {
            answersArr[questionIndex - 1] = String.valueOf(answerId);
        }

        String updatedAnswers = String.join(",", answersArr);
        quizLiveMapper.updateUserAnswers(userSeq, playDate, sessionNo, updatedAnswers);
    }
}