USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_PKG_URGENT_PRODUCT_INSERT
■ DESCRIPTION				: 긴급모객 상품 등록
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-04-16		정지용			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_PKG_URGENT_PRODUCT_INSERT]
(
	@SITE_CODE		CHAR(3),
	@REGION_CODE	VARCHAR(1),
	@PRO_CODE		VARCHAR(20),
	@PRO_NAME		VARCHAR(200),
	@SEAT_CNT		INT,
	@SHOW_YN		CHAR(1),
	@NEW_CODE		CHAR(7)
) 
AS 
BEGIN 
	IF EXISTS ( SELECT 1 FROM PKG_URGENT_MASTER WITH(NOLOCK) WHERE SITE_CODE = @SITE_CODE AND PRO_CODE = @PRO_CODE AND SHOW_YN = 'Y' )
	BEGIN
		SELECT 'EXISTS';
		RETURN;
	END


	DECLARE @U_SEQ INT;
	SELECT @U_SEQ = (ISNULL(MAX(U_SEQ), 0) + 1) FROM PKG_URGENT_MASTER A WITH(NOLOCK) WHERE A.SITE_CODE = @SITE_CODE

	INSERT INTO PKG_URGENT_MASTER (SITE_CODE, U_SEQ, REGION_CODE, PRO_CODE, PRO_NAME, SEAT_CNT, SHOW_YN, NEW_CODE, NEW_DATE)
	VALUES ( @SITE_CODE, @U_SEQ, @REGION_CODE, @PRO_CODE, @PRO_NAME, @SEAT_CNT, @SHOW_YN, @NEW_CODE, GETDATE() )

	SELECT 'SUCC';
END 
GO
