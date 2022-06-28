USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_MOV2_SNS_INFO_SELECT
■ DESCRIPTION				: 검색_SNS 정보
■ INPUT PARAMETER			: CUS_NO
■ EXEC						: 
    -- EXEC SP_MOV2_SNS_INFO_SELECT 7225080 

■ MEMO						: SNS 정보을 조회한다.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-01	  아이비솔루션				최초생성
   2017-10-23		정지용					수정
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_SNS_INFO_SELECT]
	@CUS_NO				INT
AS
BEGIN	
	SET NOCOUNT ON;
	/*
	SELECT A.* FROM CUS_SNS_INFO A 
	WHERE A.CUS_NO = @CUS_NO
		AND A.DISCNT_DATE IS NULL
	*/
	SELECT 
		@CUS_NO AS CUS_NO, A.PUB_CODE AS SNS_COMPANY, B.SNS_ID, B.SNS_EMAIL, B.SNS_NAME, B.NEW_DATE, B.DISCNT_DATE 
	FROM COD_PUBLIC A WITH(NOLOCK) 
	LEFT JOIN (
		SELECT A.* FROM CUS_SNS_INFO A WITH(NOLOCK)
		WHERE A.CUS_NO = @CUS_NO AND A.DISCNT_DATE IS NULL	
	) B ON B.SNS_COMPANY = A.PUB_CODE
	WHERE A.PUB_TYPE = 'EXTERNAL.PROVIDER' AND A.USE_YN = 'Y'

END


GO
