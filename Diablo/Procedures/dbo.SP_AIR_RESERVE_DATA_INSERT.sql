USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_AIR_RESERVE_DATA_INSERT
■ DESCRIPTION				: 예약전 관련 파라메터XML 및 항공조회된 XML 저장
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-07-21		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_AIR_RESERVE_DATA_INSERT]
	@REQUEST_DATA XML,
	@RESERVE_DATA XML,
	@CUS_NO INT
AS 
BEGIN	
	SET NOCOUNT OFF;
	
	INSERT INTO AIR_RESERVE_DATA ( REQUEST_DATA, RESERVE_DATA, CUS_NO, NEW_DATE)
	VALUES( @REQUEST_DATA, @RESERVE_DATA, @CUS_NO, GETDATE() )

	SELECT @@IDENTITY
END

GO
