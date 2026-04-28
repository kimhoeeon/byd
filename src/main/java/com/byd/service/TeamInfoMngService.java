package com.byd.service;

import com.byd.mapper.TeamInfoMngMapper;
import com.byd.vo.Criteria;
import com.byd.vo.TeamVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TeamInfoMngService {

    private final TeamInfoMngMapper teamInfoMngMapper;

    public List<TeamVO> getTeamList() {
        return teamInfoMngMapper.getTeamList();
    }

    public TeamVO getTeam(String teamCode) {
        return teamInfoMngMapper.selectTeamByCode(teamCode);
    }

    @Transactional
    public void updateTeam(TeamVO team) {
        teamInfoMngMapper.updateTeam(team);
    }

    public List<TeamVO> selectTeamList(Criteria cri) {
        return teamInfoMngMapper.selectTeamList(cri);
    }

}