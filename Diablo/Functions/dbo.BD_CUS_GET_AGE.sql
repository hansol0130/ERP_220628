USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
■ Function_Name				: DBO.BD_CUS_GET_AGE
■ Description				: 생년월일로 나이 계산
■ Input Parameter						            
	@BIRTH_DATE				: 생년월일
	@DEP_DATE				: 기준일자 
	@AGE_TYPE				: 나이출력형식     
■ Exec						: 
	SELECT dbo.BD_CUS_GET_AGE(@BIRTH_DATE,@DEP_DATE, 0 ) --연령
	SELECT dbo.BD_CUS_GET_AGE(@BIRTH_DATE,@DEP_DATE, 1 )  --연령대 
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2015-08-13		윤병도			성호과장님이 주민번호 빼고 BIRTH DATE로만 구할 수 있게 바꿈
	2015-07-23		윤병도			형만대리님이 만들어줌. 
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[BD_CUS_GET_AGE]
(
	@BIRTH_DATE	DATETIME ,        -- 출발날짜 2010-04-15
	@DEP_DATE	DATETIME,
	@AGE_TYPE	INT	-- 0 - 전체, 1 - 10자리
)
RETURNS INT
AS
BEGIN

	DECLARE @TEMP_DATE DATETIME
	DECLARE @AGE INT
	SET @AGE = 0

	--출발일이 비었으면
	IF @DEP_DATE IS NULL
	BEGIN
		SET @DEP_DATE  = GETDATE()
	END 

	--생년월일 구하는 함수 
	SET @AGE = DBO.FN_CUS_GET_AGE_BY_BIRTH(@BIRTH_DATE ,@DEP_DATE)
	
	IF( @AGE > -1 )
	BEGIN 
		--연령대 구하기 
		IF @AGE_TYPE = 1 
		BEGIN
			IF @AGE < 20 
			BEGIN 
				SET @AGE = 19 
			END 
			ELSE 
			BEGIN 
				SET @AGE = @AGE - (@AGE % 10 ) 
			END 
		END 
	END 
	RETURN (@AGE);
END

GO
