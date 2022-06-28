USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_PKG_MASTER_SELECT_PRODUCT_NAVER_DETAIL_UPDATECHECK
■ DESCRIPTION				: 2019 네이버 패키지 상품연동 상품 조회 
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: SP_PKG_MASTER_SELECT_PRODUCT_NAVER_DETAIL_UPDATECHECK ''


-- @CODES 는 100 개 자상품 코드 넘지 않게 전송 
SP_PKG_MASTER_SELECT_PRODUCT_NAVER_DETAIL_UPDATECHECK 'EPP4007-190621OK10|1,EPP4007-190628OK10|1,EPP4007-190704|1,EPP4007-190705OK10|1,EPP4007-190706KE|1,EPP4007-190724KE|1'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
2019-06-20			박형만			
================================================================================================================*/ 
CREATE  PROC [dbo].[SP_PKG_MASTER_SELECT_PRODUCT_NAVER_DETAIL_UPDATECHECK]
	@CODES VARCHAR(4000) , @UPD_DATE DATETIME = NULL  
AS
BEGIN

--DECLARE @CODES VARCHAR(4000), @UPD_DATE DATETIME 
--SET  @CODES = 'EPP4007-190621OK10|1,EPP4007-190628OK10|1,EPP4007-190704|1,EPP4007-190705OK10|1,EPP4007-190706KE|1,EPP4007-190724KE|1'

	IF @UPD_DATE IS NULL 
	BEGIN
		SET @UPD_DATE = GETDATE()
	END 
	--SELECT @UPD_DATE 
	IF ISNULL(@CODES,'') <> ''
	BEGIN 
		UPDATE NAVER_PKG_DETAIL SET UPDATEDDATE = @UPD_DATE 
		--SELECT * FROM NAVER_PKG_DETAIL 
		WHERE CHILDCODE IN ( SELECT DATA FROM FN_SPLIT(@CODES,',') )  
	END 
END 
GO
