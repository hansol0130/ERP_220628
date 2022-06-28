USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ACR_MASTER_INSERT
■ DESCRIPTION				: 경위서 입력
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	DECLARE @COUNT INT
	exec XP_ACR_MASTER_INSERT 0, '92685' ,'CPP456-130531' ,'2013-05-31 00:00:00.000' ,'2013-06-02 00:00:00.000' ,'320','2013-05-31 00:00:00.000' ,'2013-06-02 00:00:00.000', 'L130145' ,'aaaaa' ,'9asdasdas sd <br>999a999', '', '', '', 'L130002'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-06-19		김완기			최초생성
   2014-01-14		김성호			쿼리수정
================================================================================================================*/ 
CREATE PROC [dbo].[XP_ACR_MASTER_INSERT]
	@ACR_SEQ_NO INT OUTPUT,
 	@AGT_CODE VARCHAR(10),
	@PRO_CODE VARCHAR(20),
	@DEP_DATE DATETIME,
	@ARR_DATE DATETIME,
	@REGION_CODE       varchar(3),
	@ACR_START_DATE    datetime,
	@ACR_END_DATE      datetime,
	@GUIDE_CODE        varchar(7),
	@TITLE             varchar(200),
	@CONTENT           NTEXT,
	@FILENAME1         varchar(200),
	@FILENAME2         varchar(200),
	@FILENAME3         varchar(200),
	@NEW_CODE          varchar(7)
AS 
BEGIN
	SET @ACR_SEQ_NO = 0

	INSERT INTO ACR_MASTER
		   (AGT_CODE       
		   ,PRO_CODE       
		   ,DEP_DATE       
		   ,ARR_DATE       
		   ,REGION_CODE    
		   ,ACR_START_DATE 
		   ,ACR_END_DATE
		   ,GUIDE_CODE
		   ,TITLE          
		   ,CONTENT      
		   ,FILENAME1      
		   ,FILENAME2      
		   ,FILENAME3      
		   ,NEW_CODE       
		   ,NEW_DATE)
	VALUES
		   (@AGT_CODE
		   ,@PRO_CODE       
		   ,@DEP_DATE       
		   ,@ARR_DATE       
		   ,@REGION_CODE    
		   ,@ACR_START_DATE 
		   ,@ACR_END_DATE   
		   ,@GUIDE_CODE
		   ,@TITLE          
		   ,@CONTENT      
		   ,@FILENAME1      
		   ,@FILENAME2      
		   ,@FILENAME3      
		   ,@NEW_CODE       
		   ,getdate())

	SET @ACR_SEQ_NO = SCOPE_IDENTITY()


	--SELECT @ACR_SEQ_NO
END 

GO
