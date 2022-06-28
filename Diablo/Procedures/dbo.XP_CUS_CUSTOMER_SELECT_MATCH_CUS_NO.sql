USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*==================================================================================
	기본내용
====================================================================================
- SP 명 : XP_CUS_CUSTOMER_SELECT_MATCH_CUS_NO
- 기 능 : 고객정보로 CUS_NO 자동 찾기  이름+생년월일+휴대폰 우선으로 적용  
====================================================================================
	참고내용
====================================================================================

- 예제 
EXEC XP_CUS_CUSTOMER_SELECT_MATCH_CUS_NO @CUS_NO=0,
@CUS_NAME='박박박',@GENDER=NULL,@BIRTH_DATE='1980-07-08',@NOR_TEL1='010',@NOR_TEL2='9185',@NOR_TEL3='2481',@NEW_CUS_YN = 'Y' 

EXEC XP_CUS_CUSTOMER_SELECT_MATCH_CUS_NO @CUS_NO=0,
@CUS_NAME='박박박',@GENDER=NULL,@BIRTH_DATE='1980-07-02',@NOR_TEL1='010',@NOR_TEL2='9185',@NOR_TEL3='2481' 


====================================================================================
	변경내역
====================================================================================
- 2017-07-18 박형만 신규작성 
===================================================================================*/
CREATE PROC [dbo].[XP_CUS_CUSTOMER_SELECT_MATCH_CUS_NO]
	@CUS_NO INT,    --1 보다 큰경우는 아직 보류,,
	@CUS_NAME VARCHAR(50) , -- 주요검색조건
	@BIRTH_DATE DATETIME ,-- 주요검색조건
	@GENDER VARCHAR(1)  = NULL ,
	@NOR_TEL1 VARCHAR(4) ,-- 주요검색조건
	@NOR_TEL2 VARCHAR(6) ,-- 주요검색조건
	@NOR_TEL3 VARCHAR(6) ,-- 주요검색조건
	@EMAIL VARCHAR(50) = NULL ,

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


--DECLARE  @CUS_NO INT    --1 보다 큰경우는 아직 보류,,
--DECLARE  @CUS_NAME VARCHAR(50) , -- 주요검색조건
--@GENDER VARCHAR(50) ,
--@BIRTH_DATE VARCHAR(50) ,-- 주요검색조건
--@NOR_TEL1 VARCHAR(50) ,-- 주요검색조건
--@NOR_TEL2 VARCHAR(50) ,-- 주요검색조건
--@NOR_TEL3 VARCHAR(50) ,-- 주요검색조건
--@EMAIL VARCHAR(50),


--DECLARE @IS_DUP_PROC INT 
--SET @IS_DUP_PROC = 1 -- 고객 자동병합 처리 

--SELECT @CUS_NAME='박형만',@GENDER=NULL,@BIRTH_DATE='1980-07-08',@NOR_TEL1='010',@NOR_TEL2='9185',@NOR_TEL3='2481' 


DECLARE @RET_CUS_NO INT 
SET @RET_CUS_NO = 1 ; --  기본값 
	--고객번호가 1 보다 작거나 같으면 , 휴대폰 번호가 유효하면 
	--매핑대상  
	IF ISNULL(@CUS_NO,-1) <= 1  
		AND @BIRTH_DATE IS NOT NULL 
		AND ISNULL(@NOR_TEL1,'') <> '' AND @NOR_TEL1 IN ( '010','011','017','018','019' ) 
		AND ISNULL(@NOR_TEL2,'') <> '' AND LEN(@NOR_TEL2) >= 3 
		AND ISNULL(@NOR_TEL3,'') <> '' AND LEN(@NOR_TEL3) >= 4 
		
	BEGIN
		-- 자동매핑 체크 
		-- 1. 이름+생년월일+휴대폰으로 체크
		-- 멤버에 있으면 (두명일수는 없음)

		DECLARE @TMP_CUS_NO INT 
		DECLARE @CERT_YN VARCHAR(1) 
		-- 정회원은 새로운것 우선으로 ( 주민번호 변경으로 DI 가 바뀌었을수 있음)
		SELECT @TMP_CUS_NO = MAX(CUS_NO) FROM ( 
			SELECT 1 AS CUS_TYPE,CUS_ID,CUS_NO,CUS_NAME,BIRTH_DATE,GENDER,NOR_TEL1,NOR_TEL2,NOR_TEL3,EMAIL 
			FROM CUS_MEMBER WITH(NOLOCK) WHERE CUS_NAME = @CUS_NAME 	AND BIRTH_DATE = @BIRTH_DATE AND NOR_TEL1 = @NOR_TEL1 AND NOR_TEL2 = @NOR_TEL2 AND NOR_TEL3 = @NOR_TEL3
			AND CUS_ID IS NOT NULL 
			UNION ALL 
			SELECT 2 AS CUS_TYPE,CUS_ID,CUS_NO,CUS_NAME,BIRTH_DATE,GENDER,NOR_TEL1,NOR_TEL2,NOR_TEL3,EMAIL 
			FROM CUS_MEMBER_SLEEP WITH(NOLOCK) WHERE CUS_NAME = @CUS_NAME 	AND BIRTH_DATE = @BIRTH_DATE AND NOR_TEL1 = @NOR_TEL1 AND NOR_TEL2 = @NOR_TEL2 AND NOR_TEL3 = @NOR_TEL3
			AND CUS_ID IS NOT NULL 
		) T 

		--정회원 정보에 있으면 
		IF ISNULL(@TMP_CUS_NO,-1)  > 1 
		BEGIN
			SET @RET_CUS_NO = @TMP_CUS_NO 
			-- 정보갱신처리 ( CUS_CUSTOMER_DAMO 의 정보를 갱신 .추후 
			--IF @IS_DUP_PROC  = 1  AND @CERT_YN = 'Y' -- 인증받은 회원인 경우만 
			--BEGIN
			--	UPDATE A
			--	SET A.CUS_NAME = B.CUS_NAME 
			--	, A.IPIN_DUP_INFO = B.IPIN_DUP_INFO 
			--	, A.IPIN_CONN_INFO = B.IPIN_CONN_INFO 
			--	FROM CUS_CUSTOMER_DAMO A INNER JOIN 
			--	(
			--		SELECT 1 AS CUS_TYPE,CUS_ID,CUS_NO,CUS_NAME,BIRTH_DATE,GENDER,NOR_TEL1,NOR_TEL2,NOR_TEL3,EMAIL 
			--		FROM CUS_MEMBER WITH(NOLOCK) WHERE CUS_NO = @RET_CUS_NO AND CUS_ID IS NOT NULL 
			--		UNION ALL 
			--		SELECT 2 AS CUS_TYPE,CUS_ID,CUS_NO,CUS_NAME,BIRTH_DATE,GENDER,NOR_TEL1,NOR_TEL2,NOR_TEL3,EMAIL 
			--		FROM CUS_MEMBER_SLEEP WITH(NOLOCK) WHERE CUS_NO = @RET_CUS_NO AND CUS_ID IS NOT NULL 
			--	) B 
			--		ON A.CUS_NO = B.CUS_NO 	
			--	WHERE CUS_NO = @RET_CUS_NO 
			--END 
		
		END 
		ELSE -- 정회원 정보에 없으면  
		BEGIN
			-- 비회원 정보 조회 
			-- 오래된것(기존에 쓰던것) 우선으로 
			SELECT @TMP_CUS_NO = CUS_NO FROM ( 
				SELECT TOP 1 
					3 AS CUS_TYPE,CUS_ID,CUS_NO,CUS_NAME,BIRTH_DATE,GENDER,NOR_TEL1,NOR_TEL2,NOR_TEL3,EMAIL 
				FROM CUS_CUSTOMER_DAMO WITH(NOLOCK) 
				WHERE CUS_NAME = @CUS_NAME	AND BIRTH_DATE = @BIRTH_DATE AND NOR_TEL1 = @NOR_TEL1 AND NOR_TEL2 = @NOR_TEL2 AND NOR_TEL3 = @NOR_TEL3 
				ORDER BY (CASE CUS_STATE WHEN 'Y' THEN 9999 ELSE 0 END) DESC,CUS_NO ASC  -- 탈퇴회원은 우선순위 밑으로 , 오래된것 순 
			)  T 
		
			-- 비회원에 있으면 
			IF ISNULL(@TMP_CUS_NO,-1)  >  1 
			BEGIN
				SET @RET_CUS_NO = @TMP_CUS_NO  
			END 
			--ELSE 
			--BEGIN
			--	SET @RET_CUS_NO = -1  
			--END 
		END 

	

		------------------------------------------------------------------------
		-- 정보를 찾지 못하였다면, 신규 고객정보 생성하고 CUS_NO 갱신 
		-- 보류 !! 
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
			SELECT * FROM 
			(
			SELECT 1 AS CUS_TYPE , CUS_NAME,LAST_NAME,FIRST_NAME,NOR_TEL1, NOR_TEL2,NOR_TEL3,EMAIL,HOM_TEL1 ,HOM_TEL2 ,HOM_TEL3 ,[NATIONAL],BIRTH_DATE , GENDER ,
				ADDRESS1,ADDRESS2,ZIP_CODE,IPIN_DUP_INFO,IPIN_CONN_INFO
			FROM CUS_CUSTOMER_DAMO WHERE CUS_NO = @RET_CUS_NO 	
			UNION ALL 
			SELECT 2 AS CUS_TYPE , CUS_NAME,LAST_NAME,FIRST_NAME,NOR_TEL1, NOR_TEL2,NOR_TEL3,EMAIL,HOM_TEL1 ,HOM_TEL2 ,HOM_TEL3 ,[NATIONAL],BIRTH_DATE , GENDER ,
				ADDRESS1,ADDRESS2,ZIP_CODE,IPIN_DUP_INFO,IPIN_CONN_INFO
			FROM CUS_MEMBER_SLEEP WHERE CUS_NO = @RET_CUS_NO AND CUS_ID IS NOT NULL 
			UNION ALL 
			SELECT 3 AS CUS_TYPE , CUS_NAME,LAST_NAME,FIRST_NAME,NOR_TEL1, NOR_TEL2,NOR_TEL3,EMAIL,HOM_TEL1 ,HOM_TEL2 ,HOM_TEL3 ,[NATIONAL],BIRTH_DATE , GENDER ,
				ADDRESS1,ADDRESS2,ZIP_CODE,IPIN_DUP_INFO,IPIN_CONN_INFO
			FROM CUS_MEMBER WHERE CUS_NO = @RET_CUS_NO AND CUS_ID IS NOT NULL  	
			) T ORDER BY CUS_TYPE DESC 
		END 
		
	
	END 

END 

GO
