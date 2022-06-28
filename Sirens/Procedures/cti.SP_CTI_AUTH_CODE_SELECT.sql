USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_AUTH_CODE_SELECT
■ DESCRIPTION				: 그룹권한코드 조회
■ INPUT PARAMETER			: 
	@CATEGORY					: 카테고리코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_AUTH_CODE_SELECT 'CTI103'

	MAIN_CODE            MAIN_NAME
-------------------- --------------------------------------------------
1                    일반상담원
2                    팀장그룹
3                    운영관리자
999                  시스템관리자

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-11		홍영택			최초생성
   2015-02-05		박노민			설명추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_AUTH_CODE_SELECT]
--DECLARE
	@CATEGORY	VARCHAR(20)

--SET @CATEGORY = 'CTI103'

AS

BEGIN
  SELECT 
    MAIN_CODE, 
    MAIN_NAME
  FROM Sirens.cti.CTI_CODE_MASTER
  WHERE CATEGORY = @CATEGORY
  AND USE_YN = 'Y'
  ORDER BY SORT
END
GO
