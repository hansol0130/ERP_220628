USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


    
/*================================================================================================================    
■ USP_NAME				: [interface].[ZP_INF_AIR_DEP_INFO_SELECT]    
■ DESCRIPTION			: 조회 항공편의 출발 체크인카운터, 터미널, 탑승게이트 정보 조회 (인천공항 한정)    
■ INPUT PARAMETER		:
		@DEP_DTM		: 출발일			ex) 20210223084500
		@AIRLINE_CODE	: 항공사코드		ex) OZ 
		@FLIGHT_NO		: 항공번호		ex) 303

■ OUTPUT PARAMETER		:
■ EXEC					: 

		EXEC [interface].[ZP_INF_AIR_DEP_INFO_SELECT]
			 @DEP_DTM = '20210223084500',	-- 출발일 
			 @AIRLINE_CODE = 'OZ',			-- 항공사코드
			 @FLIGHT_NO = '303'				-- 항공편명
	
■ MEMO					:     
------------------------------------------------------------------------------------------------------------------    
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------    
   DATE				AUTHOR		DESCRIPTION               
------------------------------------------------------------------------------------------------------------------    
   2021-02-17		김성호		최초생성    
================================================================================================================*/     
CREATE PROCEDURE [interface].[ZP_INF_AIR_DEP_INFO_SELECT]
	@DEP_DTM		VARCHAR(14),	-- ex) 20201109105200
	@AIRLINE_CODE	VARCHAR(2),
	@FLIGHT_NO		VARCHAR(4)
AS     
BEGIN
    
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT AFD.DEP_DATE, AFD.AIRLINE_CODE, AFD.FLIGHT_NO, AFD.CHECK_IN, AFD.TERMINAL_ID, AFD.GATE_NUMBER
	FROM dbo.API_FLT_DEPARTURE AFD
	WHERE AFD.DEP_DATE = [interface].[ZN_PUB_STRING_TO_DATETIME](@DEP_DTM) AND AFD.AIRLINE_CODE = @AIRLINE_CODE AND AFD.FLIGHT_NO = @FLIGHT_NO
         
END
GO
