USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_MOV2_SNS_CUS_BIRTHDAY_UPDATE
■ DESCRIPTION				: 입력_SNS 생년월일 업데이트
■ INPUT PARAMETER			: @CUS_NO, @BIRTH_DATE
■ EXEC						: 
    -- EXEC SP_MOV2_SNS_CUS_BIRTHDAY_UPDATE '8505125', '2017-10-01', 'F'

■ MEMO						: SNS 회원 추가수정시 생년월일 업데이트
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-01	  아이비솔루션				최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_SNS_CUS_BIRTHDAY_UPDATE]

	@CUS_NO					INT,
	@BIRTH_DATE				datetime,
	@GENDER					char(1)

AS

BEGIN
	
	UPDATE CUS_CUSTOMER_DAMO
		SET BIRTH_DATE = @BIRTH_DATE,
			GENDER = @GENDER
		WHERE CUS_NO = @CUS_NO

	UPDATE CUS_MEMBER
		SET BIRTH_DATE = @BIRTH_DATE,
			GENDER = @GENDER
		WHERE CUS_NO = @CUS_NO

END

GO
