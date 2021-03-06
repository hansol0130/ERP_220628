USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* =========================================================================
-- Author:		 
-- Create date:  2011-11-14
-- Description:	<팩스 수신함 조회 카운트>
-- SP_FAX_MASTER_SEARCH_COUNT @SEARCH_TYPE=0,@TEAM_CODE=N'512',@EMP_CODE=NULL,@SUBJECT=NULL,@START_DATE=N'0001-01-01',@END_DATE=N'9999-12-31',@FAX_CAT_SEQ=0

-- 2012-03-02 박형만 WITH(NOLOCK) 추가 	
-- 2012-05-21 쿼리 튜닝 SP_EXECUTESQL 로 수정
-- ========================================================================= */ 
CREATE PROCEDURE [dbo].[SP_FAX_MASTER_SEARCH_COUNT]
	@SEARCH_TYPE INT ,  -- 0: 기본 FAX 수신함 조회. 재직자 사원정보의 FAX 번호로 검색 , 1: 관리자 = 퇴사자도 포함 조회 
	@TEAM_CODE TEAM_CODE,
	@EMP_CODE EMP_CODE,
	@SUBJECT VARCHAR(20),
	@START_DATE VARCHAR(10),
	@END_DATE VARCHAR(10),
	@FAX_CAT_SEQ INT
AS
BEGIN	
--	DECLARE @SEARCH_TYPE INT , 
--@TEAM_CODE TEAM_CODE,
--@EMP_CODE EMP_CODE,
--@SUBJECT VARCHAR(20),
--@START_DATE VARCHAR(10),
--@END_DATE VARCHAR(10),
--@FAX_CAT_SEQ INT

--SELECT @SEARCH_TYPE=0,@TEAM_CODE=N'512',@EMP_CODE=NULL,@SUBJECT=NULL,@START_DATE=N'0001-01-01',@END_DATE=N'9999-12-31',@FAX_CAT_SEQ=0

DECLARE @STR_QUERY NVARCHAR(4000)
DECLARE @STR_WHERE NVARCHAR(500)
DECLARE @STR_SUB_WHERE NVARCHAR(500)
DECLARE @STR_PARAMS NVARCHAR(500)
SET @STR_QUERY = ''
SET @STR_WHERE = ''
SET @STR_SUB_WHERE = ''

IF( @SEARCH_TYPE = 0 ) 
BEGIN
	SET @STR_SUB_WHERE = @STR_SUB_WHERE + '	AND WORK_TYPE = 1 ' 
END 
IF( ISNULL(@EMP_CODE,'') <>'' ) 
BEGIN
	SET @STR_SUB_WHERE = @STR_SUB_WHERE + ' AND EMP_CODE = @EMP_CODE  ' 
END 

IF( @FAX_CAT_SEQ > 0 ) 
BEGIN
	SET @STR_WHERE = @STR_WHERE + ' AND A.FAX_CAT_SEQ = @FAX_CAT_SEQ  ' 
END 
IF( ISNULL(@SUBJECT,'') <>'' ) 
BEGIN
	SET @STR_WHERE = @STR_WHERE + ' AND A.[SUBJECT] LIKE ''%''+@SUBJECT+''%'' ' 
END 
IF( ISNULL(@START_DATE,'0001-01-01') <>'0001-01-01' ) 
BEGIN
	SET @STR_WHERE = @STR_WHERE + ' AND A.NEW_DATE >= CONVERT(DATETIME,@START_DATE)  ' 
END 

IF( ISNULL(@END_DATE,'9999-12-31') <>'9999-12-31' ) 
BEGIN
	SET @STR_WHERE = @STR_WHERE + ' AND A.NEW_DATE < CONVERT(DATETIME,@END_DATE)  ' 
END 

SET @STR_QUERY = '
		SELECT 
			COUNT(A.FAX_SEQ)
		FROM FAX_MASTER  A WITH(NOLOCK) 
			INNER JOIN FAX_RECEIVE B WITH(NOLOCK)
				ON A.FAX_SEQ = B.FAX_SEQ 
				AND A.FAX_TYPE = 2 AND A.DEL_YN=''N''
			INNER JOIN 
			( 
				SELECT FAX_NUMBER1 ,FAX_NUMBER2 ,FAX_NUMBER3 
				FROM EMP_MASTER WITH(NOLOCK)
				WHERE TEAM_CODE = @TEAM_CODE 
				'+@STR_SUB_WHERE+'
				GROUP BY FAX_NUMBER1 ,FAX_NUMBER2 ,FAX_NUMBER3 
			) C 
				ON B.RCV_NUMBER1 = C.FAX_NUMBER1
				AND B.RCV_NUMBER2 = C.FAX_NUMBER2
				AND B.RCV_NUMBER3 = C.FAX_NUMBER3
		WHERE 1=1
		'+@STR_WHERE 
		
SET @STR_PARAMS =N'@SEARCH_TYPE INT,
	@TEAM_CODE TEAM_CODE,
	@EMP_CODE EMP_CODE,
	@SUBJECT VARCHAR(20),
	@START_DATE VARCHAR(10),
	@END_DATE VARCHAR(10),
	@FAX_CAT_SEQ INT'

EXEC SP_EXECUTESQL @STR_QUERY ,@STR_PARAMS,@SEARCH_TYPE ,  
	@TEAM_CODE ,
	@EMP_CODE ,
	@SUBJECT , 
	@START_DATE ,@END_DATE ,
	@FAX_CAT_SEQ

--PRINT @STR_QUERY 
END 
GO
