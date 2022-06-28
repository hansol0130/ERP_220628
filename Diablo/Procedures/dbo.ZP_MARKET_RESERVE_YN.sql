USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_MARKET_RESERVE_YN
■ DESCRIPTION					: 참좋은마켓 고객별 상품예약 여부
■ INPUT PARAMETER				: 
	@CUS_NO			INT			: 고객번호
	@PRO_CODE		VARCHAR(20)	: 상품코드
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    : 고객서비스팀 요청사항으로 정회원 마켓 예약은 상품코드 별 1번만 가능하게 처리(추가주문은 유선으로 유도)
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2021-04-20		홍종우			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_MARKET_RESERVE_YN]
	@CUS_NO			INT,
	@PRO_CODE		VARCHAR(20)
AS 
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	
	SELECT COUNT(1)
	FROM RES_MASTER_damo
	WHERE CUS_NO = @CUS_NO
	AND PRO_CODE = @PRO_CODE
	AND RES_STATE IN (0,1,2,3,4) 
	
END
GO
