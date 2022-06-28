USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_APP_RES_MESSAGE_LIST_SELECT
■ DESCRIPTION				: 발송예약된 알림메세지 목록 PAGING
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	-- MSG_METHOD : 2 = 발송예정목록 (1회성), 3 = 정기발송목록
	-- 발송예정목록 : 
	-- EXEC SP_APP_RES_MESSAGE_LIST_SELECT 'L', 2, 10, 0, '', '', 3, '', '', '', '', ''

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-11-22		오준욱(IBK)		최초생성
   2017-02-01		오준욱(IBK)		
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_APP_RES_MESSAGE_LIST_SELECT]
	@FLAG			char(1),
	@MSG_METHOD			INT,
	@PAGE_SIZE		INT,
	@PAGE_INDEX		INT,	
	@PRO_CODE		VARCHAR(20),
	@RES_CODE		VARCHAR(12),
	@APP_TARGET		INT,
	@TITLE			VARCHAR(100),
	@KOR_NAME		varchar(20),
	@START_DATE		VARCHAR(12),
	@END_DATE		VARCHAR(20),
	@ORDER			VARCHAR(100)
	
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @SQLSTRING NVARCHAR(4000), @SQLORDER NVARCHAR(100), @PARMDEFINITION NVARCHAR(1000),	@FROM INT,	@TO INT;
	SET @SQLSTRING = '';
	
	SET @FROM = @PAGE_INDEX * @PAGE_SIZE + 1;
	SET @TO = @PAGE_INDEX * @PAGE_SIZE + @PAGE_SIZE;

	IF (@RES_CODE <> '')
	BEGIN
		SET @SQLSTRING = @SQLSTRING + '
				AND A.RES_CODE LIKE ''%'' + @RES_CODE + ''%'' ';
	END
	
	IF (@PRO_CODE <> '')
	BEGIN
		SET @SQLSTRING = @SQLSTRING + '
				AND A.PRO_CODE LIKE ''%'' + @PRO_CODE + ''%'' ';
	END					

	IF (@TITLE <> '')
	BEGIN
		SET @SQLSTRING = @SQLSTRING + '
				AND A.TITLE LIKE ''%'' + @TITLE + ''%'''
	END					
	
	IF (@KOR_NAME <> '')
	BEGIN
		SET @SQLSTRING = @SQLSTRING + '
				AND D.KOR_NAME LIKE ''%'' + @KOR_NAME + ''%'''
	END
	
	IF(@START_DATE <> '' AND @START_DATE IS NOT NULL)
	BEGIN
		SET @SQLSTRING = @SQLSTRING + ' AND A.RESERVE_TIME >= CONVERT(DATETIME,@START_DATE)'; 
	END 
	
	IF(@END_DATE <> '' AND @END_DATE IS NOT NULL)
	BEGIN
		SET @END_DATE = @END_DATE + ' 23:59:59';
		SET @SQLSTRING = @SQLSTRING + ' AND A.RESERVE_TIME <= CONVERT(DATETIME,@END_DATE)'; 
	END
	
	IF (@ORDER <> '')
	BEGIN
		SET @SQLORDER = ' B1.' + @ORDER;
	END
	ELSE
	BEGIN
		SET @SQLORDER = ' B1.NEW_DATE DESC ';
	END				
	
	IF @MSG_METHOD = 2
	BEGIN
		SET @SQLSTRING = @SQLSTRING + ' AND A.RESERVE_TIME IS NOT NULL'; 
	END
	ELSE IF @MSG_METHOD = 3
	BEGIN
		SET @SQLSTRING = @SQLSTRING + ' AND A.RESERVE_TIME IS NULL'; 
	END	
	
	IF @FLAG = 'C'
	BEGIN
		SET @SQLSTRING = N'
				SELECT COUNT(*) AS COUNT
					FROM APP_RES_MESSAGE A WITH (NOLOCK) 
					LEFT JOIN PKG_DETAIL B WITH (NOLOCK) ON A.PRO_CODE = B.PRO_CODE
					LEFT JOIN RES_MASTER_damo C WITH (NOLOCK) ON A.RES_CODE = C.RES_CODE
					LEFT JOIN EMP_MASTER_damo D WITH (NOLOCK) ON A.NEW_CODE = D.EMP_CODE
				WHERE 1 = 1
					' + @SQLSTRING;
	END
	ELSE IF @FLAG = 'L'
	BEGIN
		SET @SQLSTRING = N'
		SELECT * FROM
		(
		    SELECT *,ROW_NUMBER() OVER (ORDER BY ' + @SQLORDER + ') AS NUM FROM
			( 
				SELECT A.*, B.PRO_NAME, C.RES_NAME, D.KOR_NAME
					FROM APP_RES_MESSAGE A WITH (NOLOCK)  
					LEFT JOIN PKG_DETAIL B WITH (NOLOCK) ON A.PRO_CODE = B.PRO_CODE
					LEFT JOIN RES_MASTER_damo C WITH (NOLOCK) ON A.RES_CODE = C.RES_CODE
					LEFT JOIN EMP_MASTER_damo D WITH (NOLOCK) ON A.NEW_CODE = D.EMP_CODE
				WHERE 1 = 1
					' + @SQLSTRING + '
			) B1
		) A1 
		WHERE A1.NUM BETWEEN @FROM AND @TO
		';

	END
				
	-- SELECT @SQLSTRING
	SET @PARMDEFINITION=N'@FROM INT,@TO INT,@MSG_METHOD INT,@PRO_CODE VARCHAR(20),@RES_CODE VARCHAR(12),@APP_TARGET INT,@TITLE VARCHAR(100),@KOR_NAME VARCHAR(20),@START_DATE VARCHAR(12),@END_DATE VARCHAR(20),@ORDER VARCHAR(100)';
	--PRINT @SQLSTRING + ' ' + @PARMDEFINITION

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @FROM, @TO, @MSG_METHOD, @PRO_CODE, @RES_CODE, @APP_TARGET, @TITLE, @KOR_NAME, @START_DATE, @END_DATE, @ORDER;
END

--EXEC SP_APP_RES_MESSAGE_LIST_SELECT 'C', 2, 10, 0, '', '', 3, '', '', '', '', ''
--EXEC SP_APP_RES_MESSAGE_LIST_SELECT 'L', 3, 10, 0, '', '', 3, '', '', '', '', ''

GO
