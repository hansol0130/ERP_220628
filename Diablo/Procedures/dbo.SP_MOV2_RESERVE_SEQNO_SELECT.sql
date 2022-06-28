USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_RESERVE_SEQNO_SELECT
■ DESCRIPTION				: 검색_예약자순번
■ INPUT PARAMETER			: RES_CODE, CUS_NO
■ EXEC						: 
    -- SP_MOV2_RESERVE_SEQNO_SELECT 'RP1703032908', 5095152		-- 예약(RP1703032908) 시작일, 종료일, 여행일수

■ MEMO						: 예약자 순번정보를 가져온다.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-05-26		오준욱(IBSOLUTION)		최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_RESERVE_SEQNO_SELECT]
	@RES_CODE		VARCHAR(20),
	@CUS_NO			INT
AS
BEGIN
	SELECT A.SEQ_NO FROM RES_CUSTOMER_damo A WITH (NOLOCK) 
	WHERE A.RES_CODE = @RES_CODE AND A.CUS_NO = @CUS_NO
END           



GO
