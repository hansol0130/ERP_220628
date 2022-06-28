USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_MENU_UPDATE
■ DESCRIPTION				: 메뉴정보 저장/수정
■ INPUT PARAMETER			: 
	@MENU_GUBUN				: 메뉴구분
	@MENU_GUBUN_SORT		: 정렬순서
	@MENU_ID				: 메뉴id
	@MENU_NAME				: 메뉴명
	@MENU_LEVEL				: 레벨
	@SORT					: 정렬순서
	@UPPER_MENU_ID			: 상위메뉴
	@MENU_URL				: 웹 url
	@REMARK					: 메모
	@EMP_CODE				:  등록직원
■ OUTPUT PARAMETER			: 
■ EXEC						: 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------

 ------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-12-29		곽병삼			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_MENU_UPDATE]
--DECLARE
	@MENU_TYPE			VARCHAR(2),
	@MENU_ID			VARCHAR(4),
	@MENU_NAME			NVARCHAR(50),
	@MENU_LEVEL			VARCHAR(2),
	@SORT				SMALLINT,
	@UPPER_MENU_ID		VARCHAR(4),
	@MENU_URL			VARCHAR(50),
	@REMARK				NVARCHAR(200),
	@EMP_CODE			VARCHAR(7)

AS
--SET @MENU_GUBUN = 'A0'
--SET @MENU_GUBUN_SORT = 3
--SET @MENU_ID = NULL
--SET @MENU_NAME = '고객평가Sheet관리'
--SET @MENU_LEVEL = '20'
--SET @SORT = NULL
--SET @UPPER_MENU_ID = 'A000'
--SET @MENU_URL = 'Estimate/CusEstimateMaster'
--SET @REMARK = NULL
--SET @EMP_CODE = '2013069'

DECLARE
		@MENU_TYPE_SORT	INT

BEGIN
	
	SELECT
		@MENU_TYPE_SORT = SORT
	FROM Sirens.cti.CTI_CODE_MASTER
	WHERE CATEGORY = 'CTI001'
	AND MAIN_CODE = @MENU_TYPE
	AND USE_YN = 'Y'

	IF ISNULL(@MENU_ID,'') = ''
	BEGIN
		IF @MENU_LEVEL = '10'
		BEGIN
			SET @SORT = CONVERT(SMALLINT, CONVERT(VARCHAR,@MENU_TYPE_SORT) + '00')
			SET @MENU_ID = @MENU_TYPE + '00'
		END
		ELSE
		BEGIN
			SELECT
				@SORT = CASE WHEN MAX(SORT) IS NULL THEN CONVERT(SMALLINT, CONVERT(VARCHAR,@MENU_TYPE_SORT) + '01') ELSE MAX(SORT)+1 END,
				@MENU_ID = @MENU_TYPE + '0'+ CONVERT(VARCHAR,CONVERT(SMALLINT, ISNULL(MAX(RIGHT(MENU_ID,2)),0))+1)
			FROM Sirens.cti.CTI_MENU
			WHERE UPPER_MENU_ID = @UPPER_MENU_ID
			AND MENU_LEVEL = @MENU_LEVEL
		END
	END

	MERGE Sirens.cti.CTI_MENU AS TARGET
	USING (SELECT @MENU_ID AS MENU_ID) AS SOURCE
	ON (TARGET.MENU_ID = SOURCE.MENU_ID)
	WHEN MATCHED THEN
	UPDATE SET 
		TARGET.MENU_NAME = @MENU_NAME,
		TARGET.UPPER_MENU_ID = @UPPER_MENU_ID,
		TARGET.MENU_LEVEL = @MENU_LEVEL,
		TARGET.MENU_URL = @MENU_URL,
		TARGET.REMARK = @REMARK,
		TARGET.SORT = @SORT,
		TARGET.EDT_DATE = GETDATE(), 
		TARGET.EDT_CODE = @EMP_CODE
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (MENU_ID, MENU_NAME, MENU_LEVEL, SORT, UPPER_MENU_ID, MENU_URL, REMARK, NEW_DATE, NEW_CODE)
	VALUES (
		@MENU_ID,
		@MENU_NAME,
		@MENU_LEVEL,
		@SORT,
		@UPPER_MENU_ID,
		@MENU_URL,
		@REMARK,
		GETDATE(),
		@EMP_CODE
	);
END
GO
