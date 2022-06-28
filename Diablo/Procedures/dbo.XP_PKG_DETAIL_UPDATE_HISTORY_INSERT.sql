USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*==================================================================================
	기본내용
====================================================================================
- SP 명 : XP_PKG_DETAIL_UPDATE_HISTORY_INSERT
- 기 능 : 행사 수정 & 일괄 수정시 행사 수정기록을 입력 (개별) 


XP_PKG_DETAIL_UPDATE_HISTORY_INSERT 'APA083-191203' ,'PKGLIST' ,'ALL' 

XP_PKG_DETAIL_UPDATE_HISTORY_INSERT 'APA083-191203' ,'PKGLIST' ,'ALL' ,'2013007'

====================================================================================
	참고내용
====================================================================================
- 네이버 상품 연동 ( 가격 , 예약상태 매칭) 을 위함 
====================================================================================
	변경내역
====================================================================================
- 2019-12-18 박형만 최초생성
===================================================================================*/
CREATE PROC [dbo].[XP_PKG_DETAIL_UPDATE_HISTORY_INSERT]
	@PRO_CODE VARCHAR(20),
	@UPDATE_TYPE VARCHAR(20),
	@UPDATE_TARGET VARCHAR(20),
	@NEW_CODE VARCHAR(7) = '9999999'
AS 
BEGIN
	
	INSERT INTO PKG_DETAIL_UPDATE_NAVER_HISTORY
	(	MASTER_CODE,
		PRO_CODE,UPDATE_TYPE,UPDATE_TARGET,NEW_CODE) 
	
	VALUES 
	(	SUBSTRING(@PRO_CODE,1,CHARINDEX('-',@PRO_CODE)-1),
		@PRO_CODE,@UPDATE_TYPE,@UPDATE_TARGET,@NEW_CODE )  
END 
GO
