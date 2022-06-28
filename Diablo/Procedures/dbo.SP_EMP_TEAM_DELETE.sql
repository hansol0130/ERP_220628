USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:권윤경
-- Create date: 2008-03-10
-- Description:	해당사원이 없을경우 팀삭제 sp
-- 수정: 등록된 사원 체크시 재직인 경우만 카운트 [김성호:20080624]
-- =============================================
CREATE PROCEDURE [dbo].[SP_EMP_TEAM_DELETE]
@TEAM_CODE VARCHAR(3),
@REVALUE INT OUTPUT
AS
BEGIN

SET NOCOUNT OFF;
	DECLARE @EMP_COUNT INT
	SET @EMP_COUNT  = 0;

	BEGIN
		SELECT @EMP_COUNT  = COUNT(EMP_CODE)  FROM EMP_MASTER_damo WHERE TEAM_CODE=@TEAM_CODE AND WORK_TYPE='1'
		
		IF @EMP_COUNT=0
			BEGIN
				
				UPDATE EMP_TEAM SET USE_YN='N' WHERE TEAM_CODE=@TEAM_CODE
				SET	@REVALUE = 1; --성공
			END
		ELSE
			BEGIN
				SET	@REVALUE = 0;
			END
		
	END
END
GO
