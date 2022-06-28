USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_EVT_RECOMMEND_CNT_SELECT
■ DESCRIPTION					: 알림톡예외처리
■ INPUT PARAMETER				: 
	@MASTER_CODE				: 마스터코드
	@PRO_CODE					: 상품코드
	@CHECK_CODE					: 예외처리코드 (예외처리를 위해 임의로 정의 된 키값)
								  
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    : 예외처리코드 history 관리
								  'RES01' - 20210618 / 홈쇼핑 상품 예외처리 (레드마인 #1455)
								  'RES01' - 20210625 / 홈쇼핑 상품 예외처리 (레드마인 #1463)
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2021-07-06		홍종우			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_ALIMTALK_CHECK_LIST_SELECT]
	@MASTER_CODE 			VARCHAR(10),
	@PRO_CODE 				VARCHAR(20),
	@CHECK_CODE 			VARCHAR(10)
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	SELECT COUNT(1)
	FROM   TMP_ALIMTALK_CHECK_LIST
	WHERE  CHECK_CODE = @CHECK_CODE
	       AND (MASTER_CODE = @MASTER_CODE OR PRO_CODE = @PRO_CODE)
END
GO
