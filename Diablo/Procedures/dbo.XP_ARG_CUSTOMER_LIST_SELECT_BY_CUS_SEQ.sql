USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ARG_CUSTOMER_LIST_SELECT_BY_CUS_SEQ
■ DESCRIPTION				: 수배현황 출발자 리스트 
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	XP_ARG_CUSTOMER_LIST_SELECT_BY_CUS_SEQ  'A140408-0051', '','1_1,1_2,1_3,2_1'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-03-25		박형만			최초생성
   2014-04-09		박형만			출발자 나이타입별 카운트 
   2014-12-09		정지용			SORT 수정
   2015-03-03		김성호			주민번호 삭제, 생년월일 추가
================================================================================================================*/ 
CREATE PROC [dbo].[XP_ARG_CUSTOMER_LIST_SELECT_BY_CUS_SEQ]
	@ARG_CODE VARCHAR(12) ,  --수배코드 
	@AGT_CODE VARCHAR(20) , -- 랜드사코드 ( 전체 NULL ) 
	@GRP_CUS_SEQ_NOS VARCHAR(4000) -- 선택된 사용자 명 
AS 
BEGIN

--GO 

--declare @ARG_CODE VARCHAR(12) ,  --수배코드 
--	@AGT_CODE VARCHAR(20) , -- 랜드사코드 ( 전체 NULL ) 
--	@GRP_CUS_SEQ_NOS VARCHAR(4000) -- 선택된 사용자 명 
--select  @ARG_CODE='A140327-0007',@AGT_CODE='93002',@GRP_CUS_SEQ_NOS='4_8,5_8'
--SELECT SUBSTRING(Data , 1, CHARINDEX('_',Data) -1 ) AS GRP_SEQ_NO, 
--			SUBSTRING(Data , CHARINDEX('_',Data)+1  , LEN(DATA) -1  )  AS CUS_SEQ_NO  
--			FROM DBO.FN_SPLIT( @GRP_CUS_SEQ_NOS , ',')  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	--출발자 명단 카운트
	SELECT 
		SUM(CASE WHEN A.AGE_TYPE IN (0) THEN 1 ELSE 0 END ) AS AGE_TYPE_CNT_1 ,
		SUM(CASE WHEN A.AGE_TYPE IN (1) THEN 1 ELSE 0 END ) AS AGE_TYPE_CNT_2 ,
		SUM(CASE WHEN A.AGE_TYPE IN (2) THEN 1 ELSE 0 END ) AS AGE_TYPE_CNT_3 
	FROM  ARG_CUSTOMER A 
		INNER JOIN ARG_DETAIL B
			ON A.ARG_CODE = B.ARG_CODE 
		INNER JOIN ARG_CONNECT C
			ON A.ARG_CODE = C.ARG_CODE 
			AND B.GRP_SEQ_NO = C.GRP_SEQ_NO 
			AND A.CUS_SEQ_NO = C.CUS_SEQ_NO 
		INNER JOIN ARG_MASTER D 
			ON A.ARG_CODE = D.ARG_CODE 
		INNER JOIN 
		(	SELECT SUBSTRING(Data , 1, CHARINDEX('_',Data) -1 ) AS GRP_SEQ_NO, 
			SUBSTRING(Data , CHARINDEX('_',Data)+1  , LEN(DATA) -1  )  AS CUS_SEQ_NO  
			FROM DBO.FN_SPLIT( @GRP_CUS_SEQ_NOS , ',')  
		)  CUS 
			ON B.GRP_SEQ_NO = CUS.GRP_SEQ_NO 
			AND C.CUS_SEQ_NO = CUS.CUS_SEQ_NO
	WHERE A.ARG_CODE = @ARG_CODE
	AND (D.AGT_CODE = @AGT_CODE OR ISNULL(@AGT_CODE,'') = '')
		
	--출발자 명단 
	SELECT
		ROW_NUMBER() OVER( ORDER BY B.ARG_TYPE , A.CUS_SEQ_NO ) AS ROW_NUM , 
		D.PRO_CODE, D.AGT_CODE , C.ARG_CODE , B.ARG_TYPE, C.GRP_SEQ_NO , 
		A.ARG_CODE,A.CUS_SEQ_NO,A.RES_CODE,A.SEQ_NO,A.ARG_STATUS,
		A.CUS_NAME,A.LAST_NAME,A.FIRST_NAME,A.AGE_TYPE,A.GENDER,A.BIRTH_DATE,A.EMAIL,A.CELLPHONE,A.PASS_NUM,A.PASS_EXPIRE,
		A.ROOMING,A.ETC_REMAKR,A.NEW_CODE,A.NEW_DATE,A.EDT_DATE,A.EDT_CODE ,
		CASE WHEN ISDATE(A.BIRTH_DATE) = 1 THEN  
			dbo.FN_CUS_GET_AGE(CONVERT(DATETIME,A.BIRTH_DATE) ,B.DEP_DATE ) 
		ELSE 0 END AS AGE , CUS.GRP_SEQ_NO 
	FROM  ARG_CUSTOMER A 
		INNER JOIN ARG_DETAIL B
			ON A.ARG_CODE = B.ARG_CODE 
		INNER JOIN ARG_CONNECT C
			ON A.ARG_CODE = C.ARG_CODE 
			AND B.GRP_SEQ_NO = C.GRP_SEQ_NO 
			AND A.CUS_SEQ_NO = C.CUS_SEQ_NO 
		INNER JOIN ARG_MASTER D 
			ON A.ARG_CODE = D.ARG_CODE 
		INNER JOIN 
		(	SELECT SUBSTRING(Data , 1, CHARINDEX('_',Data) -1 ) AS GRP_SEQ_NO, 
			SUBSTRING(Data , CHARINDEX('_',Data)+1  , LEN(DATA) -1  )  AS CUS_SEQ_NO  
			FROM DBO.FN_SPLIT( @GRP_CUS_SEQ_NOS , ',')  
		)  CUS 
			ON B.GRP_SEQ_NO = CUS.GRP_SEQ_NO 
			AND C.CUS_SEQ_NO = CUS.CUS_SEQ_NO
			--AND A.CUS_SEQ_NO = CUS.CUS_SEQ_NO 
	WHERE A.ARG_CODE = @ARG_CODE
	AND (D.AGT_CODE = @AGT_CODE OR ISNULL(@AGT_CODE,'') = '')
	--ORDER BY B.ARG_TYPE , A.CUS_SEQ_NO 
	ORDER BY A.RES_CODE ASC, A.SEQ_NO ASC
	--ORDER BY (CASE  WHEN @ORDER_BY = 1 THEN ROW_NUMBER() OVER( ORDER BY A.ARG_STATUS DESC ) 
	--				WHEN @ORDER_BY = 2 THEN ROW_NUMBER() OVER( ORDER BY A.RES_CODE DESC ) 
	--				WHEN @ORDER_BY = 3 THEN ROW_NUMBER() OVER( ORDER BY A.NEW_DATE DESC ) 
	--				ELSE ROW_NUMBER() OVER( ORDER BY A.RES_CODE DESC ) 
	--				END) ASC  
END 

GO
