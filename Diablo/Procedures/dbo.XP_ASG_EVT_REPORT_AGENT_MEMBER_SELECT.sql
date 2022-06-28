USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

		
 /*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_REPORT_AGENT_MEMBER_SELECT
■ DESCRIPTION				: 대외업무시스템 인솔자관리 출장보고서 인솔자 리스트 검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC dbo.XP_ASG_EVT_REPORT_AGENT_MEMBER_SELECT @TOT_CODE = 'XXF111', @AGT_TYPE_CODE = NULL
	
	EXEC dbo.XP_ASG_EVT_REPORT_AGENT_MEMBER_SELECT @TOT_CODE = 'APP0209-170811OZ73', @AGT_TYPE_CODE = NULL

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------)
   2022-01-14		김성호			PKG_AGT_MASTER 스키마 변경 및 SP 분리
									랜드사조회(XP_ASG_EVT_REPORT_AGENT_SELECT), 랜드사인솔자(XP_ASG_EVT_REPORT_AGENT_MEMBER_SELECT)
================================================================================================================*/ 		
CREATE PROCEDURE [dbo].[XP_ASG_EVT_REPORT_AGENT_MEMBER_SELECT]
(
    @TOT_CODE          VARCHAR(20) -- 마스터/행사코드
   ,@AGT_TYPE_CODE     VARCHAR(2) -- AGENT 종류
)
AS
BEGIN
	
/*	public enum AgentTypeEnum
    {
        선택, 항공사 = 11, 랜드사 = 12, 항공권거래처 = 15, 일반거래처 = 16, 보험사 = 17, 기타거래처 = 18, 인센티브거래처 = 20, 간판_타여행사 = 21,
        호텔_해외 = 22, 호텔_국내 = 23, 인솔자 = 30, 대리점 = 50, 지점 = 60, 마케팅 = 70, 국내거래처 = 80, 경리거래처 = 90, 본사 = 99
    }*/
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	-- 행사코드가 없으면 마스터로 검색
	IF NOT EXISTS(
	       SELECT 1
	       FROM   dbo.PKG_AGT_MASTER
	       WHERE  TOT_CODE = @TOT_CODE
	   )
	   AND CHARINDEX('-' ,@TOT_CODE) > 0
	BEGIN
	    --SELECT @TOT_CODE = SUBSTRING(@TOT_CODE ,0 ,(CASE WHEN CHARINDEX('-' ,@TOT_CODE) > 0 THEN CHARINDEX('-' ,@TOT_CODE) ELSE 10 END))
	    SELECT @TOT_CODE = SUBSTRING(@TOT_CODE ,0 ,CHARINDEX('-' ,@TOT_CODE))
	END
		
	-- 행사별 랜드사가 있으면 행사로 검색 행사별 랜드사가 없으면 마스터의 랜드사 정보를 검색
	SELECT DISTINCT 
	       @TOT_CODE AS TOT_CODE
	      ,AM.AGT_TYPE_CODE
	      ,AMM.MEM_CODE
	      ,AMM.KOR_NAME
	      ,AM.AGT_CODE
	FROM   DBO.PKG_AGT_MASTER PAM
	       INNER JOIN DBO.AGT_MASTER AM
	            ON  PAM.AGT_CODE = AM.AGT_CODE
	       INNER JOIN DBO.AGT_MEMBER AMM
	            ON  PAM.AGT_CODE = AMM.AGT_CODE
	WHERE  PAM.TOT_CODE = @TOT_CODE
	       AND AM.AGT_TYPE_CODE = (CASE WHEN @AGT_TYPE_CODE IS NULL THEN AM.AGT_TYPE_CODE ELSE @AGT_TYPE_CODE END)
	       AND AMM.WORK_TYPE = 1
	       AND AMM.MEM_TYPE = 1
	ORDER BY
	       AMM.KOR_NAME
	
/*	
	--랜드사에 속한 인솔자
	SELECT	B.MEM_CODE
			,B.KOR_NAME
			,A.AGT_CODE
	FROM		dbo.PKG_AGT_MASTER A WITH(NOLOCK)
	INNER JOIN dbo.AGT_MEMBER B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE
	WHERE	--A.AGT_MASTER_CODE = @AGT_MASTER_CODE
            A.PRO_CODE = @PRO_CODE
	AND		B.WORK_TYPE = 1
	AND    B.MEM_TYPE = 1
	--AND     B.MEM_CODE LIKE 'L%'
	UNION 		
	SELECT	B.MEM_CODE
			,B.KOR_NAME
			,A.AGT_CODE
	FROM		dbo.PKG_AGT_MASTER A WITH(NOLOCK)
	INNER JOIN dbo.AGT_MEMBER B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE
	WHERE	
			B.WORK_TYPE = 1
	AND    B.MEM_TYPE = 1
*/	
	
END

GO
