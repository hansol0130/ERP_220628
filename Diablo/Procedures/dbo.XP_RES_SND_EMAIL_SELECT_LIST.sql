USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================

■ USP_NAME					: XP_RES_SND_EMAIL_SELECT_LIST

■ DESCRIPTION				: 회원 이메일 수신 LIST

■ INPUT PARAMETER			: 

	@PAGE_INDEX  INT		: 현재 페이지

	@PAGE_SIZE  INT			: 한 페이지 표시 게시물 수

	@RCV_EMAIL VARCHAR(50)	: 회원 회원 이메일 주소

	@RES_CODE				: 예약 코드

■ OUTPUT PARAMETER			: 

	@TOTAL_COUNT INT OUTPUT	: 총 리스트 카운트         

■ EXEC						: 

	DECLARE @PAGE_INDEX INT,

	@PAGE_SIZE  INT,

	@RCV_EMAIL VARCHAR(30),

	@RES_CODE CHAR(12),

	@TOTAL_COUNT INT 

	SELECT @PAGE_INDEX=1,@PAGE_SIZE=10,@RCV_EMAIL='timeprids@msn.com', @RES_CODE='RP0905280084'

	exec XP_RES_SND_EMAIL_SELECT_LIST @page_index, @page_size, @RCV_EMAIL, @RES_CODE, @total_count output

	SELECT @TOTAL_COUNT;

■ MEMO						: 

------------------------------------------------------------------------------------------------------------------

■ CHANGE HISTORY                   

------------------------------------------------------------------------------------------------------------------

   DATE				AUTHOR			DESCRIPTION           

------------------------------------------------------------------------------------------------------------------

   2013-05-02		이동호			최초생성

================================================================================================================*/ 



CREATE PROCEDURE [dbo].[XP_RES_SND_EMAIL_SELECT_LIST]

(

	@PAGE_INDEX  INT,

	@PAGE_SIZE  INT,

	@RCV_EMAIL VARCHAR(50),	

	@RES_CODE CHAR(12),

	@TOTAL_COUNT INT OUTPUT

)

AS  

BEGIN



	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED



	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @WHERE NVARCHAR(4000), @SORT_STRING VARCHAR(50);

	

	-- WHERE 조건 만들기

	SET @WHERE =' AND S.RCV_EMAIL = '''+@RCV_EMAIL+''' AND S.RES_CODE = '''+@RES_CODE+''''



	SET @SQLSTRING = N'

	-- 전체 마스터 수

	SELECT @TOTAL_COUNT = COUNT(*)

	FROM RES_SND_EMAIL S WHERE 1=1 ' + @WHERE + ' ;

	

	WITH LIST AS

	(

		SELECT		

			S.SND_NO,

			S.SND_NAME,

			S.SND_EMAIL,

			S.RCV_NAME,

			S.RCV_EMAIL,

			S.CFM_YN,

			S.NEW_DATE,

			S.SND_TYPE,

			S.RES_CODE			

		FROM RES_SND_EMAIL S WITH(NOLOCK)

		WHERE 1=1 ' + @WHERE + ' 

		ORDER BY S.SND_NO DESC 

		OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE

		ROWS ONLY

	)

		SELECT 

			S.SND_NO,

			S.SND_NAME,

			S.SND_EMAIL,

			S.RCV_NAME,

			S.RCV_EMAIL,

			S.CFM_YN,

			S.NEW_DATE,

			S.SND_TYPE,

			S.RES_CODE		

		FROM LIST S WITH(NOLOCK) 

		WHERE 1=1 ' + @WHERE + ''

	

	SET @PARMDEFINITION = N'

		@PAGE_INDEX INT,

		@PAGE_SIZE INT,

		@RCV_EMAIL VARCHAR(50),

		@RES_CODE CHAR(12),

		@TOTAL_COUNT INT OUTPUT';

	

	PRINT @SQLSTRING

		

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,

		@PAGE_INDEX,

		@PAGE_SIZE,

		@RCV_EMAIL,

		@RES_CODE,

		@TOTAL_COUNT OUTPUT;		

END

GO
