package com.byd.service;

import com.byd.mapper.EventMapper;
import com.byd.vo.ParticipantVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class EventService {

    private final EventMapper eventMapper;

    public void insertParticipant(ParticipantVO participantVO) {
        eventMapper.insertParticipant(participantVO);
    }

    public ParticipantVO getParticipantByPhone(String phone){
        return eventMapper.getParticipantByPhone(phone);
    }
}