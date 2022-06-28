USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Server					: 110.11.22.90
■ Database					: DIABLO
■ USP_Name					: SP_RES_ALT_STATE_UPDATE 
■ Description				: 국내여행 제휴업체 예약상태 변경
■ Input Parameter			:                  
		@ALT_RES_CODE		: 제휴업체 예약 코드
		@RES_STATE			: 예약상태
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC SP_RES_ALT_STATE_UPDATE  
■ Author					: 임형민  
■ Date						: 2010-06-15 
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2010-06-15       임형민			최초생성  
-------------------------------------------------------------------------------------------------*/ 

CREATE PROC [dbo].[SP_RES_ALT_STATE_UPDATE]
(
	@ALT_RES_CODE				VARCHAR(20),
	@RES_STATE					INT,
	@NEW_CODE					INT
)

AS

	BEGIN
		DECLARE @RES_CODE CHAR(12)
		
		-- 제휴업체 예약 매칭 테이블에서 제휴업체 예약번호로 예약번호를 가져온다.
		SELECT @RES_CODE = RES_CODE
		FROM DBO.RES_ALT_MATCHING
		WHERE ALT_RES_CODE = @ALT_RES_CODE
		
		-- 제휴업체 예약 매칭 테이블에서 가져온 예약번호로 예약마스터 테이블의 예약상태를 변경한다.
		UPDATE DBO.RES_MASTER_DAMO
			SET RES_STATE = @RES_STATE,
				NEW_CODE = @NEW_CODE,
				NEW_DATE = GETDATE()
		WHERE RES_CODE = @RES_CODE
	END
GO
