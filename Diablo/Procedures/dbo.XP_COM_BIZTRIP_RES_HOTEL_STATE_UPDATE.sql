USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_BIZTRIP_RES_HOTEL_STATE_UPDATE
■ DESCRIPTION				: BTMS 호텔 예약 정보 상태 변경
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-03-23		박형만			최초생성
   2016-04-20		박형만			출장대표예약 재설정 쿼리 삭제 --> BIZ 에서 처리 
================================================================================================================*/ 
CREATE  PROC [dbo].[XP_COM_BIZTRIP_RES_HOTEL_STATE_UPDATE]
	@RES_CODE	RES_CODE ,
	@RES_STATE	INT ,
	@HTL_RES_STATE INT , 
	@EDT_CODE EMP_CODE,
	@AGT_CODE VARCHAR(100) = NULL ,
	@EMP_SEQ INT = 0 ,
	@REMARK VARCHAR(1000)
AS 
BEGIN
	
	--BEGIN TRAN 

		IF @RES_STATE IN ( 7,8,9 )
		BEGIN
			UPDATE RES_MASTER_damo SET RES_STATE = @RES_STATE, EDT_CODE = @EDT_CODE, EDT_DATE = GETDATE() , CXL_DATE = GETDATE(), CXL_CODE = @EDT_CODE , ETC = ISNULL(@REMARK,'') +'
			' + ISNULL(ETC, '')
			WHERE RES_CODE = @RES_CODE
		END 
		ELSE 
		BEGIN
			UPDATE RES_MASTER_damo SET RES_STATE = @RES_STATE, EDT_CODE = @EDT_CODE, EDT_DATE = GETDATE() , ETC = ISNULL(@REMARK,'') +'
' + ISNULL(ETC, '')
			WHERE RES_CODE = @RES_CODE
		END 
	
	--{ None, 확정, 대기, 취소, 취소대기중, 펜딩, 확인요망, 환불요청중, 환불, 알수없음 };
		IF @HTL_RES_STATE NOT IN (7)
		BEGIN
			UPDATE RES_HTL_ROOM_MASTER SET RES_STATE = @HTL_RES_STATE, EDT_CODE = @EDT_CODE, EDT_DATE = GETDATE() ,	ROOM_YN ='N' ,
				SALE_PRICE = 0 ,TAX_PRICE = 0 ,DC_PRICE= 0 ,CHG_PRICE= 0 ,PENALTY_PRICE= 0 ,NET_PRICE= 0 
			WHERE RES_CODE = @RES_CODE
		END 
		ELSE 
		BEGIN
			UPDATE RES_HTL_ROOM_MASTER SET RES_STATE = @HTL_RES_STATE, EDT_CODE = @EDT_CODE, EDT_DATE = GETDATE() 
			WHERE RES_CODE = @RES_CODE
		END 
	
		--재설정 
		--EXEC XP_COM_BIZTRIP_MASTER_RESETTING @RES_CODE


	--IF( @@ERROR <> 0 )
	--BEGIN
	--	ROLLBACK TRAN 
	--END 
	--ELSE 
	--BEGIN
	--	COMMIT TRAN 
	--END 
END 



GO
