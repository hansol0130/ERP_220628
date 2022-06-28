USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: FN_RES_GET_PROFIT_CODE
■ DESCRIPTION				: 실적담당자를 가져온다.
■ INPUT PARAMETER			: 
	@PRO_CODE				: 행사코드
	@EMP_CODE				: 사원코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	SELECT DBO.FN_RES_GET_PROFIT_CODE('KHH0HJ-150221', '2008011')

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
					이규식			최초생성
	2018-07-25		박형만			대전지점추가
	2019-02-12		이명훈			광주지점추가
================================================================================================================*/ 
CREATE FUNCTION [dbo].[FN_RES_GET_PROFIT_CODE]
(
	@PRO_CODE VARCHAR(20),
	@EMP_CODE VARCHAR(7)
)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @NEW_EMP_CODE CHAR(7);

	-- 부산지점(514), 대구지점(568) , 대전지점(624), 광주지점(627)
	IF EXISTS(SELECT 1 FROM EMP_MASTER_damo WITH(NOLOCK) WHERE EMP_CODE = @EMP_CODE AND TEAM_CODE IN ('514', '568', '624', '627'))
	BEGIN
		SET @NEW_EMP_CODE = @EMP_CODE
	END
	ELSE
	BEGIN
		SELECT @NEW_EMP_CODE = NEW_CODE FROM PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE
	END

	RETURN @NEW_EMP_CODE
END
GO
