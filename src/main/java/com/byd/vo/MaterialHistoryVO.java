package com.byd.vo;
import lombok.Data;
import java.util.Date;

@Data
public class MaterialHistoryVO {
    private int historySeq;
    private int materialSeq;
    private String changeType; // "IN" or "OUT"
    private int changeQty;
    private String adminId;
    private String reason;
    private Date regDate;
}