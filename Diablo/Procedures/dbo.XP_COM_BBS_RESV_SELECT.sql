USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BBS_RESV_SELECT

■ DESCRIPTION				: 출장예약 출발하지 않은 출장예약건

■ INPUT PARAMETER			: 

	@AGT_CODE	VARCHAR(10),: 회사코드
	@EMP_SEQ	INT         : 직원코드
■ EXEC						: 
	XP_COM_BBS_RESV_SELECT '92756',100,1

	XP_COM_BBS_RESV_SELECT '92756',100
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-02-27		저스트고-백경훈		최초생성
   2016-04-29		저스트고-이유라		조건수정(날짜필터 주석처리)
   2016-05-27		저스트고-이유라		BT_STATE SELECT 삭제(사용안함)
   2016-05-30		저스트고-이유라		출발자에 포함된 출장도 검색되도록 수정
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BBS_RESV_SELECT]
(
	@AGT_CODE VARCHAR(10) ,
	@EMP_SEQ INT = 0  --로그인한 사람 
) 
AS 
BEGIN
		SELECT 
		*
		FROM 
		(
			SELECT DISTINCT T.BT_CODE ,
				T.PRO_CODE ,
				APPROVAL_STATE,
				BT_START_DATE,
				BT_END_DATE,
				MIN(DEP_DATE) AS MIN_START_DATE , 
				MAX(ARR_DATE) AS MAX_END_DATE , 
				ISNULL(AIR_CITY_CODE,HTL_CITY_CODE) AS BT_CITY_CODE,
				(SELECT KOR_NAME FROM PUB_CITY WHERE CITY_CODE = ISNULL(AIR_CITY_CODE,HTL_CITY_CODE)) AS BT_CITY_NAME , 
				DATEDIFF(DD, MIN(DEP_DATE), ISNULL(MAX(ARR_DATE),BT_END_DATE)) + 1 AS DAYS,
				SUM(CASE WHEN PRO_TYPE = 2 THEN 1 ELSE 0 END) AS AIR_CNT ,
				SUM(CASE WHEN PRO_TYPE = 3 THEN 1 ELSE 0 END) AS HTL_CNT 
			FROM 
			(
				SELECT A.BT_CODE , A.PRO_CODE , A.BT_CITY_CODE , A.APPROVAL_STATE,  A.NEW_DATE , BT_START_DATE , BT_END_DATE , 
					B.RES_CODE , B.BT_RES_SEQ , C.PRO_TYPE ,
					F.CITY_CODE AS AIR_CITY_CODE , 
					ISNULL(G.CITY_CODE, E.CITY_CODE) AS HTL_CITY_CODE , 
					ISNULL(CASE WHEN C.PRO_TYPE = 2 THEN D.DEP_DEP_DATE 
						WHEN C.PRO_TYPE = 3 THEN E.CHECK_IN ELSE C.DEP_DATE END , BT_START_DATE) DEP_DATE ,  
					ISNULL(CASE WHEN C.PRO_TYPE = 2 THEN D.ARR_ARR_DATE 
						WHEN C.PRO_TYPE = 3 THEN E.CHECK_OUT ELSE C.ARR_DATE END, BT_END_DATE) ARR_DATE,
					C.RES_STATE 
				FROM COM_BIZTRIP_MASTER A WITH(NOLOCK)  
					LEFT JOIN COM_BIZTRIP_DETAIL B WITH(NOLOCK) 
						ON A.AGT_CODE = B.AGT_CODE 
						AND A.BT_CODE = B.BT_CODE 
					LEFT JOIN RES_MASTER_damo C WITH(NOLOCK) 
						ON B.RES_CODE = C.RES_CODE 
					LEFT JOIN RES_AIR_DETAIL D WITH(NOLOCK) 
						ON C.RES_CODE = D.RES_CODE 
					LEFT JOIN RES_HTL_ROOM_MASTER E WITH(NOLOCK) 
						ON C.RES_CODE = E.RES_CODE 
					LEFT JOIN PUB_AIRPORT F WITH(NOLOCK) 
						ON D.DEP_ARR_AIRPORT_CODE = F.AIRPORT_CODE
					LEFT JOIN PUB_CITY_MAP_JUSTGO G WITH(NOLOCK) 
						ON E.CITY_CODE = G.JG_CITY_CODE
				WHERE A.AGT_CODE = @AGT_CODE
			--	AND A.BT_START_DATE > GETDATE() -- 출발하지 않은
			--	AND C.DEP_DATE >  DATEADD(DD,5,GETDATE())  --5일 이후 출발 건만
				AND (A.NEW_SEQ = @EMP_SEQ OR EXISTS(
					SELECT 1 
					FROM RES_CUSTOMER_DAMO AA WITH(NOLOCK)
					INNER JOIN COM_EMPLOYEE_MATCHING BB WITH(NOLOCK) ON AA.CUS_NO = BB.CUS_NO 
					WHERE AA.RES_CODE = C.RES_CODE AND 
					BB.AGT_CODE = A.AGT_CODE AND BB.EMP_SEQ = @EMP_SEQ)
				) 
			) T 
			GROUP BY T.BT_CODE , T.PRO_CODE , BT_END_DATE , ISNULL(AIR_CITY_CODE,HTL_CITY_CODE) ,
				APPROVAL_STATE,
				BT_START_DATE,
				BT_END_DATE
		) TT 
		WHERE  BT_START_DATE IS NOT NULL 
	--AND BT_START_DATE > GETDATE() -- 출발하지 않은 조건 한번더 구함
		ORDER BY BT_START_DATE ASC 
END 



GO
