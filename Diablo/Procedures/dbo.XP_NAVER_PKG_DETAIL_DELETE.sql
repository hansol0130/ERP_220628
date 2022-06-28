USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	기본내용
====================================================================================
- SP 명 : XP_NAVER_PKG_DETAIL_DELETE
- 기 능 : 네이버 전송 데이터 에서 해당 행사를삭제 한다 


XP_NAVER_PKG_DETAIL_DELETE 'APP5010-191221KE' ,'UPDATE' ,'PRICESTATUS' ,'2013007'

XP_NAVER_PKG_DETAIL_DELETE 'APA083-191203' ,'PKGLIST' ,'ALL' ,'2013007'

====================================================================================
	참고내용
====================================================================================
- 네이버 상품 연동 ( 가격 , 예약상태 매칭) 을 위함 
====================================================================================
	변경내역
====================================================================================
- 2019-12-18 박형만 최초생성
===================================================================================*/
CREATE PROC [dbo].[XP_NAVER_PKG_DETAIL_DELETE]
	@CHILDCODE VARCHAR(30)
AS 
BEGIN
	
	DELETE NAVER_PKG_DETAIL_SCH WHERE CHILDCODE = @CHILDCODE 
	DELETE NAVER_PKG_DETAIL_HOTEL WHERE CHILDCODE = @CHILDCODE 
	DELETE NAVER_PKG_DETAIL_OPTION WHERE CHILDCODE = @CHILDCODE 
	DELETE NAVER_PKG_DETAIL WHERE CHILDCODE = @CHILDCODE 

END 
GO
