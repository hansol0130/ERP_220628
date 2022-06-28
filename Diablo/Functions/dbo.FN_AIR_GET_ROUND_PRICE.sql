USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	100단위로 반올림
-- =============================================
CREATE FUNCTION [dbo].[FN_AIR_GET_ROUND_PRICE]
(
	@PRICE	INT
)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @RESULT VARCHAR(20);
	
	DECLARE @STR_PRICE	VARCHAR(20),	@STR_LEFT	VARCHAR(20), 	@STR_RIGHT  VARCHAR(10),	@INDEX	INT;
	
	SET @STR_PRICE = CONVERT(CHAR(20), @PRICE);
	SET @INDEX = LEN(@STR_PRICE) - 2;

	IF @INDEX < 1
		SET @INDEX = 0;

	SET @STR_LEFT = SUBSTRING(@STR_PRICE, 1, @INDEX);
	SET @STR_RIGHT = SUBSTRING(@STR_PRICE, @INDEX + 1, LEN(@STR_PRICE));

	IF @STR_RIGHT > 0
	BEGIN
		SET @STR_LEFT = CONVERT(INT, @STR_LEFT) + 1;
		SET @STR_RIGHT = '00';
	END

	SET @RESULT = CONVERT(VARCHAR(20), @STR_LEFT + @STR_RIGHT);

	RETURN @RESULT;
END
GO
