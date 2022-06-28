USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_NAVER_CONSULT_BOOKING_INSERT
■ DESCRIPTION				: 네이버 시간외 상담예약 프로시저
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: XP_NAVER_CONSULT_BOOKING_INSERT 'XXX901-1910011213', '010','8936','8091','김남훈','네이버테스트44','123','1,1,1'
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-05-14       김남훈          최초생성
   2019-06-21       김남훈          고객이름 데이터 크기 변경
   2019-06-25       김남훈          통계 테이블 추가
================================================================================================================*/ 
CREATE PROC [dbo].[XP_NAVER_CONSULT_BOOKING_INSERT]
	@PRO_CODE VARCHAR(20),
	@NOR_TEL1 VARCHAR(4),
	@NOR_TEL2 VARCHAR(4),
	@NOR_TEL3 VARCHAR(4),
	@CUS_NAME VARCHAR(20),
	@MESSAGE text,
	@NAVER_RES_KEY VARCHAR(10) = NULL,
	@GUEST_QTY VARCHAR(20) = ''
AS 
BEGIN 
	DECLARE @CUS_NO int,
	@NEW_CODE char(7),
	@NEW_NAME varchar(20),
	@NEW_TEAM_CODE char(3),
	@NEW_TEAM_NAME varchar(50),
	@INNER_NUMBER varchar(4),
	@CONSULT_SEQ varchar(14),
	@CONSULT_RES_SEQ int

	DECLARE @CUSTABLE table ( CUS_NO int)


	--해당 고객 정보가 있는지 조회
	SELECT @CUS_NO = CUS_NO 
	FROM CUS_CUSTOMER_damo WITH(NOLOCK)
	WHERE NOR_TEL3 = @NOR_TEL3 
	AND NOR_TEL2 = @NOR_TEL2 
	AND NOR_TEL1 = @NOR_TEL1 
	AND CUS_NAME = @CUS_NAME
	

	IF(@CUS_NO IS NULL)
	BEGIN
		INSERT @CUSTABLE EXEC Sirens.cti.SP_CTI_ERP_CUSTOMER_INSERT @CUS_NAME, NULL,NULL,NULL,NULL,@NOR_TEL1, @NOR_TEL2, @NOR_TEL3, '9999999'
		SELECT @CUS_NO = CUS_NO FROM @CUSTABLE

		PRINT @CUS_NO
	END


	SELECT 
	@NEW_CODE = EM.EMP_CODE,
	@NEW_NAME = EM.KOR_NAME,
	@NEW_TEAM_CODE = EM.TEAM_CODE, 
	@NEW_TEAM_NAME = ET.TEAM_NAME,
	@INNER_NUMBER = EM.INNER_NUMBER3
	FROM
	EMP_MASTER EM WITH(NOLOCK)
	INNER JOIN EMP_TEAM ET WITH(NOLOCK)
	ON ET.TEAM_CODE = EM.TEAM_CODE
	WHERE EM.EMP_CODE = '2019069'

--상담 SEQ 만드는 과정
	DECLARE
	@CTI_TYPE	TINYINT,
	@SEQ	INT,
	@YMD	VARCHAR(8)

	SET @CTI_TYPE = 1
	SET @YMD = CONVERT(VARCHAR(8),GETDATE(),112)

	UPDATE sirens.cti.CTI_SEQ_NUMBER
	SET @SEQ = CTI_SEQ = CTI_SEQ + 1
	WHERE CTI_SEQ_TYPE = 1
	AND CTI_SEQ_YMD = @YMD

	IF @SEQ  IS NULL
	BEGIN
		INSERT sirens.cti.CTI_SEQ_NUMBER(CTI_SEQ_TYPE,CTI_SEQ_YMD,CTI_SEQ)
		VALUES (@CTI_TYPE,@YMD,1)

		SET @SEQ = 1
	END	

	SET @CONSULT_SEQ = @YMD + RIGHT(REPLICATE('0',6) + LTRIM(STR(@SEQ)),6)
--상담 SEQ 만들기 끝

	INSERT INTO Sirens.[cti].[CTI_CONSULT]
	VALUES(
	@CONSULT_SEQ, 
	GETDATE(), 
	'S', 
	0,
	@NEW_CODE, 
	@NEW_NAME,
	@NEW_TEAM_CODE, 
	@NEW_TEAM_NAME, 
	@INNER_NUMBER, 
	'1', 
	@CUS_NO, 
	@CUS_NAME, 
	@NOR_TEL1 + @NOR_TEL2 + @NOR_TEL3,
	NULL, 
	'C', 
	@MESSAGE,
	'N',
	'0',
	'N',
	'N',
	NULL,
	'9',
	GETDATE(),
	'9999999',
	NULL,
	NULL,
	NULL)

	SELECT @CONSULT_RES_SEQ = NEXT VALUE FOR Sirens.CTI.CTI_CONSULT_RES_SEQ

	--상담 예약시간 확인
	DECLARE @DAY_ADD int
	DECLARE @CONSULT_RES_DATE DATETIME
	SET @DAY_ADD = 0;

	--일요일
	IF(DATEPART(DW,GETDATE()) = 1)
	BEGIN		
		SET @DAY_ADD = 1;

	END
	--토요일
	IF(DATEPART(DW,GETDATE()) = 7)
	BEGIN		
		SET @DAY_ADD = 2;

	END

	-- 17시 이후 익일 고객으로
	IF(DATEPART(HH,GETDATE()) >= 17)
	BEGIN
			--금요일	
			IF(DATEPART(DW,GETDATE()) = 6)
			BEGIN		
				SET @DAY_ADD = 3;
			END
			IF(DATEPART(DW,GETDATE()) BETWEEN 2 AND 5)
			BEGIN
				--금요일 아닌 평일
				SET @DAY_ADD = 1;
			END
	END
	
	IF(@DAY_ADD = 0)
	BEGIN
		IF(DATEPART(MI,GETDATE()) < 30)
		BEGIN
			SELECT @CONSULT_RES_DATE = CONVERT(varchar(13),DATEADD(hh,1,DATEADD(dd, @DAY_ADD,GETDATE())),121) + ':00:00.000'
		END
		ELSE
		BEGIN
			SELECT @CONSULT_RES_DATE = CONVERT(varchar(13),DATEADD(hh,1,DATEADD(dd, @DAY_ADD,GETDATE())),121) + ':30:00.000'
		END
	END
	IF(@DAY_ADD > 0)
	BEGIN
		SELECT @CONSULT_RES_DATE = CONVERT(varchar(10),DATEADD(dd, @DAY_ADD,GETDATE()),121) + ' 09:00:00.000'
	END

	INSERT INTO Sirens.[cti].[CTI_CONSULT_RESERVATION]
	VALUES(
	@CONSULT_RES_SEQ, 
	@CONSULT_RES_DATE, 
	@CONSULT_SEQ, 
	'C',
	@NEW_CODE, 
	@NEW_NAME,
	@NEW_TEAM_CODE, 
	@NEW_TEAM_NAME, 
	@INNER_NUMBER, 
	@CUS_NO, 
	@CUS_NAME, 
	@NOR_TEL1 + @NOR_TEL2 + @NOR_TEL3,
	'1', 
	NULL, 
	NULL,
	NULL,
	GETDATE(),
	'9999999',
	NULL,
	NULL)


	--통계 테이블 추가
	INSERT INTO DBO.NAVER_PHONE_BOOKING
	VALUES
	(
		@CONSULT_RES_SEQ,
		@NAVER_RES_KEY,
		dbo.FN_SPLIT_LONG(@PRO_CODE,'|',1),
		dbo.FN_SPLIT_LONG(@PRO_CODE,'|',2),
		dbo.FN_SPLIT_LONG(@GUEST_QTY,',',1),
		dbo.FN_SPLIT_LONG(@GUEST_QTY,',',2),
		dbo.FN_SPLIT_LONG(@GUEST_QTY,',',3)
	)
END 
GO
