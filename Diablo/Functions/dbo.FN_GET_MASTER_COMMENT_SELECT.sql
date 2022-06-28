USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_GET_MASTER_COMMENT_SELECT
■ Description				: 마스터코드 고객평
■ Input Parameter			:                  
		@PRO_CODE			: 마스터코드
■ Output Parameter			: 
■ Output Value				: 
■ Exec						: 
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2019-12-11		프리랜서			최초생성
	2020-02-18		김성호			리턴형 변경 varchar(max) -> nvarchar(2500)
-------------------------------------------------------------------------------------------------*/ 
CREATE FUNCTION [dbo].[FN_GET_MASTER_COMMENT_SELECT]
(
	@MASTER_CODE VARCHAR(10)
)
RETURNS NVARCHAR(2500)
AS
BEGIN
	-- Declare the return variable here  
	DECLARE @COMMENT NVARCHAR(2500);  
	
	SELECT @COMMENT = (
	           SELECT TOP 1 CONVERT(VARCHAR(10) ,ISNULL(BO.GRADE ,5)) + '|^|' + ISNULL(NICKNAME ,'') + '|^|' + ISNULL(BO.CONTENTS ,'')
	           FROM   PRO_COMMENT BO WITH(NOLOCK) 
	                  
	                  --LEFT OUTER JOIN CUS_CUSTOMER  CC WITH(NOLOCK)  ON BO.CUS_NO  =  CC.CUS_NO
	           WHERE  BO.MASTER_CODE = @MASTER_CODE
	                  AND BO.GRADE > 3
	           ORDER BY
	                  BO.GRADE DESC
	                 ,BO.NEW_DATE DESC
	       );  
	
	SELECT @COMMENT = ISNULL(@COMMENT ,'|^||^|') 
	
	RETURN @COMMENT;
END
GO
