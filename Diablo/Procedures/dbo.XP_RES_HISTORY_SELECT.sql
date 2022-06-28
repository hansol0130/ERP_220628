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
	@SEQ_NO		INT			: 출잘자 순번
	@HIS_SEQ	INT			: 히스토리 순번
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	exec XP_RES_HISTORY_LIST_SELECT 'RP1301229445'
	exec XP_RES_HISTORY_SELECT 'RP1301229445', 1, 'N'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-03-03		김성호			최초생성
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_RES_HISTORY_SELECT]
(
	@RES_CODE	VARCHAR(20),
	@HIS_SEQ	INT,
	@MASTER_YN	CHAR(1)
)

AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF @MASTER_YN = 'Y'
		SELECT * FROM RES_MASTER_HISTORY WHERE RES_CODE = @RES_CODE AND HIS_SEQ = @HIS_SEQ
	ELSE
		SELECT * FROM RES_CUSTOMER_HISTORY WHERE RES_CODE = @RES_CODE AND HIS_SEQ = @HIS_SEQ

END


GO
