USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:권윤경
-- Create date: 2008-03-18
-- Description:	휴가정보에서 사용일수 구하는 함수
-- =============================================
CREATE FUNCTION [dbo].[FN_SUM_HOLIDAY_USEDAY]
(
	@EMP_CODE char(7),
	@APPLY_YEAR  char(4),
	@HOLIDAY_TYPE char(1)
)
RETURNS Numeric(18,1)
AS

BEGIN
	DECLARE @USE_DAY Numeric(18,1);
	
	
	SELECT @USE_DAY=ISNULL(SUM(HOLIDAY_USE_DAY),0)  FROM EMP_HOLIDAY_HISTORY WITH(NOLOCK)  WHERE APPLY_YN='Y'
	AND EMP_CODE=@EMP_CODE AND  APPLY_YEAR=@APPLY_YEAR AND HOLIDAY_TYPE=@HOLIDAY_TYPE

	RETURN @USE_DAY

END



GO
