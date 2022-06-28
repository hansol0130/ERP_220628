USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name			: DBO.FN_REMOVE_SPECIAL_CHARS
■ Description				: 특수문자 제거 함수 ( 한글 / 영문 / 숫자 / 기본 특수문자를 제외한 거 모두 제거 )
■ Input Parameter			:                  		
■ Select					: 
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2016-01-26       정지용			최초생성  
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_REMOVE_SPECIAL_CHARS] (
    @STRING_WORD VARCHAR(2000)
)
RETURNS VARCHAR(2000)
BEGIN

	IF @STRING_WORD IS NULL 
	BEGIN
        RETURN NULL;
    END
 
    DECLARE @TMP_STRING_WORD VARCHAR(2000)
	SET @TMP_STRING_WORD = '';

    DECLARE @STR_LEN INT;
	SET @STR_LEN = LEN(@STRING_WORD);

    DECLARE @STR_IDX INT
	SET @STR_IDX = 1;
 
    WHILE @STR_IDX <= @STR_LEN 
	BEGIN
        DECLARE @ASCII_IDX INT;
        SET @ASCII_IDX = ASCII(SUBSTRING(@STRING_WORD, @STR_IDX, 1));		
		
        IF (@ASCII_IDX BETWEEN 33 AND 47) -- 기본 특수문자
			OR (@ASCII_IDX BETWEEN 91 AND 96) -- -- 기본 특수문자
			OR (@ASCII_IDX BETWEEN 48 AND 57) -- 숫자
			OR (@ASCII_IDX BETWEEN 65 AND 90) -- 영문 대문자
			OR (@ASCII_IDX BETWEEN 97 AND 122) -- 영문 소문자
		BEGIN						
            SET @TMP_STRING_WORD = @TMP_STRING_WORD + CHAR(@ASCII_IDX);
        END
		ELSE IF (UNICODE(SUBSTRING(@STRING_WORD, @STR_IDX, 1)) >= 44032 AND UNICODE(SUBSTRING(@STRING_WORD, @STR_IDX, 1)) <= 55203)
		BEGIN
			SET @TMP_STRING_WORD = @TMP_STRING_WORD + SUBSTRING(@STRING_WORD, @STR_IDX, 1);
		END

        SET @STR_IDX = @STR_IDX + 1;
    END
 
    IF len(@TMP_STRING_WORD) = 0 
	BEGIN
        RETURN NULL;
    END

	RETURN @TMP_STRING_WORD;
END
GO
