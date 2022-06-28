USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PKG_DETAIL_OPTION_INSERT
■ DESCRIPTION				: 행사 옵션정보 입력
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-07-25		정지용
   2017-07-10		박형만		@OPT_CONTENT -> VARCHAR(50) --> 500
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PKG_DETAIL_OPTION_INSERT]
	@PRO_CODE VARCHAR(20),
	@OPT_SEQ INT,
	@OPT_NAME VARCHAR(50),
	@OPT_CONTENT VARCHAR(400),
	@OPT_PRICE VARCHAR(40),
	@OPT_USETIME VARCHAR(40),
	@OPT_REPLACE VARCHAR(400),
	@OPT_PLACE VARCHAR(200),
	@OPT_COMPANION VARCHAR(30)
AS 
BEGIN	
	SET NOCOUNT OFF;

	IF @OPT_SEQ = 0
	BEGIN
		SELECT @OPT_SEQ = ISNULL(MAX(OPT_SEQ), 0) + 1 FROM PKG_DETAIL_OPTION WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE
	END
	
	INSERT INTO PKG_DETAIL_OPTION ( PRO_CODE, OPT_SEQ, OPT_NAME, OPT_CONTENT, OPT_PRICE, OPT_USETIME, OPT_REPLACE, OPT_PLACE, OPT_COMPANION )
	VALUES( @PRO_CODE, @OPT_SEQ, @OPT_NAME, @OPT_CONTENT, @OPT_PRICE, @OPT_USETIME, @OPT_REPLACE, @OPT_PLACE, @OPT_COMPANION )
END 




GO
