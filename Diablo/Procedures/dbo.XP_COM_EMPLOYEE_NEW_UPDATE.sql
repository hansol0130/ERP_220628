USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: [[XP_COM_EMPLOYEE_NEW_INSERT]]
■ DESCRIPTION				: 팝업 업로드
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 

■ EXEC						: 
	EXEC XP_COM_EMPLOYEE_NEW_UPDATE '92756','2016021','','1','test','19790909','M','2EA6201A068C5FA0EEA5D81A3863321A87F8D533','010-123-1233','010','123','1233','2010-03-01','KNIHGT@NAVER.COM','1','100'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-05-20		박형만					최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_COM_EMPLOYEE_NEW_UPDATE]
(
	@AGT_CODE			VARCHAR(10),
	@EMP_ID				VARCHAR(20),
	@EMP_SEQ			int,
	@TEAM_SEQ			int,
	@POS_SEQ			int,

	@KOR_NAME			VARCHAR(20),
	@BIRTH_DATE			VARCHAR(10),
	@GENDER				CHAR(1),
	@PASSWORD			VARCHAR(100),
	@HP_NUMBER			VARCHAR(20),
	--@HP_TEL01			VARCHAR(20),
	--@HP_TEL02			VARCHAR(20),
	--@HP_TEL03			VARCHAR(20),
	@EMAIL				VARCHAR(50),
	
	@CUS_NO				INT= 0 ,
	@NEW_CODE			EMP_CODE=NULL,
	@NEW_SEQ			INT = 0, -- 기본 0 
	@EDT_SEQ			INT = 0 
)
AS

BEGIN

	 --//empSeq = 0 인경우 
  --      // 직원등록 , 고객정보등록 , 직원-고객매핑정보등록 
  --      //cusNo = 0 인경우 
  --      // 고객정보등록 , 직원-고객매핑정보등록 
  
	-- NULL 값 넣기 
	SET @TEAM_SEQ = CASE WHEN ISNULL(@TEAM_SEQ,0) = 0 THEN NULL ELSE @TEAM_SEQ END 
	SET @BIRTH_DATE = CASE WHEN ISNULL(@BIRTH_DATE,'') = '' THEN NULL ELSE @BIRTH_DATE END 
		
	UPDATE COM_EMPLOYEE 
		SET TEAM_SEQ = @TEAM_SEQ , POS_SEQ = @POS_SEQ 
			, KOR_NAME = @KOR_NAME  , EMP_ID = @EMP_ID , GENDER = @GENDER , BIRTH_DATE = @BIRTH_DATE 
			 , HP_NUMBER = @HP_NUMBER , @EMAIL = EMAIL  
	WHERE AGT_CODE = @AGT_CODE 
	AND EMP_SEQ =  @EMP_SEQ 

	-----<결과반환>-----
	SELECT 1 AS RESULT_STATUS , @CUS_NO AS CUS_NO , @EMP_SEQ AS EMP_SEQ , '' AS RES_CODE
			
END

GO
