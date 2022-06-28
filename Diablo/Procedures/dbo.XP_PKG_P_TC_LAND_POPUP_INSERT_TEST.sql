USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec XP_PKG_TC_MASTER_LAND_SELECT @TOT_CODE='XXP928-220609OZ',@AGT_TYPE_CODE=NULL
		
CREATE PROCEDURE [dbo].[XP_PKG_P_TC_LAND_POPUP_INSERT_TEST]
(
    @TOT_CODE VARCHAR(20) -- 마스터/행사코드
   ,@AGT_CODE VARCHAR(10)
   ,@NEW_CODE CHAR(7)
)
AS

BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY
	
		-- 등록유무 체크
		IF NOT EXISTS(
		       SELECT 1
		       FROM   dbo.PKG_AGT_MASTER
		       WHERE  TOT_CODE = @TOT_CODE
		              AND AGT_CODE = @AGT_CODE
		   )
		BEGIN
			
			-- 행사코드로 거래처 등록안되어 있으면 마스터의 거래처 코드 복사
			IF NOT EXISTS(
				SELECT 1
				FROM   dbo.PKG_AGT_MASTER
				WHERE  TOT_CODE = @TOT_CODE
			)
			AND CHARINDEX('-' ,@TOT_CODE) > 0
		    BEGIN
		        INSERT INTO dbo.PKG_AGT_MASTER
		          (
		            TOT_CODE
		           ,AGT_CODE
		           ,NEW_CODE
		           ,NEW_DATE
		          )
		        SELECT TOT_CODE
		              ,AGT_CODE
		              ,NEW_CODE
		              ,NEW_DATE
		        FROM   dbo.PKG_AGT_MASTER
		        WHERE  TOT_CODE = SUBSTRING(@TOT_CODE ,0 ,CHARINDEX('-' ,@TOT_CODE))
		    END
		    
		    -- 해당 코드 복사
		    INSERT INTO dbo.PKG_AGT_MASTER
		      (
		        TOT_CODE
		       ,AGT_CODE
		       ,NEW_CODE
		       ,NEW_DATE
		      )
		    VALUES
		      (
		        @TOT_CODE
		       ,@AGT_CODE
		       ,@NEW_CODE
		       ,GETDATE()
		      )
		END		
		SELECT 1
		  
	END TRY
	BEGIN CATCH
		SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_STATE() AS ErrorState,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage
		
		
		SELECT -1
		
	END CATCH

END
GO
