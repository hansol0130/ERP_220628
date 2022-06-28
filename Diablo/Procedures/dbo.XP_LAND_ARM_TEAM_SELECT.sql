USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*================================================================================================================
■ USP_NAME					: XP_LAND_ARM_TEAM_SELECT
■ DESCRIPTION				: 랜드사 관리 알림사항 게시판 팀조회
■ INPUT PARAMETER			: 
	
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec XP_LAND_ARM_TEAM_SELECT 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-09		오인규			최초생성    
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_LAND_ARM_TEAM_SELECT]

AS  
BEGIN

DECLARE @VIEW_TYPE INT 
SET @VIEW_TYPE =1
	SELECT * FROM 
	(
		SELECT 
			TEAM_CODE,
			TEAM_EMP_CODE,
			TEAM_NAME,
			VIEW_YN,
			USE_YN,
			PARENT_CODE,
			AGT_CODE,
			ACC_SEQ,
			NEW_CODE,
			NEW_DATE,
			EDT_CODE,
			EDT_DATE,
			ORDER_SEQ,
			TEAM_TYPE,
			DBO.FN_CUS_GET_EMP_NAME(TEAM_EMP_CODE) AS [TEAM_EMP_NAME],
			CASE WHEN TEAM_CODE < 500 THEN '1' + TEAM_CODE ELSE '2000' END AS [FLAG]
		FROM EMP_TEAM WITH(NOLOCK)
		WHERE VIEW_YN = 'Y' 
		AND USE_YN = 'Y'
		--UNION ALL SELECT '1','','==============','Y','Y','','',NULL,'',GETDATE(),NULL,NULL,0,0,'',1
		--UNION ALL SELECT '2','','==============','Y','Y','','',NULL,'',GETDATE(),NULL,NULL,0,1,'',2
		--UNION ALL SELECT '3','','==============','Y','Y','','',NULL,'',GETDATE(),NULL,NULL,0,2,'',3
		--UNION ALL SELECT '4','','==============','Y','Y','','',NULL,'',GETDATE(),NULL,NULL,0,4,'',4
		--UNION ALL SELECT 
		--	TEAM_CODE,
		--	TEAM_EMP_CODE,
		--	TEAM_NAME,
		--	VIEW_YN,
		--	USE_YN,
		--	PARENT_CODE,
		--	AGT_CODE,
		--	ACC_SEQ,
		--	NEW_CODE,
		--	NEW_DATE,
		--	EDT_CODE,
		--	EDT_DATE,
		--	99999 AS ORDER_SEQ,
		--	4 AS TEAM_TYPE,
		--	DBO.FN_CUS_GET_EMP_NAME(TEAM_EMP_CODE) AS [TEAM_EMP_NAME],
		--	CASE WHEN TEAM_CODE < 500 THEN '1' + TEAM_CODE ELSE '2000' END AS [FLAG]
		--FROM EMP_TEAM WITH(NOLOCK)
		--WHERE VIEW_YN = 'N' 
		--AND USE_YN = 'Y'
	)
	 TBL 
	WHERE ( @VIEW_TYPE = 1 AND TEAM_TYPE IN ( 1 , 2 ) )  --  예약상품 , 영업 비영업까지 
	--OR ( @VIEW_TYPE = 2 AND TEAM_TYPE IN ( 1 , 2 , 3  ) ) -- 관리까지 (  정산,회계,통계)
	--OR ( @VIEW_TYPE = 3 AND TEAM_TYPE IN ( 1 , 2 , 3 , 4 ) ) -- 사용하지 않는 팀까지( 회계,통계)
	--OR ( @VIEW_TYPE = 4 AND TEAM_TYPE IN ( 0 , 1 , 2 ,3 ) ) -- 그룹웨어용( 임원진 포함 ) 
	--OR ( @VIEW_TYPE = 0 AND TEAM_TYPE IN ( 0 , 1 , 2 ,3 , 4  ) ) -- 전체 나옴 
	ORDER BY TEAM_TYPE, ORDER_SEQ, FLAG, TEAM_NAME 
END

GO
