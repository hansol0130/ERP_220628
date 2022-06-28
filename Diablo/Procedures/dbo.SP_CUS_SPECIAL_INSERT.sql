USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CUS_SPECIAL_INSERT
■ DESCRIPTION				: 특수고객 저장
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
================================================================================================================*/ 
CREATE PROC [dbo].[SP_CUS_SPECIAL_INSERT]
 	@TEL_NUMBER1 VARCHAR(4),
	@TEL_NUMBER2 VARCHAR(4),
	@TEL_NUMBER3 VARCHAR(4),
	@CUS_NO INT,
	@EMP_CODE CHAR(7),
	@REMARK	NVARCHAR(200),
	@USE_YN CHAR(1),
	@NEW_CODE CHAR(7)


AS 
BEGIN
	INSERT INTO CUS_SPECIAL ( NO1,  NO2, NO3, CUS_NO, CONNECT_CODE, REMARK, USE_YN, NEW_CODE, NEW_DATE )
	VALUES ( @TEL_NUMBER1, @TEL_NUMBER2, @TEL_NUMBER3, @CUS_NO, @EMP_CODE, @REMARK, @USE_YN, @NEW_CODE, GETDATE())
END
GO
