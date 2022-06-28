USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	기본내용
====================================================================================
- SP 명 : XP_CUS_CUSTOMER_UPDATE_SELECT_MATCH_BY_PASS_NUM
- 기 능 : 고객정보로 CUS_NO 자동 찾기  이름+생년월일+여권번호 우선으로 적용  
====================================================================================
	참고내용
====================================================================================
SELECT TOP 100 * FROM CUS_CUSTOMER WHERE CUS_NO = 998899106
- 예제 
EXEC XP_CUS_CUSTOMER_UPDATE_SELECT_MATCH_BY_PASS_NUM @CUS_NO=0,
@CUS_NAME='박박박',@GENDER=NULL,@BIRTH_DATE='1980-07-08',@NOR_TEL1='010',@NOR_TEL2='9185',@NOR_TEL3='2481',@NEW_CUS_YN = 'Y' 


EXEC XP_CUS_CUSTOMER_UPDATE_SELECT_MATCH_BY_PASS_NUM @CUS_NO=0,
@CUS_NAME='박박박',@GENDER=NULL,@BIRTH_DATE='1980-07-08',@NOR_TEL1='010',@NOR_TEL2='9185',@NOR_TEL3='2481',@NEW_CUS_YN = 'Y' 


EXEC XP_CUS_CUSTOMER_UPDATE_SELECT_MATCH_BY_PASS_NUM @CUS_NO=1,
@CUS_NAME='박형만',@GENDER=NULL,@BIRTH_DATE='1980-07-08',@PASS_NUM = 'M87085302'


====================================================================================
	변경내역
====================================================================================
- 2017-07-18 박형만 신규작성 
- 2018-05-15 박형만 수정
- 2018-05-29 박형만 여권번호 고객정보 한번더 조회 
===================================================================================*/
CREATE PROC [dbo].[XP_CUS_CUSTOMER_UPDATE_SELECT_MATCH_BY_PASS_NUM]
	@CUS_NO INT,    --1 보다 큰경우는 아직 보류,,
	@CUS_NAME VARCHAR(50) , -- 주요검색조건
	@BIRTH_DATE DATETIME ,-- 주요검색조건
	@GENDER VARCHAR(1)  = NULL ,
	@NOR_TEL1 VARCHAR(4) =NUUL,-- 1순위검색조건
	@NOR_TEL2 VARCHAR(6) =NUUL,-- 1순위검색조건
	@NOR_TEL3 VARCHAR(6) =NUUL,-- 1순위검색조건
	@EMAIL VARCHAR(50) = NULL ,  --2순위검색조건 

	@PASS_NUM VARCHAR(20) = NULL,

	@HOM_TEL1 VARCHAR(6) = NULL ,
	@HOM_TEL2 VARCHAR(6) = NULL ,
	@HOM_TEL3 VARCHAR(6) = NULL ,

	@LAST_NAME VARCHAR(50) = NULL ,
	@FIRST_NAME VARCHAR(50) = NULL ,

	@NATIONAL  VARCHAR(10) = NULL , 
	@NEW_CODE VARCHAR(7)= '9999999',
	@NEW_CUS_YN CHAR(1) = NULL ,
	@DUP_PROC_YN CHAR(1) = NULL 
AS
BEGIN

--테스트 고객

--DECLARE @CUS_NO INT,    --1 보다 큰경우는 아직 보류,,
--	@CUS_NAME VARCHAR(50) , -- 주요검색조건
--	@BIRTH_DATE DATETIME ,-- 주요검색조건
--	@GENDER VARCHAR(1)  = NULL ,
--	@NOR_TEL1 VARCHAR(4) ,-- 1순위검색조건
--	@NOR_TEL2 VARCHAR(6) ,-- 1순위검색조건
--	@NOR_TEL3 VARCHAR(6) ,-- 1순위검색조건
--	@EMAIL VARCHAR(50) = NULL ,  --2순위검색조건 

--	@PASS_NUM VARCHAR(20)

--SELECT @CUS_NAME ='박형만',@PASS_NUM='M12341234' , @BIRTH_DATE = '1980-07-08'

----SELECT * FROM RES_CUSTOMER WHERE RES_CODE ='RP1707172991'
--SELECT CUS_NO FROM CUS_CUSTOMER_DAMO WHERE CUS_NAME = @CUS_NAME  AND BIRTH_DATE = @BIRTH_DATE 
----이름 생년월일로 CUS_CUSTOMER_DAMO 검색 
--SELECT CUS_NO, damo.dbo.dec_varchar('DIABLO','dbo.RES_CUSTOMER','PASS_NUM', SEC_PASS_NUM) AS PASS_NUM , RES_CODE , SEq_NO FROM RES_CUSTOMER_DAMO 
--WHERE CUS_NO IN (SELECT CUS_NO FROM CUS_CUSTOMER_DAMO WHERE CUS_NAME = @CUS_NAME  AND BIRTH_DATE = @BIRTH_DATE )
--AND SEC_PASS_NUM IN ( damo.dbo.enc_varchar('DIABLO','dbo.RES_CUSTOMER','PASS_NUM',UPPER(@PASS_NUM))
--					,damo.dbo.enc_varchar('DIABLO','dbo.RES_CUSTOMER','PASS_NUM',LOWER(@PASS_NUM)) )
--SELECT TOP 100  damo.dbo.dec_varchar('DIABLO','dbo.RES_CUSTOMER','PASS_NUM', SEC_PASS_NUM),SEC_PASS_NUM,* FROM RES_CUSTOMER_DAMO WHERE CUS_NO IN ( 9094206,9094252)

	DECLARE @RET_CUS_NO INT 
	SET @RET_CUS_NO = 1 ; --  기본값 

	--아직 매핑되지 않았고 
	--이름 생년월일 여권번호가 있을경우
	IF ISNULL(@CUS_NO,-1) <= 1  
		AND @BIRTH_DATE IS NOT NULL 
		AND ISNULL(@PASS_NUM,'') <> '' 
	BEGIN
		--이름 생년월일로 CUS_CUSTOMER_DAMO 검색 
		DECLARE @TMP_CUS_NO INT 
		DECLARE @TMP_CUS_NO_DATA VARCHAR(1000)

		--정회원CUS_NO 로 예약의 여권번호 우선 검색 
		SELECT @TMP_CUS_NO_DATA = STUFF((
				SELECT  (',' +CONVERT(VARCHAR(20),CUS_NO) ) AS [text()]
				FROM RES_CUSTOMER_DAMO 
				WHERE CUS_NO IN (
					SELECT CUS_NO FROM CUS_MEMBER WHERE CUS_NAME = @CUS_NAME  AND BIRTH_DATE = @BIRTH_DATE AND CUS_ID IS NOT NULL 
					UNION ALL 
					SELECT CUS_NO FROM CUS_MEMBER_SLEEP WHERE CUS_NAME = @CUS_NAME  AND BIRTH_DATE = @BIRTH_DATE AND CUS_ID IS NOT NULL 
					 )
				AND SEC_PASS_NUM IN ( damo.dbo.enc_varchar('DIABLO','dbo.RES_CUSTOMER','PASS_NUM',UPPER(@PASS_NUM))
						,damo.dbo.enc_varchar('DIABLO','dbo.RES_CUSTOMER','PASS_NUM',LOWER(@PASS_NUM)) )
				GROUP BY CUS_NO 
				FOR XML PATH('')), 1, 1, '')    
		--SELECT @TMP_CUS_NO_DATA

		-- 정회원CUS_NO 로 없으면 비회원CUS_NO 로 예약의 여권번호 우선 검색 
		IF @TMP_CUS_NO_DATA IS NULL 
		BEGIN
			SELECT @TMP_CUS_NO_DATA = STUFF((
				SELECT  (',' +CONVERT(VARCHAR(20),CUS_NO) ) AS [text()]
				FROM RES_CUSTOMER_DAMO 
				WHERE CUS_NO IN (SELECT CUS_NO FROM CUS_CUSTOMER_DAMO WHERE CUS_NAME = @CUS_NAME  AND BIRTH_DATE = @BIRTH_DATE )
				AND SEC_PASS_NUM IN ( damo.dbo.enc_varchar('DIABLO','dbo.RES_CUSTOMER','PASS_NUM',UPPER(@PASS_NUM))
						,damo.dbo.enc_varchar('DIABLO','dbo.RES_CUSTOMER','PASS_NUM',LOWER(@PASS_NUM)) )
				GROUP BY CUS_NO 
				FOR XML PATH('')), 1, 1, '')    
			--SELECT @TMP_CUS_NO_DATA
		END 

		-- 정회원CUS_NO , 비회원CUS_NO 없으면 고객정보 여권번호 조회 
		IF @TMP_CUS_NO_DATA IS NULL 
		BEGIN
			SELECT @TMP_CUS_NO_DATA = STUFF((
				SELECT  (',' +CONVERT(VARCHAR(20),CUS_NO) ) AS [text()]
				FROM CUS_CUSTOMER_DAMO WHERE CUS_NAME = @CUS_NAME  AND BIRTH_DATE = @BIRTH_DATE 
				AND SEC_PASS_NUM IN ( damo.dbo.enc_varchar('DIABLO','dbo.CUS_CUSTOMER','PASS_NUM',UPPER(@PASS_NUM))
						,damo.dbo.enc_varchar('DIABLO','dbo.CUS_CUSTOMER','PASS_NUM',LOWER(@PASS_NUM)) )
				GROUP BY CUS_NO 
				FOR XML PATH('')), 1, 1, '')    
			--SELECT @TMP_CUS_NO_DATA
		END 

		-- 
		IF @TMP_CUS_NO_DATA IS NOT NULL -- AND CHARINDEX(',',@TMP_CUS_NO_DATA) = 0 
		BEGIN

			SELECT TOP 1 @TMP_CUS_NO =  CUS_NO  FROM 
			(
				SELECT CUS_NO , CUS_ID 
				FROM CUS_CUSTOMER_DAMO WHERE CUS_NO IN ( SELECT DATA FROM FN_SPLIT(@TMP_CUS_NO_DATA,','))
				AND CUS_NAME = @CUS_NAME -- 이름 생년월일 같은것 
			) T 
			ORDER BY (CASE WHEN ISNULL(CUS_ID,'') <> '' THEN 1 ELSE 2 END) , CUS_NO ASC   -- 정회원,기존것 우선  

			SET @RET_CUS_NO = @TMP_CUS_NO 
		END 


		----데이터가 있고 , 한건인경우 (두건이 아닌경우 (,없음))
		--IF @TMP_CUS_NO_DATA IS NOT NULL AND CHARINDEX(',',@TMP_CUS_NO_DATA) = 0 
		--BEGIN

		--	SELECT * FROM CUS_CUSTO
		--	SELECT @TMP_CUS_NO = DATA FROM FN_SPLIT(@TMP_CUS_NO_DATA,',') WHERE ID = 1 
		--END 
		--ELSE 
		--BEGIN 
			
		--END 

		-- 정보를 찾지 못하였다면, 신규 고객정보 생성하고 CUS_NO 갱신 
		IF ISNULL(@TMP_CUS_NO,-1)  = -1  AND @NEW_CUS_YN = 'Y' 
		BEGIN
		
			INSERT INTO CUS_CUSTOMER_DAMO (CUS_NAME, LAST_NAME , FIRST_NAME,
				--SOC_NUM1,SEC1_SOC_NUM2, SEC_SOC_NUM2, 
				NOR_TEL1, NOR_TEL2 ,NOR_TEL3 , EMAIL, 
				HOM_TEL1 ,HOM_TEL2 ,HOM_TEL3 ,
				NEW_DATE, NEW_CODE ,--IPIN_DUP_INFO ,IPIN_CONN_INFO ,
				[NATIONAL] ,
				BIRTH_DATE , GENDER )
			VALUES (@CUS_NAME,  @LAST_NAME , @FIRST_NAME,
				--@SOC_NUM1 ,damo.dbo.pred_meta_plain_v(@SOC_NUM2, 'DIABLO', 'dbo.CUS_CUSTOMER', 'SOC_NUM2') ,damo.dbo.enc_varchar('DIABLO','dbo.CUS_CUSTOMER','SOC_NUM2',@SOC_NUM2), 
				@NOR_TEL1, @NOR_TEL2 , @NOR_TEL3,  @EMAIL,
				@HOM_TEL1 ,@HOM_TEL2 ,@HOM_TEL3 ,
				GETDATE(), @NEW_CODE ,--@IPIN_DUP_INFO, @IPIN_CONN_INFO , 
				@NATIONAL,
				@BIRTH_DATE , @GENDER )

			SET @RET_CUS_NO = @@IDENTITY 
		END    
		
		IF( @RET_CUS_NO > 1 ) 
		BEGIN 
			SELECT T.*
			, DAMO.dbo.dec_varchar('DIABLO','dbo.CUS_CUSTOMER','PASS_NUM', C.SEC_PASS_NUM) AS PASS_NUM,C.PASS_DATE,C.FAX_SEQ , C.PASS_EXPIRE, C.PASS_ISSUE
			 FROM 
			(
			SELECT 3 AS CUS_TYPE , CUS_NO,CUS_ID,CUS_NAME,LAST_NAME,FIRST_NAME,NOR_TEL1, NOR_TEL2,NOR_TEL3,EMAIL,HOM_TEL1 ,HOM_TEL2 ,HOM_TEL3 ,[NATIONAL],BIRTH_DATE , GENDER ,
				ADDRESS1,ADDRESS2,ZIP_CODE,IPIN_DUP_INFO,IPIN_CONN_INFO
			FROM CUS_CUSTOMER_DAMO WHERE CUS_NO = @RET_CUS_NO 	
			AND CUS_NAME = @CUS_NAME -- 이름꼬이지 않은것 
			UNION ALL 
			SELECT 1 AS CUS_TYPE , CUS_NO,CUS_ID,CUS_NAME,LAST_NAME,FIRST_NAME,NOR_TEL1, NOR_TEL2,NOR_TEL3,EMAIL,HOM_TEL1 ,HOM_TEL2 ,HOM_TEL3 ,[NATIONAL],BIRTH_DATE , GENDER ,
				ADDRESS1,ADDRESS2,ZIP_CODE,IPIN_DUP_INFO,IPIN_CONN_INFO
			FROM CUS_MEMBER WHERE CUS_NO = @RET_CUS_NO AND CUS_ID IS NOT NULL  	
			AND CUS_NAME = @CUS_NAME -- 이름꼬이지 않은것 
			UNION ALL 
			SELECT 2 AS CUS_TYPE , CUS_NO,CUS_ID,CUS_NAME,LAST_NAME,FIRST_NAME,NOR_TEL1, NOR_TEL2,NOR_TEL3,EMAIL,HOM_TEL1 ,HOM_TEL2 ,HOM_TEL3 ,[NATIONAL],BIRTH_DATE , GENDER ,
				ADDRESS1,ADDRESS2,ZIP_CODE,IPIN_DUP_INFO,IPIN_CONN_INFO
			FROM CUS_MEMBER_SLEEP WHERE CUS_NO = @RET_CUS_NO AND CUS_ID IS NOT NULL 
			AND CUS_NAME = @CUS_NAME -- 이름꼬이지 않은것 
			
			) T
				LEFT JOIN CUS_CUSTOMER_DAMO  C 
					ON T.CUS_NO = C.CUS_NO 
			ORDER BY T.CUS_TYPE ASC 
		END 

		SELECT @TMP_CUS_NO_DATA AS '검색회원'
		
	END 
END 



GO
