USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_BBS_AGT_BOARD_INSERT
■ DESCRIPTION				: 대외업무시스템 게시물 등록
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-02-27		김성호			최초생성
   2013-03-12		김성호			마스터코드 값이 없을때 BBS_MASTER_AGT_LINK 테이블에서 해당 거래처 마스터코드 검색
   2013-05-08		오인규			랜드사 알림사항게시판에서 사용될 지역 추가 , CATEGORY_GROUP 컬럼을 사용한다.
   2013-06-10		김성호			WITH(NOLOCK) 추가
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[XP_BBS_AGT_BOARD_INSERT]
	@BBS_SEQ		INT OUTPUT,
	@MASTER_SEQ		INT OUTPUT,
	@SUBJECT		VARCHAR(200),
	@CONTENTS		NVARCHAR(MAX),
	@NOTICE_YN		VARCHAR(1),
	@FILE_COUNT		INT,
	@FILE_PATH		VARCHAR(200),
	@COMMENT_COUNT	INT,
	@IPADDRESS		VARCHAR(15),
	@SCOPE_TYPE		CHAR(1) ,
	@TEAM_NAME		VARCHAR(50),
	@TEAM_CODE		VARCHAR(3),
	@NEW_NAME		VARCHAR(20),
	@NEW_CODE		VARCHAR(7),
	@COM_STRING		VARCHAR(30),
	@CATEGORY_GROUP                CHAR(3)             -- 지역코드로 사용 
AS
BEGIN
	SET NOCOUNT OFF;

	IF ISNULL(@MASTER_SEQ, 0) = 0
	BEGIN
		SELECT @MASTER_SEQ = MASTER_SEQ FROM BBS_MASTER_AGT_LINK WITH(NOLOCK) WHERE AGT_CODE IN (SELECT AGT_CODE FROM AGT_MEMBER WITH(NOLOCK) WHERE MEM_CODE = @NEW_CODE)
	END

	DECLARE @COD_TYPE VARCHAR(10);
	
	BEGIN
		SET @COD_TYPE = ('B' + CAST(@MASTER_SEQ AS VARCHAR));

		EXEC [dbo].[SP_COD_GETSEQ_UNLIMITED] @COD_TYPE, @BBS_SEQ OUTPUT

		-- 게시물 등록
		INSERT INTO BBS_DETAIL (
			BBS_SEQ, MASTER_SEQ, SUBJECT, CONTENTS, NOTICE_YN, FILE_COUNT, FILE_PATH,
			COMMENT_COUNT, IPADDRESS, SCOPE_TYPE, TEAM_CODE, TEAM_NAME, NEW_NAME, NEW_CODE,CATEGORY_GROUP
		) VALUES (
			@BBS_SEQ, @MASTER_SEQ, @SUBJECT, @CONTENTS, @NOTICE_YN, @FILE_COUNT, @FILE_PATH,
			@COMMENT_COUNT, @IPADDRESS, @SCOPE_TYPE, @TEAM_CODE, @TEAM_NAME, @NEW_NAME, @NEW_CODE,@CATEGORY_GROUP
		)

		-- 게시물 권한관리
		INSERT INTO BBS_DETAIL_VIEW (MASTER_SEQ, BBS_SEQ, COM_TYPE)
		SELECT @MASTER_SEQ, @BBS_SEQ, CONVERT(INT, A.Data) FROM DBO.FN_SPLIT(@COM_STRING, ',') A

	END
END

GO
