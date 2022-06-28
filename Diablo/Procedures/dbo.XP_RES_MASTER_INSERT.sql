USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_RES_MASTER_INSERT
■ DESCRIPTION				: 예약 마스터입력( erp)
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec XP_RES_MASTER_INSERT (1, '1', '폴질문 등록 테스트', '9999999')
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-13		박형만			최초생성
   2016-09-20		박형만			PNR_INFO 추가 
   2016-11-02		박형만			PKG_DETAIL . NEW_DATE  값 추가 
================================================================================================================*/ 
CREATE  PROC [dbo].[XP_RES_MASTER_INSERT]
	@RES_AGT_TYPE	INT , -- 0 : 본사상품 일반 예약 ,  1 : 본사상품 대외시스템예약(무궁화관광) ,  2 : 외부제휴상품 예약(테마,홍익,제주),

	@PRO_TYPE	INT , -- ProductTypeEnum { 패키지 = 1, 항공 = 2, 호텔 = 3, 자유여행 = 4, 옵션 = 5, 전체 = 9 }
	@RES_TYPE	INT ,  -- ReserveTypeEnum { 일반 = 0, 대리점, 상용, 외부, 직원 = 9, 전체 = 10 }
	@RES_PRO_TYPE INT ,  -- 예약통계 행사구분? ReserveProductTypeEnum { 상품 = 1, 항공, 호텔, 랜드 }
	@PROVIDER	INT , -- ProviderTypeEnum { None, 직판, 간판여행사, 간판랜드사, 대리점, 인터넷, 항공조인여행사, 항공조인랜드사, LandyOnly, 타사전도, 삼성TnE, 멤플러스, 멤플러스_인터파크, 멤플러스_큐비, G마켓, 신한카드, 웅진메키아, 롯데카드, 무궁화관광, 다음쇼핑 };
	@RES_STATE	INT ,  --ReserveStateEnum { 접수 = 0, 담당자확인중, 예약확정, 결제중, 결제완료, 출발완료, 해피콜, 환불, 이동, 취소, 전체 = 10 }

	@RES_CODE	RES_CODE ,  --호텔은 예약코드 미리 생성
	@MASTER_CODE MASTER_CODE ,
	@PRO_CODE	PRO_CODE , 
	@PRICE_SEQ INT,
	@PRO_NAME NVARCHAR(100),
	@DEP_DATE DATETIME,
	@ARR_DATE DATETIME,
	@LAST_PAY_DATE DATETIME,
	
	@CUS_NO	INT , 
	@RES_NAME VARCHAR(40),
	--@SOC_NUM1 VARCHAR(6),
	--@SOC_NUM2 VARCHAR(7),
	@BIRTH_DATE DATETIME,
	@GENDER CHAR(1),
	@IPIN_DUP_INFO CHAR(64),
	@RES_EMAIL VARCHAR(100),			
	@NOR_TEL1 VARCHAR(6),			
	@NOR_TEL2 VARCHAR(5),					
	@NOR_TEL3 VARCHAR(4),			
	@ETC_TEL1 VARCHAR(6),					
	@ETC_TEL2 VARCHAR(5),					
	@ETC_TEL3 VARCHAR(4),		
	@RES_ADDRESS1 VARCHAR(100),		
	@RES_ADDRESS2 VARCHAR(100),		
	@ZIP_CODE VARCHAR(7),					
	@MEMBER_YN  CHAR(1),	
	@CUS_REQUEST  NVARCHAR(4000),
	@CUS_RESPONSE NVARCHAR(1000),

	@COMM_RATE numeric(4,2),
	@COMM_AMT decimal(18,0),

	@NEW_CODE CHAR(7),	--일반적으로 9999999 , 외부제휴상품,호텔상품,항공상품=담당자사번 

	@ETC NVARCHAR(4000) ,
	@SYSTEM_TYPE INT = 1 ,
	@SALE_COM_CODE VARCHAR(50) = NULL ,
	@TAX_YN CHAR(1) = 'N' ,
	@PNR_INFO VARCHAR(4000)= NULL 
			
	--@AGENT_YN	CHAR(1), 
	--@AFFILIATE_YN CHAR(1),
	--@RES_CODE	RES_CODE OUTPUT  
AS  
BEGIN

	
	--------------------------------------------------------------
	-- 변수선언
	--------------------------------------------------------------

	-- 예약타입STRING RP,RH
	DECLARE @PRO_CHAR CHAR(1)   --,
		--@COMM_RATE NUMERIC(4,2) ,
		--@PRO_NAME NVARCHAR(100) , 
		--@MASTER_CODE VARCHAR(10) 

	-- 담당자 
	DECLARE @NEW_TEAM_CODE VARCHAR(3),		
		@NEW_TEAM_NAME VARCHAR(50),
		--@SALE_COM_CODE varchar(50),
		@SALE_EMP_CODE EMP_CODE,		
		@SALE_TEAM_CODE VARCHAR(3),	
		@SALE_TEAM_NAME varchar(50),	
		@PROFIT_EMP_CODE EMP_CODE,	
		@PROFIT_TEAM_CODE varchar(3),	
		@PROFIT_TEAM_NAME varchar(50)

	-- 예약 타입 채번
	SELECT @PRO_CHAR = (CASE @PRO_TYPE WHEN 1 THEN 'P' WHEN 2 THEN 'T' WHEN 3 THEN 'H' WHEN 4 THEN 'F' WHEN 5 THEN 'O' END)

	-- 예약 코드 채번
	-- 1:패키지, 2:항공, 3:호텔, 4:자유여행
	-- 호텔의 경우에는 행사코드와 예약코드가 만들어져서 들어온다
	IF @PRO_TYPE IN (1, 2)
	BEGIN
		EXEC SP_RES_GET_RES_CODE @PRO_CHAR, @RES_CODE OUTPUT;
	END

	--------------------------------------------------------
	-- 가상행사 생성 (실시간항공, 실시간호텔을 위한 가상의 행사생성)
	-------------------------------------------------------- 
	-- 항공,호텔 OR 외부제휴상품예약
	
	-- 행사가 존재하지 않을때 등록한다.
	IF NOT EXISTS(SELECT 1 FROM PKG_DETAIL A WITH(NOLOCK) WHERE A.PRO_CODE = @PRO_CODE)
	BEGIN

		DECLARE @NEW_PRO_NAME NVARCHAR(100)
		SET @NEW_PRO_NAME = @PRO_NAME 

		--BTMS 예약 
		IF @PROVIDER = 33 
		BEGIN
			
			IF ISNULL(@PRO_NAME,'') = ''
			BEGIN
				DECLARE @SALE_COM_NAME VARCHAR(50)
				IF( ISNULL(@SALE_COM_CODE ,'') <> '' )
				BEGIN
					SELECT @SALE_COM_NAME = KOR_NAME FROM AGT_MASTER WITH(NOLOCK) WHERE AGT_CODE = @SALE_COM_CODE 
				END 

				SET @NEW_PRO_NAME = '[BTMS] '  + ISNULL(@SALE_COM_NAME,@SALE_COM_CODE) + ' ' 
					+ ISNULL( (SELECT KOR_NAME FROM PUB_REGION WHERE SIGN = SUBSTRING(@MASTER_CODE,1,1)),'') +' 출장 ' 
					+ ISNULL((SELECT SUBSTRING(CONVERT(VARCHAR(10) ,@DEP_DATE, 112) ,3,6) ),'')
			END 
		END 
		ELSE 
		BEGIN
			IF( @PRO_TYPE ) = 3  --호텔의 경우 상품명 수정 
			BEGIN

				IF (SUBSTRING(@MASTER_CODE,1,1)) = 'K'
				BEGIN
					SET @NEW_PRO_NAME = '국내숙박 호텔/리조트/콘도/펜션 JG' + (SELECT SUBSTRING(CONVERT(VARCHAR(10) ,@DEP_DATE, 112) ,3,6) )
				END
				ELSE
				BEGIN
					SET @NEW_PRO_NAME = (SELECT KOR_NAME FROM PUB_REGION WHERE SIGN = SUBSTRING(@MASTER_CODE,1,1)) +  ' 해외호텔 ' + (SELECT SUBSTRING(CONVERT(VARCHAR(10) ,@DEP_DATE, 112) ,3,6) )
				END 
			END 
		END 
		


		INSERT INTO PKG_DETAIL
		(PRO_CODE, PRO_NAME, MASTER_CODE, TRANSFER_TYPE, SEAT_CODE, DEP_DATE, ARR_DATE, 
		TOUR_NIGHT, 
		TOUR_DAY,
		MIN_COUNT, MAX_COUNT,
		LAST_PAY_DATE, SENDING_YN, DEP_CFM_YN, CONFIRM_YN, SHOW_YN, NEW_CODE , NEW_DATE , PRO_TYPE)
		VALUES
		(@PRO_CODE, @NEW_PRO_NAME, @MASTER_CODE, 3, 0, @DEP_DATE, @ARR_DATE, 
		(CASE WHEN DATEDIFF(D, @DEP_DATE , @ARR_DATE ) = 0 THEN 0 ELSE DATEDIFF(D, @DEP_DATE , @ARR_DATE ) END ) , 
		(CASE WHEN DATEDIFF(D, @DEP_DATE , @ARR_DATE ) = 0 THEN 1 ELSE DATEDIFF(D, @DEP_DATE , @ARR_DATE ) +1 END )  , 
		1, 999,
		@DEP_DATE - 1, 'N', 'N', 'Y', 'N', @NEW_CODE, GETDATE(), @PRO_TYPE)
	END 
	ELSE 
	BEGIN
		--출발일만 업데이트 
		UPDATE PKG_DETAIL 
		SET DEP_DATE = @DEP_DATE ,
			ARR_DATE = @ARR_DATE ,
			TOUR_NIGHT = (CASE WHEN DATEDIFF(D, @DEP_DATE , @ARR_DATE ) = 0 THEN 0 ELSE DATEDIFF(D, @DEP_DATE , @ARR_DATE ) END )  ,
			TOUR_DAY = (CASE WHEN DATEDIFF(D, @DEP_DATE , @ARR_DATE ) = 0 THEN 1 ELSE DATEDIFF(D, @DEP_DATE , @ARR_DATE ) +1 END )
		WHERE PRO_CODE = @PRO_CODE
	END 

	--------------------------------------------------------
	-- 예약 담당자 설정 
	--------------------------------------------------------

	--패키지 
	IF @PRO_TYPE = 1   
	BEGIN
		
		--내부상품 외부사이트제휴 입점 아닐경우 -기본 
		SELECT	@NEW_CODE = dbo.FN_RES_GET_NEW_CODE(@PRO_CODE, @NEW_CODE) , --상품담당자 가져오기
			@NEW_TEAM_CODE = dbo.FN_CUS_GET_EMP_TEAM_CODE(@NEW_CODE),
			@NEW_TEAM_NAME = dbo.FN_CUS_GET_EMP_TEAM(@NEW_CODE),

			@SALE_EMP_CODE = CASE WHEN @PROVIDER NOT IN (14,15,16,17,18,29,30,31) THEN dbo.FN_RES_GET_SALE_CODE(@PRO_CODE, @NEW_CODE) ELSE @NEW_CODE END  , --제휴사 입점 제외  
			@SALE_TEAM_CODE = dbo.FN_CUS_GET_EMP_TEAM_CODE(@SALE_EMP_CODE),
			@SALE_TEAM_NAME = dbo.FN_CUS_GET_EMP_TEAM(@SALE_EMP_CODE),

			@PROFIT_EMP_CODE = dbo.FN_RES_GET_PROFIT_CODE(@PRO_CODE, @NEW_CODE),
			@PROFIT_TEAM_CODE = dbo.FN_CUS_GET_EMP_TEAM_CODE(@PROFIT_EMP_CODE),
			@PROFIT_TEAM_NAME = dbo.FN_CUS_GET_EMP_TEAM(@PROFIT_EMP_CODE)

		IF @PROVIDER <> 33 
		BEGIN
			--상품명,출발일,마스터코드
			SELECT @PRO_NAME = PRO_NAME, @DEP_DATE = DEP_DATE, @ARR_DATE =ARR_DATE, @MASTER_CODE = MASTER_CODE
			FROM PKG_DETAIL WITH(NOLOCK)
			WHERE PRO_CODE = @PRO_CODE
		END 
		
	END
	ELSE 
	BEGIN
		--  호텔 , 항공 
		--IF @PRO_TYPE = 3								--  호텔이라면 아래 구문 실행
		--BEGIN
		--	-- 호텔의 경우 호텔 담당자 허경주씨로 고정 --->>>  페이지 에서 입력 한다 
		--	SET @NEW_CODE = '2011027'
		--END

		--   항공 
		IF @PRO_TYPE = 2								--  항공이라면 아래 구문 실행
		BEGIN
				
			--BTMS 아니고 , WEB 해외항공일경우 
			IF @PROVIDER <> 33  AND (SUBSTRING(@MASTER_CODE,1,1)) <> 'K'
			BEGIN
				-- web 해외 항공의 경우 JustGo 로 고정 
				SET @SALE_COM_CODE = '92474'
			END 
				
		END
	
		--그외 전체
		SELECT	@NEW_TEAM_CODE = dbo.FN_CUS_GET_EMP_TEAM_CODE(@NEW_CODE),
				@NEW_TEAM_NAME = dbo.FN_CUS_GET_EMP_TEAM(@NEW_CODE),

				@SALE_EMP_CODE = @NEW_CODE,
				@SALE_TEAM_CODE = dbo.FN_CUS_GET_EMP_TEAM_CODE(@NEW_CODE),
				@SALE_TEAM_NAME = dbo.FN_CUS_GET_EMP_TEAM(@NEW_CODE),

				@PROFIT_EMP_CODE = @NEW_CODE,
				@PROFIT_TEAM_CODE = dbo.FN_CUS_GET_EMP_TEAM_CODE(@NEW_CODE),
				@PROFIT_TEAM_NAME = dbo.FN_CUS_GET_EMP_TEAM(@NEW_CODE)
	
	END 
	

	--------------------------------------------------------
	-- 예약 마스터 입력
	--------------------------------------------------------

	--예약이 미리 등록되어있으면 (EX호텔예약바로결제)
	IF	ISNULL(@RES_CODE,'') <> '' 
		AND EXISTS (SELECT * FROM RES_MASTER_DAMO WHERE RES_CODE = @RES_CODE) 
	BEGIN
		UPDATE RES_MASTER_DAMO 
		SET PRICE_SEQ = @PRICE_SEQ,		SYSTEM_TYPE = @SYSTEM_TYPE,		PRO_CODE = @PRO_CODE, 
			PRO_TYPE = @PRO_TYPE,		RES_STATE=	@RES_STATE,			RES_TYPE=@RES_TYPE,			DEP_DATE=@DEP_DATE, 
			ARR_DATE = @ARR_DATE,		RES_NAME = @RES_NAME,			--SOC_NUM1=@SOC_NUM1,
			--SEC_SOC_NUM2 = damo.dbo.enc_varchar('DIABLO', 'dbo.RES_MASTER', 'SOC_NUM2', @SOC_NUM2), 
			--SEC1_SOC_NUM2 = damo.dbo.pred_meta_plain_v(@SOC_NUM2, 'DIABLO', 'dbo.RES_MASTER', 'SOC_NUM2'),
			BIRTH_DATE = @BIRTH_DATE,	GENDER = @GENDER,
			RES_EMAIL = @RES_EMAIL,		NOR_TEL1=	@NOR_TEL1,			NOR_TEL2=@NOR_TEL2,			NOR_TEL3=@NOR_TEL3, 
			ETC_TEL1 = @ETC_TEL1,		ETC_TEL2=	@ETC_TEL2,			ETC_TEL3=@ETC_TEL3,			RES_ADDRESS1=@RES_ADDRESS1, 
			RES_ADDRESS2 =@RES_ADDRESS2,ZIP_CODE=	@ZIP_CODE,			MEMBER_YN=@MEMBER_YN,		CUS_REQUEST=@CUS_REQUEST,
			CUS_RESPONSE =@CUS_RESPONSE,
			NEW_DATE = GETDATE(),					NEW_CODE=@NEW_CODE,				NEW_TEAM_CODE=@NEW_TEAM_CODE,	NEW_TEAM_NAME=@NEW_TEAM_NAME,
			SALE_EMP_CODE = @SALE_EMP_CODE,			SALE_TEAM_CODE=@SALE_TEAM_CODE,	SALE_TEAM_NAME=@SALE_TEAM_NAME,	PROFIT_EMP_CODE=@PROFIT_EMP_CODE,
			SALE_COM_CODE = @SALE_COM_CODE,			TAX_YN	= @TAX_YN		,COMM_RATE=@COMM_RATE ,			COMM_AMT=@COMM_AMT , 
			PROFIT_TEAM_CODE = @PROFIT_TEAM_CODE,	PROFIT_TEAM_NAME=@PROFIT_TEAM_NAME,	CUS_NO=@CUS_NO,				LAST_PAY_DATE=@LAST_PAY_DATE,
			MASTER_CODE = @MASTER_CODE,				PRO_NAME=@PRO_NAME,				PROVIDER=@PROVIDER,				ETC=NULL /*@ETC*/,
			IPIN_DUP_INFO = @IPIN_DUP_INFO,			RES_PRO_TYPE=	@RES_PRO_TYPE
		WHERE RES_CODE = @RES_CODE 
	END 
	ELSE 
	BEGIN
		INSERT INTO RES_MASTER_DAMO
		(
			RES_CODE,			PRICE_SEQ,			SYSTEM_TYPE,		PRO_CODE,
			PRO_TYPE,			RES_STATE,			RES_TYPE,			DEP_DATE,
			ARR_DATE,			RES_NAME,			--SOC_NUM1,
			--SEC_SOC_NUM2,
			--SEC1_SOC_NUM2,
			BIRTH_DATE,			GENDER,
			RES_EMAIL,			NOR_TEL1,			NOR_TEL2,			NOR_TEL3,
			ETC_TEL1,			ETC_TEL2,			ETC_TEL3,			RES_ADDRESS1,
			RES_ADDRESS2,		ZIP_CODE,			MEMBER_YN,			CUS_REQUEST,
			CUS_RESPONSE,
			NEW_DATE,			NEW_CODE,			NEW_TEAM_CODE,		NEW_TEAM_NAME,
			SALE_EMP_CODE,		SALE_TEAM_CODE,		SALE_TEAM_NAME,		PROFIT_EMP_CODE,
			SALE_COM_CODE,		TAX_YN,				COMM_RATE ,			COMM_AMT , 
			PROFIT_TEAM_CODE,	PROFIT_TEAM_NAME,	CUS_NO,				LAST_PAY_DATE,
			MASTER_CODE,		PRO_NAME,			PROVIDER,			ETC,
			IPIN_DUP_INFO,		RES_PRO_TYPE,		PNR_INFO 
		)
		VALUES
		(
			@RES_CODE,			@PRICE_SEQ,			@SYSTEM_TYPE,		@PRO_CODE, 
			@PRO_TYPE,			@RES_STATE,			@RES_TYPE,			@DEP_DATE, 
			@ARR_DATE,			@RES_NAME,			--@SOC_NUM1,
			--damo.dbo.enc_varchar('DIABLO', 'dbo.RES_MASTER', 'SOC_NUM2', @SOC_NUM2), 
			--damo.dbo.pred_meta_plain_v(@SOC_NUM2, 'DIABLO', 'dbo.RES_MASTER', 'SOC_NUM2'),
			@BIRTH_DATE,		@GENDER,
			@RES_EMAIL,			@NOR_TEL1,			@NOR_TEL2,			@NOR_TEL3, 
			@ETC_TEL1,			@ETC_TEL2,			@ETC_TEL3,			@RES_ADDRESS1, 
			@RES_ADDRESS2,		@ZIP_CODE,			@MEMBER_YN,			@CUS_REQUEST,
			@CUS_RESPONSE,
			GETDATE(),			@NEW_CODE,			@NEW_TEAM_CODE,		@NEW_TEAM_NAME,
			@SALE_EMP_CODE,		@SALE_TEAM_CODE,	@SALE_TEAM_NAME,	@PROFIT_EMP_CODE,
			@SALE_COM_CODE,		@TAX_YN,				@COMM_RATE ,		@COMM_AMT , 
			@PROFIT_TEAM_CODE,	@PROFIT_TEAM_NAME,	@CUS_NO,			@LAST_PAY_DATE,
			@MASTER_CODE,		@PRO_NAME,			@PROVIDER,			@ETC,
			@IPIN_DUP_INFO,		@RES_PRO_TYPE,		@PNR_INFO 
		)
	END 

	

	-- 채번된 예약 코드 넘기기
	SELECT @RES_CODE

END 


GO
