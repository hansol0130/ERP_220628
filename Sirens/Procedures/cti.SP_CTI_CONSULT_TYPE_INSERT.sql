USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_CONSULT_TYPE_INSERT
■ DESCRIPTION				: 상담 구분 저장
■ INPUT PARAMETER			: 
	@CONSULT_SEQ			: 상담등록 SEQ
	@CONSULT_TYPE			: 상담구분
	@ITEM_CODE				: 상담구분 예약은 예약코드, 상품은 상품코드
	@EMP_CODE				: 처리 직원코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_CONSULT_TYPE_INSERT @CONSULT_SEQ, @CONSULT_TYPE, @ITEM_CODE, @EMP_CODE

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-21		곽병삼			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_CONSULT_TYPE_INSERT]
--DECLARE
	@CONSULT_SEQ	VARCHAR(14),
	@CONSULT_TYPE	VARCHAR(10),
	@ITEM_CODE		VARCHAR(30),
	@EMP_CODE		VARCHAR(7)

AS
-- CONSULT_TYPE (C:고객, R: 예약, P:상품, D:일반)
--SET @CONSULT_SEQ = '20141119000009'
--SET @CONSULT_TYPE = 'R'
--SET @ITEM_CODE = 'RP1406301908'
--SET @EMP_CODE = '2012010'

BEGIN
	INSERT INTO sirens.cti.CTI_CONSULT_TYPE
	VALUES (
		@CONSULT_SEQ,
		@CONSULT_TYPE,
		@ITEM_CODE,
		GETDATE(),
		@EMP_CODE
	)
END
GO
