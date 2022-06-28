USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================

■ USP_NAME					: XP_RES_SND_SMS_SUMMARY_COUNT_SELECT

■ DESCRIPTION				: 회원 문자 수신 LIST_TOTAL COUNT

■ INPUT PARAMETER			: 
	@RES_CODE  VARCHAR(12)	: 상품 코드
	@RCV_NUMBER1 VARCHAR(4)	: 회원 휴대폰 번호1
	@RCV_NUMBER2 VARCHAR(4)	: 회원 휴대폰 번호2
	@RCV_NUMBER3 VARCHAR(4)	: 회원 휴대폰 번호3
■ EXEC						: 
	
	EXEC XP_RES_SND_SMS_SUMMARY_COUNT_SELECT @RES_CODE='RP0906070366',@RCV_NUMBER1='011',@RCV_NUMBER2='1234',@RCV_NUMBER3='5678'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-30		이동호			최초생성
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[XP_RES_SND_SMS_SUMMARY_COUNT_SELECT]
(
	@RES_CODE VARCHAR(12),
	@RCV_NUMBER1 VARCHAR(4),
	@RCV_NUMBER2 VARCHAR(4),
	@RCV_NUMBER3 VARCHAR(4)
)
AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @WHERE NVARCHAR(4000), @SORT_STRING VARCHAR(50);

	-- WHERE 조건 만들기

	SET @WHERE =' AND S.RES_CODE='''+@RES_CODE+''' AND S.RCV_NUMBER1 = '''+@RCV_NUMBER1+''' AND S.RCV_NUMBER2 = '''+@RCV_NUMBER2+''' AND S.RCV_NUMBER3 = '''+@RCV_NUMBER3+''''

	SET @SQLSTRING = N'

	-- 전체 마스터 수

	SELECT COUNT(*) AS SMS_CNT

	FROM RES_SND_SMS S WHERE 1=1 ' + @WHERE + '' ;

	SET @PARMDEFINITION = N'
		@RES_CODE VARCHAR(12),		
		@RCV_NUMBER1 VARCHAR(4),
		@RCV_NUMBER2 VARCHAR(4),
		@RCV_NUMBER3 VARCHAR(4) ';

	PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@RES_CODE,
		@RCV_NUMBER1,
		@RCV_NUMBER2,
		@RCV_NUMBER3 ;		
END

GO
