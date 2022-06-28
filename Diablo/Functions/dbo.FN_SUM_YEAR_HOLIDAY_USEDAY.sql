USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:설세민
-- Create date: 2008-05-16
-- Description:	휴가정보에서 연차로 HolidayType없이 사용일수 구하는 함수
-- =============================================
CREATE FUNCTION [dbo].[FN_SUM_YEAR_HOLIDAY_USEDAY]
(
	@EMP_CODE char(7),
	@APPLY_YEAR  char(4)
)
RETURNS Numeric(18,1)
AS

BEGIN
	DECLARE @USE_DAY Numeric(18,1);
	
	
	SELECT @USE_DAY=ISNULL(SUM(HOLIDAY_USE_DAY),0)  FROM EMP_HOLIDAY_HISTORY  WITH(NOLOCK) WHERE APPLY_YN='Y'
	AND EMP_CODE=@EMP_CODE AND  APPLY_YEAR=@APPLY_YEAR 

	RETURN @USE_DAY

END




GO
