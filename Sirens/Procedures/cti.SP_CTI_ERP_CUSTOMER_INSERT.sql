USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_ERP_CUSTOMER_INSERT
■ DESCRIPTION				: ERP 고객정보 추가
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec CTI_CONSULT_INSERT 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-10-23		곽병삼			최초생성
   2014-12-04		곽병삼			고객전화번호(핸드폰, 일반번호 구분저장)
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_ERP_CUSTOMER_INSERT]
--DECLARE
	@CUS_NAME	VARCHAR(20),
	@CUS_ID		VARCHAR(20),
	@BIRTH_DATE	VARCHAR(20),
	@GENDER		VARCHAR(1),
	@EMAIL		VARCHAR(40),
	@NOR_TEL1	VARCHAR(6),
	@NOR_TEL2	VARCHAR(4),
	@NOR_TEL3	VARCHAR(4),
	@EMP_CODE	VARCHAR(7)

--SET @CUS_NAME = '테스트'
--SET @CUS_ID = ''
--SET @BIRTH_DATE = '2014-10-23'
--SET @GENDER = 'M'
--SET @EMAIL = 'sam9339@naver.com'
--SET @NOR_TEL1 = '010'
--SET @NOR_TEL2 = '5566'
--SET @NOR_TEL3 = '4455'
--SET @EMP_CODE = '2012019'

AS

BEGIN

	DECLARE
		@HOM_TEL1	VARCHAR(6),
		@HOM_TEL2	VARCHAR(4),
		@HOM_TEL3	VARCHAR(4)

	IF LEFT(@NOR_TEL1,2) <> '01'
	BEGIN
		SET @HOM_TEL1 = @NOR_TEL1
		SET @HOM_TEL2 = @NOR_TEL2
		SET @HOM_TEL3 = @NOR_TEL3

		SET @NOR_TEL1 = NULL
		SET @NOR_TEL2 = NULL
		SET @NOR_TEL3 = NULL
	END

	INSERT INTO Diablo.DBO.CUS_CUSTOMER_DAMO (
		CUS_NAME,
		--CUS_ID,
		BIRTH_DATE,
		GENDER,
		EMAIL,
		NOR_TEL1,
		NOR_TEL2,
		NOR_TEL3,
		HOM_TEL1,
		HOM_TEL2,
		HOM_TEL3,
		NEW_CODE,
		NEW_DATE )
	VALUES (
		@CUS_NAME,
		--@CUS_ID,
		CAST(@BIRTH_DATE AS DATETIME),
		@GENDER,
		@EMAIL,
		@NOR_TEL1,
		@NOR_TEL2,
		@NOR_TEL3,
		@HOM_TEL1,
		@HOM_TEL2,
		@HOM_TEL3,
		@EMP_CODE,
		GETDATE()
	)

	SELECT @@IDENTITY AS CUS_NO
END
GO
