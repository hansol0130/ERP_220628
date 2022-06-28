USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Server					: 211.115.202.230
■ Database					: DIABLO
■ USP_Name					: SP_EMP_ACC_LIST  
■ Description				: 팀별 계좌관리 추가, 수정, 삭제
■ Input Parameter			: 
		@ACC_SEQ			: 
		@TEAM_CODE			: 팀 코드
		@ACC_NAME			: 
		@ACC_HOLDER			: 
		@BANK_NAME			: 
		@ACC_NUM			: 
		@SORT_NUM			: 
		@NEW_CODE			: 
		@EDT_CODE			: 
		@CUD				: 	
■ Output Parameter			: 
		@RTN_ACC_SEQ		:
■ Output Value				:                 
■ Exec						: EXEC SP_EMP_ACC_CUD  
■ Author					: 임형민  
■ Date						: 2010-08-26 
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2010-08-26       임형민			최초생성  
-------------------------------------------------------------------------------------------------*/ 

CREATE PROC [dbo].[SP_EMP_ACC_CUD]
(
	@ACC_SEQ						INT														= 0,
	@TEAM_CODE						CHAR(3)													= '',
	@ACC_NAME						VARCHAR(1000)											= '',
	@ACC_HOLDER						VARCHAR(40)												= '',
	@BANK_NAME						VARCHAR(40)												= '',
	@ACC_NUM						VARCHAR(20)												= '',
	@SORT_NUM						INT														= 0,
	@NEW_CODE						CHAR(7)													= '',
	@EDT_CODE						CHAR(7)													= '',
	@CUD							CHAR(1),
	@RTN_ACC_SEQ					INT							OUTPUT
)

AS

	BEGIN
		IF @CUD = 'C'
		BEGIN
			BEGIN TRAN
				BEGIN TRY
					-- 팀 관리계좌를 추가 한다.
					INSERT INTO DBO.EMP_TEAM_ACC_DAMO (TEAM_CODE, ACC_NAME, ACC_HOLDER, BANK_NAME, SORT_NUM, NEW_CODE, NEW_DATE, SEC_ACC_NUM)
					VALUES (@TEAM_CODE, @ACC_NAME, @ACC_HOLDER, @BANK_NAME, @SORT_NUM, @NEW_CODE, GETDATE(), damo.dbo.enc_varchar('DIABLO','dbo.EMP_TEAM_ACC','ACC_NUM', @ACC_NUM))
					
					SET @RTN_ACC_SEQ = @@IDENTITY
					
					--전체 쿼리 중 이상이 없었다면 COMMIT한다.
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
						   ERROR_MESSAGE() AS ErrorMessage,
						   '추가 중 에러 발생' AS ErrorEtc
				END CATCH	
		END
		ELSE IF @CUD = 'U' 
		BEGIN
			BEGIN TRAN
				BEGIN TRY
					-- 팀 관리계좌를 수정 한다.
					UPDATE DBO.EMP_TEAM_ACC_DAMO
						SET ACC_NAME = @ACC_NAME,
							ACC_HOLDER = @ACC_HOLDER,
							BANK_NAME = @BANK_NAME,
							SORT_NUM = @SORT_NUM,
							EDT_CODE = @EDT_CODE,
							EDT_DATE = GETDATE(),
							SEC_ACC_NUM = damo.dbo.enc_varchar('DIABLO','dbo.EMP_TEAM_ACC','ACC_NUM', @ACC_NUM)
					WHERE ACC_SEQ = @ACC_SEQ
					
					SET @RTN_ACC_SEQ = @ACC_SEQ
					
					--전체 쿼리 중 이상이 없었다면 COMMIT한다.
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
						   ERROR_MESSAGE() AS ErrorMessage,
						   '수정 중 에러 발생' AS ErrorEtc
				END CATCH	
		END
		ELSE IF @CUD = 'D'
		BEGIN
			BEGIN TRAN
				BEGIN TRY
					-- 팀 관리계좌를 삭제 한다.
					UPDATE DBO.EMP_TEAM_ACC_DAMO
						SET DEL_YN = 'Y',
							EDT_DATE = GETDATE()
					WHERE ACC_SEQ = @ACC_SEQ
				
					SET @RTN_ACC_SEQ = @ACC_SEQ
				
					--전체 쿼리 중 이상이 없었다면 COMMIT한다.
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
						   ERROR_MESSAGE() AS ErrorMessage,
						   '삭제 중 에러 발생' AS ErrorEtc
				END CATCH	
		END
	END
GO
