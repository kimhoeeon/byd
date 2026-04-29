<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>잘못된 접근 - BYD 시승신청</title>
    <link rel="stylesheet" type="text/css" href="/css/reset.css">
    <link rel="stylesheet" type="text/css" href="/css/style.css">
    <style>
        .error-container {
            text-align: center;
            padding: 100px 20px;
            color: #fff;
        }

        .error-container h1 {
            font-size: 80px;
            margin-bottom: 20px;
            font-weight: 800;
            color: #e50000;
        }

        .error-container p {
            font-size: 18px;
            margin-bottom: 40px;
            line-height: 1.5;
        }

        .btn-home {
            display: inline-block;
            padding: 15px 40px;
            background-color: #fff;
            color: #000;
            text-decoration: none;
            font-weight: bold;
            border-radius: 5px;
        }
    </style>
</head>
<body style="background-color:#111;">
    <div class="wrap">
        <div class="error-container">
            <h1>400</h1>
            <h2>잘못된 접근입니다.</h2>
            <p>유효하지 않은 티켓 링크이거나<br>잘못된 경로로 접근하셨습니다.</p>
            <a href="/apply/step1" class="btn-home">시승 신청 홈으로</a>
        </div>
    </div>
</body>
</html>