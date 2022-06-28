USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_WEB_PKG_DETAIL_POINT_SELECT
■ DESCRIPTION				: 행사 핵심정보 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
	@PRO_CODE VARCHAR(20)	: 행사코드
	@PRICE_SEQ INT			: 가격순번
■ EXEC						: 
exec XP_WEB_PKG_DETAIL_POINT_SELECT @PRO_CODE='XXX201-140901',@PRICE_SEQ=1
select top 1 * from pkg_detail
select top 1 * from pkg_master
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-07-25		정지용			최초생성
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_WEB_PKG_DETAIL_POINT_SELECT]
(
	@PRO_CODE	VARCHAR(20),
	@PRICE_SEQ	INT
)
AS  
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	/*
	DECLARE	@PRO_CODE	VARCHAR(20)
	DECLARE	@PRICE_SEQ	INT

	SET @PRO_CODE = 'XXX201-140901'
	SET @PRICE_SEQ = 1
	*/
	IF @PRICE_SEQ IS NULL OR @PRICE_SEQ = 0
	BEGIN
		SELECT @PRICE_SEQ = MIN(PRICE_SEQ) FROM PKG_DETAIL_PRICE WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE
	END

	-- 상품정보
	SELECT
		  A.MASTER_CODE
		, A.PRO_CODE
		, A.PRO_NAME
		, A.DEP_DATE
		, A.ARR_DATE
		, A.MIN_COUNT
		, A.PKG_CONTRACT
		, A.DEP_CFM_YN
		, A.GUIDE_YN
		, A.AIR_CFM_YN
		, A.ROOM_CFM_YN
		, A.SCHEDULE_CFM_YN
		, A.PRICE_CFM_YN
		, A.TC_YN
		, A.UNITE_YN
		, B.SAFE_DATE
		, B.SAFE_REMARK_1
		, B.SAFE_REMARK_2
		, B.SAFE_REMARK_3
	FROM PKG_DETAIL A WITH(NOLOCK)
	INNER JOIN PKG_MASTER B WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE
	WHERE A.PRO_CODE = @PRO_CODE AND A.SHOW_YN = 'Y'

	-- 가격정보
	SELECT 
		A.PRO_CODE, A.PRICE_SEQ, A.PRICE_NAME, A.SEASON, A.SCH_SEQ, A.PKG_INCLUDE, A.PKG_NOT_INCLUDE, A.SGL_PRICE, A.CUR_TYPE, A.EXC_RATE, A.FLOATING_YN, A.POINT_RATE, A.POINT_PRICE, A.POINT_YN,
		A.ADT_PRICE, A.CHD_PRICE, A.INF_PRICE,
		ISNULL(B.ADT_SALE_PRICE, 0) AS ADT_SALE_PRICE,
		ISNULL(B.CHD_SALE_PRICE, 0) AS CHD_SALE_PRICE,
		ISNULL(B.INF_SALE_PRICE, 0) AS INF_SALE_PRICE,
		ISNULL(B.ADT_SALE_QCHARGE, 0) AS ADT_SALE_QCHARGE,
		ISNULL(B.CHD_SALE_QCHARGE, 0) AS CHD_SALE_QCHARGE,
		ISNULL(B.INF_SALE_QCHARGE, 0) AS INF_SALE_QCHARGE,
		B.SALE_QCHARGE_DATE,	
		(CASE ISNULL(A.POINT_YN, '0') WHEN '0' THEN 'N' ELSE 'Y' END) AS POINT_CREATE_YN 
	FROM PKG_DETAIL_PRICE A WITH(NOLOCK)
	INNER JOIN XN_PKG_DETAIL_PRICE(@PRO_CODE, @PRICE_SEQ) B ON A.PRO_CODE = B.PRO_CODE AND A.PRICE_SEQ = B.PRICE_SEQ
	WHERE A.PRO_CODE = @PRO_CODE AND A.PRICE_SEQ = @PRICE_SEQ

	-- 공동경비정보
	SELECT * fROM XN_PKG_DETAIL_PRICE_GROUP_COST_SUMMARY(@PRO_CODE, @PRICE_SEQ)

	-- 쇼핑정보
	SELECT PRO_CODE,SHOP_SEQ,SHOP_NAME,SHOP_PLACE,SHOP_TIME,SHOP_REMARK FROM PKG_DETAIL_SHOPPING WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE

END
GO
