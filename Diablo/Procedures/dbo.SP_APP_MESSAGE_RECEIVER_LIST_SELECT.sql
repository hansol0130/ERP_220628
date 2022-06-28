USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_APP_MESSAGE_RECEIVER_LIST_SELECT
■ DESCRIPTION				: 발송된 알림메세지 수신자 목록 PAGING
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	-- 메세지번호 98361 의 수신자 목록 : 
	-- EXEC SP_APP_MESSAGE_RECEIVER_LIST_SELECT 'L', 10, 0, 98361, ''

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-12-08		오준욱(IBK)		최초생성
   2017-02-01		오준욱(IBK)		
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_APP_MESSAGE_RECEIVER_LIST_SELECT]
	@FLAG			char(1),
	@PAGE_SIZE		INT,
	@PAGE_INDEX		INT,	
	@MSG_SEQ_NO		INT,
	@ORDER			VARCHAR(100)
	
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @SQLSTRING NVARCHAR(4000), @SQLORDER NVARCHAR(100), @PARMDEFINITION NVARCHAR(1000),	@FROM INT,	@TO INT;
	SET @SQLSTRING = '';
	
	SET @FROM = @PAGE_INDEX * @PAGE_SIZE + 1;
	SET @TO = @PAGE_INDEX * @PAGE_SIZE + @PAGE_SIZE;
	
	IF (@MSG_SEQ_NO <> '')
	BEGIN
		SET @SQLSTRING = @SQLSTRING + '
				AND A.MSG_SEQ_NO = @MSG_SEQ_NO';
	END						

	IF (@ORDER <> '')
	BEGIN
		SET @SQLORDER = ' B1.' + @ORDER;
	END
	ELSE
	BEGIN
		SET @SQLORDER = ' B1.RCV_DATE DESC ';
	END				
	
	IF @FLAG = 'C'
	BEGIN
		SET @SQLSTRING = N'
				SELECT 
				   COUNT(*) AS COUNT
				FROM
				   APP_RECEIVE A WITH (NOLOCK)
				   LEFT JOIN CUS_CUSTOMER_damo B WITH (NOLOCK) ON 
					   A.CUS_NO = B.CUS_NO
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
				SELECT 
				   B.CUS_NAME,A.OS_TYPE,A.RCV_DATE,RCV_TYPE,A.MSG_SEQ_NO, A.RES_CODE 
				FROM
				   APP_RECEIVE A WITH (NOLOCK)
				   LEFT JOIN CUS_CUSTOMER_damo B WITH (NOLOCK) ON 
					   A.CUS_NO = B.CUS_NO
				WHERE 1 = 1
					' + @SQLSTRING + '
					
			) B1
		) A1 
		WHERE A1.NUM BETWEEN @FROM AND @TO
		';

	END
				
	-- SELECT @SQLSTRING
	SET @PARMDEFINITION=N'@FROM INT,@TO INT,@MSG_SEQ_NO INT,@ORDER VARCHAR(100)';
	--PRINT @SQLSTRING + ' ' + @PARMDEFINITION

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @FROM, @TO, @MSG_SEQ_NO, @ORDER;
END

--EXEC SP_APP_MESSAGE_RECEIVER_LIST_SELECT 'L', 10, 0, 98361, ''
--EXEC SP_APP_MESSAGE_RECEIVER_LIST_SELECT 'C', 10, 0, 98361, ''

GO
