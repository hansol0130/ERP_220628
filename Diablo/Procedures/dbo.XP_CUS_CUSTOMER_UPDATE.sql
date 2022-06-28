USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_CUS_CUSTOMER_UPDATE
■ DESCRIPTION				: 통합고객 정보 수정(ERP)
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec  XP_CUS_CUSTOMER_UPDATE 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-03-23		박형만			최초생성
================================================================================================================*/ 
CREATE  PROC [dbo].[XP_CUS_CUSTOMER_UPDATE]
(
	@CUS_NO INT , 
	@NOR_TEL1 VARCHAR(6), 
	@NOR_TEL2 VARCHAR(5), 
	@NOR_TEL3 VARCHAR(4),
	@HOM_TEL1 VARCHAR(6), 
	@HOM_TEL2 VARCHAR(5), 
	@HOM_TEL3 VARCHAR(4), 
	@COM_TEL1 VARCHAR(6), 
	@COM_TEL2 VARCHAR(5), 
	@COM_TEL3 VARCHAR(4), 
	@ZIP_CODE VARCHAR(7), 
	@ADDRESS1 VARCHAR(100), 
	@ADDRESS2 VARCHAR(100), 
	@EMAIL	VARCHAR(40),
	@ETC VARCHAR(1000),
	@EDT_MESSAGE varchar(1000),
	@EDT_CODE NEW_CODE
)
AS 

BEGIN

	--기록남기기 
	EXEC XP_CUS_CUSTOMER_HISTORY_INSERT  
	@CUS_NO = @CUS_NO, 
	
	@NOR_TEL1 = @NOR_TEL1,
	@NOR_TEL2 = @NOR_TEL2,
	@NOR_TEL3 = @NOR_TEL3,
	@HOM_TEL1 = @HOM_TEL1,
	@HOM_TEL2 = @HOM_TEL2,
	@HOM_TEL3 = @HOM_TEL3,
	@COM_TEL1 = @COM_TEL1,
	@COM_TEL2 = @COM_TEL2,
	@COM_TEL3 = @COM_TEL3,

	@ZIP_CODE = @ZIP_CODE,
	@ADDRESS1 = @ADDRESS1,
	@ADDRESS2 = @ADDRESS2,
	@EMAIL	= @EMAIL,

	@EMP_CODE = @EDT_CODE , 
	@EDT_REMARK = @EDT_MESSAGE , 
	@EDT_TYPE  = 1 

	UPDATE CUS_CUSTOMER_DAMO 
		SET EMAIL = @EMAIL
		, NOR_TEL1 = @NOR_TEL1
		, NOR_TEL2 = @NOR_TEL2
		, NOR_TEL3 = @NOR_TEL3
		, HOM_TEL1 = @HOM_TEL1
		, HOM_TEL2 = @HOM_TEL2
		, HOM_TEL3 = @HOM_TEL3
		, COM_TEL1 = @COM_TEL1
		, COM_TEL2 = @COM_TEL2
		, COM_TEL3 = @COM_TEL3
		--, [NATIONAL] = @NATIONAL
		, ETC = @ETC
		, ADDRESS1 = @ADDRESS1
		, ADDRESS2 = @ADDRESS2
		, ZIP_CODE = @ZIP_CODE
		, EDT_CODE = @EDT_CODE
		, EDT_DATE = GETDATE()
		, EDT_MESSAGE = @EDT_MESSAGE 
	 WHERE 
		CUS_NO = @CUS_NO

	IF EXISTS ( SELECT * FROM CUS_MEMBER_SLEEP WHERE CUS_NO = @CUS_NO )
	BEGIN 
		UPDATE CUS_MEMBER_SLEEP 
			SET EMAIL = @EMAIL
			, NOR_TEL1 = @NOR_TEL1
			, NOR_TEL2 = @NOR_TEL2
			, NOR_TEL3 = @NOR_TEL3
			, HOM_TEL1 = @HOM_TEL1
			, HOM_TEL2 = @HOM_TEL2
			, HOM_TEL3 = @HOM_TEL3
			, COM_TEL1 = @COM_TEL1
			, COM_TEL2 = @COM_TEL2
			, COM_TEL3 = @COM_TEL3
			--, [NATIONAL] = @NATIONAL
			, ETC = @ETC
			, ADDRESS1 = @ADDRESS1
			, ADDRESS2 = @ADDRESS2
			, ZIP_CODE = @ZIP_CODE
			, EDT_CODE = @EDT_CODE
			, EDT_DATE = GETDATE()
			, EDT_MESSAGE = @EDT_MESSAGE 
		 WHERE 
			CUS_NO = @CUS_NO
	END 

	IF EXISTS ( SELECT * FROM CUS_MEMBER WHERE CUS_NO = @CUS_NO )
	BEGIN 
		UPDATE CUS_MEMBER
			SET EMAIL = @EMAIL
			, NOR_TEL1 = @NOR_TEL1
			, NOR_TEL2 = @NOR_TEL2
			, NOR_TEL3 = @NOR_TEL3
			, HOM_TEL1 = @HOM_TEL1
			, HOM_TEL2 = @HOM_TEL2
			, HOM_TEL3 = @HOM_TEL3
			, COM_TEL1 = @COM_TEL1
			, COM_TEL2 = @COM_TEL2
			, COM_TEL3 = @COM_TEL3
			--, [NATIONAL] = @NATIONAL
			, ETC = @ETC
			, ADDRESS1 = @ADDRESS1
			, ADDRESS2 = @ADDRESS2
			, ZIP_CODE = @ZIP_CODE
			, EDT_CODE = @EDT_CODE
			, EDT_DATE = GETDATE()
			, EDT_MESSAGE = @EDT_MESSAGE 
		 WHERE 
			CUS_NO = @CUS_NO
	END 
END


GO
