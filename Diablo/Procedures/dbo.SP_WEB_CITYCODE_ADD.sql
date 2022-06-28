USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ SERVER					: 211.115.202.203
■ DATABASE					: DIABLO
■ USP_NAME					: SP_WEB_CITYCODE_ADD
■ DESCRIPTION				: 도시코드를 추가한다
■ INPUT PARAMETER			:                  
		@PRO_CODE			: 행사코드   
■ OUTPUT PARAMETER			:                  
■ OUTPUT VALUE				:                 
■ EXEC						: EXEC SP_WEB_CITYCODE_ADD 'TT', '형민사랑', NULL, 'GM', '0000', NULL
■ AUTHOR					:   
■ DATE						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
									최초생성  
   2010-10-28		임형민			GMT_TIME 추가
   2011-08-01						INSERT PUB_CITY 테이블 컬럼지정
================================================================================================================*/

CREATE PROC [dbo].[SP_WEB_CITYCODE_ADD]
(
	@CITY_CODE				CHAR(3), 
	@KOR_NAME				VARCHAR(100),
	@ENG_NAME				VARCHAR(100),
	@NATION_CODE			CHAR(2),
	@STATE_CODE				VARCHAR(4),
	@GMT_TIME				VARCHAR(5)
)

AS

	SET NOCOUNT ON

	BEGIN
		IF NOT EXISTS (SELECT CITY_CODE FROM PUB_CITY WHERE CITY_CODE = @CITY_CODE)
		BEGIN
			IF NOT EXISTS (SELECT KOR_NAME FROM PUB_CITY WHERE KOR_NAME = @KOR_NAME AND NATION_CODE = @NATION_CODE AND STATE_CODE = @STATE_CODE)
			BEGIN
				IF @CITY_CODE IS NULL OR LEN(@CITY_CODE) = 0
				BEGIN
					SELECT @CITY_CODE = CAST(RIGHT(ISNULL(MAX(CITY_CODE), '0'), 2)+1 AS VARCHAR)
					FROM PUB_CITY 
					WHERE NATION_CODE = @NATION_CODE AND CITY_CODE LIKE '' + LEFT(@NATION_CODE, 1) + '[0-9]%' 
					
					IF @GMT_TIME IS NULL
					BEGIN
						SELECT TOP 1 @GMT_TIME = GMT_TIME
						FROM PUB_CITY 
						WHERE NATION_CODE = @NATION_CODE AND GMT_TIME IS NOT NULL
					END

					IF @CITY_CODE < 10 
						SET @CITY_CODE = LEFT(@NATION_CODE, 1) + '0' + CAST(@CITY_CODE AS VARCHAR)
					ELSE
						SET @CITY_CODE = LEFT(@NATION_CODE, 1) + @CITY_CODE
				END		
				
				INSERT INTO PUB_CITY ( CITY_CODE , KOR_NAME, ENG_NAME,NATION_CODE,STATE_CODE,GMT_TIME, NEW_DATE, NEW_CODE ) 
				VALUES (@CITY_CODE, @KOR_NAME, @ENG_NAME, @NATION_CODE, @STATE_CODE, @GMT_TIME , GETDATE(), NULL)

				SELECT '도시코드 [' + @CITY_CODE + '] ' + @KOR_NAME + ' 추가 되었습니다'
			END
			ELSE
			BEGIN
				SELECT '도시이름 ' + @KOR_NAME + '  있음'
			END
		END
		ELSE
		BEGIN
			SELECT '도시코드 [' + @CITY_CODE + '] 있음'
		END
	END

GO
