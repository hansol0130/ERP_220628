USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_CTI_CONSULT_REPORT_TYPE_SELECT_LIST
- 기 능 : 함수_고객상담_통화통계_내용검색
====================================================================================
	참고내용
====================================================================================
- 예제 EXEC 
SP_CTI_CONSULT_REPORT_TYPE_SELECT_LIST @CTI_TYPE = -1  ,  
@START_DATE = '2012-05-01 00:00:00',
@END_DATE = '2012-05-20 00:00:00' , 
@TEAM_CODE = '529',
@EMP_CODE = '9999999'

====================================================================================
	변경내역
====================================================================================
- 2012-05-14 신규 작성 
===================================================================================*/
CREATE PROCEDURE [dbo].[SP_CTI_CONSULT_REPORT_TYPE_SELECT_LIST]
	@CTI_TYPE INT ,
	@TEAM_CODE TEAM_CODE ,
	@EMP_CODE EMP_CODE ,
	@START_DATE DATETIME,
	@END_DATE DATETIME
AS
BEGIN 

DECLARE @STR_QUERY NVARCHAR(4000)
DECLARE @STR_WHERE NVARCHAR(1000)
DECLARE @STR_PARAMS NVARCHAR(1000)
SET @STR_WHERE = ''

IF( @CTI_TYPE > -1 ) 
BEGIN
	SET @STR_WHERE = @STR_WHERE + '	AND	 A.CTI_TYPE = @CTI_TYPE ' 
END 
IF( ISNULL(@TEAM_CODE,'') <>'' ) 
BEGIN
	SET @STR_WHERE = @STR_WHERE + ' AND  A.TEAM_CODE = @TEAM_CODE ' 
END 
IF( ISNULL(@EMP_CODE,'') <>'' ) 
BEGIN
	SET @STR_WHERE = @STR_WHERE + ' AND  A.NEW_CODE = @EMP_CODE  ' 
END 
	
SET @STR_QUERY = N'
SELECT  
	(SELECT TEAM_NAME FROM EMP_TEAM WHERE TEAM_CODE = A.TEAM_CODE ) AS TEAM_NAME ,
	(SELECT KOR_NAME FROM EMP_MASTER_damo WHERE EMP_CODE = A.NEW_CODE ) AS EMP_NAME ,
	A.TEAM_CODE , 
	A.NEW_CODE , 
	SUM((CASE WHEN CTI_TYPE = 0 THEN 1 ELSE 0 END )) AS TYPE0_CNT,
	SUM((CASE WHEN CTI_TYPE = 1 THEN 1 ELSE 0 END )) AS TYPE1_CNT,
	SUM((CASE WHEN CTI_TYPE = 2 THEN 1 ELSE 0 END )) AS TYPE2_CNT,
	SUM((CASE WHEN CTI_TYPE = 3 THEN 1 ELSE 0 END )) AS TYPE3_CNT,
	SUM((CASE WHEN CTI_TYPE = 4 THEN 1 ELSE 0 END )) AS TYPE4_CNT,
	SUM((CASE WHEN CTI_TYPE = 5 THEN 1 ELSE 0 END )) AS TYPE5_CNT,
	SUM((CASE WHEN CTI_TYPE = 6 THEN 1 ELSE 0 END )) AS TYPE6_CNT,
	SUM((CASE WHEN CTI_TYPE = 7 THEN 1 ELSE 0 END )) AS TYPE7_CNT,
	SUM((CASE WHEN CTI_TYPE = 8 THEN 1 ELSE 0 END )) AS TYPE8_CNT,
	SUM((CASE WHEN CTI_TYPE = 9 THEN 1 ELSE 0 END )) AS TYPE9_CNT,
	SUM(1) AS TOTAL_TYPE_CNT,
	SUM(CONVERT(DECIMAL,DATEDIFF(SECOND , RCV_DATE , NEW_DATE ))) AS TOTAL_CTI_TIME
FROM CTI_CONSULT A WITH(NOLOCK)
WHERE RCV_DATE >= @START_DATE 
AND RCV_DATE < DATEADD(D,1,@END_DATE )
'+@STR_WHERE +' 
GROUP BY 
TEAM_CODE , 
NEW_CODE 
ORDER BY A.TEAM_CODE , A.NEW_CODE '

SET @STR_PARAMS =N'@CTI_TYPE INT 
	,@TEAM_CODE TEAM_CODE 
	,@EMP_CODE EMP_CODE 
	,@START_DATE DATETIME,@END_DATE DATETIME
'

--print @STR_QUERY

EXEC SP_EXECUTESQL @STR_QUERY ,@STR_PARAMS,@CTI_TYPE ,  
	@TEAM_CODE ,
	@EMP_CODE ,
	@START_DATE ,@END_DATE 
END 
GO
