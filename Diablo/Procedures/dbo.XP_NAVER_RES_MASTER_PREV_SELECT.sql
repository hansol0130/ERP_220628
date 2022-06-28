USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*================================================================================================================
■ USP_NAME					: XP_NAVER_RES_MASTER_PREV_SELECT
■ DESCRIPTION				: 

네이버 예약
현재 네이버로 전송된 예약정보  

■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: [XP_NAVER_RES_MASTER_PREV_SELECT] 'RP1906109735'
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
2019-12-03	박형만	 
2019-12-13	박형만	네이버 예약 API 변경 도시,국가,마스터코드 필드 추가 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_NAVER_RES_MASTER_PREV_SELECT]
	@RES_CODE VARCHAR(12)  
AS 
BEGIN 

--DECLARE @START_DATE DATETIME  ,
--@END_DATE VARCHAR(10) 
--SET @START_DATE = '2019-06-10' 

	-- 갱신된 현재 정보 조회 하기 	
	SELECT 
	RES_CODE,
	ALT_MEM_NO,
	BOOK_KEY,
	PRO_CODE,
	PRICE_SEQ,
	PRO_NAME,
	NEW_DATE,
	DEP_DATE,
	ARR_DATE,
	TOTAL_PRICE,
	ADT_COUNT,
	CHD_COUNT,
	INF_COUNT,
	RES_NAME,
	RES_TEL,
	BOOKING_STATE,
	PAY_STATE,
	NEW_CODE,
	EMP_NAME,
	INNER_NUMBER,
	PRO_PC_URL,
	PRO_MOB_URL,
	RES_PC_URL,
	RES_MOB_URL,
	MEET_INFO,
	TC_CODE,
	TC_YN,
	TC_NUMBER,
	LAST_UPD_DATE,
	SEND_DATE,
	SYSTEM_TYPE,
	NATION_CODES, -- 2019-12 추가 
	CITY_CODES,-- 2019-12 추가 
	MASTER_CODE -- 2019-12 추가 
	FROM NAVEr_RES_MASTER WITH(NOLOCK)
	WHERE RES_CODE = @RES_CODE
END 

GO
