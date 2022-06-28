USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ARG_FILE_INSERT
■ DESCRIPTION				: 수배 문서 파일 저장
■ INPUT PARAMETER			: 
	@XML XML				: List<string> 타입의 xml 문자열
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_ARG_FILE_INSERT ''

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-03-21		김성호			최초생성
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_ARG_FILE_INSERT]
(
	@ARG_CODE VARCHAR(12),
	@GRP_SEQ_NO INT,
	@XML XML
)
AS  
BEGIN

	INSERT INTO ARG_FILE (ARG_CODE, GRP_SEQ_NO, FILE_NO, FILE_PATH)
	SELECT
		@ARG_CODE, @GRP_SEQ_NO
		, ROW_NUMBER() over(order by t1.col.value('.', 'nvarchar(200)'))
		, t1.col.value('.', 'nvarchar(200)') as [file_path]
	FROM @xml.nodes('/ArrayOfString/string') as t1(col)

END

/*
<ArrayOfString>
  <string>아자차</string>
  <string>가나다</string>
</ArrayOfString>
*/



GO
