USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PUB_JOINT_PROMOTION_MASTER_INSERT
■ DESCRIPTION				: 공동기획전 관리 마스터 입력
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2016-10-10		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PUB_JOINT_PROMOTION_MASTER_INSERT]
	@TYPE INT,
	@SUBJECT VARCHAR(50),
	@START_DATE DATETIME,
	@END_DATE DATETIME,
	@VIEW_YN CHAR(1),
	@TOP_URL VARCHAR(100),
	@NEW_CODE CHAR(7)
AS 
BEGIN
	DECLARE @JOINT_SEQ INT;
	SELECT @JOINT_SEQ = ISNULL(MAX(JOINT_SEQ), 0) + 1 FROM PUB_JOINT_MASTER WITH(NOLOCK)	

	INSERT INTO PUB_JOINT_MASTER ( 
		JOINT_SEQ, TYPE, SUBJECT, START_DATE, END_DATE, VIEW_YN,
		TOP_URL, READ_COUNT, NEW_CODE, NEW_DATE
	)
	VALUES 
	( 
		@JOINT_SEQ, @TYPE, @SUBJECT, @START_DATE, @END_DATE, @VIEW_YN,
		@TOP_URL, 0, @NEW_CODE, GETDATE()
	);

	SELECT @JOINT_SEQ;
END
	
GO
