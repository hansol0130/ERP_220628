USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_RES_PAY_COUPON_PAY_MATCHING_LIST
■ DESCRIPTION				: ERP 쿠폰 입금 매칭 정보 조회 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec XP_RES_PAY_COUPON_PAY_MATCHING_LIST  '2017-05-01' ,'2017-09-01' ,  '93024' ,'N'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-04-28		박형만			최초생성
================================================================================================================*/ 
create PROC [dbo].[XP_RES_PAY_COUPON_PAY_MATCHING_LIST]
	@START_DATE	VARCHAR(10),
	@END_DATE	VARCHAR(10),
	@AGT_CODE	VARCHAR(10),
	@PAY_COMP_YN	CHAR(1) 
AS 
BEGIN
	

--DECLARE @START_DATE	VARCHAR(10),
--	@END_DATE	VARCHAR(10),
--	@AGT_CODE	VARCHAR(10),
--	@PAY_COMP_YN	CHAR(1),
--	@CPN_SEQ INT = 0 

--SELECT @START_DATE = '2017-05-01' , @END_DATE = '2017-09-25' , @AGT_CODE = '93024' , @PAY_COMP_YN = '' 
 
	SELECT TOP 100 
		A.PRO_CODE,A.RES_CODE , A.RES_NAME, A.RES_STATE, C.AGT_CODE , 
		A.DEP_DATE , 
		C.CPN_TITLE , C.CPN_NO , C.CPN_SEQ , 
		C.PAY_TARGET_PRICE ,
		C.DC_RATE , C.DC_PRICE , 
		CASE WHEN C.DC_RATE  > 0 THEN  PAY_TARGET_PRICE * (C.DC_RATE * 0.01) ELSE C.DC_PRICE END AS DC_CALC_PRICE ,  --계산된 수수료  
		C.COMM_RATE , C.COMM_PRICE , 
		CASE WHEN C.COMM_RATE  > 0 THEN  (CASE WHEN C.DC_RATE  > 0 THEN  PAY_TARGET_PRICE * (C.DC_RATE * 0.01) ELSE C.DC_PRICE END) * (C.COMM_RATE * 0.01) ELSE C.COMM_PRICE END AS COMM_CALC_PRICE ,  --계산된 참좋은수수료
		C.PAY_SEQ ,
		C.MCH_SEQ ,  
		E.NEW_DATE , 
		E.NEW_CODE ,
		(SELECT KOR_NAME FROM EMP_MASTER WHERE EMP_CODE = E.NEW_CODE) AS NEW_NAME  ,
		E.PART_PRICE  
		--C.* ,  * 
	FROM RES_MASTER_DAMO A WITH(NOLOCK) 
		--INNER JOIN RES_AIR_DETAIL B WITH(NOLOCK) 
		--	ON A.RES_CODE = B.RES_CODE 
		INNER JOIN PAY_COUPON C WITH(NOLOCK)  
			ON A.RES_CODE = C.RES_CODE 
		LEFT JOIN RES_ALT_MATCHING D WITH(NOLOCK)   
			ON A.RES_CODE = D.RES_CODE 
			AND D.ALT_CODE = 'tmon'
		LEFT JOIN PAY_MATCHING E WITH(NOLOCK)   
			ON C.PAY_SEQ = E.PAY_SEQ 
			AND C.MCH_SEQ = E.MCH_SEQ 
	WHERE A.DEP_DATE >= CONVERT(DATETIME,@START_DATE)
	AND  A.DEP_DATE < DATEADD(DD,1,CONVERT(DATETIME,@END_DATE))
	AND A.PROVIDER = 36 
	AND A.PRO_TYPE = 2 
	AND C.AGT_CODE = @AGT_CODE
	AND C.CXL_YN = 'N' 
	AND A.RES_STATE NOT IN ( 7,8,9 ) 
	AND( (@PAY_COMP_YN  ='Y'  AND E.PAY_SEQ IS NOT NULL ) 
		OR (@PAY_COMP_YN  ='N'  AND E.PAY_SEQ IS NULL )  
		OR (ISNULL(@PAY_COMP_YN,'') ='' ) )
	 


END 
GO
