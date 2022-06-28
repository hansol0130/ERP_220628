USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_RESERVE_CODE_LIST_SELECT
■ DESCRIPTION				: 검색_예약코드페이지별목록
■ INPUT PARAMETER			: CUS_NO, PAGE_INDEX, PAGE_SIZE
■ EXEC						: 
    -- exec SP_MOV2_RESERVE_CODE_LIST_SELECT 8505125, 1, 5, 1

■ MEMO						: 예약코드 목록을 가져오기.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-08-06		오준욱(IBSOLUTION)		최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_RESERVE_CODE_LIST_SELECT]
	@CUS_NO			INT,
	@PAGE_INDEX		INT,
	@PAGE_SIZE		INT,
	@SELECT_TYPE	INT
AS
BEGIN

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
			) P2
		WHERE P2.ROWNUM BETWEEN (' + CONVERT(varchar(20), @PAGE_INDEX) + ' * ' + CONVERT(varchar(20), @PAGE_SIZE) + ' + 1) AND (' + CONVERT(varchar(20), @PAGE_INDEX) + ' + 1) * ' + CONVERT(varchar(20), @PAGE_SIZE) + '

	';

	

	SET @PARMDEFINITION = N'@CUS_NO INT,@PAGE_INDEX INT,@PAGE_SIZE INT';
	 --PRINT @SQLSTRING + ' ' + @PARMDEFINITION

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @CUS_NO, @PAGE_INDEX, @PAGE_SIZE;

	-- EXEC (@SQLSTRING)

END           



GO
