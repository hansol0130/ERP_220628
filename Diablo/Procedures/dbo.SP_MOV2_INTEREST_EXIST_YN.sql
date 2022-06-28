USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_INTEREST_EXIST_YN
■ DESCRIPTION				: 검색_관심상품등록여부
■ INPUT PARAMETER			: CUS_NO, PRO_CODE
■ EXEC						: 
    -- exec SP_MOV2_INTEREST_EXIST_YN 8505125, 'APP6312'

■ MEMO						: 관심상품등록여부
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-09-09		IBSOLUTION				최초생성
   2017-09-29		정지용					순번 조회로 변경
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_INTEREST_EXIST_YN]
	@CUS_NO			INT,
	@PRO_CODE		VARCHAR(20)
AS
BEGIN

	SELECT 
		--COUNT(*) AS CNT 
		INT_SEQ
	FROM CUS_INTEREST WITH(NOLOCK) WHERE CUS_NO = @CUS_NO AND PRO_CODE = @PRO_CODE

END           



GO
