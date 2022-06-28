USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_SAFE_INFO_SELECT
■ DESCRIPTION				: 안전정보 전체 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 	
	EXEC XP_SAFE_INFO_SELECT 'HUN,ICN,TPE, FJG, HEK'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-13		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_SAFE_INFO_SELECT]
	@CITYCODE_STRING VARCHAR(100)
AS 
BEGIN
	-- 여행금지제도
	EXEC XP_SAFE_INFO_BAN_SELECT '';

	-- 여행경보
	EXEC XP_SAFE_INFO_WARNING_SELECT @CITYCODE_STRING;

	-- 사건사고현황
	EXEC XP_SAFE_INFO_ACCIDENT_SELECT @CITYCODE_STRING;

	-- 현지 연락처
	EXEC XP_SAFE_INFO_CONTACT_SELECT @CITYCODE_STRING;

	-- 국가별 기본정보
	EXEC XP_SAFE_INFO_COUNTRY_BASIC_SELECT @CITYCODE_STRING;

END
GO
