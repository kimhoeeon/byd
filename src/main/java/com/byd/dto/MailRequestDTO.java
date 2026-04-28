package com.byd.dto;

import com.byd.vo.DevFileVO;
import lombok.Data;
import java.util.List;

@Data
public class MailRequestDTO {
    private String subject;
    private String body;
    private List<Receiver> receiver;
    private String template;
    private List<DevFileVO> fileUrl;

    @Data
    public static class Receiver {
        private String name;
        private String email;
        private String mobile;
        public Receiver(String name, String email) {
            this.name = name;
            this.email = email;
        }
    }
}