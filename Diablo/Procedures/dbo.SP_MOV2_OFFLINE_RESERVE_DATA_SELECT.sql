USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_OFFLINE_RESERVE_DATA_SELECT
■ DESCRIPTION				: 검색_Mov2_오프라인예약데이타
■ INPUT PARAMETER			: CUS_NO, RES_CODE
■ EXEC						: 
    -- exec SP_MOV2_OFFLINE_RESERVE_DATA_SELECT 8505125, 'RP1610185020'

■ MEMO						: 오프라인 예약데이타 가져오기.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-09-15		IBSOLUTION				최초생성
   2017-12-11		IBSOLUTION				예약자 포함
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_OFFLINE_RESERVE_DATA_SELECT]
	@CUS_NO			INT,
	@RES_CODE		VARCHAR(20)
AS
BEGIN

		SELECT 
			RES.*, 
			A.PRO_CODE, A.PRO_NAME AS RES_MASTER_PRO_NAME,
			A.SALE_COM_CODE , 
			dbo.FN_RES_GET_RES_AGE_COUNT(RES.RES_CODE, 0) AS ADT_COUNT, 
			dbo.FN_RES_GET_RES_AGE_COUNT(RES.RES_CODE, 1) AS CHD_COUNT, 
			dbo.FN_RES_GET_RES_AGE_COUNT(RES.RES_CODE, 2) AS INF_COUNT,
			C.TRANSFER_TYPE,
			D.ATT_CODE,			
			K.FILENAME FREE_FILENAME,
			H.CFM_YN AS CFM_YN,  --여행자 계약서 동의여부	  
			H.CFM_DATE AS CFM_DATE,
			C.PRO_NAME, C.TOUR_DAY, C.TOUR_NIGHT, C.DEP_DATE AS DEP_DATE2, C.ARR_DATE AS ARR_DATE2,
			E.FILE_CODE, E.REGION_CODE, E.NATION_CODE, E.STATE_CODE, E.CITY_CODE, E.FILE_NAME_L, E.FILE_NAME_M, E.FILE_NAME_S, E.FILE_TYPE , 
		
			(SELECT TOP 1 (
				'/CONTENT/' + BB.REGION_CODE + '/' + BB.NATION_CODE + '/'  
				+ RTRIM(BB.STATE_CODE) + '/' + BB.CITY_CODE + '/IMAGE/' + (  
				CASE WHEN BB.FILE_NAME_M <> '' THEN BB.FILE_NAME_M ELSE BB.FILE_NAME_S  END))  
				FROM INF_FILE_MANAGER AA WITH(NOLOCK) 
				INNER JOIN INF_FILE_MASTER BB WITH(NOLOCK) ON BB.FILE_CODE = AA.FILE_CODE AND BB.FILE_TYPE = 1  
				WHERE AA.CNT_CODE = I.CNT_CODE  
			) AS HTL_IMG_URL,
				
			CASE WHEN A.PRO_TYPE = 1 THEN J.DEP_TRANS_CODE ELSE F.AIRLINE_CODE END AIRLINE_CODE, 
			CASE WHEN A.PRO_TYPE = 2 THEN 
				(SELECT TOP 1 OP_AIRLINE_CODE FROM RES_SEGMENT WITH(NOLOCK) WHERE RES_CODE = A.RES_CODE AND OP_AIRLINE_CODE IS NOT NULL) ELSE NULL END  AS  OP_AIRLINE_CODE, 
			CASE WHEN A.PRO_TYPE = 2 THEN 
				(SELECT KOR_NAME FROM PUB_AIRLINE WHERE AIRLINE_CODE = (SELECT TOP 1 OP_AIRLINE_CODE FROM RES_SEGMENT WITH(NOLOCK) WHERE RES_CODE = A.RES_CODE AND OP_AIRLINE_CODE IS NOT NULL)) ELSE NULL END  AS  OP_AIRLINE_NAME, 
			(SELECT KOR_NAME FROM PUB_AIRLINE WHERE AIRLINE_CODE = (CASE WHEN A.PRO_TYPE = 1 THEN J.DEP_TRANS_CODE ELSE F.AIRLINE_CODE END)) AS AIRLINE_NAME, 
			CASE WHEN A.PRO_TYPE = 2 THEN 
				(SELECT TOP 1 FLIGHT FROM RES_SEGMENT WITH(NOLOCK) WHERE RES_CODE = A.RES_CODE ) ELSE J.DEP_TRANS_NUMBER END  AS  FLIGHT_NUMBER, 
	
			CASE WHEN A.PRO_TYPE = 2 THEN 
				(SELECT SUM(CASE WHEN SEAT_STATUS = 'HK' THEN 1 ELSE 0 END) - COUNT(*) FROM RES_SEGMENT  WITH(NOLOCK) 
				WHERE RES_CODE = A.RES_CODE ) ELSE 0 END AS HK_COUNT --좌석별 확약건수 - 전체좌석 (0건이면 확정)							
			FROM RES_MASTER_damo A WITH(NOLOCK)
			INNER JOIN ( 
				SELECT A.RES_STATE, A.DEP_DATE, A.ARR_DATE, A.PRO_TYPE , A.RES_CODE , 'Y' AS MASTER_YN , A.NEW_DATE , A.RES_NAME AS RES_NAME, 'N' AS ADULT_YN, 
					ISNULL( (SELECT TOP 1 SEQ_NO FROM RES_CUSTOMER_DAMO A1 WITH(NOLOCK) WHERE A1.RES_CODE = A.RES_CODE AND A1.CUS_NO = A.CUS_NO ), 0 ) AS SEQ_NO, 
					(SELECT COUNT(*) FROM RES_CUSTOMER_DAMO A1 WITH(NOLOCK) WHERE A1.RES_CODE = A.RES_CODE AND A1.CUS_NO = A.CUS_NO ) AS RND
				FROM RES_MASTER_damo A WITH(NOLOCK) 
				WHERE CUS_NO = @CUS_NO
				AND A.RES_CODE = @RES_CODE
				AND A.VIEW_YN ='Y' --노출여부
				AND A.RES_STATE < 7

				UNION ALL 						

				SELECT A.RES_STATE, A.DEP_DATE, A.ARR_DATE, A.PRO_TYPE , A.RES_CODE , 'N' AS MASTER_YN , A.NEW_DATE , B.CUS_NAME AS RES_NAME, IIF(B.AGE_TYPE = 0, 'Y', 'N') AS ADULT_YN, 
					B.SEQ_NO AS SEQ_NO, 0 AS RND
				FROM RES_MASTER_damo A WITH(NOLOCK) 
					INNER JOIN RES_CUSTOMER_DAMO B WITH(NOLOCK) 
						ON A.RES_CODE = B.RES_CODE 
				WHERE B.CUS_NO = @CUS_NO AND A.CUS_NO  <> B.CUS_NO
				AND B.RES_STATE = 0  -- 정상출발자만 
				AND B.VIEW_YN = 'Y' -- 노출여부
				AND A.RES_CODE = @RES_CODE 
			) RES ON A.RES_CODE = RES.RES_CODE 
			
			LEFT JOIN PKG_DETAIL  C  WITH(NOLOCK)
				ON A.PRO_CODE = C.PRO_CODE 
			
			LEFT JOIN PKG_MASTER D WITH(NOLOCK) 
				ON A.MASTER_CODE = D.MASTER_CODE		
			
			LEFT JOIN INF_FILE_MASTER E WITH(NOLOCK) 
				ON D.MAIN_FILE_CODE = E.FILE_CODE AND E.SHOW_YN = 'Y'		
			
			LEFT JOIN RES_AIR_DETAIL F WITH(NOLOCK) 
				ON A.RES_CODE = F.RES_CODE		
			
			LEFT JOIN  RES_CONTRACT H WITH(NOLOCK)
				ON A.RES_CODE = H.RES_CODE 
				AND H.CONTRACT_NO = (SELECT MAX(CONTRACT_NO) FROM RES_CONTRACT WHERE RES_CODE = H.RES_CODE  )
			
			LEFT JOIN HTL_MASTER I WITH(NOLOCK) 
				ON A.MASTER_CODE = I.MASTER_CODE
						
			LEFT JOIN PRO_TRANS_SEAT J WITH(NOLOCK) 
				ON C.SEAT_CODE = J.SEAT_CODE		
				
			LEFT JOIN APP_FREETOUR_GUIDEFILE K WITH(NOLOCK) 
				ON A.RES_CODE = K.RES_CODE 

END           



GO
