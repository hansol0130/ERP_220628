USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ USP_Name					: SP_PRO_TRANS_SEAT_SEGMENT_INSERT  
■ Description				: 좌석 정보 신규 세그 등록 
■ Input Parameter			:                  


■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC SP_PRO_TRANS_SEAT_INSERT  
■ Author					: 박형만  
■ Date						: 2019-04-01
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2019-04-01		박형만			최초생성  
-------------------------------------------------------------------------------------------------*/ 
CREATE PROC [dbo].[SP_PRO_TRANS_SEAT_SEGMENT_INSERT]
(	
	@SEAT_CODE INT, -- 키 
	@TRANS_SEQ INT,
	@SEG_NO INT,
	@DEP_AIRPORT_CODE CHAR(3),
	@ARR_AIRPORT_CODE CHAR(3),
	@AIRLINE_CODE  CHAR(2),
	@FLIGHT  VARCHAR(20),
	@DEP_DATE datetime,
	@ARR_DATE datetime,
	@NEW_CODE NEW_CODE,
	@REAL_AIRLINE_CODE char(2),
	@FLYING_TIME varchar(5) 
)
AS 
BEGIN

	INSERT PRO_TRANS_SEAT_SEGMENT 
	(SEAT_CODE,TRANS_SEQ,SEG_NO,DEP_AIRPORT_CODE,ARR_AIRPORT_CODE,AIRLINE_CODE,FLIGHT,
	DEP_DATE,ARR_DATE,NEW_CODE,NEW_DATE,REAL_AIRLINE_CODE,FLYING_TIME)

	VALUES 
	(@SEAT_CODE,@TRANS_SEQ,@SEG_NO,@DEP_AIRPORT_CODE,@ARR_AIRPORT_CODE,@AIRLINE_CODE,@FLIGHT,
	@DEP_DATE,@ARR_DATE,@NEW_CODE,GETDATE(),@REAL_AIRLINE_CODE,@FLYING_TIME )

END
GO
