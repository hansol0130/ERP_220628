USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Server					: 211.115.202.230
■ Database					: DIABLO
■ USP_Name					: XP_PKG_TC_PKG_ASG_SELECT
■ Description				: 
■ Input Parameter			:                  
	@MASTER_CODE	VARCHAR(10)
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						:  
■ Author					:  
■ Date						: 
■ Memo						: 
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
  2013-04-25			오인규 			  최초생성  
-------------------------------------------------------------------------------------------------*/ 
CREATE PROCEDURE [dbo].[XP_PKG_TC_PKG_ASG_SELECT]
(  
	@PRO_CODE      VARCHAR(20) 
)
AS

BEGIN
	DECLARE @MASTER_CODE VARCHAR(10)
	SELECT @MASTER_CODE = MASTER_CODE FROM dbo.PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE

	
	SELECT TOP 5 A.PRO_CODE
	      ,(
	           SELECT COUNT(C.RES_CODE)
	           FROM   dbo.Res_master_damo C WITH(NOLOCK)
	           WHERE  C.PRO_CODE = A.PRO_CODE
	       ) AS RESCOUNT
	      ,ISNULL(A.TC_NAME ,'') AS TC_NAME
	      ,ISNULL(B.OTR_STATE ,0) AS OTR_STATE
	FROM   dbo.PKG_DETAIL A WITH(NOLOCK)
	       LEFT OUTER JOIN OTR_MASTER B WITH(NOLOCK)
	            ON  A.PRO_CODE = B.PRO_CODE
	WHERE  A.MASTER_CODE = @MASTER_CODE
	       --AND   A.DEP_DATE > GETDATE()
	       AND ISNULL(B.OTR_STATE ,0) NOT IN (0 ,1)
	       
	       
END
GO
