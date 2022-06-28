USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BTMS_HOTEL_MAIL_INFO
■ DESCRIPTION				: BTMS 호텔 메일작성 정보
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	XP_COM_BTMS_HOTEL_MAIL_INFO 'RT1603318880'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR					DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-05-06		저스트고(강태영)		최초생성
================================================================================================================*/ 

CREATE PROC [dbo].[XP_COM_BTMS_HOTEL_MAIL_INFO]
@RES_CODE VARCHAR(20)

AS

BEGIN

	SELECT
		A.AGT_CODE,
		A.BT_CODE,
		B.AGT_ID,
		C.[FILE_NAME],
		D.CITY_CODE,
		E.KOR_NAME AS CITY_NAME,
		F.KOR_NAME AS NATION_NAME,
		D.HOTEL_NAME
	FROM COM_BIZTRIP_DETAIL A WITH(NOLOCK)
	INNER JOIN COM_MASTER B WITH(NOLOCK) ON B.AGT_CODE = A.AGT_CODE
	INNER JOIN COM_FILE C WITH(NOLOCK) ON C.AGT_CODE = A.AGT_CODE
	INNER JOIN RES_HTL_ROOM_MASTER D WITH(NOLOCK) ON D.RES_CODE = A.RES_CODE
	LEFT JOIN PUB_CITY E WITH(NOLOCK) ON E.CITY_CODE = D.CITY_CODE
	LEFT JOIN PUB_NATION F WITH(NOLOCK) ON F.NATION_CODE = E.NATION_CODE
	WHERE C.FILE_SEQ = 0 AND A.RES_CODE = @RES_CODE


END
GO
