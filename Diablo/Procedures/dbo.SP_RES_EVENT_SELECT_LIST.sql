USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*==================================================================================
	기본내	용
====================================================================================
- SP 명 : SP_RES_EVENT_SELECT_LIST
- 기 능 : 할인예약목록조회
====================================================================================
	참고내용
====================================================================================
- 예제
 EXEC SP_RES_EVENT_SELECT 0
====================================================================================
	변경내역
====================================================================================
- 2011-02-01 박형만 신규 작성 
===================================================================================*/
CREATE PROC [dbo].[SP_RES_EVENT_SELECT_LIST]
	@PRO_CODE	PRO_CODE
AS 
SET NOCOUNT ON 
BEGIN
	SELECT PRO_CODE, RES_CODE, EVT_SEQ, EVT_ADT_PRICE, NEW_CODE, NEW_DATE 
	FROM RES_EVENT WITH(NOLOCK)
	WHERE PRO_CODE = @PRO_CODE
	ORDER BY NEW_DATE ASC 
END 
GO
