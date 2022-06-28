USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	기본내용
====================================================================================
- SP 명 : [ZP_CUS_SALE_CODE_INSERT]
- 기 능 : 난수생성
====================================================================================
	변경내역
====================================================================================
- 2021-07-08 김영민 신규 작성 
===================================================================================*/
CREATE  PROCEDURE [dbo].[ZP_CUS_SALE_CODE_INSERT]
@CODE_CNT INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @ID    INT
DECLARE @CODE  VARCHAR(10)
DECLARE @START_DATE DATETIME
DECLARE @END_DATE DATETIME

SET @ID = 0
SET @START_DATE = CONVERT(CHAR(10), GETDATE(), 23) + ' 00:00:00.000'
SET @END_DATE =  DATEADD(mm,1,(CONVERT(CHAR(10), GETDATE(), 23))) + ' 23:59:00.000'
 
WHILE( @ID < @CODE_CNT )
BEGIN
  SET @ID = @ID + 1
  SET @CODE =  LEFT(NEWID(), 4) + '-' + LEFT(NEWID(), 4) 
 IF NOT EXISTS (SELECT SALE_CODE FROM CUS_SALE_CODE WHERE SALE_CODE = @CODE )
  INSERT INTO CUS_SALE_CODE (SALE_CODE, NEW_DATE,START_DATE, END_DATE,USE_YN ) VALUES (@CODE, GETDATE(), @START_DATE, @END_DATE,'N');
  ELSE
   SET @ID = @ID -1
END

END 
GO
