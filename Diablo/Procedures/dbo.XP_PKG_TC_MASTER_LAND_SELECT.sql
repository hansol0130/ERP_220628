USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Server					: 211.115.202.230
■ Database					: DIABLO
■ USP_Name					: XP_PKG_TC_MASTER_LAND_SELECT
■ Description				: 
■ Input Parameter			:                  
	@MASTER_CODE	VARCHAR(10)
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						:  

	EXEC XP_PKG_TC_MASTER_LAND_SELECT @TOT_CODE = 'UPP154-220506OZ07', @AGT_TYPE_CODE = null
	
	EXEC XP_PKG_TC_MASTER_LAND_SELECT @TOT_CODE = 'UPP154', @AGT_TYPE_CODE = null

■ Author					:  
■ Date						: 
■ Memo						: 상품마스터화면/ 랜드사 조회
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date				Author			Description           
---------------------------------------------------------------------------------------------------
	2013-04-25			오인규 			최초생성  
	2014-04-23			이동호 			마스터페이지 행사 페이지 등록시 모도 노출되게 처리[임시 추후 변경될수있음 참초:이슬아계장]
	2014-11-27			정지용			최초 조회시 마스터에 등록된 랜드사 저장하도록 수정 / 잘못된 쿼리 수정(이해안되는 쿼리 주석처리)
	2018-08-23			김성호			WITH(NOLOCK) 옵션 추가
  	2022-01-14			김성호			PKG_AGT_MASTER 스키마 변경으로 SP 수정
  	2022-02-17			김성호			수배카운트 퀴리 수정
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[XP_PKG_TC_MASTER_LAND_SELECT]
(
    @TOT_CODE          VARCHAR(20)
   ,@AGT_TYPE_CODE     VARCHAR(2)
    
    -- @FLAG			CHAR(1)   -- M:마스터  P: 행사
    --,@MASTER_CODE	VARCHAR(10)
    --,@PRO_CODE      VARCHAR(20)
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
	    SELECT @TOT_CODE = SUBSTRING(@TOT_CODE ,0 ,CHARINDEX('-' ,@TOT_CODE))
	END
	
	SELECT PAM.TOT_CODE
	      ,PAM.AGT_CODE
	      ,AM.AGT_TYPE_CODE
	      ,AM.KOR_NAME AS [AGT_NAME]
	      ,AM.AGT_REGISTER
	      ,AM.CEO_NAME
	      ,(
	           SELECT COUNT(AMM.MEM_CODE)
	           FROM   dbo.AGT_MEMBER AMM
	           WHERE  PAM.AGT_CODE = AMM.AGT_CODE
	                  AND AMM.WORK_TYPE IN (1 ,2)
	                  AND AMM.MEM_TYPE = 1
	       ) AS TCCount
	      ,(
	           SELECT COUNT(ARM.AGT_CODE)
	           FROM   dbo.ARG_MASTER ARM
	           WHERE  PAM.AGT_CODE = ARM.AGT_CODE
	                  AND ARM.PRO_CODE = @TOT_CODE
	       ) AS ARGCOUNT	-- 해당 행사의 수배건 수만 표시
	FROM   dbo.PKG_AGT_MASTER PAM
	       INNER JOIN dbo.AGT_MASTER AM
	            ON  PAM.AGT_CODE = AM.AGT_CODE
	WHERE  PAM.TOT_CODE = @TOT_CODE
	       AND AM.AGT_TYPE_CODE = (CASE WHEN @AGT_TYPE_CODE IS NULL THEN AM.AGT_TYPE_CODE ELSE @AGT_TYPE_CODE END)
	       AND AM.SHOW_YN = 'Y'
	ORDER BY
	       AM.KOR_NAME

/*	
	IF @FLAG = 'M'
		BEGIN
		-- 마스터 진입시
				WITH LIST AS(
					SELECT A.AGT_MASTER_CODE, A.MASTER_CODE, A.AGT_CODE
					FROM  dbo.PKG_AGT_MASTER A WITH(NOLOCK)
					INNER JOIN  dbo.AGT_MASTER B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE AND A.AGT_TYPE_CODE ='12'
					--WHERE (A.MASTER_CODE = @MASTER_CODE) OR (DBO.FN_ARR_SPLIT(A.PRO_CODE,'-',1) = @MASTER_CODE)
					WHERE A.MASTER_CODE = @MASTER_CODE
					--GROUP BY  A.AGT_CODE, A.MASTER_CODE
					GROUP BY  A.AGT_CODE, A.MASTER_CODE, AGT_MASTER_CODE
				)
				SELECT A.*, B.KOR_NAME, B.AGT_REGISTER, B.CEO_NAME 
				--, (SELECT TOP 1 M.AGT_MASTER_CODE FROM PKG_AGT_MASTER M WHERE M.AGT_CODE = A.AGT_CODE) AS AGT_MASTER_CODE
				, AGT_MASTER_CODE
				, (SELECT COUNT(C.MEM_CODE) FROM dbo.AGT_MEMBER C WITH(NOLOCK) WHERE C.AGT_CODE = A.AGT_CODE AND C.WORK_TYPE IN (1, 2) AND C.MEM_TYPE =1) AS TCCount
				, (SELECT COUNT(D.AGT_CODE) FROM dbo.ARG_MASTER D WITH(NOLOCK) WHERE D.AGT_CODE = A.AGT_CODE AND DBO.FN_ARR_SPLIT(D.PRO_CODE,'-',1) = @MASTER_CODE) AS ARGCOUNT
				FROM LIST A 							
				INNER JOIN AGT_MASTER B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE
		END
	ELSE
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE AND TC_LAND_YN = 'Y')
		BEGIN			
			SELECT @MASTER_CODE = MASTER_CODE FROM PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE;
			INSERT INTO DBO.PKG_AGT_MASTER ( MASTER_CODE, PRO_CODE, AGT_CODE, AGT_TYPE_CODE, NEW_DATE, NEW_CODE, EDT_DATE, EDT_CODE)
			SELECT 
				'',
				@PRO_CODE,
				AGT_CODE,
				'12',
				GETDATE(),
				'9999999',
				GETDATE(),
				'9999999'
			FROM PKG_AGT_MASTER WITH(NOLOCK) WHERE MASTER_CODE = @MASTER_CODE	
			
			UPDATE PKG_DETAIL SET TC_LAND_YN = 'Y' WHERE PRO_CODE = @PRO_CODE		
		END;		

		WITH LIST AS(
			SELECT A.MASTER_CODE, A.AGT_CODE, A.AGT_MASTER_CODE
			FROM  dbo.PKG_AGT_MASTER A WITH(NOLOCK)
			INNER JOIN  dbo.AGT_MASTER B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE AND A.AGT_TYPE_CODE ='12'						
			WHERE A.PRO_CODE = @PRO_CODE
			GROUP BY  A.AGT_CODE, A.MASTER_CODE, A.AGT_MASTER_CODE
		)
		SELECT A.*, B.KOR_NAME, B.AGT_REGISTER, B.CEO_NAME 
		--, (SELECT TOP 1 M.AGT_MASTER_CODE FROM PKG_AGT_MASTER M WHERE M.AGT_CODE = A.AGT_CODE) AS AGT_MASTER_CODE
		, AGT_MASTER_CODE
		, (SELECT COUNT(C.MEM_CODE) FROM dbo.AGT_MEMBER C WITH(NOLOCK) WHERE C.AGT_CODE = A.AGT_CODE AND C.WORK_TYPE IN (1, 2) AND C.MEM_TYPE =1) AS TCCount
		, (SELECT COUNT(D.AGT_CODE) FROM dbo.ARG_MASTER D WITH(NOLOCK) WHERE D.AGT_CODE = A.AGT_CODE AND D.PRO_CODE = @PRO_CODE ) AS ARGCOUNT
		FROM LIST A 							
		INNER JOIN AGT_MASTER B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE
	
	END
*/

END
GO
