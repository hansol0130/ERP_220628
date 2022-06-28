USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CUS_SPECIAL_UPDATE
■ DESCRIPTION				: 특수고객 수정
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2016-06-09		정지용			최초생성
   2019-03-19       김남훈          업데이트 이력 추가
================================================================================================================*/ 
CREATE PROC [dbo].[SP_CUS_SPECIAL_UPDATE]
 	@TEL_NUMBER1 VARCHAR(4),
	@TEL_NUMBER2 VARCHAR(4),
	@TEL_NUMBER3 VARCHAR(4),
	@CUS_NO INT,
	@EMP_CODE CHAR(7),
	@REMARK	NVARCHAR(200),
	@USE_YN CHAR(1),
	@SPC_NO INT,
	@EDT_CODE CHAR(7)
AS 
BEGIN
	UPDATE CUS_SPECIAL SET
		NO1 = @TEL_NUMBER1,  NO2 = @TEL_NUMBER2, NO3 = @TEL_NUMBER3, CUS_NO = @CUS_NO, 
		CONNECT_CODE = @EMP_CODE, REMARK = @REMARK, USE_YN = @USE_YN, EDT_CODE = @EDT_CODE, EDT_DATE = GETDATE()
	WHERE SPC_NO = @SPC_NO
END
GO
