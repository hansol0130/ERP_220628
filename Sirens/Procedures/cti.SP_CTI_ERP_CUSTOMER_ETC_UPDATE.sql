USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_ERP_CUSTOMER_ETC_UPDATE
■ DESCRIPTION				: ERP 고객정보 특징 수정
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_ERP_CUSTOMER_ETC_UPDATE 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-13		곽병삼			최초생성
   2015-09-04		정지용			휴면계정으로 인해 회원테이블 업데이트 분기
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_ERP_CUSTOMER_ETC_UPDATE]
--DECLARE
	@CUS_NO	INT,
	@CUS_ID	VARCHAR(20),
	@EMP_CODE	VARCHAR(7),
	@ETC		NVARCHAR(MAX)

--SET @CUS_NAME = '테스트'
--SET @CUS_ID = ''
--SET @EMP_CODE = '2012019'
AS
BEGIN

	--고객의 특징 수정
	UPDATE Diablo.DBO.CUS_CUSTOMER_DAMO 
	SET	ETC = @ETC
	WHERE  CUS_NO = @CUS_NO 

	--정회원정보 고객의 특징 수정
	IF( ISNULL(@CUS_ID,'') <> '')
	BEGIN
		IF EXISTS(SELECT 1 FROM Diablo.dbo.CUS_MEMBER WITH(NOLOCK) WHERE CUS_NO = @CUS_NO AND CUS_ID IS NULL)
		BEGIN
			--정회원정보 수정
			UPDATE Diablo.DBO.CUS_MEMBER_SLEEP
			SET ETC = @ETC
			WHERE  CUS_NO = @CUS_NO 
		END
		ELSE 
		BEGIN
			--정회원정보 수정
			UPDATE Diablo.DBO.CUS_MEMBER
			SET ETC = @ETC
			WHERE  CUS_NO = @CUS_NO 
		END
	END 

	SELECT @CUS_NO as CUS_NO
END
GO
