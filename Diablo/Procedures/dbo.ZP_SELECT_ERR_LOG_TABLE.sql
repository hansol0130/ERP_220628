USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




    
/*================================================================================================================    
■ USP_NAME     : [ZP_SELECT_ERR_LOG_TABLE]    
■ DESCRIPTION    : 날짜, 시간별 에러 조회   
■ INPUT PARAMETER   :     
■ OUTPUT PARAMETER   :     
■ EXEC      :     
■ MEMO      :     
------------------------------------------------------------------------------------------------------------------    
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------    
   DATE    AUTHOR   DESCRIPTION               
------------------------------------------------------------------------------------------------------------------    
   2020-06-12  유민석   최초생성 
   2020-07-15  유민석   홈페이지 REF_URL , ERP TITLE 추가
   2020-07-17  유민석   ERP LOG_TYPE 추가     
================================================================================================================*/
CREATE PROC [dbo].[ZP_SELECT_ERR_LOG_TABLE]
	@HomeErp  VARCHAR(10),
	@fromDate DATETIME,
	@toDate   DATETIME
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	IF @HomeErp = 'Erp'
	BEGIN
	    SELECT FORMAT(NEW_DATE ,'yyyy-MM-dd HH:mm:ss') AS DATE
	          ,SEQ_NO AS SEQ
	          ,CATEGORY AS CATE
	          ,LOG_TYPE = CASE 
	                           WHEN (LOG_TYPE = 0) THEN 'None'
	                           WHEN (LOG_TYPE = 1) THEN 'Error'
	                           WHEN (LOG_TYPE = 2) THEN 'Warning'
	                           WHEN (LOG_TYPE = 3) THEN 'Information'
	                           WHEN (LOG_TYPE = 4) THEN 'CustomerMerge'
	                      END
	          ,PATH
	          ,URL
	          ,TITLE
	          ,BODY AS LOG_MSG
	          ,CLIENT_IP
	          ,SERVER_IP
	          ,TRACE
	          ,REQUEST
	          ,EMP_NAME
	          ,EMP_CODE
	    FROM   VGLog.dbo.SYS_ERP_LOG
	    WHERE  NEW_DATE BETWEEN @fromDate AND @toDate
	 	       AND TITLE NOT IN ('고객병합','좌측메뉴반영', '좌측메뉴수정')
	    ORDER BY
	           SEQ_NO DESC
	END
	ELSE
	BEGIN
	    SELECT FORMAT(NEW_DATE ,'yyyy-MM-dd HH:mm:ss') AS DATE
	          ,SEQ_NO AS SEQ
	          ,CATEGORY AS CATE
	          ,ROUTE_INFO AS PATH
	          ,URL
	          ,REF_URL
	          ,LOG_MSG
	          ,CLIENT_IP
	          ,SERVER_IP
	          ,TRACE
	          ,USER_AGENT
	          ,PARAM_DATA
	          ,POST_DATA
	          ,COOKIE_DATA
	          ,SESSION_DATA
	          ,CUS_NO
	          ,ERR_CODE
	    FROM   VGLog.dbo.WEB_ERR_LOG
	    WHERE  NEW_DATE BETWEEN @fromDate AND @toDate
	    ORDER BY
	           SEQ_NO DESC
	END
END
	
GO
