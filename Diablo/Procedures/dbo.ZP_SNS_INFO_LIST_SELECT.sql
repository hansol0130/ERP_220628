USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: ZP_SNS_INFO_LIST_SELECT
■ DESCRIPTION				: 검색_SNS 정보
■ INPUT PARAMETER			: CUS_NO
■ EXEC						: 
    -- EXEC ZP_SNS_INFO_LIST_SELECT 7225080 

■ MEMO						: SNS 정보을 조회한다.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2020-11-03		오준혁					최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[ZP_SNS_INFO_LIST_SELECT]
	@CUS_NO				INT
AS
BEGIN
		
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	SELECT CUS_NO
	      ,SNS_COMPANY
	      ,SNS_ID
	      ,SNS_EMAIL
	      ,SNS_NAME
	      ,NEW_DATE
	      ,DISCNT_DATE
	FROM   CUS_SNS_INFO
	WHERE  CUS_NO = @CUS_NO
	       AND DISCNT_DATE IS NULL
	       AND ISNULL(SNS_EMAIL,'') <> ''

END


GO
