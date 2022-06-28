USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_RES_SND_SMS_SELECT_LIST
■ DESCRIPTION				: 회원 문자 수신 LIST
■ INPUT PARAMETER			: 
	@PAGE_INDEX  INT		: 현재 페이지
	@PAGE_SIZE  INT			: 한 페이지 표시 게시물 수	
	@RCV_NUMBER1 VARCHAR(4)	: 회원 휴대폰 번호1
	@RCV_NUMBER2 VARCHAR(4)	: 회원 휴대폰 번호2
	@RCV_NUMBER3 VARCHAR(4)	: 회원 휴대폰 번호3
	@RES_CODE VARCHAR(12)		: 예약코드
■ OUTPUT PARAMETER			: 
	@TOTAL_COUNT INT OUTPUT	: 총 리스트 카운트         
■ EXEC						: 
	DECLARE @PAGE_INDEX INT,
	@PAGE_SIZE  INT,
	@RCV_NUMBER1 VARCHAR(4),
	@RCV_NUMBER2 VARCHAR(4),
	@RCV_NUMBER3 VARCHAR(4),
	@RES_CODE	 CHAR(12),
	@TOTAL_COUNT INT 
	SELECT @PAGE_INDEX=1,@PAGE_SIZE=10, @RCV_NUMBER1='010',@RCV_NUMBER2='4452',@RCV_NUMBER3='2280', @RES_CODE='4564564'
	exec XP_RES_SND_SMS_SELECT_LIST @page_index, @page_size, @RCV_NUMBER1, @RCV_NUMBER2, @RCV_NUMBER3, @RES_CODE, @total_count output
	SELECT @TOTAL_COUNT;
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-30		이동호			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_RES_SND_SMS_SELECT_LIST]
(
	@PAGE_INDEX  INT,
	@PAGE_SIZE  INT,
	@RCV_NUMBER1 VARCHAR(4),
	@RCV_NUMBER2 VARCHAR(4),
	@RCV_NUMBER3 VARCHAR(4),
	@RES_CODE CHAR(12),
	@TOTAL_COUNT INT OUTPUT
)
AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @WHERE NVARCHAR(4000), @SORT_STRING VARCHAR(50);

	-- WHERE 조건 만들기
	SET @WHERE =' AND S.RCV_NUMBER1 = '''+@RCV_NUMBER1+''' AND S.RCV_NUMBER2 = '''+@RCV_NUMBER2+''' AND S.RCV_NUMBER3 = '''+@RCV_NUMBER3+''' AND S.RES_CODE = '''+@RES_CODE+''' '

	SET @SQLSTRING = N'
	-- 전체 마스터 수
	SELECT @TOTAL_COUNT = COUNT(*)
	FROM RES_SND_SMS S WHERE 1=1 ' + @WHERE + ' ;

	WITH LIST AS
	(
		SELECT		
			S.SND_NO,
			S.SND_TYPE,
			S.SND_NUMBER,
			S.BODY,
			S.SND_RESULT,
			S.RCV_NUMBER1,
			S.RCV_NUMBER2,
			S.RCV_NUMBER3,
			S.RCV_NAME,
			S.NEW_CODE,
			S.NEW_DATE,
			S.SND_DATE,
			S.RES_CODE,
			DBO.XN_COM_GET_EMP_NAME(S.NEW_CODE) AS NEW_NAME
		FROM RES_SND_SMS S WITH(NOLOCK)
		WHERE 1=1 ' + @WHERE + ' 
		ORDER BY S.SND_DATE DESC 
		OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
		ROWS ONLY
	)

		SELECT 
			S.SND_NO,
			S.SND_TYPE,
			S.SND_NUMBER,
			S.BODY,
			S.SND_RESULT,
			S.RCV_NUMBER1,
			S.RCV_NUMBER2,
			S.RCV_NUMBER3,
			S.RCV_NAME,
			S.NEW_CODE,
			S.NEW_DATE,
			S.SND_DATE,
			S.RES_CODE,
			DBO.XN_COM_GET_EMP_NAME(S.NEW_CODE) AS NEW_NAME
		FROM LIST S WITH(NOLOCK) 
		WHERE 1=1 ' + @WHERE + ''

	SET @PARMDEFINITION = N'
		@PAGE_INDEX INT,
		@PAGE_SIZE INT,
		@RCV_NUMBER1 VARCHAR(4),
		@RCV_NUMBER2 VARCHAR(4),
		@RCV_NUMBER3 VARCHAR(4),
		@RES_CODE CHAR(12),
		@TOTAL_COUNT INT OUTPUT';

	PRINT @SQLSTRING

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@PAGE_INDEX,
		@PAGE_SIZE,
		@RCV_NUMBER1,
		@RCV_NUMBER2,
		@RCV_NUMBER3,
		@RES_CODE,
		@TOTAL_COUNT OUTPUT;		
END

GO
