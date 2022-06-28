USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================    
■ USP_Name				: [dbo].[SP_RES_GET_RES_CODE]      
■ Description			: 예약코드 생성 SP
■ Input Parameter		: 
	@RES_TYPE			: 상품타입
	@RES_CODE OUTPUT	: 예약코드
■ Output Parameter		:                      
■ Output Value			:                     
■ Exec					: 

	DECLARE @RES_CODE VARCHAR(20)
	EXEC [dbo].[SP_RES_GET_RES_CODE] 'P', @RES_CODE OUTPUT
	SELECT @RES_CODE

------------------------------------------------------------------------------------------------------------------    
■ Change History
------------------------------------------------------------------------------------------------------------------    
	Date			Author		Description
------------------------------------------------------------------------------------------------------------------
	2009-03-29		김성호		최초생성
	2021-04-13		김성호		테이블 사용에서 시퀀스 사용으로 변경 (Transaction 제거)
	2022-05-02		김성호		행사시퀀스 생성에 따른 시퀀스 네임 변경
================================================================================================================*/
CREATE PROCEDURE [dbo].[SP_RES_GET_RES_CODE]
(
	@RES_TYPE	CHAR(1),
	@RES_CODE	CHAR(12) OUTPUT
)

AS
BEGIN
	
	DECLARE @SEQ_NO INT;
	
	IF @RES_TYPE = 'P'
		SELECT @SEQ_NO = NEXT VALUE FOR dbo.SEQ_RES_PACKAGE
	ELSE IF @RES_TYPE = 'T'
		SELECT @SEQ_NO = NEXT VALUE FOR dbo.SEQ_RES_AIR
	ELSE IF @RES_TYPE = 'H'
		SELECT @SEQ_NO = NEXT VALUE FOR dbo.SEQ_RES_HOTEL
	ELSE
		SELECT @SEQ_NO = NEXT VALUE FOR dbo.SEQ_RES_ETC
	
	SELECT @RES_CODE = ('R' + @RES_TYPE + CONVERT(VARCHAR(6), GETDATE(), 12) + RIGHT(('0000' + CONVERT(VARCHAR(4), @SEQ_NO)), 4));
	
	--BEGIN TRAN;
	--SELECT @SEQ_NO = SEQ_NO FROM RES_SEQ WITH ( XLOCK ) WHERE RES_TYPE = @RES_TYPE;
	--IF @@ROWCOUNT = 0
	--BEGIN
	--	INSERT INTO RES_SEQ(RES_TYPE, SEQ_NO) VALUES(@RES_TYPE, 2);
	--	SET @SEQ_NO = '1';
	--END
	--ELSE
	--	UPDATE RES_SEQ 
	--		SET SEQ_NO = CASE WHEN (SEQ_NO + 1)  > 9999 THEN 1 ELSE (SEQ_NO + 1) END
	--		WHERE RES_TYPE = @RES_TYPE;
	
	--SET @RES_CODE = 'R' + @RES_TYPE + convert(varchar, getdate(),12) + RIGHT('0000' + CONVERT(VARCHAR(4), @SEQ_NO), 4)

	--COMMIT TRAN;
END
GO
