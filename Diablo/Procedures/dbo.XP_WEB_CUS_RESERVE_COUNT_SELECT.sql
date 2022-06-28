USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_WEB_CUS_RESERVE_COUNT_SELECT
■ DESCRIPTION				: 마이페이지 회원 종합정보 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

exec XP_WEB_CUS_RESERVE_COUNT_SELECT @CUS_NO=4228549
exec XP_WEB_CUS_RESERVE_COUNT_SELECT @CUS_NO=5090013


■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-01		박형만			최초생성
   2014-06-17		박형만			노출여부 VIEW_YN 컬럼조건 추가
   2017-10-25		박형만			진행중예약= 미출발예약 -> 미도착예약 (편도는미출발)  
									모바일앱 SP_MOV2_RESERVE_LATEST_SELECT 와 건수가 같도록 유지 해야함 
================================================================================================================*/ 
--DROP PROC DBO.XP_WEB_CUS_RESERVE_COUNT_SELECT
CREATE PROC [dbo].[XP_WEB_CUS_RESERVE_COUNT_SELECT]
	@CUS_NO			INT  
AS 
BEGIN

	SELECT COUNT(*) AS RES_CNT
	FROM 
	(
		SELECT RES_CODE FROM (
			SELECT A.RES_CODE FROM RES_MASTER_damo A WITH(NOLOCK) 
			WHERE A.CUS_NO = @CUS_NO 
			AND A.RES_STATE NOT IN (7,8,9) --취소되지않은
			--AND A.DEP_DATE > GETDATE()  -- 미출발예약 
			AND IIF(A.ARR_DATE IS NULL, A.DEP_DATE, A.ARR_DATE) >= CONVERT(DATETIME,cast(DATEADD(D,1,getdate()) as date))  /*RES_MASTER 다음날 정각 이후 도착(편도는출발)예약만 */ 
			AND A.VIEW_YN ='Y' --노출여부
			UNION ALL 	
			SELECT A.RES_CODE  FROM RES_MASTER_damo A WITH(NOLOCK) 
				INNER JOIN RES_CUSTOMER_DAMO B WITH(NOLOCK) 
					ON A.RES_CODE = B.RES_CODE 
			WHERE B.CUS_NO = @CUS_NO 
			AND A.RES_STATE NOT IN (7,8,9) --취소되지않은
			--AND A.DEP_DATE > GETDATE()  -- 미출발예약 
			AND IIF(A.ARR_DATE IS NULL, A.DEP_DATE, A.ARR_DATE) >= CONVERT(DATETIME,cast(DATEADD(D,1,getdate()) as date))  /*RES_MASTER 다음날 정각 이후 도착(편도는출발)예약만 */ 
			AND B.RES_STATE = 0   --정상출발자
			AND B.VIEW_YN ='Y' --노출여부
		) TBL 
		GROUP BY RES_CODE 
	) TBL 
END 


GO
