USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_PRI_NOTE_INSERT
■ DESCRIPTION				: 대외업무시스템 사내메일 등록
■ INPUT PARAMETER			: 
	@SUBJECT	VARCHAR(300)
	@CONTENTS	NVARCHAR(MAX)
	@NEW_CODE	CHAR(7)
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	exec XP_PRI_NOTE_SELECT 617021, 130

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-02-20		김성호			최초생성
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_PRI_NOTE_INSERT]
(
	@SUBJECT	VARCHAR(300),
	@CONTENTS	NVARCHAR(MAX),
	@NEW_CODE	CHAR(7)
)
AS  
BEGIN

	-- INSERT_NOTE
	INSERT INTO PRI_NOTE(SUBJECT, CONTENTS, NEW_CODE)
	VALUES(@SUBJECT, @CONTENTS, @NEW_CODE);

	SELECT @@IDENTITY;

END




	

GO
