USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김성호
-- Create date: 2011-6-2
-- Description:	해당 조건의 검색 순번을 가져온다
-- History 
-- 2011-06-01 : 최초생성
-- 2011-08-10 : 임시테이블 VGLog DB로 수정
-- 2011-11-08 : 사용유무가 Y로 된 검색만 사용
-- 2012-03-02 : WITH(NOLOCK) 추가 	
-- =============================================
CREATE PROCEDURE [dbo].[SP_HTL_COM_HOTEL_CASHING]
	@CITY_CODE CHAR(3),
	@CHECK_IN DATETIME,
	@CHECK_OUT DATETIME,
	@ROOM_TYPE VARCHAR(10)
AS
BEGIN

-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

DECLARE @SEQ_NO INT
SET @SEQ_NO = 0

SELECT TOP 1 @SEQ_NO = SEQ_NO FROM VGLog.dbo.HTL_TMP_PRICE_MASTER WITH(NOLOCK)
WHERE CITY_CODE = @CITY_CODE AND CHECK_IN = @CHECK_IN AND CHECK_OUT = @CHECK_OUT
	AND ROOM_TYPE = @ROOM_TYPE AND NEW_DATE >= DATEADD(MINUTE, -10, GETDATE()) AND USE_YN = 'Y' --DATEADD(HOUR, -1, GETDATE())
ORDER BY NEW_DATE DESC

-- 검색수 카운터 증가
IF @SEQ_NO > 0
	UPDATE VGLog.dbo.HTL_TMP_PRICE_MASTER SET SEARCH_COUNT = (SEARCH_COUNT + 1) WHERE SEQ_NO = @SEQ_NO

SELECT @SEQ_NO

END
GO
