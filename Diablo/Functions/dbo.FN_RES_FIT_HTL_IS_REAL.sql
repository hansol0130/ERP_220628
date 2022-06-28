USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_RES_FIT_HTL_IS_REAL]
(
	@GRP_RES_CODE	VARCHAR(20)
)
RETURNS CHAR(1)
AS
BEGIN

	DECLARE @YN CHAR(1)

	SELECT
		@YN = MIN(ISNULL(C.RES_ONLINE_YN,'N'))
	FROM RES_HTL_ROOM_MASTER A WITH(NOLOCK) 
	INNER JOIN HTL_CONNECT B  WITH(NOLOCK) ON A.SUP_CODE = B.SUP_CODE
	INNER JOIN HTL_MASTER C  WITH(NOLOCK) ON B.MASTER_CODE = C.MASTER_CODE
	WHERE A.RES_CODE IN (SELECT RES_CODE FROM RES_MASTER  WITH(NOLOCK) WHERE GRP_RES_CODE = @GRP_RES_CODE)


	RETURN (@YN)
END
GO