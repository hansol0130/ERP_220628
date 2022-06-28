USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_WEB_RES_MASTER_SUMMARY_COUNT_SELECT
■ DESCRIPTION				: 회원의 예약 갯수 가져오기(예약자+출발자 중복제외)
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

exec XP_WEB_RES_MASTER_SUMMARY_COUNT_SELECT @CUS_NO=4228549

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-01		박형만			최초생성
   2014-05-20		박형만			비회원은 출발일 30일 지난것 표시 안함
   2014-06-17		박형만			노출여부 VIEW_YN 컬럼조건 추가
================================================================================================================*/ 
CREATE PROC [dbo].[XP_WEB_RES_MASTER_SUMMARY_COUNT_SELECT]
	@CUS_NO			INT  
AS 
BEGIN

	DECLARE @MEM_YN VARCHAR(1)  --정회원 여부 

	--회원정보 조회 
	IF EXISTS ( SELECT * FROM CUS_MEMBER  WITH(NOLOCK) WHERE CUS_NO = @CUS_NO AND CUS_STATE = 'Y'  )
	BEGIN
		SET @MEM_YN = 'Y' --정회원
	END 
	ELSE 
	BEGIN
		SET @MEM_YN = 'N' --비회원
	END 

	--회원의 예약자+출발자(예약자일시제외) 정보 조회 
	SELECT 
		SUM(1) TOTAL_CNT , 
		SUM(CASE WHEN A.PRO_TYPE = 1 THEN 1 ELSE 0 END)  AS PKG_CNT , 
		SUM(CASE WHEN A.PRO_TYPE = 2 THEN 1 ELSE 0 END)  AS AIR_CNT , 
		SUM(CASE WHEN A.PRO_TYPE = 3 THEN 1 ELSE 0 END)  AS HTL_CNT 
	FROM ( 
		SELECT A.RES_CODE FROM RES_MASTER_damo A WITH(NOLOCK) 
		WHERE A.CUS_NO = @CUS_NO 
		AND (( @MEM_YN = 'N' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE()) ) OR @MEM_YN = 'Y' )  --비회원 출발일 30일 지난것은 표시 안함 
		AND A.VIEW_YN ='Y' --노출여부
		UNION ALL 	
		SELECT A.RES_CODE  FROM RES_MASTER_damo A WITH(NOLOCK) 
			INNER JOIN RES_CUSTOMER_DAMO B WITH(NOLOCK) 
				ON A.RES_CODE = B.RES_CODE 
				AND A.CUS_NO <> B.CUS_NO 
		WHERE B.CUS_NO = @CUS_NO 
		AND B.RES_STATE = 0  --정상출발자만 
		AND (( @MEM_YN = 'N' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE()) ) OR @MEM_YN = 'Y' )  --비회원 출발일 30일 지난것은 표시 안함 
		AND B.VIEW_YN ='Y' --노출여부
		GROUP BY A.PRO_TYPE , A.RES_CODE 
	) TBL 
		INNER JOIN RES_MASTER_damo A WITH(NOLOCK)  
			ON TBL.RES_CODE = A.RES_CODE 
		
END 

GO
