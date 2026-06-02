package com.byd.vo;
import lombok.Data;
import java.util.Date;

@Data
public class MaterialVO {
    private int seq;
    private String category;
    private String materialName;
    private int initQty;
    private int totalQty;
    private int todayOutQty;
    private String memo;
    private Date regDate;

    // UI 프로그레스 바 계산용 (소진율)
    public int getExhaustionRate() {
        if (initQty == 0) return 0;
        return (int) (((double) totalQty / initQty) * 100);
    }
}