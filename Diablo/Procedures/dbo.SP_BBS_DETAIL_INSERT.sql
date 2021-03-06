USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
2011-07-19 SP_COD_GETSEQ -> SP_COD_GETSEQ_UNLIMITED 사용으로 변경
*/
CREATE PROCEDURE [dbo].[SP_BBS_DETAIL_INSERT]
	@BBS_SEQ INT OUTPUT,
	@MASTER_SEQ INT,
	@CATEGORY_GROUP VARCHAR(3),
	@CATEGORY_SEQ	INT,
	@SUBJECT VARCHAR(200),
	@CONTENTS NVARCHAR(MAX),
	@PASSWORD VARCHAR(20),
	@NOTICE_YN VARCHAR(1),
	@ICON_SEQ INT,
	@FILE_COUNT INT,
	@FILE_PATH VARCHAR(200),
	@LEVEL INT,
	@COMMENT_COUNT INT,
	@PARENT_SEQ INT,
	@IPADDRESS VARCHAR(15) ,
	@SCOPE_TYPE CHAR(1) ,
	@TEAM_NAME VARCHAR(50),
	@TEAM_CODE VARCHAR(3),
	@NEW_NAME VARCHAR(20),
	@NEW_CODE VARCHAR(7)
	
AS
BEGIN
	SET NOCOUNT OFF;
	DECLARE @SEQ INT;
	DECLARE @COD_TYPE VARCHAR(10);
		
	BEGIN
			SET @COD_TYPE = ('B' + CAST(@MASTER_SEQ AS VARCHAR));

			EXEC	[dbo].[SP_COD_GETSEQ_UNLIMITED] @COD_TYPE, @BBS_SEQ OUTPUT

			INSERT INTO BBS_DETAIL
			(BBS_SEQ,MASTER_SEQ,SUBJECT,[PASSWORD],CATEGORY_GROUP,CATEGORY_SEQ,CONTENTS,NOTICE_YN,
			FILE_COUNT,FILE_PATH,COMMENT_COUNT,ICON_SEQ,LEVEL,PARENT_SEQ,IPADDRESS,SCOPE_TYPE,TEAM_CODE,TEAM_NAME,NEW_NAME,NEW_CODE)
			VALUES
			(@BBS_SEQ,@MASTER_SEQ,@SUBJECT,@PASSWORD,@CATEGORY_GROUP,@CATEGORY_SEQ,@CONTENTS,@NOTICE_YN,
			@FILE_COUNT,@FILE_PATH,@COMMENT_COUNT,@ICON_SEQ,@LEVEL,@PARENT_SEQ,@IPADDRESS,@SCOPE_TYPE,@TEAM_CODE,@TEAM_NAME,@NEW_NAME,@NEW_CODE)

	END
END
GO
