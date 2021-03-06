USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_HTL_RESV_ROOM_REFRESH]

@RESV_NO INT,
@ROOM_NO INT,
@PAX_CNT INT,
@ROOM_DESC VARCHAR(300)

AS

DECLARE @CNT INT;
SELECT @CNT = COUNT(*) FROM HTL_RESV_ROOM WHERE RESV_NO=@RESV_NO AND ROOM_NO=@ROOM_NO

IF (@CNT = 0)
BEGIN

INSERT INTO HTL_RESV_ROOM
(
	RESV_NO,
	ROOM_NO,
	PAX_CNT,
	ROOM_DESC,
	ROOM_TYPE,
	USE_YN,
	CREATE_DATE,
	CREATE_USER,
	UPDATE_DATE,
	UPDATE_USER
)
SELECT
	@RESV_NO,
	(SELECT ISNULL(MAX(ROOM_NO),0)+1 FROM HTL_RESV_ROOM WHERE RESV_NO=@RESV_NO),
	@PAX_CNT,
	@ROOM_DESC,
	'None', 'Y', GETDATE(), 'SYSTEM', GETDATE(), 'SYSTEM'

END

ELSE

BEGIN

	UPDATE HTL_RESV_ROOM SET
		PAX_CNT = @PAX_CNT,
		ROOM_DESC = @ROOM_DESC
	WHERE
		RESV_NO = @RESV_NO 
		AND ROOM_NO = @ROOM_NO
END


GO
