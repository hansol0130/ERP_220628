USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_PKG_BEST_COMMUNITY_SEARCH
- 기 능 : 베스트상품후기,상품평 타입별 조회 
====================================================================================
	참고내용
====================================================================================
- 예제
 EXEC SP_PKG_BEST_COMMUNITY_SEARCH 'VGT' , '900' , 0 ,   1 
 EXEC SP_PKG_BEST_COMMUNITY_SEARCH 'VGT' , '10101' , 0 ,   1
====================================================================================
	변경내역
====================================================================================
- 2011-12-26 박형만 신규 작성 
- 2012-03-02 박형만 WITH(NOLOCK) 추가 
===================================================================================*/
CREATE PROC [dbo].[SP_PKG_BEST_COMMUNITY_SEARCH]
	@SITE_CODE	VARCHAR(3),
	@MENU_CODE	VARCHAR(20),
	@SEC_SEQ	INT , 
	@TYPE_SEQ	int 
AS 
BEGIN 

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF (@TYPE_SEQ = 1 )    -- 상품평 
	BEGIN
		SELECT 
			--A.PRO_TYPE,A.A_TYPE,A.A_NAME,A.PRO_NAME ,
			--B.REG_SEQ,B.CODE_TYPE,B.CODE,B.CODE_SEQ ,
			--B.ORDER_SEQ,B.NEW_CODE,B.NEW_DATE,
			A.SITE_CODE , A.NEW_CODE , A.SEC_SEQ  , 
			A.NEW_CODE ,  A.NEW_DATE ,  A.ORDER_NO , 
			A.CODE , A.CODE_SEQ , 
			D.MASTER_CODE AS CODE ,
			D.MASTER_CODE AS MASTER_CODE ,
			C.PRO_CODE AS PRO_CODE , 
			D.MASTER_NAME AS [NAME] ,
			C.TITLE ,
			C.CONTENTS ,
			C.NEW_DATE AS REG_DATE ,
			C.GRADE , 
			C.CUS_NO ,
			CASE WHEN ISNULL(C.NICKNAME,'') ='' THEN (SELECT TOP 1 CUS_NAME FROM CUS_CUSTOMER_damo WITH(NOLOCK) WHERE CUS_NO = C.CUS_NO) ELSE C.NICKNAME END  AS CUS_NAME  ,
			(POINT1+POINT2+POINT3+POINT4+POINT5) AS POINT , 
			E.*
		FROM (	SELECT A.SITE_CODE, A.MENU_CODE , A.SEC_SEQ , 
				A.DTI_ITEM1 AS CODE, CONVERT(INT,A.DTI_ITEM2) AS CODE_SEQ , 
				A.NEW_CODE ,  A.NEW_DATE ,  A.ORDER_NO 
				FROM PKG_BEST_DETAIL AS A WITH(NOLOCK)
				WHERE A.SITE_CODE = @SITE_CODE
				AND A.MENU_CODE = @MENU_CODE 
				AND (@SEC_SEQ = 0 OR A.SEC_SEQ = @SEC_SEQ )
				AND A.TYPE_SEQ IN (1) -- 상품평 
			  )AS A 
			INNER JOIN PRO_COMMENT AS C WITH(NOLOCK) 
				ON A.CODE = C.MASTER_CODE 
				AND A.CODE_SEQ = C.COM_SEQ
			INNER JOIN PKG_MASTER AS D WITH(NOLOCK) 
				ON C.MASTER_CODE = D.MASTER_CODE 
			LEFT JOIN INF_FILE_MASTER AS E WITH(NOLOCK)
				ON D.MAIN_FILE_CODE = E.FILE_CODE
		ORDER BY A.ORDER_NO ASC
		
	END 
	ELSE IF ( @TYPE_SEQ IN(2,3,4) )  --여행후기 
	BEGIN
		SELECT  
			--A.PRO_TYPE,A.A_TYPE,A.A_NAME,A.PRO_NAME ,
			--B.REG_SEQ,B.CODE_TYPE,B.CODE,B.CODE_SEQ ,
			--B.ORDER_SEQ,B.NEW_CODE,B.NEW_DATE,
			A.SITE_CODE , A.NEW_CODE , A.SEC_SEQ  , 
			A.NEW_CODE ,  A.NEW_DATE ,  A.ORDER_NO , 
			A.CODE_SEQ AS CODE , A.CODE_SEQ , 
			D.MASTER_CODE AS CODE ,
			D.MASTER_CODE AS MASTER_CODE ,
			'' AS PRO_CODE , 
			D.MASTER_NAME AS [NAME] ,
			C.SUBJECT AS TITLE ,
			C.CONTENTS ,
			C.NEW_DATE AS REG_DATE ,
			0 AS GRADE , 
			0 AS CUS_NO ,
			C.NICKNAME AS CUS_NAME ,
			C.SHOW_COUNT 
		FROM (	SELECT A.SITE_CODE, A.MENU_CODE , A.SEC_SEQ , 
				A1.GROUP_CODE AS CODE, CONVERT(INT,A.DTI_ITEM1) AS CODE_SEQ , 
				A.NEW_CODE ,  A.NEW_DATE ,  A.ORDER_NO 
				FROM PKG_BEST_DETAIL AS A WITH(NOLOCK)
					INNER JOIN PKG_BEST_MAPPING AS A1 WITH(NOLOCK)
						ON A.SITE_CODE = A1.SITE_CODE 
						AND A.MENU_CODE = A1.MENU_CODE 
						AND A.SEC_SEQ = A1.SEC_SEQ 
						AND A.MAP_SEQ = A1.MAP_SEQ 
				WHERE A.SITE_CODE = @SITE_CODE
				AND A.MENU_CODE = @MENU_CODE 
				AND (@SEC_SEQ = 0 OR A.SEC_SEQ = @SEC_SEQ )
				AND A.TYPE_SEQ IN (2,3,4) -- 여행후기  
			)AS A 
			INNER JOIN HBS_DETAIL AS C WITH(NOLOCK)
				ON A.CODE = C.MASTER_SEQ
				AND A.CODE_SEQ = C.BOARD_SEQ 
			LEFT JOIN PKG_MASTER AS D WITH(NOLOCK) 
				ON C.MASTER_CODE = D.MASTER_CODE
		ORDER BY A.ORDER_NO ASC
	END 
END 
GO
