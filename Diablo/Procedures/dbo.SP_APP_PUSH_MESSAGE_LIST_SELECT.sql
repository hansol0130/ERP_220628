USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*================================================================================================================
■ USP_NAME					: SP_APP_PUSH_MESSAGE_LIST_SELECT
■ DESCRIPTION				: 발송된 푸시알림메세지 목록 PAGING
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
exec SP_APP_PUSH_MESSAGE_LIST_SELECT @PAGE_INDEX=0,@PAGE_SIZE=10,@START_DATE=N'2018-11-20',@END_DATE=N'2018-11-27',@OS_TYPE=N'ALL',@TEMPLATE_TYPE=N'A',@GENDER_TYPE=N'A',@AGE_TYPE=N'AA',@RES_HISTORY=N'AA',@TITLE=N'',@FLAG=N'L',@SEND_TYPE = ''
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-11-19	    김남훈	     	최초생성
   2020-07-06		홍종우			푸시(알림) 수정
   
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_APP_PUSH_MESSAGE_LIST_SELECT]
	@FLAG			char(1),
	@PAGE_SIZE		INT,
	@PAGE_INDEX		INT,
	@START_DATE      VARCHAR(10),
	@END_DATE        VARCHAR(10),
	@OS_TYPE         VARCHAR(10),
	@TEMPLATE_TYPE  VARCHAR(10),
	@GENDER_TYPE  VARCHAR(10),
	@AGE_TYPE  VARCHAR(20),
	@RES_HISTORY  VARCHAR(10),
	@TITLE  VARCHAR(100),
	@SEND_TYPE  VARCHAR(10),
	@RECV_CODE_TYPE  VARCHAR(3),
	@RECV_CODE  VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @SQLSTRING NVARCHAR(4000), @SQLORDER NVARCHAR(100), @PARMDEFINITION NVARCHAR(1000),	@FROM INT,	@TO INT, @WHERE NVARCHAR(1000);
	SET @SQLSTRING = '';
	SET @WHERE = '';
	
	SET @FROM = @PAGE_INDEX * @PAGE_SIZE + 1;
	SET @TO = @PAGE_INDEX * @PAGE_SIZE + @PAGE_SIZE;	
	
	--OS TYPE SET
	IF(@OS_TYPE <> 'ALL')
	BEGIN
		SET @WHERE += ' AND A.RECV_OS_TYPE = ''' + @OS_TYPE + ''''
	END

	IF(@TEMPLATE_TYPE <> 'A')
	BEGIN
		SET @WHERE += ' AND B.TEMPLATE_TYPE = ''' + @TEMPLATE_TYPE + ''''
	END

	IF(@GENDER_TYPE <> 'A')
	BEGIN
		SET @WHERE += ' AND A.RECV_GENDER = ''' + @GENDER_TYPE + ''''
	END

	IF(@AGE_TYPE <> 'AA')
	BEGIN
		SET @WHERE += ' AND A.RECV_AGE = ''' + @AGE_TYPE + ''''
	END

	IF(@RES_HISTORY <> 'AA')
	BEGIN
		SET @WHERE += ' AND A.RES_HISTORY = ''' + @RES_HISTORY + ''''
	END

	IF(LEN(@TITLE) > 0)
	BEGIN
		SET @WHERE += ' AND B.TITLE like ''%' + @TITLE + '%'''
	END

	IF(@SEND_TYPE <> 'A')
	BEGIN
		SET @WHERE += ' AND A.SEND_TYPE = ''' + @SEND_TYPE + ''''
	END
	
	IF(@RECV_CODE_TYPE <> 'A')
	BEGIN
		SET @WHERE += ' AND A.RECV_CODE_TYPE = ''' + @RECV_CODE_TYPE + ''''
		SET @WHERE += ' AND A.RECV_CODE LIKE ''%' + @RECV_CODE + '%'''
	END

	PRINT @WHERE

	IF @FLAG = 'C'
	BEGIN
		SET @SQLSTRING = N'
		SELECT COUNT(*) 
		FROM 
		APP_PUSH_SEND_HISTORY A, 
		APP_PUSH_MSG_INFO B with (nolock)
		WHERE A.MSG_NO = B.MSG_NO 
		AND A.RES_TIME BETWEEN @START_DATE AND @END_DATE'
		+ @WHERE
	END
	ELSE IF @FLAG = 'L'
	BEGIN
		SET @SQLSTRING = N'
		SELECT * FROM
		(
		    SELECT *,ROW_NUMBER() OVER (ORDER BY SEND_SEQ DESC) AS NUM FROM
			( 
				SELECT A.*, 
				B.TEMPLATE_TYPE, 
				B.TITLE,
				B.MSG,
				B.MSG_DETAIL,
				B.RECV_DATE,
				B.IMAGE_URL,
				B.LINK_URL
				FROM 
				APP_PUSH_SEND_HISTORY A, 
				APP_PUSH_MSG_INFO B with (nolock)
				WHERE A.MSG_NO = B.MSG_NO 
				AND A.RES_TIME BETWEEN @START_DATE AND @END_DATE
				' + @WHERE + '
			) B1
		) A1 
		WHERE A1.NUM BETWEEN @FROM AND @TO
		';

	END
	SET @PARMDEFINITION=N'@FROM INT,@TO INT, @START_DATE VARCHAR(10), @END_DATE VARCHAR(10)';		
	EXEC SP_EXECUTESQL @SQLSTRING,@PARMDEFINITION, @FROM, @TO, @START_DATE, @END_DATE;
END



GO
