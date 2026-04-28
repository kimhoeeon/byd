package com.byd.config;

import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;
import lombok.extern.slf4j.Slf4j;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;

@Slf4j
@WebListener
public class MySQLCleanupListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // 시작할 때는 할 일 없음
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        log.info(">>> 웹 애플리케이션 종료: MySQL 리소스 정리 시작");

        // 1. 등록된 JDBC 드라이버 강제 해제
        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            try {
                DriverManager.deregisterDriver(driver);
                log.info(">>> JDBC Driver 해제 완료: {}", driver);
            } catch (SQLException e) {
                log.error(">>> JDBC Driver 해제 실패", e);
            }
        }

        // 2. MySQL Cleanup 쓰레드 강제 종료 (로그의 주범 해결)
        try {
            AbandonedConnectionCleanupThread.checkedShutdown();
            log.info(">>> MySQL AbandonedConnectionCleanupThread 종료 완료");
        } catch (Exception e) {
            log.error(">>> MySQL 쓰레드 종료 실패", e);
        }
    }
}