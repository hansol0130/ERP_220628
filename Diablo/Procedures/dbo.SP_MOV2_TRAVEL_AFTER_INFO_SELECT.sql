USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_TRAVEL_AFTER_INFO_SELECT
■ DESCRIPTION				: 검색_여행후정보
■ INPUT PARAMETER			: CUS_NO, RES_CODE
■ EXEC						: 
    -- exec SP_MOV2_TRAVEL_AFTER_INFO_SELECT 8505125

■ MEMO						: 검색_여행후정보
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-08-17		오준욱(IBSOLUTION)		최초생성
   2017-11-15		박형만				
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_TRAVEL_AFTER_INFO_SELECT]
	@CUS_NO			INT,
	@RES_CODE		RES_CODE
AS
BEGIN
	--담당자
	DECLARE @EMP_CODE VARCHAR(10)
	SELECT @EMP_CODE = NEW_CODE FROM RES_MASTER_damo WHERE RES_CODE = @RES_CODE

	--총 포인트 
	DECLARE @POINT_PRICE INT 
	SELECT TOP 1 @POINT_PRICE = TOTAL_PRICE FROM CUS_POINT WITH(NOLOCK) WHERE CUS_NO = @CUS_NO
	ORDER BY POINT_NO DESC  

	--총 비행시간
	DECLARE @TRAVEL_COUNT INT 
	DECLARE @FLY_TIME INT 

	SELECT @TRAVEL_COUNT = count(*), 
		@FLY_TIME = Sum(datediff (SS, convert(DATETIME, convert(varchar(10), C.DEP_DEP_DATE, 120) + ' ' + C.DEP_DEP_TIME + ':00'), 
			convert(DATETIME, convert(varchar(10), C.DEP_ARR_DATE, 120) + ' ' + C.DEP_ARR_TIME + ':00')) + 
			datediff (SS, convert(DATETIME, convert(varchar(10), C.ARR_DEP_DATE, 120) + ' ' + C.ARR_DEP_TIME + ':00'), 
			convert(DATETIME, convert(varchar(10), C.ARR_ARR_DATE, 120) + ' ' + C.ARR_ARR_TIME + ':00')))  		
	 FROM RES_MASTER_damo A WITH(NOLOCK) 
		INNER JOIN PKG_DETAIL B WITH(NOLOCK)
		ON A.PRO_CODE = B.PRO_CODE
		LEFT JOIN PRO_TRANS_SEAT C WITH(NOLOCK)
		ON B.SEAT_CODE = C.SEAT_CODE
	WHERE CUS_NO = @CUS_NO AND RES_STATE IN ( 4,5,6 ) 

	--예약정보
	SELECT 
		@POINT_PRICE AS POINT_PRICE,
		@TRAVEL_COUNT AS TRAVEL_COUNT,
		@FLY_TIME AS FLY_TIME,
		A.PRO_CODE, A.PRICE_SEQ, A.MASTER_CODE,
		C.EMP_CODE, C.KOR_NAME, C.INNER_NUMBER1, C.INNER_NUMBER2, C.INNER_NUMBER3, 
		C.FAX_NUMBER1, C.FAX_NUMBER2, C.FAX_NUMBER3, C.EMAIL AS EMP_EMAIL, C.GREETING , 
		C.TEAM_CODE , DBO.XN_COM_GET_TEAM_NAME(C.EMP_CODE)  AS TEAM_NAME  ,
		( SELECT KEY_NUMBER FROM EMP_TEAM WITH(NOLOCK) WHERE TEAM_CODE = C.TEAM_CODE )  AS KEY_NUMBER
		FROM RES_MASTER_damo A WITH(NOLOCK) 
		LEFT JOIN EMP_MASTER C WITH(NOLOCK) 
			ON C.EMP_CODE = @EMP_CODE 
	WHERE RES_CODE = @RES_CODE

END           


GO
