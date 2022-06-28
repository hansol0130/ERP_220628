USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_SMARTCARE_STATICMAP_DELETE
- 기 능 :마스트코드 값으로 여행일정 맵 정보를 삭제한다.
====================================================================================
	참고내용
====================================================================================
- 예제

 EXEC SP_SMARTCARE_STATICMAP_DELETE @MASTER_CODE 
====================================================================================
	변경내역
====================================================================================
- 2016-04-22 아이비솔루션 이인왕
===================================================================================*/
CREATE PROCEDURE [dbo].[SP_SMARTCARE_STATICMAP_DELETE]
(
	@MASTER_CODE	VARCHAR(20)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE	@FILE_CODE INTEGER
	DECLARE	@CNT_CODE INTEGER

    DELETE FROM INF_FILE_MANAGER WHERE FILE_CODE IN (SELECT FILE_CODE FROM PKG_MASTER_SCH_MAP WHERE MASTER_CODE = @MASTER_CODE)
	DELETE FROM INF_FILE_TYPE WHERE FILE_CODE IN (SELECT FILE_CODE FROM PKG_MASTER_SCH_MAP WHERE MASTER_CODE = @MASTER_CODE)
	
	DELETE FROM INF_TYPE WHERE CNT_CODE IN (SELECT CNT_CODE FROM PKG_MASTER_SCH_MAP WHERE MASTER_CODE = @MASTER_CODE)
	DELETE FROM INF_MAP WHERE CNT_CODE IN (SELECT CNT_CODE FROM PKG_MASTER_SCH_MAP WHERE MASTER_CODE = @MASTER_CODE)
	
	DELETE FROM PKG_DETAIL_SCH_MAP WHERE MASTER_CODE = @MASTER_CODE
	DELETE FROM PKG_MASTER_SCH_MAP_CONTENT WHERE MASTER_CODE = @MASTER_CODE
	DELETE FROM PKG_MASTER_SCH_MAP WHERE MASTER_CODE = @MASTER_CODE

	DECLARE CUR CURSOR FOR
		SELECT FILE_CODE,CNT_CODE FROM PKG_MASTER_SCH_MAP WHERE MASTER_CODE = @MASTER_CODE 
	OPEN CUR

	FETCH NEXT FROM CUR INTO @FILE_CODE,@CNT_CODE

	WHILE @@FETCH_STATUS = 0 
	BEGIN
		DELETE FROM INF_FILE_MASTER WHERE FILE_CODE = @FILE_CODE
		DELETE FROM INF_MASTER WHERE CNT_CODE = @CNT_CODE

		FETCH NEXT FROM CUR INTO @FILE_CODE,@CNT_CODE
	end
END

GO
