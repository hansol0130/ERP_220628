USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- AUTHOR:  최 미 선  
-- CREATE DATE: 2010. 04. 16  
-- DESCRIPTION: 주민번호로 보험 나이 계산  
-- 2010-06-10 로직 수정 , 뒷자리로 출생년도 구분
-- 2011-04-04 잘못된 주민번호로 인해 예외처리			김성호
-- 2012-07-04 윤달생년월일자 임시방법으로 보정			박형만
-- 2014-06-05 윤달생년월일자 임시방법으로 보정	 삭제	김성호
-- 2014-10-17 보험나이 구하는 부분 새로운 로직으로변경 	박형만
-- 2016-12-19 암복호화시 정상적이지 않을때 @SOC_NUM2값에 TAB 공백이 들어감, 해당값 REPLACE 정지용
-- 2017-12-19 2000년도 이상 외국인 국적 남여 뒷자리가 7,8 이라 계산이 잘못되는 것 수정
-- =============================================  
CREATE FUNCTION [dbo].[FN_PUB_GET_INS_AGE]  
(  
	@SOC_NUM1  VARCHAR(6),   -- 주민번호 790703  
	@SOC_NUM2  VARCHAR(7),   -- 주민번호 뒷자리   
	@DEP_DATE DATETIME        -- 출발날짜 2010-04-15  
)  
RETURNS INT  
AS  
BEGIN
--DECLARE @SOC_NUM1  VARCHAR(6),   -- 주민번호 790703  
--	@SOC_NUM2  VARCHAR(7),   -- 주민번호 뒷자리   
--	@DEP_DATE DATETIME        -- 출발날짜 2010-04-15  
--SELECT @SOC_NUM1 = '140629 ',@SOC_NUM2 ='4',@DEP_DATE = '2014-09-07' 

	DECLARE @INS_AGE INT, @TEMP_DATE DATETIME

	/* 오늘의날짜중 년도에서주민번호앞2자리를뺀다 */
	
	IF LEN(ISNULL(@SOC_NUM1, '')) = 6  AND LEN(ISNULL(REPLACE(@SOC_NUM2, CHAR(9), ''), '')) > 0 AND ISDATE(@SOC_NUM1) = 1
	BEGIN
		
		DECLARE @YEAR_DIV INT 
		SET @YEAR_DIV  = CONVERT(INT,SUBSTRING( @SOC_NUM2  , 1 , 1 ))
		
		-- 2000년 이후 출생
		-- 유학생 성균인 가입시 주민등록번호는 남자 : 생년월일- 5999999 여자 : 생년월일- 6999999
		IF( @YEAR_DIV IN (3,4) OR @YEAR_DIV IN (7,8))
		BEGIN
			SET @TEMP_DATE = CONVERT(DATETIME, ('20' + @SOC_NUM1))
		END
		ELSE  -- 1,2 등 기타  
		BEGIN
			SET @TEMP_DATE = CONVERT(DATETIME, ('19' + @SOC_NUM1))
		END 
		
		--SELECT @INS_AGE = DATEDIFF("dd",@TEMP_DATE, @DEP_DATE) / 365
		SELECT @INS_AGE =   
			(  
				-- 5개월 이상 1살 플러스 보험사 요청사항  
				(DATEDIFF("dd",@TEMP_DATE, @DEP_DATE) / 365) + (  
					CASE
						WHEN ABS((DATEPART(MONTH, @DEP_DATE) + 12 - DATEPART(MONTH, @TEMP_DATE)) % 12) > 5 THEN 1  
						ELSE 0   
					END  
				)
			)
		-- 0 살일경우 1살로 지정 - 기존 로직 
		SELECT @INS_AGE = CASE @INS_AGE WHEN 0 THEN 1 ELSE @INS_AGE END  
		
	END
	ELSE
	BEGIN
		SELECT @INS_AGE = 0
	END

	--SELECT @INS_AGE 
	--기존소스 주석처리 문제 생길시 확인 2014-10-17 
	-- select DBO.FN_PUB_GET_INS_AGE('690229', '2052628',  '2014-06-07') AS [AGE]
	--DECLARE @INS_AGE INT, @TEMP_DATE DATETIME  
	
	--/* 오늘의날짜중 년도에서주민번호앞2자리를뺀다 */  

	--IF LEN(ISNULL(@SOC_NUM1, '')) = 6  AND LEN(ISNULL(@SOC_NUM2, '')) = 7   
	--BEGIN  

	--	DECLARE @YEAR_DIV INT, @YEAR VARCHAR(2), @MONTH VARCHAR(2), @DAY INT, @TEMP INT
	--	SET @YEAR_DIV  = CONVERT(INT,SUBSTRING(@SOC_NUM2, 1, 1))
		
	--	SET @MONTH = SUBSTRING(@SOC_NUM1, 3, 2)
	--	SET @DAY = CONVERT(INT,SUBSTRING(@SOC_NUM1, 5, 2))
		
	--	-- 1900년대, 2000년대 체크
	--	IF( @YEAR_DIV IN (3,4))
	--		SET @YEAR = '20'
	--	ELSE
	--		SET @YEAR = '19'

	--	-- 주민번호 해당월의 마지막 날짜
	--	SET @TEMP = CONVERT(INT, DAY(DATEADD(DAY, -1, DATEADD(MONTH, 1, CONVERT(DATETIME, (@YEAR + @MONTH + '01'))))))
		
	--	-- 윤달보정 (2014-06-05 주석 처리)
	--	--IF( @MONTH = '02' AND @DAY >= 29 )
	--	--BEGIN
	--	--	SET @TEMP = @DAY 
	--	--END 
		
	--	-- 입력된 값이 마지막날짜보다 작거나 같으면
	--	IF @DAY <= @TEMP
	--	BEGIN
	--		SET @TEMP_DATE = CONVERT(DATETIME, (@YEAR + @SOC_NUM1))
			
	--		SELECT @INS_AGE =   
	--		(  
	--			-- 5개월 이상 1살 플러스 보험사 요청사항  
	--			(DATEDIFF("dd",@TEMP_DATE, @DEP_DATE) / 365) + (  
	--				CASE
	--					WHEN ABS((DATEPART(MONTH, @DEP_DATE) + 12 - DATEPART(MONTH, @TEMP_DATE)) % 12) > 5 THEN 1  
	--					ELSE 0   
	--				END  
	--			)
	--		)

	--		SELECT @INS_AGE = CASE @INS_AGE WHEN 0 THEN 1 ELSE @INS_AGE END  
	--	END
	--	ELSE
	--	BEGIN
	--		SET @INS_AGE = 0
	--	END
	--END  
	--ELSE  
	--BEGIN  
	--	SELECT @INS_AGE = 0  
	--END  

	RETURN (@INS_AGE);  

END  
GO
