USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PUB_HOLIDAY_SELECT_LIST
■ DESCRIPTION				: 휴일 리스트 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 	
■ EXEC						: 
	EXEC SP_PUB_HOLIDAY_SELECT '2015-01', 'Y'
	SELECT * FROM PUB_HOLIDAY
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2015-01-19		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PUB_HOLIDAY_SELECT_LIST]
	@HOLIDAY VARCHAR(10),
	@IS_HOLIDAY CHAR(1)
AS 
BEGIN
	SELECT
		HOLIDAY, 
		HOLIDAY_NAME, 
		IS_HOLIDAY
	FROM PUB_HOLIDAY WITH(NOLOCK)
	WHERE 
		((@HOLIDAY = '') OR (HOLIDAY LIKE @HOLIDAY + '%')) 
		AND ((@IS_HOLIDAY = '') OR (IS_HOLIDAY = @IS_HOLIDAY))
	ORDER BY HOLIDAY ASC;
END

GO
