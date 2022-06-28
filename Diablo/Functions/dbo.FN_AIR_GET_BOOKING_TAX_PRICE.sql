USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<발권 수수료를 가져온다.>
-- =============================================
CREATE FUNCTION [dbo].[FN_AIR_GET_BOOKING_TAX_PRICE]
(
	@REGION_CODE CHAR(3)
)
RETURNS INT
AS
BEGIN
	DECLARE @RESULT INT;

	SET @RESULT = (CASE WHEN @REGION_CODE IN ('310','320') THEN 5000  --일본,중국
						WHEN @REGION_CODE IN ('330','350','360') THEN 7000  --동남아,서인도,괌사이판
						WHEN @REGION_CODE IN ('340','110','120','130','140','210') THEN 15000 --유럽,미주,대양주
						WHEN @REGION_CODE IN ('220','230','370') THEN 20000 ELSE 5000 END);  --중남미,중동,아프리카

	RETURN @RESULT;
END

GO
