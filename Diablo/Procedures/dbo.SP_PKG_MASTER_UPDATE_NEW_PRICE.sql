USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ USP_Name					: SP_PKG_MASTER_UPDATE_NEW_PRICE  
■ Description				: 행사 마스터 가격 등록 및 수정    
■ Input Parameter			:                     
		@MASTER_CODE		:
		@PRICE_SEQ			:
		@PRICE_NAME			:
		@FLAG				:
■ Output Parameter			:                  
         @VISION_CONTENT	:
■ Output Value				:                 
■ Exec						: EXEC SP_PKG_MASTER_UPDATE_NEW_PRICE  
■ Author					:  
■ Date						:  
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
									최초생성
2015-06-26			김성호			@PRICE_NAME 형변환 NVARCHAR(50) -> NVARCHAR(60)
2019-03-15		박형만		네이버관련 컬럼추가 
-------------------------------------------------------------------------------------------------*/ 
CREATE PROCEDURE [dbo].[SP_PKG_MASTER_UPDATE_NEW_PRICE]
	@MASTER_CODE	VARCHAR(20),
	@PRICE_SEQ		INT,
	@PRICE_NAME		NVARCHAR(60),
	@FLAG			CHAR(1)
AS
BEGIN
	IF @FLAG = 'I'					-- 신규
	BEGIN
		DECLARE @NEW_PRICE_SEQ INT
		SELECT @NEW_PRICE_SEQ = ISNULL(MAX(PRICE_SEQ), 0) + 1 FROM PKG_MASTER_PRICE   WHERE MASTER_CODE = @MASTER_CODE;
		--SELECT TOP 1 @SCH_SEQ = SCH_SEQ FROM PKG_DETAIL_SCH_MASTER WHERE MASTER_CODE = @MASTER_CODE
		
		IF EXISTS(SELECT 1 FROM PKG_MASTER_PRICE   WHERE MASTER_CODE = @MASTER_CODE AND PRICE_SEQ = @PRICE_SEQ)
		BEGIN
			-- 행사 가격 정보 저장
			INSERT INTO PKG_MASTER_PRICE (MASTER_CODE, PRICE_SEQ, PRICE_NAME, SEASON, SCH_SEQ, PKG_INCLUDE
				, PKG_NOT_INCLUDE, ADT_PRICE, CHD_PRICE, INF_PRICE, SGL_PRICE, CUR_TYPE, EXC_RATE, FLOATING_YN
				, POINT_RATE, POINT_PRICE, POINT_YN)
			SELECT
				@MASTER_CODE, @NEW_PRICE_SEQ, @PRICE_NAME, A.SEASON, A.SCH_SEQ, A.PKG_INCLUDE, A.PKG_NOT_INCLUDE
				, A.ADT_PRICE, A.CHD_PRICE, A.INF_PRICE, A.SGL_PRICE, A.CUR_TYPE, A.EXC_RATE, A.FLOATING_YN
				, POINT_RATE, POINT_PRICE, POINT_YN
			FROM PKG_MASTER_PRICE A  
			WHERE MASTER_CODE = @MASTER_CODE AND PRICE_SEQ = @PRICE_SEQ

			-- 행사 호텔 세부 내역 저장
			INSERT INTO PKG_MASTER_PRICE_HOTEL (MASTER_CODE, PRICE_SEQ, DAY_NUMBER, HTL_MASTER_CODE, SUP_CODE, STAY_TYPE, STAY_INFO, DINNER_1, DINNER_2, DINNER_3,
				DINNER_CODE_1,DINNER_CODE_2,DINNER_CODE_3
			)
			SELECT
				@MASTER_CODE, @NEW_PRICE_SEQ, A.DAY_NUMBER, A.HTL_MASTER_CODE, A.SUP_CODE, A.STAY_TYPE, A.STAY_INFO, A.DINNER_1, A.DINNER_2, A.DINNER_3,
				A.DINNER_CODE_1,A.DINNER_CODE_2,A.DINNER_CODE_3
			FROM PKG_MASTER_PRICE_HOTEL A  
			WHERE MASTER_CODE = @MASTER_CODE AND PRICE_SEQ = @PRICE_SEQ
		END
		ELSE
		BEGIN
			-- 행사일정 마스터 저장
			INSERT INTO PKG_MASTER_PRICE (MASTER_CODE, PRICE_SEQ, PRICE_NAME, POINT_YN, POINT_RATE) VALUES (@MASTER_CODE, @NEW_PRICE_SEQ, @PRICE_NAME, 'Y', 0.00)
			
			DECLARE @TOURDAY INT, @SCHEDULEDAY INT
			SELECT @TOURDAY = ISNULL(TOUR_DAY, 0), @SCHEDULEDAY = 0 FROM PKG_MASTER   WHERE MASTER_CODE = @MASTER_CODE
			
			WHILE (@SCHEDULEDAY < @TOURDAY)
			BEGIN
				SET @SCHEDULEDAY = @SCHEDULEDAY + 1
				INSERT INTO PKG_MASTER_PRICE_HOTEL (MASTER_CODE, PRICE_SEQ, DAY_NUMBER) VALUES (@MASTER_CODE, @NEW_PRICE_SEQ, @SCHEDULEDAY);
			END
		END
		
		-- 일정 마스터 순번 리턴
		SELECT @NEW_PRICE_SEQ
	END
	ELSE								-- 수정
	BEGIN
		-- 행사 가격명 수정
		UPDATE PKG_MASTER_PRICE SET PRICE_NAME = @PRICE_NAME
		WHERE MASTER_CODE = @MASTER_CODE AND PRICE_SEQ = @PRICE_SEQ

		-- 일정 마스터 순번 리턴
		SELECT @PRICE_SEQ
	END
END







GO
