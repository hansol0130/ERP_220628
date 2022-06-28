USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_EVT_PROMOTION_DELETE
■ DESCRIPTION				: 프로모션 이벤트 삭제
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2017-05-12		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_EVT_PROMOTION_DELETE]
	@SEC_SEQ INT,
 	@ARR_SEQ_NO VARCHAR(100)
AS 
BEGIN
	SET NOCOUNT OFF;

	UPDATE EVT_PROMOTION_DETAIL SET 
		DEL_YN = CASE WHEN ISNULL(DEL_YN, 'N') = 'N'THEN 'Y' ELSE 'N' END 
	WHERE SEC_SEQ = @SEC_SEQ AND SEQ_NO IN ( SELECT Data FROM DBO.FN_SPLIT(@ARR_SEQ_NO, ',') );

END



GO
