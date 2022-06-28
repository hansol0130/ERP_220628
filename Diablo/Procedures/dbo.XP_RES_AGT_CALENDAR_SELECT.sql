USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Server					: 
■ Database					: DIABLO
■ USP_Name					: XP_RES_AGT_CALENDAR_SELECT
■ Description				: 예약 CALENDAR 조회 
■ Input Parameter			:                  
							@DATE_TYPE INT , -- 1:예약일 , 2:출발일
							@START_DATE DATETIME , 
							@END_DATE DATETIME ,
							@AGT_CODE VARCHAR(50),
							@EMP_CODE CHAR(7)
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC XP_RES_AGT_CALENDAR_SELECT 1,'2013-02-01','2013-03-01', '60002' , 'A130001'
■ Author					: 박형만  
■ Date						: 2013-02-20
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2013-02-20		박형만			최초생성  
-------------------------------------------------------------------------------------------------*/ 
CREATE PROCEDURE [dbo].[XP_RES_AGT_CALENDAR_SELECT]
( 
	@DATE_TYPE INT , -- 1:예약일 , 2:출발일
	@START_DATE DATETIME , 
	@END_DATE DATETIME ,
	@AGT_CODE VARCHAR(50),
	@NEW_CODE CHAR(7)
) 
AS 
BEGIN 

--DECLARE @DATE_TYPE INT ,
--@START_DATE DATETIME , 
--@END_DATE DATETIME ,
--@AGT_CODE VARCHAR(50),
--@NEW_CODE CHAR(7)
--SELECT 
--@DATE_TYPE =0 ,
--@START_DATE = '2013-02-01',
--@END_DATE = '2013-02-28',
--@AGT_CODE ='60002',
--@NEW_CODE ='A130001'

	IF @DATE_TYPE = 1
	BEGIN
		SELECT
			RES_CODE, PRO_CODE, 
			RES_STATE, DBO.FN_RES_GET_RES_COUNT(A.RES_CODE) AS CUS_CNT,
			dbo.FN_RES_GET_PAY_STATE(A.RES_CODE) AS PAY_STATE,  --0:미납,1:부분납,2:완납3	:과납
			CONVERT(VARCHAR(10), A.NEW_DATE, 120) AS BASIS_DATE,

			CONVERT(VARCHAR(10), A.NEW_DATE, 120) AS NEW_DATE,
			CONVERT(VARCHAR(10), A.DEP_DATE, 120) AS DEP_DATE,
			RES_NAME 
		FROM RES_MASTER_DAMO A WITH(NOLOCK)
		WHERE A.NEW_DATE BETWEEN @START_DATE AND @END_DATE   -- 예약일
		AND A.SALE_COM_CODE = @AGT_CODE 
		AND (A.SALE_EMP_CODE = @NEW_CODE OR ISNULL(@NEW_CODE,'') ='')
	END 
	ELSE IF @DATE_TYPE = 2
	BEGIN
		SELECT
			RES_CODE, PRO_CODE, 
			RES_STATE, DBO.FN_RES_GET_RES_COUNT(A.RES_CODE) AS CUS_CNT,
			dbo.FN_RES_GET_PAY_STATE(A.RES_CODE) AS PAY_STATE,  --0:미납,1:부분납,2:완납3	:과납
			CONVERT(VARCHAR(10), A.DEP_DATE, 120) AS BASIS_DATE,

			CONVERT(VARCHAR(10), A.NEW_DATE, 120) AS NEW_DATE,
			CONVERT(VARCHAR(10), A.DEP_DATE, 120) AS DEP_DATE,
			RES_NAME 
		FROM RES_MASTER_DAMO A WITH(NOLOCK)
		WHERE A.DEP_DATE BETWEEN @START_DATE AND @END_DATE  -- 출발일
		AND A.SALE_COM_CODE = @AGT_CODE 
		AND (A.SALE_EMP_CODE = @NEW_CODE OR ISNULL(@NEW_CODE,'') ='')
	END 


END 
GO
