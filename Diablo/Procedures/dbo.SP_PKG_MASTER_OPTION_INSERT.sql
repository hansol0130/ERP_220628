USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PKG_MASTER_OPTION_INSERT
■ DESCRIPTION				: 마스터 옵션정보 입력
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
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PKG_MASTER_OPTION_INSERT]
	@MASTER_CODE VARCHAR(10),
	@OPT_SEQ INT,
	@OPT_NAME VARCHAR(50),
	@OPT_CONTENT VARCHAR(50),
	@OPT_PRICE VARCHAR(20),
	@OPT_USETIME VARCHAR(20),
	@OPT_REPLACE VARCHAR(50),
	@OPT_PLACE VARCHAR(50),
	@OPT_COMPANION VARCHAR(30)
AS 
BEGIN	
	SET NOCOUNT OFF;

	IF @OPT_SEQ = 0
	BEGIN
		SELECT @OPT_SEQ = ISNULL(MAX(OPT_SEQ), 0) + 1 FROM PKG_MASTER_OPTION WITH(NOLOCK) WHERE MASTER_CODE = @MASTER_CODE
	END
	
	INSERT INTO PKG_MASTER_OPTION ( MASTER_CODE, OPT_SEQ, OPT_NAME, OPT_CONTENT, OPT_PRICE, OPT_USETIME, OPT_REPLACE, OPT_PLACE, OPT_COMPANION )
	VALUES( @MASTER_CODE, @OPT_SEQ, @OPT_NAME, @OPT_CONTENT, @OPT_PRICE, @OPT_USETIME, @OPT_REPLACE, @OPT_PLACE, @OPT_COMPANION )
END 


GO
