USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		이규식
-- Create date: 2009-10-4
-- Description:	정산수익조회
-- 2012-03-02 WITH(NOLOCK) 추가 	
-- =============================================
CREATE FUNCTION [dbo].[FN_SET_GET_COMPLETE]
(
	@PRO_CODE VARCHAR(20)
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT * FROM VIEW_SET_COMPLETE WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE
)

GO
