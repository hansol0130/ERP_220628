USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_WEB_RES_MASTER_BEFORE_INSERT
■ DESCRIPTION				: 예약 마스터 미리 입력 - 호텔예약 바로 결제시에 사용 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec XP_WEB_RES_MASTER_BEFORE_INSERT
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-02		박형만			최초생성
   2013-07-03		박형만			PROVIDER 추가 
   2014-05-16		박형만			ETC 추가 
================================================================================================================*/ 
CREATE  PROC [dbo].[XP_WEB_RES_MASTER_BEFORE_INSERT]
	@PRO_TYPE	INT , -- ProductTypeEnum { 패키지 = 1, 항공 = 2, 호텔 = 3, 자유여행 = 4, 옵션 = 5, 전체 = 9 }
	@RES_PRO_TYPE INT ,  -- 예약통계 행사구분? ReserveProductTypeEnum { 상품 = 1, 항공, 호텔, 랜드 }
	@RES_STATE	INT ,  --ReserveStateEnum { 접수 = 0, 담당자확인중, 예약확정, 결제중, 결제완료, 출발완료, 해피콜, 환불, 이동, 취소, 전체 = 10 }
	@PROVIDER	INT , -- ProviderTypeEnum { None, 직판, 간판여행사, 간판랜드사, 대리점, 인터넷, 항공조인여행사, 항공조인랜드사, LandyOnly, 타사전도, 삼성TnE, 멤플러스, 멤플러스_인터파크, 멤플러스_큐비, G마켓, 신한카드, 웅진메키아, 롯데카드, 무궁화관광, 다음쇼핑 };

	@RES_CODE	RES_CODE ,  --호텔은 예약코드 미리 생성
	@PRO_CODE	PRO_CODE ,  --호텔은 상품코드 미리 생성
	@PRICE_SEQ INT , 
	@MASTER_CODE MASTER_CODE ,
	@DEP_DATE DATETIME,
	@ARR_DATE DATETIME,
	@LAST_PAY_DATE DATETIME,
	@CUS_NO	INT , 
	--@CITY_CODE VARCHAR(5),
	@RES_NAME VARCHAR(40),
	@RES_EMAIL VARCHAR(100),			
	@NOR_TEL1 VARCHAR(6),			
	@NOR_TEL2 VARCHAR(5),					
	@NOR_TEL3 VARCHAR(4),			
	
	@CUS_REQUEST  NVARCHAR(4000),
	@CUS_RESPONSE NVARCHAR(1000),
	@NEW_CODE CHAR(7) ,	--일반적으로 9999999 , 외부제휴상품,호텔상품,항공상품=담당자사번 

	@ETC NVARCHAR(4000)
	--@AGENT_YN	CHAR(1), 
	--@AFFILIATE_YN CHAR(1),
	--@RES_CODE	RES_CODE OUTPUT  
AS  
BEGIN

	--예약미리입력
	-- 담당자 
	DECLARE @NEW_TEAM_CODE VARCHAR(3),		
		@NEW_TEAM_NAME VARCHAR(50),
		@SALE_COM_CODE varchar(50),
		@SALE_EMP_CODE EMP_CODE,		
		@SALE_TEAM_CODE VARCHAR(3),	
		@SALE_TEAM_NAME varchar(50),	
		@PROFIT_EMP_CODE EMP_CODE,	
		@PROFIT_TEAM_CODE varchar(3),	
		@PROFIT_TEAM_NAME varchar(50)

	SELECT	@NEW_TEAM_CODE = dbo.FN_CUS_GET_EMP_TEAM_CODE(@NEW_CODE),
			@NEW_TEAM_NAME = dbo.FN_CUS_GET_EMP_TEAM(@NEW_CODE),

			@SALE_EMP_CODE = @NEW_CODE,
			@SALE_TEAM_CODE = dbo.FN_CUS_GET_EMP_TEAM_CODE(@NEW_CODE),
			@SALE_TEAM_NAME = dbo.FN_CUS_GET_EMP_TEAM(@NEW_CODE),

			@PROFIT_EMP_CODE = @NEW_CODE,
			@PROFIT_TEAM_CODE = dbo.FN_CUS_GET_EMP_TEAM_CODE(@NEW_CODE),
			@PROFIT_TEAM_NAME = dbo.FN_CUS_GET_EMP_TEAM(@NEW_CODE)

	--등록되지 않았을때만
	IF NOT EXISTS ( SELECT * FROM RES_MASTER_DAMO WITH(NOLOCK) WHERE RES_CODE = @RES_CODE ) 
	BEGIN
		INSERT INTO RES_MASTER_DAMO
		(
			RES_CODE,			PRICE_SEQ,			SYSTEM_TYPE,		PROVIDER,	PRO_CODE,
			PRO_TYPE,			RES_STATE,			RES_TYPE,			DEP_DATE,
			ARR_DATE,			RES_NAME,			
			RES_EMAIL,			NOR_TEL1,			NOR_TEL2,			NOR_TEL3,
			CUS_REQUEST,
			CUS_RESPONSE,
			NEW_DATE,			NEW_CODE,			NEW_TEAM_CODE,		NEW_TEAM_NAME,
			SALE_EMP_CODE,		SALE_TEAM_CODE,		SALE_TEAM_NAME,		PROFIT_EMP_CODE,
			SALE_COM_CODE,		
			PROFIT_TEAM_CODE,	PROFIT_TEAM_NAME,	CUS_NO,				LAST_PAY_DATE,
			MASTER_CODE,		
			RES_PRO_TYPE	,ETC
		)
		VALUES 
		(
			@RES_CODE,			@PRICE_SEQ,			1,			5,		@PRO_CODE,
			@PRO_TYPE,			@RES_STATE,			0,			@DEP_DATE,
			@ARR_DATE,			@RES_NAME,			
			@RES_EMAIL,			@NOR_TEL1,			@NOR_TEL2,			@NOR_TEL3,
			@CUS_REQUEST,
			@CUS_RESPONSE,
			GETDATE(),			@NEW_CODE,			@NEW_TEAM_CODE,		@NEW_TEAM_NAME,
			@SALE_EMP_CODE,		@SALE_TEAM_CODE,		@SALE_TEAM_NAME,		@PROFIT_EMP_CODE,
			@SALE_COM_CODE,		
			@PROFIT_TEAM_CODE,	@PROFIT_TEAM_NAME,	@CUS_NO,			@LAST_PAY_DATE	,
			@MASTER_CODE,		
			@RES_PRO_TYPE ,		@ETC
		)

		--IF( @PRO_TYPE = 3 )
		--BEGIN
		--	SELECT TOP 10 * FROM RES_HTL_ROOM_MASTER
		--	INSERT INTO RES_HTL_ROOM_MASTER 
		--	(
		--		RES_CODE , MASTER_CODE , RES_STATE , CHECK_IN , CHECK_OUT , 
		--		CITY_CODE , SUP_CODE , LAST_CXL_DATE , ROOM_YN ,
		--		SALE_PRICE , TAX_PRICE , DC_PRICE , CHG_PRICE , PENALTY_PRICE , NET_PRICE , 
		--		HTL_REMARK , CXL_REMARK , NEW_CODE  , NEW_DATE 
		--	)
		--	VALUES 
		--	(
		--		@RES_CODE , @MASTER_CODE , 3 , @DEP_DATE , @ARR_DATE , 
		--		@CITY_CODE , NULL , @LAST_PAY_DATE , 'N' ,
		--		0 , 0 , 0 , 0 , 0 , NET_PRICE , 
		--		HTL_REMARK , CXL_REMARK , NEW_CODE  , NEW_DATE 
		--	)
		--END 
	END 
	-- 채번된 예약 코드 넘기기
	SELECT @RES_CODE
END 
GO
