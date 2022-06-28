USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_BIZTRIP_MASTER_RESETTING
■ DESCRIPTION				: 출장예약 수정시 출장마스터의 시작일 및 시작 도시 업데이트 
■ INPUT PARAMETER			: 

	XP_COM_BIZTRIP_MASTER_RESETTING '', 'RT1603228872'
	XP_COM_BIZTRIP_MASTER_RESETTING ''

■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-03-22		박형만			최초생성    
   2016-04-20		박형만			마지막 예약일 최종 업데이트  
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BIZTRIP_MASTER_RESETTING]
(
	@BT_CODE  VARCHAR(20),
	@RES_CODE RES_CODE = NULL 
) 
AS 
BEGIN

	
	DECLARE @PRO_CODE VARCHAR(30)

	--BT코드 있을때 
	IF( ISNULL(@BT_CODE,'') <> '')
	BEGIN
		-- 행사코드 구함
		SELECT TOP 1 @PRO_CODE = PRO_CODE  FROM COM_BIZTRIP_MASTER
		WHERE BT_CODE = @BT_CODE 
	END 
	--예약번호 있을때 
	IF( ISNULL(@RES_CODE,'') <> '')
	BEGIN
		--BT 코드와 행사코드 구함 
		SELECT TOP 1 @BT_CODE = B.BT_CODE , @PRO_CODE = B.PRO_CODE  FROM COM_BIZTRIP_DETAIL A 
			INNER JOIN COM_BIZTRIP_MASTER B 
				ON A.BT_CODE = B.BT_CODE
		WHERE RES_CODE = @RES_CODE 
	END 

	--(행사와 출장마스터는 1:1 관계)
	--행사코드 기준으로 하위 예약 가져옴
	IF @PRO_CODE IS NOT NULL 
	BEGIN
		
		--시작,종료,입금마감일 구함
		DECLARE @BT_START_DATE DATETIME 
		DECLARE @BT_END_DATE DATETIME 
		DECLARE @BT_LAST_NEW_DATE DATETIME 
		DECLARE @BT_TIME_LIMIT DATETIME 
		DECLARE @BT_CITY_CODE VARCHAR(3)

		SELECT @BT_START_DATE = MIN(DEP_DATE)
			, @BT_END_DATE = MAX(ARR_DATE)
			, @BT_TIME_LIMIT = MIN(LAST_PAY_DATE) --  다가오는 최근 입금마감일
			, @BT_LAST_NEW_DATE = MAX(NEW_DATE) --  최종예약일
		FROM RES_MASTER_damo 
		WHERE PRO_CODE = @PRO_CODE 
		AND RES_STATE NOT IN (7,8,9) 

		IF @BT_START_DATE IS NOT NULL 
		BEGIN
			--최초일정의 도시 
			SELECT TOP 1 @BT_CITY_CODE = 
			(CASE WHEN A.PRO_TYPE = 2 THEN (SELECT CITY_CODE FROM PUB_AIRPORT WHERE AIRPORT_CODE =  B.DEP_ARR_AIRPORT_CODE )
				WHEN A.PRO_TYPE = 3 THEN C.CITY_CODE 
				END ) 
			FROM RES_MASTER_DAMO A 
				LEFT JOIN RES_AIR_DETAIL B 
					ON A.RES_CODE = B.RES_CODE 
				LEFT JOIN RES_HTL_ROOM_MASTER C
					ON A.RES_CODE = C.RES_CODE 
			WHERE A.RES_STATE NOT IN ( 7,8,9 ) 
			AND A.PRO_CODE = @PRO_CODE
			ORDER BY DEP_DATE ASC , PRO_TYPE ASC , A.NEW_DATE ASC  -- 패키지,항공,호텔,처음예약순

			--출장 마스터를 업데이트함,
			--예약은 행사코드 기준으로 업데이트함
			UPDATE COM_BIZTRIP_MASTER
			SET BT_START_DATE = ISNULL(@BT_START_DATE , BT_START_DATE)
				,BT_END_DATE = 	ISNULL(@BT_END_DATE , BT_END_DATE)
				,BT_TIME_LIMIT = ISNULL(@BT_TIME_LIMIT , BT_TIME_LIMIT)
				,BT_CITY_CODE = ISNULL(@BT_CITY_CODE , BT_CITY_CODE) 
				,LAST_NEW_DATE =  ISNULL(@BT_LAST_NEW_DATE , NEW_DATE) -- 마지막 예약일 
			WHERE BT_CODE = @BT_CODE 
		END 

	END 
	
END 
GO
