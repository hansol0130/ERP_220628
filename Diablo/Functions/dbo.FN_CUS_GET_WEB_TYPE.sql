USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* 

2017-07-05 박형만 사용하지 않는 함수 새로 고쳐서 수정 

 9 = 전체 
 3 = 휴면회원
 2 = 정회원
 1 = 비회원
 0 = 일반고객
*/ 
CREATE FUNCTION [dbo].[FN_CUS_GET_WEB_TYPE]
(
	@CUS_NO INT
)
RETURNS CHAR(1)
AS
BEGIN

	DECLARE @YN CHAR(1)

	SELECT @YN = (

		CASE WHEN @CUS_NO <= 1 THEN '9'  
			 WHEN ISNULL((SELECT CUS_ID FROM CUS_MEMBER_SLEEP WHERE CUS_NO = @CUS_NO) ,'')  <> '' THEN '3'
			 WHEN ISNULL((SELECT CUS_ID FROM CUS_MEMBER WHERE CUS_NO = @CUS_NO) ,'')  <> '' THEN '2'
			 WHEN @CUS_NO > 1 AND EXISTS (SELECT CUS_ID FROM CUS_CUSTOMER_DAMO WHERE CUS_NO = @CUS_NO
					AND BIRTH_DATE IS NOT NULL 
					AND GENDER IN ('M','F')
					AND NOR_TEL1 IS NOT NULL AND NOR_TEL1 <> ''
					AND NOR_TEL2 IS NOT NULL AND NOR_TEL2 <> ''
					AND NOR_TEL3 IS NOT NULL AND NOR_TEL3 <> '')
			THEN '1' 
			ELSE '0' END   
--		CASE
--			WHEN EXISTS(SELECT 1 FROM CUS_CUSTOMER WHERE CUS_NO = @CUS_NO AND ISNULL(CUS_ID, '') <> '') THEN 'Y'
--			ELSE 'N' END
--		'Y'
	)

	RETURN (@YN)
END

GO
