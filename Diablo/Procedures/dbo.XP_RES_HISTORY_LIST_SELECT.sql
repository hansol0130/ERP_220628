USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_RES_HISTORY_LIST_SELECT
■ DESCRIPTION				: 예약정보 수정 히스토리 리스트 검색
■ INPUT PARAMETER			: 
	@RES_CODE	VARCHAR(20)	: 예약코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	exec XP_RES_HISTORY_LIST_SELECT 'RP1301229445'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-03-03		김성호			최초생성
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_RES_HISTORY_LIST_SELECT]
(
	@RES_CODE	VARCHAR(20)
)

AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	WITH LIST AS
	(
		SELECT RES_CODE, 0 AS [SEQ_NO], HIS_SEQ, HIS_CODE, HIS_DATE 
		FROM RES_MASTER_HISTORY
		WHERE RES_CODE = @RES_CODE
		UNION ALL
		SELECT RES_CODE, SEQ_NO, HIS_SEQ, HIS_CODE, HIS_DATE 
		FROM RES_CUSTOMER_HISTORY
		WHERE RES_CODE = @RES_CODE
	)
	SELECT 
		ROW_NUMBER() OVER (ORDER BY A.HIS_DATE ASC) AS [ROWNUMBER],
		A.*,
		[DBO].[XN_COM_GET_EMP_NAME](A.HIS_CODE) AS [HIS_NAME],
		[DBO].[XN_COM_GET_TEAM_NAME](A.HIS_CODE) AS [HIS_TEAM_NAME]
	FROM LIST A
	ORDER BY A.HIS_DATE DESC

END


GO
