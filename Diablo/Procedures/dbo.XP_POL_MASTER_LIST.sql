USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_POL_MASTER_LIST
■ DESCRIPTION				: 폴답변 등록
■ INPUT PARAMETER			:
	@PAGE					: 현재페이지
	@PAGESIZE				: 출력할페이지갯수
	@TARGET					: 폴대상
	@POL_TYPE				: 폴타입
	@START_DATE				: 시작날짜	
	@END_DATE				: 종료날짜
	@SUBJECT				: 제목
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_POL_MASTER_LIST 1, 10

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-10		이상일			최초생성
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[XP_POL_MASTER_LIST]
(
	@PAGE			INT,
	@PAGESIZE		INT,
	@TARGET			CHAR(1) = '',
	@POL_TYPE		CHAR(1) = '',
	@START_DATE		VARCHAR(10),
	@END_DATE		VARCHAR(10),
	@SUBJECT		VARCHAR(400) = '',
	@ORDER			VARCHAR(100) = 'MASTER_SEQ'
)
AS
BEGIN
	SELECT TOP (@PAGESIZE) MASTER_SEQ, TARGET, POL_TYPE, POL_STATE, SUBJECT, POL_DESC, START_DATE, END_DATE, OPEN_DATE, NEW_CODE, NEW_DATE,
	CASE TARGET
	WHEN '1' then '비회원'
	WHEN '2' then '회원'
	WHEN '3' then '내부'
	END as TARGET_NAME,
	CASE POL_TYPE
	WHEN '1' then '전체평가'
	WHEN '2' then '가이드평가'
	WHEN '3' then '호텔평가'
	WHEN '4' then '식사평가'
	WHEN '5' then '고객평가'
	WHEN '6' then '이벤트'
	END as POL_TYPE_NAME,
	CASE POL_STATE
	WHEN '1' then '진행중'
	WHEN '2' then '종료'
	END as POL_STATE_NAME,
	CONVERT(VARCHAR(10), START_DATE, 121) AS START_DATE_EX,
	CONVERT(VARCHAR(10), END_DATE, 121) AS END_DATE_EX,
	CONVERT(VARCHAR(10), OPEN_DATE, 121) AS OPEN_DATE_EX,
	CONVERT(VARCHAR(10), NEW_DATE, 121) AS NEW_DATE_EX
	FROM POL_MASTER
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
		(@START_DATE <> '' AND NEW_DATE > CONVERT(DATETIME, @START_DATE))
	)
	AND	
	(
		(@END_DATE = '' AND 1=1)
		OR
		(@END_DATE <> '' AND NEW_DATE < CONVERT(DATETIME, @END_DATE))
	)
	AND	
	(
		(@SUBJECT = '' AND 1=1)
		OR
		(@SUBJECT <> '' AND SUBJECT like '%@SUBJECT%')
	)
	AND DEL_FLAG = 'N'
	AND MASTER_SEQ NOT IN (	
	SELECT TOP (@PAGE) MASTER_SEQ FROM POL_MASTER
		WHERE  1=1
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
			(@START_DATE <> '' AND NEW_DATE > CONVERT(DATETIME, @START_DATE))
		)
		AND	
		(
			(@END_DATE = '' AND 1=1)
			OR
			(@END_DATE <> '' AND NEW_DATE < CONVERT(DATETIME, @END_DATE))
		)
		AND	
		(
			(@SUBJECT = '' AND 1=1)
			OR
			(@SUBJECT <> '' AND SUBJECT like '%@SUBJECT%')
		)
		AND DEL_FLAG = 'N'
		ORDER BY CASE @ORDER
			WHEN 'TARGET' then TARGET
			WHEN 'POL_TYPE' then POL_TYPE
		END
			DESC
	)
	ORDER BY CASE @ORDER
		WHEN 'TARGET' then TARGET
		WHEN 'POL_TYPE' then POL_TYPE
	END
		DESC
END

GO
