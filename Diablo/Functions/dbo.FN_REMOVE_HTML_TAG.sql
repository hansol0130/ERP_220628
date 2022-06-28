USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* 2010-09-01 HTML 태그 제거 함수 
작성자:박형만 
*/
CREATE FUNCTION [dbo].[FN_REMOVE_HTML_TAG]
(
	@CONTENTS VARCHAR(8000)
)
RETURNS VARCHAR(8000)
AS
BEGIN
	
	--SET @CONTENTS = 'AAAAB<1234ASDFASDFFSD5>BBBBB<123>CCCCCC'
	IF( @CONTENTS IS NULL ) 
		RETURN NULL 
		
	DECLARE @TAG_LEN INT 
	--DECLARE @RET_CONTENTS VARCHAR(4000)
	--SET @RET_CONTENTS = @CONTENTS 
	DECLARE @CNT INT 
	SET @CNT = 0
	WHILE CHARINDEX( '<',@CONTENTS)  > 0 
	BEGIN
		IF( @CNT > 50000)
		BEGIN
			BREAK
		END 
	
		SET @TAG_LEN =  CHARINDEX( '>',@CONTENTS) - CHARINDEX( '<',@CONTENTS) + 1 
		IF( @TAG_LEN < 0 )
		BEGIN
			BREAK 
		END 
		SET @CONTENTS =  STUFF( @CONTENTS ,CHARINDEX( '<',@CONTENTS) , @TAG_LEN ,'')
		
		SET @CNT = @CNT + 1 
	END 
	RETURN @CONTENTS 
END
GO