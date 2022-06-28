USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_BUS_ROUTE_SELECT
■ DESCRIPTION				: 검색_버스노선정보
■ INPUT PARAMETER			: 
■ EXEC						: 
    -- EXEC SP_MOV2_BUS_ROUTE_SELECT 100100411
■ MEMO						: 버스노선정보
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-12-08		IBSOLUTION			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_BUS_ROUTE_SELECT]
	@ROUTE_ID			VARCHAR(20)
AS
BEGIN
	
	SELECT * 
	FROM
	(
		SELECT ROUTE_ID, ROUTE_NAME, START_NAME, END_NAME, FIRST_BUS_TIME, LAST_BUS_TIME, TERM, 1 AS R_TYPE
		FROM API_BUS_SEL_ROUTE WITH (NOLOCK) 
		UNION 
		SELECT ROUTE_ID, ROUTE_NM AS ROUTE_NAME, ST_STA_NM AS START_NAME, ED_STA_NM AS END_NAME, UP_FIRST_TIME AS FIRST_BUS_TIME, DOWN_LAST_TIME AS LAST_BUS_TIME, NPEEK_ALLOC AS TERM, 2 AS R_TYPE
		FROM API_BUS_GGD_ROUTE WITH (NOLOCK)
	) A
	WHERE A.ROUTE_ID = @ROUTE_ID


END           




GO
