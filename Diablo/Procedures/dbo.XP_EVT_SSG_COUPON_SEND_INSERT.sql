USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_EVT_SSG_COUPON_SEND_INSERT
■ DESCRIPTION				: 신세계면세점 상품권 정기 문자 발송번호 등록
■ INPUT PARAMETER			: 
	@RES_CODE VARCHAR(20)	: 예약번호
	@NOR_TEL1 VARCHAR(6)	: 핸드폰번호1
	@NOR_TEL2 VARCHAR(5)	: 핸드폰번호2
	@NOR_TEL3 VARCHAR(4)	: 핸드폰번호3
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC XP_EVT_SSG_COUPON_SEND_INSERT '', '', '', ''

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2016-09-08		김성호			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_EVT_SSG_COUPON_SEND_INSERT]
	@RES_CODE VARCHAR(20),
	@NOR_TEL1 VARCHAR(6),
	@NOR_TEL2 VARCHAR(5),
	@NOR_TEL3 VARCHAR(4)
AS 
BEGIN

	IF NOT EXISTS(SELECT 1 FROM EVT_SSG_DUTYFREE A WITH(NOLOCK) WHERE A.RES_CODE = @RES_CODE AND A.NOR_TEL1 = @NOR_TEL1 AND A.NOR_TEL2 = @NOR_TEL2 AND A.NOR_TEL3 = @NOR_TEL3)
	BEGIN
		INSERT INTO EVT_SSG_DUTYFREE (RES_CODE, NOR_TEL1, NOR_TEL2, NOR_TEL3, NEW_DATE) VALUES (@RES_CODE, @NOR_TEL1, @NOR_TEL2, @NOR_TEL3, GETDATE())
	END

END



	
GO
