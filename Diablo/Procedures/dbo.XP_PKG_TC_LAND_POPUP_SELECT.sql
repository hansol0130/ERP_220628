USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
■ Server					: 211.115.202.230
■ Database					: DIABLO
■ USP_Name					: XP_PKG_TC_LAND_POPUP_SELECT
■ Description				: 
■ Input Parameter			: 
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 

	EXEC DBO.XP_PKG_TC_LAND_POPUP_SELECT @FLAG = 'F', @LANDNAME = '', @MASTER_CODE = 'XPP112'

■ Author					:  
■ Date						: 
■ Memo						: 상품마스터화면/ 랜드사 검색및 등록 조회
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date				Author			Description           
---------------------------------------------------------------------------------------------------
	2013-04-25			오인규			최초생성
	2022-01-14			김성호			PKG_AGT_MASTER 스키마 변경으로 SP 수정
-------------------------------------------------------------------------------------------------*/ 
CREATE PROCEDURE [dbo].[XP_PKG_TC_LAND_POPUP_SELECT]
(
    @TOT_CODE          VARCHAR(20)
   ,@LANDNAME          VARCHAR(50)
   ,@AGT_TYPE_CODE     VARCHAR(2) -- AGENT 종류
    
    --@FLAG			CHAR(1),		-- S: 대리점 조회, F: 전체 조회
    --@LANDNAME		VARCHAR(50),
    --@MASTER_CODE	VARCHAR(10)
)
AS
BEGIN
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
	
	SELECT AM.AGT_CODE
	      ,AM.KOR_NAME AS [AGT_NAME]
	FROM   dbo.AGT_MASTER AM
	       --	WHERE  AM.AGT_CODE IN (SELECT AGT_CODE
	       --	                       FROM   dbo.PKG_AGT_MASTER
	       --	                       WHERE  TOT_CODE = ISNULL(@TOT_CODE ,TOT_CODE))
	WHERE  AM.AGT_TYPE_CODE = (CASE WHEN @AGT_TYPE_CODE IS NULL THEN AM.AGT_TYPE_CODE ELSE @AGT_TYPE_CODE END)
	       AND AM.SHOW_YN = 'Y'
	       AND (@LANDNAME IS NULL OR AM.KOR_NAME LIKE '%' + @LANDNAME + '%')
	       AND (
	               CASE 
	                    WHEN @TOT_CODE = '' THEN 1
	                    WHEN NOT EXISTS (
	                             SELECT 1
	                             FROM   dbo.PKG_AGT_MASTER PAM
	                             WHERE  PAM.TOT_CODE = @TOT_CODE
	                                    AND PAM.AGT_CODE = AM.AGT_CODE
	                         ) THEN 1
	                    ELSE 0
	               END
	           ) = 1
	ORDER BY
	       AM.KOR_NAME
	       
	       --IF @FLAG ='F'
	       --BEGIN
	       --	SELECT	A.AGT_CODE
	       --			,A.KOR_NAME
	       --	FROM	dbo.AGT_MASTER A WITH(NOLOCK)
	       --	WHERE	A.AGT_TYPE_CODE ='12'
	       --	AND		A.SHOW_YN ='Y'
	       --	AND		A.AGT_CODE NOT IN (SELECT AGT_CODE  FROM PKG_AGT_MASTER WHERE MASTER_CODE = @MASTER_CODE)
	       --	--AND		(SELECT COUNT(C.MEM_CODE) FROM dbo.AGT_MEMBER C WHERE C.AGT_CODE = A.AGT_CODE AND C.WORK_TYPE =1 AND C.MEM_TYPE =1) > 0
	       --	ORDER BY A.KOR_NAME
	       --END
	       --ELSE
	       --BEGIN
	       --	SELECT	A.AGT_CODE
	       --			,A.KOR_NAME
	       --	FROM	dbo.AGT_MASTER A WITH(NOLOCK)
	       --	WHERE	A.AGT_TYPE_CODE ='12'
	       --	AND		A.SHOW_YN ='Y'
	       --	--AND		A.AGT_CODE NOT IN (SELECT AGT_CODE  FROM PKG_AGT_MASTER WHERE MASTER_CODE = @MASTER_CODE)
	       --	--AND		(SELECT COUNT(C.MEM_CODE) FROM dbo.AGT_MEMBER C WHERE C.AGT_CODE = A.AGT_CODE AND C.WORK_TYPE =1 AND C.MEM_TYPE =1) > 0
	       --	AND		A.KOR_NAME LIKE '%' +@LANDNAME +'%'
	       --	ORDER BY A.KOR_NAME
	       --END
END


GO
