USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_RESERVE_SCHEDULE_SELECT
■ DESCRIPTION				: 검색_예약일정정보
■ INPUT PARAMETER			: RES_CODE
■ EXEC						: 
    -- SP_MOV2_RESERVE_SCHEDULE_SELECT 'RP1703032908'		-- 예약(RP1703032908) 시작일, 종료일, 여행일수

■ MEMO						: 예약정보를 사용하여 시작일,종료일,여행일수를 가져온다.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-05-26		오준욱(IBSOLUTION)		최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_RESERVE_SCHEDULE_SELECT]
	@RES_CODE		VARCHAR(20)
AS
BEGIN
	SELECT B.DEP_DATE, B.ARR_DATE, B.TOUR_DAY 
		FROM RES_MASTER_damo A WITH (NOLOCK)
			INNER JOIN PKG_DETAIL B
			ON A.PRO_CODE = B.PRO_CODE
		WHERE RES_CODE = @RES_CODE	
END           



GO
