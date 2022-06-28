USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_CLIENT_MANAGER_INFO_UPDATE
■ DESCRIPTION				: BTMS 거래처 담당자 정보 수정
■ INPUT PARAMETER			: AGT_CODE
■ OUTPUT PARAMETER			: 
■ EXEC						: 	
	EXEC XP_COM_CLIENT_MANAGER_INFO_UPDATE
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-13		저스트고강태영			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_CLIENT_MANAGER_INFO_UPDATE]
	@AGT_CODE varchar(10), @MANAGER_TYPE INT,@EMP_CODE char(7)
AS 
BEGIN	
		INSERT INTO COM_MANAGER
		(
			AGT_CODE,
			MANAGER_TYPE,
			EMP_CODE,
			NEW_DATE
		)
		VALUES
		(
			@AGT_CODE,
			@MANAGER_TYPE,
			@EMP_CODE,
			GETDATE()
		)
END 
GO
