USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: [SP_CTI_ERP_CUSTOMER_RESERVE_UPDATE_CUS_NO]
■ DESCRIPTION				: 예약내역의 매칭되지 않은 고객의 CUS_NO 수정 
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_ERP_CUSTOMER_RESERVE_UPDATE_CUS_NO 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-05-14		박형만			최초생성
================================================================================================================*/ 
create PROCEDURE [cti].[SP_CTI_ERP_CUSTOMER_RESERVE_UPDATE_CUS_NO]
--DECLARE
	@RES_CODE VARCHAR(12) , 
	@SEQ_NO INT , 
	@CUS_NO	INT ,
	@EMP_CODE VARCHAR(7) 
--SET @CUS_NAME = '테스트'
--SET @CUS_ID = ''
--SET @EMP_CODE = '2012019'
AS
BEGIN

	DECLARE @CUS_NAME VARCHAR(50) 
	--출발자 번호가 0 이면 
	IF( @SEQ_NO = 0 )
	BEGIN

		
		SET @CUS_NAME = (SELECT RES_NAME FROM Diablo.DBO.RES_MASTER_DAMO WHERE RES_CODE = @RES_CODE)

		-- 예약 마스터 고객 번호 수정 
		UPDATE Diablo.DBO.RES_MASTER_DAMO  
		SET	CUS_NO = @CUS_NO , EDT_DATE = GETDATe() , EDT_CODE = @EMP_CODE
		WHERE  RES_CODE = @RES_CODE 

		---- 매칭되지 않은 고객명 같은 출발자 번호 수정 
		--UPDATE RES_CUSTOMER_DAMO  
		--SET	CUS_NO = @CUS_NO , EDT_DATE = GETDATe() , EDT_CODE = @EMP_CODE
		--WHERE RES_CODE = @RES_CODE 
		--AND CUS_NAME = @CUS_NAME 
		--AND CUS_NO = 1   --매칭되지 않은 
		
	END 
	ELSE 
	BEGIN
		SET @CUS_NAME = (SELECT CUS_NAME FROM Diablo.DBO.RES_CUSTOMER_DAMO WHERE RES_CODE = @RES_CODE AND SEq_NO = @SEQ_NO )

		--예약 출발자 고객 번호 수정 
		UPDATE Diablo.DBO.RES_CUSTOMER_DAMO  
		SET	CUS_NO = @CUS_NO , EDT_DATE = GETDATe() , EDT_CODE = @EMP_CODE
		WHERE  RES_CODE = @RES_CODE 
		AND  SEQ_NO = @SEQ_NO 

		---- 매칭되지 않은 고객명 같은 예약자 번호 수정 
		--UPDATE Diablo.DBO.RES_MASTER_DAMO    
		--SET	CUS_NO = @CUS_NO , EDT_DATE = GETDATe() , EDT_CODE = @EMP_CODE
		--WHERE RES_CODE = @RES_CODE 
		--AND CUS_NO = 1   --매칭되지 않은 

	END 
	SELECT @CUS_NO 
END
GO
