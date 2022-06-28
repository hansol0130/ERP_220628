USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: [XP_RES_CHARGE_SELECT]
■ DESCRIPTION				: 예약 담당자 찾기
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

SELECT * FROM EMP_TEAM 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-08-21		김남훈          최초생성
================================================================================================================*/ 

CREATE PROC [dbo].[XP_RES_CHARGE_SELECT]
	@RES_CODE			VARCHAR(20)  
AS 
BEGIN

		--상품 담당자 찾기
		SELECT emd.EMP_CODE
		      ,emd.KOR_NAME
		      ,et.TEAM_CODE
		      ,et.TEAM_NAME
		FROM   RES_MASTER_damo rmd WITH(NOLOCK)
		       INNER JOIN PKG_DETAIL pd WITH(NOLOCK)
		            ON  rmd.PRO_CODE = pd.PRO_CODE
		       INNER JOIN EMP_MASTER_damo emd WITH(NOLOCK)
		            ON  pd.NEW_CODE = emd.EMP_CODE
		       INNER JOIN EMP_TEAM et WITH(NOLOCK)
		            ON  emd.TEAM_CODE = et.TEAM_CODE
		WHERE  rmd.RES_CODE = @RES_CODE
		
END
GO
