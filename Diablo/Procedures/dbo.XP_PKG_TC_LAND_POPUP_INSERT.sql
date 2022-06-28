USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
■ Server					: 211.115.202.230
■ Database					: DIABLO
■ USP_Name					: XP_PKG_TC_LAND_POPUP_SELECT
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
	Date				Author			Description           
---------------------------------------------------------------------------------------------------
	2013-04-25			오인규 			최초생성
  	2022-01-14			김성호			PKG_AGT_MASTER 스키마 변경으로 SP 수정				  
-------------------------------------------------------------------------------------------------*/ 
CREATE PROCEDURE [dbo].[XP_PKG_TC_LAND_POPUP_INSERT]
(             
    @TOT_CODE VARCHAR(20) -- 마스터/행사코드
   ,@AGT_CODE VARCHAR(10)
   ,@NEW_CODE CHAR(7)
)
AS
BEGIN
	
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
	
	--IF ((SELECT COUNT(AGT_CODE)  FROM PKG_AGT_MASTER WHERE MASTER_CODE = @MASTER_CODE AND AGT_CODE = @AGT_CODE) < 1 )
	--	BEGIN
	--		INSERT INTO dbo.PKG_AGT_MASTER 
	--			   (  
	--				MASTER_CODE, 
	--				PRO_CODE, 
	--				AGT_CODE, 
	--				AGT_TYPE_CODE, 
	--				NEW_DATE, 
	--				NEW_CODE, 
	--				EDT_DATE, 
	--				EDT_CODE
	--			   )   
	--		VALUES  
	--			   (  
	--				@MASTER_CODE, 
	--				'', 
	--				@AGT_CODE, 
	--				'12', 
	--				GETDATE(), 
	--				@NEW_CODE, 
	--				GETDATE(), 
	--				@NEW_CODE
	--			   )  
	--	END
END

GO
