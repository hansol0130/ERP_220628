USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_CODE_MASTER_UPDATE
■ DESCRIPTION				: 공통코드 저장/수정
■ INPUT PARAMETER			: 
	@GUBUN					:구분
	@CATEGORY				:코드 카테고리 CTI(구분세자리) + 숫자3자리(000)
	@CATEGORY_NAME			:카테고리명
	@MAIN_CODE				:코드
	@MAIN_NAME				:설명
	@REFERENCE_CATEGORY		:관련1(레벨구조 코드시 사용)
	@REFERENCE_CODE			:관련2(레벨구조 코드시 사용)
	@SORT					:정렬
	@USE_YN					:사용유무
	@REMARK					:비고
	@EMP_CODE				:작업자ID
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	SP_CTI_CODE_MASTER_UPDATE 'N','CTI000','사용여부','A','TEST','','',3,'Y','테스트',2013017'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------

 ------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-12-30		곽병삼			최초생성
   2015-02-05		박노민			설명추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_CODE_MASTER_UPDATE]
--DECLARE
	@GUBUN				CHAR(1),
	@CATEGORY			VARCHAR(6),
	@CATEGORY_NAME		VARCHAR(50),
	@MAIN_CODE			VARCHAR(20),
	@MAIN_NAME			VARCHAR(50),
	@REFERENCE_CATEGORY	VARCHAR(6),
	@REFERENCE_CODE		VARCHAR(20),
	@SORT				INT,
	@USE_YN				VARCHAR(1),
	@REMARK				NVARCHAR(200),
	@EMP_CODE			VARCHAR(7)

AS
--SET @GUBUN = 'N'
--SET @CATEGORY = 'CTI000'
--SET @CATEGORY_NAME = '사용여부'
--SET @MAIN_CODE = 'A'
--SET @MAIN_NAME = 'TEST'
--SET @REFERENCE_CATEGORY = NULL
--SET @REFERENCE_CODE = NULL
--SET @SORT = 3
--SET @USE_YN = 'Y'
--SET @REMARK = '테스트'
--SET @EMP_CODE = '2013069'

BEGIN
	
	MERGE sirens.cti.CTI_CODE_MASTER AS TARGET
	USING (SELECT @CATEGORY AS CATEGORY, @MAIN_CODE AS MAIN_CODE) AS SOURCE
	ON (TARGET.CATEGORY = SOURCE.CATEGORY AND TARGET.MAIN_CODE = SOURCE.MAIN_CODE)
	WHEN MATCHED THEN
	UPDATE SET
		TARGET.MAIN_NAME = @MAIN_NAME,
		TARGET.REFERENCE_CATEGORY = @REFERENCE_CATEGORY,
		TARGET.REFERENCE_CODE = @REFERENCE_CODE,
		TARGET.SORT = @SORT,
		TARGET.USE_YN = @USE_YN,
		TARGET.REMARK = @REMARK,
		TARGET.EDT_DATE = GETDATE(), 
		TARGET.EDT_CODE = @EMP_CODE
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (CATEGORY, CATEGORY_NAME, MAIN_CODE, MAIN_NAME, REFERENCE_CATEGORY, REFERENCE_CODE, SORT, USE_YN, REMARK, NEW_DATE, NEW_CODE)
	VALUES (
		@CATEGORY, @CATEGORY_NAME, @MAIN_CODE, @MAIN_NAME, @REFERENCE_CATEGORY, @REFERENCE_CODE, @SORT, @USE_YN, @REMARK, GETDATE(), @EMP_CODE
	);
END
GO
