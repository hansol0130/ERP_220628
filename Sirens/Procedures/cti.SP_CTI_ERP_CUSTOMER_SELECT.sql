USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_ERP_CUSTOMER_SELECT
■ DESCRIPTION				: ERP 고객정보 조회
■ INPUT PARAMETER			: 
	@CUS_NO					: 고객번호
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_CODE_MASTER_SEARCH 'CTI000', 'Y'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-10-20		곽병삼			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_ERP_CUSTOMER_SELECT]
--DECLARE
	@CUS_NO	INT

--SET @CUS_NO = 4284582

AS

SELECT
	A.CUS_NO,
	CONVERT(VARCHAR(10),A.NEW_DATE,120) AS NEW_DATE,
	A.CUS_ID,
	A.CUS_NAME,
	A.LAST_NAME,
	A.FIRST_NAME,
	CONVERT(VARCHAR(10),A.BIRTH_DATE,120) AS BIRTH_DATE,
	CONVERT(VARCHAR(10),A.BIRTHDAY,120) AS BIRTHDAY,
	CASE A.GENDER WHEN 'M' THEN '남' WHEN 'F' THEN '여' ELSE '' END AS GENDER,
	A.NOR_TEL1,A.NOR_TEL2,A.NOR_TEL3,
	A.HOM_TEL1,A.HOM_TEL2,A.HOM_TEL3,
	A.COM_TEL1,A.COM_TEL2,A.COM_TEL3,
	A.EMAIL,
	A.RCV_EMAIL_YN,
	A.RCV_SMS_YN,
	B.CARD_NUM AS OKCARDNUM
FROM Diablo.DBO.CUS_CUSTOMER_DAMO A WITH(NOLOCK)
LEFT OUTER JOIN Diablo.DBO.CUS_OCB_AUTH B
ON A.CUS_NO = B.CUS_NO
LEFT OUTER JOIN Diablo.DBO.CUS_POINT C
ON A.CUS_NO = C.CUS_NO
WHERE A.CUS_NO = @CUS_NO
GO
