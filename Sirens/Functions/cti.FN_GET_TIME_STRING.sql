USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_GET_TIME_STRING
■ Description				: 초를 이용해 시간 표시
■ Input Parameter			: 
	@SEC INT				: 초
■ Exec						: 

	SELECT CTI.FN_GET_TIME_STRING(120)

---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2015-07-23		김성호			최초생성
	2015-11-29		김성호			시간 2자리 이상 처리
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [cti].[FN_GET_TIME_STRING]
(
	@SEC INT
)
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @TIME_STRING VARCHAR(20)
	SET @TIME_STRING = '';

	IF @SEC >= 360000
	BEGIN
		SELECT @TIME_STRING = CONVERT(VARCHAR(3), (@SEC / 360000)), @SEC = @SEC % 360000
		--SELECT @SEC = @SEC % 360000
	END

	SELECT @TIME_STRING = @TIME_STRING + (
		RIGHT(('00' + CONVERT(VARCHAR(2), (@SEC / 3600))), 2) + ':' + 
		RIGHT(('00' + CONVERT(VARCHAR(2), (@SEC % 3600 / 60))), 2) + ':' + 
		RIGHT(('00' + CONVERT(VARCHAR(2), (@SEC % 3600 % 60))), 2))
	
	RETURN (@TIME_STRING);
END

GO
