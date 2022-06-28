USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_SAFE_INFO_COUNTRY_BASIC_INSERT
■ DESCRIPTION				: 안전정보 국가별 기본정보 입력
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	SELECT * FROM SAFE_INFO_COUNTRY_BASIC;
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-22		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_SAFE_INFO_COUNTRY_BASIC_INSERT]
	@XML XML
AS 
BEGIN
	BEGIN TRAN;
	
	BEGIN TRY
		
		TRUNCATE TABLE SAFE_INFO_COUNTRY_BASIC;

		INSERT INTO SAFE_INFO_COUNTRY_BASIC
		SELECT 
			t1.col.value('./id[1]', 'varchar(20)') as [id],
			t1.col.value('./continent[1]', 'varchar(60)') as [continent],
			t1.col.value('./countryName[1]', 'varchar(50)') as [countryName],
			t1.col.value('./countryEnName[1]', 'varchar(50)') as [countryEnName],
			t1.col.value('./basic[1]', 'varchar(5000)') as [basic],
			t1.col.value('./imgUrl[1]', 'varchar(100)') as [imgUrl],
			t1.col.value('./wrtDt[1]', 'datetime') as [wrtDt],
			GETDATE()
		FROM @XML.nodes('/SafeInfoCountryBasicItems/item') as t1(col);

		IF @@TRANCOUNT > 0
		BEGIN
			COMMIT TRAN;
			RETURN;
		END
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRAN;
		END
	END CATCH

	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRAN;
	END	
END
GO
