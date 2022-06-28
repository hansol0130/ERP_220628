USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ VIEW_NAME					: VIEW_PRO_DETAIL_PRICE
■ DESCRIPTION				: 행사 금액 조회
■ MEMO						: 
■ Exec						:

SELECT TOP 10 * FROM dbo.VIEW_PRO_DETAIL_PRICE

------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2022-02-11		김성호			최초생성
================================================================================================================*/ 
CREATE VIEW [dbo].[VIEW_PRO_DETAIL_PRICE] AS

	WITH PRO_LIST AS (
	    SELECT PD.PRO_CODE
	          ,(CASE WHEN PTS.SEAT_CODE > 0 THEN PTS.ARR_TRANS_CODE ELSE PM.AIRLINE_CODE END) AIRLINE_CODE
	          ,(CASE WHEN PTS.SEAT_CODE > 0 THEN PTS.DEP_ARR_AIRPORT_CODE ELSE PM.AIRPORT_CODE END) AIRPORT_CODE
	          ,PD.DEP_DATE
	          ,PC.NATION_CODE
	    FROM   PKG_DETAIL PD WITH(NOLOCK)
	           INNER JOIN PKG_MASTER PM WITH(NOLOCK)
	                ON  PD.MASTER_CODE = PM.MASTER_CODE
	           LEFT JOIN PRO_TRANS_SEAT PTS WITH(NOLOCK)
	                ON  PD.SEAT_CODE = PTS.SEAT_CODE
	           INNER JOIN PUB_AIRPORT PA WITH(NOLOCK)
	                ON  PA.AIRPORT_CODE = (CASE WHEN PTS.SEAT_CODE > 0 THEN PTS.DEP_ARR_AIRPORT_CODE ELSE PM.AIRPORT_CODE END)
	           INNER JOIN PUB_CITY PC WITH(NOLOCK)
	                ON  PA.CITY_CODE = PC.CITY_CODE
	)
	
	SELECT PL.PRO_CODE
	      ,PDP.PRICE_SEQ
	      ,PDP.PRICE_NAME
	      ,PDP.ADT_PRICE
	      ,PDP.CHD_PRICE
	      ,PDP.INF_PRICE
	      ,PDP.ADT_TAX
	      ,PDP.CHD_TAX
	      ,PDP.INF_TAX
	      ,PDP.QCHARGE_TYPE
	      ,(CASE PDP.QCHARGE_TYPE WHEN 0 THEN 0 WHEN 1 THEN QL.ADT_QCHARGE ELSE PDP.ADT_QCHARGE END) AS [ADT_SALE_QCHARGE]
	      ,(CASE PDP.QCHARGE_TYPE WHEN 0 THEN 0 WHEN 1 THEN QL.CHD_QCHARGE ELSE PDP.CHD_QCHARGE END) AS [CHD_SALE_QCHARGE]
	      ,(CASE PDP.QCHARGE_TYPE WHEN 0 THEN 0 WHEN 1 THEN QL.INF_QCHARGE ELSE PDP.INF_QCHARGE END) AS [INF_SALE_QCHARGE]
	      ,(CASE PDP.QCHARGE_TYPE WHEN 0 THEN NULL WHEN 1 THEN QL.[START_DATE] ELSE PDP.QCHARGE_DATE END) AS [SALE_QCHARGE_DATE]
	      ,DBO.XN_PRO_SALE_PRICE_CUTTING(PDP.ADT_PRICE + PDP.ADT_TAX + (CASE PDP.QCHARGE_TYPE WHEN 0 THEN 0 WHEN 1 THEN QL.ADT_QCHARGE ELSE PDP.ADT_QCHARGE END)) AS [ADT_SALE_PRICE]
	      ,DBO.XN_PRO_SALE_PRICE_CUTTING(PDP.CHD_PRICE + PDP.CHD_TAX + (CASE PDP.QCHARGE_TYPE WHEN 0 THEN 0 WHEN 1 THEN QL.CHD_QCHARGE ELSE PDP.CHD_QCHARGE END)) AS [CHD_SALE_PRICE]
	      ,DBO.XN_PRO_SALE_PRICE_CUTTING(PDP.INF_PRICE + PDP.INF_TAX + (CASE PDP.QCHARGE_TYPE WHEN 0 THEN 0 WHEN 1 THEN QL.INF_QCHARGE ELSE PDP.INF_QCHARGE END)) AS [INF_SALE_PRICE]
	      --,DBO.XN_PUB_PRICE_CUTTING(QL.ADT_QCHARGE ,3) AS [ADT_QCHARGE]
	      --,DBO.XN_PUB_PRICE_CUTTING(QL.CHD_QCHARGE ,3) AS [CHD_QCHARGE]
	      --,DBO.XN_PUB_PRICE_CUTTING(QL.INF_QCHARGE ,3) AS [INF_QCHARGE]
	FROM   PRO_LIST PL
	       INNER JOIN dbo.PKG_DETAIL_PRICE PDP WITH(NOLOCK)
	            ON  PL.PRO_CODE = PDP.PRO_CODE
	       CROSS APPLY (
	    SELECT *
	          ,ROW_NUMBER() OVER(PARTITION BY PL.PRO_CODE ORDER BY QCHARGE_LIST.DATE_ORDER ,QCHARGE_LIST.NEW_DATE DESC ,QCHARGE_LIST.ZONE_ORDER) AS [ROWNUM]
	    FROM   (
	               SELECT TOP 1 PL.PRO_CODE
	                     ,AEQ.[START_DATE]
	                     ,AEQ.ADT_QCHARGE
	                     ,AEQ.CHD_QCHARGE
	                     ,AEQ.INF_QCHARGE
	                     ,AEQ.NEW_DATE
	                     ,(CASE WHEN AEQ.END_DATE > PL.DEP_DATE THEN 1 ELSE 2 END) AS [DATE_ORDER]
	                     ,(CASE WHEN PATINDEX('%' + PL.AIRPORT_CODE + '%' ,AEQ.AIRPORT_CODES) > 0 THEN 1 ELSE 2 END) AS [ZONE_ORDER]
	               FROM   AIRLINE_EXC_QCHARGE AEQ WITH(NOLOCK)
	               WHERE  AEQ.AIRLINE_CODE = PL.AIRLINE_CODE
	                      AND AEQ.[START_DATE] <= PL.DEP_DATE
	                      AND (PATINDEX('%' + PL.AIRPORT_CODE + '%' ,AEQ.AIRPORT_CODES) > 0 OR PATINDEX('%' + PL.NATION_CODE + '%' ,AEQ.NATION_CODES) > 0)
	               ORDER BY
	                      (CASE WHEN AEQ.END_DATE > PL.DEP_DATE THEN 1 ELSE 2 END)
	                     ,AEQ.NEW_DATE DESC
	                     ,(CASE WHEN PATINDEX('%' + PL.AIRPORT_CODE + '%' ,AEQ.AIRPORT_CODES) > 0 THEN 1 ELSE 2 END)
	               UNION ALL
	               SELECT TOP 1 PL.PRO_CODE
	                     ,AQ.[START_DATE]
	                     ,AQ.ADT_QCHARGE
	                     ,AQ.CHD_QCHARGE
	                     ,AQ.INF_QCHARGE
	                     ,AQ.NEW_DATE
	                     ,(CASE WHEN AQ.END_DATE > PL.DEP_DATE THEN 1 ELSE 2 END) AS [DATE_ORDER]
	                     ,(CASE WHEN PATINDEX('%' + PL.AIRPORT_CODE + '%' ,AR.AIRPORT_CODES) > 0 THEN 1 ELSE 2 END) AS [ZONE_ORDER]
	               FROM   AIRLINE_QCHARGE AQ WITH(NOLOCK)
	                      INNER JOIN AIRLINE_REGION AR WITH(NOLOCK)
	                           ON  AQ.AIRLINE_CODE = AR.AIRLINE_CODE
	                               AND AQ.GROUP_SEQ = AR.GROUP_SEQ
	                               AND AQ.REGION_SEQ = AR.REGION_SEQ
	               WHERE  AQ.AIRLINE_CODE = PL.AIRLINE_CODE
	                      AND AQ.START_DATE <= PL.DEP_DATE
	                      AND (PATINDEX('%' + PL.AIRPORT_CODE + '%' ,AR.AIRPORT_CODES) > 0 OR PATINDEX('%' + PL.NATION_CODE + '%' ,AR.NATION_CODES) > 0)
	               ORDER BY
	                      (CASE WHEN AQ.END_DATE > PL.DEP_DATE THEN 1 ELSE 2 END)
	                     ,AQ.NEW_DATE DESC
	                     ,(CASE WHEN PATINDEX('%' + PL.AIRPORT_CODE + '%' ,AR.AIRPORT_CODES) > 0 THEN 1 ELSE 2 END)
	               UNION ALL
	               SELECT PL.PRO_CODE
	                     ,NULL AS [START_DATE]
	                     ,0 AS [ADT_QCHARGE]
	                     ,0 AS [CHD_QCHARGE]
	                     ,0 AS [INF_QCHARGE]
	                     ,NULL AS [NEW_DATE]
	                     ,3 AS [DATE_ORDER]
	                     ,3 AS [ZONE_ORDER]
	           ) QCHARGE_LIST
	) QL
	WHERE  QL.ROWNUM = 1

GO
