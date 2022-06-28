USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: SP_MOV2_MEMBER_SEARCH_KEYWORD_INSERT
■ DESCRIPTION				: 검색 키워드 정보 저장.
■ INPUT PARAMETER			: 
	@CUSTOMER_NO			: 고객 번호
	@COOKIE_KEYWORD			: 쿠키 저장 검색 단어
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC SP_MOV2_MEMBER_SEARCH_KEYWORD_INSERT

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
										최초등록
	2017-10-17			김성호			키워드 등록
================================================================================================================*/ 
CREATE PROC [dbo].[SP_MOV2_MEMBER_SEARCH_KEYWORD_INSERT]
	@COOKIE_KEYWORD VARCHAR(50),
	@CUSTOMER_NO INT
AS 
BEGIN

	-- 회원이면서 이전 검색 결과가 있을때 등록
	IF @CUSTOMER_NO > 0 AND EXISTS(SELECT 1 FROM VGLOG.DBO.KEYWORD_LOG A WITH(NOLOCK) WHERE A.CUS_NO = @CUSTOMER_NO AND A.KEYWORD = @COOKIE_KEYWORD)
	BEGIN
		UPDATE VGLOG.DBO.KEYWORD_LOG SET NEW_DATE = GETDATE() WHERE SEQ_NO IN (
			SELECT TOP 1 SEQ_NO FROM VGLOG.DBO.KEYWORD_LOG AA WITH(NOLOCK) WHERE AA.CUS_NO = @CUSTOMER_NO AND AA.KEYWORD = @COOKIE_KEYWORD ORDER BY AA.NEW_DATE DESC
		)
	END
	ELSE
	BEGIN
		INSERT INTO VGLOG.DBO.KEYWORD_LOG (KEYWORD, CUS_NO, NEW_DATE)
		VALUES (@COOKIE_KEYWORD, @CUSTOMER_NO, GETDATE())
	END


	--IF(SELECT COUNT(*) FROM LATEST_KEYWORD WHERE CUS_NO = @CUSTOMER_NO AND KEYWORD = @COOKIE_KEYWORD) = 0 
	--	INSERT LATEST_KEYWORD
	--	(CUS_NO,KEYWORD,NEW_DATE)
	--	VALUES 
	--	(@CUSTOMER_NO, @COOKIE_KEYWORD,  GETDATE())
	--ELSE
	--	UPDATE LATEST_KEYWORD
	--	SET NEW_DATE = GETDATE()
	--	WHERE CUS_NO = @CUSTOMER_NO
	--		AND KEYWORD = @COOKIE_KEYWORD

END 


GO
