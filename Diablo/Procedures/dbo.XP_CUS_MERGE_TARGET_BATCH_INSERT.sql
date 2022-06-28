USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_CUS_MERGE_TARGET_BATCH_INSERT
■ DESCRIPTION				: 고객정보 매핑 통합 대상 배치 테이블 입력  함수_고객병합대상_일괄_등록
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 

SELECT TOP 100 * FROM CUS_CLEAR_TARGET WHERE DEP_DATE = '2018-06-18'

exec XP_CUS_MERGE_TARGET_BATCH_INSERT @TARGET_DATE='2018-06-19',@CUS_TYPE=0,@TARGET_CODE=''

XP_CUS_MERGE_TARGET_BATCH_INSERT '',0,'RP1510033970'
XP_CUS_MERGE_TARGET_BATCH_INSERT '2016-10-19',0,''

XP_CUS_MERGE_TARGET_BATCH_SELECT '2016-10-18',0,''
XP_CUS_MERGE_TARGET_BATCH_SELECT '2016-10-19',0,''
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2018-05-17		박형만			최초생성  
	2018-06-11		박형만			중복고객 합쳐 줄때  CUS_NO 1 인것 제외 
	2018-06-20		박형만			이름 금지어 수정 , 등록안되었거나 미처리인것만 갱신 대상 
	2018-07-06		박형만			공백제거 로직 추가 
	2018-08-23		김성호			 WITH(NOLOCK) 옵션 추가
	2018-10-10		박형만			휴대폰 자릿수 오류 해결 
	2018-10-24		박형만			이메일 자릿수 오류 해결 
	2018-11-20		박형만			2차휴대폰으로검색시 이름+휴대폰 검색이 아니라 이름+휴대폰+생년월일(null허용) 으로 검색 하고 있었음 (언제부터인지??)
	2020-12-03		김영민			고객병합 미처리 (RES_CUSTOMER_DAMO)출발자 번호없기때문에 CUS_CUSTOMER_DAMO - 전화번호 사용 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_CUS_MERGE_TARGET_BATCH_INSERT]
	@TARGET_DATE VARCHAR(10) ,
	@CUS_TYPE INT = 0 ,-- 0은 전체 , 1출발자  ,2예약자  -- 보통 출발자 처리후 , 예약자 처리 
	@TARGET_CODE RES_CODE = NULL -- 특정예약  
AS 
BEGIN 
SET NOCOUNT ON 

--DECLARE @TARGET_DATE DATETIME ,
--	@CUS_TYPE INT = 0 ,-- 0은 전체 , 1출발자  ,2예약자  -- 보통 출발자 처리후 , 예약자 처리 
--	@TARGET_CODE RES_CODE = NULL -- 특정예약 , 테스트용 
--SELECT @TARGET_DATE = '2018-10-20',@CUS_TYPE = 0 , @TARGET_CODE = '' 

IF ISNULL(@TARGET_CODE,'') <> ''  
BEGIN
	SET @TARGET_DATE  = (SELECT TOP 1 CONVERT(VARCHAR(10),DEP_DATE,121) FROM RES_MASTER_DAMO WITH(NOLOCK) WHERE RES_CODE = @TARGET_CODE)
END 

DECLARE @START_DATE DATETIME 
SET @START_DATE = CONVERT(DATETIME,@TARGET_DATE)

--DROP TABLE #TMP_TARGET_LIST 
CREATE TABLE #TMP_TARGET_LIST 
( PRO_CODE VARCHAR(40)
,DEP_DATE DATETIME
,RES_CODE VARCHAR(12)
,SEQ_NO INT 
,CUS_NO INT 
,CUS_NAME varchar(40)
,BIRTH_DATE DATETIME 
,PASS_NUM VARCHAR(20) 
,NOR_TEL1 VARCHAR(6),NOR_TEL2 VARCHAR(5),NOR_TEL3 VARCHAR(4)
,EMAIL VARCHAR(50)) 

	--출발자 병합매핑 대상 쿼리 
	IF @CUS_TYPE = 0 OR @CUS_TYPE = 1 
	BEGIN 
		INSERT INTO #TMP_TARGET_LIST 
		SELECT --TOP 20 
		A.PRO_CODE ,
		CONVERT(VARCHAR(10),A.DEP_DATE,121) AS DEP_DATE ,
		B.RES_CODE ,
		B.SEQ_NO,
		B.CUS_NO , 
		B.CUS_NAME,
		B.BIRTH_DATE,
		damo.dbo.dec_varchar('DIABLO', 'dbo.RES_CUSTOMER', 'PASS_NUM', B.SEC_PASS_NUM) AS PASS_NUM,
		--B.GENDER,
		--B.NOR_TEL1,B.NOR_TEL2,B.NOR_TEL3,
		CASE  WHEN  B.NOR_TEL1  IS NULL THEN Z.NOR_TEL1 ELSE B.NOR_TEL1 END AS NOR_TEL1 ,
		CASE  WHEN  B.NOR_TEL2  IS NULL THEN Z.NOR_TEL2 ELSE B.NOR_TEL2 END AS NOR_TEL2 ,
		CASE  WHEN  B.NOR_TEL3  IS NULL THEN Z.NOR_TEL3 ELSE B.NOR_TEL3 END AS NOR_TEL3 ,
		CASE WHEN LEN(B.EMAIL) > 40 THEN SUBSTRING(B.EMAIL,1,40) ELSE B.EMAIL END AS EMAIL
		--, C.ROW_SEQ ,C.STATUS 
		FROM RES_MASTER_DAMO A WITH (INDEX([IDX_RES_MASTER_3]))
			INNER JOIN RES_CUSTOMER_DAMO B WITH(NOLOCK)
				ON A.REs_CODE = B.RES_CODE 
			LEFT JOIN CUS_CUSTOMER_DAMO Z  WITH(NOLOCK) ON B.CUS_NO  = Z.CUS_NO	
			LEFT JOIN CUS_CLEAR_TARGET C   WITH(NOLOCK)-- 기존등록 
				ON B.RES_CODE = C.RES_CODE 
				AND B.SEq_NO = C.SEq_NO 
		--WHERE A.DEP_DATE >= '2017-09-01' AND A.DEP_DATE < '2017-09-02'-- 
		WHERE A.DEP_DATE >= @START_DATE AND A.DEP_DATE < DATEADD(DD,1,@START_DATE)
		AND A.RES_STATE NOT IN ( 7,8,9 ) AND B.RES_STATE = 0 -- 예약 .출발 상태 정상 
		AND A.PROVIDER <> 33 -- BTMS 제외 -- 기타 제휴사도 고려 
		--AND B.BIRTH_DATE IS NOT NULL --생년월일
		--AND ( (B.NOR_TEL2 IS NOT NULL AND B.NOR_TEL3 IS NOT NULL AND B.NOR_TEL2 <>'' AND B.NOR_TEL3 <>''
		--		AND B.NOR_TEL2 NOT IN ('000','0000') AND B.NOR_TEL3 NOT IN ('000'))  -- 전화번호 
		--	OR (B.SEC_PASS_NUM IS NOT NULL AND damo.dbo.dec_varchar('DIABLO', 'dbo.RES_CUSTOMER', 'PASS_NUM', B.SEC_PASS_NUM) <>  'M00000000' ) --  쓰레기 데이터 
		--	) 
		AND ( ISNULL(@TARGET_CODE,'') = '' OR A.RES_CODE =@TARGET_CODE)
		AND (C.ROW_SEQ IS NULL OR C.STATUS IN (0,2,3) ) -- 등록 안되어 있거나 미처리 상태인것만 갱신  6/29 처리실패인것도추가 
	END 
	--예약자 병합매핑 대상 쿼리 
	IF @CUS_TYPE = 0 OR @CUS_TYPE = 2 
	BEGIN
		--예약자 병합매핑 대상 쿼리
		INSERT INTO #TMP_TARGET_LIST 
		SELECT --TOP 20 
		A.PRO_CODE ,
		CONVERT(VARCHAR(10),A.DEP_DATE,121) AS DEP_DATE,
		A.RES_CODE ,
		0 AS SEQ_NO,
		A.CUS_NO , 
		A.RES_NAME AS CUS_NAME ,
		A.BIRTH_DATE,
		'' AS PASS_NUM,
		--B.GENDER,
		A.NOR_TEL1,A.NOR_TEL2,A.NOR_TEL3,
		CASE WHEN LEN(A.RES_EMAIL) > 40 THEN SUBSTRING(A.RES_EMAIL,1,40) ELSE A.RES_EMAIL END AS EMAIL
		--A.RES_EMAIL AS EMAIL 
		--, C.ROW_SEQ ,C.STATUS 
		FROM RES_MASTER_DAMO A WITH (INDEX([IDX_RES_MASTER_3]))
			LEFT JOIN CUS_CLEAR_TARGET C WITH(NOLOCK)
				ON A.RES_CODE = C.RES_CODE 
				AND C.SEq_NO = 0 
		WHERE A.DEP_DATE >= @START_DATE AND A.DEP_DATE < DATEADD(DD,1,@START_DATE)
		--WHERE A.DEP_DATE >= '2017-09-01' AND A.DEP_DATE < '2017-09-02'-- 
		AND A.RES_STATE NOT IN ( 7,8,9 ) --AND B.RES_STATE = 0 -- 예약 .출발 상태 정상 
		AND A.PROVIDER <> 33 -- BTMS 제외 
		--AND A.BIRTH_DATE IS NOT NULL --생년월일
		--AND ( (A.NOR_TEL2 IS NOT NULL AND A.NOR_TEL3 IS NOT NULL AND A.NOR_TEL2 <>'' AND A.NOR_TEL3 <>''
		--		AND A.NOR_TEL2 NOT IN ('000','0000') AND A.NOR_TEL3 NOT IN ('000'))  -- 전화번호 
		--	) 
		--AND A.RES_CODE ='RP1707116719'
		AND ( ISNULL(@TARGET_CODE,'') = '' OR A.RES_CODE =@TARGET_CODE)
		AND (C.ROW_SEQ IS NULL OR C.STATUS IN (0,2,3) ) -- 등록 안되어 있거나 미처리 상태인것만 갱신 6/29 처리실패인것도추가 
	END 

	
	--SELECT * FROM #TMP_TARGET_LIST
-- ==========================================================================================
-- 고객 출발자 병합  Declare and using a READ_ONLY cursor
-- ==========================================================================================
DECLARE CSR_RES_CUSTOMER_MATCH_MERGE CURSOR
READ_ONLY
FOR 
	--실제 조회 
	SELECT * FROM #TMP_TARGET_LIST
	ORDER BY DEP_DATE,PRO_CODE ,RES_CODE , SEQ_NO 

--변수선언 
DECLARE @ROW_CNT INT 
SET @ROW_CNT = 0 
DECLARE 
	@PRO_CODE VARCHAR(40)
	,@DEP_DATE DATETIME
	,@RES_CODE VARCHAR(12)
	,@SEQ_NO INT 
	,@CUS_NO INT 
	,@CUS_NAME varchar(40)
	,@BIRTH_DATE DATETIME 
	,@PASS_NUM VARCHAR(20) 
	,@NOR_TEL1 VARCHAR(6),@NOR_TEL2 VARCHAR(5),@NOR_TEL3 VARCHAR(4)
	,@EMAIL VARCHAR(50)

--중복 고객번호 결과 테이블 
DECLARE @TB_PASS_TARGET_CUS_NO TABLE (ROW_NUM INT IDENTITY(1,1),CUS_NO VARCHAR(1000),MEM_TYPE INT ) -- 생년+여권
DECLARE @TB_TEL_TARGET_CUS_NO TABLE (ROW_NUM INT IDENTITY(1,1),CUS_NO VARCHAR(1000),MEM_TYPE INT )  --생년(NULL)+휴대폰 

DECLARE @TB_TARGET_CUS_NO TABLE (ROW_NUM INT IDENTITY(1,1),CUS_NO VARCHAR(1000) ) -- 최종 (여권+휴대폰)
 
OPEN CSR_RES_CUSTOMER_MATCH_MERGE
FETCH NEXT FROM CSR_RES_CUSTOMER_MATCH_MERGE INTO @PRO_CODE,@DEP_DATE,@RES_CODE,@SEQ_NO,@CUS_NO,@CUS_NAME,@BIRTH_DATE,@PASS_NUM,@NOR_TEL1,@NOR_TEL2,@NOR_TEL3,@EMAIL
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		--PRINT CONVERT(vARCHAR,@CUS_NO)+'	'+@CUS_NAME+'	'+CONVERT(vARCHAR(10),@BIRTH_DATE,121)+'	'+ISNULL(@PASS_NUM,'')+'	'+ISNULL(@NOR_TEL1+@NOR_TEL2+@NOR_TEL3,'') +'	'+ISNULL(@EMAIL,'')
--		eg.

		SET @ROW_CNT = @ROW_CNT + 1 
		-- 대상 처리 타입 
		DECLARE @TARGET_TYPE INT 
		DECLARE @CHK_TYPE INT 
		DECLARE @CHK_TEXT VARCHAR(500)
		DECLARE @STATUS INT 
		DECLARE @REMARK VARCHAR(1000)
		
		SET @TARGET_TYPE = 0 -- 미처리상태 
		SET @CHK_TYPE = 0 -- 기본 체크정상
		SET @CHK_TEXT = NULL 
		SET @STATUS = 0 
		SET @REMARK = NULL 

		-- 대상 CUS_NO 
		DECLARE @TARGET_CUS_NO VARCHAR(1000) 
		DECLARE @TARGET_CNT INT
		SET @TARGET_CUS_NO = NULL 
		SET @TARGET_CNT = 0

		-- 출발자 이면서 예약자 일때 
		DECLARE @RES_CUS_NO INT
		SET @RES_CUS_NO = 0 

		-- * 1 이름유효성 
		-- CUS_NAME 이 영문,숫자가 포함된 PASS 
		IF patindex('%[a-Z0-9%]', @CUS_NAME ) > 0 
		BEGIN
			SELECT @CHK_TYPE = 1 ,@CHK_TEXT ='이름에 영문숫자포함'
			GOTO INSERT_CLEAR_TARGET
		END 

		-- CUS_NAME 공백은 전부 제거 한다  출발자,예약자 공백제거함 . 
		IF CHARINDEX(' ', @CUS_NAME ) > 0 
		BEGIN
			SET @CUS_NAME = REPLACE(@CUS_NAME,' ','')

			-- 출발,예약자 이름에 공백제거 
			IF( @SEQ_NO = 0  )
			BEGIN
				-- 매칭되어 있고 고객정보에 공백을 제거한 이름이 같은경우만 
				IF (@CUS_NO > 1 AND (REPLACE((SELECT TOP 1 CUS_NAME FROM CUS_CUSTOMER_DAMO WHERE CUS_NO = @CUS_NO),' ','') = @CUS_NAME))
					OR @CUS_NO  = 1 
				BEGIN
					UPDATE RES_MASTER_DAMO SET RES_NAME = @CUS_NAME  WHERE RES_CODE = @RES_CODE 
				END 
				ELSE 
				BEGIN
					SELECT @CHK_TYPE = 1 ,@CHK_TEXT ='이름에 공백포함'
					GOTO INSERT_CLEAR_TARGET
				END 
			END 
			ELSE  -- 출발자 
			BEGIN
				-- 매칭되어 있고 고객정보에 공백을 제거한 이름이 같은경우만 
				IF (@CUS_NO > 1 AND (REPLACE((SELECT TOP 1 CUS_NAME FROM CUS_CUSTOMER_DAMO WHERE CUS_NO = @CUS_NO),' ','') = @CUS_NAME))
					OR @CUS_NO  = 1 
				BEGIN
					UPDATE RES_CUSTOMER_DAMO SET CUS_NAME = @CUS_NAME  WHERE RES_CODE = @RES_CODE AND SEQ_NO = @SEQ_NO 
				END 
				ELSE 
				BEGIN
					SELECT @CHK_TYPE = 1 ,@CHK_TEXT ='이름에 공백포함'
					GOTO INSERT_CLEAR_TARGET
				END 
			END 
			
			--SELECT @CHK_TYPE = 1 ,@CHK_TEXT ='이름에 공백포함'
			--GOTO INSERT_CLEAR_TARGET
			--SET @CUS_NAME = REPLACE(@CUS_NAME,' ','')

		END 
		
		-- 이름이 한글형식 아님 
		IF patindex('%[ㄱ-?%]', @CUS_NAME ) = 0 
		BEGIN
			SELECT @CHK_TYPE = 1 ,@CHK_TEXT ='이름이 한글이 아닌문자포함' 
			GOTO INSERT_CLEAR_TARGET
		END 
		---- 이름이 2자 이하 5자 이상
		--IF LEN (@CUS_NAME)  < 2  OR  LEN (@CUS_NAME)  > 5
		--BEGIN
		--	SELECT @CHK_TYPE = 1 ,@CHK_TEXT ='이름 자릿수 오류(' +  convert(varchar,LEN (@CUS_NAME)) + '자)'
		--	GOTO INSERT_CLEAR_TARGET
		--END 
		-- 예약자,출발자에 금지어 

		--select PATINDEX ( '%[허니문,투어,쿠팡,티몬,인솔자,고객,가이드,노랑풍선%]', '이현순' ) > 0 
		--IF  CHARINDEX ( @CUS_NAME, '투어,쿠팡,티몬,인솔자,고객,가이드,노랑풍선' )  > 0 
		--IF PATINDEX ( '%[허니문,투어,쿠팡,티몬,인솔자,고객,가이드,노랑풍선%]', @CUS_NAME ) > 0 
		IF EXISTS ( SELECT DATA FROM DBO.FN_SPLIT('투어,쿠팡,티몬,인솔자,고객,가이드,노랑풍선,에어텔,보물섬,트레블,여행사',',')
			WHERE @CUS_NAME LIKE '%' + DATA + '%' )
		BEGIN
			SELECT @CHK_TYPE = 1 ,@CHK_TEXT ='이름에 금지어 포함(개발팀확인)'
			GOTO INSERT_CLEAR_TARGET
		END 
		-- * 2 필수값체크 
		-- 여권 번호나 휴대폰 둘다 없는경우 
		IF(ISNULL(@PASS_NUM,'') = '' AND  ISNULL(@NOR_TEL1 + @NOR_TEL2 + @NOR_TEL3,'') = '' ) 
		BEGIN
			SELECT @CHK_TYPE = 2 ,@CHK_TEXT ='여권,휴대폰 둘다 없음'
			GOTO INSERT_CLEAR_TARGET
		END 
		-- 생년월일 없으면서 휴대폰번호도 없는경우 
		IF(@BIRTH_DATE IS NULL AND  ISNULL(@NOR_TEL1 + @NOR_TEL2 + @NOR_TEL3,'') = '' ) 
		BEGIN
			SELECT @CHK_TYPE = 2 ,@CHK_TEXT ='생년월일,휴대폰 둘다 없음'
			GOTO INSERT_CLEAR_TARGET
		END 
		
		-- * 3 필수값의데이터체크 
		-- 여권번호 7자리 미만 ,9 자리  초과 
		IF(ISNULL(@PASS_NUM,'') <> '' 
			AND (LEN(ISNULL(@PASS_NUM,'')) < 7 OR LEN(ISNULL(@PASS_NUM,'')) > 9)  ) 
		BEGIN
			SELECT @CHK_TYPE = 3 ,@CHK_TEXT ='여권 자릿수 오류 ['+ISNULL(@PASS_NUM,'')+']'  
			GOTO INSERT_CLEAR_TARGET
		END 

		-- 휴대폰 10자리 미만 인경우 
		IF(ISNULL(@NOR_TEL1 + @NOR_TEL2 + @NOR_TEL3,'') <> '' 
			AND LEN(ISNULL(@NOR_TEL1 + @NOR_TEL2 + @NOR_TEL3,'')) < 10 ) 
		BEGIN
			SELECT @CHK_TYPE = 3 ,@CHK_TEXT ='휴대폰 자릿수 오류 ['+ISNULL(@NOR_TEL1 + @NOR_TEL2 + @NOR_TEL3,'') +']'  
			GOTO INSERT_CLEAR_TARGET
		END 
		IF(ISNULL(@NOR_TEL1 + @NOR_TEL2 + @NOR_TEL3,'') <> '' 
			AND LEN(ISNULL(@NOR_TEL1 + @NOR_TEL2 + @NOR_TEL3,'')) > 11   ) 
		BEGIN
			SELECT @CHK_TYPE = 3 ,@CHK_TEXT ='휴대폰 자릿수 오류 ['+ISNULL(@NOR_TEL1 + @NOR_TEL2 + @NOR_TEL3,'') +']'  
			GOTO INSERT_CLEAR_TARGET
		END 

		-- 비정상 데이터 넘어가기 
		IF(ISNULL(@PASS_NUM,'') = 'M00000000' OR @NOR_TEL2 = '000' OR @NOR_TEL2 + @NOR_TEL3 = '0000000' OR @NOR_TEL2 + @NOR_TEL3 = '1111111' ) 
		BEGIN
			SELECT @CHK_TYPE = 3 ,@CHK_TEXT ='여권,휴대폰 형식오류 PASS_NUM:'+ISNULL(@PASS_NUM,'')+',NOR_TEL:'+ISNULL(@NOR_TEL1 + @NOR_TEL2 + @NOR_TEL3,'')
			GOTO INSERT_CLEAR_TARGET
		END 
		
		-- 휴대폰 번호 
		DECLARE @NOR_TEL VARCHAR(12)
		SET @NOR_TEL = @NOR_TEL1 + @NOR_TEL2 + @NOR_TEL3

		--생년월일 있는경우 에만 
		IF @BIRTH_DATE IS NOT NULL 
		BEGIN
			--생년월일,여권번호로 한번 A 
			IF(ISNULL(@PASS_NUM,'') <> '') 
			BEGIN 
				--SELECT '여권번호', @DEP_DATE,@RES_CODE,@SEQ_NO,@CUS_NO,@CUS_NAME,@BIRTH_DATE,@PASS_NUM,@NOR_TEL1,@NOR_TEL2,@NOR_TEL3
				INSERT INTO @TB_PASS_TARGET_CUS_NO ( MEM_TYPE,CUS_NO ) 
				EXEC XP_CUS_MERGE_LIST_SELECT @CUS_NAME=@CUS_NAME,@CUS_BIRTH=@BIRTH_DATE,@PASS_NUM=@PASS_NUM,@RESULT_TYPE='1'
			END 
		END 
		-- 생년월일과 관계없이 이름+휴대폰번호로도 한번 (느려질수 있음 주의!)
		-- 이름,생년(NULL허용),휴대폰번호로 한번 B
		IF(ISNULL(@NOR_TEL,'') <> '') 
		BEGIN
			--SELECT '일반번호', @DEP_DATE,@RES_CODE,@SEQ_NO,@CUS_NO,@CUS_NAME,@BIRTH_DATE,@PASS_NUM,@NOR_TEL1,@NOR_TEL2,@NOR_TEL3
			INSERT INTO @TB_TEL_TARGET_CUS_NO ( MEM_TYPE,CUS_NO ) 
			EXEC XP_CUS_MERGE_LIST_SELECT @CUS_NAME=@CUS_NAME,@CUS_BIRTH=@BIRTH_DATE,@CUS_TEL=@NOR_TEL,@RESULT_TYPE='1'
		END 
		--  CLEAR_TARGET 테이블에 넣기 
		-- A+B 합치기 
		INSERT INTO @TB_TARGET_CUS_NO ( CUS_NO)
		SELECT CUS_NO 
		FROM (
			SELECT * FROM @TB_PASS_TARGET_CUS_NO 
			UNION ALL 
			SELECT * FROM @TB_TEL_TARGET_CUS_NO 
		) T 
		GROUP BY CUS_NO -- , MEM_TYPE 
		ORDER BY MIN(ROW_NUM)  

		------ 예약마스터 , 예약출발자1번이 이름은 같으나 CUS_NO 가 다른경우 
		--IF( @SEQ_NO = 0 )
		--BEGIN
		--	-- 출발자중 예약자와 이름이 같은 1명 
		--	SET @RES_CUS_NO = (SELECT TOP 1 CUS_NO FROM RES_CUSTOMER_DAMO WHERE RES_CODE = @RES_CODE AND CUS_NAME = @CUS_NAME AND RES_sTATE =0 AND CUS_NO > 1 
		--		ORDER BY SEq_NO )

		--	-- 출발자 중 예약자가 있고 , 대상 테이블에 없는경우 
		--	IF ISNULL(@RES_CUS_NO,0) > 0 AND NOT EXISTS (SELECT * FROM @TB_TARGET_CUS_NO WHERE CUS_NO = @RES_CUS_NO )
		--	BEGIN
		--		INSERT INTO @TB_TARGET_CUS_NO ( CUS_NO)
		--		VALUES (@RES_CUS_NO ) 
		--	END 
		--END 
		--ELSE 
		--BEGIN
		--	--출발자 , 예약자 와 이름은 같으나 CUS_NO 다른경우 
		--	-- 출발자중 예약자와 이름이 같은 1명 
		--	SET @RES_CUS_NO = (SELECT TOP 1 CUS_NO FROM RES_MASTER_DAMO WHERE RES_CODE = @RES_CODE AND RES_NAME = @CUS_NAME AND CUS_NO > 1  )

		--	-- 예약자 중 출발자가 있고 , 대상 테이블에 없는경우 
		--	IF ISNULL(@RES_CUS_NO,0) > 0 AND NOT EXISTS (SELECT * FROM @TB_TARGET_CUS_NO WHERE CUS_NO = @RES_CUS_NO )
		--	BEGIN
		--		INSERT INTO @TB_TARGET_CUS_NO ( CUS_NO)
		--		VALUES (@RES_CUS_NO ) 
		--	END 
			
		--END 


		-- 대상 CUS_NO 
		SET @TARGET_CNT = (SELECT COUNT(*) FROM @TB_TARGET_CUS_NO)
		SET @TARGET_CUS_NO = (SELECT STUFF((SELECT (',' + CUS_NO ) AS [text()] FROM @TB_TARGET_CUS_NO ORDER BY CUS_NO  FOR XML PATH('')), 1, 1, '')  )	

		--!! 대상 TARGET_CNT 가 한건이고 
		-- @CUS_NO > 1 이미 매핑되었고 
		-- @CUS_NO 와 다른경우 TARGET_CUS_NO 에 현재 @CUS_NO 추가 해줌  @TARGET_CNT + 1 

--SELECT * FROM @TB_TARGET_CUS_NO  
--select '체크' , @TARGET_CNT,@CUS_NO , @TARGET_CUS_NO

		IF @TARGET_CNT = 1  AND @CUS_NO > 1 
			AND  @CUS_NO <> CONVERT(INT,@TARGET_CUS_NO) 
		BEGIN
			SET @TARGET_CUS_NO = CONVERT(VARCHAR,@CUS_NO)+','+@TARGET_CUS_NO
			SET @TARGET_CNT = @TARGET_CNT +1 
		END 
		
		-- 0 건일경우 
		IF @TARGET_CNT = 0 
		BEGIN
			IF @CUS_NO = 1 
			BEGIN
				SET @TARGET_TYPE = 2 -- 고객정보에 없음
				SET @CHK_TEXT = '고객정보없음.신규고객생성'  -- 기존 CUS_NO  수정 	
			END 
			ELSE 
			BEGIN
				SET @TARGET_TYPE = 2 -- 고객정보에 없음
				SET @CHK_TEXT = '고객정보없음.기존정보갱신'  -- 기존 CUS_NO  수정 	
			END 
		END 
		-- 한건일경우 
		ELSE IF @TARGET_CNT = 1 
		BEGIN
			-- 대상CUS_NO 
			--기존CUS_NO 가 1일경우에 매핑처리후 종료 (병합불필요) 
			IF @CUS_NO = 1  
			BEGIN
				SET @TARGET_TYPE =3 -- 기존고객매핑
				SET @CHK_TEXT = '기존고객매핑' 
			END 
			ELSE  -- 위에서 처리 했기 때문에 @CUS_NO 와 @TARGET_CUS_NO 무조건  같음 
			BEGIN
				SET @TARGET_TYPE =1 -- 처리불필요
				SET @CHK_TEXT = '기존정보갱신'
			END 
		END 
		ELSE IF @TARGET_CNT > 1 
		BEGIN
			-- 병합대상 회원이 정회원 두명이면 병합안됨 
			IF( (SELECT COUNT(*) FROM CUS_MEMBER WITH(NOLOCK) WHERE CUS_NO IN ( SELECT CUS_NO FROM @TB_TARGET_CUS_NO ) AND CUS_ID IS NOT NULL) 
			 + (SELECT COUNT(*) FROM CUS_MEMBER_SLEEP WITH(NOLOCK) WHERE CUS_NO IN ( SELECT CUS_NO FROM @TB_TARGET_CUS_NO ) AND CUS_ID IS NOT NULL) > 1  ) 
			BEGIN
				SET @TARGET_TYPE =5 -- 수동병합대상 처리불가 
				SET @STATUS = 2 
				SET @CHK_TEXT = '처리불가.정회원두명.수동병합대상'
				
			END 
			ELSE 
			BEGIN
				SET @TARGET_TYPE =4 -- 자동병합대상
				SET @CHK_TEXT = '자동병합처리대상'
			END 
		END 

		


	----------------------------------------------------------------------
	INSERT_CLEAR_TARGET:  

		-- 체크 실패시 
		IF( @CHK_TYPE > 0 )
		BEGIN
			SET @STATUS = 2  -- 처리 불가 
		END 
		
		-- 신규 등록 
		EXEC XP_CUS_CLEAR_TARGET_INSERT @RES_CODE=@RES_CODE,@SEQ_NO=@SEQ_NO,@DEP_DATE=@DEP_DATE
			,@CUS_NAME=@CUS_NAME,@OLD_CUS_NO=@CUS_NO,@TARGET_CUS_NO=@TARGET_CUS_NO,@TARGET_CNT=@TARGET_CNT
			,@TARGET_TYPE=@TARGET_TYPE,@CHK_TYPE=@CHK_TYPE,@CHK_TEXT=@CHK_TEXT,@STATUS=@STATUS,@REMARK=@REMARK


		--테이블 변수 데이터 삭제 
		DELETE @TB_TARGET_CUS_NO 
		DELETE @TB_PASS_TARGET_CUS_NO
		DELETE @TB_TEL_TARGET_CUS_NO
	----------------------------------------------------------------------


	END
	FETCH NEXT FROM CSR_RES_CUSTOMER_MATCH_MERGE INTO @PRO_CODE,@DEP_DATE,@RES_CODE,@SEQ_NO,@CUS_NO,@CUS_NAME,@BIRTH_DATE,@PASS_NUM,@NOR_TEL1,@NOR_TEL2,@NOR_TEL3,@EMAIL
END

CLOSE CSR_RES_CUSTOMER_MATCH_MERGE
DEALLOCATE  CSR_RES_CUSTOMER_MATCH_MERGE
SET NOCOUNT OFF 

DROP TABLE #TMP_TARGET_LIST 

----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE CSR_CUS_CLEAR_TARGET CURSOR
READ_ONLY
FOR 


--DECLARE @START_DATE DATETIME 
--DECLARE @TARGET_CODE VARCHAR(100)
--SET @START_DATE  = '2018-06-08' 
--SET @TARGET_CODE = 'RP1806053534' 

	--예약의 중복된 이름 조회 . 같은 고객은 TARGET_CUS_NO 를 합쳐줌 -- 기존로직 
	--SELECT A.RES_CODE ,A.CUS_NAME ,
	--(SELECT STUFF((SELECT (',' + TARGET_CUS_NO ) AS [text()] 
	--	FROM CUS_CLEAR_TARGET AA WHERE AA.RES_CODE = A.RES_CODE 
	--		AND  AA.CUS_NAME = (CASE WHEN C.CUS_NAME IS NULL THEN B.RES_NAME ELSE C.CUS_NAME END )  
	--ORDER BY AA.TARGET_CUS_NO  FOR XML PATH('')), 1, 1, ''))

	--FROM CUS_CLEAR_TARGET A	
	--	INNER JOIN RES_MASTER_DAMO B 
	--		ON A.RES_CODE = B.RES_CODE 
	--		--AND B.CUS_NO > 1 -- 1 공용고객 제외 
	--	LEFT JOIN RES_CUSTOMER_DAMO C
	--		ON A.RES_CODE = C.RES_CODE 
	--		AND A.SEQ_NO = C.SEQ_NO 
	--		--AND C.CUS_NO > 1 -- 1 공용고객 제외 
	--WHERE A.DEP_DATE >= @START_DATE
	--AND A.DEP_DATE < DATEADD(D,1,@START_DATE)
	--AND A.STATUS IN(0,2)  -- 정상,처리불가만 
	----AND TARGET_CUS_NO IS NOT NULL 
	--AND ( ISNULL(@TARGET_CODE,'') = '' OR A.RES_CODE =@TARGET_CODE)
	--GROUP BY A.RES_CODE , A.CUS_NAME ,(CASE WHEN C.CUS_NAME IS NULL THEN B.RES_NAME ELSE C.CUS_NAME END ) 
	--HAVING COUNT(*) > 1 


	SELECT RES_CODE , CUS_NAME , TARGET_CUS_NO  FROM 
	(
		SELECT A.RES_CODE , A.CUS_NAME , 
		(SELECT STUFF((SELECT (',' + TARGET_CUS_NO ) AS [text()] 
			FROM CUS_CLEAR_TARGET AA WITH(NOLOCK) WHERE AA.RES_CODE = A.RES_CODE 
				AND  AA.CUS_NAME = (CASE WHEN C.CUS_NAME IS NULL THEN B.RES_NAME ELSE C.CUS_NAME END )  
		ORDER BY AA.TARGET_CUS_NO  FOR XML PATH('')), 1, 1, '')) AS TARGET_CUS_NO 

		FROM CUS_CLEAR_TARGET A	 WITH(NOLOCK)
			INNER JOIN RES_MASTER_DAMO B  WITH(NOLOCK)
				ON A.RES_CODE = B.RES_CODE  
				AND A.SEQ_NO = 0 
			INNER JOIN RES_CUSTOMER_DAMO C  WITH(NOLOCK)
				ON B.RES_CODE  = C.RES_CODE 
				AND B.RES_NAME = C.CUS_NAME 
		WHERE A.DEP_DATE >= @START_DATE
		AND A.DEP_DATE < DATEADD(D,1,@START_DATE)
		AND A.STATUS IN(0,2,3)  -- 미처리,처리불가만 합쳐줌 6/29처리실패도추가
		--AND TARGET_CUS_NO IS NOT NULL 
		AND ( ISNULL(@TARGET_CODE,'') = '' OR A.RES_CODE =@TARGET_CODE) 
		GROUP BY A.RES_CODE ,A.CUS_NAME  ,(CASE WHEN C.CUS_NAME IS NULL THEN B.RES_NAME ELSE C.CUS_NAME END )  
		HAVING COUNT(*) = 1 
	) T 
	WHERE 1=1
	AND TARGET_CUS_NO IS NOT NULL 

	--SELECT '예약자,출발자 동일:' + CONVERT(vARCHAR,ISNULL(@@ROWCOUNT,-1)) + '건조회'

--변수선언 
DECLARE @DUP_CHK_RES_CODE VARCHAR(50) 
DECLARE @DUP_CHK_CUS_NAME VARCHAR(50) 
DECLARE @DUP_CHK_CUS_NO VARCHAR(1000)  

OPEN CSR_CUS_CLEAR_TARGET
FETCH NEXT FROM CSR_CUS_CLEAR_TARGET INTO @DUP_CHK_RES_CODE,@DUP_CHK_CUS_NAME,@DUP_CHK_CUS_NO
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		
		--SELECT DATA FROM DBO.FN_SPLIT(@DUP_CHK_CUS_NO,',') 
		--GROUP BY DATA 

		DECLARE @DUP_CHK_TARGET_CNT INT 
		-- 정상인 처리 골라서 갱신 업데이트 
		DECLARE @DUP_CHK_STATUS INT 
		DECLARE @DUP_CHK_TYPE INT
		DECLARE @DUP_CHK_CHK_TEXT VARCHAR(500)

		SET @DUP_CHK_TARGET_CNT = ( SELECT COUNT(*) FROM (SELECT DATA FROM DBO.FN_SPLIT(@DUP_CHK_CUS_NO,',') GROUP BY DATA)TT )

		SELECT TOP 1 @DUP_CHK_STATUS = STATUS,  
			@DUP_CHK_TYPE = CHK_TYPE ,
			@DUP_CHK_CHK_TEXT = CHK_TEXT  
		FROM CUS_CLEAR_TARGET  WITH(NOLOCK)
			WHERE RES_CODE = @DUP_CHK_RES_CODE
			AND CUS_NAME = @DUP_CHK_CUS_NAME  AND STATUS IN(0,2)  -- 정상,처리불가만 
		ORDER BY STATUS ASC 
		

		UPDATE CUS_CLEAR_TARGET 
			SET TARGET_CUS_NO =  (SELECT STUFF((SELECT (',' + DATA ) AS [text()]  FROM DBO.FN_SPLIT(@DUP_CHK_CUS_NO,',') GROUP BY DATA ORDER BY DATA FOR XML PATH('')), 1, 1, ''))
			 , MERGE_INFO = '기존TARGET_CUS_NO:' + ISNULL(TARGET_CUS_NO,'')
			 , TARGET_CNT = @DUP_CHK_TARGET_CNT
			 , STATUS  = CASE WHEN @DUP_CHK_STATUS IS NOT NULL THEN @DUP_CHK_STATUS ELSE STATUS END 
			 , CHK_TYPE  = CASE WHEN @DUP_CHK_TYPE IS NOT NULL THEN @DUP_CHK_TYPE ELSE CHK_TYPE END 
			 , CHK_TEXT  = CASE WHEN @DUP_CHK_CHK_TEXT IS NOT NULL THEN @DUP_CHK_CHK_TEXT ELSE CHK_TEXT END 
		WHERE RES_CODE = @DUP_CHK_RES_CODE
		AND CUS_NAME = @DUP_CHK_CUS_NAME 
		
		

	END
	FETCH NEXT FROM CSR_CUS_CLEAR_TARGET INTO @DUP_CHK_RES_CODE,@DUP_CHK_CUS_NAME,@DUP_CHK_CUS_NO
END

CLOSE CSR_CUS_CLEAR_TARGET
DEALLOCATE  CSR_CUS_CLEAR_TARGET


SELECT @ROW_CNT AS '총처리건수'

END 

GO
