USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[FN_AIR_GET_PAX_NAME]
(
	-- Add the parameters for the function here
	@PAX_NAME VARCHAR(40)
)
RETURNS VARCHAR(40)
AS
BEGIN

-- 순서중요
SET @PAX_NAME = REPLACE(@PAX_NAME, ' ', '');
SET @PAX_NAME = REPLACE(@PAX_NAME, '/', '');
SET @PAX_NAME = REPLACE(@PAX_NAME, 'MSTR', '');
SET @PAX_NAME = REPLACE(@PAX_NAME, 'MISS', '');
SET @PAX_NAME = REPLACE(@PAX_NAME, 'MRS', '');
SET @PAX_NAME = REPLACE(@PAX_NAME, 'MR', '');
SET @PAX_NAME = REPLACE(@PAX_NAME, 'MS', '');

	-- Return the result of the function
	RETURN @PAX_NAME

END


GO
