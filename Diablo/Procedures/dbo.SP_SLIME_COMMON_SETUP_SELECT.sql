USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_SLIME_COMMON_SETUP_SELECT
■ DESCRIPTION				: 검색_고객설정정보
■ INPUT PARAMETER			: CUS_NO
■ EXEC						: 
    -- SP_SLIME_COMMON_SETUP_SELECT 8505125

■ MEMO						: 고객의 푸시여부, 큐비동작여부, 폰트 사이즈를 가져온다.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-07-25		오준욱(IBSOLUTION)		최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_SLIME_COMMON_SETUP_SELECT]
	@CUS_NO		VARCHAR(20)
AS
BEGIN
	SELECT A.PUSH_YN, A.CUVE_YN, A.FONT_SIZE 
		FROM CUS_MEMBER_OPTION A WITH (NOLOCK)
		WHERE A.CUS_NO = @CUS_NO
END           



GO
