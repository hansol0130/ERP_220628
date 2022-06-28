USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_CLIENT_DETAIL_INFO_UPDATE
■ DESCRIPTION				: BTMS 거래처 상세 정보 수정
■ INPUT PARAMETER			: AGT_CODE
■ OUTPUT PARAMETER			: 
■ EXEC						: 	
	EXEC XP_COM_CLIENT_DETAIL_INFO_UPDATE
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-13		저스트고강태영			최초생성
   2016-06-07		김성호					BTMS_YN 항목 추가
   2016-07-27		김성호					COM_MASTER 테이블 SALE_RATE 추가
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_CLIENT_DETAIL_INFO_UPDATE]
	@AGT_CODE varchar(10),@SHOW_YN VARCHAR(1),@AGT_TYPE_CODE char(2),@USE_CODE varchar(10),@AGT_PART_CODE char(2),
	@KOR_NAME varchar(50),@AGT_NAME varchar(50),@CEO_NAME varchar(50),@NOR_TEL1 varchar(6),@NOR_TEL2 varchar(5),@NOR_TEL3 varchar(4),
	@FAX_TEL1 varchar(6),@FAX_TEL2 varchar(5),@FAX_TEL3 varchar(4),@AGT_REGISTER char(10),@AGT_CONDITION varchar(30),
	@AGT_ITEM varchar(30),@ZIP_CODE varchar(10),@ADDRESS1 varchar(100),@ADDRESS2 varchar(100),@URL varchar(50),@TAX_YN VARCHAR(1),
	@COMM_RATE decimal(4, 2),@PAY_LATER_YN char(1),@ADMIN_REMARK varchar(300),@EDT_CODE char(7),
	@PARENT_AGT_CODE varchar(10),@COMPANY_NUMBER varchar(20),@CON_START_DATE datetime,@CON_END_DATE DATETIME,@EDT_SEQ INT,
	@AGT_ID varchar(20),@BTMS_YN VARCHAR(1),@SALE_RATE decimal(4, 2) = 0 
AS 
BEGIN

	-- 임시
	--DECLARE @SALE_RATE DECIMAL(4,2) = 0.0

	--거래처 정보
	UPDATE AGT_MASTER SET
		SHOW_YN = @SHOW_YN,
		AGT_TYPE_CODE = @AGT_TYPE_CODE,
		USE_CODE = @USE_CODE,
		AGT_PART_CODE = @AGT_PART_CODE,
		KOR_NAME = @KOR_NAME,
		AGT_NAME = @AGT_NAME,
		CEO_NAME = @CEO_NAME,
		NOR_TEL1 = @NOR_TEL1,
		NOR_TEL2 = @NOR_TEL2,
		NOR_TEL3 = @NOR_TEL3,
		FAX_TEL1 = @FAX_TEL1,
		FAX_TEL2 = @FAX_TEL2,
		FAX_TEL3 = @FAX_TEL3,
		AGT_REGISTER = @AGT_REGISTER,
		AGT_CONDITION = @AGT_CONDITION,
		AGT_ITEM = @AGT_ITEM,
		ZIP_CODE = @ZIP_CODE,
		ADDRESS1 = @ADDRESS1,
		ADDRESS2 = @ADDRESS2,
		URL = @URL,
		TAX_YN = @TAX_YN,
		COMM_RATE = @COMM_RATE,
		PAY_LATER_YN = @PAY_LATER_YN,
		ADMIN_REMARK = @ADMIN_REMARK,
		BTMS_YN = @BTMS_YN,
		EDT_DATE = GETDATE(),
		EDT_CODE = @EDT_SEQ
	WHERE
		AGT_CODE = @AGT_CODE
	
	IF EXISTS(SELECT 1 FROM COM_MASTER WITH(NOLOCK) WHERE AGT_CODE = @AGT_CODE)
	BEGIN

		UPDATE COM_MASTER SET
			PARENT_AGT_CODE = @PARENT_AGT_CODE,
			COMPANY_NUMBER = @COMPANY_NUMBER,
			CON_START_DATE = @CON_START_DATE,
			CON_END_DATE = @CON_END_DATE,
			SALE_RATE = @SALE_RATE,
			EDT_DATE = GETDATE(),
			EDT_SEQ = @EDT_SEQ,
			AGT_ID = @AGT_ID
		WHERE
			AGT_CODE = @AGT_CODE

	END
	ELSE
	BEGIN
	
		INSERT INTO COM_MASTER
		(
			AGT_CODE,
			PARENT_AGT_CODE,
			COMPANY_NUMBER,
			CON_START_DATE,
			CON_END_DATE,
			SALE_RATE,
			EDT_DATE,
			EDT_SEQ,
			AGT_ID
		)
		VALUES
		(
			@AGT_CODE,
			@PARENT_AGT_CODE,
			@COMPANY_NUMBER,
			@CON_START_DATE,
			@CON_END_DATE,
			@SALE_RATE,
			GETDATE(),
			@EDT_SEQ,
			@AGT_ID
		)

	END
END 

GO
