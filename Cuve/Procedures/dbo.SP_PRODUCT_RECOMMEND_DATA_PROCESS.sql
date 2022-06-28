USE [Cuve]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_PRODUCT_RECOMMEND_DATA_PROCESS
■ DESCRIPTION				: 추천 데이타 가공
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC SP_PRODUCT_RECOMMEND_DATA_PROCESS
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2017-06-30		윤병도			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_PRODUCT_RECOMMEND_DATA_PROCESS]	
AS
BEGIN
	WITH LIST AS --R에서 불러올  자동으로 생기는 { } 문자열 제거 
	(	
		SELECT 
			SEQ, [1]+','+[2] AS [1] , 지지도, 예약상품
		FROM
		(
			SELECT
				ROW_NUMBER() OVER (ORDER BY SUPPORT DESC) AS SEQ
				,REPLACE(REPLACE(REPLACE(LHS,' ',''),'{',''),'}','') AS '1'
				,REPLACE(REPLACE(REPLACE(RHS,' ',''),'{',''),'}','') AS '2'
				,REPLACE(SUPPORT,' ','') AS 지지도
				,REPLACE(MASTER_CODE,' ','') AS '예약상품'
			FROM 
				TMP_APRIORI_INSERT_TBL
		) A
	) 
	,LIST2 AS 
	(
		SELECT 
			 T.SEQ, B.ID AS NO
			,B.Data AS 마스터코드
			,T.지지도
			,T.예약상품
		FROM LIST T
		CROSS APPLY diablo..FN_XML_SPLIT(t.[1],',') B  
		WHERE ISNULL(t.[1],'') <> ''  
	)
	SELECT * INTO TMP_APRIORI_FINAL_TRAIN FROM LIST2 A
	WHERE 
		SEQ NOT IN 
		(
			SELECT SEQ FROM LIST2 B WHERE A.SEQ = B.SEQ AND LEFT(마스터코드,1) <> LEFT(예약상품,1) -- 고객이 본 상품과 같은 지역의 상품 추천 규칙으로 한정  
		);
END

GO
