USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PKG_MASTER_SELECT_PRODUCT_NAVER_MASTER
■ DESCRIPTION				: 2019 네이버 패키지 상품연동 마스터 조회 
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: SP_PKG_MASTER_SELECT_PRODUCT_NAVER_MASTER 'XPP3019'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
2019-03-18			박형만			
2019-05-16			박형만  등록된것만 조회 
================================================================================================================*/ 
CREATE  PROC [dbo].[SP_PKG_MASTER_SELECT_PRODUCT_NAVER_MASTER]
	@CODE VARCHAR(30)
AS
BEGIN

	--INSERT INTO NAVER_PKG_MASTER  (mstCode,mstTitle,imageUrl,createdDate,updateDate,updateChildCount,useYn)
	--VALUES ('EPP3017','【 안단테_느리게걷기】　[1급호텔UP][2대옵션포함] 프랑스, 스위스 그리고 이탈리아까지 모두 여유있는 12일',
	--'http://contents.verygoodtour.com/content/210/IT/0000/I01/image/966381_3.jpg', GETDATE() ,'',0 ,'Y' )

	--INSERT INTO NAVER_PKG_MASTER  (mstCode,mstTitle,imageUrl,createdDate,updateDate,updateChildCount,useYn)
	--VALUES ('APP1016','多둘러보세요 【다낭+호이안+후에】 다낭2박 그랜드 투란호텔 _5성급 5/6일_관광형 패키지',
	--'http://contents.verygoodtour.com/content/330/VN/0000/DAD/image/1830045_3.jpg', GETDATE() ,'',0 ,'Y' )

	
	--INSERT INTO NAVER_PKG_MASTER  (mstCode,mstTitle,imageUrl,createdDate,updateDate,updateChildCount,useYn)
	--VALUES ('XPP3019','【 안단테_느리게걷기】　[1급호텔UP][2대옵션포함] 프랑스, 스위스 그리고 이탈리아까지 모두 여유있는 12일',
	--'http://contents.verygoodtour.com/content/210/IT/0000/I01/image/966381_3.jpg', GETDATE() ,'',0 ,'Y' )

	--INSERT INTO NAVER_PKG_MASTER  (mstCode,mstTitle,imageUrl,createdDate,updateDate,updateChildCount,useYn)
	--VALUES ('JPP6677','[나혼자 가도 좋다. 이미 익숙하니까] 오사카/교토/고베/나라 3일 (1일자유)',
	--'http://contents.verygoodtour.com/content/310/JP/J33/OSA/image/310762_3.jpg', GETDATE() ,'',0 ,'Y' )


	IF ISNULL(@CODE,'') = ''
	BEGIN
		SELECT * FROM NAVER_PKG_MASTER 
		WHERE useYn ='Y' 
	END 
	ELSE 
	BEGIN
		SELECT * FROM NAVER_PKG_MASTER 
		WHERE useYn ='Y' 
		AND MSTCODE =@CODE 
	END 

	
	

END 
GO
