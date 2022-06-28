USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_GET_MASTER_SUMMARY
■ Description				: 마스터코드 상세검색 집계값
■ Input Parameter			:                  
		@PRO_CODE			: 마스터코드
■ Output Parameter			: 
■ Output Value				: 
■ Exec						: 
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2019-12-09		프리랜서			최초생성
-------------------------------------------------------------------------------------------------*/ 
CREATE FUNCTION [dbo].[FN_GET_MASTER_SUMMARY]
(
		@MASTER_CODE	VARCHAR(10)
	,	@SEARCH_TYPE	VARCHAR(10)
)
RETURNS VARCHAR(255)
AS
BEGIN
	
	-- Declare the return variable here
	DECLARE @SUMMARY_VALUE VARCHAR(255)

	SELECT @SUMMARY_VALUE = 
	STUFF((
			SELECT  DISTINCT ',' + CONVERT(VARCHAR(10), SEARCH_VALUE) 
			FROM	(
						SELECT	ZZ.SEARCH_VALUE 
						FROM	DBO.PKG_MASTER_SUMMARY ZZ 
						WITH	(NOLOCK) 
						WHERE	ZZ.MASTER_CODE = @MASTER_CODE
						AND		ZZ.SEARCH_TYPE = @SEARCH_TYPE 
						GROUP BY ZZ.SEARCH_VALUE
						) A FOR XML PATH('')
			), 1, 1, '')

	-- 호텔은 최소3등급 리턴하도록 
	IF @SEARCH_TYPE = 'G' AND @SUMMARY_VALUE IS NULL
		BEGIN
			SET @SUMMARY_VALUE = '3'
		END

	RETURN @SUMMARY_VALUE

END
GO
