USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_MOV2_PASSPORT_LIST_SELECT
■ DESCRIPTION				: 검색_출발자목록
■ INPUT PARAMETER			: RES_CODE, SEQ_NO
■ EXEC						: 
    -- exec SP_MOV2_PASSPORT_LIST_SELECT RP1708083004 

■ MEMO						: 검색_출발자목록(성인/아동/유아 구분필드 포함)
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-08-31		IBSOLUTION				최초생성
   2017-10-18		IBSOLUTION				예약자 여부 확인방식 변경
   2022-04-12		오준혁				    출발자도 예약자와 동일하게 처리
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_PASSPORT_LIST_SELECT]
	@RES_CODE	VARCHAR(20),
	@SEQ_NO		INT,
	@CUS_NO		INT
AS
BEGIN

	DECLARE @RES_CUS_NO INT;  --예약자 CUS_NO 
	DECLARE @SQLSTRING NVARCHAR(MAX);

	--예약자 조회
	SELECT @RES_CUS_NO = CUS_NO FROM RES_MASTER_damo A WITH(NOLOCK) WHERE A.RES_CODE = @RES_CODE

	IF(@CUS_NO = 0 AND @SEQ_NO =0)
	BEGIN
		SET @CUS_NO = @RES_CUS_NO
	END

	SET @SQLSTRING = '
		SELECT 
			A.RES_CODE, A.SEQ_NO, A.CUS_NO, A.CUS_NAME, 
			A.LAST_NAME, A.FIRST_NAME, A.GENDER,
			A.BIRTH_DATE, A.NOR_TEL1, A.NOR_TEL2, A.NOR_TEL3, B.EMAIL, A.AGE_TYPE,
			A.PASS_YN, damo.dbo.dec_varchar(''DIABLO'',''dbo.RES_CUSTOMER'',''PASS_NUM'', A.sec_PASS_NUM) AS PASS_NUM, A.PASS_EXPIRE, A.PASS_ISSUE,
			(SELECT TOP 1 P.PASS_STATUS FROM PPT_MASTER P WITH(NOLOCK) WHERE P.RES_CODE = A.RES_CODE AND P.RES_NO = A.SEQ_NO ORDER BY PPT_NO DESC) PASS_STATUS
		FROM RES_CUSTOMER_DAMO A WITH(NOLOCK) 
			LEFT JOIN CUS_CUSTOMER_DAMO B WITH(NOLOCK) 
				ON A.CUS_NO = B.CUS_NO   
		WHERE A.RES_CODE = ''' + @RES_CODE + '''
			AND A.RES_STATE = 0  --정상출발자만 
			AND A.VIEW_YN =''Y'' '

	/* 출발자도 예약자와 동일하게 처리
	IF @RES_CUS_NO <> @CUS_NO
		BEGIN
			SET @SQLSTRING = @SQLSTRING + ' AND SEQ_NO = ' + CONVERT(VARCHAR(5), @SEQ_NO);	
		END 
	*/

	--PRINT @SQLSTRING

	EXEC SP_EXECUTESQL @SQLSTRING
END           



GO
