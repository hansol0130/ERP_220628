USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<김성호>
-- Create date: <2009-08-12>
-- Description:	<마스터행사 일정 일자 변경>
--   2019-03-15		박형만 네이버관련 수정 
-- =============================================
CREATE PROCEDURE [dbo].[SP_PKG_MASTER_SCHEDULE_DAY_CHANGE]
	@MASTER_CODE	VARCHAR(10),
	@SCH_SEQ		INT,
	@DAY_NUMBER		INT,
	@EDT_CODE		VARCHAR(10)
AS
BEGIN
	DECLARE @TEMP_DAY_SEQ INT, @TEMP_DAY_NUMBER INT
	SELECT @TEMP_DAY_NUMBER = ISNULL(MAX(DAY_NUMBER), 0) FROM PKG_MASTER_SCH_DAY WHERE MASTER_CODE = @MASTER_CODE AND SCH_SEQ = @SCH_SEQ;
	
	-- 일정을 줄이면
	--IF (@DAY_NUMBER < @TEMP_DAY_NUMBER)
	--BEGIN
		-- 오버 스케줄 삭제
		DELETE FROM PKG_MASTER_SCH_DAY WHERE MASTER_CODE = @MASTER_CODE AND DAY_NUMBER > @DAY_NUMBER
		-- 오버 가격정보 삭제
		DELETE FROM PKG_MASTER_PRICE_HOTEL WHERE MASTER_CODE = @MASTER_CODE AND DAY_NUMBER > @DAY_NUMBER
	--END
	-- 일정을 늘리면
	--ELSE
	--BEGIN
		DECLARE @MASTER_SCH_SEQ INT, @MASTER_PRICE_SEQ INT
	
		-- 모자른 일자 추가
		DECLARE SCH_CURSOR CURSOR FOR
		SELECT SCH_SEQ FROM PKG_MASTER_SCH_MASTER WHERE MASTER_CODE = @MASTER_CODE
		
		OPEN SCH_CURSOR
		
		FETCH NEXT FROM SCH_CURSOR
		INTO @MASTER_SCH_SEQ
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @TEMP_DAY_NUMBER = ISNULL(MAX(DAY_NUMBER), 0) + 1 FROM PKG_MASTER_SCH_DAY WHERE MASTER_CODE = @MASTER_CODE AND SCH_SEQ = @MASTER_SCH_SEQ;
			SELECT @TEMP_DAY_SEQ = ISNULL(MAX(DAY_SEQ), 0) + 1 FROM PKG_MASTER_SCH_DAY WHERE MASTER_CODE = @MASTER_CODE AND SCH_SEQ = @MASTER_SCH_SEQ;
			
			--WHILE (@DAY_NUMBER < @TEMP_DAY_NUMBER)
			WHILE (@TEMP_DAY_NUMBER <= @DAY_NUMBER)
			BEGIN
				INSERT INTO PKG_MASTER_SCH_DAY (MASTER_CODE,SCH_SEQ,DAY_SEQ,DAY_NUMBER)  -- 컬럼명시 19.03 
				VALUES (@MASTER_CODE, @MASTER_SCH_SEQ, @TEMP_DAY_SEQ, @TEMP_DAY_NUMBER);
				SET @TEMP_DAY_NUMBER = @TEMP_DAY_NUMBER + 1
				SET @TEMP_DAY_SEQ = @TEMP_DAY_SEQ + 1
			END
		
			--PRINT @MASTER_SCH_SEQ
			
			FETCH NEXT FROM SCH_CURSOR
			INTO @MASTER_SCH_SEQ
		END
		CLOSE SCH_CURSOR
		DEALLOCATE SCH_CURSOR
		
		-- 모자른 가격 일자 추가
		DECLARE PRICE_CURSOR CURSOR FOR
		SELECT PRICE_SEQ FROM PKG_MASTER_PRICE WHERE MASTER_CODE = @MASTER_CODE
		
		OPEN PRICE_CURSOR
		
		FETCH NEXT FROM PRICE_CURSOR
		INTO @MASTER_PRICE_SEQ
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @TEMP_DAY_NUMBER = ISNULL(MAX(DAY_NUMBER), 0) + 1
			FROM PKG_MASTER_PRICE_HOTEL WHERE MASTER_CODE = @MASTER_CODE and PRICE_SEQ = @MASTER_PRICE_SEQ;
			
			--WHILE (@DAY_NUMBER < @TEMP_DAY_NUMBER)
			WHILE (@TEMP_DAY_NUMBER <= @DAY_NUMBER)
			BEGIN
				INSERT INTO PKG_MASTER_PRICE_HOTEL (MASTER_CODE, PRICE_SEQ, DAY_NUMBER) VALUES (@MASTER_CODE, @MASTER_PRICE_SEQ, @TEMP_DAY_NUMBER);
				SET @TEMP_DAY_NUMBER = @TEMP_DAY_NUMBER + 1
			END
		
			--PRINT @MASTER_SCH_SEQ
			
			FETCH NEXT FROM PRICE_CURSOR
			INTO @MASTER_PRICE_SEQ
		END
		CLOSE PRICE_CURSOR
		DEALLOCATE PRICE_CURSOR
	--END
	
	-- 마스터수정
	UPDATE PKG_MASTER SET TOUR_DAY = @DAY_NUMBER, EDT_DATE = GETDATE(), EDT_CODE = @EDT_CODE
	WHERE MASTER_CODE = @MASTER_CODE
END


GO
