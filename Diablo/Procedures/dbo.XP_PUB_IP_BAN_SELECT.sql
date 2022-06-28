USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_PUB_IP_BAN_SELECT
■ DESCRIPTION				: 해외 불량 아이피 메일 보낼시 체크
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	XP_PUB_IP_BAN_SELECT '58.71.118.172', '977761964'
	XP_PUB_IP_BAN_SELECT '110.11.44.187', '1846226107'
	XP_PUB_IP_BAN_SELECT '127.0.0.1', '2130706433'
	SELECT * FROM  IP_BAN_LIST			
■ MEMO						:  
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2017-06-05		정지용			최초생성   
   2017-08-02		정지용			2분으로 해놨지만 패턴변경하여 계속 시도하여 당일 기준 해외에서 10번 메일 발송 시도시 BAN 처리
================================================================================================================*/ 
CREATE PROC [dbo].[XP_PUB_IP_BAN_SELECT]
 	@IPADDRESS VARCHAR(50),
	@IP_LONG BIGINT
AS 
BEGIN
	DECLARE @BAN_LIMIT_CNT INT;
	SET @BAN_LIMIT_CNT = 10; -- 10번 제한

	DECLARE @BAN_YN CHAR(1);
	DECLARE @BAN_CNT INT;
	SET @BAN_YN = 'N';

	/* 국가 체크 */
	DECLARE @NATION_CODE CHAR(2);
	SELECT 
		@NATION_CODE = B.NATION_CODE 
	FROM IPADDRESS_COUNTRY_IP A WITH(NOLOCK)
	INNER JOIN IPADDRESS_COUNTRY_CODE B WITH(NOLOCK) ON A.SEQ_NO = B.SEQ_NO
	WHERE @IP_LONG BETWEEN START_NUM AND END_NUM

	-- 한국일 경우에는 BAN 안함
	IF ISNULL(@NATION_CODE, 'KR') = 'KR'
	BEGIN
		SELECT @BAN_YN;
		RETURN;
	END
	
	-- 중국 / 필리핀 일 경우 그냥 다 막기 ( 나쁜놈들 때문엥.. )
	
	IF ISNULL(@NATION_CODE, 'KR') = 'CN' OR ISNULL(@NATION_CODE, 'KR') = 'PH'
	BEGIN
		SELECT 'Y';
		RETURN;
	END
	
	-- 120초 안에 10번 시도한 경우 BAN 처리
	SELECT TOP 1 @BAN_CNT = BAN_COUNT FROM IP_BAN_LIST WITH(NOLOCK) WHERE IPADDRESS = @IPADDRESS ORDER BY CONNECT_DATE DESC;
	IF @BAN_CNT >= @BAN_LIMIT_CNT
	BEGIN
		SELECT 'Y';
		RETURN;
	END

	IF NOT EXISTS ( SELECT 1 FROM IP_BAN_LIST WITH(NOLOCK) WHERE IPADDRESS = @IPADDRESS )
	BEGIN 
		INSERT INTO IP_BAN_LIST ( IPADDRESS, NATION_CODE, CONNECT_DATE )
		VALUES (@IPADDRESS, @NATION_CODE, GETDATE() );
	END
	ELSE
	BEGIN		
		DECLARE @CONNECT_DATE DATETIME;
		DECLARE @SEQ_NO INT;
		SELECT TOP 1 @CONNECT_DATE = CONNECT_DATE, @SEQ_NO = SEQ_NO FROM IP_BAN_LIST WITH(NOLOCK) WHERE IPADDRESS = @IPADDRESS ORDER BY CONNECT_DATE DESC;
		
		-- 마지막 접속 기준 120초 안에 재접속 시도시 BAN 카운트 1씩 증가
		IF DATEDIFF(SS, @CONNECT_DATE, GETDATE()) <= 120 
		BEGIN
			UPDATE IP_BAN_LIST SET 
				BAN_COUNT = ISNULL(BAN_COUNT, 0) + 1, 
				@BAN_YN = BAN_YN = CASE WHEN (ISNULL(BAN_COUNT, 0) + 1) = @BAN_LIMIT_CNT THEN 'Y' ELSE 'N' END,
				CONNECT_DATE = GETDATE()
			WHERE SEQ_NO = @SEQ_NO;
		END
		ELSE
		BEGIN
			-- 당일 기준 해외에서 10번 메일 발송 시도시 BAN 처리 ( 5번으로 줄임 )
			DECLARE @EXISTS_CNT INT;
			SELECT @EXISTS_CNT = COUNT(1) FROM IP_BAN_LIST WITH(NOLOCK) WHERE IPADDRESS = @IPADDRESS AND CONVERT(VARCHAR(10), CONNECT_DATE, 121) = CONVERT(VARCHAR(10), GETDATE(), 121)

			IF @EXISTS_CNT >= 5
			BEGIN
				UPDATE IP_BAN_LIST SET 
					BAN_COUNT = 10, 
					@BAN_YN = BAN_YN = 'Y',
					CONNECT_DATE = GETDATE()
				WHERE SEQ_NO = @SEQ_NO;
			END
			ELSE
			BEGIN
				INSERT INTO IP_BAN_LIST ( IPADDRESS, NATION_CODE, CONNECT_DATE )
				VALUES (@IPADDRESS, @NATION_CODE, GETDATE() );
			END
		END
	END

	SELECT @BAN_YN;
END
GO
