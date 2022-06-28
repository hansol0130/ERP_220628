USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
■ Function_Name				: [interface].[ZN_PUB_AIR_DECRYPT]
■ Description				: 항공 데이터 복호화
■ Input Parameter			: 

	@DATA	VARCHAR(8000)	: 암호화 할 문장
	@AUTH INT				: 인증키
	
■ Output Parameter			: 
■ Output Value				: 
■ Exec						: 
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2021-01-06		김성호			최초생성
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [interface].[ZN_PUB_AIR_DECRYPT]
(
	@DATA VARCHAR(8000),
	@AUTH	INT
)
RETURNS VARCHAR(8000)
AS
BEGIN
	RETURN(
		
		SELECT CONVERT(VARCHAR(8000), DECRYPTBYKEY(CONVERT(VARBINARY(8000), @DATA, 1), 1, CONVERT(VARBINARY, @AUTH)))
		
		--SELECT CONVERT(VARCHAR(8000), CONVERT(VARBINARY(8000), ( 
		--	'0x' + REPLACE((
		--	SELECT ';' + CONVERT(VARCHAR(8000), DECRYPTBYKEY(CONVERT(VARBINARY(8000), A.DATA, 1), 1, CONVERT(VARBINARY, @AUTH)), 1) 
		--	FROM [dbo].[FN_SPLIT] (@DATA, ';') A
		--	FOR XML PATH('')), ';0x', '')
		--	), 1))
	)
END
GO
