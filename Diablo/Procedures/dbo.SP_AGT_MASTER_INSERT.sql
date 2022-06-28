USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_AGT_MASTER_INSERT
■ DESCRIPTION				: ERP 거래처 등록
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
	재무회계 팀 요청으로 거래처 유형별로 번호 따서 입력되도록 수정 및 기존에 리소스로 되어있던 것 프로시져로 변경
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-03-20		정지용			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_AGT_MASTER_INSERT]
	@AGT_REGISTER CHAR(10),
	@KOR_NAME VARCHAR(50),
	@ENG_NAME VARCHAR(30),
	@CEO_NAME VARCHAR(50),
	@AGT_CONDITION VARCHAR(50),
	@AGT_ITEM VARCHAR(50),
	@ZIP_CODE VARCHAR(10),
	@ADDRESS1 VARCHAR(100),
	@ADDRESS2 VARCHAR(100),
	@NOR_TEL1 VARCHAR(6),
	@NOR_TEL2 VARCHAR(5),
	@NOR_TEL3 VARCHAR(4),
	@FAX_TEL1 VARCHAR(6),
	@FAX_TEL2 VARCHAR(5),
	@FAX_TEL3 VARCHAR(4),
	@ADMIN_REMARK VARCHAR(300),
	@SHOW_YN USE_Y,
	@NEW_CODE NEW_CODE,
	@URL VARCHAR(50),
	@AGT_PART_CODE CHAR(2),
	@AGT_NAME VARCHAR(50),
	@USE_CODE VARCHAR(10),
	@AREA_CODE VARCHAR(25),
	@TAX_YN CHAR(1),
	@COMM_RATE DECIMAL,
	@AGT_TYPE_CODE CHAR(2),
	@BTMS_YN CHAR(1)
AS
BEGIN

	DECLARE @NEW_AGT_CODE INT;
	SELECT @NEW_AGT_CODE = MIN(A.AGT_CODE)
	FROM (
		SELECT TOP 999 @AGT_TYPE_CODE + RIGHT(('00' + CONVERT(VARCHAR(3), NUMBER)), 3) AS [AGT_CODE]
		FROM MASTER.DBO.SPT_VALUES A WITH(NOLOCK)
		WHERE TYPE = 'P' AND NUMBER >= 0
	) A
	LEFT JOIN DIABLO.DBO.AGT_MASTER B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE
	WHERE B.AGT_CODE IS NULL

	INSERT AGT_MASTER
	(
		AGT_CODE,		AGT_REGISTER,		KOR_NAME,		ENG_NAME,
		CEO_NAME,		AGT_CONDITION,		AGT_ITEM,		AGT_TYPE_CODE,	
		ZIP_CODE,		ADDRESS1,			ADDRESS2,		NOR_TEL1,
		NOR_TEL2,		NOR_TEL3,			FAX_TEL1,		FAX_TEL2,
		FAX_TEL3,		ADMIN_REMARK,		SHOW_YN,		NEW_DATE,
		NEW_CODE,		URL,				AGT_PART_CODE,	AGT_NAME,
		USE_CODE,		AREA_CODE,			TAX_YN,			COMM_RATE,
		BTMS_YN
	)
	VALUES
	(
		@NEW_AGT_CODE,	@AGT_REGISTER,		@KOR_NAME,		@ENG_NAME,
		@CEO_NAME,		@AGT_CONDITION,		@AGT_ITEM,		@AGT_TYPE_CODE,	
		@ZIP_CODE,		@ADDRESS1,			@ADDRESS2,		@NOR_TEL1,
		@NOR_TEL2,		@NOR_TEL3,			@FAX_TEL1,		@FAX_TEL2,
		@FAX_TEL3,		@ADMIN_REMARK,		@SHOW_YN,		GETDATE(),
		@NEW_CODE,		@URL,				@AGT_PART_CODE,	@AGT_NAME,
		@USE_CODE,		@AREA_CODE,			@TAX_YN,		@COMM_RATE,
		@BTMS_YN
	);

	SELECT @NEW_AGT_CODE;

END
GO
