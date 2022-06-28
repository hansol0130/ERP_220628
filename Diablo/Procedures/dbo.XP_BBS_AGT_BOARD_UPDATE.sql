USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_BBS_AGT_BOARD_UPDATE
■ DESCRIPTION				: 대외업무시스템 게시물 수정
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
   2013-05-08		오인규			랜드사 알림사항게시판에서 사용될 지역 추가 , CATEGORY_GROUP 컬럼을 사용한다.
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[XP_BBS_AGT_BOARD_UPDATE]
	@BBS_SEQ		INT,
	@MASTER_SEQ		INT,
	@SUBJECT		VARCHAR(200),
	@CONTENTS		NVARCHAR(MAX),
	@NOTICE_YN		VARCHAR(1),
	@FILE_COUNT		INT,
	@FILE_PATH		VARCHAR(200),
	@IPADDRESS		VARCHAR(15),
	@SCOPE_TYPE		CHAR(1) ,
	@EDT_NAME		VARCHAR(20),
	@EDT_CODE		VARCHAR(7),
	@COM_STRING		VARCHAR(30),
	@CATEGORY_GROUP                CHAR(3)             -- 지역코드로 사용 
AS
BEGIN
	SET NOCOUNT OFF;

	BEGIN

		UPDATE BBS_DETAIL SET 
			[SUBJECT] = @SUBJECT,
			CONTENTS = @CONTENTS,
			NOTICE_YN = @NOTICE_YN,
			FILE_COUNT = @FILE_COUNT,
			FILE_PATH = @FILE_PATH,
			SCOPE_TYPE = @SCOPE_TYPE,
			EDT_CODE = @EDT_CODE,
			EDT_DATE = GETDATE(),
			EDT_NAME = @EDT_NAME,
			CATEGORY_GROUP = @CATEGORY_GROUP      
		WHERE MASTER_SEQ = @MASTER_SEQ AND BBS_SEQ = @BBS_SEQ

		-- 거래처 삭제
		DELETE FROM BBS_DETAIL_VIEW WHERE MASTER_SEQ = @MASTER_SEQ AND BBS_SEQ = @BBS_SEQ

		INSERT INTO BBS_DETAIL_VIEW (MASTER_SEQ, BBS_SEQ, COM_TYPE)
		SELECT @MASTER_SEQ, @BBS_SEQ, CONVERT(INT, A.Data) FROM DBO.FN_SPLIT(@COM_STRING, ',') A

	END
END

GO
