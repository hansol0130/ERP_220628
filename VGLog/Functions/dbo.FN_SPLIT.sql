USE [VGLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*-------------------------------------------------------------------------------------------------
■ Function_Name			: FN_SPLIT
■ Description				: split 기능 
■ Input Parameter			:                  
		@sText				: 대상 문자열
		@str				: 구분기호(Default '|')
		@idx				: 배열 인덱스
■ Select					: 
■ Author					: 
■ Date						:   
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
2019-04-09			이명훈			생성  
-------------------------------------------------------------------------------------------------*/

CREATE FUNCTION [dbo].[FN_SPLIT](
 @sText  VARCHAR(MAX),		 -- 대상 문자열
 @str   CHAR(1) = '|',       -- 구분기호(Default '|')
 @idx  INT                   -- 배열 인덱스

)
RETURNS VARCHAR(MAX)
AS
BEGIN
 DECLARE @word    VARCHAR(MAX),    -- 반환할 문자
      @sTextData  VARCHAR(MAX), 
      @num    SMALLINT;
     
 SET @num = 1;
 SET @str = LTRIM(RTRIM(@str));
 SET @sTextData = LTRIM(RTRIM(@sText)) + @str; 
 
 WHILE @idx >= @num
 BEGIN
 
  IF CHARINDEX(@str, @sTextData) > 0
  BEGIN
   -- 문자열의 인덱스 위치의 요소를 반환
   SET @word = SUBSTRING(@sTextData, 1, CHARINDEX(@str, @sTextData) - 1);
   SET @word = LTRIM(RTRIM(@word));
 
   -- 반환된 문자는 버린후 좌우공백 제거   
   SET @sTextData = LTRIM(RTRIM(RIGHT(@sTextData, LEN(@sTextData) - (LEN(@word) + 1))))
  END ELSE BEGIN
   SET @word = NULL;
  END
  SET @num = @num + 1
 END
 RETURN(@word);
END

GO
