USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ Server					: 211.115.202.203
■ Database					: DIABLO
■ USP_Name					: SP_MANAGE_MENU_COPY
■ Description				: 사용자의 메뉴 권한을 복사한다.
■ Input Parameter			:                  
		@FROM_EMP_CODE		: 해당 권한을 갖은 대상자
		@TO_EMP_CODE		: 해당 권한을 받을 대상자
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC SP_MANAGE_MENU_COPY '2010003', '2008013' 
■ Author					: 임형민  
■ Date						: 2010-09-17
■ Memo						: 
------------------------------------------------------------------------------------------------------------------
■ Change History                   
------------------------------------------------------------------------------------------------------------------
   Date				Author			Description           
------------------------------------------------------------------------------------------------------------------
   2010-09-17       임형민			최초생성  
   2011-09-19		박형만			권한복사시 작업자 사번 기록 
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MANAGE_MENU_COPY]
(
	@FROM_EMP_CODE				CHAR(7),
	@TO_EMP_CODE				CHAR(7),
	@NEW_CODE					CHAR(7)
)
	
AS

	BEGIN
		BEGIN TRAN
			BEGIN TRY
				-- '해당 권한을 받을 대상자'의 기존 모든 메뉴 권한을 모두 삭제한다.
				DELETE PUB_GRANT WHERE EMP_CODE = @TO_EMP_CODE
				
				-- '해당 권한을 갖은 대상자'의 모든 메뉴 권한을 '해당 권한을 받을 대상자'에게 복사한다.
				INSERT PUB_GRANT (MENU_GROUP_CODE, MENU_CODE, EMP_CODE, SELECT_YN, INSERT_YN, UPDATE_YN, DELETE_YN, MASTER_YN, NEW_CODE, NEW_DATE)
				SELECT MENU_GROUP_CODE, MENU_CODE, @TO_EMP_CODE, SELECT_YN, INSERT_YN, UPDATE_YN, DELETE_YN, MASTER_YN, @NEW_CODE, GETDATE()
				FROM PUB_GRANT
				WHERE EMP_CODE = @FROM_EMP_CODE
				
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
