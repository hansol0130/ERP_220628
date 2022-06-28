USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ Server					: 211.115.202.203
■ Database					: DIABLO
■ Function_Name				: FN_RES_IS_TOURLIST
■ Description				: 여행자계약서 작성 상태    
■ Input Parameter			:                  
		@RES_CODE			: 예약코드  
■ Select					: SELECT DBO.FN_RES_IS_TOURLIST('RP1009240422')
■ Author					: 이규식  
■ Date						: 2010-02-02  
■ Memo						: 0 - 계약서 미작성
							  1 - 계약서 미발송
							  2 - 계약서 발송
							  3 - 계약서 동의
							  4 - 마이페이지 동의
------------------------------------------------------------------------------------------------------------------
■ Change History                   
------------------------------------------------------------------------------------------------------------------
   Date				Author			Description           
------------------------------------------------------------------------------------------------------------------
			        이규식			최초생성
   2010-09-24		임형민			수정 (메일 미발송 시에도 'RES_CONTRACT' 테이블에 'RSV_DATE'값이 있다면 수신.
================================================================================================================*/ 

CREATE FUNCTION [dbo].[FN_RES_IS_TOURLIST]
(
	@RES_CODE VARCHAR(20)
)

RETURNS CHAR(1)

AS

	BEGIN
		DECLARE @CREATE_YN CHAR(1), @SAND_YN CHAR(1), @CFM_YN CHAR(1), @STATE CHAR(1) 
		DECLARE @NEW_DATE SMALLDATETIME, @RSV_DATE SMALLDATETIME 

		SELECT @CREATE_YN = (CASE COUNT(RES_CODE) WHEN 0 THEN 'N' ELSE 'Y' END)
		FROM RES_CONTRACT WITH(NOLOCK) 
		WHERE RES_CODE = @RES_CODE

		IF (@CREATE_YN = 'Y')
		BEGIN
			SELECT TOP 1 @CFM_YN = CFM_YN,
						 @NEW_DATE = NEW_DATE,
						 @RSV_DATE = RSV_DATE
			FROM RES_CONTRACT WITH(NOLOCK) 
			WHERE RES_CODE = @RES_CODE 
			ORDER BY RES_CODE, CONTRACT_NO DESC
			
			SELECT @SAND_YN = CASE WHEN @RSV_DATE IS NULL THEN (CASE COUNT(SND_NO) WHEN 0 THEN 'N' ELSE 'Y' END) ELSE 'Y' END
			FROM RES_SND_EMAIL WITH(NOLOCK) 
			WHERE SND_TYPE = 6 
			  AND RES_CODE = @RES_CODE
			  AND @NEW_DATE < NEW_DATE

			IF (@SAND_YN = 'N')
			BEGIN
				IF (@CFM_YN = 'Y')
				BEGIN
					SET @STATE = '4'
				END
				ELSE
				BEGIN
					SET @STATE = '1'	
				END
			END
			ELSE IF (@CFM_YN = 'N')
			BEGIN
				SET @STATE = '2'
			END
			ELSE
			BEGIN
				SET @STATE = '3'
			END
		END
		ELSE
		BEGIN
			SET @STATE = '0'
		END
		
		RETURN (@STATE)
	END

GO
