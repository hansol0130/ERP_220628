USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_MOV2_PERIOD_HISTORY_DELETE
■ DESCRIPTION				: 삭제_정기적인_히스토리데이타
■ INPUT PARAMETER			: @CUVE_PERIOD, @HIS_PERIOD : 단위 일, @VIEW_MASTER_PERIOD : 단위 시간
■ EXEC						: 
    -- exec SP_MOV2_PERIOD_HISTORY_DELETE 120, 120, 6

■ MEMO						: 정기적으로 히스토리 데이타 정보를 삭제한다.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-11-10		오준욱(IBSOLUTION)		최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_PERIOD_HISTORY_DELETE]
	@CUVE_PERIOD			INT,
	@HIS_PERIOD				INT,
	@VIEW_MASTER_PERIOD		INT
AS
BEGIN

		-- 큐비 히스토리
		DELETE FROM CUVE
			WHERE DATEDIFF ( DAY , SEND_DATE , GETDATE() ) > @CUVE_PERIOD 

		-- 상품/여행후기/관심상품 히스토리
		DELETE FROM CUS_MASTER_HISTORY
			WHERE DATEDIFF ( DAY , HIS_DATE , GETDATE() ) > @HIS_PERIOD

		-- 조회중인 상품 
		DELETE FROM VIEW_MASTER
			WHERE DATEDIFF ( HOUR , NEW_DATE , GETDATE() ) > @VIEW_MASTER_PERIOD

END           



GO
