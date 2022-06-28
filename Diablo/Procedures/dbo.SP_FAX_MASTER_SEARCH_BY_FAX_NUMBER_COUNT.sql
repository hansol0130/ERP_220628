USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		 
-- Create date:  2011-11-28
-- Description:	<팩스 수신함 조회 카운트  - 번호로 조회>

-- SP_FAX_MASTER_SEARCH_BY_FAX_NUMBER_COUNT '02','6944','9107'
-- =============================================
CREATE PROCEDURE [dbo].[SP_FAX_MASTER_SEARCH_BY_FAX_NUMBER_COUNT]
	@RCV_NUMBER1 VARCHAR(4),
	@RCV_NUMBER2 VARCHAR(4),
	@RCV_NUMBER3 VARCHAR(4)
AS
BEGIN	
		SELECT 
			COUNT(*)
		FROM FAX_MASTER  A WITH(NOLOCK) 
			INNER JOIN FAX_RECEIVE B WITH(NOLOCK)
				ON A.FAX_SEQ = B.FAX_SEQ 
		WHERE A.FAX_TYPE = 2 AND A.DEL_YN='N' 
		
		AND B.RCV_NUMBER1 = @RCV_NUMBER1
		AND B.RCV_NUMBER2 = @RCV_NUMBER2
		AND B.RCV_NUMBER3 = @RCV_NUMBER3
		
END 
GO
