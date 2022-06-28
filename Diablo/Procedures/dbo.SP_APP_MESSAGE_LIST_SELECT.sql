USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: SP_APP_MESSAGE_LIST_SELECT
■ DESCRIPTION				: 발송된 알림메세지 목록 PAGING
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	-- RP1612072674 예약코드로 검색 : 
	-- EXEC SP_APP_MESSAGE_LIST_SELECT 'L', 10, 0, 0, '', 'RP1612072674','', '', '', '', 'NEW_DATE DESC'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-07-05		IBSOLUTION		최초생성
   2016-08-08		IBSOLUTION		검색 값 수정
   2017-02-01		IBSOLUTION		행사명 대신 예약코드로 검색변경
   2017-06-26		IBSOLUTION		전체 알림수, 발송수 추가(발송에러도 포함)
   2018-01-25		IBSOLUTION		수신수 0 인경우 제외
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_APP_MESSAGE_LIST_SELECT]
	@FLAG			char(1),
	@PAGE_SIZE		int	= 10,
	@PAGE_INDEX		int = 0,	
	@MSG_TYPE		INT,
	@PRO_CODE		VARCHAR(20),
	@RES_CODE		VARCHAR(12),
	@PRO_NAME		NVARCHAR(100),
	@NEW_CODE   	VARCHAR(7),
	@START_DATE		VARCHAR(12),
	@END_DATE		VARCHAR(20),
	@ORDER			VARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @SQLSTRING NVARCHAR(4000), @SQLORDER NVARCHAR(1000), @SQLWHERE NVARCHAR(1000), @PARMDEFINITION NVARCHAR(1000),	@FROM INT,	@TO INT;
	SET @SQLSTRING = '';
	SET @SQLWHERE = '';

	SET @FROM = @PAGE_INDEX * @PAGE_SIZE + 1;
	SET @TO = @PAGE_INDEX * @PAGE_SIZE + @PAGE_SIZE;

	IF (@PRO_NAME <> '')
	BEGIN
		SET @SQLSTRING = @SQLSTRING + '
				AND A.PRO_NAME LIKE ''%'' + @PRO_NAME + ''%'''
	END
	IF (@PRO_CODE <> '' AND @PRO_CODE IS NOT NULL)
	BEGIN
		SET @SQLSTRING = @SQLSTRING + ' 
				AND A.PRO_CODE = @PRO_CODE';
	END

	IF (@RES_CODE <> '' AND @RES_CODE IS NOT NULL)
	BEGIN
		SET @SQLWHERE = ' 
				AND A.MSG_SEQ_NO IN ( SELECT DISTINCT MSG_SEQ_NO FROM APP_RECEIVE WITH (NOLOCK) WHERE RES_CODE = @RES_CODE ) '
	END	

	IF (@NEW_CODE <> '' AND @NEW_CODE IS NOT NULL)
	BEGIN
		SET @SQLSTRING = @SQLSTRING + '
				AND A.NEW_CODE = @NEW_CODE'
	END					
	IF (@MSG_TYPE <> '' AND @MSG_TYPE IS NOT NULL)
	BEGIN
		SET @SQLSTRING = @SQLSTRING + '
				AND A.MSG_TYPE = @MSG_TYPE'
	END	
	IF(@START_DATE <> '' AND @START_DATE IS NOT NULL)
	BEGIN
		SET @SQLSTRING = @SQLSTRING + ' AND A.NEW_DATE >= CONVERT(DATETIME,@START_DATE)'; 
	END 
	IF(@END_DATE <> '' AND @END_DATE IS NOT NULL)
	BEGIN
		SET @END_DATE = @END_DATE + ' 23:59:59';
		SET @SQLSTRING = @SQLSTRING + ' AND A.NEW_DATE <= CONVERT(DATETIME,@END_DATE)'; 
	END		

	IF (@ORDER <> '')
	BEGIN
		SET @SQLORDER = ' ' + @ORDER;
	END
	ELSE
	BEGIN
		SET @SQLORDER = ' A.NEW_DATE DESC ';
	END				


	-- 검색된 데이타의 카운트를 돌려준다.
	IF @FLAG = 'C'
	BEGIN
			SET @SQLSTRING = N'
				SELECT 
					COUNT(*) AS COUNT
				FROM
					APP_MESSAGE_damo A
				WHERE 1 = 1
					 --KOR_TITLE LIKE ''%'' + ISNULL(@TITLE, '''') + ''%''
					' + @SQLSTRING;
	END
	-- 검색된 데이타의 리스트를 돌려준다.
	ELSE IF @FLAG = 'L'
	BEGIN
		SET @SQLSTRING = N'
				SELECT
					*
				FROM
				(
       				SELECT 
						*,ROW_NUMBER() OVER (ORDER BY ' + @SQLORDER + ') AS NUM
					FROM
					( 
				 		SELECT 
							A.MSG_TYPE,A.MSG_SEQ_NO,A.REMARK,A.RES_CODE,A.PRO_CODE,A.TITLE,A.NEW_DATE,
							(SELECT COUNT(*) AS CNT_RCV FROM APP_RECEIVE A1 WITH (NOLOCK) WHERE A1.MSG_SEQ_NO = A.MSG_SEQ_NO AND A1.RCV_TYPE = 1) AS CNT_RCV,
							(SELECT COUNT(*) AS CNT_RCV FROM APP_RECEIVE A1 WITH (NOLOCK) WHERE A1.MSG_SEQ_NO = A.MSG_SEQ_NO AND A1.RCV_TYPE = 0) AS CNT_SEND,
							(SELECT COUNT(MSG_SEQ_NO) AS TOT_MSG FROM APP_RECEIVE A2 WITH (NOLOCK) WHERE A2.MSG_SEQ_NO = A.MSG_SEQ_NO ) AS TOT_MSG,
							D.PRO_NAME
						FROM
							APP_MESSAGE_damo A WITH (NOLOCK)
							LEFT JOIN PKG_DETAIL D WITH (NOLOCK)
								ON A.PRO_CODE = D.PRO_CODE	
					)A
					WHERE A.TOT_MSG > 0
					' + @SQLWHERE +'					
					' + @SQLSTRING +'					
				 ) AA
				 WHERE AA.NUM BETWEEN @FROM AND @TO
		';
	END
	--SELECT @SQLSTRING
	SET @PARMDEFINITION=N'@FROM INT,@TO INT,@MSG_TYPE INT,@PRO_CODE VARCHAR(20),@RES_CODE VARCHAR(12),@PRO_NAME NVARCHAR(100),@NEW_CODE VARCHAR(7),@START_DATE VARCHAR(12),@END_DATE VARCHAR(20),@ORDER VARCHAR(100)';
	--PRINT @SQLSTRING + ' ' + @PARMDEFINITION
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @FROM, @TO, @MSG_TYPE, @PRO_CODE, @RES_CODE, @PRO_NAME, @NEW_CODE, @START_DATE, @END_DATE, @ORDER;
END

-- EXEC SP_APP_MESSAGE_LIST_SELECT 'L', 10, 0, 0, '', 'RP1612072674','', '', '', '', 'NEW_DATE DESC'
-- EXEC SP_APP_MESSAGE_LIST_SELECT 'L', 10, 0, 0, '', '','', '', '2016-12-22', '2016-12-22 23:59:59', 'NEW_DATE DESC'


GO
