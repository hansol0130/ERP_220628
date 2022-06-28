USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================    
■ USP_Name			: SP_PKG_DETAIL_UPDATE_WITH_PKG_MASTER
■ Description		: 행사마스터기준 행사 수정
■ Input Parameter   : 
■ Output Parameter	:                      
■ Output Value		:                     
■ Exec				: 
■ Memo				:    
------------------------------------------------------------------------------------------------------------------    
■ Change History
------------------------------------------------------------------------------------------------------------------    
 Date   Author   Description               
------------------------------------------------------------------------------------------------------------------    
2010-03-18	김성호	최초생성
2014-06-25	김성호	총액표시제에 따른 스키마 수정 반영,6/30 공동경비삭제
2014-07-25	김성호	옵션 수정 추가
2015-05-29	박형만	쇼핑시간,비고 누락된것 추가
2015-06-26	김성호	BIT_CODE 무시 옵션 선택 시 옵션, 쇼핑도 정상적으로 복사 되도록 수정
2019-03-15  박형만	네이버관련 컬럼추가 
2019-12-24	박형만  상품수정히스토리에 넣기(네이버용)
2020-03-24	김성호	트리거 예외처리 추가 (트리거에 CONTEXT_INFO() 체크하여 트리거 무시하는 로직 추가 필요)
2021-12-19	김성호	네이버 연동 등록 제거, 트립토파즈 연동 등록 추가
================================================================================================================*/
CREATE PROCEDURE [dbo].[SP_PKG_DETAIL_UPDATE_WITH_PKG_MASTER]
	@MASTER_CODE		VARCHAR(20),	-- 마스터코드
	@BIT_CODE			VARCHAR(10),	-- 비트코드
	@START				VARCHAR(10),	-- 복사시작일
	@END				VARCHAR(10),	-- 복사종료일
	@WEEK_DAY_TYPE		VARCHAR(7),		-- 요일
	@DAYS				VARCHAR(1000),	-- 일자들		(사용X 지정일에서 사용)
	@UPDATE_TYPE		VARCHAR(10),	-- 복사타입 (1: 행사명, 2: 상품상세, 3: 리뷰, 4: 파일, 5: 가격/일정표)
	@EMP_CODE			CHAR(7),		-- 생성자코드
	@ARRAY_PRICE_SEQ	VARCHAR(30),	-- 신규등록 가격순번	EX) 1|2
	@ARRAY_SCH_SEQ		VARCHAR(30),	-- 스케줄 순번			EX) 2|3
	@ALL_PRODUCT_YN		CHAR(1)			-- BIT_CODE 무시 여부
AS
BEGIN
	
	-- 트리거 동작 제외
	SET CONTEXT_INFO 0x21884680;
	
	SET NOCOUNT ON;

	DECLARE @START_DATE DATETIME, @END_DATE DATETIME, @NEW_PRO_CODE VARCHAR(20), @RES_YN VARCHAR(1)

--	SELECT @BIT_CODE = SUBSTRING(PRO_CODE, 14, 10), @NEW_MASTER_CODE = MASTER_CODE

	SET @START_DATE = CONVERT(DATETIME, @START);
	SET @END_DATE = CONVERT(DATETIME, @END);
	SET @RES_YN = 'N';

	-- 임시테이블 선언
	CREATE TABLE #MSG_TEMP (
		[ERROR_SEQ] INT IDENTITY,	[ERROR_DATE] DATETIME,
		[ERROR_TYPE] INT,			[ERROR_MESSAGE] NVARCHAR(2048))
		
	-- 복사 가격 임시테이블 생성
	SELECT A.ID, A.DATA AS [PRICE_SEQ], B.DATA AS [SCH_SEQ]
	INTO #TMP_SCHEDULE
	FROM DBO.FN_SPLIT(@ARRAY_PRICE_SEQ, '|') A
	INNER JOIN DBO.FN_SPLIT(@ARRAY_SCH_SEQ, '|') B ON A.ID = B.ID

	-- 선택 기간동안
	WHILE (@END_DATE >= @START_DATE)
	BEGIN
		-- 요일이 일치하면
		IF '1' = SUBSTRING(@WEEK_DAY_TYPE, DATEPART(WEEKDAY, @START_DATE), 1)
		BEGIN
			-- 행사코드 생성
			IF @ALL_PRODUCT_YN = 'Y'
			BEGIN
				SET @NEW_PRO_CODE = (@MASTER_CODE + '-' + SUBSTRING(CONVERT(VARCHAR(10), @START_DATE, 112), 3, 10) + '%')
			END
			ELSE
			BEGIN
				SET @NEW_PRO_CODE = (@MASTER_CODE + '-' + SUBSTRING(CONVERT(VARCHAR(10), @START_DATE, 112), 3, 10) + ISNULL(@BIT_CODE, ''))
			END

			-- 행사가 존재하면
			IF EXISTS(SELECT 1 FROM PKG_DETAIL WHERE PRO_CODE LIKE @NEW_PRO_CODE)
			BEGIN
				BEGIN TRY
					BEGIN TRAN
					
					-- 행사명 체크시
					IF SUBSTRING(@UPDATE_TYPE, 1, 1) = '1'
					BEGIN
						UPDATE A SET
							A.PRO_NAME = B.MASTER_NAME, A.EDT_CODE = @EMP_CODE, EDT_DATE = GETDATE()
						FROM PKG_DETAIL A
						INNER JOIN PKG_MASTER B ON A.MASTER_CODE = B.MASTER_CODE
						WHERE A.PRO_CODE LIKE @NEW_PRO_CODE
					END

					-- 세부항목 체크시
					IF SUBSTRING(@UPDATE_TYPE, 2, 1) = '1'
					BEGIN
						UPDATE A SET
							A.AIRLINE = B.AIRLINE, A.PKG_SUMMARY = B.PKG_SUMMARY, A.PKG_INC_SPECIAL = B.PKG_INC_SPECIAL
							, A.PKG_CONTRACT = B.PKG_CONTRACT, A.PKG_REMARK = B.PKG_REMARK, A.RES_REMARK = B.RES_REMARK
							, A.SHOW_YN = B.SHOW_YN, A.EDT_CODE = @EMP_CODE, A.EDT_DATE = GETDATE(), A.PKG_TOUR_REMARK = B.PKG_TOUR_REMARK
							, A.PKG_PASSPORT_REMARK = B.PKG_PASSPORT_REMARK, A.PKG_SHOPPING_REMARK = B.PKG_SHOPPING_REMARK
							, A.TOUR_JOURNEY = B.TOUR_JOURNEY, A.HOTEL_REMARK = B.HOTEL_REMARK, A.OPTION_REMARK = B.OPTION_REMARK
						FROM PKG_DETAIL A
						INNER JOIN PKG_MASTER B ON A.MASTER_CODE = B.MASTER_CODE
						WHERE A.PRO_CODE LIKE @NEW_PRO_CODE

						-- 옵션정보
						DELETE FROM PKG_DETAIL_OPTION WHERE PRO_CODE LIKE @NEW_PRO_CODE

						INSERT INTO PKG_DETAIL_OPTION (PRO_CODE, OPT_SEQ, OPT_NAME, OPT_CONTENT, OPT_PRICE, OPT_USETIME, OPT_REPLACE, OPT_PLACE, OPT_COMPANION)
						SELECT B.PRO_CODE, A.OPT_SEQ, A.OPT_NAME, A.OPT_CONTENT, A.OPT_PRICE, A.OPT_USETIME, A.OPT_REPLACE, A.OPT_PLACE, A.OPT_COMPANION
						FROM PKG_MASTER_OPTION A WITH(NOLOCK)
						INNER JOIN PKG_DETAIL B WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE AND B.PRO_CODE LIKE @NEW_PRO_CODE
						WHERE A.MASTER_CODE = @MASTER_CODE

						-- 쇼핑정보
						DELETE FROM PKG_DETAIL_SHOPPING WHERE PRO_CODE LIKE @NEW_PRO_CODE

						INSERT INTO PKG_DETAIL_SHOPPING (PRO_CODE, SHOP_SEQ, SHOP_NAME, SHOP_PLACE, SHOP_TIME, SHOP_REMARK )
						SELECT B.PRO_CODE, SHOP_SEQ, SHOP_NAME, SHOP_PLACE , SHOP_TIME, SHOP_REMARK 
						FROM PKG_MASTER_SHOPPING A WITH(NOLOCK)
						INNER JOIN PKG_DETAIL B WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE AND B.PRO_CODE LIKE @NEW_PRO_CODE
						WHERE A.MASTER_CODE = @MASTER_CODE

						-- 셀링포인트 삭제후 복사 19.03 추가 
						DELETE FROM PKG_DETAIL_SELL_POINT WHERE PRO_CODE LIKE @NEW_PRO_CODE
						
						INSERT INTO PKG_DETAIL_SELL_POINT 
						(B.PRO_CODE,TRAFFIC_POINT,STAY_POINT,TOUR_POINT,EAT_POINT,DISCOUNT_POINT,OTHER_POINT)
						SELECT @NEW_PRO_CODE , TRAFFIC_POINT,STAY_POINT,TOUR_POINT,EAT_POINT,DISCOUNT_POINT,OTHER_POINT
						FROM PKG_MASTER_SELL_POINT A WITH(NOLOCK)
						INNER JOIN PKG_DETAIL B WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE AND B.PRO_CODE LIKE @NEW_PRO_CODE
						WHERE A.MASTER_CODE = @MASTER_CODE

					END
					
					-- 리뷰 체크시
					IF SUBSTRING(@UPDATE_TYPE, 3, 1) = '1'
					BEGIN
						UPDATE PKG_DETAIL SET
							PKG_REVIEW = B.PKG_REVIEW, EDT_CODE = @EMP_CODE, EDT_DATE = GETDATE()
						FROM PKG_DETAIL A
						INNER JOIN PKG_MASTER B ON A.MASTER_CODE = B.MASTER_CODE
						WHERE A.PRO_CODE LIKE @NEW_PRO_CODE
					END
					
					-- 파일 체크시
					IF SUBSTRING(@UPDATE_TYPE, 4, 1) = '1' AND @ALL_PRODUCT_YN = 'N'
					BEGIN
						DELETE FROM PKG_DETAIL_FILE WHERE PRO_CODE = @NEW_PRO_CODE
						INSERT INTO PKG_DETAIL_FILE
						SELECT @NEW_PRO_CODE, FILE_CODE, SHOW_ORDER
						FROM PKG_FILE_MANAGER WHERE MASTER_CODE = @MASTER_CODE
					END
					
					-- 가격 체크시
					IF SUBSTRING(@UPDATE_TYPE, 5, 1) = '1' AND @ALL_PRODUCT_YN = 'N'
					BEGIN
						
						--SET @RES_YN = 'N'
						
						IF NOT EXISTS(SELECT 1 FROM RES_MASTER_damo WHERE PRO_CODE = @NEW_PRO_CODE)
						BEGIN
							-- 스케줄 삭제 후 생성
							DELETE FROM PKG_DETAIL_SCH_MASTER WHERE PRO_CODE = @NEW_PRO_CODE
							
							EXEC [DBO].[SP_PKG_DETAIL_INSERT_NEW_SCHEDULE] @NEW_PRO_CODE
							
							-- 가격 삭제 후 생성
							--DELETE FROM PKG_DETAIL_PRICE_HOTEL FROM PRO_CODE = @NEW_PRO_CODE
							DELETE FROM PKG_DETAIL_PRICE WHERE PRO_CODE = @NEW_PRO_CODE

							-- 기존공동경비삭제
							DELETE FROM PKG_DETAIL_PRICE_GROUP_COST WHERE PRO_CODE = @NEW_PRO_CODE

							-- 기존 포함/불포함 삭제 19.03 추가 
							DELETE FROM PKG_DETAIL_PRICE_INOUT WHERE PRO_CODE = @NEW_PRO_CODE

							--SELECT A.ID, A.DATA AS [PRICE_SEQ], B.DATA AS [SCH_SEQ]
							--INTO #TMP_SCHEDULE
							--FROM DBO.FN_SPLIT(@ARRAY_PRICE_SEQ, '|') A
							--INNER JOIN DBO.FN_SPLIT(@ARRAY_SCH_SEQ, '|') B ON A.ID = B.ID
							
							DECLARE @COUNT INT, @PRICE_SEQ INT, @SCH_SEQ INT
							SET @COUNT = 1
							
							WHILE (EXISTS(SELECT 1 FROM #TMP_SCHEDULE WHERE ID = @COUNT))
							BEGIN
								SELECT @PRICE_SEQ = PRICE_SEQ, @SCH_SEQ = SCH_SEQ FROM #TMP_SCHEDULE WHERE ID = @COUNT
								--가격,공동경비,가격호텔정보 생성 
								EXEC [DBO].[SP_PKG_DETAIL_INSERT_NEW_PRICE_ONE] @MASTER_CODE, @NEW_PRO_CODE, @PRICE_SEQ, @SCH_SEQ
								
								SET @COUNT = @COUNT + 1
							END

							--DROP TABLE #TMP_SCHEDULE
						END
						ELSE
						BEGIN
							SET @RES_YN = 'Y'
						END
					END
					
					COMMIT TRAN
					
					IF @RES_YN = 'N'
					BEGIN
						-- LOG INSERT
						INSERT INTO #MSG_TEMP 
						SELECT @START_DATE, 1, '수정 성공'
					END
					ELSE
					BEGIN
						INSERT INTO #MSG_TEMP 
						SELECT @START_DATE, 3, (@NEW_PRO_CODE + ' 예약 존재')
					END

					--------------------------------------------------------------------------------------
					-- 트립토파즈 연동 등록
					--------------------------------------------------------------------------------------
					EXEC DBO.XP_NTT_PKG_DETAIL_TARGET_INSERT @PRO_CODE=@NEW_PRO_CODE, @EMP_CODE=@EMP_CODE
					--------------------------------------------------------------------------------------
					/*
					--------------------------------------------------------------------------------------
					-- 수정 히스토리에 등록 (네이버용) 2019-12
					-- 현재는 DYNAMIC(가격,상태)만 처리 하기 , 
					-- 추후 전체 처리로 바꿔야함
					DECLARE @IS_UPDATE_PRICE INT ,@IS_UPDATE_STATUS INT , @UPDATE_TARGET VARCHAR(20) 
					IF SUBSTRING(@UPDATE_TYPE, 5, 1) = '1' AND @ALL_PRODUCT_YN = 'N' -- 가격 
					BEGIN
						SET @IS_UPDATE_PRICE = 1 
						SET @UPDATE_TARGET = 'PRICE'
					END 
					IF SUBSTRING(@UPDATE_TYPE, 2, 1) = '1'  -- 세부항목 
					BEGIN
						SET @IS_UPDATE_STATUS = 1 
						SET @UPDATE_TARGET = 'STATUS'
					END 

					IF @IS_UPDATE_PRICE = 1  AND  @IS_UPDATE_STATUS  = 1 
					BEGIN 
						SET @UPDATE_TARGET = 'PRICESTATUS'
					END 

					IF ISNULL(@UPDATE_TARGET,'') <> ''
					BEGIN
						EXEC DBO.XP_NAVER_PKG_DETAIL_UPDATE_HISTORY_INSERT @NEW_PRO_CODE ,'UPDATEMST' ,@UPDATE_TARGET ,@EMP_CODE
					END
					--------------------------------------------------------------------------------------
					*/
					
				END TRY
				BEGIN CATCH

					ROLLBACK TRAN

					-- LOG INSERT
					INSERT INTO #MSG_TEMP 
					SELECT @START_DATE, 2, ERROR_MESSAGE()

				END CATCH
			END
			ELSE
			BEGIN
				-- LOG INSERT
				INSERT INTO #MSG_TEMP 
				SELECT @START_DATE, 2, (@NEW_PRO_CODE + ' 행사 없음')
			END
		END

		-- 날짜 증가
		SET @START_DATE = DATEADD(DAY, 1, @START_DATE)
	END
	
	-- 트리거 예외처리 후 마스터 업데이트
	EXEC DBO.SP_PKG_MASTER_RESETTING @MASTER_CODE;


	SELECT * FROM #MSG_TEMP

	DROP TABLE #TMP_SCHEDULE
	DROP TABLE #MSG_TEMP
END



GO
