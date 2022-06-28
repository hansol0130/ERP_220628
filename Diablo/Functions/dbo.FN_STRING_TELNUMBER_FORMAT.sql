USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name			: FN_STRING_TELNUMBER_FORMAT
■ Description				: 전화번호자리수에따른"-" 붙여주기
■ Input Parameter			:                  
■ Select					: 
	SELECT DBO.FN_STRING_TELNUMBER_FORMAT('022884000')
■ Author					: 
■ Date						:   
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
2018-05-28			정지용			최초생성  
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_STRING_TELNUMBER_FORMAT](
	@TEL_NUMBER VARCHAR(11)
)
RETURNS VARCHAR(13)
AS
BEGIN
	DECLARE @RETURN_VALUE VARCHAR(13);
	SET @TEL_NUMBER = LTRIM(RTRIM(@TEL_NUMBER));

	SET @RETURN_VALUE =
		CASE 
			WHEN LEFT(@TEL_NUMBER, 2) = '02'
				THEN
					CASE
						WHEN LEN(@TEL_NUMBER) = 9 THEN LEFT(@TEL_NUMBER, 2) + '-' + SUBSTRING(@TEL_NUMBER, 3, 3) + '-' + SUBSTRING(@TEL_NUMBER, 6, LEN(@TEL_NUMBER))
						WHEN LEN(@TEL_NUMBER) = 10 THEN LEFT(@TEL_NUMBER, 2) + '-' + SUBSTRING(@TEL_NUMBER, 3, 4) + '-' + SUBSTRING(@TEL_NUMBER, 7, LEN(@TEL_NUMBER))
					END
			WHEN LEFT(@TEL_NUMBER, 2) != '02'
				THEN
					CASE
						WHEN LEN(@TEL_NUMBER) = 10 THEN LEFT(@TEL_NUMBER, 3) + '-' + SUBSTRING(@TEL_NUMBER, 4, 3) + '-' + SUBSTRING(@TEL_NUMBER, 7, LEN(@TEL_NUMBER))
						WHEN LEN(@TEL_NUMBER) = 11 THEN LEFT(@TEL_NUMBER, 3) + '-' + SUBSTRING(@TEL_NUMBER, 4, 4) + '-' + SUBSTRING(@TEL_NUMBER, 8, LEN(@TEL_NUMBER))
					ELSE @TEL_NUMBER END
		ELSE @TEL_NUMBER END;


	RETURN @RETURN_VALUE;
END
GO
