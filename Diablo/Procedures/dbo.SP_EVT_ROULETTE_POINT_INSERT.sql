USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*================================================================================================================
■ USP_NAME					: SP_EVT_ROULETTE_POINT_INSERT
■ DESCRIPTION				: 룰렛 포인트 수동 적립
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
exec SP_EVT_ROULETTE_POINT_INSERT @CUS_NO=15,@ARR_RESCODE=N'RT1012086788,',@NEW_CODE=N'9999999'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-05-22		정지용
   2014-09-02		정지용			호텔적립 추가
================================================================================================================*/ 
CREATE PROC [dbo].[SP_EVT_ROULETTE_POINT_INSERT]
	@CUS_NO INT,
	@ARR_RESCODE VARCHAR(200),
	@REMARK VARCHAR(100),
	@NEW_CODE CHAR(7)
AS 
BEGIN	
	SET NOCOUNT OFF;
	IF EXISTS ( SELECT 1 FROM EVT_ROULETTE WITH(NOLOCK) WHERE CUS_CODE = @CUS_NO AND RES_CODE IN ( SELECT Data FROM dbo.FN_SPLIT(@ARR_RESCODE, ',') ) )
	BEGIN
		RETURN;
	END

	INSERT INTO EVT_ROULETTE ( EVT_ROU_SEQ, EVT_WIN_SEQ, RES_CODE, RES_SEQ_NO, CUS_CODE, REMARK, NEW_CODE, NEW_DATE )
	SELECT 
		(SELECT ISNULL(MAX(EVT_ROU_SEQ), 0) FROM EVT_ROULETTE) + ROW_NUMBER() OVER (ORDER BY RES_CODE),
		NULL, 
		RES_CODE, 
		SEQ_NO, 
		CUS_NO,
		@REMARK,
		@NEW_CODE,
		GETDATE() 
	FROM (
		SELECT 
			 Z.RES_CODE, SEQ_NO, CUS_NO, TOTAL_PRICE,
			 CASE 
				WHEN TOTAL_PRICE >= 10000 AND TOTAL_PRICE < 1000000 THEN '1' 	  
				WHEN TOTAL_PRICE >= 1000000 AND TOTAL_PRICE < 2000000 THEN '2' 
				WHEN TOTAL_PRICE >= 2000000 AND TOTAL_PRICE < 3000000 THEN '3' 
				WHEN TOTAL_PRICE >= 3000000 AND TOTAL_PRICE < 9000000 THEN '4' 
				WHEN TOTAL_PRICE >= 9000000 THEN '5' 
			END AS GRADE
		FROM (
			SELECT RM.RES_CODE, RC.SEQ_NO, RC.CUS_NO, 
			--((ISNULL(RC.SALE_PRICE, 0) + ISNULL(RC.CHG_PRICE, 0) + ISNULL(RC.TAX_PRICE, 0)) - ISNULL(RC.DC_PRICE, 0)) AS TOTAL_PRICE
			DBO.FN_RES_GET_TOTAL_PRICE_ONE(RM.RES_CODE, RC.SEQ_NO) AS TOTAL_PRICE
			FROM PKG_DETAIL AS PD WITH(NOLOCK)
			INNER JOIN RES_MASTER_damo AS RM WITH(NOLOCK) ON PD.PRO_CODE = RM.PRO_CODE 
			INNER JOIN RES_CUSTOMER_damo AS RC WITH(NOLOCK) ON RM.RES_CODE = RC.RES_CODE 
			INNER JOIN CUS_MEMBER AS CC WITH(NOLOCK) ON RC.CUS_NO = CC.CUS_NO
			WHERE 
			RM.RES_STATE IN(3,4,5,6) -- 예약상태 결제중,결제완료,출발완료,해피콜 
			AND RC.RES_STATE IN (0) -- 출발고객상태 예약인것만
			AND RM.RES_CODE IN ( SELECT Data FROM dbo.FN_SPLIT(@ARR_RESCODE, ',') )
			AND CC.CUS_NO = @CUS_NO
			
			UNION ALL

			SELECT HRM.RES_CODE, 0 AS SEQ_NO, CC.CUS_NO,
				DBO.FN_RES_HTL_GET_TOTAL_PRICE(HRM.RES_CODE) AS TOTAL_PRICE
			FROM RES_MASTER AS HRM WITH(NOLOCK)
			INNER JOIN CUS_MEMBER AS CC WITH(NOLOCK) ON HRM.CUS_NO = CC.CUS_NO
			WHERE 
			HRM.PRO_TYPE = 3
			AND HRM.RES_STATE IN(3,4,5,6) -- 예약상태 결제중,결제완료,출발완료,해피콜 
			AND HRM.RES_CODE IN ( SELECT Data FROM dbo.FN_SPLIT(@ARR_RESCODE, ',') )
			AND CC.CUS_NO = @CUS_NO
			) Z
	) AA
	INNER JOIN DBO.FN_SPLIT('1,2,2,3,3,3,4,4,4,4,5,5,5,5,5,5,5,5,5,5', ',') TEMP ON AA.GRADE = TEMP.DATA
	ORDER BY RES_CODE ASC

END 



GO
