USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_BIZTRIP_DETAIL_INSERT
■ DESCRIPTION				: 출장예약 상세 등록 - 예약자cus_no 와 직원 매핑  
■ INPUT PARAMETER			: 
	
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-03-10		박형만			최초생성    
   2016-04-06		박형만			@PRO_DETAIL_TYPE 추가
   2016-04-19		김성호			COM_BIZTRIP_DETAIL 테이블에서 PAY_REQUEST_DATE 제거
   2016-05-10		박형만			COM_BIZTRIP_DETAIL 테이블에서 BT_PURPOSE 제거
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BIZTRIP_DETAIL_INSERT] 
(
	@AGT_CODE	varchar(10),
	@BT_CODE	varchar(20),
	@BT_PURPOSE	varchar(100) = null , -- 출장사유 (삭제 보류)
	@RES_CODE	VARCHAR(20),
	@PRO_DETAIL_TYPE int = 9 , --항공 = 2, 호텔 = 3, 렌트카 = 4, 비자 = 5, 기타 = 9
	@NEW_SEQ	int--,
)
AS
BEGIN
	-- 예약코드 등록되어 있지 않을경우 예약SEQ 넣어주기 
	IF NOT EXISTS (SELECT * FROM COM_BIZTRIP_DETAIL  WHERE AGT_CODE = @AGT_CODE AND BT_CODE = @BT_CODE AND RES_CODE = @RES_CODE )
	BEGIN 
		DECLARE @BT_RES_SEQ INT 
		SET @BT_RES_SEQ = ISNULL((SELECT MAX(BT_RES_SEQ) FROM COM_BIZTRIP_DETAIL WITH(NOLOCK) WHERE AGT_CODE = @AGT_CODE AND BT_CODE = @BT_CODE),0) + 1 
		--출장예약 순번 넣기 
		INSERT INTO COM_BIZTRIP_DETAIL (AGT_CODE,BT_CODE,BT_RES_SEQ,RES_CODE,PRO_DETAIL_TYPE)
		SELECT @AGT_CODE , @BT_CODE , @BT_RES_SEQ , @RES_CODE ,@PRO_DETAIL_TYPE
	END 

	DECLARE @CUS_NO INT 
	--CUS_NO 가져오기 
	SET @CUS_NO = ISNULL((SELECT CUS_NO FROM RES_MASTER_damo WITH(NOLOCK ) WHERE RES_CODE = @RES_CODE),0)

	----------------------------------------------------------------------------------------------------
	-- 직원과 CUS_NO 가 매핑될 경우 
	IF(@CUS_NO > 0)
	BEGIN
		IF EXISTS ( SELECT * FROM COM_EMPLOYEE_MATCHING WHERE AGT_CODE = @AGT_CODE AND EMP_SEQ  = @NEW_SEQ ) 
		BEGIN
			UPDATE 	COM_EMPLOYEE_MATCHING 
			SET CUS_NO = @CUS_NO , NEW_DATE = GETDATE() , NEW_CODE  = '9999999'
			WHERE AGT_CODE = @AGT_CODE AND EMP_SEQ  = @NEW_SEQ
		END
		ELSE 
		BEGIN 
			INSERT INTO COM_EMPLOYEE_MATCHING 
			( AGT_CODE , EMP_SEQ , CUS_NO , NEW_DATE , NEW_CODE ) 
			VALUES ( @AGT_CODE , @NEW_SEQ , @CUS_NO , GETDATE() , NULL )  
		END  
		
	END 

END 


GO
