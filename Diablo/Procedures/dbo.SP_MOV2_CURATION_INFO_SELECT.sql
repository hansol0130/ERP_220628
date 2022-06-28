USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_CURATION_INFO_SELECT
■ DESCRIPTION				: 검색_앱큐레이션목록
■ INPUT PARAMETER			: 
■ EXEC						: 
    -- SP_MOV2_CURATION_INFO_SELECT 	-- 검색_앱큐레이션목록

■ MEMO						: 큐레이션목록을 가져온다.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-05-29		오준욱(IBSOLUTION)		최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_CURATION_INFO_SELECT]
AS
BEGIN
	DECLARE @SQLSTRING NVARCHAR(4000)
	SET @SQLSTRING = N'
		SELECT C.CUR_NO, C.CUR_ITEM, C.CUR_TITLE, C.CUR_MESSAGE, C.CUR_ORDER, C.CUR_TYPE, C.CUR_LINK, 
			C.CUR_DAY, C.CUR_HOUR, C.CUR_MINUTE, C.CUR_BA, C.CUR_BASIC
		FROM CUR_INFO C WITH (NOLOCK) 
		WHERE C.USE_YN = ''Y'' 
		ORDER BY C.CUR_ORDER'
		
	EXEC SP_EXECUTESQL @SQLSTRING
END           



GO
