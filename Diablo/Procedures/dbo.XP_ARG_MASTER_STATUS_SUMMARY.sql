USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_ARG_MASTER_STATUS_SUMMARY
■ DESCRIPTION				: 수배현황 검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 

	XP_ARG_MASTER_STATUS_SUMMARY	@ARG_CODE = 'A140403-0044' , @AGT_CODE  = ''
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-03-26		박형만			신규생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_ARG_MASTER_STATUS_SUMMARY]
 	@ARG_CODE VARCHAR(12) ,
	@AGT_CODE VARCHAR(10)  --랜드사코드(전체 NULL OR '' ) 
AS 
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	;


	WITH LIST AS 
	(
		SELECT * FROM 
			(SELECT 1 AS ARG_TYPE, '수배'  AS ARG_TYPE_NAME
		UNION ALL SELECT 2 AS ARG_TYPE, 'I/V' AS ARG_TYPE_NAME  
		UNION ALL SELECT 3 AS ARG_TYPE, '정산' AS ARG_TYPE_NAME  ) AA  
	)  

	--최근상태,수정일 요약리스트
	SELECT A.*, 
	B.ARG_STATUS AS LAST_ARG_STATUS, 
	ISNULL(B.EDT_DATE,B.NEW_DATE) AS LAST_EDT_DATE FROM 
	( 
		SELECT 
			A.ARG_TYPE , A.ARG_TYPE_NAME , B.ARG_CODE  , B.GRP_SEQ_NO  
		FROM LIST A 
		LEFT JOIN 
		(	
			-- ARG_TYPE 별,가장최근 GRP_SEQ_NO
			SELECT ARG_CODE,AGT_CODE,ARG_TYPE,MAX(GRP_SEQ_NO) AS GRP_SEQ_NO FROM 
			(
				SELECT A.ARG_CODE , A.AGT_CODE , GRP_SEQ_NO, 
					CASE WHEN ARG_STATUS IN (1,2,3,4) THEN 1 
						WHEN ARG_STATUS IN (5,6,7,8) THEN 2 
						WHEN ARG_STATUS IN (9,10) THEN 3 
					END AS ARG_TYPE 
				FROM ARG_MASTER A 
					LEFT JOIN ARG_DETAIL B1
						ON A.ARG_CODE = B1.ARG_CODE
				WHERE A.ARG_CODE = @ARG_CODE 
				AND ( A.AGT_CODE = @AGT_CODE OR ISNULL(@AGT_CODE,'') = '' )
				--GROUP BY  A.ARG_CODE , A.AGT_CODE
			) T
			GROUP BY ARG_CODE,AGT_CODE,ARG_TYPE
		) B 
			ON A.ARG_TYPE = B.ARG_TYPE 
		--LEFT JOIN ARG_DETAIL C 
		--	ON B.ARG_CODE = C.ARG_CODE 
		--	AND B.GRP_SEQ_NO = C.GRP_SEQ_NO 

		--GROUP BY A.ARG_TYPE , A.ARG_TYPE_NAME  , B.ARG_CODE  
	) A 
		LEFT JOIN ARG_DETAIL B 
			ON A.ARG_CODE = B.ARG_CODE 
			AND A.GRP_SEQ_NO = B.GRP_SEQ_NO 

	
END 
GO
