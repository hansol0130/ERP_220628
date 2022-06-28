USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_VGT_SHORTURL_INSERT
■ DESCRIPTION				: 단축 주소 입력
■ INPUT PARAMETER			: 
	@URL					: 주소
	@SHORTRUL				: 단축주소
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_VGT_SHORTURL_INSERT '', ''
	exec XP_VGT_SHORTURL_INSERT @URL='/Product/Package/PackageMaster?MasterCode=APP0456'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-04-17		박형만			최초생성
   2018-04-27		박형만			생성시 SEQ * 10  으로 운영 
================================================================================================================*/ 
CREATE  PROCEDURE [dbo].[XP_VGT_SHORTURL_INSERT]
(
	@URL		VARCHAR(1000)
)

AS  
BEGIN
	DECLARE @SEQ_NO INT 
	--SET @SEQ_NO = ISNULL((SELECT TOP 1 @SEQ_NO FROM  VGLOG.DBO.VGT_SHORTURL WITH(NOLOCK) 
	--	WHERE URL_KEY = @URL_KEY ORDER BY SEQ_NO DESC ) ,-1)
	--IF @SEQ_NO  = -1 
	--BEGIN 
		INSERT INTO VGLOG.DBO.VGT_SHORTURL (URL)
		VALUES (@URL)	
		SET @SEQ_NO = @@IDENTITY 

		DECLARE @URL_KEY VARCHAR(10)
		--SET @URL_KEY = dbo.XN_BASE62_ENCODING( CONVERT(INT, CONVERT(VARCHAR,CONVERT(INT, RAND() *10 ))+ CONVERT(VARCHAR,@SEQ_NO)) )
		SET @URL_KEY = dbo.XN_BASE62_ENCODING( @SEQ_NO * 10 ) -- 생성시 SEQ * 10 

		UPDATE VGLOG.DBO.VGT_SHORTURL  
		--SET URL_KEY  =  DBO.XN_BASE62_ENCODING( CONVERT(INT, RAND() *10 )+ @SEQ_NO) 
		SET URL_KEY  =   @URL_KEY
		WHERE SEQ_NO = @SEQ_NO 


		SELECT @URL_KEY

	--END 
	--SELECT @SEQ_NO 
END
GO
