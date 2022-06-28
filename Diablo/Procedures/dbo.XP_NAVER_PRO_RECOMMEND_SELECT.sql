USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: [XP_NAVER_PRO_RECOMMEND_SELECT]
■ DESCRIPTION				: 네이버 추천상품 조회 ( 웹관리>베스트상품관리>네이버) 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: [XP_NAVER_PRO_RECOMMEND_SELECT]  
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-11-15		박형만			추천상품 관리가 안되어서 나름의 기준을 가지고 넣어봤음 . 네이버 일일 배치때 실행 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_NAVER_PRO_RECOMMEND_SELECT]
	
	
AS 
BEGIN 

	--SELECT T.* , NPD.CHILDCODE FROM ( 
	--	SELECT mm.NATION_CODE, 
	--		UPPER(pd.MASTER_CODE) AS MASTER_CODE, 
	--		UPPER(mmi.PRO_CODE) AS PRO_CODE, 
	--		MIN(pdp.PRICE_SEQ) AS PRICE_SEQ
	--	FROM MNU_MNG_ITEM mmi
	--	INNER JOIN MNU_MASTER mm
	--		ON mm.MENU_CODE = mmi.MENU_CODE
	--	INNER JOIN PKG_DETAIL pd
	--		ON mmi.PRO_CODE = pd.PRO_CODE
	--	INNER JOIN PKG_DETAIL_PRICE pdp
	--		ON pd.PRO_CODE = pdp.PRO_CODE
	--	INNER JOIN NAVER_PKG_MASTER tnm
	--		ON pd.MASTER_CODE = tnm.MSTCODE

	--	WHERE mm.SITE_CODE = 'NAV'
	--	AND mmi.PRO_CODE <> ''
	--	AND tnm.useYn = 'Y'
	--	GROUP BY PD.MASTER_CODE, mm.NATION_CODE, mmi.PRO_CODE
	--) T  
	--LEFT JOIN NAVER_PKG_DETAIL NPD 
	--ON  T.MASTER_CODE = NPD.mstcode  
	--AND T.PRO_CODE + '|' + convert(varchar,T.PRICE_SEQ) = NPD.CHILDCODE 
	--ORDER BY NATION_CODE


	-- 2019-11-15 추가 
	SELECT T1.* FROM 
	( 
		SELECT * FROM ( 
			SELECT A.NATION_CODE , A.MASTER_CODE ,  
			RANK() OVER ( PARTITION BY A.NATION_CODE , A.MASTER_CODE  ORDER BY C.ADT_PRICE  /*, B.DEP_DATE*/  ) AS PRICE_RANK , 
			--B.DEP_DATE , B.DEP_CFM_YN , 
			B.PRO_CODE ,  C.PRICE_SEQ , 
			B.PRO_CODE  + '|'+ CONVERT(VARCHAR, C.PRICE_SEQ) AS CHILDCODE ,  
			C.ADT_PRICE 

			FROM 
			(
				SELECT MM.NATION_CODE, UPPER(PD.MASTER_CODE) AS MASTER_CODE -- , PD.PRO_CODE 
				FROM MNU_MNG_ITEM MMI
				INNER JOIN MNU_MASTER MM
					ON MM.MENU_CODE = MMI.MENU_CODE
				INNER JOIN PKG_DETAIL PD
					ON MMI.PRO_CODE =  PD.PRO_CODE 
				WHERE MM.SITE_CODE = 'NAV'
				AND MMI.PRO_CODE <> ''
				GROUP BY MM.NATION_CODE, UPPER(PD.MASTER_CODE)
			) A
				INNER JOIN PKG_DETAIL B
					ON A.MASTER_CODE = B.MASTER_CODE 
					AND B.DEP_DATE >=  DATEADD(M,1,GETDATE()) -- 출발일 1개월 남은것 부터 
					AND B.DEP_DATE <  DATEADD(M,3,GETDATE()) -- 출발일 3개월 남은것 
					AND B.DEP_CFM_YN IN('Y','F')  -- 출발 확정인것 
					AND B.SHOW_YN = 'Y' 
					AND B.RES_ADD_YN = 'Y'  -- 예약가능 
					AND B.SALE_TYPE > 1 --긴급,집중모객
		
				INNER JOIN PKG_DETAIL_PRICE C 
					ON B.PRO_CODE = C.PRO_CODE 
		) T 
		WHERE PRICE_RANK IN (1,2) -- 가격순위 2순위 까지 
	) T1 
		INNER JOIN NAVER_PKG_DETAIL T2 
			ON T1.CHILDCODE = T2.CHILDCODE 
			AND T1.MASTER_CODE = T2.MSTCODE 
	
	ORDER BY T1.NATION_CODE , T1.MASTER_CODE   
END 


GO
