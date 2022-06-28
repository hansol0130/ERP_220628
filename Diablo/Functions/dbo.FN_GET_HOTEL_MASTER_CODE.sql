USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이규식
-- Create date: 2011-05-14
-- Description:	호텔 마스터코드 생성을 위한 호텔마스터 코드를 얻어온다.
-- =============================================
CREATE FUNCTION [dbo].[FN_GET_HOTEL_MASTER_CODE]
(
	@BASE_CODE VARCHAR(10)
)
RETURNS VARCHAR(20)
AS
BEGIN
	
	-- Declare the return variable here
	DECLARE @MAX_CODE VARCHAR(20)
	DECLARE @MAX_NUM INT

	SELECT @MAX_CODE= MAX(MASTER_CODE) FROM HTL_MASTER WITH(NOLOCK) 
	WHERE MASTER_CODE LIKE @BASE_CODE + '%'
	
	IF @MAX_CODE IS NULL
	BEGIN
		SET @MAX_CODE = @BASE_CODE + '00001'
	END
	ELSE
	BEGIN
		SET @MAX_NUM = CAST(SUBSTRING(@MAX_CODE, 4, 5) AS INT) + 1
		SET @MAX_CODE = @BASE_CODE + RIGHT('00000' + CAST(@MAX_NUM AS VARCHAR), 5)
	END

	RETURN @MAX_CODE

END
GO
