package com.byd.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class StadiumVisitDTO {
    private Integer stadiumId;
    private String name;
    private boolean visited; // 방문 여부
}