USE [VGLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: USP_MKT_MASTER
■ DESCRIPTION				: 네이버 등록용 최저가 상품 검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec USP_MKT_MASTER
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   									최초생성
   2014-06-12		차지훈			C.SHOW_YN 조건 추가
   2014-10-23		김성호			가격에 유류할증료 포함
   2014-12-10		김성호			마스터 최저가가 아닌 상품 최저가 기준으로 정렬 순서 변경
   2017-07-27		박형만			행사 구분코드가 항공사 코드일때 항공사명 추출 
   2017-11-28		박형만			항공사 코드 없으면 unique_code null 이 되는 현상 해결 , 좌석조인 실제 항공사 코드 가져옴 	
   2017-12-05		박형만			마스터속성 추가 , 이벤트 정보 추가  
================================================================================================================*/ 
CREATE PROC [dbo].[USP_MKT_MASTER]
AS
WITH LIST AS
(
	SELECT A.PRO_CODE, 
		--SUBSTRING(A.PRO_CODE, 0, CHARINDEX('-', A.PRO_CODE)) + '-' +  SUBSTRING(A.PRO_CODE, CHARINDEX('-', A.PRO_CODE) + 1 + 6, LEN(A.PRO_CODE)) AS UNIQUE_CODE
		SUBSTRING(A.PRO_CODE, 0, CHARINDEX('-', A.PRO_CODE))  AS MASTER_CODE   
		, SUBSTRING(A.PRO_CODE, CHARINDEX('-', A.PRO_CODE) + 1 + 6, LEN(A.PRO_CODE)) AS SUFFIX 
		--, ISNULL((SELECT AIRLINE_CODE FROM DIABLO..PUB_AIRLINE WHERE AIRLINE_CODE = SUBSTRING(A.PRO_CODE, CHARINDEX('-', A.PRO_CODE) + 1 + 6, LEN(A.PRO_CODE))),DEP_TRANS_CODE) AS AIRLINE_CODE
		, DEP_TRANS_CODE AS AIRLINE_CODE , A.EVENT_NAME 
		, (B.ADT_PRICE + B.ADT_TAX + (CASE B.QCHARGE_TYPE WHEN 0 THEN 0 WHEN 1 THEN [DIABLO].[dbo].[XN_PRO_DETAIL_QCHARGE_PRICE](A.PRO_CODE) ELSE B.ADT_QCHARGE END)) AS [ADT_PRICE]
		, B.POINT_PRICE, A.ATT_CODE, A.DEP_DATE
	FROM (

		SELECT 
		--SUBSTRING(A.PRO_CODE, 0, CHARINDEX('-', A.PRO_CODE)) + '-' +   D.DEP_TRANS_CODE , 
			A.PRO_CODE, B.PRICE_SEQ, C.ATT_CODE, DEP_DATE
			, D.DEP_TRANS_CODE 
			, ROW_NUMBER() OVER (PARTITION BY SUBSTRING(A.PRO_CODE, 0, CHARINDEX('-', A.PRO_CODE)) + '-' +   D.DEP_TRANS_CODE  ORDER BY B.ADT_PRICE) AS [ROWNUMBER]
			, CASE WHEN ISNULL(C.EVENT_PRO_CODE,'') <> '' AND EVENT_DEP_DATE > GETDATE() THEN C.EVENT_NAME ELSE NULL END AS EVENT_NAME 
		FROM Diablo.DBO.PKG_DETAIL A WITH(NOLOCK)
		INNER JOIN Diablo.DBO.PKG_DETAIL_PRICE B WITH(NOLOCK) ON A.PRO_CODE = B.PRO_CODE
		INNER JOIN Diablo.DBO.PKG_MASTER C WITH(NOLOCK) ON A.MASTER_CODE = C.MASTER_CODE
		INNER JOIN Diablo.DBO.PRO_TRANS_SEAT D WITH(NOLOCK) ON A.SEAT_CODE = D.SEAT_CODE   --좌석조인 
		WHERE A.DEP_DATE > GETDATE() AND A.SHOW_YN = 'Y' AND C.SHOW_YN = 'Y' AND B.ADT_PRICE > 5000
		--and c.master_code like 'APP0%'
		--and c.master_code like 'APF2414'
	) A
	INNER JOIN Diablo.DBO.PKG_DETAIL_PRICE B WITH(NOLOCK) ON A.PRO_CODE = B.PRO_CODE AND A.PRICE_SEQ = B.PRICE_SEQ
	WHERE A.ROWNUMBER =  1 
)
SELECT * FROM 
(
	SELECT A.*,
	--CASE WHEN SUFFIX = '' OR AIRLINE_CODE IS NOT NULL THEN A.MASTER_CODE + '-'+ LTRIM(RTRIM(ISNULL(AIRLINE_CODE,''))) ELSE A.MASTER_CODE + '-' END UNIQUE_CODE ,
	A.MASTER_CODE +'-'+ (CASE WHEN ISNULL(SUFFIX,'') <> '' THEN LTRIM(RTRIM(ISNULL(AIRLINE_CODE,''))) ELSE '' END) UNIQUE_CODE ,
	REPLACE(D.PUB_VALUE, '여행', '') AS ATT_CODE_DESC, B.PRO_NAME, B.NEW_CODE, C.TEAM_CODE, 
		('http://www.verygoodtour.com/Product/Package/PackageDetail?ProCode=' + A.PRO_CODE) AS PRO_URL ,
		CASE WHEN ISNULL(SUFFIX,'') <> ''THEN ( SELECT KOR_NAME FROM DIABLO..PUB_AIRLINE WHERE AIRLINE_CODE = A.AIRLINE_CODE ) ELSE '' END AS AIRLINE_NAME,
		--,E.DEP_TRANS_CODE 
		STUFF((SELECT ('^' + BB.PUB_VALUE ) AS [text()]
				FROM  Diablo.DBO.PKG_ATTRIBUTE AA 
				INNER JOIN Diablo.DBO.COD_PUBLIC BB 
					ON AA.ATT_CODE = BB.PUB_CODE AND BB.PUB_TYPE = 'PKG.ATTRIBUTE'
				WHERE B.MASTER_CODE = AA.MASTER_CODE 
				FOR XML PATH('')), 1, 1, '') AS ATT_NAME  
	FROM LIST A 
	JOIN DIABLO.DBO.PKG_DETAIL B WITH(NOLOCK) ON B.PRO_CODE = A.PRO_CODE
	JOIN DIABLO.DBO.EMP_MASTER C WITH(NOLOCK) ON B.NEW_CODE = C.EMP_CODE
	JOIN DIABLO.DBO.COD_PUBLIC D WITH(NOLOCK) ON A.ATT_CODE = D.PUB_CODE AND D.PUB_TYPE = 'PKG.ATTRIBUTE'
	--LEFT JOIN DIABLO.DBO.PRO_TRANS_SEAT E WITH(NOLOCK) ON B.SEAT_CODE = E.SEAT_CODE 
) T 
	WHERE UNIQUE_CODE IS NOT NULL 
ORDER BY T.PRO_CODE  
GO
