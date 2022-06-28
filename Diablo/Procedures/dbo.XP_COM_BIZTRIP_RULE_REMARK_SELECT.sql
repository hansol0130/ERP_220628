USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BIZTRIP_RULE_REMARK_SELECT
■ DESCRIPTION				: 출장예약 규정위반 내역 가져오기 (예약후)
■ INPUT PARAMETER			: 
	
	XP_COM_BIZTRIP_RULE_REMARK_SELECT  'BT1602290024', ''  

XP_COM_BIZTRIP_RULE_REMARK_SELECT  '', 'RT1603108832'  


	RT1603108832

■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-03-02		박형만			최초생성    
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BIZTRIP_RULE_REMARK_SELECT] 
(
	@BT_CODE VARCHAR(12),
	@RES_CODE RES_CODE 
)
AS 
BEGIN

	IF(ISNULL(@BT_CODE,'') <> '')
	BEGIN
		SELECT A.*, B.BT_CODE , C.PRO_TYPE FROM COM_BIZTRIP_RULE_REMARK A WITH(NOLOCK)
			INNER JOIN COM_BIZTRIP_DETAIL B WITH(NOLOCK) 
				ON A.RES_CODE = B.RES_CODE 
			INNER JOIN RES_MASTER_damo C WITH(NOLOCK) 
				ON A.RES_CODE = C.RES_CODE 
		WHERE B.BT_CODE = @BT_CODE 
		ORDER BY C.NEW_DATE ASC -- 예약순 
	END 
	ELSE IF(ISNULL(@RES_CODE,'') <> '')
	BEGIN
		SELECT A.* , B.BT_CODE , C.PRO_TYPE FROM COM_BIZTRIP_RULE_REMARK A WITH(NOLOCK)
			INNER JOIN COM_BIZTRIP_DETAIL B WITH(NOLOCK) 
				ON A.RES_CODE = B.RES_CODE 
			INNER JOIN RES_MASTER_damo C WITH(NOLOCK) 
				ON A.RES_CODE = C.RES_CODE 
		WHERE A.RES_CODE = @RES_CODE 
	END 
	
END 

GO
