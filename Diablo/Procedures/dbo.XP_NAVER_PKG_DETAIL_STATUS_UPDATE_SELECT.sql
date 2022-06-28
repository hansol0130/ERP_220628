USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_NAVER_PKG_DETAIL_STATUS_UPDATE_SELECT
■ DESCRIPTION				: 네이버 상품 현재 상품상태,가격 조회 (갱신후 조회) 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: XP_NAVER_PKG_DETAIL_STATUS_UPDATE_SELECT 'EPP4390-190610|1' 
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
2019-11-15		박형만			갱신시에 updateDate 갱신하지 않음 
2019-12-20		박형만			임시테이블이용 sp 에서 결과받아서 수정    
================================================================================================================*/ 
CREATE PROC [dbo].[XP_NAVER_PKG_DETAIL_STATUS_UPDATE_SELECT]
	@CHILDCODE VARCHAR(30) 
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
	insert into #TMP_PRICE_STATUS
	exec XP_NAVER_PKG_DETAIL_STATUS_PREV_SELECT @CHILDCODE

--DECLARE @PRO_CODE VARCHAR(30) , 
--@PRICE_SEQ INT 

--DECLARE @CHILDCODE VARCHAR(30) 
--SET @CHILDCODE = 'EPP4390-190610|1' 

	--IF ISNULL(@CHILDCODE,'') <> '' AND ISNULL(@PRO_CODE,'') = ''
	--BEGIN
	--	SET @PRO_CODE = SUBSTRING(@CHILDCODE,1,CHARINDEX('|',@CHILDCODE)-1)
	--	SET @PRICe_SEQ = CONVERT(INT, SUBSTRING(@CHILDCODE,CHARINDEX('|',@CHILDCODE)+1,LEN(@CHILDCODE)-CHARINDEX('|',@CHILDCODE)) )
	--END 
	

	
--DECLARE @CHILDCODE VARCHAR(30)
--SET @CHILDCODE = 'CPP195-191014NO|1' 

--SELECT 
--A.mstCode , T.mstCode , 
---------------------------------------------------------------
--- 자상품 정보 갱신 (가격정보,좌석,예약상태,노출상태)------------------------------
------------------------------------------------------------
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
	INNER JOIN (

	--------------------------------------------------------------------------------------------
	-- XP_NAVER_PKG_DETAIL_STATUS_UPDATE_SELECT 
	SELECT * FROM #TMP_PRICE_STATUS
	--------------------------------------------------------------------------------------------
) T 
	ON A.CHILDCODE = T.CHILDCODE 
	-- 자상품 갱신 끝 


	-- 자상품 갱신 후에 조회 
	SELECT  
		mstCode,
		priceInfo_adult_basePrice,
		priceInfo_adult_surcharge,
		priceInfo_adult_total,
		priceInfo_adult_localPrice,
		priceInfo_adult_localCurrency,
		priceInfo_child_basePrice,
		priceInfo_child_surcharge,
		priceInfo_child_total,
		priceInfo_child_localPrice,
		priceInfo_child_localCurrency,
		priceInfo_infant_basePrice,
		priceInfo_infant_surcharge,
		priceInfo_infant_total,
		priceInfo_infant_localPrice,
		priceInfo_infant_localCurrency,
		priceInfo_infant_description,
		
		bookingStatus_seatAll,
		bookingStatus_seatMin,
		bookingStatus_seatNow,
		bookingStatus_bookingCode
	FROM NAVER_PKG_DETAIL  WITH(NOLOCK)
	WHERE childCode = @CHILDCODE 


END 
GO
