USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_CHECKLIST_SELECT
■ DESCRIPTION				: 검색_체크리스트값
■ INPUT PARAMETER			: RES_CODE, SEQ_NO
■ EXEC						: 
    -- SP_MOV2_CHECKLIST_SELECT 'RP1703032908', 1		-- 출발자(RP1703032908, 1) 검색_체크리스트값

■ MEMO						: 예약번호에 맞는 체크리스트값을 가져온다..
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-05-26		오준욱(IBSOLUTION)		최초생성
   2017-10-11		김성호					동적쿼리 제거
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_CHECKLIST_SELECT]
	@RES_CODE		VARCHAR(20),
	@SEQ_NO			VARCHAR(20)
AS
BEGIN

	SELECT A.CHECK_VALUE FROM TRAVEL_CHECKLIST A WITH (NOLOCK)
	WHERE A.RES_CODE = @RES_CODE AND A.SEQ_NO = @SEQ_NO


	--DECLARE @SQLSTRING NVARCHAR(4000)

	--SET @SQLSTRING = N'
	--	SELECT A.CHECK_VALUE FROM TRAVEL_CHECKLIST A WITH (NOLOCK)
	--	WHERE A.RES_CODE = ''' + @RES_CODE + ''' AND A.SEQ_NO = ' + @SEQ_NO

	---- PRINT @SQLSTRING
	--EXEC SP_EXECUTESQL @SQLSTRING
END           



GO
