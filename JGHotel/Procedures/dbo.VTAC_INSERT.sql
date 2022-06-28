USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- =============================================
-- Author:        <Author,,Name>
-- Create date: <Create Date,,>
-- Description:    <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[VTAC_INSERT]
    @ToTel        nvarchar(20),
	@Name        nvarchar(20),
	@ResNo        nvarchar(20),
	@HotelName        nvarchar(200),
	@TicketUrl        nvarchar(200),
    @isComplete bit



AS
BEGIN
    DECLARE @contentType NVARCHAR(64);    --요청할 HTTP 서버에 보낼 데이터의 콘텐츠 타입을 정의하는 변수
    DECLARE @postData NVARCHAR(2000);     --실제 보내는 데이터 담을 변수
    DECLARE @responseText NVARCHAR(2000); --HTTP 서버의 처리 결과를 응답받을 변수
    DECLARE @responseXML NVARCHAR(2000);  --사용안함(응답받을 데이터 XML형식일 경우를 가정해 만든것으로 보임)
    DECLARE @ret INT;                     --OLE 자동화 프로시저 호출 결과 리턴 값을 담을 변수(0:성공, 0 아닌 숫자는 실패)
    DECLARE @status NVARCHAR(32);         --요청 서버의 상태 값을 답는 변수
    DECLARE @statusText NVARCHAR(32);     --요청 서버의 상태 값의 상세 내용을 답는 변수
    DECLARE @token INT;                   --OLE 자동화 프로시저 개채 생성 토큰 값을 담을 변수(여기서는 1회용 개체 사용권) 
    DECLARE @url NVARCHAR(256);           --HTTP 서버 URL 변수
    DECLARE @sComplete    NVARCHAR(10);

 
    --쿼리문 또는 프로시저의 영향을 받은 행 수를 나타내는 메시지가 결과 집합의 일부로 반환되지 않도록 하는 것
    --프로시저 속도 향상을 위해...((0개 행인 영향을 받음) <<< 영향받은 행이 0일 경우 이 메시지가 나오지 않도록 조치됨.)
    SET NOCOUNT ON;
 
    IF (@isComplete = 0)
        SET @sComplete = 'false'
    ElSE
        SET @sComplete = 'true'
 
 
    BEGIN TRY --예외 실행문 시작
        SET @contentType = 'application/json';                                                --컨텐츠타입
        SET @postData = '{  "ToTel":"' + @ToTel + '", "Name":"' + @Name + '","ResNo":"' + @ResNo + '","HotelName":"' + @HotelName + '", "TicketUrl":"' + @TicketUrl + '", "isComplete":' + @sComplete + '}';    --전송데이터
        SET @url = 'https://api.verygoodtour.com/api/hotel/alimtalk/'                --웹URL
 
        --커넥션 생성
        EXEC @ret = sp_OACreate 'MSXML2.ServerXMLHTTP', @token OUT; --MSXML2.ServerXMLHTTP 웹페이지를 읽는 xml파서 개체 형식의 OLE 인스턴스 개체 생성(출력된 토큰값으로 사용)
        IF @ret = 0 BEGIN                                            --OLE 인스턴스 개체 생성 결과가 정상일 경우 시작
            --HTTP 서버 요청
            EXEC @ret = sp_OAMethod @token, 'open', NULL, 'POST', @url, 'false';                    --서버와의 통신 방식 정의
            EXEC @ret = sp_OAMethod @token, 'setRequestHeader', NULL, 'Content-type', @contentType; --데이터 요청 헤더 정의
            EXEC @ret = sp_OAMethod @token, 'setTimeouts', NULL, 1000, 1000, 1000, 1000                --연결 유지 시간 정의
            EXEC @ret = sp_OAMethod @token, 'send', NULL, @postData; --데이터 전송
 
            --응답 결과 처리
            EXEC @ret = sp_OAGetProperty @token, 'status', @status OUT;                    --서버 상태
            EXEC @ret = sp_OAGetProperty @token, 'statusText', @statusText OUT;            --서버 상태 내용
            EXEC @ret = sp_OAGetProperty @token, 'responseText', @responseText OUT;        --응답 내용
 
            --응답 결과 확인
            PRINT 'Status: ' + @status + ' (' + @statusText + ')';  --OLE 개체의 속성 상태와 내용을 출력
            PRINT 'Response text: ' + @responseText;  --응답 결과 출력
 
            --해당 토큰값의 OLE 인스턴스 개체 소멸(소켓 클로즈라고 보면됨.)
            EXEC @ret = sp_OADestroy @token;
        END
    END TRY        
    BEGIN CATCH
        PRINT ERROR_MESSAGE()
    END CATCH  
END
 
 /* 테스트 프로시저 
    exec [AddTodoitem] 'test1234', 0
*/
GO
