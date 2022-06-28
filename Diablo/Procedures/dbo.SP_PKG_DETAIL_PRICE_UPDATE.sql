USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_PKG_DETAIL_PRICE_UPDATE
■ DESCRIPTION				: 행사 가격 일괄 수정
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE					AUTHOR				DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2010-01-11		    김성호			    최초 생성
   2016-06-09		    김성호			    행사코드 검색 조건 BIT_CODE 추가
   2017-09-07		    김성호			    BIT_CODE NULL 일 경우 ISNULL 처리
   2018-10-11		    김성호			    가격일괄수정 항공사 조건 추가
   2018-11-01		    김남훈			    가격일괄수정 항공 편 번호 추가
   2019-05-09		    김남훈			    가격일괄수정 항공 편 로깅 추가
   2019-12-18			박형만				WHERE 문 분리 , 네이버 상품수정히스토리에 넣기
   2020-05-11			김영민				포인트일괄수정 조건 추가
   2020-06-24			김영민				포인트일괄수정에따른 포인트율 포인트가격 입력
   2021-03-04			오준혁				네이버 연동 관련 제거
   2021-11-19			김성호				트립토파즈 연동 등록 추가
   2021-12-01			김성호				제휴 대상 체크 dbo.PKG_MASTER_AFFILIATE
   2022-04-27			김성호				트립토파즈 연동 시 금일 이후 출발일 조건 추가
   2022-04-28           이장훈              저장 에러 발생으로 A.DEP_DATE  ->  B.DEP_DATE 변경 
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_PKG_DETAIL_PRICE_UPDATE]
	@BASE_MASTER_CODE	VARCHAR(8000),
	@PRICE				INT,
	@PRICE_RATE			DECIMAL,
	@AGE_TYPE			VARCHAR(3),
	@MAX_COUNT			INT,
	@MIN_COUNT			INT,
	@FAKE_COUNT			INT = 0,
	@RES_ADD_YN			CHAR(1),
	@BIT_CODE			VARCHAR(4),		-- 행사코드 구분 값
	@START				VARCHAR(10),	-- 복사시작일
	@END				VARCHAR(10),	-- 복사종료일
	@WEEK_DAY_TYPE		VARCHAR(7),		-- 요일
	@DAYS				VARCHAR(1000),	-- 일자들
	@UPDATE_TYPE		VARCHAR(10),	-- 복사타입 (첫?자리: 가격, 둘째자리: 최대인원, 셋째자리: 최소인원, 넷째자리: 예약가능여부)
	@EMP_CODE			CHAR(7),			-- 생성인코드
	@AIRLINE_CODE		VARCHAR(2),
	@AIRLINE_NUMBER		VARCHAR(4),
	@POINT_YN		    CHAR

AS
BEGIN
	 
	-- 트리거 동작 제외
	SET CONTEXT_INFO 0x21884680;

	SET NOCOUNT ON;

	DECLARE @SQLSTRING NVARCHAR(MAX) = '', @PARMDEFINITION NVARCHAR(MAX) = '',
			@PRICEQUERY NVARCHAR(300) = '', @COLUMNS NVARCHAR(100) = '',@RATEQUERY NVARCHAR(400) = '', @WHERE NVARCHAR(1000) = '', @MESSAGE VARCHAR(1000) = '',
			@ICOUNT INT = 1, @WEEK VARCHAR(20) = '';
	
	BEGIN TRY
		BEGIN TRAN

			-- 가격을 수정하면
			IF SUBSTRING(@UPDATE_TYPE, 1, 1) = '1'
			BEGIN
				
				IF @PRICE <> 0		-- 금액으로 가격 수정
				BEGIN
					IF SUBSTRING(@AGE_TYPE, 1, 1) = '1'
					BEGIN
						SET @PRICEQUERY = @PRICEQUERY + ', A.ADT_PRICE = (A.ADT_PRICE + @PRICE)'
					END
					IF SUBSTRING(@AGE_TYPE, 2, 1) = '1'
					BEGIN
						SET @PRICEQUERY = @PRICEQUERY + ', A.CHD_PRICE = (A.CHD_PRICE + @PRICE)'
					END
					IF SUBSTRING(@AGE_TYPE, 3, 1) = '1'
					BEGIN
						SET @PRICEQUERY = @PRICEQUERY + ', A.INF_PRICE = (A.INF_PRICE + @PRICE)'
					END
				END
				ELSE				-- 비율로 가격 수정
				BEGIN
					IF SUBSTRING(@AGE_TYPE, 1, 1) = '1'
					BEGIN
						SET @PRICEQUERY = @PRICEQUERY + ', A.ADT_PRICE = (A.ADT_PRICE + (A.ADT_PRICE * 0.01 * @PRICE_RATE))'
					END
					IF SUBSTRING(@AGE_TYPE, 2, 1) = '1'
					BEGIN
						SET @PRICEQUERY = @PRICEQUERY + ', A.CHD_PRICE = (A.CHD_PRICE + (A.CHD_PRICE * 0.01 * @PRICE_RATE))'
					END
					IF SUBSTRING(@AGE_TYPE, 3, 1) = '1'
					BEGIN
						SET @PRICEQUERY = @PRICEQUERY + ', A.INF_PRICE = (A.INF_PRICE + (A.INF_PRICE * 0.01 * @PRICE_RATE))'
					END
				END
			END


			-- 업데이트 항목 체크
			IF SUBSTRING(@UPDATE_TYPE, 2, 1) = '1'
			BEGIN
				-- 일자선택별 예약정보수정
				SET @COLUMNS = @COLUMNS + ', B.MAX_COUNT = @MAX_COUNT'
			END
			IF SUBSTRING(@UPDATE_TYPE, 3, 1) = '1'
			BEGIN
				-- 일자선택별 예약정보수정
				SET @COLUMNS = @COLUMNS + ', B.MIN_COUNT = @MIN_COUNT'
			END
			IF SUBSTRING(@UPDATE_TYPE, 4, 1) = '1'
			BEGIN
				-- 일자선택별 예약정보수정
				SET @COLUMNS = @COLUMNS + ', B.RES_ADD_YN = @RES_ADD_YN'
			END
			IF SUBSTRING(@UPDATE_TYPE, 5, 1) = '1'
			BEGIN
				-- 일자선택별 예약정보수정
				SET @COLUMNS = @COLUMNS + ', B.FAKE_COUNT = @FAKE_COUNT'
			END
		
		    --POINT 항목 체크
			IF SUBSTRING(@UPDATE_TYPE, 6, 1) = '1'
			BEGIN
				SET @RATEQUERY = @RATEQUERY + ', A.POINT_YN = @POINT_YN , A.POINT_PRICE =  FLOOR((A.ADT_PRICE + A.ADT_QCHARGE) * ( 0.01)) , A.POINT_RATE = 1.00'				
			END
			
		
			IF LEN(ISNULL(@DAYS, '')) > 0		-- 지정일자로 수정
			BEGIN
				--2019-12-18 WHERE 문 따로 뺌 
				SET @WHERE = N'WHERE B.MASTER_CODE IN (SELECT Data FROM dbo.FN_SPLIT(@BASE_MASTER_CODE, '',''))
						AND B.DEP_DATE IN (SELECT Data FROM dbo.FN_SPLIT(@DAYS, '',''))
						AND (@BIT_CODE = ''####'' OR B.PRO_CODE LIKE (''%[-][0-9][0-9][0-9][0-9][0-9][0-9]'' + ISNULL(@BIT_CODE, '''')))'

				IF LEN(@AIRLINE_CODE) = 2
				BEGIN
					SET @WHERE = @WHERE + ' AND C.DEP_TRANS_CODE = @AIRLINE_CODE'
					IF LEN(@AIRLINE_NUMBER) > 0
					BEGIN
						SET @WHERE = @WHERE + ' AND C.DEP_TRANS_NUMBER = @AIRLINE_NUMBER'
					END
				END

				
				-- 가격수정
				IF SUBSTRING(@UPDATE_TYPE, 1, 1) = '1' AND @PRICEQUERY <> ''
				BEGIN
					SET @SQLSTRING = @SQLSTRING + N'
					UPDATE A SET ' + SUBSTRING(@PRICEQUERY, 2, 1000) + N'
					FROM PKG_DETAIL_PRICE A
					INNER JOIN PKG_DETAIL B ON A.PRO_CODE = B.PRO_CODE
					LEFT JOIN PRO_TRANS_SEAT C ON B.SEAT_CODE = C.SEAT_CODE
					'+@WHERE
				END
				-- 가격이외 수정
				IF LEN(@COLUMNS) > 5
				BEGIN
					SET @SQLSTRING = @SQLSTRING + N'
					UPDATE B SET ' + SUBSTRING(@COLUMNS, 2, 100) + N'
					FROM PKG_DETAIL B
					LEFT JOIN PRO_TRANS_SEAT C ON B.SEAT_CODE = C.SEAT_CODE
					'+@WHERE
				END
				--포인트수정
				IF SUBSTRING(@UPDATE_TYPE, 6, 1) = '1' AND @RATEQUERY <> ''
				BEGIN
					SET @SQLSTRING = @SQLSTRING + N'
					UPDATE A SET ' + SUBSTRING(@RATEQUERY, 2, 1000) + N'
					FROM PKG_DETAIL_PRICE A
					INNER JOIN PKG_DETAIL B ON A.PRO_CODE = B.PRO_CODE
					LEFT JOIN PRO_TRANS_SEAT C ON B.SEAT_CODE = C.SEAT_CODE
					'+@WHERE
				END

				
			END
			ELSE								-- 기간으로 수정
			BEGIN

				IF @WEEK_DAY_TYPE <> '0000000'
				BEGIN
					-- 적용 요일 체크
					WHILE (@ICOUNT <= 7)
					BEGIN
						IF SUBSTRING(@WEEK_DAY_TYPE, @ICOUNT, 1) = '1'
						BEGIN
							SET @WEEK = @WEEK + ',' + CONVERT(VARCHAR(1), @ICOUNT)
						END

						SET @ICOUNT = (@ICOUNT + 1)
					END
					SET @WEEK = SUBSTRING(@WEEK, 2, 100)

					--2019-12-18 WHERE 문 따로 뺌 
					SET @WHERE = 'WHERE B.MASTER_CODE IN (SELECT Data FROM dbo.FN_SPLIT(@BASE_MASTER_CODE, '',''))
								AND B.DEP_DATE BETWEEN @START AND @END
								AND (@BIT_CODE = ''####'' OR B.PRO_CODE LIKE (''%[-][0-9][0-9][0-9][0-9][0-9][0-9]'' + ISNULL(@BIT_CODE, '''')))'

					IF LEN(@AIRLINE_CODE) = 2
					BEGIN
						SET @WHERE = @WHERE + ' AND C.DEP_TRANS_CODE = @AIRLINE_CODE'
						IF LEN(@AIRLINE_NUMBER) > 0
						BEGIN
							SET @WHERE = @WHERE + ' AND C.DEP_TRANS_NUMBER = @AIRLINE_NUMBER'
						END
					END

					-- 가격 수정
					IF SUBSTRING(@UPDATE_TYPE, 1, 1) = '1' AND @PRICEQUERY <> ''
					BEGIN
						SET @SQLSTRING = @SQLSTRING + N'
						UPDATE A SET' + SUBSTRING(@PRICEQUERY, 2, 1000) + N'
						FROM PKG_DETAIL_PRICE A
						INNER JOIN (
							SELECT B.PRO_CODE, DATEPART(WEEKDAY, B.DEP_DATE) AS [WEEK_DAY] 
							FROM PKG_DETAIL B WITH(NOLOCK)
							LEFT JOIN PRO_TRANS_SEAT C ON B.SEAT_CODE = C.SEAT_CODE
							' + @WHERE + N'
						) B ON A.PRO_CODE = B.PRO_CODE AND B.WEEK_DAY IN (SELECT Data FROM dbo.FN_SPLIT(@WEEK, '',''))'
					END

					-- 가격이외 수정
					IF LEN(@COLUMNS) > 5
					BEGIN
						SET @SQLSTRING = @SQLSTRING + N'
						UPDATE B SET ' + SUBSTRING(@COLUMNS, 2, 100) + N'
						FROM PKG_DETAIL B
						INNER JOIN (
							SELECT B.PRO_CODE, DATEPART(WEEKDAY, B.DEP_DATE) AS [WEEK_DAY] 
							FROM PKG_DETAIL B WITH(NOLOCK)
							LEFT JOIN PRO_TRANS_SEAT C ON B.SEAT_CODE = C.SEAT_CODE
							' + @WHERE + N'
						) C ON B.PRO_CODE = C.PRO_CODE AND C.WEEK_DAY IN (SELECT Data FROM dbo.FN_SPLIT(@WEEK, '',''))'
					END
					
					-- 포인트 수정
					IF SUBSTRING(@UPDATE_TYPE, 6, 1) = '1' AND @RATEQUERY <> ''
					BEGIN
						SET @SQLSTRING = @SQLSTRING + N'
						UPDATE A SET' + SUBSTRING(@RATEQUERY, 2, 1000) + N'
						FROM PKG_DETAIL_PRICE A
						INNER JOIN (
							SELECT B.PRO_CODE, DATEPART(WEEKDAY, B.DEP_DATE) AS [WEEK_DAY] 
							FROM PKG_DETAIL B WITH(NOLOCK)
							LEFT JOIN PRO_TRANS_SEAT C ON B.SEAT_CODE = C.SEAT_CODE
							' + @WHERE + N'
						) B ON A.PRO_CODE = B.PRO_CODE AND B.WEEK_DAY IN (SELECT Data FROM dbo.FN_SPLIT(@WEEK, '',''))'
					END
					
				END	-- 요일 체크
				
			END
			
			PRINT @SQLSTRING
			
			SET @PARMDEFINITION = N'
				@PRICE INT, 
				@PRICE_RATE DECIMAL, 
				@MAX_COUNT INT, 
				@MIN_COUNT INT, 
				@FAKE_COUNT INT,
				@RES_ADD_YN CHAR(1),
				@BASE_MASTER_CODE VARCHAR(8000),
				@BIT_CODE VARCHAR(4),
				@DAYS VARCHAR(1000),
				@START VARCHAR(10),
				@END VARCHAR(10),
				@WEEK VARCHAR(20),
				@AIRLINE_CODE VARCHAR(2),
				@AIRLINE_NUMBER VARCHAR(4),
				@EMP_CODE VARCHAR(7),
				@POINT_YN CHAR';

			--가격일괄 수정 추가 
			EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 
				@PRICE, 
				@PRICE_RATE, 
				@MAX_COUNT, 
				@MIN_COUNT, 
				@FAKE_COUNT,
				@RES_ADD_YN,
				@BASE_MASTER_CODE,
				@BIT_CODE,
				@DAYS,
				@START,
				@END,
				@WEEK,
				@AIRLINE_CODE,
				@AIRLINE_NUMBER,
				@EMP_CODE,
				@POINT_YN


			--------------------------------------------------------------------------------------
			-- 수정 히스토리에 등록 (네이버용) 2019-12
			-- 현재는 DYNAMIC(가격,상태)만 처리 하기 , 
			-- 추후 전체 처리로 바꿔야함
			DECLARE @SQLSTRING2 NVARCHAR(MAX) = ''
			
			SET @SQLSTRING2 = N'
			INSERT INTO NTT_PKG_DETAIL_UPDATE_TARGET (MASTER_CODE, PRO_CODE, PRICE_SEQ, NEW_CODE, NEW_DATE, BIT_CODE)
			SELECT A.MASTER_CODE, A.PRO_CODE, A.PRICE_SEQ, A.NEW_CODE, A.NEW_DATE, A.BIT_CODE
			FROM (
				SELECT DISTINCT B.MASTER_CODE, B.PRO_CODE, A.PRICE_SEQ, @EMP_CODE AS [NEW_CODE], GETDATE() AS [NEW_DATE]
					, ISNULL(SUBSTRING(B.PRO_CODE, (CHARINDEX(''-'', B.PRO_CODE)+7), 4), '''') AS [BIT_CODE]
				FROM PKG_DETAIL_PRICE A WITH(NOLOCK)
				INNER JOIN PKG_DETAIL B WITH(NOLOCK) ON A.PRO_CODE = B.PRO_CODE AND B.DEP_DATE > GETDATE()
				LEFT JOIN PRO_TRANS_SEAT C WITH(NOLOCK) ON B.SEAT_CODE = C.SEAT_CODE
				LEFT JOIN NTT_PKG_DETAIL_UPDATE_TARGET Z WITH(NOLOCK) ON B.PRO_CODE = Z.PRO_CODE AND A.PRICE_SEQ = Z.PRICE_SEQ AND Z.CHK_DATE IS NULL
				' + @WHERE + N' AND Z.SEQ_NO IS NULL
			) A
			INNER JOIN dbo.PKG_MASTER_AFFILIATE PMA WITH(NOLOCK) ON A.MASTER_CODE = PMA.MASTER_CODE AND A.BIT_CODE = PMA.BIT_CODE
				AND PMA.PROVIDER = 41 AND PMA.USE_YN = ''Y'';	-- 네이버'
			
--			PRINT @SQLSTRING2

			EXEC SP_EXECUTESQL @SQLSTRING2, @PARMDEFINITION, 
				@PRICE, 
				@PRICE_RATE, 
				@MAX_COUNT, 
				@MIN_COUNT, 
				@FAKE_COUNT,
				@RES_ADD_YN,
				@BASE_MASTER_CODE,
				@BIT_CODE,
				@DAYS,
				@START,
				@END,
				@WEEK,
				@AIRLINE_CODE,
				@AIRLINE_NUMBER,
				@EMP_CODE,
				@POINT_YN
			--------------------------------------------------------------------------------------

			
			-- 일괄 업데이트 로그 등록  --POINT_PRICE/POINT_RATEPOINT_YN 추가?
			INSERT SYS_PKG_UPDATE (
				BASE_MASTER_CODE, PRICE, PRICE_RATE, AGE_TYPE, MAX_COUNT, MIN_COUNT, FAKE_COUNT, RES_ADD_YN
				, START, [END], WEEK_DAY_TYPE, [DAYS], UPDATE_TYPE, EMP_CODE, NEW_DATE, AIRLINE_CODE, AIRLINE_NUMBER, POINT_YN
			) VALUES (
				@BASE_MASTER_CODE, @PRICE, @PRICE_RATE, @AGE_TYPE, @MAX_COUNT, @MIN_COUNT,@FAKE_COUNT, @RES_ADD_YN
				, @START, @END, @WEEK_DAY_TYPE, @DAYS, @UPDATE_TYPE, @EMP_CODE, GETDATE(), UPPER(@AIRLINE_CODE), @AIRLINE_NUMBER ,@POINT_YN 
			)
		
		COMMIT TRAN
		
		-- 트리거 예외처리 후 마스터 업데이트
		DECLARE @MASTER_CODE VARCHAR(10)
		
		DECLARE my_cursor CURSOR FAST_FORWARD READ_ONLY FOR
		SELECT DATA  FROM dbo.FN_SPLIT(@BASE_MASTER_CODE, ',')
		
		OPEN my_cursor
		
		FETCH FROM my_cursor INTO @MASTER_CODE
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			EXEC DBO.SP_PKG_MASTER_RESETTING @MASTER_CODE;
		
			FETCH FROM my_cursor INTO @MASTER_CODE
		END
		
		CLOSE my_cursor
		DEALLOCATE my_cursor
		
	END TRY
	BEGIN CATCH
	
		ROLLBACK TRAN
		
		SELECT @MESSAGE = ERROR_MESSAGE()
		
	END CATCH
	
	-- 결과 출력
	SELECT @MESSAGE
END


GO
