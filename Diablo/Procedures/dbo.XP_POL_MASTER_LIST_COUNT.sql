USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_POL_MASTER_LIST_COUNT
■ DESCRIPTION				: 폴 마스터 전체 갯수
■ INPUT PARAMETER			:
	@TARGET					: 폴대상
	@POL_TYPE				: 폴타입
	@START_DATE				: 시작날짜	
	@END_DATE				: 종료날짜
	@SUBJECT				: 제목
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_POL_MASTER_LIST_COUNT 3

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-10		이상일			최초생성
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[XP_POL_MASTER_LIST_COUNT]
(
	@TARGET			CHAR(1) = '',
	@POL_TYPE		CHAR(1) = '',
	@START_DATE		VARCHAR(10) = '',
	@END_DATE		VARCHAR(10) = '',
	@SUBJECT		VARCHAR(400) = ''
)
AS
BEGIN
	SELECT COUNT(MASTER_SEQ) AS TotalCount FROM POL_MASTER
	WHERE 1=1
	AND	
	(
		(@TARGET = '' AND 1=1)
		OR
		(@TARGET <> '' AND TARGET = @TARGET)
	)
	AND	
	(
		(@POL_TYPE = '' AND 1=1)
		OR
		(@POL_TYPE <> '' AND POL_TYPE = @POL_TYPE)
	)
	AND	
	(
		(@START_DATE = '' AND 1=1)
		OR
		(@START_DATE <> '' AND START_DATE > CONVERT(DATETIME, @START_DATE))
	)
	AND	
	(
		(@END_DATE = '' AND 1=1)
		OR
		(@END_DATE <> '' AND END_DATE < CONVERT(DATETIME, @END_DATE))
	)
	AND	
	(
		(@SUBJECT = '' AND 1=1)
		OR
		(@SUBJECT <> '' AND SUBJECT like '%@SUBJECT%')
	)
	AND DEL_FLAG = 'N'
END

GO
