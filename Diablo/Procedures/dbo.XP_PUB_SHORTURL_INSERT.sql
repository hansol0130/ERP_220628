USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_PUB_SHORTURL_INSERT
■ DESCRIPTION				: 단축 주소 입력
■ INPUT PARAMETER			: 
	@URL					: 주소
	@SHORTRUL				: 단축주소
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_PUB_SHORTURL_INSERT '', ''

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-07		김성호			최초생성
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_PUB_SHORTURL_INSERT]
(
	@URL		VARCHAR(1000),
	@SHORTURL	VARCHAR(100)
)

AS  
BEGIN
	INSERT INTO VGLOG.DBO.PUB_SHORTURL (URL, SHORTURL)
	VALUES (LOWER(@URL), @SHORTURL)

END

GO
