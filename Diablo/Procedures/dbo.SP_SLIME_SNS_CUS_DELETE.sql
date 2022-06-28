USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_SNS_CUS_DELETE
■ DESCRIPTION				: 삭제_SNS 회원정보
■ INPUT PARAMETER			: CUS_NO
■ EXEC						: 
    -- EXEC SP_MOV2_SNS_CUS_DELETE 8505125 

■ MEMO						: SNS 회원 정보을 삭제한다.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-01	  아이비솔루션				최초생성
   2017-10-23		정지용					수정 
   2020-05-25		김영민(EHD)				CHANGE_DATE 추가 
   2020-09-17		홍종우					@SNS_ID VARCHAR(20) -> VARCHAR(100) 변경

================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_SLIME_SNS_CUS_DELETE]	
	@SNS_COMPANY			INT,
	@SNS_ID				VARCHAR(100),
	@CUS_NO				INT
AS
BEGIN
/*
	UPDATE CUS_SNS_INFO 
		SET  DISCNT_DATE = GETDATE()
	WHERE CUS_NO = @CUS_NO
*/
	UPDATE CUS_SNS_INFO SET
		DISCNT_DATE = GETDATE(),
		CHANGE_DATE = null
	WHERE SNS_ID = @SNS_ID AND CUS_NO = @CUS_NO;
END
GO
