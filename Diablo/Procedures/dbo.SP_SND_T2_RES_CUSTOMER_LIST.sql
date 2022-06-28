USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_SND_T2_RES_CUSTOMER_LIST
■ DESCRIPTION				: 제2출국장 출발 고객 ( 1시간 배치 기준 : 8시간, 24시간 전 출발 고객 / ICN출발 기준 'KE','DL','AF','KL' 항공만.. )
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC SP_SND_T2_RES_CUSTOMER_LIST ''
	EXEC SP_SND_T2_RES_CUSTOMER_LIST '2018-01-17 18:00:00'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-01-08		정지용			최초생성
   2018-07-25		김성호			사용안함 (SP_RES_SND_TERMINAL_INFO_INSERT 로 대체)
================================================================================================================*/ 
CREATE PROC [dbo].[SP_SND_T2_RES_CUSTOMER_LIST]
	@CHK_DATE DATETIME
AS 
BEGIN	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF ISNULL(@CHK_DATE, '') = ''
	BEGIN
		SET @CHK_DATE = GETDATE();
	END

	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000);
	DECLARE @DEFINE_DATE DATETIME;
	SET @DEFINE_DATE =  CONVERT(DATETIME, CONVERT(VARCHAR(10),@CHK_DATE,121) + ' 00:00:00.000');

	SET @SQLSTRING = N'
		WITH LIST AS (
			SELECT 	
				  A.RES_CODE, A.CUS_NAME
				, CC.NOR_TEL1, CC.NOR_TEL2, CC.NOR_TEL3
				, D.DEP_DEP_AIRPORT_CODE AS DEP_AIRPORT_CODE, D.DEP_TRANS_CODE AS AIRLINE_CODE
				, ABS(DATEDIFF(HH, @CHK_DATE, CONVERT(DATETIME,CONVERT(VARCHAR(10),D.DEP_DEP_DATE,121) + '' '' + D.DEP_DEP_TIME + '':00''))) AS HOUR_DIFF
				, CONVERT(DATETIME,CONVERT(VARCHAR(10),D.DEP_DEP_DATE,121) + '' '' + D.DEP_DEP_TIME + '':00'') AS DEP_DEP_DATE
				, DATEADD(HOUR, -7, CONVERT(DATETIME,CONVERT(VARCHAR(10),D.DEP_DEP_DATE,121) + '' '' + D.DEP_DEP_TIME + '':00'')) AS DEP_7_BEFORE
			FROM RES_CUSTOMER_damo A WITH(NOLOCK)	
			INNER JOIN RES_MASTER B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE AND B.PRO_TYPE = 1
			INNER JOIN PKG_DETAIL C WITH(NOLOCK) ON B.PRO_CODE = C.PRO_CODE
			INNER JOIN CUS_CUSTOMER CC WITH(NOLOCK) ON A.CUS_NO = CC.CUS_NO
			LEFT JOIN PRO_TRANS_SEAT D WITH(NOLOCK) ON C.SEAT_CODE = D.SEAT_CODE
			WHERE B.DEP_DATE >= @DEFINE_DATE AND A.RES_STATE = 0 AND B.RES_STATE NOT IN ( 7,8,9 ) AND ISDATE(B.DEP_DATE) = 1
					AND CC.NOR_TEL1 IS NOT NULL AND CC.NOR_TEL2 IS NOT NULL AND CC.NOR_TEL3 IS NOT NULL
					AND D.DEP_TRANS_CODE IN (''KE'', ''DL'', ''AF'', ''KL'') -- 대한항공, 델타항공, 에어프랑스, 네덜란드항공
			UNION ALL
			SELECT
				  A.RES_CODE, A.CUS_NAME
				, CC.NOR_TEL1, CC.NOR_TEL2, CC.NOR_TEL3
				, C.DEP_DEP_AIRPORT_CODE AS DEP_AIRPORT_CODE, C.AIRLINE_CODE
				, ABS(DATEDIFF(HH, @CHK_DATE, B.DEP_DATE)) AS HOUR_DIFF
				, B.DEP_DATE AS DEP_DEP_DATE
				, DATEADD(HOUR, -7, B.DEP_DATE) AS DEP_7_BEFORE
			FROM RES_CUSTOMER_damo A WITH(NOLOCK)
			INNER JOIN RES_MASTER B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE AND B.PRO_TYPE = 2
			INNER JOIN RES_AIR_DETAIL C WITH(NOLOCK) ON B.RES_CODE = C.RES_CODE
			INNER JOIN CUS_CUSTOMER CC WITH(NOLOCK) ON A.CUS_NO = CC.CUS_NO
			WHERE B.DEP_DATE >= @DEFINE_DATE AND A.RES_STATE = 0 AND B.RES_STATE NOT IN ( 7,8,9 ) AND ISDATE(B.DEP_DATE) = 1
					AND CC.NOR_TEL1 IS NOT NULL AND CC.NOR_TEL2 IS NOT NULL AND CC.NOR_TEL3 IS NOT NULL
					AND C.AIRLINE_CODE IN (''KE'', ''DL'', ''AF'', ''KL'') -- 대한항공, 델타항공, 에어프랑스, 네덜란드항공
		)
		SELECT 
			RES_CODE, CUS_NAME, NOR_TEL1, NOR_TEL2, NOR_TEL3, AIRLINE_CODE, HOUR_DIFF, DEP_AIRPORT_CODE, DEP_DEP_DATE, DEP_7_BEFORE,
			''[참좋은여행 중요공지] 출국전 필수 체크, 인천공항 터미널 반드시 확인하세요.[+]2018년 1월 18일 출발편부터 아래 4개 항공사는 기존 1터미널이 아닌 제2터미널에서 출국하게 됩니다.[+][+]■ 제2터미널 이용항공사[+]- 대한항공(KE)[+]- 에어프랑스(AF)[+]- 네덜란드항공(KL)[+]- 델타항공(DL)[+][+]■ 공동운항(코드셰어)편의 경우 실제 탑승 항공편의 터미널을 이용하셔야 합니다.(ex: 대한항공이 체코항공과 코드셰어하여 체코항공(OK)을 탈 경우 1터미널 이용)[+][+]■ 잘못 도착하신 경우[+]제1터미널 3층 8번과 제2터미널 3층 중앙에서 출발하는 터미널간 셔틀버스 이용(무료, 5분간격)[+][+]■ 참좋은여행 안내데스크[+]제1터미널 : M카운터(14번 출입구 앞) 여행사 테이블(A카운터 폐쇄)[+]제2터미널 : H카운터(8번 출입구 앞) 여행사 테이블'' AS ETC_REMARK
		FROM LIST WHERE HOUR_DIFF = 24 AND DEP_7_BEFORE > @CHK_DATE AND DEP_AIRPORT_CODE = ''ICN'' AND DEP_DEP_DATE >= ''2018-01-18 00:00:00'' ORDER BY DEP_DEP_DATE;
	';
	SET @PARMDEFINITION = N'@CHK_DATE	DATETIME, @DEFINE_DATE DATETIME';
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @CHK_DATE, @DEFINE_DATE;
END

GO
