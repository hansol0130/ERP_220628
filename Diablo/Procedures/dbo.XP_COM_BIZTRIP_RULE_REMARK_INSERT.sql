USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_BIZTRIP_RULE_REMARK_INSERT
■ DESCRIPTION				: 출장예약 규정위반 등록 
■ INPUT PARAMETER			: 
	
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-02-26		박형만			최초생성    
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BIZTRIP_RULE_REMARK_INSERT] 
(
	@RES_CODE	varchar(20),
	@AIR_SAME_YN	char(1),
	@AIR_LIKE_YN	char(1),
	@AIR_DISLIKE_YN char(1),
	@HOTEL_LIKE_YN	char(1),
	@HOTEL_DISLIKE_YN	char(1),
	@AIR_CLASS_LIMIT	varchar(10),
	@HOTEL_PRICE_LIMIT	int,
	@REASON_SEQ	int,
	@REASON_REMARK	varchar(50) 
)
AS 
BEGIN 
	--DECLARE @PRO_TYPE INT ,

	INSERT INTO COM_BIZTRIP_RULE_REMARK (RES_CODE,
		AIR_SAME_YN,AIR_LIKE_YN,AIR_DISLIKE_YN,
		HOTEL_LIKE_YN,HOTEL_DISLIKE_YN,AIR_CLASS_LIMIT,
		HOTEL_PRICE_LIMIT,REASON_SEQ,REASON_REMARK)
	VALUES (@RES_CODE,
		@AIR_SAME_YN,@AIR_LIKE_YN,@AIR_DISLIKE_YN,
		@HOTEL_LIKE_YN,@HOTEL_DISLIKE_YN,@AIR_CLASS_LIMIT,
		@HOTEL_PRICE_LIMIT,@REASON_SEQ,@REASON_REMARK) 


	----위반사유 입력 
	--IF( @BREAK_REASON_YN = 'Y' )
	--BEGIN
		
	--END 
END 


GO
