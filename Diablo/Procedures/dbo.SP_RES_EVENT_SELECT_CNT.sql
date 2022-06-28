USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_RES_EVENT_SELECT_CNT
- 기 능 : 할인예약건수 조회 (취소,환불,이동 제외)
====================================================================================
	참고내용
====================================================================================
- 예제
 EXEC SP_RES_EVENT_SELECT_CNT 'CPP107-110211' , -1 
 EXEC SP_RES_EVENT_SELECT_CNT '' , 1
====================================================================================
	변경내역
====================================================================================
- 2011-02-01 박형만 신규 작성 
===================================================================================*/
CREATE PROC [dbo].[SP_RES_EVENT_SELECT_CNT]
	@PRO_CODE	PRO_CODE, -- NULL 전체 
	@EVT_SEQ	INT -- -1 전체 , 0 해당기간 , 0보다크면 해당이벤트
AS 
SET NOCOUNT ON 
BEGIN
	
	SELECT COUNT(* ) AS CNT 
	FROM PKG_EVENT AS PE  WITH(NOLOCK) 
		--INNER JOIN RES_EVENT AS RE WITH(NOLOCK)
		--	ON PE.PRO_CODE = RE.PRO_CODE 
			--AND GETDATE() BETWEEN PE.START_DATE AND PE.END_DATE
		INNER JOIN RES_MASTER_damo AS RM WITH(NOLOCK)
			ON PE.PRO_CODE = RM.PRO_CODE 
			AND RM.RES_STATE NOT IN (7,8,9) -- 취소이동환불 예약이 아닌것만 계산
			
	WHERE (ISNULL(@PRO_CODE,'')='' OR PE.PRO_CODE = @PRO_CODE) 
	AND (@EVT_SEQ = -1
	OR (@EVT_SEQ = 0 AND GETDATE() BETWEEN PE.START_DATE AND PE.END_DATE )
	OR (@EVT_SEQ > 0 AND PE.EVT_SEQ = @EVT_SEQ))
	
END 
GO
