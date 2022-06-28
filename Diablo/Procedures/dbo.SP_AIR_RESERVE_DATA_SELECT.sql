USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_AIR_RESERVE_DATA_SELECT
■ DESCRIPTION				: 예약전 관련 파라메터XML 및 항공조회된 XML 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 	
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-07-15		정지용			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_AIR_RESERVE_DATA_SELECT]
(
	@SEQ INT
)

AS  
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT 
		REQUEST_DATA, RESERVE_DATA
	FROM AIR_RESERVE_DATA
	WHERE SEQ = @SEQ
END

GO
