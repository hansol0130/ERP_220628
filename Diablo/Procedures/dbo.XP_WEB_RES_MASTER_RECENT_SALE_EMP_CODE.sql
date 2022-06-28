USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_WEB_RES_MASTER_RECENT_SALE_EMP_CODE
■ DESCRIPTION				: 조회_예약_최근접수자조회	
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec XP_WEB_RES_MASTER_RECENT_NEW_CODE 1 ,15 ,'1,3','0,1,2,3,4,5,6'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-11		박형만			 조회_예약_최근담당자조회	
================================================================================================================*/ 
CREATE PROC [dbo].[XP_WEB_RES_MASTER_RECENT_SALE_EMP_CODE] 
	@PRO_TYPE INT ,
	@PROVIDER  VARCHAR(20), 
	@SYSTEM_TYPE VARCHAR(20), 
	@RES_STATE  VARCHAR(20)
AS  
BEGIN

--DECLARE @PRO_TYPE INT ,
--	@PROVIDER  VARCHAR(20), 
--	@SYSTEM_TYPE VARCHAR(20), 
--	@RES_STATE  VARCHAR(20)
--SELECT @PRO_TYPE = 1 , @PROVIDER = 5 , @SYSTEM_TYPE = '1,3' , @RES_STATE = '0,1,2,3,4,5,6' 
	
DECLARE @STR_QUERY NVARCHAR(4000) 
DECLARE @STR_WHERE NVARCHAR(4000) 
DECLARE @PARAM NVARCHAR(4000) 
SET @STR_QUERY = ''
SET @STR_WHERE = ''
SET @PARAM =  N'@PRO_TYPE INT';

IF( ISNULL(@PROVIDER,'') <>  '')
BEGIN 
	SET @STR_WHERE = @STR_WHERE + 'AND A.PROVIDER IN ( '+@PROVIDER+' ) ' 
END 
IF( ISNULL(@SYSTEM_TYPE,'') <>  '')
BEGIN 
	SET @STR_WHERE = @STR_WHERE + 'AND A.SYSTEM_TYPE IN ( '+@SYSTEM_TYPE+' ) ' 
END 

IF( ISNULL(@RES_STATE,'') <>  '')
BEGIN 
	SET @STR_WHERE = @STR_WHERE + 'AND A.RES_STATE IN ( '+@RES_STATE+' ) ' 
END 

SET @STR_QUERY  = '
SELECT TOP 1 A.SALE_EMP_CODE ,  A.NEW_CODE ,  A.NEW_TEAM_NAME , 
ISNULL(B.INNER_NUMBER1,'''') + ''-''+   
ISNULL(B.INNER_NUMBER2,'''') + ''-''+ 
ISNULL(B.INNER_NUMBER3,'''')  AS  EMP_TEL , A.RES_CODE 

FROM RES_MASTER_damo A WITH(NOLOCK)
	INNER JOIN EMP_MASTER B WITH(NOLOCK) 
		ON A.SALE_EMP_CODE = B.EMP_CODE 
WHERE A.PRO_TYPE = @PRO_TYPE 
' +  @STR_WHERE + 
'AND A.NEW_DATE > DATEADD(M,-1,GETDATE()) --최근한달
--AND A.RES_STATE NOT IN (7,8,9)
ORDER BY A.NEW_DATE DESC'

PRINT @STR_QUERY 
EXEC SP_EXECUTESQL  @STR_QUERY ,  N'@PRO_TYPE INT' , @PRO_TYPE 
;

END 
 
GO
