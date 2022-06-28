USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name				: [interface].[ZN_PUB_AIR_ENCRYPT]
■ Description				: 항공 데이터 암호화 
■ Input Parameter			: 

	@DATA	VARCHAR(8000)	: 암호화 할 문장
	@@AUTH	INT				: 인증키

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
CREATE FUNCTION [interface].[ZN_PUB_AIR_ENCRYPT]
(
	@DATA	VARCHAR(700),		-- 입력 값 크기 제한 (734 Byte 암호화 시 7865 Byte 리턴)
	@AUTH	INT
)
RETURNS VARCHAR(8000)
AS
BEGIN
	RETURN(
		
		SELECT CONVERT(VARCHAR(8000), ENCRYPTBYKEY(KEY_GUID('SYM_TOPAS_AIR'), @DATA, 1, CONVERT(VARBINARY, @AUTH)), 1)
		
		--SELECT STUFF((
		--	SELECT ';' + CONVERT(VARCHAR(8000), ENCRYPTBYKEY(KEY_GUID('SYM_TOPAS_AIR'), SUBSTRING(CONVERT(VARBINARY(1000), @DATA), 16 * (N.SEQ - 1) + 1, 16), 1, CONVERT(VARBINARY, @AUTH)), 1)
		--	FROM   PUB_TMP_SEQ N
		--	WHERE  N.SEQ <= (DATALENGTH(@DATA) / 16 + 1)
		--	FOR XML PATH('')
		--), 1, 1, '')
	)
END
GO
