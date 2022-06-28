USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_SNS_CUS_SELECT
■ DESCRIPTION				: 검색_SNS 가입정보가 있는 회원
■ INPUT PARAMETER			: @SNS_COMPANY, @SNS_ID
■ EXEC						: 
    -- SP_MOV2_SNS_CUS_SELECT '1','8505125' --SNS 업체 번호 , SNS 발행 아이디

■ MEMO						: SNS 가입정보가 있는 회원을 조회한다.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-05-26	  아이비솔루션				최초생성
   2020-05-26	  김영민(EHD)				 where SNS_COMPANY삭제 select SNS_COMPANY추가
   2020-09-17     홍종우					@SNS_ID VARCHAR(20) -> VARCHAR(100) 변경
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_SLIME_SNS_CUS_SELECT]
	-- Add the parameters for the stored procedure here
	@SNS_ID				VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
        A.CUS_NO, A.CUS_ID, A.CUS_PASS, A.CUS_NAME, A.NICKNAME, A.FIRST_NAME, A.LAST_NAME, 
	    A.CUS_ICON, A.EMAIL, CI.SNS_COMPANY,
		A.IPIN_DUP_INFO , A.IPIN_CONN_INFO,
	    A.ZIP_CODE, A.ADDRESS1, A.ADDRESS2, B.RCV_EMAIL_YN,	B.RCV_SMS_YN, (
		CASE
			WHEN EXISTS(SELECT 1 FROM EMP_MASTER E WITH(NOLOCK) WHERE E.SOC_NUMBER1 = A.SOC_NUM1 AND E.SOC_NUMBER2 = damo.dbo.dec_varchar('DIABLO', 'dbo.CUS_CUSTOMER', 'SOC_NUM2', A.SEC_SOC_NUM2) AND E.WORK_TYPE = '1') THEN 'Y'
			ELSE 'N'
		END ) AS [EMP_YN],
	    A.NOR_TEL1, A.NOR_TEL2, A.NOR_TEL3, A.GENDER ,
		A.BIRTH_DATE  ,A.CERT_YN
	FROM CUS_MEMBER AS A WITH(NOLOCK)
	INNER JOIN CUS_SNS_INFO AS CI WITH(NOLOCK) ON A.CUS_NO =CI.CUS_NO
	LEFT JOIN CUS_CUSTOMER_DAMO B WITH(NOLOCK) ON A.CUS_NO = B.CUS_NO
	WHERE CI.SNS_ID=@SNS_ID  AND CI.DISCNT_DATE IS NULL
END

GO
