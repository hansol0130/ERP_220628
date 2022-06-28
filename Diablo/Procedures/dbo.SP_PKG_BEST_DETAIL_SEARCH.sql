USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_PKG_BEST_DETAIL_SEARCH
- 기 능 : 베스트상품 직접조회
====================================================================================
	참고내용
====================================================================================
- 예제
EXEC SP_PKG_BEST_DETAIL_SEARCH 'VGT' , '900' , 12
EXEC SP_PKG_BEST_DETAIL_SEARCH 'VGT' , '900' , 22
====================================================================================
	변경내역
====================================================================================
- 2012-04-26 박형만 신규 작성 
===================================================================================*/
CREATE PROC [dbo].[SP_PKG_BEST_DETAIL_SEARCH]
	@SITE_CODE		VARCHAR(3),
	@MENU_CODE		VARCHAR(20),
	@SEC_SEQ		INT 
AS 
BEGIN 
	SELECT * FROM PKG_BEST_DETAIL A WITH(NOLOCK) 
	WHERE A.SITE_CODE = @SITE_CODE 
	AND A.MENU_CODE = @MENU_CODE 
	AND (A.SEC_SEQ = @SEC_SEQ OR @SEC_SEQ = 0)
	ORDER BY ORDER_NO ASC 
END 
GO
