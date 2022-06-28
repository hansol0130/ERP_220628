USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_NAVER_PKG_DETAIL_STATUS_UPDATE
■ DESCRIPTION				: 네이버 상품 현재 상품상태,가격갱신 참좋은데이터->네이버데이터
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: XP_NAVER_PKG_DETAIL_STATUS_UPDATE 'EPP4390-190610|1' 
	
■ MEMO						:  네이버 웹서비스 전송이 완료 되었을때 바꾼다 
					
	XP_NAVER_PKG_DETAIL_STATUS_PREV_SELECT 파라미터 컬럼이 바뀌면 오류 나므로 주의 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   
================================================================================================================*/ 
CREATE PROC [dbo].[XP_NAVER_PKG_DETAIL_STATUS_UPDATE]
	@CHILDCODE VARCHAR(30),
	@UPDATE_TYPE CHAR(1) = ''   -- 'P':가격만,'S'상태만 ,'' 전체다 
AS 
BEGIN  

	CREATE TABLE #TMP_PRICE_STATUS (
	mstCode varchar(20),
	childCode varchar(30),
	priceInfo_adult_basePrice	int,
	priceInfo_adult_surcharge	int	,
	priceInfo_adult_total	int ,
	priceInfo_adult_localPrice	int,
	priceInfo_adult_localCurrency	varchar(3),
	priceInfo_child_basePrice	int,
	priceInfo_child_surcharge	int,
	priceInfo_child_total	int,
	priceInfo_child_localPrice	int,
	priceInfo_child_localCurrency	varchar(3),
	priceInfo_infant_basePrice	int,
	priceInfo_infant_surcharge	int,
	priceInfo_infant_total	int	,
	priceInfo_infant_localPrice	int,
	priceInfo_infant_localCurrency	varchar	(3),
	priceInfo_infant_description	varchar(10),
	--priceInfo_serviceCharge_serviceName	varchar	no	50
	--priceInfo_serviceCharge_price	int	no	4
	--priceInfo_serviceCharge_currency	varchar	no	3
	bookingStatus_seatAll	int,
	bookingStatus_seatMin	int,
	bookingStatus_seatNow	int,
	bookingStatus_bookingCode	varchar(5) 
	) 
	
	INSERT INTO #TMP_PRICE_STATUS
	EXEC XP_NAVER_PKG_DETAIL_STATUS_PREV_SELECT @CHILDCODE  
	-- SELECT 컬럼 바뀌면 임시테이블도 바꿔야함, OPENROWSET 으로 가져오는게 있긴 한데 ,영향도 테스트가 안되어서 일단 이걸로

---------------------------------------------------------------
--- 자상품 정보 갱신 (가격정보,좌석,예약상태,노출상태)------------------------------
------------------------------------------------------------

IF ISNULL(@UPDATE_TYPE,'')= '' -- 가격+상태 전체 
BEGIN
	UPDATE A SET 
	--A.updatedDate = getdate() , DYNAMICE 은 수정일 갱신 안함 
	A.priceInfo_adult_basePrice		= T.priceInfo_adult_basePrice,
	A.priceInfo_adult_surcharge		= T.priceInfo_adult_surcharge,
	A.priceInfo_adult_total			= T.priceInfo_adult_total,
	A.priceInfo_adult_localPrice	= T.priceInfo_adult_localPrice,
	A.priceInfo_adult_localCurrency = T.priceInfo_adult_localCurrency,
	A.priceInfo_child_basePrice		= T.priceInfo_child_basePrice,
	A.priceInfo_child_surcharge		= T.priceInfo_child_surcharge,
	A.priceInfo_child_total			= T.priceInfo_child_total,
	A.priceInfo_child_localPrice	= T.priceInfo_child_localPrice,
	A.priceInfo_child_localCurrency = T.priceInfo_child_localCurrency,
	A.priceInfo_infant_basePrice	= T.priceInfo_infant_basePrice,
	A.priceInfo_infant_surcharge	= T.priceInfo_infant_surcharge,
	A.priceInfo_infant_total		= T.priceInfo_infant_total,
	A.priceInfo_infant_localPrice	= T.priceInfo_infant_localPrice,
	A.priceInfo_infant_localCurrency= T.priceInfo_infant_localCurrency,
	A.priceInfo_infant_description	= T.priceInfo_infant_description,
		
	A.bookingStatus_seatAll = T.bookingStatus_seatAll,
	A.bookingStatus_seatMin = T.bookingStatus_seatMin,
	A.bookingStatus_seatNow = T.bookingStatus_seatNow,
	A.bookingStatus_bookingCode = T.bookingStatus_bookingCode 

	FROM NAVER_PKG_DETAIL A 
		INNER JOIN #TMP_PRICE_STATUS T 
			ON A.CHILDCODE = T.CHILDCODE 
END 
ELSE IF ISNULL(@UPDATE_TYPE,'') = 'P'  -- 가격만 
BEGIN
	UPDATE A SET 
	A.priceInfo_adult_basePrice		= T.priceInfo_adult_basePrice,
	A.priceInfo_adult_surcharge		= T.priceInfo_adult_surcharge,
	A.priceInfo_adult_total			= T.priceInfo_adult_total,
	A.priceInfo_adult_localPrice	= T.priceInfo_adult_localPrice,
	A.priceInfo_adult_localCurrency = T.priceInfo_adult_localCurrency,
	A.priceInfo_child_basePrice		= T.priceInfo_child_basePrice,
	A.priceInfo_child_surcharge		= T.priceInfo_child_surcharge,
	A.priceInfo_child_total			= T.priceInfo_child_total,
	A.priceInfo_child_localPrice	= T.priceInfo_child_localPrice,
	A.priceInfo_child_localCurrency = T.priceInfo_child_localCurrency,
	A.priceInfo_infant_basePrice	= T.priceInfo_infant_basePrice,
	A.priceInfo_infant_surcharge	= T.priceInfo_infant_surcharge,
	A.priceInfo_infant_total		= T.priceInfo_infant_total,
	A.priceInfo_infant_localPrice	= T.priceInfo_infant_localPrice,
	A.priceInfo_infant_localCurrency= T.priceInfo_infant_localCurrency,
	A.priceInfo_infant_description	= T.priceInfo_infant_description
	FROM NAVER_PKG_DETAIL A 
		INNER JOIN #TMP_PRICE_STATUS T 
			ON A.CHILDCODE = T.CHILDCODE 
END 
ELSE IF ISNULL(@UPDATE_TYPE,'') = 'S' -- 상태만 
	UPDATE A SET 
	A.bookingStatus_seatAll = T.bookingStatus_seatAll,
	A.bookingStatus_seatMin = T.bookingStatus_seatMin,
	A.bookingStatus_seatNow = T.bookingStatus_seatNow,
	A.bookingStatus_bookingCode = T.bookingStatus_bookingCode 
	FROM NAVER_PKG_DETAIL A 
		INNER JOIN #TMP_PRICE_STATUS T 
			ON A.CHILDCODE = T.CHILDCODE 
END 


GO
