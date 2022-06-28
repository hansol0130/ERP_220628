USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ Server					: 211.115.202.203
■ Database					: DIABLO
■ USP_Name					: SP_PKG_DETAIL_UPDATE_MONITORING_WRITE
■ Description				: 행사 상세 테이블의 모니터링 작성여부를 수정한다.
■ Input Parameter			:                  
		@PRO_CODE			: 행사코드   
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC SP_PKG_DETAIL_UPDATE_MONITORING_WRITE  
■ Author					: 임형민  
■ Date						: 2010-09-06
■ Memo						: 
------------------------------------------------------------------------------------------------------------------
■ Change History                   
------------------------------------------------------------------------------------------------------------------
   Date				Author			Description           
------------------------------------------------------------------------------------------------------------------
   2010-09-06       임형민			최초생성  
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[SP_PKG_DETAIL_UPDATE_MONITORING_WRITE]
(
	@PRO_CODE				VARCHAR(20)
)
	
AS

	BEGIN
		SET NOCOUNT ON;

		BEGIN TRAN
			BEGIN TRY
				-- 행사 테이블의 모니터링 작성여부를 수정한다.
				UPDATE DBO.PKG_DETAIL 
					SET MONITORING_WRITE_YN = 'Y'
				WHERE PRO_CODE = @PRO_CODE
				
				-- 전체 쿼리 중 이상이 없었다면 COMMIT한다.
				COMMIT TRAN
			END TRY
			BEGIN CATCH
				-- 에러가 발생 했다면 ROLLBACK한다.
				ROLLBACK TRAN
				
				-- TRY~CATCH 구문 중 에러가 발생한다면 에러로그를 출력한다.
				SELECT ERROR_NUMBER() AS ErrorNumber,
					   ERROR_SEVERITY() AS ErrorSeverity,
					   ERROR_STATE() AS ErrorState,
					   ERROR_PROCEDURE() AS ErrorProcedure,
					   ERROR_LINE() AS ErrorLine,
					   ERROR_MESSAGE() AS ErrorMessage
			END CATCH
	END
GO
