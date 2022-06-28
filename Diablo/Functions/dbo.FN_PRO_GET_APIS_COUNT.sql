USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_PRO_GET_APIS_COUNT
■ Description				: 행사 아피스 완료 인원 검색
■ Input Parameter			:                  
		@PRO_CODE			: 행사코드
■ Select					: 
■ Author					: 
■ Date						:   
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date				Author			Description           
---------------------------------------------------------------------------------------------------
	2009-03-29			김성호			최초생성
	2015-03-03			김성호			주민번호 삭제로 체크사항 생년월일로 변경
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_PRO_GET_APIS_COUNT]
(
	@PRO_CODE VARCHAR(20)
)

RETURNS INT

AS

	BEGIN
		DECLARE @YN CHAR(1), @TOT_COUNT INT, @OK_COUNT INT

		-- TOT_COUNT는 전체 인원수를 가진다.
		-- OK_COUNT 는 APIS사항이 완료된 인원수를 가진다.
		-- TOT_COUNT <> OK_COUNT가 다르면 APIS사항이 완료 안된 사람이 있다.
		-- TOT_COUNT - OK_COUNT = APIS 사항이 완료안된 사람 건수
		SELECT 
			@TOT_COUNT = COUNT(*),
			@OK_COUNT = SUM(
				CASE
					WHEN (
						--LEN(B.SOC_NUM1) = 6 AND LEN(damo.dbo.dec_varchar('DIABLO','dbo.RES_CUSTOMER','SOC_NUM2', B.SEC_SOC_NUM2)) = 7 AND
						B.BIRTH_DATE IS NOT NULL AND B.GENDER IN ('M', 'F') AND
						LEN(B.LAST_NAME) > 1 AND LEN(B.FIRST_NAME) > 1 AND 
						LEN(damo.dbo.dec_varchar('DIABLO','dbo.RES_CUSTOMER','PASS_NUM', B.SEC_PASS_NUM)) >= 7 AND
						DATEADD(MONTH, -6, DATEADD(DAY, +1, B.PASS_EXPIRE)) > A.DEP_DATE)
					THEN 1
					ELSE 0
				END
			)
		FROM RES_MASTER_DAMO A WITH(NOLOCK) 
		INNER JOIN RES_CUSTOMER_DAMO B WITH(NOLOCK)  ON B.RES_CODE = A.RES_CODE
		WHERE A.RES_CODE IN (SELECT RES_CODE FROM RES_MASTER_DAMO WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE)
			AND B.RES_STATE = 0

		RETURN (@OK_COUNT)
	END
GO
