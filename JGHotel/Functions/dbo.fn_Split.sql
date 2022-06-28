USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_Split](@sText varchar(8000), @sDelim varchar(20) ='#')  
 RETURNS @retArray  
 TABLE  
 (  
  idx smallint Primary Key,  
  value varchar(8000)
 )  
AS  
BEGIN  
 DECLARE @idx smallint,  
 @value varchar(8000),  
 @bcontinue bit,  
 @iStrike smallint,  
 @iDelimlength tinyint
   
 SET @idx = 1  
 SET @sText = LTrim(RTrim(@sText))  
 SET @iDelimlength = LEN(@sDelim)  
 SET @bcontinue = 1  
 WHILE @bcontinue = 1  
	BEGIN  

		--텍스트에서 구분자를 발견하면, 첫 번째 요소를 반환하고  
		--반환되는 테이블에 인덱스를 입력한다.  
		IF CHARINDEX(@sDelim, @sText)>0  
			BEGIN  
				-- 첫 번째 요소를 반환  
				SET @value = SUBSTRING(@sText,1, CHARINDEX
(@sDelim,@sText)-1)  
				
				INSERT @retArray (idx, value) VALUES (@idx, @value)  


				--다음 요소와 구분자를 문자열의 앞에서부터 제거하고,  
				--index를 증가시키고 반복작업(loop)을 이어간다.  
				SET @iStrike = LEN(@value) + @iDelimlength  
				SET @idx = @idx + 1  
				SET @sText = LTrim(Right(@sText,LEN(@sText) - @iStrike))  
			END
		ELSE  
			BEGIN  
				--만약 텍스트 안에서 구분자를 더 이상 찾을 수 없게 되면,   
				--@sText가 @retArray의 마지막 값이다.  
				SET @value = @sText  
				-- 마지막 값도 구분자로 나누어져 있으뎐  
				INSERT @retArray (idx, value) VALUES (@idx, @value)  

				--WHILE 루프를 빠져 나온다.  
				SET @bcontinue = 0  
			END  
	END  
	RETURN  
END




GO
