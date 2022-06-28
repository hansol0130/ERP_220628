USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_WEB_RES_AIR_CUSTOMER_DETAIL_INSERT
■ DESCRIPTION				: 출장예약 체류지 정보 등록/수정 
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
   2016-05-10		박형만			체류지정보 업데이트 
================================================================================================================*/ 
create PROC [dbo].[XP_WEB_RES_AIR_CUSTOMER_DETAIL_INSERT]
(
	@SEQ_NO int,
	@RES_CODE RES_CODE ,
	@STAY_NATION varchar(10),
	@STAY_CITY_CODE varchar(10),
	@STAY_ADDRESS varchar(200),
	@STAY_ZIP_CODE varchar(10),
	@STAY_TEL varchar(50),
	@MILEAGE_REF varchar(20)
--DEP_MILEAGE_REF varchar no	20
--DEP_AIRLINE_CODE char no	2
--DEP_DC_CODE varchar no	5
--DEP_DC_NAME varchar no	200
--DEP_DC_RATE decimal no	5
--ARR_MILEAGE_REF varchar no	20
--ARR_AIRLINE_CODE char no	2
--ARR_DC_CODE varchar no	5
--ARR_DC_NAME varchar no	200
--ARR_DC_RATE decimal no	5
--BIRTH_DAY varchar no	10
)
AS 

IF NOT EXISTS (SELECT TOP 100 * FROM RES_AIR_CUSTOMER_DETAIL WHERE RES_CODE =@RES_CODE AND SEQ_NO = @SEQ_NO )
BEGIN

	INSERT INTO RES_AIR_CUSTOMER_DETAIL (
	 SEQ_NO ,
		RES_CODE ,
		STAY_NATION ,
		STAY_CITY_CODE ,
		STAY_ADDRESS ,
		STAY_ZIP_CODE ,
		STAY_TEL ,
		MILEAGE_REF)
	VALUES ( @SEQ_NO ,
		@RES_CODE ,
		@STAY_NATION ,
		@STAY_CITY_CODE ,
		@STAY_ADDRESS ,
		@STAY_ZIP_CODE ,
		@STAY_TEL ,
		@MILEAGE_REF ) 
END 
ELSE
BEGIN
	UPDATE RES_AIR_CUSTOMER_DETAIL 
	SET   
		STAY_NATION = @STAY_NATION,
		STAY_CITY_CODE = @STAY_CITY_CODE,
		STAY_ADDRESS = @STAY_ADDRESS,
		STAY_ZIP_CODE = @STAY_ZIP_CODE,
		STAY_TEL = @STAY_TEL,
		MILEAGE_REF= @MILEAGE_REF 
	WHERE RES_CODE =@RES_CODE AND SEQ_NO = @SEQ_NO
END 

--체류지정보 필드 업데이트 
UPDATE RES_AIR_DETAIL 
SET STAY_ADDRESS = ISNULL(@STAY_NATION,'') + '/' +  ISNULL(@STAY_CITY_CODE,'')+ '/' +  ISNULL(@STAY_ADDRESS,'')+ '/' +  ISNULL(@STAY_ZIP_CODE,'')+ '/' +  ISNULL(@STAY_TEL,'')
WHERE RES_CODE =@RES_CODE  

GO
