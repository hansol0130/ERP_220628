USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_CUVE_HISTORY_INSERT
■ DESCRIPTION				: 입력_큐비히스토리
■ INPUT PARAMETER			: CUS_NO, HIS_TYPE, HIS_TITLE, HIS_MESSAGE
■ EXEC						: 
    -- SP_MOV2_CUVE_HISTORY_INSERT 8712212, 3, 'title', 'message'		-- 큐비 히스토리 등록 

■ MEMO						: 큐비 히스토리에 입력한다.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-05-29		오준욱(IBSOLUTION)		최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_CUVE_HISTORY_INSERT]
	@CUR_NO			INT,
	@HIS_TYPE		INT,
	@HIS_TITLE		VARCHAR(100),
	@HIS_MESSAGE	VARCHAR(1000)
AS
BEGIN
	INSERT INTO CUVE_HISTORY ( CUR_NO, HIS_TYPE, HIS_TITLE, HIS_MESSAGE, NEW_DATE)
	VALUES ( @CUR_NO, @HIS_TYPE, @HIS_TITLE, @HIS_MESSAGE, GETDATE() )

	SELECT @@Identity
END           



GO
