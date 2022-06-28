USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_SEARCH_BTMS_CUS_NAMES
■ DESCRIPTION				: ERP BTMS 예약자명 불러오기
■ INPUT PARAMETER			: 
	@RES_CODE		VARCHAR(15): 검색 키
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC DBO.XP_COM_SEARCH_BTMS_CUS_NAMES 'RT1609123678'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-06-24	 저스트고_강태영	  최초생성
   2016-09-12    저스트고_이유라		  B.RES_STATE 상태값 조건 추가 (FN_RES_GET_RES_COUNT 참고)
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_SEARCH_BTMS_CUS_NAMES]

@RES_CODE VARCHAR(15)

AS

SELECT DISTINCT B.CUS_NAME
FROM RES_MASTER_damo A
INNER JOIN RES_CUSTOMER_damo B ON A.RES_CODE = B.RES_CODE
WHERE A.RES_CODE = @RES_CODE AND A.RES_STATE <= 7  AND B.RES_STATE IN (0, 3)  
GO
