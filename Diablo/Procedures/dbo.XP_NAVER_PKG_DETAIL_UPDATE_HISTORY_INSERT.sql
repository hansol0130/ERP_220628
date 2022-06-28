USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*==================================================================================
	기본내용
====================================================================================
- SP 명 : XP_NAVER_PKG_DETAIL_UPDATE_HISTORY_INSERT
- 기 능 : 행사 수정 & 일괄 수정시 행사 수정기록을 입력 (개별) 


XP_NAVER_PKG_DETAIL_UPDATE_HISTORY_INSERT 'APP5010-191221KE' ,'UPDATE' ,'PRICESTATUS' ,'2013007'

XP_NAVER_PKG_DETAIL_UPDATE_HISTORY_INSERT 'EPP129-191230EY' ,'UPDATE' ,'PRICESTATUS' ,'2013007'

====================================================================================
	참고내용
====================================================================================
- 네이버 상품 연동 ( 가격 , 예약상태 매칭) 을 위함 
====================================================================================
	변경내역
====================================================================================
- 2019-12-18 박형만 최초생성
===================================================================================*/
CREATE PROC [dbo].[XP_NAVER_PKG_DETAIL_UPDATE_HISTORY_INSERT]
	@PRO_CODE VARCHAR(30),
	@UPDATE_CATE VARCHAR(20),
	@UPDATE_TARGET VARCHAR(20),
	@NEW_CODE VARCHAR(7) = '9999999'
AS 
BEGIN

--이미 등록된것 들어가지 않게 하는 로직 추가 
--DECLARE @PRO_CODE VARCHAR(30),@UPDATE_CATE VARCHAR(20),@UPDATE_TARGET VARCHAR(20),@NEW_CODE VARCHAR(7)
--SELECT @PRO_CODE ='APP9206-191218VJ' ,@UPDATE_CATE = 'UPDATE',  @UPDATE_TARGET = 'STATUS' , @NEW_CODE = '2013007'

		--SELECT mstcode ,childCode ,@UPDATE_CATE ,@UPDATE_TARGET,@NEW_CODE FROM  NAVEr_PKG_DETAIL A with(nolock) 
		--WHERE mstCode = SUBSTRING(@PRO_CODE,1,CHARINDEX('-',@PRO_CODE)-1)
		--AND  CHARINDEX(@PRO_CODE  ,childCode ) = 1 
		--AND NOT EXISTS ( 
		--	SELECT * FROM NAVER_PKG_DETAIL_UPDATE_HISTORY with(nolock)  
		--	WHERE CHK_DATE IS NULL 
		--	AND MASTER_CODE = A.mstCode 
		--	AND CHILD_CODE = A.childCode 
		--	AND UPDATE_TARGET = @UPDATE_TARGET 
		--	) 

	
	-- 네이버 상품 코드로 온경우 
	IF CHARINDEX('|',@PRO_CODE)  > 0 
	BEGIN
		INSERT INTO NAVER_PKG_DETAIL_UPDATE_HISTORY
		(	MASTER_CODE,
			CHILD_CODE,UPDATE_CATE,UPDATE_TARGET,NEW_CODE) 
	
		SELECT mstcode ,childCode ,@UPDATE_CATE ,@UPDATE_TARGET,@NEW_CODE FROM  NAVEr_PKG_DETAIL A with(nolock) 
		WHERE mstCode = SUBSTRING(@PRO_CODE,1,CHARINDEX('-',@PRO_CODE)-1)
		AND  CHILDCODE = @PRO_CODE 
		AND NOT EXISTS (  --이미 등록된 미처리 상품 들어가지 않게 하는 로직 추가  
			SELECT * FROM NAVER_PKG_DETAIL_UPDATE_HISTORY with(nolock) 
			WHERE CHK_DATE IS NULL 
			AND mstCode = A.mstCode 
			AND CHILD_CODE = @PRO_CODE 
			AND UPDATE_CATE = @UPDATE_CATE ) 

		
	END 
	ELSE -- 행사코드로 온경우 
	BEGIN
		INSERT INTO NAVER_PKG_DETAIL_UPDATE_HISTORY
		(	MASTER_CODE,
			CHILD_CODE,UPDATE_CATE,UPDATE_TARGET,NEW_CODE) 
	
		SELECT mstcode ,childCode ,@UPDATE_CATE ,@UPDATE_TARGET,@NEW_CODE FROM  NAVEr_PKG_DETAIL A with(nolock) 
		WHERE mstCode = SUBSTRING(@PRO_CODE,1,CHARINDEX('-',@PRO_CODE)-1)
		AND  CHARINDEX(@PRO_CODE  ,childCode ) = 1 
		AND NOT EXISTS (  --이미 등록된 미처리 상품 들어가지 않게 하는 로직 추가 
			SELECT * FROM NAVER_PKG_DETAIL_UPDATE_HISTORY with(nolock)  
			WHERE CHK_DATE IS NULL 
			AND MASTER_CODE = A.mstCode 
			AND CHILD_CODE = A.childCode 
			AND UPDATE_TARGET = @UPDATE_TARGET 
			) 
	END 


	--SELECT @@IDENTITY 

END 
GO
