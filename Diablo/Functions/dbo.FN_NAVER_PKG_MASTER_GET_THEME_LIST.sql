USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name			: FN_NAVER_PKG_MASTER_GET_THEME_LIST
■ Description				: 네이버 예약 총 판매금액 리턴
■ Input Parameter			:                  
		@RES_CODE			: 예약코드
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 

	SELECT DBO.FN_NAVER_PKG_MASTER_GET_THEME_LIST('APP8912')

---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	
	2019-12-02		박형만			네이버 용 테마리스트 구하기 

-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_NAVER_PKG_MASTER_GET_THEME_LIST]
(
	@MASTER_CODE VARCHAR(10)
)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @TOT_PRICE DECIMAL
	DECLARE @THEME_LIST VARCHAR(100)
	SELECT 
	--A.MASTER_CODE , 
	@THEME_LIST =  
	CASE WHEN CHARINDEX('아동',MASTER_NAME) > 0 THEN ',CHD' ELSE '' END+
	CASE WHEN CHARINDEX('크루즈',MASTER_NAME) > 0 THEN ',CRU' ELSE '' END+
	CASE WHEN CHARINDEX('가족',MASTER_NAME) > 0 THEN ',FAM' ELSE '' END+
	CASE WHEN SUBSTRING(MASTEr_CODE,3,1) ='F' OR  ATT_CODE ='F'  OR CHARINDEX('자유일정',MASTER_NAME) > 0 THEN ',FRE' ELSE '' END+
	CASE WHEN CHARINDEX('골프',MASTER_NAME) > 0 THEN ',GOL' ELSE '' END+
	CASE WHEN CHARINDEX('홈쇼',MASTER_NAME) > 0 THEN ',HSP' ELSE '' END+
	CASE WHEN CHARINDEX('허니문',MASTER_NAME) > 0 THEN ',HYM' ELSE '' END+
	CASE WHEN CHARINDEX('특식',MASTER_NAME) > 0 OR CHARINDEX('미식',MASTER_NAME) > 0 THEN ',MEL' ELSE '' END+
	CASE WHEN CHARINDEX('성지순례',MASTER_NAME) > 0 THEN ',PLG' ELSE '' END+
	CASE WHEN CHARINDEX('풀빌라',MASTER_NAME) > 0 THEN ',POV' ELSE '' END+
	--"code": "RET","name": "휴양","description": "자유일정 등이 포함되어 여유로운 일정으로 구성된 상품" -- 보류 
	--"code": "TRE","name": "관광+휴양","description": "관광과 휴양을 함께 즐기는 상품" -- 보류 
	CASE WHEN CHARINDEX('료칸',MASTER_NAME) > 0 THEN ',RYO' ELSE '' END+
	CASE WHEN CHARINDEX('온천',MASTER_NAME) > 0 THEN ',SPR' ELSE '' END+
	CASE WHEN CHARINDEX('테마파크',MASTER_NAME) > 0 THEN ',TEP' ELSE '' END+
	CASE WHEN SUBSTRING(MASTEr_CODE,3,1) <> 'F' AND ATT_CODE <> 'F' THEN ',TRV' ELSE '' END  
	FROM PKG_MASTER WITH(NOLOCK)
	WHERE MASTER_CODE = @MASTER_CODE
	--	INNER JOIN NAVER_PKG_MASTER B 
	--		ON A.MASTER_CODE = B.MSTCODE 

	-- WHERE 
	-- CHARINDEX('테마파크',MASTER_NAME) > 0  
	--  or CHARINDEX('허니문',MASTER_NAME) > 0
	-- OR CHARINDEX('료칸',MASTER_NAME) > 0
	-- OR CHARINDEX('일주',MASTER_NAME) > 0 
	-- OR CHARINDEX('골프',MASTER_NAME) > 0 
	-- or CHARINDEX('홈쇼',MASTER_NAME) > 0
	-- OR CHARINDEX('온천',MASTER_NAME)  > 0 
	-- OR CHARINDEX('크루즈',MASTER_NAME) > 0 
	-- OR CHARINDEX('풀빌라',MASTER_NAME) > 0 
	-- OR CHARINDEX('아동',MASTER_NAME) > 0 
	-- OR CHARINDEX('가족',MASTER_NAME) > 0 
	-- OR CHARINDEX('성지순례',MASTER_NAME) > 0 
	-- OR (SUBSTRING(MASTEr_CODE,3,1) ='F' OR CHARINDEX('자유일정',MASTER_NAME) > 0 )
	-- OR (CHARINDEX('특식',MASTER_NAME) > 0 OR CHARINDEX('미식',MASTER_NAME) > 0)
	-- OR (SUBSTRING(MASTEr_CODE,3,1) <> 'F' AND ATT_CODE <> 'F') 
	--ORDER BY MASTER_CODE 
	IF ISNULL(@THEME_LIST,'') = '' 
	BEGIN	
		SET @THEME_LIST = 'TRV' 
	END 
	ELSE 
	BEGIN
		SET @THEME_LIST = RIGHT(@THEME_LIST,LEN(@THEME_LIST)-1)
	END

	RETURN @THEME_LIST 


END
GO
