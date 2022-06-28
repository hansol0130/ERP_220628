USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_GET_TOUR_NIGHY_DAY_TEX
■ Description				: 마스터코드의 여행기간 반환
■ Input Parameter			:                  
		@MASTER_CODE		: 마스터코드
		@IS_ALL				: 조회 타입 0=가장최근하나만 ,1=전체여행기간(70일까지만)
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	SELECT DBO.FN_GET_TOUR_NIGHY_DAY_TEXT('EPP102', 0)
	SELECT DBO.FN_GET_TOUR_NIGHY_DAY_TEXT('EPP2600', 1)
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2010-06-15		박형만			최초생성
	2012-05-02		박형만			여행기간 2달 -> 70일로 변경
	2013-03-21		김성호			로직변경
	2014-07-16		김성호			활성화 행사 기준으로 변경
	2014-11-04		정지용			0일 일때 무박으로 변경
	2016-09-21		박형만			로직수정, 검색된 여행기간이 없을경우 최근으로 조회 
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_GET_TOUR_NIGHY_DAY_TEXT]
(
	@MASTER_CODE MASTER_CODE,
	@IS_ALL INT  -- 조회 타입 0=가장최근하나만 ,1=전체여행기간(70일까지만)
)
RETURNS VARCHAR(100)
AS
BEGIN

--DECLARE @MASTER_CODE MASTER_CODE 
--SET @MASTER_CODE = 'APP1231'
	
	DECLARE @RETVALUE VARCHAR(100)
	SET @RETVALUE = ''
	
	--IF( @IS_ALL = 0 )
	--BEGIN
	--	--SELECT TOP 1 @RETVALUE = CONVERT(VARCHAR,TOUR_NIGHT)+'박' + CONVERT(VARCHAR,TOUR_DAY)+'일'
	--	SELECT TOP 1 @RETVALUE = CASE TOUR_NIGHT WHEN 0 THEN '무' ELSE CONVERT(VARCHAR, TOUR_NIGHT) END +'박' + CONVERT(VARCHAR,TOUR_DAY)+'일'
	--	FROM PKG_DETAIL WITH(NOLOCK) WHERE MASTER_CODE = @MASTER_CODE
	--	AND DEP_DATE > DATEADD(D,-1,GETDATE())
	--	AND SHOW_YN = 'Y'  	
	--	ORDER BY DEP_DATE ASC 
	--END 
	--ELSE 
	--BEGIN
	--	SELECT @RETVALUE = STUFF((
	--		--SELECT (', ' + CONVERT(VARCHAR(3), TOUR_NIGHT) + '박' + CONVERT(VARCHAR(3), TOUR_DAY) + '일') AS [text()]
	--		SELECT (', ' + CASE TOUR_NIGHT WHEN 0 THEN '무' ELSE CONVERT(VARCHAR(3), TOUR_NIGHT) END +'박' + CONVERT(VARCHAR(3), TOUR_DAY) + '일') AS [text()]
	--		FROM PKG_DETAIL WITH(NOLOCK)
	--		WHERE MASTER_CODE = @MASTER_CODE AND DEP_DATE BETWEEN DATEADD(D,-1,GETDATE()) AND DATEADD(D,70,GETDATE()) AND SHOW_YN = 'Y'  
	--		GROUP BY TOUR_NIGHT, TOUR_DAY
	--		FOR XML PATH('')
	--	), 1, 2, '')
	--END 

	--전체기간일경우 
	IF( @IS_ALL = 1 )
	BEGIN
		SELECT @RETVALUE = STUFF((
			--SELECT (', ' + CONVERT(VARCHAR(3), TOUR_NIGHT) + '박' + CONVERT(VARCHAR(3), TOUR_DAY) + '일') AS [text()]
			SELECT (', ' + CASE TOUR_NIGHT WHEN 0 THEN '무' ELSE CONVERT(VARCHAR(3), TOUR_NIGHT) END +'박' + CONVERT(VARCHAR(3), TOUR_DAY) + '일') AS [text()]
			FROM PKG_DETAIL WITH(NOLOCK)
			WHERE MASTER_CODE = @MASTER_CODE AND DEP_DATE BETWEEN DATEADD(D,-1,GETDATE()) AND DATEADD(D,70,GETDATE()) AND SHOW_YN = 'Y'  
			GROUP BY TOUR_NIGHT, TOUR_DAY
			FOR XML PATH('')
		), 1, 2, '')

		
	END 


	IF ( @IS_ALL = 0 OR @RETVALUE IS NULL )   --최근한건 옵션 또는 위 검색 결과에서 찾지 못한경우 
	BEGIN
		--SELECT TOP 1 @RETVALUE = CONVERT(VARCHAR,TOUR_NIGHT)+'박' + CONVERT(VARCHAR,TOUR_DAY)+'일'
		SELECT TOP 1 @RETVALUE = CASE TOUR_NIGHT WHEN 0 THEN '무' ELSE CONVERT(VARCHAR, TOUR_NIGHT) END +'박' + CONVERT(VARCHAR,TOUR_DAY)+'일'
		FROM PKG_DETAIL WITH(NOLOCK) WHERE MASTER_CODE = @MASTER_CODE
		AND DEP_DATE > DATEADD(D,-1,GETDATE())
		AND SHOW_YN = 'Y'  	
		ORDER BY DEP_DATE ASC 
	END

		
	RETURN @RETVALUE 
END
GO
