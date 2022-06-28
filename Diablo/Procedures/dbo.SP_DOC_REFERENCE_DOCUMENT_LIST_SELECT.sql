USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_DOC_REFERENCE_DOCUMENT_LIST_SELECT
■ DESCRIPTION				: 전자결재 참조 가능문서 검색
■ INPUT PARAMETER			: 
	@FLAG					: 1: 문서카운트, 2: 문서리스트
	@EMP_CODE				: 사원코드
	@START_DATE				: 검색 시작일
	@END_DATE				: 검색 종료일
	@PAGESIZE				: 페이지 사이즈
	@IPAGE					: 현재페이지

■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC SP_DOC_REFERENCE_DOCUMENT_LIST_SELECT '2', '2007044', '2008-04-01', '2008-04-11', 5, 0
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2008-04-25		김성호			최초생성
   2015-06-23		김성호			쿼리튜닝
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[SP_DOC_REFERENCE_DOCUMENT_LIST_SELECT]
	@FLAG			VARCHAR(1),
	@EMP_CODE		CHAR(7),
	@START_DATE		VARCHAR(10),
	@END_DATE		VARCHAR(10),
	@PAGESIZE		INT,
	@IPAGE			INT
AS
BEGIN

	DECLARE @QUERY VARCHAR(8000);

	IF @FLAG = '1'
	BEGIN
		SET @QUERY = '
		SELECT COUNT(*)
		FROM EDI_MASTER_DAMO A WITH(NOLOCK)
		WHERE A.EDI_CODE IN (
			SELECT EDI_CODE FROM EDI_APPROVAL A WITH(NOLOCK)
			WHERE A.APP_CODE = ''' + @EMP_CODE + ''' 
			UNION
			SELECT EDI_CODE FROM EDI_REFERENCE A WITH(NOLOCK)
			WHERE A.REF_CODE = ''' + @EMP_CODE + '''
			UNION
			SELECT EDI_CODE FROM EDI_MASTER_DAMO A WITH(NOLOCK)
			WHERE A.NEW_CODE = ''' + @EMP_CODE + ''' AND A.NEW_DATE >= ''' + @START_DATE + ''' AND A.EDI_STATUS = ''3''
		) AND A.NEW_DATE BETWEEN ''' + @START_DATE + ''' AND ''' + @END_DATE + ''' AND A.EDI_STATUS = ''3'''
	END
	ELSE IF @FLAG = '2'
	BEGIN
		SET @QUERY = '
		WITH DOCUMENTLIST AS
		(
			SELECT
				ROW_NUMBER() OVER (ORDER BY EDI_CODE DESC) AS [ROWNUMBER],
				A.* 
			FROM EDI_MASTER_DAMO A WITH(NOLOCK)
			WHERE A.EDI_CODE IN (
				SELECT EDI_CODE FROM EDI_APPROVAL A WITH(NOLOCK)
				WHERE A.APP_CODE = ''' + @EMP_CODE + '''
				UNION
				SELECT EDI_CODE FROM EDI_REFERENCE A WITH(NOLOCK)
				WHERE A.REF_CODE = ''' + @EMP_CODE + '''
				UNION
				SELECT EDI_CODE FROM EDI_MASTER_DAMO A WITH(NOLOCK)
				WHERE A.NEW_CODE = ''' + @EMP_CODE + ''' AND A.NEW_DATE >= ''' + @START_DATE + ''' AND EDI_STATUS = ''3''
			) AND A.NEW_DATE BETWEEN ''' + @START_DATE + ''' AND ''' + @END_DATE + ''' AND EDI_STATUS = ''3''
		)
		SELECT * FROM DOCUMENTLIST
		WHERE ROWNUMBER BETWEEN ' + CONVERT(VARCHAR(10), (@IPAGE * @PAGESIZE + 1)) + ' AND ' + CONVERT(VARCHAR(10), (@IPAGE * @PAGESIZE + @PAGESIZE)) + ';'
	END

	EXEC (@QUERY)

--	PRINT (@QUERY)

END
GO
