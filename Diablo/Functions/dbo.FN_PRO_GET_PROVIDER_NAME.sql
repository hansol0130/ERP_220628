USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_PRO_GET_PROVIDER_NAME
■ Description				: 
■ Input Parameter			: 
		@PROVIDER			: 유입처구분 이름 변경
■ Select					: 
■ Author					: 
■ Date						:   
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
  2019-07-29        김남훈          최초생성
-------------------------------------------------------------------------------------------------*/

CREATE FUNCTION [dbo].[FN_PRO_GET_PROVIDER_NAME]
(
	@PROVIDER int
)

RETURNS VARCHAR(20)

AS

	BEGIN
		DECLARE @PROVIDER_NAME VARCHAR(20)
		SELECT @PROVIDER_NAME = PUB_VALUE FROM COD_PUBLIC WHERE PUB_TYPE = 'RES.AGENT.TYPE' AND USE_YN = 'Y' AND PUB_CODE = @PROVIDER

		IF @PROVIDER_NAME IS NULL
		BEGIN
			SET @PROVIDER_NAME = ''
		END

		RETURN (@PROVIDER_NAME)
	END
GO
