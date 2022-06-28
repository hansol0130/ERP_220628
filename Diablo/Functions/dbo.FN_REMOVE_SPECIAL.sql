USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이규식
-- Create date: 2011-05-03
-- Description:	입력문자열중 특수기호를 제거한다.
-- =============================================
CREATE FUNCTION [dbo].[FN_REMOVE_SPECIAL]
(
	@STR VARCHAR(200)
)
RETURNS VARCHAR(200)
AS
BEGIN
	-- Return the result of the function
	RETURN 
	REPLACE(
	REPLACE(
	REPLACE(
	REPLACE(
		REPLACE(@STR, '(', ''),
					')', '')
					,'-', '')
					,' ', '')
					,'/', '')

END
GO
