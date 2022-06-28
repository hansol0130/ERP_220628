USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*=================================================================================================
■ Server					: 211.115.202.230
■ Database					: DIABLO
■ USP_Name					: SP_CUS_POINT_CONSENT_LIST  
■ Description				: 포인트 동의 내역 리스트
■ Input Parameter			:                  
		@START_DTE			:
		@END_DTE			:
		@SEARCH_TYPE		:
		@ORDER_BY			:
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC SP_CUS_POINT_CONSENT_LIST '2010-06-01', '2010-06-30', 'ALL' , 'POINT' 
■ Author					: 임형민  
■ Date						: 2010-09-01
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2010-09-01       임형민			최초생성  
   2010-12-08		김성호			회원테이블 분리로 인해 대상 테이블 변경
   2012-03-02		박형만			READ UNCOMMITTED 설정
   2015-03-03		김성호			주민번호 삭제, 생년월일 추가
=================================================================================================*/ 
CREATE PROC [dbo].[SP_CUS_POINT_CONSENT_LIST]
(
	@START_DTE					DATETIME,
	@END_DTE					DATETIME,
	@SEARCH_TYPE				VARCHAR(10),
	@ORDER_BY					VARCHAR(10)
)

AS

	BEGIN
		SELECT CASE
					WHEN ISNULL(NEW_DATE, '') = '' THEN  '기존'
					WHEN NEW_DATE < '2010-06-01' THEN '기존'
					ELSE '신규'
			   END AS MEMBER_GB,
			   A.CUS_NO,
			   A.CUS_ID,
			   A.CUS_NAME,
			   --A.SOC_NUM1,
			   --damo.dbo.dec_varchar('DIABLO','dbo.CUS_CUSTOMER','SOC_NUM2', SEC_SOC_NUM2) AS SOC_NUM2,
			   A.BIRTH_DATE,
			   A.GENDER,
			   A.NEW_DATE,
			   A.POINT_CONSENT_DATE
		FROM CUS_MEMBER A WITH(NOLOCK)
		WHERE A.CUS_STATE = 'Y'
		  AND A.POINT_CONSENT_DATE >= @START_DTE
		  AND A.POINT_CONSENT_DATE < @END_DTE + 1
		  AND CASE
				   -- 전체(ALL)이라면 값은 무조건 1이다.
				   WHEN @SEARCH_TYPE = 'ALL' THEN 1
				   
				   -- 기존(EXISTING)이라면..
				   WHEN @SEARCH_TYPE = 'EXISTING' THEN
				   	   -- 기존 조건에 맞는 것은 값이 1이고, 조건에 맞지 않는 것은 0이다.
					   CASE WHEN A.NEW_DATE < '2010-06-01' THEN 1 ELSE 0 END
					   
				   -- 신규(NEW)라면..
				   WHEN @SEARCH_TYPE = 'NEW' THEN 
				   	   -- 신규 조건에 맞는 것은 값이 1이고, 조건에 맞지 않는 것은 0이다.
					   CASE WHEN A.NEW_DATE >= '2010-06-01' THEN 1 ELSE 0 END
					   
			  -- 값이 1인 것만 출력한다.
			  END = 1
		ORDER BY CASE @ORDER_BY
					 WHEN 'NEW' THEN NEW_DATE
					 WHEN 'POINT' THEN POINT_CONSENT_DATE
				 END
	END
GO
