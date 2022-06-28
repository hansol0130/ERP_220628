USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_CTI_CONSULT_REPORT_TIME_SELECT_LIST
- 기 능 : 함수_고객상담_통화통계_시간대별검색
====================================================================================
	참고내용
====================================================================================
- 예제 EXEC 
SP_CTI_CONSULT_REPORT_TIME_SELECT_LIST @CTI_TYPE = -1  ,  
@START_DATE = '2012-05-01 00:00:00',
@END_DATE = '2012-05-20 00:00:00' , 
@TEAM_CODE = '529',
@EMP_CODE = '9999999'

====================================================================================
	변경내역
====================================================================================
- 2012-05-14 신규 작성 
===================================================================================*/
CREATE PROCEDURE [dbo].[SP_CTI_CONSULT_REPORT_TIME_SELECT_LIST]
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
HOUR ,  COUNT(CTI_HOUR) AS HOUR_CNT , FLAG 

FROM (
	SELECT 8 AS HOUR ,0 AS FLAG 
	UNION ALL SELECT 9,1
	UNION ALL SELECT 10,2
	UNION ALL SELECT 11,3
	UNION ALL SELECT 12,4
	UNION ALL SELECT 13,5
	UNION ALL SELECT 14,6
	UNION ALL SELECT 15,7
	UNION ALL SELECT 16,8
	UNION ALL SELECT 17,9
	UNION ALL SELECT 18,10
	UNION ALL SELECT 19,11
	) A
LEFT JOIN 
(
	SELECT 
		CASE WHEN CTI_HOUR < 9 THEN 8 
			WHEN CTI_HOUR > 18 THEN 19 
			ELSE CTI_HOUR END AS CTI_HOUR  
	FROM 
	(
		SELECT 
			CONVERT(INT,SUBSTRING( CONVERT(VARCHAR(100),RCV_DATE ,121) , 12 , 2 )) AS CTI_HOUR 
		FROM CTI_CONSULT A WITH(NOLOCK)
		WHERE RCV_DATE >= @START_DATE 
		AND RCV_DATE < DATEADD(D,1,@END_DATE )
		
		'+@STR_WHERE +' 
	) X 
) B 
	ON A.HOUR = B.CTI_HOUR
 
GROUP BY HOUR , FLAG
' 
SET @STR_PARAMS =N'@CTI_TYPE INT 
	,@TEAM_CODE TEAM_CODE 
	,@EMP_CODE EMP_CODE 
	,@START_DATE DATETIME,@END_DATE DATETIME
'
EXEC SP_EXECUTESQL @STR_QUERY ,@STR_PARAMS,@CTI_TYPE ,  
	@TEAM_CODE ,
	@EMP_CODE ,
	@START_DATE ,@END_DATE 
END 
GO
