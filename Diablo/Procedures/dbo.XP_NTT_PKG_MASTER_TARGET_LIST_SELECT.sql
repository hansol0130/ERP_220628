USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_NTT_PKG_MASTER_TARGET_LIST_SELECT
■ DESCRIPTION				: 네이버 트립토파즈 업데이트 마스터코드 조회 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC XP_NTT_PKG_MASTER_TARGET_LIST_SELECT @NTT_MASTER_CODE=null
	
	EXEC XP_NTT_PKG_MASTER_TARGET_LIST_SELECT @NTT_MASTER_CODE='APP2091|VJ35'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2021-11-18			김성호			최초생성
	2021-11-29			김성호			네이버 제휴사 상품 등록 된 건만 조회
	2022-04-27			김성호			쿼리튜닝 (with ADC)
================================================================================================================*/ 
CREATE PROC [dbo].[XP_NTT_PKG_MASTER_TARGET_LIST_SELECT]

	@NTT_MASTER_CODE VARCHAR(30) = NULL -- 마스터 상품코드

AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @MASTER_CODE     VARCHAR(20)
	       ,@BIT_CODE        VARCHAR(4);
	
	IF LEN(@NTT_MASTER_CODE) > 0
	BEGIN
	    SELECT @MASTER_CODE = SUBSTRING(@NTT_MASTER_CODE ,0 ,(CASE WHEN CHARINDEX('|' ,@NTT_MASTER_CODE) > 0 THEN CHARINDEX('|' ,@NTT_MASTER_CODE) ELSE 20 END))
	          ,@BIT_CODE = SUBSTRING(@NTT_MASTER_CODE ,(CHARINDEX('|' ,@NTT_MASTER_CODE) + 1) ,(CASE WHEN CHARINDEX('|' ,@NTT_MASTER_CODE) > 0 THEN 4 ELSE 0 END))
	END
	
	IF @MASTER_CODE IS NOT NULL
	BEGIN
	    SELECT NPD.MASTER_CODE
	          ,NPD.BIT_CODE
	          ,COUNT(*) AS [PRO_COUNT]
	          ,(NPD.MASTER_CODE + (CASE WHEN NPD.BIT_CODE = '' THEN '' ELSE '|' END) + NPD.BIT_CODE) AS [NTT_MASTER_CODE]
	          ,MIN(PM.NEW_CODE) AS [EMP_CODE]
	    FROM   NTT_PKG_DETAIL_UPDATE_TARGET NPD WITH(NOLOCK)
	           INNER LOOP
	           JOIN PKG_DETAIL PD WITH(NOLOCK)
	                ON  NPD.PRO_CODE = PD.PRO_CODE
	           INNER JOIN PKG_MASTER PM WITH(NOLOCK)
	                ON  PD.MASTER_CODE = PM.MASTER_CODE
	           INNER JOIN dbo.PKG_MASTER_AFFILIATE PMA WITH(NOLOCK)
	                ON  NPD.MASTER_CODE = PMA.MASTER_CODE
	                    AND NPD.BIT_CODE = PMA.BIT_CODE
	                    AND PMA.PROVIDER = 41
	                    AND PMA.USE_YN = 'Y' -- 네이버
	    WHERE  NPD.CHK_DATE IS NULL
	           AND PD.DEP_DATE > GETDATE()
	           AND NPD.MASTER_CODE = @MASTER_CODE
	           AND NPD.BIT_CODE = ISNULL(@BIT_CODE ,NPD.BIT_CODE)
	    GROUP BY
	           NPD.MASTER_CODE
	          ,NPD.BIT_CODE
	END
	ELSE
	BEGIN
	    SELECT NPD.MASTER_CODE
	          ,NPD.BIT_CODE
	          ,COUNT(*) AS [PRO_COUNT]
	          ,(NPD.MASTER_CODE + (CASE WHEN NPD.BIT_CODE = '' THEN '' ELSE '|' END) + NPD.BIT_CODE) AS [NTT_MASTER_CODE]
	          ,MIN(PM.NEW_CODE) AS [EMP_CODE]
	    FROM   PKG_DETAIL PD WITH(NOLOCK ,INDEX(IDX_PKG_DETAIL_3)) --, index(IDX_PKG_DETAIL_7))
	           INNER JOIN NTT_PKG_DETAIL_UPDATE_TARGET NPD WITH(NOLOCK)
	                ON  NPD.PRO_CODE = PD.PRO_CODE
	           INNER LOOP JOIN PKG_MASTER PM WITH(NOLOCK ,INDEX(PK_PKG_MASTER)) --, INDEX(IDX_PKG_MASTER_3))
	                ON  PD.MASTER_CODE = PM.MASTER_CODE
	           INNER JOIN dbo.PKG_MASTER_AFFILIATE PMA WITH(NOLOCK)
	                ON  NPD.MASTER_CODE = PMA.MASTER_CODE
	                    AND NPD.BIT_CODE = PMA.BIT_CODE
	                    AND PMA.PROVIDER = 41
	                    AND PMA.USE_YN = 'Y' -- 네이버
	    WHERE  NPD.CHK_DATE IS NULL
	           AND PD.DEP_DATE > GETDATE()
	           AND NPD.MASTER_CODE = ISNULL(@MASTER_CODE ,NPD.MASTER_CODE)
	           AND NPD.BIT_CODE = ISNULL(@BIT_CODE ,NPD.BIT_CODE)
	               -- 임시
	               --AND npd.master_code IN ('APG0057','APG020','APG110')-- AND NPD.BIT_CODE = 'KE'
	    GROUP BY
	           NPD.MASTER_CODE
	          ,NPD.BIT_CODE
	END
	
	--SELECT NPD.MASTER_CODE
	--      ,NPD.BIT_CODE
	--      ,COUNT(*) AS [PRO_COUNT]
	--      ,(NPD.MASTER_CODE + (CASE WHEN NPD.BIT_CODE = '' THEN '' ELSE '|' END) + NPD.BIT_CODE) AS [NTT_MASTER_CODE]
	--      ,MIN(PM.NEW_CODE) AS [EMP_CODE]
	--FROM   dbo.PKG_DETAIL PD WITH(NOLOCK ,INDEX(IDX_PKG_DETAIL_3))
	--       INNER JOIN dbo.NTT_PKG_DETAIL_UPDATE_TARGET NPD WITH(NOLOCK)
	--            ON  NPD.PRO_CODE = PD.PRO_CODE
	--       INNER LOOP JOIN dbo.PKG_MASTER PM WITH(NOLOCK ,INDEX(PK_PKG_MASTER))
	--            ON  PD.MASTER_CODE = PM.MASTER_CODE
	--       INNER JOIN dbo.PKG_MASTER_AFFILIATE PMA WITH(NOLOCK)
	--            ON  NPD.MASTER_CODE = PMA.MASTER_CODE
	--                AND NPD.BIT_CODE = PMA.BIT_CODE
	--                AND PMA.PROVIDER = 41
	--                AND PMA.USE_YN = 'Y' -- 네이버
	--WHERE  PD.DEP_DATE > GETDATE()
	--       AND NPD.CHK_DATE IS NULL
	--       AND NPD.MASTER_CODE = ISNULL(@MASTER_CODE ,NPD.MASTER_CODE)
	--       AND NPD.BIT_CODE = ISNULL(@BIT_CODE ,NPD.BIT_CODE)
	--GROUP BY
	--       NPD.MASTER_CODE
	--      ,NPD.BIT_CODE	
	
END 


GO
