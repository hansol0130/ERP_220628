USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
■ Server					: 211.115.202.230
■ Database					: DIABLO
■ USP_Name					: [XP_PKG_P_TC_LAND_POPUP_INSERT
■ Description				: 
■ Input Parameter			:                  
	@MASTER_CODE	VARCHAR(10)
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
■ Author					:  
■ Date						: 
■ Memo						: 상품마스터화면/ 랜드사 선택 등록 
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	DATE				Author			DESCRIPTION           
---------------------------------------------------------------------------------------------------
	2013-04-25			오인규 			최초생성 
	2014-03-17			이동호 			행사나 마스터중 이미 등록된 값이 있으면 미등록처리  
	2014-12-01			정지용			행사코드 OR 마스터 코드 체크에서 행사코드만 검색
	2022-01-14			김성호			PKG_AGT_MASTER 스키마 변경으로 SP 수정
	2022-05-25			이호철			행사마스터 등록시 랜드사 거래처 코드값 수정
-------------------------------------------------------------------------------------------------*/ 
CREATE PROCEDURE [dbo].[XP_PKG_P_TC_LAND_POPUP_INSERT]
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
		        SELECT @TOT_CODE
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
		/* 
		SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_STATE() AS ErrorState,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage
		*/
		
		SELECT -1
		
	END CATCH


	
	--DECLARE @result INT
	--SET @result = 0
	
		
	--IF ISNULL((SELECT TC_LAND_YN FROM PKG_DETAIL WHERE PRO_CODE = @PRO_CODE), '') <> 'Y'
	--	BEGIN
	--		INSERT INTO dbo.PKG_AGT_MASTER 
	--				(  
	--				MASTER_CODE, 
	--				PRO_CODE, 
	--				AGT_CODE, 
	--				AGT_TYPE_CODE, 
	--				NEW_DATE, 
	--				NEW_CODE, 
	--				EDT_DATE, 
	--				EDT_CODE
	--				)   
	--			SELECT '',
	--				@PRO_CODE,
	--				AGT_CODE, 
	--				'12', 
	--				GETDATE(), 
	--				@NEW_CODE, 
	--				GETDATE(), 
	--				@NEW_CODE
	--			FROM PKG_AGT_MASTER
	--			WHERE MASTER_CODE = @MASTER_CODE

	--			UPDATE PKG_DETAIL SET TC_LAND_YN= 'Y' WHERE PRO_CODE = @PRO_CODE

	--	END


	--IF ((SELECT COUNT(AGT_CODE)  FROM PKG_AGT_MASTER WHERE PRO_CODE = @PRO_CODE AND AGT_CODE = @AGT_CODE) < 1 )
	----IF ((SELECT COUNT(AGT_CODE)  FROM PKG_AGT_MASTER WHERE AGT_CODE = @AGT_CODE AND (PRO_CODE = @PRO_CODE OR MASTER_CODE = @MASTER_CODE)) < 1 ) -- 행사나 마스터중 등록된 값이 이으면 패스
	--	BEGIN
	--		SET @result = 1

	--		INSERT INTO dbo.PKG_AGT_MASTER 
	--				(  
	--				MASTER_CODE, 
	--				PRO_CODE, 
	--				AGT_CODE, 
	--				AGT_TYPE_CODE, 
	--				NEW_DATE, 
	--				NEW_CODE, 
	--				EDT_DATE, 
	--				EDT_CODE
	--				)   
	--		VALUES  
	--				(  
	--				'', 
	--				@PRO_CODE, 
	--				@AGT_CODE, 
	--				'12', 
	--				GETDATE(), 
	--				@NEW_CODE, 
	--				GETDATE(), 
	--				@NEW_CODE
	--				)	
			
	--	END
	
	--	SELECT @result		
END
GO
