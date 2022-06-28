USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_CODE_MASTER_SELECT
■ DESCRIPTION				: CTI 코드 마스터 조회
■ INPUT PARAMETER			: 
	@@CATEGORY				: 카테고리구분코드
	@@USE_YN				: 사용여부
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_CODE_MASTER_SELECT 'CTI000', 'Y'

	CATEGORY CATEGORY_NAME                                      MAIN_CODE            MAIN_NAME                                          REFERENCE_CATEGORY REFERENCE_CODE       SORT   USE_YN REMARK                                                                                                                                                                                                   NEW_DATE                NEW_CODE EDT_DATE                EDT_CODE
-------- -------------------------------------------------- -------------------- -------------------------------------------------- ------------------ -------------------- ------ ------ -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----------------------- -------- ----------------------- --------
CTI000   사용여부                                               Y                    Yes                                                NULL               NULL                 1      Y      NULL                                                                                                                                                                                                     2014-10-13 00:00:00.000 1234567  2014-12-30 22:27:52.183 2013069
CTI000   사용여부                                               N                    No                                                 NULL               NULL                 2      Y      NULL                                                                                                                                                                                                     2014-10-13 00:00:00.000 1234567  2014-12-30 22:27:52.183 2013069


■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-09-12		곽병삼			최초생성
   2015-02-05		박노민			설명추가
================================================================================================================*/ 

CREATE PROCEDURE [cti].[SP_CTI_CODE_MASTER_SELECT]
--DECLARE
	@CATEGORY	VARCHAR(6),
	@USE_YN		VARCHAR(1)
AS

	--SET @CATEGORY = 'CTI000'
	--SET @USE_YN = 'Y'

SET NOCOUNT ON

	SELECT
		CATEGORY,
		CATEGORY_NAME,
		MAIN_CODE,
		MAIN_NAME,
		REFERENCE_CATEGORY,
		REFERENCE_CODE,
		SORT,
		USE_YN,
		REMARK,
		NEW_DATE,
		NEW_CODE,
		EDT_DATE,
		EDT_CODE
	FROM sirens.cti.CTI_CODE_MASTER
	WHERE CATEGORY = @CATEGORY
		AND USE_YN = @USE_YN
	ORDER BY SORT

SET NOCOUNT OFF
GO
