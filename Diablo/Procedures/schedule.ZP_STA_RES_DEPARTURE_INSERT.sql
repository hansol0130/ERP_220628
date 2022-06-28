USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME			: [schedule].[ZP_STA_RES_DEPARTURE_INSERT]
■ DESCRIPTION		: 매일 행사별 예약자 수를 기록
■ INPUT PARAMETER	: 
■ OUTPUT PARAMETER	: 
■ EXEC				: 

EXEC [schedule].[ZP_STA_RES_DEPARTURE_INSERT] @RES_DATE = '2022-02-19'


------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2022-03-10		김성호			스케줄러 사용 쿼리 SP로 변경
================================================================================================================*/ 
CREATE PROC [schedule].[ZP_STA_RES_DEPARTURE_INSERT]
	@RES_DATE	DATE
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	SELECT @RES_DATE = ISNULL(@RES_DATE, CONVERT(DATE ,DATEADD(DD ,-1 ,GETDATE())))
	
	--DECLARE @RES_DATE DATE = CONVERT(DATE ,'2022-02-22');
	
	INSERT INTO STA_RES_DEPARTURE
	  (
	    PRO_CODE
	   ,MASTER_CODE
	   ,DEP_DATE
	   ,RES_DATE
	   ,EMP_CODE
	   ,TEAM_CODE
	   ,RES_COUNT
	  )
	SELECT PD.PRO_CODE
	      ,PD.MASTER_CODE
	      ,PD.DEP_DATE
	      ,@RES_DATE AS [RES_DATE]
	      ,EM.EMP_CODE
	      ,EM.TEAM_CODE
	      ,RM.RES_COUNT
	FROM   (
	           SELECT RM.PRO_CODE
	                 ,COUNT(*) RES_COUNT
	           FROM   dbo.RES_MASTER_damo RM WITH(NOLOCK)
	                  INNER JOIN dbo.RES_CUSTOMER_damo RC WITH(NOLOCK)
	                       ON  RM.RES_CODE = RC.RES_CODE
	           WHERE  RM.DEP_DATE >= @RES_DATE
	                  AND RM.RES_STATE <= 7
	                  AND RC.RES_STATE = 0
	           GROUP BY
	                  RM.PRO_CODE
	       ) RM
	       INNER JOIN dbo.PKG_DETAIL PD WITH(NOLOCK)
	            ON  RM.PRO_CODE = PD.PRO_CODE
	       INNER JOIN dbo.EMP_MASTER EM WITH(NOLOCK)
	            ON  PD.NEW_CODE = EM.EMP_CODE
	       LEFT JOIN dbo.STA_RES_DEPARTURE SRD WITH(NOLOCK)
	            ON  SRD.RES_DATE = @RES_DATE
	                AND SRD.DEP_DATE = PD.DEP_DATE
	                AND SRD.PRO_CODE = PD.PRO_CODE
	WHERE  SRD.PRO_CODE IS NULL
	
	SELECT @@ROWCOUNT
END

GO
