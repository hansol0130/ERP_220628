USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



    
/*================================================================================================================    
■ USP_NAME     : [ZP_SELECT_ERR_LOG_CHART]    
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
   2020-06-10  유민석   최초생성    
================================================================================================================*/
CREATE PROC [dbo].[ZP_SELECT_ERR_LOG_CHART]
	@HomeErp	VARCHAR(10),
	@fromDate	DATETIME,
	@toDate		DATETIME
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @fromDate1	DATETIME
	       ,@toDate1	DATETIME
	       ,@fromDate2	DATETIME
	       ,@toDate2	DATETIME
	       ,@fromDate3	DATETIME
	       ,@toDate3	DATETIME       
		   ,@Days		INT
		   ,@Times		VARCHAR(100)
	
	SET @Days = DATEDIFF(DAY ,@fromDate ,@toDate)
	
	SET @fromDate1 = @fromDate
	SET @toDate1 = DATEADD(DAY ,1 ,@fromDate)
	
	SET @fromDate2 = @toDate1
	SET @toDate2 = DATEADD(DAY ,1 ,@fromDate2)
	
	SET @fromDate3 = @toDate2
	SET @toDate3 = DATEADD(DAY ,1 ,@fromDate3)
	
	SET @Times = '00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23'
	
	IF @HomeErp = 'Erp'
	BEGIN
	    SELECT FORMAT(@fromDate1 ,'yyyy-MM-dd ') + a.[Data] AS 'Log_Date'
	          ,ISNULL(COUNT(b.NEW_DATE) ,0) AS 'Log_Count'
	    FROM   Diablo.dbo.FN_SPLIT(@Times ,',') a
	           LEFT JOIN VGLog.dbo.SYS_ERP_LOG b
	                ON  a.[Data] = FORMAT(b.NEW_DATE ,'HH')
	                    AND b.NEW_DATE BETWEEN @fromDate1 AND @toDate1
	                    AND b.TITLE NOT IN ('고객병합','좌측메뉴반영', '좌측메뉴수정')
	    WHERE  @Days <= 3
	    GROUP BY
	           a.[Data]
	    
	    UNION ALL
	    
	    SELECT FORMAT(@fromDate2 ,'yyyy-MM-dd ') + a.[Data] AS 'Log_Date'
	          ,ISNULL(COUNT(b.NEW_DATE) ,0) AS 'Log_Count'
	    FROM   Diablo.dbo.FN_SPLIT(@Times ,',') a
	           LEFT JOIN VGLog.dbo.SYS_ERP_LOG b
	                ON  a.[Data] = FORMAT(b.NEW_DATE ,'HH')
	                    AND b.NEW_DATE BETWEEN @fromDate2 AND @toDate2
	                    AND b.TITLE NOT IN ('고객병합','좌측메뉴반영', '좌측메뉴수정')
	    WHERE  @Days >= 2
	    GROUP BY
	           a.[Data]
	    
	    UNION ALL
	    
	    SELECT FORMAT(@fromDate3 ,'yyyy-MM-dd ') + a.[Data] AS 'Log_Date'
	          ,ISNULL(COUNT(b.NEW_DATE) ,0) AS 'Log_Count'
	    FROM   Diablo.dbo.FN_SPLIT(@Times ,',') a
	           LEFT JOIN VGLog.dbo.SYS_ERP_LOG b
	                ON  a.[Data] = FORMAT(b.NEW_DATE ,'HH')
	                    AND b.NEW_DATE BETWEEN @fromDate3 AND @toDate3
	                    AND b.TITLE NOT IN ('고객병합','좌측메뉴반영', '좌측메뉴수정')
	    WHERE  @Days = 3
	    GROUP BY
	           a.[Data]
	END
	ELSE
	BEGIN
	    SELECT FORMAT(@fromDate1 ,'yyyy-MM-dd ') + a.[Data] AS 'Log_Date'
	          ,ISNULL(COUNT(b.NEW_DATE) ,0) AS 'Log_Count'
	    FROM   Diablo.dbo.FN_SPLIT(@Times ,',') a
	           LEFT JOIN VGLog.dbo.WEB_ERR_LOG b
	                ON  a.[Data] = FORMAT(b.NEW_DATE ,'HH')
	                    AND b.NEW_DATE BETWEEN @fromDate1 AND @toDate1
	    WHERE  @Days <= 3
	    GROUP BY
	           a.[Data]
	    
	    UNION ALL
	    
	    SELECT FORMAT(@fromDate2 ,'yyyy-MM-dd ') + a.[Data] AS 'Log_Date'
	          ,ISNULL(COUNT(b.NEW_DATE) ,0) AS 'Log_Count'
	    FROM   Diablo.dbo.FN_SPLIT(@Times ,',') a
	           LEFT JOIN VGLog.dbo.WEB_ERR_LOG b
	                ON  a.[Data] = FORMAT(b.NEW_DATE ,'HH')
	                    AND b.NEW_DATE BETWEEN @fromDate2 AND @toDate2
	    WHERE  @Days >= 2
	    GROUP BY
	           a.[Data]
	    
	    UNION ALL
	    
	    SELECT FORMAT(@fromDate3 ,'yyyy-MM-dd ') + a.[Data] AS 'Log_Date'
	          ,ISNULL(COUNT(b.NEW_DATE) ,0) AS 'Log_Count'
	    FROM   Diablo.dbo.FN_SPLIT(@Times ,',') a
	           LEFT JOIN VGLog.dbo.WEB_ERR_LOG b
	                ON  a.[Data] = FORMAT(b.NEW_DATE ,'HH')
	                    AND b.NEW_DATE BETWEEN @fromDate3 AND @toDate3
	    WHERE  @Days = 3
	    GROUP BY
	           a.[Data]
	END
END
	
GO
