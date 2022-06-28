USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_CONSULT_CUS_TEL_UPDATE
■ DESCRIPTION				: CTI 통화 고객번호 저장
■ INPUT PARAMETER			: 
	@CUS_NO					:고객번호
	@CUS_TEL				:고객전화번호
	@EMP_CODE				:자겁직원코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXECUTE SP_CTI_CONSULT_CUS_TEL_UPDATE @CUS_NO, @CUS_NO, @EMP_CODE

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-13		곽병삼			최초생성
   2015-02-05		박노민			설명추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_CONSULT_CUS_TEL_UPDATE]
--DECLARE
	@CUS_NO		INT,
	@CUS_TEL	VARCHAR(20),
	@EMP_CODE	VARCHAR(7)
AS

BEGIN
	
	MERGE sirens.cti.CTI_CONSULT_CUS_TEL AS TARGET
	USING (SELECT @CUS_TEL AS CUS_TEL) AS SOURCE
	ON (TARGET.CUS_TEL = SOURCE.CUS_TEL)
	WHEN MATCHED THEN
	UPDATE SET 
		TARGET.CUS_NO = @CUS_NO,
		TARGET.EDT_DATE = GETDATE(), 
		TARGET.EDT_CODE = @EMP_CODE
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (CUS_NO, CUS_TEL, NEW_DATE, NEW_CODE)
	VALUES (
		@CUS_NO, 
		@CUS_TEL,
		GETDATE(), @EMP_CODE
	);

END
GO
