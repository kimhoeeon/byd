package com.byd.exception;

// RuntimeException을 상속받는 커스텀 예외 클래스
public class AlertException extends RuntimeException {
    public AlertException(String message) {
        super(message);
    }

    /**
     * Stack Trace 생성을 방지하는 핵심 메서드.
     * 이 메서드를 재정의하면 예외 발생 시 수십 줄의 에러 로그가 생성되지 않고
     * 성능(비용) 낭비도 막을 수 있습니다.
     */
    @Override
    public synchronized Throwable fillInStackTrace() {
        // 부모의 메서드를 호출하지 않고 그냥 자기 자신(this)만 반환합니다.
        return this;
    }
}