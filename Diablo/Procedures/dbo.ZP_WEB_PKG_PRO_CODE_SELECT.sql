USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

    
/*================================================================================================================    
■ USP_NAME     : [ZP_WEB_PKG_PRO_CODE_SELECT]    
■ DESCRIPTION    : 마스터코드로 상세코드 가져오기    
■ INPUT PARAMETER   :     
■ OUTPUT PARAMETER   :     
■ EXEC      :     
■ MEMO      :     
------------------------------------------------------------------------------------------------------------------    
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------    
   DATE    AUTHOR   DESCRIPTION               
------------------------------------------------------------------------------------------------------------------    
   2020-05-07  오준혁   최초생성    
   2021-04-21  홍종우   최저가로 변경    
================================================================================================================*/     
CREATE PROC [dbo].[ZP_WEB_PKG_PRO_CODE_SELECT]
	@MASTER_CODE VARCHAR(10)
AS     
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	SELECT TOP 1 PD.PRO_CODE
	FROM   PKG_DETAIL PD WITH(NOLOCK)
	       INNER JOIN PKG_DETAIL_PRICE PP
	            ON  PD.PRO_CODE = PP.PRO_CODE
	WHERE  PD.MASTER_CODE = @MASTER_CODE
	       AND PD.DEP_DATE >= GETDATE()
	       AND PD.SHOW_YN = 'Y'
	       AND PD.RES_ADD_YN = 'Y'
	       AND (MAX_COUNT = 0 OR (MAX_COUNT - DBO.FN_PRO_GET_RES_COUNT(PD.PRO_CODE) > 0))
	ORDER BY
	       PP.ADT_PRICE ASC
END 
GO
