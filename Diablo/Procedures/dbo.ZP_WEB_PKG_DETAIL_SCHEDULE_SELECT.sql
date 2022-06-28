USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: ZP_WEB_PKG_DETAIL_SCHEDULE_SELECT
■ DESCRIPTION				: 행사 상세 일정표 검색
■ INPUT PARAMETER			: 
	@PRO_CODE VARCHAR(20)	: 행사코드
	@PRICE_SEQ INT			: 가격순번
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec ZP_WEB_PKG_DETAIL_SCHEDULE_SELECT 'CPP9050-140305A', 2

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-03		김성호			최초생성
   2013-06-10		김성호			WITH(NOLOCK) 추가
   2019-03-12		김성호			쿼리 수정
   2019-03-14		박형만			식사코드 추가
   2019-11-19		고병호			XN_CNT_GET_IMAGE_FILE_PATH_STRING --> XN_CNT_GET_LARGE_IMAGE_FILE_PATH
   2020-02-18	    임원묵			XP_WEB_PKG_DETAIL_SCHEDULE_SELECT -> ZP_WEB_PKG_DETAIL_SCHEDULE_SELECT 로 복사 생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[ZP_WEB_PKG_DETAIL_SCHEDULE_SELECT]
(@PRO_CODE VARCHAR(20) ,@PRICE_SEQ INT)
AS
BEGIN
	-- 일자정보
	SELECT C.*
	      ,DATEADD(DAY ,(C.DAY_NUMBER -1) ,A.DEP_DATE) AS [DAY]
	      ,D.HTL_MASTER_CODE
	      ,D.STAY_INFO AS [HTL_MASTER_NAME]
	      ,D.DINNER_1
	      ,D.DINNER_2
	      ,D.DINNER_3
	      ,D.DINNER_CODE_1
	      ,D.DINNER_CODE_2
	      ,D.DINNER_CODE_3
	      ,E.HTL_GRADE
	      ,F.TEL_NUMBER
	      ,STUFF(
	           (
	               SELECT ('-' + BB.KOR_NAME) AS [text()]
	               FROM   PKG_DETAIL_SCH_CITY AA WITH(NOLOCK)
	                      INNER JOIN PUB_CITY BB WITH(NOLOCK)
	                           ON  AA.CITY_CODE = BB.CITY_CODE
	               WHERE  AA.PRO_CODE = C.PRO_CODE
	                      AND AA.SCH_SEQ = C.SCH_SEQ
	                      AND AA.DAY_SEQ = C.DAY_SEQ
	               ORDER BY
	                      AA.CITY_SHOW_ORDER FOR XML PATH('')
	           )
	          ,1
	          ,1
	          ,''
	       ) AS [TOUR_JOURNEY]
	FROM   PKG_DETAIL A WITH(NOLOCK)
	       INNER JOIN PKG_DETAIL_PRICE B WITH(NOLOCK)
	            ON  A.PRO_CODE = B.PRO_CODE
	       INNER JOIN PKG_DETAIL_SCH_DAY C WITH(NOLOCK)
	            ON  B.PRO_CODE = C.PRO_CODE
	                AND B.SCH_SEQ = C.SCH_SEQ
	       INNER JOIN PKG_DETAIL_PRICE_HOTEL D WITH(NOLOCK)
	            ON  B.PRO_CODE = D.PRO_CODE
	                AND B.PRICE_SEQ = D.PRICE_SEQ
	                AND C.DAY_NUMBER = D.DAY_NUMBER
	       LEFT JOIN HTL_MASTER E WITH(NOLOCK)
	            ON  D.HTL_MASTER_CODE = E.MASTER_CODE
	       LEFT JOIN INF_HOTEL F WITH(NOLOCK)
	            ON  E.CNT_CODE = F.CNT_CODE
	WHERE  A.PRO_CODE = @PRO_CODE
	       AND B.PRICE_SEQ = @PRICE_SEQ
	ORDER BY
	       C.DAY_NUMBER;
	---- 도시
	SELECT B.*
	      ,C.KOR_NAME AS [CITY_NAME]
	FROM   PKG_DETAIL_PRICE A WITH(NOLOCK)
	       INNER JOIN PKG_DETAIL_SCH_CITY B WITH(NOLOCK)
	            ON  A.PRO_CODE = B.PRO_CODE
	                AND A.SCH_SEQ = B.SCH_SEQ
	       INNER JOIN PUB_CITY C WITH(NOLOCK)
	            ON  C.CITY_CODE = B.CITY_CODE
	WHERE  A.PRO_CODE = @PRO_CODE
	       AND A.PRICE_SEQ = @PRICE_SEQ
	ORDER BY
	       B.DAY_SEQ
	      ,B.CITY_SHOW_ORDER;
	---- 컨텐츠
	SELECT B.*
	      ,C.KOR_TITLE
	      ,C.GPS_X
	      ,C.GPS_Y
	      ,C.SHORT_DESCRIPTION
	      ,C.DESCRIPTION
	      ,C.DISPLAY_TYPE
	      ,C.CNT_TYPE
	      ,C.SHOW_YN AS [CNTSHOW_YM]
	      ,(
	           CASE B.CNT_CODE
	                WHEN 0 THEN NULL 
	                     -- ELSE DBO.XN_CNT_GET_IMAGE_FILE_PATH_STRING(B.CNT_CODE, (CASE C.DISPLAY_TYPE WHEN 2 THEN 2 ELSE 1 END), '|') END) AS [FILE_PATH_STRING]
	                ELSE DBO.XN_CNT_GET_LARGE_IMAGE_FILE_PATH(B.CNT_CODE)
	           END
	       ) AS [FILE_PATH_STRING] -- 2019-11-19
	FROM   PKG_DETAIL_PRICE A WITH(NOLOCK)
	       INNER JOIN PKG_DETAIL_SCH_CONTENT B WITH(NOLOCK)
	            ON  A.PRO_CODE = B.PRO_CODE
	                AND A.SCH_SEQ = B.SCH_SEQ
	       LEFT JOIN INF_MASTER C WITH(NOLOCK)
	            ON  B.CNT_CODE = C.CNT_CODE
	WHERE  A.PRO_CODE = @PRO_CODE
	       AND A.PRICE_SEQ = @PRICE_SEQ
	ORDER BY
	       B.DAY_SEQ
	      ,B.CNT_SHOW_ORDER;
END
GO
