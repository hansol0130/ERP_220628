USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_BIZTRIP_MASTER_INSERT
■ DESCRIPTION				: 출장예약마스터 등록및 수정 
■ INPUT PARAMETER			: 
	
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-02-26		박형만			최초생성    
   2016-04-06		박형만			출장마스터 최근예약일 추가 , PRO_TYPE 변수 제거 , 출장명 넣기
   2016-04-19		김성호			COM_BIZTRIP_MASTER PAY_REQUEST_DATE 컬럼 추가, EDT_SEQ => EDT_CODE 로 변경
   2016-05-11		박형만			사용되는 규정없으면 승인불필요 처리 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BIZTRIP_MASTER_INSERT] 
(
	@PRO_TYPE INT = 0,
	@PRO_CODE VARCHAR(20), --행사코드 -- BT 코드에 연결된 행사코드가 있을경우 무시 
	--@CUS_NO INT ,  -- 아래 에서 구함 

	@AGT_CODE	varchar(10),
	@BT_CODE	varchar(20),  -- 신규 등록시 빈값
	@BT_NAME	varchar(200),  -- 최초 등록시에만 
	@BT_CITY_CODE	varchar(3),
	@BT_START_DATE	datetime,
	@BT_END_DATE	datetime,
	--@BT_STATE	int,
	@BT_TIME_LIMIT	datetime,
	--@NEW_DATE	datetime,
	@NEW_SEQ	int ,
	@EMP_SEQ	VARCHAR(100) = NULL  --출장자 리스트  122,100
	--@EDT_DATE	datetime,
	--@EDT_SEQ	int,
	--@CONFIRM_DATE	datetime,
	--@CONFIRM_EMP_SEQ	int,
	--@CONFIRM_REMARK	varchar(50),
	--@APPROVAL_STATE	int
)
AS 
BEGIN 
	--DECLARE @PRO_TYPE INT ,
	----@PRO_CODE VARCHAR(20),
	--@RES_CODE VARCHAR(12),
	--@CUS_NO INT 

	--DECLARE @AGT_CODE	varchar(10),
	--	@BT_CODE	varchar(20),
	--	@BT_CITY_CODE	int,
	--	@BT_START_DATE	datetime,
	--	@BT_END_DATE	datetime,
	--	@BT_STATE	int,
	--	@BT_TIME_LIMIT	datetime,
	--	--@NEW_DATE	datetime,
	--	@NEW_SEQ	int,
	--	--@EDT_DATE	datetime,
	--	--@EDT_SEQ	int,
	--	--@CONFIRM_DATE	datetime,
	--	--@CONFIRM_EMP_SEQ	int,
	--	--@CONFIRM_REMARK	varchar(50),
	--	@APPROVAL_STATE	int
	--	--@REQUEST_DATE	datetime,
	--	--@REQUEST_REMARK	varchar(50) 

	--SELECT @PRO_TYPE = 2 
	----,@PRO_CODE = 'KTR011-12312'
	--,@RES_CODE = 'RP1602051231'
	--,@CUS_NO = 0 ; 

	--SELECT @AGT_CODE = '92756',
	--	@BT_CODE	= 'BT1602260008',
	--	@BT_CITY_CODE	= 0 ,
	--	@BT_START_DATE	='2016-02-27',
	--	@BT_END_DATE	='2016-02-29',
	--	@BT_STATE	= 0 ,
	--	@BT_TIME_LIMIT	= '2016-02-27',--최초결제마감일
	--	--@NEW_DATE	= getdate(),
	--	@NEW_SEQ	= 100 ,
	--	--@EDT_DATE	datetime,
	--	--@EDT_SEQ	= 0 ,
	--	--@CONFIRM_DATE	datetime,
	--	--@CONFIRM_EMP_SEQ	int,
	--	--@CONFIRM_REMARK	 = '',
	--	@APPROVAL_STATE	= 0  -- 승인상태 
	--	--@REQUEST_DATE	datetime,
	--	--@REQUEST_REMARK	= ''
	----------------------------------------------------------------------------------------------------
	-- 출장예약코드 무조건 있음 

	--상태 관련 
	--BT_STATE BizTripStateTypeEnum { 예약 = 0, 환불 = 7, 취소 = 9 }
	--APPROVAL_STATE BizTripApprovalTypeEnum { 출장대기 = 0, 출장요청 = 1, 출장확정 = 2, 출장반려 = 9}
	--출장 최초 상태 구하기 
	DECLARE @CONFIRM_YN CHAR(1)
	SET @CONFIRM_YN =  
		ISNULL((SELECT TOP 1 B.CONFIRM_YN  FROM DBO.FN_COM_BIZTRIP_GROUP_INFO(@AGT_CODE, @EMP_SEQ) A 
			INNER JOIN COM_BIZTRIP_GROUP B 
				ON A.BT_SEQ = B.BT_SEQ 
				AND A.AGT_CODE = B.AGT_CODE 
		ORDER BY A.ORDER_NUM),'N')  -- 사용되는 규정이 없으면 전부 승인 필요없음 

	DECLARE @APPROVAL_STATE INT 
	SET @APPROVAL_STATE = (CASE WHEN @CONFIRM_YN = 'N' THEN 2 ELSE 0 END) --  승인불필요시 출장확정:2 로 

	----------------------------------------------------------------------------------------------------
	--출장예약마스터 넣기 
	IF NOT EXISTS (SELECT * FROM COM_BIZTRIP_MASTER WHERE AGT_CODE = @AGT_CODE AND BT_CODE = @BT_CODE)
	BEGIN
		INSERT INTO COM_BIZTRIP_MASTER ( AGT_CODE, BT_CODE, BT_NAME ,PRO_CODE, BT_CITY_CODE, BT_START_DATE, BT_END_DATE, BT_TIME_LIMIT, 
			NEW_DATE, NEW_SEQ, EDT_DATE, EDT_CODE, 
			CONFIRM_DATE, CONFIRM_EMP_SEQ, CONFIRM_REMARK, 
			APPROVAL_STATE, REQUEST_DATE, REQUEST_REMARK , LAST_NEW_DATE, PAY_REQUEST_DATE )
		VALUES ( @AGT_CODE, @BT_CODE, @BT_NAME ,@PRO_CODE, @BT_CITY_CODE, @BT_START_DATE, @BT_END_DATE, @BT_TIME_LIMIT, 
			GETDATE(), @NEW_SEQ, NULL, NULL, 
			NULL, NULL, NULL, 
			@APPROVAL_STATE , NULL, NULL , GETDATE(), GETDATE() ) 
	END 
	ELSE --이미 있을경우  
	BEGIN 
		--출장예약 수정 
		--기존 정보 구하기 
		DECLARE @ORG_BT_START_DATE DATETIME 
		DECLARE @ORG_BT_END_DATE DATETIME 
		DECLARE @ORG_BT_TIME_LIMIT DATETIME 
		DECLARE @ORG_BT_CITY_CODE VARCHAR(3)
		DECLARE @ORG_APPROVAL_STATE INT
		SELECT @ORG_BT_START_DATE = BT_START_DATE , @ORG_BT_END_DATE = BT_END_DATE  ,
			@ORG_BT_TIME_LIMIT = BT_TIME_LIMIT ,
			@ORG_BT_CITY_CODE = BT_CITY_CODE ,
			@ORG_APPROVAL_STATE = APPROVAL_STATE
		FROM COM_BIZTRIP_MASTER WHERE AGT_CODE = @AGT_CODE AND BT_CODE = @BT_CODE

		--원래 출발일보다 이후 일경우 기존 출발일 유지
		IF (@ORG_BT_START_DATE < @BT_START_DATE )
		BEGIN
			SET @BT_START_DATE =  @ORG_BT_START_DATE 
			-- 처음 입력된 도시 그대로 유지  
			IF(ISNULL(@ORG_BT_CITY_CODE,'') <> '')
			BEGIN 
				SET @BT_CITY_CODE = @ORG_BT_CITY_CODE 
			END 
		END 
		
		--원래 도착일보다 더 이전일경우 기존 도착일 유지
		IF (@ORG_BT_END_DATE > @BT_END_DATE)
		BEGIN
			SET @BT_END_DATE =  @ORG_BT_END_DATE 
		END 
		--원래 마감일보다 더 이후 일경우 기존 마감일 유지 
		IF (@ORG_BT_TIME_LIMIT < @BT_TIME_LIMIT )
		BEGIN
			SET @BT_TIME_LIMIT =  @ORG_BT_TIME_LIMIT --갱신 
		END 

		--출장예약 수정 
		UPDATE COM_BIZTRIP_MASTER 
		SET BT_CITY_CODE = @BT_CITY_CODE  , BT_START_DATE =@BT_START_DATE  , BT_END_DATE = @BT_END_DATE,
			BT_TIME_LIMIT = @BT_TIME_LIMIT  ,
			APPROVAL_STATE = @APPROVAL_STATE ,  -- 출장상태는 무조건 마지막껄로 갱신 
			LAST_NEW_DATE = GETDATE()
			
			--, PRO_CODE = @PRO_CODE  --행사코드도 갱신 
			
		WHERE AGT_CODE = @AGT_CODE AND BT_CODE = @BT_CODE
	END 

	SELECT @BT_CODE 

END
GO
