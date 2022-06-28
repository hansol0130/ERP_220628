USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_WEB_RES_MASTER_UPDATE
■ DESCRIPTION				: 예약 마스터 수정
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-09		박형만			최초생성
   2015-03-03		김성호			주민번호 삭제, 생년월일 사용
================================================================================================================*/ 
CREATE  PROC [dbo].[XP_WEB_RES_MASTER_UPDATE]
	@RES_CODE	RES_CODE ,
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
	--@MEMBER_YN  CHAR(1),	
	@CUS_REQUEST NVARCHAR(4000)	
	--@AGENT_YN	CHAR(1), 
	--@AFFILIATE_YN CHAR(1),
	--@RES_CODE	RES_CODE OUTPUT  
AS  
BEGIN

	UPDATE RES_MASTER_DAMO SET
		--PRICE_SEQ = @PRICE_SEQ,		
		RES_NAME = @RES_NAME,		
		--SOC_NUM1 = @SOC_NUM1,
		--SEC_SOC_NUM2 = damo.dbo.enc_varchar('DIABLO', 'dbo.RES_MASTER', 'SOC_NUM2', @SOC_NUM2),
		--SEC1_SOC_NUM2 = damo.dbo.pred_meta_plain_v(@SOC_NUM2, 'DIABLO', 'dbo.RES_MASTER', 'SOC_NUM2'),
		BIRTH_DATE = @BIRTH_DATE,
		GENDER = @GENDER,
		IPIN_DUP_INFO = @IPIN_DUP_INFO,
		RES_EMAIL = @RES_EMAIL,		
		NOR_TEL1 = @NOR_TEL1,		
		NOR_TEL2 = @NOR_TEL2,			
		NOR_TEL3 = @NOR_TEL3, 
		ETC_TEL1 = @ETC_TEL1,		
		ETC_TEL2 = @ETC_TEL2,			
		ETC_TEL3 = @ETC_TEL3,			
		RES_ADDRESS1 = @RES_ADDRESS1,								
		RES_ADDRESS2 = @RES_ADDRESS2,	
		ZIP_CODE = @ZIP_CODE,		
		CUS_REQUEST = @CUS_REQUEST,		
		CUS_NO = @CUS_NO
	WHERE RES_CODE = @RES_CODE;

END 

GO
