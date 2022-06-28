USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_GET_TOUR_DAY
■ Description				: 마스터코드의 여행일수 검색 (지마켓,옥션 사용)
■ Input Parameter			:                  
		@MASTER_CODE		: 마스터코드
		@IS_ALL				: 조회 타입 0=가장최근하나만 ,1=전체여행기간(70일까지만)
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	SELECT DBO.FN_GET_TOUR_NIGHT('APP5000', 0)
	SELECT DBO.FN_GET_TOUR_DAY('APP5000', 0)
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2018-03-08		박형만			최초생성
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_GET_TOUR_DAY]
(
	@MASTER_CODE MASTER_CODE,
	@IS_ALL INT  -- 조회 타입 0=가장최근하나만 ,1=전체여행기간(70일까지만)
)
RETURNS VARCHAR(10)
AS
BEGIN

	DECLARE @RETVALUE VARCHAR(3)

	SET @RETVALUE = '0'
	
	IF( @IS_ALL = 0 )
	BEGIN
		SELECT TOP 1 @RETVALUE = CONVERT(VARCHAR(3),TOUR_DAY)
		FROM PKG_DETAIL WITH(NOLOCK)
		WHERE MASTER_CODE = @MASTER_CODE AND DEP_DATE > DATEADD(D,-1,GETDATE())	AND SHOW_YN = 'Y'  	
		ORDER BY DEP_DATE ASC 
	END 
	ELSE 
	BEGIN
		SELECT @RETVALUE = STUFF((
			SELECT (', ' + CONVERT(VARCHAR(3), TOUR_DAY)) AS [text()]
			FROM PKG_DETAIL WITH(NOLOCK)
			WHERE MASTER_CODE = @MASTER_CODE AND DEP_DATE BETWEEN DATEADD(D,-1,GETDATE()) AND DATEADD(D,70,GETDATE()) AND SHOW_YN = 'Y'  
			GROUP BY TOUR_DAY
			FOR XML PATH('')
		), 1, 2, '')
	END 
		
	RETURN @RETVALUE 
END
GO
