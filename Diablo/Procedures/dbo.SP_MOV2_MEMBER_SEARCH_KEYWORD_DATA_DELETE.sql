USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*================================================================================================================
■ USP_NAME					: SP_MOV2_MEMBER_SEARCH_KEYWORD_DATA_DELETE
■ DESCRIPTION				: 검색 키워드 날짜 수정
■ INPUT PARAMETER			: 
	@KEYWORD_NO				: 키워드 번호
■ OUTPUT PARAMETER			: 
■ EXEC						: 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------

	2017-10-17		김성호			테이블 변경 및 삭제 방식 변경
================================================================================================================*/ 
CREATE PROC [dbo].[SP_MOV2_MEMBER_SEARCH_KEYWORD_DATA_DELETE]
	@CUSTOMER_NO	INT,
	@KEYWORD_NO		INT
AS 
BEGIN

	IF @KEYWORD_NO > 0
	BEGIN
		UPDATE VGLOG.DBO.KEYWORD_LOG SET CUS_NO = 0 WHERE SEQ_NO = @KEYWORD_NO
	END
	ELSE
	BEGIN
		UPDATE VGLOG.DBO.KEYWORD_LOG SET CUS_NO = 0 WHERE CUS_NO = @CUSTOMER_NO
	END
	
	--IF @KEYWORD_NO > 0
	--	BEGIN
	--		UPDATE LATEST_KEYWORD
	--		SET NEW_DATE = '1900-01-01'
	--		WHERE KEYWORD_NO = @KEYWORD_NO 
	--	END

	--ELSE
	--	BEGIN
	--		UPDATE LATEST_KEYWORD
	--		SET NEW_DATE = '1900-01-01'
	--		WHERE CUS_NO = @CUSTOMER_NO
	--	END

END 



GO
