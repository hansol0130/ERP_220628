USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_APP_RESERVE_SCH_DAILY_STATIC_MAP
■ DESCRIPTION				: 일정별 정적 지도 생성 리스트
■ INPUT PARAMETER			: START_DATE, END_DATE
■ OUTPUT PARAMETER			: 
■ EXEC						: 

    -- SP_APP_RESERVE_SCH_DAILY_STATIC_MAP '', ''   -- 출발일 오늘자이후 모든 예약 목록
	-- SP_APP_RESERVE_SCH_DAILY_STATIC_MAP '2017-03-03 10:00:00', '2017-03-03 10:10:00' -- 출발일 오늘자이후 시간안에 예약된 목록

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-08-10		김낙겸(IBS)		최초생성 (StaticMap 배치에서 사용함)
   2017-03-03		오준욱(IBS)		예약시간 조건 추가  (MakeMap4Reserve 배치에서 사용함)
   2022-03-08		김성호			동적쿼리 제거
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_APP_RESERVE_SCH_DAILY_STATIC_MAP]
	@START_DATE		VARCHAR(20),
	@END_DATE		VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	-- 테스트
	--SELECT @START_DATE = '2022-03-08 18:00:00', @END_DATE = '2022-03-08 23:10:00'
	
	SELECT RM.PRO_CODE
	      ,PDSM.SCH_SEQ
	FROM   dbo.RES_MASTER_damo RM
	       INNER JOIN PKG_DETAIL PD
	            ON  RM.PRO_CODE = PD.PRO_CODE
	       INNER JOIN PKG_MASTER PM
	            ON  PD.MASTER_CODE = PM.MASTER_CODE
	       INNER JOIN PKG_DETAIL_PRICE PDP
	            ON  RM.PRO_CODE = PDP.PRO_CODE
	                AND RM.PRICE_SEQ = PDP.PRICE_SEQ
	       INNER JOIN PKG_DETAIL_SCH_MASTER PDSM
	            ON  PDP.PRO_CODE = PDSM.PRO_CODE
	                AND PDP.SCH_SEQ = PDSM.SCH_SEQ
	WHERE  RM.DEP_DATE >= CONVERT(DATE ,GETDATE())
	       AND RM.RES_STATE < 7
	       AND RM.PRO_TYPE IN (1 ,2) -- [패키지,항공예약] 실시간,오프라인항공
	       AND RM.PRO_CODE NOT LIKE 'K%' -- [국내해외여부] 해외
	       AND PD.TRANSFER_TYPE = 1 -- [교통편] 항공편
	       AND PM.ATT_CODE IN ('P' ,'R' ,'W' ,'G') -- [마스터 대표속성] 패키지,실시간항공,허니문,골프
	       AND (CASE WHEN @START_DATE IS NULL THEN 1 WHEN RM.NEW_DATE >= @START_DATE THEN 1 ELSE 0 END) = 1
	       AND (CASE WHEN @END_DATE IS NULL THEN 1 WHEN RM.NEW_DATE < DATEADD(DD, 1, CONVERT(DATE, @END_DATE)) THEN 1 ELSE 0 END) = 1
	GROUP BY
	       RM.PRO_CODE
	      ,PDSM.SCH_SEQ
END   
    
	--DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000);
	--SET @SQLSTRING = '';

	--IF(@START_DATE <> '' AND @START_DATE IS NOT NULL)
	--BEGIN
	--	SET @SQLSTRING = @SQLSTRING + ' AND A.NEW_DATE > ''' + @START_DATE + ''''; 
	--END 

	--IF(@END_DATE <> '' AND @END_DATE IS NOT NULL)
	--BEGIN
	--	SET @END_DATE = @END_DATE + ' 23:59:59';
	--	SET @SQLSTRING = @SQLSTRING + ' AND A.NEW_DATE <= ''' + @END_DATE + ''''; 
	--END

	--SET @SQLSTRING = N'
	--	SELECT UPPER(A.PRO_CODE)AS PRO_CODE , A.SCH_SEQ
	--	FROM
	--	(
	--		SELECT B.PRO_CODE, D.SCH_SEQ
	--			FROM RES_MASTER_DAMO A  WITH(NOLOCK)
	--			INNER JOIN PKG_DETAIL B  WITH(NOLOCK)
	--				ON A.PRO_CODE = B.PRO_CODE 
	--			INNER JOIN PKG_MASTER C  WITH(NOLOCK)
	--				ON B.MASTER_CODE = C.MASTER_CODE 
	--			INNER JOIN PKG_DETAIL_PRICE D WITH(NOLOCK)
	--				ON A.PRO_CODE = D.PRO_CODE  AND A.PRICE_SEQ = D.PRICE_SEQ
	
	--		--필수 조건들 
	--		WHERE A.PRO_TYPE IN (1,2)  -- [패키지,항공예약] 실시간,오프라인항공 
	--		AND A.PRO_CODE NOT LIKE ''K%''  --[국내해외여부] 해외 
	--		AND B.TRANSFER_TYPE = 1 -- [교통편] 항공편
	--		AND C.ATT_CODE IN (''P'',''R'',''W'',''G'')  --[마스터 대표속성] 패키지,실시간항공,허니문,골프

	--		--선택 조건들 
	--		AND A.DEP_DATE >= CONVERT(VARCHAR, GETDATE(), 112)   --출발일 오늘자 이후 
	--		AND B.DEP_DATE >= CONVERT(VARCHAR, GETDATE(), 112)   --출발일 오늘자 이후 
	 
	--		AND A.RES_STATE < 7  -- 취소제외
	--		' + @SQLSTRING + '

	--		GROUP BY  B.PRO_CODE, D.SCH_SEQ
	--		--ORDER BY B.PRO_CODE
	--	) A
	--	WHERE A.SCH_SEQ IS NOT NULL
	--	';

	---- SELECT @SQLSTRING
	--SET @PARMDEFINITION=N'@START_DATE VARCHAR(20),@END_DATE VARCHAR(20)';
	----PRINT @SQLSTRING + ' ' + @PARMDEFINITION

	--EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @START_DATE, @END_DATE;



-- SP_APP_RESERVE_SCH_DAILY_STATIC_MAP '2022-03-08 18:00:00', '2022-03-08 23:10:00'
GO
