USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_GET_PACKAGE
■ Description				: 마스터코드 가까운 행사코드
■ Input Parameter			:                  
		@PRO_CODE			: 마스터코드
■ Output Parameter			: 
■ Output Value				: 
■ Exec						: 
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2020-01-03		프리랜서			최초생성
-------------------------------------------------------------------------------------------------*/ 
CREATE FUNCTION [dbo].[FN_GET_PACKAGE]
(
		@MASTER_CODE	VARCHAR(10)
)
RETURNS VARCHAR(20)
AS
BEGIN
	
	-- Declare the return variable here
	DECLARE @PRO_CODE VARCHAR(20)

	SELECT @PRO_CODE = (
		SELECT	TOP 1 PRO_CODE
		FROM	PKG_DETAIL PD WITH(NOLOCK)
		WHERE   MASTER_CODE = @MASTER_CODE
		AND		DEP_DATE	>= GETDATE() --DATEADD(D, 1, GETDATE())
		AND		SHOW_YN		=	'Y'
		ORDER BY DEP_DATE ASC, PRO_CODE ASC
	)

	IF @PRO_CODE IS NULL 
		BEGIN
			SET @PRO_CODE = ''
		END

	RETURN @PRO_CODE

END
GO
