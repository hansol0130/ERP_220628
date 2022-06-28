USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: ZP_CUS_KAKAOCUSTOMER_UPDATE
■ DESCRIPTION				: 카카오싱크 중복가입자 현황 제외처리
■ INPUT PARAMETER			: 
■ EXEC						: EXEC ZP_CUS_KAKAOCUSTOMER_UPDATE '5420,5419,5418'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2021-09-02		홍종우					최초 생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[ZP_CUS_KAKAOCUSTOMER_UPDATE]
	@INFO VARCHAR(MAX)
AS
BEGIN
	
	SET NOCOUNT ON
 	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 	
	DECLARE @SQL_STRING VARCHAR(MAX)
	
	SET @SQL_STRING = 'UPDATE CUS_SNS_CLEAR SET CHECK_YN = 2 '
	SET @SQL_STRING = @SQL_STRING + 'WHERE CUS_SNS_SEQ IN ('+@INFO+')'
 
	EXEC(@SQL_STRING) 

END
GO
