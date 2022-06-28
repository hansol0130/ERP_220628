USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_SAFE_INFO_WARNING_INSERT
■ DESCRIPTION				: 안전정보 여행 경보제도 입력
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	SELECT * FROM SAFE_INFO_TRAVEL_WARNING;
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2015-12-24		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_SAFE_INFO_WARNING_INSERT]
	@XML XML
AS 
BEGIN
	BEGIN TRAN;
	
	BEGIN TRY
		
		TRUNCATE TABLE SAFE_INFO_TRAVEL_WARNING;

		INSERT INTO SAFE_INFO_TRAVEL_WARNING
		SELECT 
			t1.col.value('./id[1]', 'varchar(20)') as [id],
			t1.col.value('./continent[1]', 'varchar(60)') as [continent],
			t1.col.value('./countryName[1]', 'varchar(50)') as [countryName],
			t1.col.value('./countryEnName[1]', 'varchar(50)') as [countryEnName],
			t1.col.value('./imgUrl[1]', 'varchar(100)') as [imgUrl],
			t1.col.value('./imgUrl2[1]', 'varchar(100)') as [imgUrl2],
			t1.col.value('./attention[1]', 'varchar(20)') as [attention],
			t1.col.value('./attentionPartial[1]', 'varchar(20)') as [attentionPartial],
			t1.col.value('./attentionNote[1]', 'varchar(500)') as [attentionNote],
			t1.col.value('./control[1]', 'varchar(20)') as [control],
			t1.col.value('./controlPartial[1]', 'varchar(20)') as [controlPartial],
			t1.col.value('./controlNote[1]', 'varchar(500)') as [controlNote],
			t1.col.value('./limita[1]', 'varchar(20)') as [limit],
			t1.col.value('./limitaPartial[1]', 'varchar(20)') as [limitPartial],
			t1.col.value('./limitaNote[1]', 'varchar(500)') as [limitNote],
			t1.col.value('./wrtDt[1]', 'datetime') as [wrtDt],
			GETDATE()
		FROM @XML.nodes('/SafeInfoWarningItems/item') as t1(col);

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
