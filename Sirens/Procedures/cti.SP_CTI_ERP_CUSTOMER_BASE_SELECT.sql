USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: SP_CTI_ERP_CUSTOMER_BASE_SELECT
■ DESCRIPTION				: ERP 고객 기본정보 조회 
■ INPUT PARAMETER			: 
	@CUS_NO					: 고객번호
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec CTI.SP_CTI_ERP_CUSTOMER_BASE_SELECT @CUS_NO = 4228549
	 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-10-23		박형만			최초생성
   2014-10-30		곽병삼			상담이력 SAVE TYPE이 초기저장(1) 은 조회 제외.
   2014-12-17		곽병삼			상담이력 SAVE TYPE이 0인 내용만 조회 제외.
   2020-12-09		김성호			고객 등급 위치 변경 (CUS_VIP_HISTRORY)
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_ERP_CUSTOMER_BASE_SELECT]
--DECLARE
	@CUS_NO	INT
--SET @CUS_NO = 4284582
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--DECLARE @CUS_NO INT 
--SET  @CUS_NO = 4228549

DECLARE @ING_CNT INT   -- 미출발 진행중예약 
DECLARE @HISTORY_CNT INT -- 출발일 지난 결제중,결제완료,출발완료예약 

DECLARE @LAST_DEP_DATE DATETIME  -- 가장마지막 완료 예약 
DECLARE @BEFORE_DEP_DATE DATETIME -- 진행중인 출발전 예약 
;
---------------------- 고객의 예약 기본 정보 ( 예약자+출발자) ------------------------------
WITH RES_LIST AS 
( 
	SELECT 
	RES.RES_CODE ,
	CASE WHEN A.PRO_TYPE = 1 AND LEN(A.PRO_CODE) > 6 AND  SUBSTRING(A.PRO_CODE,3,1) = 'F' THEN 4 
		ELSE A.PRO_TYPE  END AS PRO_TYPE , 
	A.DEP_DATE , A.RES_STATE , 

	--2 완료: 출발일이 지난 예약 
	--1 진행: 출발전 예약 
	CASE WHEN A.DEP_DATE < GETDATE() /*A.RES_STATE IN (3,4,5,6) */  THEN 2 
		 WHEN A.DEP_DATE > GETDATE() /* A.RES_STATE IN (0,1,2,3,4) AND */ THEN 1 ELSE 0 END  AS RES_STATE_EXT
	FROM 
	( 
		SELECT A.RES_CODE   -- 예약자 
		FROM Diablo.dbo.RES_MASTER_damo A WITH(NOLOCK) 
		WHERE A.CUS_NO = @CUS_NO 
		--AND (( @MEM_YN = 'N' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE()) ) OR @MEM_YN = 'Y' )  --비회원 출발일 30일 지난것은 표시 안함 
		AND A.VIEW_YN ='Y' --노출여부
		AND A.RES_STATE NOT IN ( 7,8,9 )
		UNION ALL 	
		SELECT A.RES_CODE  -- 출발자 
		FROM Diablo.dbo.RES_MASTER_damo A WITH(NOLOCK) 
		INNER JOIN Diablo.dbo.RES_CUSTOMER_DAMO B WITH(NOLOCK) 
			ON A.RES_CODE = B.RES_CODE 
			AND A.CUS_NO <> B.CUS_NO 
		WHERE B.CUS_NO = @CUS_NO 
		AND B.RES_STATE = 0  --정상출발자만 
		--AND (( @MEM_YN = 'N' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE()) ) OR @MEM_YN = 'Y' )  --비회원 출발일 30일 지난것은 표시 안함 
		AND B.VIEW_YN ='Y' --노출여부
		AND A.RES_STATE NOT IN ( 7,8,9 )
	) RES 
		INNER JOIN Diablo.dbo.RES_MASTER_damo A
			ON RES.RES_CODE = A.RES_CODE 
)

--------------------------------------------------------------------------------------------------------------

-- 예약 집계정보 
SELECT 
	--2 완료: 결제완료,출발완료인것OR 결제중이면서 출발 한달지난것  
	--1 진행: 완료상태 이외의 상태중, 접수,확인,확정,결제중인것 
	@ING_CNT = SUM(CASE WHEN RES_STATE_EXT = 1 THEN 1 ELSE 0 END) ,  
	@HISTORY_CNT = SUM(CASE WHEN RES_STATE_EXT = 2 THEN 1 ELSE 0 END) ,  
		
	@LAST_DEP_DATE = MAX(CASE WHEN RES_STATE_EXT = 2 THEN A.DEP_DATE ELSE NULL END ) ,  -- 출발일 지난것중 가장큰값
	@BEFORE_DEP_DATE = MIN(CASE WHEN RES_STATE_EXT = 1 THEN A.DEP_DATE ELSE  NULL END ) -- 출발전인 것중 가장 작은값
FROM RES_LIST A

--------------------------------------------------------------------------------------------------------------
-- 고객정보 
SELECT
	ISNULL(CVH.CUS_GRADE, 0) AS [CUS_GRADE],
	CUS.CUS_NO,
	CUS.CUS_ID,
	CUS.CUS_NAME,
	CUS.FIRST_NAME,
	CUS.LAST_NAME,
	CUS.BIRTH_DATE,
	DATEDIFF(YEAR,CAST(CUS.BIRTH_DATE AS DATETIME),GETDATE()) AS AGE,
	CUS.GENDER,
	CASE WHEN ISNULL(CUS.NOR_TEL3,'') <> '' THEN ISNULL(CUS.NOR_TEL1,'') + '-' +ISNULL(CUS.NOR_TEL2,'')+ '-' +ISNULL(CUS.NOR_TEL3,'') END AS NOR_TEL,
	CUS.NOR_TEL1 ,CUS.NOR_TEL2 ,CUS.NOR_TEL3 ,
	CASE WHEN ISNULL(CUS.HOM_TEL3,'') <> '' THEN ISNULL(CUS.HOM_TEL1,'') + '-' +ISNULL(CUS.HOM_TEL2,'')+ '-' +ISNULL(CUS.HOM_TEL3,'') END AS HOM_TEL,
	CUS.HOM_TEL1 ,CUS.HOM_TEL2 ,CUS.HOM_TEL3 ,
	CASE WHEN ISNULL(CUS.COM_TEL3,'') <> '' THEN ISNULL(CUS.COM_TEL1,'') + '-' +ISNULL(CUS.COM_TEL2,'')+ '-' +ISNULL(CUS.COM_TEL3,'') END AS COM_TEL,
	CUS.COM_TEL1 ,CUS.COM_TEL2 ,CUS.COM_TEL3 ,
	CUS.EMAIL,
	
	--집계정보
	(SELECT COUNT(*) FROM cti.CTI_CONSULT WHERE CUS_NO = CUS.CUS_NO AND SAVE_TYPE <> '0' AND NEW_DATE > DATEADD(M,-1,GETDATE())  ) AS CONSULT_CNT ,
	@ING_CNT AS ING_CNT , 
	@HISTORY_CNT AS HISTORY_CNT , 
	@LAST_DEP_DATE AS LAST_DEP_DATE ,
	@BEFORE_DEP_DATE AS BEFORE_DEP_DATE 

FROM Diablo.dbo.CUS_CUSTOMER_DAMO CUS WITH(NOLOCK)
LEFT JOIN Diablo.DBO.CUS_VIP_HISTORY CVH WITH(NOLOCK) ON CUS.CUS_NO = CVH.CUS_NO AND CVH.VIP_YEAR = YEAR(GETDATE())
WHERE CUS.CUS_NO = @CUS_NO

SET NOCOUNT OFF 
GO
