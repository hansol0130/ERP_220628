USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================

■ USP_NAME					: XP_RES_SND_EMAIL_SUMMARY_COUNT_SELECT

■ DESCRIPTION				: 회원 이메일 수신 LIST_TOTAL COUNT

■ INPUT PARAMETER			: 
	@RES_CODE  VARCHAR(12)	: 상품 코드
	@RCV_EMAIL VARCHAR(4)	: 회원 이메일 주소
■ EXEC						: 
	
	EXEC XP_RES_SND_EMAIL_SUMMARY_COUNT_SELECT @RES_CODE='RP0906070366',@RCV_EMAIL='011'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-30		이동호			최초생성
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[XP_RES_SND_EMAIL_SUMMARY_COUNT_SELECT]
(
	@RES_CODE VARCHAR(12),
	@RCV_EMAIL VARCHAR(50)
)
AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @WHERE NVARCHAR(4000), @SORT_STRING VARCHAR(50);

	-- WHERE 조건 만들기

	SET @WHERE =' AND S.RES_CODE='''+@RES_CODE+''' AND S.RCV_EMAIL = '''+@RCV_EMAIL+''''

	SET @SQLSTRING = N'

	-- 전체 마스터 수

	SELECT COUNT(*) AS EMAIL_CNT

	FROM RES_SND_EMAIL S WHERE 1=1 ' + @WHERE + '' ;

	SET @PARMDEFINITION = N'
		@RES_CODE VARCHAR(12),		
		@RCV_EMAIL VARCHAR(50) ';

	PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@RES_CODE,
		@RCV_EMAIL ;		
END

GO
