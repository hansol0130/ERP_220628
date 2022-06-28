USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- AUTHOR:		김 성 호
-- CREATE DATE: 2014-01-07
-- DESCRIPTION:	지마켓 상품타입 검색
-- 2018-06-20 박형만 지마켓 카테고리 갱신 NEW패키지자유여행연동 v0.9.8.docx 
-- =============================================
CREATE FUNCTION [dbo].[FN_PRO_GMARKET_CODE]
(
	@SIGN_CODE VARCHAR(1),
	@ATT_CODE VARCHAR(1),
	@MASTER_CODE VARCHAR(20),
	@BRANCH_CODE INT 
)
RETURNS VARCHAR(5)
AS
BEGIN

	DECLARE @GD_TYPE VARCHAR(5)

	SELECT @GD_TYPE = (
		CASE
			-- 부산 
			WHEN @BRANCH_CODE = 1 THEN 
			(
				CASE WHEN @ATT_CODE = 'F' OR SUBSTRING(@MASTER_CODE,3,1) = 'F' THEN 'D-1' -- D-1 : 지방출발자유여행_부산
						WHEN @SIGN_CODE = 'K' THEN 'J-5' -- J-5 : 지방출발 제주여행	
					ELSE 'P-1' END   -- P-1 : 지방출발패키지_부산
			)
			-- 대구 
			WHEN @BRANCH_CODE = 2 THEN (
				CASE WHEN @ATT_CODE = 'F' OR SUBSTRING(@MASTER_CODE,3,1) = 'F' THEN 'D-2' --D-2 : 지방출발자유여행_대구
						WHEN @SIGN_CODE = 'K' THEN 'J-5' -- J-5 : 지방출발 제주여행	
					ELSE 'P-2' END   -- P-2 : 지방출발패키지_대구
			)
			ELSE (
				CASE 
				WHEN @SIGN_CODE = 'K' THEN (
					CASE
						WHEN @MASTER_CODE LIKE 'KPPT%' THEN 'J-1'	--J-1 : 항공+숙박+버스관광
						WHEN @MASTER_CODE LIKE 'KPG%' THEN 'J-2' --J-2 : 제주 골프/허니문여행
						WHEN @MASTER_CODE LIKE 'KPP%' THEN 'J-3' --J-3 : 항공+숙박+렌터카
						ELSE 'J-1'
					END
				)
				ELSE (
					CASE
						WHEN @ATT_CODE = 'P' THEN 'E-1' --E-1 : [해외] 패키지
						WHEN @ATT_CODE IN ('B', 'F', 'I') OR SUBSTRING(@MASTER_CODE,3,1) = 'F'  THEN 'E-2'--E-2 : [해외] 자유여행
						WHEN @ATT_CODE IN ('T', 'V') THEN 'E-3' --E-3 : [해외] 패스/입장권/현지투어
						WHEN @ATT_CODE IN ('D', 'L') THEN 'E-4'
						WHEN @ATT_CODE = 'W' THEN 'E-5'	-- E-5 : [해외] 허니문
						WHEN @ATT_CODE = 'G' THEN 'E-6' -- E-6 : [해외] 골프
						WHEN @ATT_CODE = 'C' THEN 'E-7' --E-7 : [해외] 크루즈
						ELSE 'E-1'
					END
				)
				END 
			)
		END 
	)

	RETURN (@GD_TYPE)
END

GO
