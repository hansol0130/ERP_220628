USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_SAFE_INFO_TRAVEL_NOTICE_INSERT
■ DESCRIPTION				: 안전 정보 국가별 공지사항 입력
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	SELECT * FROM SAFE_INFO_COUNTRY_NOTICE;
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2015-12-28		정지용			최초생성
   2015-01-14		정지용			텍스트 내용 / HTML 내용
================================================================================================================*/ 
CREATE PROC [dbo].[XP_SAFE_INFO_TRAVEL_NOTICE_INSERT]
	@XML XML,
	@ISO_CODE VARCHAR(3)
AS 
BEGIN
	INSERT INTO SAFE_INFO_COUNTRY_NOTICE ( ID, NATION_CODE, TITLE, CONTENTS_HTML, CONTENTS, FILE_URL, WRT_DT, NEW_DATE )
	SELECT 
		t1.col.value('./id[1]', 'varchar(20)') as [id],
		t1.col.value('./isoCode[1]', 'varchar(3)') as [isoCode],
		t1.col.value('./title[1]', 'varchar(300)') as [title],
		t1.col.value('./ctntHtml[1]', 'varchar(max)') as [ctntHtml],
		t1.col.value('./ctntText[1]', 'varchar(max)') as [ctntText],
		t1.col.value('./fileUrl[1]', 'varchar(100)') as [fileUrl],
		t1.col.value('./wrtDt[1]', 'datetimeoffset') as [wrtDt],
		GETDATE()
	FROM @XML.nodes('/SafeInfoCountryNoticeItems/item') as t1(col) 
	WHERE t1.col.value('./id[1]', 'varchar(20)') NOT IN (SELECT ID FROM SAFE_INFO_COUNTRY_NOTICE WITH(NOLOCK) WHERE NATION_CODE = @ISO_CODE); 
END


GO
