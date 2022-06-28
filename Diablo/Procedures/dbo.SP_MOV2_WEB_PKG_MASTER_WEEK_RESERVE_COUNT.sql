USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_WEB_PKG_MASTER_WEEK_RESERVE_COUNT
■ DESCRIPTION				: 검색_Mov2_일주일간예약수 내의 출발자수
■ INPUT PARAMETER			: MASTER_CODE
■ EXEC						: 
    -- exec SP_MOV2_WEB_PKG_MASTER_WEEK_RESERVE_COUNT 'APP5222'

■ MEMO						: 마스터상품 일주일간 예약수 (변경 : 예약수 내의 출발자수)
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-04		IBSOLUTION				최초생성
   2018-01-31		IBSOLUTION				예약건수내의 출발자수로 변경
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_WEB_PKG_MASTER_WEEK_RESERVE_COUNT]
	@MASTER_CODE		VARCHAR(20)
AS
BEGIN

		-- SELECT COUNT(*) AS CNT FROM RES_MASTER_DAMO A WITH(NOLOCK)
		-- 	INNER JOIN PKG_MASTER B WITH(NOLOCK)
		-- 		ON A.MASTER_CODE = B.MASTER_CODE
		-- 	WHERE A.MASTER_CODE = @MASTER_CODE
		-- 		AND A.NEW_DATE >= DATEADD(DD,-7,GETDATE()) 
		-- 		AND A.NEW_DATE <= GETDATE()
		-- 		AND A.VIEW_YN ='Y' --노출여부
		-- 		AND B.SHOW_YN ='Y'


		SELECT SUM(A1.TRIPPER) AS CNT 
		FROM (
			SELECT 
				( 
					SELECT COUNT(*) FROM RES_CUSTOMER_damo C WITH(NOLOCK)
					WHERE C.RES_CODE = A.RES_CODE 
						AND C.RES_STATE = 0 
						AND C.VIEW_YN = 'Y' 
				) AS TRIPPER
			FROM RES_MASTER_DAMO A WITH(NOLOCK)
				INNER JOIN PKG_MASTER B WITH(NOLOCK)
					ON A.MASTER_CODE = B.MASTER_CODE
				WHERE A.MASTER_CODE = @MASTER_CODE
					AND A.NEW_DATE >= DATEADD(DD,-7,GETDATE()) 
					AND A.NEW_DATE <= GETDATE()
					AND A.VIEW_YN ='Y' --노출여부
					AND B.SHOW_YN ='Y'
		) A1

END           
GO
