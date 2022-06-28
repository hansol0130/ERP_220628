USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_RESERVE_CODE_LIST_SELECT
■ DESCRIPTION				: 마이페이지 여행후기 탭 후기 작성하지 않은 예약리스트 검색
■ INPUT PARAMETER			: 

	@CUS_NO	INT				: 고객 코드

■ EXEC						: 

    -- exec SP_MOV2_RESERVE_CODE_REVIEW_LIST_SELECT 4797216, 1, 5, 1

	-- exec SP_MOV2_RESERVE_CODE_REVIEW_LIST_SELECT 15, 1, 5, 1

■ MEMO						: 정상적으로 결제가 완료된 패키중에 후기를 작성하지 않은 예약 내역 최근부터 5개 검색
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-09-23		고민우(IBSOLUTION)		최초생성
   2017-11-06		김성호					쿼리 수정
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_RESERVE_CODE_REVIEW_LIST_SELECT]
	@CUS_NO			INT,
	@PAGE_INDEX		INT,
	@PAGE_SIZE		INT,
	@SELECT_TYPE	INT
AS
BEGIN

	SELECT TOP 5 ROW_NUMBER() OVER (ORDER BY A.DEP_DATE DESC) AS [ROWNUM]
		, A.MASTER_CODE, A.PRO_CODE, A.PRO_NAME, A.DEP_DATE, C.ARR_DATE
	FROM RES_MASTER_damo A WITH(NOLOCK)
	INNER JOIN RES_CUSTOMER_DAMO B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
	INNER JOIN PKG_DETAIL C WITH(NOLOCK) ON A.PRO_CODE = C.PRO_CODE
	WHERE A.RES_STATE <= 7 AND B.RES_STATE = 0 AND B.CUS_NO = @CUS_NO 
		AND A.PRO_TYPE = 1 
		AND C.ARR_DATE < GETDATE()
		AND NOT EXISTS(SELECT 1 FROM HBS_DETAIL AA WITH(NOLOCK) WHERE AA.MASTER_SEQ = 1 AND AA.MASTER_CODE = A.MASTER_CODE AND AA.NEW_CODE = @CUS_NO AND AA.DEL_YN = 'N')
	ORDER BY A.DEP_DATE DESC



/*
	DECLARE @MEM_YN VARCHAR(1), @ADD_STRING VARCHAR(100);   
	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000);

	--회원정보 조회 
	IF EXISTS ( SELECT * FROM CUS_MEMBER  WITH(NOLOCK) WHERE CUS_NO = @CUS_NO AND CUS_STATE = 'Y'  )
		BEGIN
			SET @MEM_YN = 'Y' --정회원
		END 
	ELSE 
		BEGIN
			SET @MEM_YN = 'N' --비회원
		END

	IF @SELECT_TYPE = 2
		BEGIN
			SET @ADD_STRING = 'AND P1.ONGOING = 0'
		END
	ELSE
		BEGIN
			SET @ADD_STRING = ''
		END

	SET @SQLSTRING = '

		SELECT * FROM (	
			SELECT ROW_NUMBER() OVER (ORDER BY P1.ONGOING DESC, P1.NEW_DATE DESC) AS ROWNUM, * FROM ( 	
	
				SELECT 
					(CASE WHEN A.RES_STATE IN(7,8,9) THEN -2 
							WHEN IIF(A.ARR_DATE IS NULL, IIF(C.ARR_DATE IS NULL, GETDATE()-1, C.ARR_DATE), A.ARR_DATE) < GETDATE()-1 THEN -1  ELSE 0 END ) ONGOING,

					RES.*, 
					C.PRO_NAME,
					C.MASTER_CODE
				FROM RES_MASTER_damo A WITH(NOLOCK)
					INNER JOIN ( 
						SELECT * FROM ( 
							SELECT A.RES_CODE, A.NEW_DATE
							FROM RES_MASTER_damo A WITH(NOLOCK) 
							WHERE CUS_NO = ' + CONVERT(varchar(20), @CUS_NO) + '
							-- AND SUBSTRING(A.RES_CODE,2,1)  IN ( ''P'',''T'',''H'')  -- 패키지, 자유여행, 호텔		
							AND A.VIEW_YN =''Y'' --노출여부
							-- AND A.RES_STATE < 7
							AND (( ''' + @MEM_YN + ''' = ''N'' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE()) ) OR ''' + @MEM_YN + ''' = ''Y'' )  --비회원 출발일 30일 지난것은 표시 안함 
							UNION ALL 
							SELECT A.RES_CODE, A.NEW_DATE
							FROM RES_MASTER_damo A WITH(NOLOCK) 
								INNER JOIN RES_CUSTOMER_DAMO B WITH(NOLOCK) 
									ON A.RES_CODE = B.RES_CODE 
									AND A.CUS_NO  <> B.CUS_NO
							WHERE B.CUS_NO = ' + CONVERT(varchar(20), @CUS_NO) + '
							-- AND SUBSTRING(A.RES_CODE,2,1)  IN ( ''P'',''T'',''H'') -- 패키지, 자유여행, 호텔						
							AND B.RES_STATE = 0  -- 정상출발자만 
							AND B.VIEW_YN = ''Y'' -- 노출여부 
							-- AND A.RES_STATE < 7
							AND (( ''' + @MEM_YN + ''' = ''N'' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE()) ) OR ''' + @MEM_YN + ''' = ''Y'' )  --비회원 출발일 30일 지난것은 표시 안함 
						) TBL 
					) RES ON A.RES_CODE = RES.RES_CODE 
					LEFT JOIN PKG_DETAIL  C  WITH(NOLOCK)
						ON A.PRO_CODE = C.PRO_CODE 
	
				) P1
				WHERE 1= 1 ' + @ADD_STRING + '
				AND P1.MASTER_CODE NOT IN (SELECT HD.MASTER_CODE FROM HBS_DETAIL HD WHERE HD.NEW_CODE = ' + CONVERT(varchar(20), @CUS_NO) + ' AND HD.MASTER_SEQ = 1 AND HD.CATEGORY_SEQ = 0 AND HD.DEL_YN = ''N'' AND HD.NOTICE_YN = ''N'' AND HD.MASTER_CODE IS NOT NULL)
			) P2
		WHERE P2.ROWNUM BETWEEN (' + CONVERT(varchar(20), @PAGE_INDEX) + ' * ' + CONVERT(varchar(20), @PAGE_SIZE) + ' + 1) AND (' + CONVERT(varchar(20), @PAGE_INDEX) + ' + 1) * ' + CONVERT(varchar(20), @PAGE_SIZE) + '

	';

	

	SET @PARMDEFINITION = N'@CUS_NO INT,@PAGE_INDEX INT,@PAGE_SIZE INT';
	--PRINT @SQLSTRING + ' ' + @PARMDEFINITION

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @CUS_NO, @PAGE_INDEX, @PAGE_SIZE;

	-- EXEC (@SQLSTRING)
*/
END           



GO
