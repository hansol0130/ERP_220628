USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ Server					: 222.122.198.100
■ Database					: DIABLO
■ USP_Name					: SP_WEB_POPUP_LIST  
■ Description				: 웹관리 팝업 리스트
■ Input Parameter			:                  
		@PAGE_COUNT			: 조회할 로우 갯수
		@PAGE_NUMBER		: 현재 페이지 번호
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC SP_WEB_POPUP_LIST 10, 1
■ Author					: 임형민  
■ Date						: 2010-12-10
■ Memo						: 
------------------------------------------------------------------------------------------------------------------
■ Change History                   
------------------------------------------------------------------------------------------------------------------
   Date				Author			Description           
------------------------------------------------------------------------------------------------------------------
   2010-12-10       임형민			최초생성
   2011-11-18       김현진			검색조건 추가
   2012-07-13       박형만			버그수정,PAGE_NUMBER 조정
================================================================================================================*/ 

CREATE PROC [dbo].[SP_WEB_POPUP_LIST]
(
	@POPTITLE				VARCHAR(50),
	@POPISPAUSE				VARCHAR(1),
	@PAGE_COUNT				INT,
	@PAGE_NUMBER			INT
)

AS

	BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	
		DECLARE @START_ROW_NUM INT, @END_ROW_NUM INT

		SET @START_ROW_NUM = @PAGE_NUMBER * @PAGE_COUNT + 1
		SET @END_ROW_NUM =@PAGE_NUMBER * @PAGE_COUNT + @PAGE_COUNT;

		SELECT COUNT(*) AS TOTAL_COUNT
		FROM PUB_POPUP
		WHERE POPTITLE LIKE '%' + @POPTITLE + '%'
			AND CASE @POPISPAUSE WHEN '' THEN @POPISPAUSE ELSE POPISPAUSE END = @POPISPAUSE

		SELECT *
		FROM (
			SELECT ROW_NUMBER() OVER (ORDER BY POPIDX DESC) AS ROW_NUM, *
			FROM PUB_POPUP
			WHERE POPTITLE LIKE '%' + @POPTITLE + '%'
				AND CASE @POPISPAUSE WHEN '' THEN @POPISPAUSE ELSE POPISPAUSE END = @POPISPAUSE
			 )A
		WHERE A.ROW_NUM BETWEEN @START_ROW_NUM AND @END_ROW_NUM
	END


GO
