USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		박형만
-- Create date: '2019-04-04'
-- Description:	문자열에서 숫자만 추출 
-- SELECT DBO.FN_GET_ONLY_NUMBER_FROM_STRING('1인 7만원') 
-- =============================================
CREATE FUNCTION [dbo].[FN_GET_ONLY_NUMBER_FROM_STRING]
(
	-- Add the parameters for the function here
	@VAL NVARCHAR(1000)
)
RETURNS INT
AS
BEGIN
	
	--DECLARE @VAL NVARCHAR(1000) 
	--SET @VAL = 'ASD3000유1로'

	DECLARE @TMPVAL NVARCHAR(1000)
	SET @TMPVAL = ''
	DECLARE @IDX INT
	SET @IDX = 1

	SET @VAL = REPLACE(@VAL,',','') -- 콤마제거 
	SET @VAL = REPLACE(@VAL,'1인','') -- 1인제거 
	SET @VAL = REPLACE(@VAL,'만원','0000원') -- 만원으로 
	WHILE @IDX <= LEN(@VAL)
	BEGIN
		DECLARE @CURVAL NVARCHAR(1) 
		SET @CURVAL = SUBSTRING(@VAL,@IDX,1) 

		-- 숫자일때 
		IF PATINDEX('%[0-9]%', @CURVAL) > 0 
		BEGIN
			SET @TMPVAL = @TMPVAL+ @CURVAL
		END 

		--영문일때 
		IF PATINDEX('%[^0-9]%', @CURVAL) > 0 
		BEGIN
			SET @TMPVAL = @TMPVAL+ ',' 
		END 
		--SELECT @IDX ,@CURVAL ,@TMPVAL 
		SET @IDX = @IDX + 1 
	END

	DECLARE @RET INT
	SET @RET = 0 
	IF ISNULL(@VAL ,'') <> '' 
	BEGIN
		SET @RET = ISNULL((SELECT TOP 1 DATA FROM DBO.FN_SPLIT(@TMPVAL,',') 
				WHERE DATA <> '' 
				ORDER BY ID),0) 
	END 
	
	RETURN @RET 
END

GO
