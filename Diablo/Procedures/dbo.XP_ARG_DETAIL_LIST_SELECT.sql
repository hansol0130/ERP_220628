USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_ARG_DETAIL_LIST_SELECT
■ DESCRIPTION				: 수배현황상세 리스트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	/Land/LandCommonHandler.ashx?type=argdetail&proCode=XXX101-140422&agtCode=&argType=0&argStatus=0
	EXEC DBO.XP_ARG_DETAIL_LIST_SELECT 'XXX101-140422','',0,0
	EXEC DBO.XP_ARG_DETAIL_LIST_SELECT 'CPP1020-131217','',0,0
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-03-27		박형만			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_ARG_DETAIL_LIST_SELECT]
 	@PRO_CODE PRO_CODE,
	@AGT_CODE VARCHAR(10), -- 랜드사코드 
	@ARG_TYPE INT, -- 구분  0전체, 수배요청서, 수배확정서, 인보이스, 인보이스확정 
	@ARG_STATUS INT  --  상태 
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	--수배상세 
	SELECT 
		B.PRO_CODE,
		B.AGT_CODE,
		A.*,
		--(SELECT PRO_CODE FROM ARG_MASTER WHERE ARG_SEQ_NO = A.ARG_SEQ_NO) AS PRO_CODE,
		(SELECT PRO_NAME FROM dbo.PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = B.PRO_CODE) AS PRO_NAME,
		(SELECT DEP_DATE FROM dbo.PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = B.PRO_CODE) AS DEP_DATE,
		(SELECT KOR_NAME FROM dbo.AGT_MASTER WITH(NOLOCK) WHERE AGT_CODE = B.AGT_CODE) AS AGT_NAME,
		ADT_COUNT +CHD_COUNT+INF_COUNT+FOC_COUNT  AS TOT_COUNT,
		DBO.XN_COM_GET_EMP_NAME(A.NEW_CODE) AS NEW_NAME,
		DBO.XN_COM_GET_TEAM_NAME(A.NEW_CODE) AS NEW_TEAM_NAME,
		DBO.XN_COM_GET_EMP_NAME(A.CFM_CODE) AS CFM_NAME,
		DBO.XN_COM_GET_TEAM_NAME(A.CFM_CODE) AS CFM_TEAM_NAME
	FROM ARG_DETAIL A WITH(NOLOCK)
	INNER JOIN ARG_MASTER B WITH(NOLOCK) ON A.ARG_CODE = B.ARG_CODE
	WHERE B.PRO_CODE = @PRO_CODE 
	AND ( B.AGT_CODE = @AGT_CODE OR ISNULL(@AGT_CODE,'')='') --랜드사 
	AND ( A.ARG_TYPE = @ARG_TYPE OR @ARG_TYPE = 0 )  --구분 
	--@ARG_STATUS
	ORDER BY A.EDT_DATE ASC
END 

GO
