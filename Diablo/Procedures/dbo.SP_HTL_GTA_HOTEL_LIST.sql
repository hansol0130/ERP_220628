USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_HTL_GTA_HOTEL_LIST]
	@XML Nvarchar(max)
AS
BEGIN

DECLARE @docHandle int

-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

EXEC sp_xml_preparedocument @docHandle OUTPUT, @xml;


WITH Hotel (ON_HotelCode, ON_HotelName, ON_HotelCity) AS
(
	SELECT 
		*
	FROM OPENXML(@DOCHANDLE, N'/Response/ResponseDetails/SearchHotelPriceResponse/HotelDetails/Hotel', 0)
	WITH
	(
		ON_HotelCode	varchar(10)	'./Item/@Code',
		ON_HotelName	nvarchar(50) './Item',
		ON_HotelCity	varchar(10) './City/@Code'
	)
)
SELECT 
	A.* ,
	B.SUP_CODE,
	B.MASTER_CODE,
	C.MASTER_NAME,
	C.CITY_CODE,
	-- 호텔 등급이 변경되면서 기존의 1자리 체계로 변화시켜주기 위한 로직
	-- 예전에는 1, 2, 3, 4, 5로 별이 표시되었으나 2009-10-29일 10,20,30,35,40,45,50 으로 변경
	-- 35, 45는 3, 4로 맵핑
	SUBSTRING(RIGHT('10' + CAST(ISNULL(C.HTL_GRADE, 10) AS VARCHAR), 2), 1, 1) AS HTL_GRADE,
	C.LOCATION_TYPE,
	(SELECT KOR_NAME FROM PUB_CITY WITH(NOLOCK) WHERE CITY_CODE = C.CITY_CODE) AS CITY_NAME,
	C.CNT_CODE,
	D.GPS_X,
	D.GPS_Y,
	D.SHORT_DESCRIPTION,
	-- 상품문의
	(SELECT COUNT(*) FROM HBS_DETAIL  WITH(NOLOCK) WHERE MASTER_SEQ = 2  AND CATEGORY_SEQ = 6 AND MASTER_CODE = B.MASTER_CODE AND DEL_YN = 'N') AS PRO_COUNT,
	-- 여행후기
	(SELECT COUNT(*) FROM HBS_DETAIL  WITH(NOLOCK) WHERE MASTER_SEQ = 1  AND CATEGORY_SEQ = 6 AND MASTER_CODE = B.MASTER_CODE AND DEL_YN = 'N') AS TOUR_COUNT,
	-- 여행평가 (미구현)
	(SELECT TOP 1 IMAGE FROM (
		SELECT CASE WHEN TYPE='외관' THEN 0 ELSE 1 END AS TYPE_NO, * FROM 
		GTA_IMAGELINK_20100215 
		WHERE CITY=A.ON_HOTELCITY AND ITEM=A.ON_HOTELCODE
		) Z
	ORDER BY TYPE_NO

	) AS IMAGE_NAME
FROM HOTEL A
INNER JOIN HTL_CONNECT B  WITH(NOLOCK) ON B.SUP_CODE = 'GTA' AND B.CONNECT_CODE = A.ON_HotelCode AND B.PROVIDER_CITY_CODE = A.ON_HotelCity AND B.SHOW_YN = 'Y'
INNER JOIN HTL_MASTER C  WITH(NOLOCK) ON C.MASTER_CODE = B.MASTER_CODE
LEFT OUTER JOIN INF_MASTER D  WITH(NOLOCK) ON D.CNT_CODE = C.CNT_CODE
WHERE B.SHOW_YN = 'Y'


EXEC sp_xml_removedocument @docHandle 	

END






GO
