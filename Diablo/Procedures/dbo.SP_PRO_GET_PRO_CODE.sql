USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================    
■ USP_Name				: [dbo].[SP_PRO_GET_PRO_CODE]      
■ Description			: 행사코드 생성 시 사용 일련번호 반환
■ Input Parameter		: 
	@PRO_TYPE			: 상품타입
	@PRO_CODE OUTPUT	: 상품코드
■ Output Parameter		:                      
■ Output Value			:                     
■ Exec					: 

	DECLARE @PRO_CODE VARCHAR(4)
	EXEC [dbo].[SP_PRO_GET_PRO_CODE] 'P', @PRO_CODE OUTPUT
	SELECT @PRO_CODE

------------------------------------------------------------------------------------------------------------------    
■ Change History
------------------------------------------------------------------------------------------------------------------    
	Date			Author		Description
------------------------------------------------------------------------------------------------------------------
	2009-03-29		김성호		최초생성
	2022-05-02		김성호		테이블 사용에서 시퀀스 사용으로 변경 (Transaction 제거)
================================================================================================================*/
CREATE PROCEDURE [dbo].[SP_PRO_GET_PRO_CODE]
(
	@PRO_TYPE	CHAR(1),
	@PRO_CODE	VARCHAR(4) OUTPUT
)
AS
BEGIN
	DECLARE @SEQ_NO INT;
	
	IF @PRO_TYPE = 'P'
		SELECT @SEQ_NO = NEXT VALUE FOR dbo.SEQ_PRO_PACKAGE
	ELSE IF @PRO_TYPE = 'T'
		SELECT @SEQ_NO = NEXT VALUE FOR dbo.SEQ_PRO_AIR
	ELSE IF @PRO_TYPE = 'H'
		SELECT @SEQ_NO = NEXT VALUE FOR dbo.SEQ_PRO_HOTEL
	ELSE
		SELECT @SEQ_NO = NEXT VALUE FOR dbo.SEQ_PRO_ETC
	
	SELECT @PRO_CODE = RIGHT('0000' + CONVERT(VARCHAR(4), @SEQ_NO), 4);
	
	
	--DECLARE @SEQ_NO VARCHAR(4)

	--BEGIN TRAN;
	--SELECT @SEQ_NO = SEQ_NO FROM PRO_SEQ WITH ( XLOCK ) WHERE PRO_TYPE = @PRO_TYPE;
	--IF @@ROWCOUNT = 0
	--BEGIN
	--	INSERT INTO PRO_SEQ(PRO_TYPE, SEQ_NO) VALUES(@PRO_TYPE, 2);
	--	SET @SEQ_NO = '1';
	--END
	--ELSE
	--	UPDATE PRO_SEQ 
	--		SET SEQ_NO = CASE WHEN (SEQ_NO + 1)  > 9999 THEN 1 ELSE (SEQ_NO + 1) END
	--		WHERE PRO_TYPE = @PRO_TYPE;
	
	--SET @PRO_CODE = RIGHT('0000' + CONVERT(VARCHAR(4), @SEQ_NO), 4)

	--COMMIT TRAN;
END
GO
