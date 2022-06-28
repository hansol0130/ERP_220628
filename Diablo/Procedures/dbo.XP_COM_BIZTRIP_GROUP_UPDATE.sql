USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BIZTRIP_GROUP_UPDATE
■ DESCRIPTION				: BTMS 거래처 출장 그룹 기본정보 등록 및 수정
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-28		김성호			최초생성
   2016-02-12		정지용			XML AGT_CODE CHAR(1)=> VARCHAR(10) 으로 변경 / 항공호텔 각키 조건없음 추가
   2016-02-15		정지용			정렬순서 업데이트 ROWNUMBER 조건 수정
   2016-02-16		김성호			호텔 등록 프로세스 수정 업데이트 ONLY -> 삭제, 수정, 등록
   2016-05-24		박형만			@AIR_RULE CLASS_NOT_USE - 이용불가 좌석등급 추가 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BIZTRIP_GROUP_UPDATE]
	@AGT_CODE		VARCHAR(10),
	@BT_SEQ			INT,
	@BTG_NAME		VARCHAR(20),
	@REPORT_YN		CHAR(1),
	@EMAIL_SEND_YN	CHAR(1),
	@CONFIRM_YN		CHAR(1),
	@AIR_SAME_YN	CHAR(1),
	@AIR_LIKE_YN	CHAR(1),
	@HOTEL_LIKE_YN	CHAR(1),
	@ORDER_NUM		INT,
	@USE_YN			CHAR(1),
	@NEW_SEQ		INT,

	@AIR_RULE		XML,
	@HOTEL_RULE		XML
AS 
BEGIN

	DECLARE @MAX_SEQ INT, @FLAG INT;

	-- 본문
	IF EXISTS(SELECT 1 FROM COM_BIZTRIP_GROUP WITH(NOLOCK) WHERE AGT_CODE = @AGT_CODE AND BT_SEQ = @BT_SEQ)
	BEGIN
		SELECT @MAX_SEQ = @BT_SEQ, @FLAG = (CASE WHEN A.ORDER_NUM >= @ORDER_NUM THEN 0 ELSE 2 END)
		FROM COM_BIZTRIP_GROUP A WITH(NOLOCK)
		WHERE A.AGT_CODE = @AGT_CODE AND A.BT_SEQ = @BT_SEQ

		UPDATE A SET A.BTG_NAME = @BTG_NAME, A.REPORT_YN = @REPORT_YN, A.EMAIL_SEND_YN = @EMAIL_SEND_YN, A.CONFIRM_YN = @CONFIRM_YN
			, A.AIR_SAME_YN = @AIR_SAME_YN, A.AIR_LIKE_YN = @AIR_LIKE_YN, A.HOTEL_LIKE_YN = @HOTEL_LIKE_YN, A.USE_YN = @USE_YN, EDT_DATE = GETDATE(), EDT_SEQ = @NEW_SEQ
		FROM COM_BIZTRIP_GROUP A
		WHERE A.AGT_CODE = @AGT_CODE AND A.BT_SEQ = @BT_SEQ
	END
	ELSE
	BEGIN
		SELECT @MAX_SEQ = ISNULL((SELECT MAX(BT_SEQ) FROM COM_BIZTRIP_GROUP WITH(NOLOCK) WHERE AGT_CODE = @AGT_CODE), 0) + 1, @FLAG = 0

		INSERT INTO COM_BIZTRIP_GROUP (AGT_CODE, BT_SEQ, BTG_NAME, REPORT_YN, EMAIL_SEND_YN, CONFIRM_YN, AIR_SAME_YN, AIR_LIKE_YN, HOTEL_LIKE_YN, USE_YN, NEW_DATE, NEW_SEQ)
		VALUES (@AGT_CODE, @MAX_SEQ, @BTG_NAME, @REPORT_YN, @EMAIL_SEND_YN, @CONFIRM_YN, @AIR_SAME_YN, @AIR_LIKE_YN, @HOTEL_LIKE_YN, @USE_YN, GETDATE(), @NEW_SEQ)

		INSERT INTO COM_AIR_RULE (AGT_CODE, BT_SEQ, AIR_RULE_SEQ, CLASS, USE_YN)
		SELECT * FROM (
			SELECT @AGT_CODE AS [AGT_CODE], @MAX_SEQ AS [BT_SEQ], 1 AS [AIR_RULE_SEQ], 'E' AS [CLASS], 'N' AS [USE_YN]
			UNION ALL
			SELECT @AGT_CODE, @MAX_SEQ, 2, 'B', 'N'
			UNION ALL
			SELECT @AGT_CODE, @MAX_SEQ, 3, 'F', 'N'
		) A
	END;

	-- 정렬순서
	WITH LIST AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY A.ORDER_NUM, A.FLAG) AS [ROWNUMBER], A.*
		FROM (
			SELECT A.AGT_CODE, A.BT_SEQ, A.ORDER_NUM, 1 AS [FLAG]
			FROM COM_BIZTRIP_GROUP A WITH(NOLOCK)
			WHERE A.AGT_CODE = @AGT_CODE AND A.BT_SEQ <> @MAX_SEQ
			UNION ALL
			SELECT @AGT_CODE, @MAX_SEQ, @ORDER_NUM, @FLAG
		) A
	)
	UPDATE A SET A.ORDER_NUM = B.ROWNUMBER
	FROM COM_BIZTRIP_GROUP A
	INNER JOIN LIST B ON A.AGT_CODE = B.AGT_CODE AND A.BT_SEQ = B.BT_SEQ

	-- 항공
	UPDATE A SET A.START_HOUR = B.StartHour, A.END_HOUR = B.EndHour, A.USE_YN = B.UseYn  , A.NEW_SEQ = B.NewSeq  ,  A.CLASS_NOT_USE = B.ClassNotUse
	FROM COM_AIR_RULE A
	INNER JOIN (
		SELECT
			t1.col.value('./AgentCode[1]', 'VARCHAR(10)') as [AgentCode]
			, t1.col.value('./BizTripSeq[1]', 'int') as [BizTripSeq]
			, t1.col.value('./AirRuleSeq[1]', 'int') as [AirRuleSeq]
			, t1.col.value('./StartHour[1]', 'int') as [StartHour]
			, t1.col.value('./EndHour[1]', 'int') as [EndHour]
			, t1.col.value('./Class[1]', 'char(1)') as [Class]
			, t1.col.value('./UseYn[1]', 'char(1)') as [UseYn]
			, t1.col.value('./NewSeq[1]', 'char(1)') as [NewSeq]
			, t1.col.value('./ClassNotUse[1]', 'char(1)') as [ClassNotUse]
		FROM @AIR_RULE.nodes('/ArrayOfBizTripAirRuleRQ/BizTripAirRuleRQ') as t1(col)
	) B ON A.AGT_CODE = B.AgentCode AND A.BT_SEQ = B.BizTripSeq AND A.AIR_RULE_SEQ = B.AirRuleSeq;

	-- 호텔
	DECLARE @TEMP_HOTEL_RULE TABLE (
		RowNumber			INT,
		HotelRuleSeq		INT,
		RegMasterSeq		INT,
		LimitPrice			INT,
		UseYn				CHAR(1)
	)
	INSERT INTO @TEMP_HOTEL_RULE (RowNumber, HotelRuleSeq, RegMasterSeq, LimitPrice, UseYn)
	SELECT
		ROW_NUMBER() OVER (ORDER BY t1.col.value('./HotelRuleSeq[1]', 'int')) AS [RowNumber]
		, t1.col.value('./HotelRuleSeq[1]', 'int') as [HotelRuleSeq]
		, t1.col.value('./RegionMasterSeq[1]', 'int') as [RegionMasterSeq]
		, t1.col.value('./LimitPrice[1]', 'int') as [LimitPrice]
		, t1.col.value('./UseYn[1]', 'char(1)') as [UseYn]
	FROM @HOTEL_RULE.nodes('/ArrayOfBizTripHotelRuleRQ/BizTripHotelRuleRQ') as t1(col)
	-- 삭제
	DELETE FROM COM_HOTEL_RULE
	WHERE AGT_CODE = @AGT_CODE AND BT_SEQ = @BT_SEQ AND HOTEL_RULE_SEQ NOT IN (SELECT HotelRuleSeq FROM @TEMP_HOTEL_RULE);
	-- 수정
	UPDATE A SET A.LIMIT_PRICE = B.LimitPrice, A.USE_YN = B.UseYn, A.NEW_DATE = GETDATE(), A.NEW_SEQ = @NEW_SEQ
	FROM COM_HOTEL_RULE A
	INNER JOIN @TEMP_HOTEL_RULE B ON A.AGT_CODE = @AGT_CODE AND A.BT_SEQ = @BT_SEQ AND A.HOTEL_RULE_SEQ = B.HotelRuleSeq
	-- 등록
	SELECT @MAX_SEQ = ISNULL((SELECT MAX(A.HOTEL_RULE_SEQ) FROM COM_HOTEL_RULE A WITH(NOLOCK) WHERE A.AGT_CODE = @AGT_CODE AND A.BT_SEQ = @BT_SEQ), 0)

	INSERT INTO COM_HOTEL_RULE (AGT_CODE, BT_SEQ, HOTEL_RULE_SEQ, REG_MASTER_SEQ, LIMIT_PRICE, USE_YN, NEW_DATE, NEW_SEQ)
	SELECT @AGT_CODE, @BT_SEQ, (@MAX_SEQ + A.RowNumber), A.RegMasterSeq, A.LimitPrice, A.UseYn, GETDATE(), @NEW_SEQ
	FROM @TEMP_HOTEL_RULE A
	WHERE A.HotelRuleSeq = 0

END 



GO
