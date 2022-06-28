USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_ERP_RES_AIR_MASTER_SELECT
■ DESCRIPTION				: BTMS 항공 예약 마스터 정보 검색
■ INPUT PARAMETER			: 
	@RES_CODE				: 예약코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC XP_COM_ERP_RES_AIR_MASTER_SELECT 'RT1612095138';

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-14		김성호			최초생성
   2016-12-15		박형만			RES_AIR_DETAIL  의 스케쥴 마스터 불러오기 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_ERP_RES_AIR_MASTER_SELECT]
	@RES_CODE		VARCHAR(20)
AS 
BEGIN

	EXEC XP_COM_ERP_RES_MASTER_SELECT @RES_CODE;

	-- 예약 상세 & PNR
	SELECT A.RES_CODE, B.TTL_DATE, B.PNR_CODE1, B.PNR_CODE2, B.PNR_MODIFY_DATE, B.AIR_GDS, B.AIR_GDS2, B.INTER_YN, A.PNR_INFO ,
	DEP_DEP_DATE,DEP_ARR_DATE,DEP_DEP_TIME,DEP_ARR_TIME,ARR_DEP_TIME,
	DEP_DEP_AIRPORT_CODE,DEP_ARR_AIRPORT_CODE,
	ARR_DEP_DATE,ARR_ARR_DATE,ARR_ARR_TIME,
	ARR_DEP_AIRPORT_CODE,ARR_ARR_AIRPORT_CODE 

	FROM RES_MASTER_damo A WITH(NOLOCK)
	LEFT JOIN RES_AIR_DETAIL B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
	WHERE A.RES_CODE = @RES_CODE;

	-- 항공 세그정보
	SELECT 
		RES_CODE,		SEQ_NO,			DEP_AIRPORT_CODE,		ARR_AIRPORT_CODE,	
		DEP_CITY_CODE,	ARR_CITY_CODE,	AIRLINE_CODE,			SEAT_STATUS,
		FLIGHT,			NEW_DATE,		NEW_CODE,				START_DATE,
		END_DATE,		FLYING_TIME,	GROUND_TIME,			AIRLINE_PNR,
		BKG_CLASS,
		SEAT_STATUS,	OP_AIRLINE_CODE,DIRECTION
	FROM RES_SEGMENT WITH(NOLOCK)
	WHERE RES_CODE = @RES_CODE;

END 

GO
