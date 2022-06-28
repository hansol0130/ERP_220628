USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_AIR_DOMESTIC_MANUAL_INSERT
■ DESCRIPTION				: 국내항공 정산 수동 처리
■ INPUT PARAMETER			: RES_CODE
■ EXEC						: 
    -- exec SP_AIR_DOMESTIC_MANUAL_INSERT 'RT1905125880'

■ MEMO						: 국내항공의 정산을 수동처리한다.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			   DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-11-29		김남훈	           최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_AIR_DOMESTIC_MANUAL_INSERT]
	@RES_CODE			VARCHAR(12)
AS
BEGIN
	PRINT '정산 수동등록 함수 호출'
    --일단 정산 수동등록 함수를 호출
	EXEC XP_SET_AIR_DOMESTIC_AUTO_INSERT @RES_CODE
	PRINT '정산 수동등록 함수 호출 종료'

	DECLARE @PRO_CODE VARCHAR(20) 
	DECLARE @AGENT_SEQ INT
	DECLARE @AGENT_CODE VARCHAR(10)
	DECLARE @SALE_PRICE INT
	DECLARE @CUSTOMER_CNT INT
	DECLARE @EMP_CODE INT

	--지상비 수동처리

	--PRO_CODE 알아오기.
	SELECT @PRO_CODE = PRO_CODE,@EMP_CODE = SALE_EMP_CODE, @AGENT_CODE = SALE_COM_CODE FROM RES_MASTER_damo WHERE RES_CODE = @RES_CODE 
	SELECT @CUSTOMER_CNT = MAX(SEQ_NO), @SALE_PRICE = SUM(SALE_PRICE) FROM RES_CUSTOMER_damo WHERE RES_CODE = @RES_CODE 

	PRINT '고객수 ' + CONVERT(varchar(15), @CUSTOMER_CNT)
	PRINT '판매금액 ' + CONVERT(varchar(15), @SALE_PRICE)
	PRINT '판매금액/고객수 ' + CONVERT(varchar(10), @SALE_PRICE / @CUSTOMER_CNT) 

	PRINT '지상비 수동처리' + @PRO_CODE

	--지상비 LAND_CUSTOMER 확인해서 없을 경우만 실행
	IF NOT EXISTS(SELECT TOP 1 * FROM SET_LAND_CUSTOMER WHERE RES_CODE = @RES_CODE)
	BEGIN
		PRINT '지상비 수동처리 등록 시작'
		--랜드사 MAX값 얻어와서 +1
		SELECT @AGENT_SEQ = (MAX(LAND_SEQ_NO) + 1) FROM SET_LAND_AGENT WHERE PRO_CODE = @PRO_CODE

		PRINT '랜드사 등록 처리'

		--랜드사 등록
		INSERT INTO SET_LAND_AGENT 
		(
		  PRO_CODE,
		  LAND_SEQ_NO,
		  AGT_CODE,
		  CUR_TYPE,
		  NEW_CODE,
		  NEW_DATE,
		  EDT_CODE,
		  EDT_DATE,
		  REMARK,
		  PAY_PRICE,
		  PAY_PRICE_YN,
		  DOC_YN,
		  EDI_CODE,
		  PAY_DATE,
		  FOC_COUNT,
		  FOREIGN_PRICE,
		  KOREAN_PRICE,
		  VAT_PRICE,
		  RES_COUNT,
		  COM_RATE,
		  COM_PRICE,
		  EXC_RATE		  
		)
		(SELECT TOP 1 
		A.PRO_CODE,
		@AGENT_SEQ,
		A.SALE_COM_CODE,
		0,
		A.SALE_EMP_CODE,
		GETDATE(),
		NULL,
		NULL,
		A.RES_CODE,
		@SALE_PRICE,
		'N',
		'Y',
		9999999999,
		'1900-01-01 00:00:00.000',
		0,
		(@SALE_PRICE / @CUSTOMER_CNT),
		(@SALE_PRICE / @CUSTOMER_CNT),
		0.00,
		@CUSTOMER_CNT,
		0.00,
		0,
		1.00
		FROM 
		RES_MASTER_damo A, RES_CUSTOMER_damo B
		WHERE A.RES_CODE = B.RES_CODE AND
		A.RES_CODE = @RES_CODE)
		PRINT '랜드사 등록 처리 완료'

		PRINT '랜드사 고객 등록 처리'
		--랜드사 고객등록
		INSERT INTO SET_LAND_CUSTOMER 
		(
		  PRO_CODE,
		  LAND_SEQ_NO,
		  RES_CODE,
		  RES_SEQ_NO,
		  VAT_PRICE,
		  EXC_RATE,
		  CUR_TYPE,
		  FOREIGN_PRICE,
		  KOREAN_PRICE,
		  NEW_CODE,
		  NEW_DATE,
		  EDT_CODE,
		  EDT_DATE,
		  REMARK,
		  PAY_PRICE,
		  COM_RATE,
		  COM_PRICE	  
		)
		SELECT
		A.PRO_CODE,
		@AGENT_SEQ,
		@RES_CODE,
		B.SEQ_NO,
		0.00,
		1.00,
		0,
		B.SALE_PRICE,
		B.SALE_PRICE,
		B.NEW_CODE,
		GETDATE(),
		NULL,
		NULL,
		@RES_CODE,
		B.SALE_PRICE,
		0.00,
		0
		FROM RES_MASTER_damo A, RES_CUSTOMER_damo B
		WHERE A.RES_CODE = B.RES_CODE AND
		A.RES_CODE = @RES_CODE
		PRINT '랜드사 고객 등록 처리 완료'

		PRINT '지상비 수동처리 등록 완료'
	END
	ELSE
	BEGIN
		PRINT '지상비 이미 있음'
	END
	

END
GO
