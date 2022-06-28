USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*================================================================================================================
■ USP_NAME					: XP_COM_ERP_BIZTRIP_MASTER_UPDATE
■ DESCRIPTION				: BTMS ERP 출장 현황 마스터 정보 수정
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-20		김성호			최초생성
   2016-05-11		정지용			전화번호 입력 안될수 있음 조건 추가
   2016-08-29		정지용			COM_BIZTRIP_MASTER 수정시 수정일 들어가도록 추가 , EDT_DATE = GETDATE()
   2018-11-09		이명훈			SOC_NUM2 삭제
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_ERP_BIZTRIP_MASTER_UPDATE]
	@AGT_CODE			VARCHAR(10),
	@BT_CODE			VARCHAR(20),
	@START_DATE			DATETIME,
	@END_DATE			DATETIME,
	@BT_NAME			VARCHAR(200),
	@NEW_SEQ			INT,
	@HP_NUMBER			VARCHAR(20),
	@EMAIL				VARCHAR(50),
	@PAY_REQUEST_DATE	DATETIME,
	@EMP_CODE			CHAR(7),
	@ERROR_MSG			VARCHAR(1000) OUTPUT
AS 
BEGIN

BEGIN TRY
	BEGIN TRAN

	UPDATE COM_BIZTRIP_MASTER SET
		BT_START_DATE = @START_DATE, BT_END_DATE = @END_DATE, BT_NAME = @BT_NAME, NEW_SEQ = @NEW_SEQ, PAY_REQUEST_DATE = @PAY_REQUEST_DATE, EDT_CODE = @EMP_CODE, EDT_DATE = GETDATE()
	WHERE AGT_CODE = @AGT_CODE AND BT_CODE = @BT_CODE;

	UPDATE COM_EMPLOYEE SET HP_NUMBER = @HP_NUMBER, EMAIL = @EMAIL WHERE AGT_CODE = @AGT_CODE AND EMP_SEQ = @NEW_SEQ;

	IF EXISTS(SELECT 1 FROM COM_BIZTRIP_MASTER WITH(NOLOCK) WHERE AGT_CODE = @AGT_CODE AND BT_CODE = @BT_CODE AND NEW_SEQ = @NEW_SEQ)
	BEGIN
		-- 전화번호 분리
		DECLARE @TEL1 VARCHAR(5), @TEL2 VARCHAR(4), @TEL3 VARCHAR(4), @CUS_NO INT;
		
		IF REPLACE(@HP_NUMBER, '-', '') <> ''
		BEGIN 
			WITH HP_NUMBER AS (
				SELECT REPLACE(@HP_NUMBER, '-', '') AS [TEL]
			)
			SELECT
				@TEL1 = SUBSTRING(TEL, 1, P1),
				@TEL2 = SUBSTRING(TEL, (P1 + 1), (P2 - P1)),
				@TEL3 = SUBSTRING(TEL, (P2 + 1), 20),
				@CUS_NO = B.CUS_NO
			FROM (SELECT TEL, (CASE WHEN TEL LIKE '02%' THEN 2 ELSE 3 END) AS [P1], (LEN(TEL) - 4) AS [P2] FROM HP_NUMBER) A
			CROSS JOIN (SELECT CUS_NO FROM COM_EMPLOYEE_MATCHING WITH(NOLOCK) WHERE AGT_CODE = @AGT_CODE AND EMP_SEQ = @NEW_SEQ) B
		END

		-- 고객정보 수정
		UPDATE A SET A.NOR_TEL1 = @TEL1, A.NOR_TEL2 = @TEL2, A.NOR_TEL3 = @TEL3, A.EMAIL = @EMAIL
		FROM CUS_CUSTOMER_damo A
		INNER JOIN COM_EMPLOYEE_MATCHING B ON A.CUS_NO = B.CUS_NO
		WHERE B.AGT_CODE = @AGT_CODE AND B.EMP_SEQ = @NEW_SEQ;
		-- 예약정보 수정
		UPDATE A SET A.CUS_NO = @CUS_NO, A.RES_NAME = D.KOR_NAME, A.SOC_NUM1 = NULL, A.RES_EMAIL = D.EMAIL, A.NOR_TEL1 = @TEL1, A.NOR_TEL2 = @TEL2, A.NOR_TEL3 = @TEL3
			, A.ETC_TEL1 = NULL, A.ETC_TEL2 = NULL, A.ETC_TEL3 = NULL, A.RES_ADDRESS1 = NULL, A.RES_ADDRESS2 = NULL, A.ZIP_CODE = NULL, A.GENDER = D.GENDER, A.BIRTH_DATE = D.BIRTH_DATE
		FROM RES_MASTER_DAMO A
		INNER JOIN COM_BIZTRIP_DETAIL B ON A.RES_CODE = B.RES_CODE
		INNER JOIN COM_BIZTRIP_MASTER C ON B.AGT_CODE = C.AGT_CODE AND B.BT_CODE = C.BT_CODE
		INNER JOIN COM_EMPLOYEE D ON C.AGT_CODE = D.AGT_CODE AND C.NEW_SEQ = D.EMP_SEQ
		WHERE C.AGT_CODE = @AGT_CODE AND C.BT_CODE = @BT_CODE
	END

	COMMIT TRAN
END TRY
BEGIN CATCH

	SELECT @ERROR_MSG = ERROR_MESSAGE();

	ROLLBACK TRAN
END CATCH

END




GO
