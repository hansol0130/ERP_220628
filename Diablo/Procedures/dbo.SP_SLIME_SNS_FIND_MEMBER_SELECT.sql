USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_MOV2_SNS_FIND_MEMBER_SELECT
■ DESCRIPTION				: 검색_SNS 회원정보
■ INPUT PARAMETER			: @SNS_EMAIL, @SNS_NAME
■ EXEC						: 
    -- EXEC SP_MOV2_SNS_FIND_MEMBER_SELECT 'poweru@naver.com','오준욱' --SNS 이메일 , SNS 이름

■ MEMO						: SNS 정보와 같은 회원을 조회한다.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-01	  아이비솔루션				최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_SLIME_SNS_FIND_MEMBER_SELECT]
	-- Add the parameters for the stored procedure here
	@SNS_EMAIL			VARCHAR(200),
	@SNS_NAME			VARCHAR(20)
AS
BEGIN
	SELECT
        A.CUS_NO, A.CUS_ID, A.CUS_PASS, A.CUS_NAME, A.NICKNAME, A.FIRST_NAME, A.LAST_NAME, 
	    A.CUS_ICON, A.EMAIL, 
	    A.ZIP_CODE, A.ADDRESS1, A.ADDRESS2,
	    A.NOR_TEL1, A.NOR_TEL2, A.NOR_TEL3, A.GENDER ,
		A.BIRTH_DATE ,A.CERT_YN
	FROM CUS_MEMBER AS A WITH(NOLOCK)
	WHERE A.EMAIL = @SNS_EMAIL 
		AND A.CUS_NAME = @SNS_NAME
END

GO
