USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME               : XP_COM_BIZTRIP_RESV_TOTAL_CNT
■ DESCRIPTION            : BTMS 출장자 예약현황 카운트
■ INPUT PARAMETER        : 
■ OUTPUT PARAMETER       :    
■ EXEC                   : 
	XP_COM_BIZTRIP_RESV_TOTAL_CNT '92756', 100
■ MEMO                  : 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE            AUTHOR         DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-03-09      정지용         최초생성
   2016-05-31      이유라         출발자에 포함된 출장도 검색되도록 수정
   2016-07-08      박형만		  상세 상태별 갯수 포함 (모바일)
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BIZTRIP_RESV_TOTAL_CNT]
   	@AGT_CODE	VARCHAR(10),
	@EMP_SEQ	INT
AS 
BEGIN

--DECLARE @AGT_CODE	VARCHAR(10),@EMP_SEQ	INT
--SELECT @AGT_CODE = '92756',@EMP_SEQ =  102 
	--출장접수 = 0, 승인진행 = 1, 출장확정 = 2, 출장반려 = 9
	SELECT SUM(1) AS TOTAL_CNT ,
		SUM(CASE WHEN APPROVAL_STATE = 0 THEN 1 ELSE 0 END) AS REQUEST_CNT ,
		SUM(CASE WHEN APPROVAL_STATE = 1 THEN 1 ELSE 0 END) AS PROCESS_CNT ,
		SUM(CASE WHEN APPROVAL_STATE = 2 THEN 1 ELSE 0 END) AS CONFIRM_CNT ,
		SUM(CASE WHEN APPROVAL_STATE = 9 THEN 1 ELSE 0 END) AS REJECT_CNT 
	FROM COM_BIZTRIP_MASTER A WITH(NOLOCK)
	INNER JOIN COM_BIZTRIP_DETAIL B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE AND A.BT_CODE = B.BT_CODE
	INNER JOIN RES_MASTER_damo C WITH(NOLOCK) ON B.RES_CODE = C.RES_CODE AND C.RES_STATE < 7
	INNER JOIN PKG_DETAIL D WITH(NOLOCK) ON C.PRO_CODE = D.PRO_CODE
	INNER JOIN COM_EMPLOYEE E WITH(NOLOCK) ON A.AGT_CODE = E.AGT_CODE AND A.NEW_SEQ = E.EMP_SEQ
	WHERE  A.AGT_CODE = @AGT_CODE AND (
				A.NEW_SEQ = @EMP_SEQ OR EXISTS(
					SELECT 1 
					FROM RES_CUSTOMER_DAMO AA WITH(NOLOCK)
					INNER JOIN COM_EMPLOYEE_MATCHING BB WITH(NOLOCK) ON AA.CUS_NO = BB.CUS_NO 
					WHERE AA.RES_CODE = C.RES_CODE AND BB.AGT_CODE = A.AGT_CODE AND BB.EMP_SEQ = @EMP_SEQ
				)
			)
END
GO
