USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_RESERVE_LATEST_SELECT
■ DESCRIPTION				: 검색_최근진행중인예약목록
■ INPUT PARAMETER			: CUS_NO
■ EXEC						: 
    -- 
	
	exec SP_MOV2_RESERVE_LATEST_SELECT '4797216'

■ MEMO						: 최근 진행중인 예약목록을 가져오기.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-07-31		오준욱(IBSOLUTION)		최초생성
   2017-10-13		박형만				트래블 가이드 사용여부 컬럼추가 
   2017-10-14		박형만				DEP_DEP_AIRPORT_CODE 컬럼추가  
   2017-10-18		박형만				이동제외 
   2017-10-25		박형만				쿼리수정 회원여부제거(진행중예약이라 필요없음) , 도착일 조회 조건 통일 , 출발일 빠른순 
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_RESERVE_LATEST_SELECT]
	@CUS_NO			INT
AS
BEGIN
--DECLARE @CUS_NO INT 
--SET @CUS_NO = 4797216 
	--DECLARE @MEM_YN VARCHAR(1);  --정회원 여부 
	DECLARE @SQLSTRING NVARCHAR(MAX), @ADD_STRING1 VARCHAR(100), @ADD_STRING2 VARCHAR(100), @PARMDEFINITION NVARCHAR(1000);

	--회원정보 조회 
	--IF EXISTS ( SELECT * FROM CUS_MEMBER  WITH(NOLOCK) WHERE CUS_NO = @CUS_NO AND CUS_STATE = 'Y'  )
	--	BEGIN
	--		SET @MEM_YN = 'Y' --정회원
	--	END 
	--ELSE 
	--	BEGIN
	--		SET @MEM_YN = 'N' --비회원
	--	END 

	SET @SQLSTRING = '
		SELECT 
			RES.*, C.TRANSFER_TYPE, D.DEP_DEP_AIRPORT_CODE,
			CASE WHEN SUBSTRING(A.RES_CODE,2,1) = ''P'' THEN
					CASE WHEN D.SEAT_CODE IS NOT NULL THEN D.DEP_DEP_DATE 
					ELSE C.DEP_DATE 
					END 

				WHEN SUBSTRING(A.RES_CODE,2,1) = ''T'' THEN
					CASE WHEN E.DEP_DEP_DATE IS NOT NULL THEN CONVERT(DATETIME,CONVERT(VARCHAR(10),E.DEP_DEP_DATE,121) + '' '' + E.DEP_DEP_TIME + '':00'')
					ELSE A.DEP_DATE 
					END 
			ELSE RES.DEPDATE
			END AS DEP_DATE,

			CASE WHEN SUBSTRING(A.RES_CODE,2,1) = ''P'' THEN
					CASE WHEN D.SEAT_CODE IS NOT NULL THEN D.ARR_ARR_DATE 
					ELSE C.ARR_DATE 
					END

				WHEN SUBSTRING(A.RES_CODE,2,1) = ''T'' THEN

					--국내 편도는 도착일을 출발도착시간으로 
					CASE  WHEN E.INTER_YN = ''N'' AND E.ROUTING_TYPE = 1 THEN 
						CASE WHEN E.DEP_ARR_DATE IS NOT NULL THEN CONVERT(DATETIME,CONVERT(VARCHAR(10),E.DEP_ARR_DATE,121) + '' '' + E.DEP_ARR_TIME + '':00'')
						ELSE E.DEP_ARR_DATE 
						END
					ELSE 
						CASE WHEN E.ARR_ARR_DATE IS NOT NULL THEN CONVERT(DATETIME,CONVERT(VARCHAR(10),E.ARR_ARR_DATE,121) + '' '' + E.ARR_ARR_TIME + '':00'')
						ELSE E.ARR_ARR_DATE 
						END 
					END
			ELSE  RES.ARRDATE
			END AS ARR_DATE ,
			DBO.XN_APP_RES_USE_YN(A.RES_CODE) AS TRAVEL_GUIDE_YN
		FROM RES_MASTER_damo A WITH(NOLOCK)
			INNER JOIN ( 
				SELECT * FROM ( 
					SELECT A.RES_STATE, A.DEP_DATE DEPDATE, A.ARR_DATE ARRDATE, A.PRO_TYPE , A.RES_CODE , ''Y'' AS MASTER_YN , A.NEW_DATE , A.RES_NAME AS RES_NAME, ''N'' AS ADULT_YN, 
					ISNULL( (SELECT TOP 1 SEQ_NO FROM RES_CUSTOMER_DAMO A1 WITH(NOLOCK) WHERE A1.RES_CODE = A.RES_CODE AND A1.CUS_NO = A.CUS_NO ), 0 ) AS SEQ_NO,
					(SELECT COUNT(*) FROM RES_CUSTOMER_DAMO A1 WITH(NOLOCK) WHERE A1.RES_CODE = A.RES_CODE AND A1.CUS_NO = A.CUS_NO ) AS RND, A.PRO_CODE
					FROM RES_MASTER_damo A WITH(NOLOCK) 
					WHERE CUS_NO = @CUS_NO
					AND A.VIEW_YN =''Y'' --노출여부
					AND A.RES_STATE <> 8  --이동제외 
					UNION ALL 

					SELECT A.RES_STATE, A.DEP_DATE DEPDATE, A.ARR_DATE ARRDATE, A.PRO_TYPE , A.RES_CODE , ''N'' AS MASTER_YN , A.NEW_DATE , B.CUS_NAME AS RES_NAME, 
						IIF(B.AGE_TYPE = 0, ''Y'', ''N'') AS ADULT_YN, B.SEQ_NO AS SEQ_NO, 0 AS RND, A.PRO_CODE
					FROM RES_MASTER_damo A WITH(NOLOCK) 
						INNER JOIN RES_CUSTOMER_DAMO B WITH(NOLOCK) 
							ON A.RES_CODE = B.RES_CODE 
							AND A.CUS_NO  <> B.CUS_NO
					WHERE B.CUS_NO = @CUS_NO
					AND A.RES_STATE <> 8  --이동제외 
					AND B.RES_STATE = 0  -- 정상출발자만 
					AND B.VIEW_YN = ''Y'' -- 노출여부 
				) TBL 
			) RES ON A.RES_CODE = RES.RES_CODE 
			LEFT JOIN PKG_DETAIL  C  WITH(NOLOCK)
				ON A.PRO_CODE = C.PRO_CODE 	
			LEFT JOIN PRO_TRANS_SEAT D WITH(NOLOCK) 
				ON C.SEAT_CODE = D.SEAT_CODE
			LEFT JOIN RES_AIR_DETAIL E WITH(NOLOCK) 
				ON A.RES_CODE = E.RES_CODE
		--WHERE (CASE WHEN A.RES_STATE IN(7,8,9) THEN -2 
		--			WHEN IIF(A.ARR_DATE IS NULL, IIF(C.ARR_DATE IS NULL, GETDATE()-1, C.ARR_DATE), A.ARR_DATE) < GETDATE()-1 THEN -1  ELSE 0 END ) = 0 
		WHERE A.RES_STATE NOT IN (7,8,9)  --정상예약만
		AND IIF(A.ARR_DATE IS NULL, A.DEP_DATE, A.ARR_DATE) >= CONVERT(DATETIME,cast(DATEADD(D,1,getdate()) as date))  
		/*RES_MASTER 다음날 정각 이후 도착(편도는출발)예약만 */ 
		ORDER BY A.DEP_DATE ASC , A.NEW_DATE DESC -- 출발일 빠른순 , 최근예약순 
	';


	SET @PARMDEFINITION = N'@CUS_NO INT'
	 --PRINT @SQLSTRING + ' ' + @PARMDEFINITION

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @CUS_NO;

	 --EXEC (@SQLSTRING)

END 
GO
