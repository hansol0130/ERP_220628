USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_EMP_TEAM_SELECT
■ DESCRIPTION				: 팀리스트 검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC SP_EMP_TEAM_SELECT 1

	 -- 하위팀 검색 시 사번 입력
	EXEC SP_EMP_TEAM_SELECT 2007044

------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR		DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
								최초생성
	2011-10-20					팀드롭다운 조회. 정렬 추가 
	2012-03-02					WITH(NOLOCK) 추가
	2019-04-03		김성호		팀하위조직 검색 추가
================================================================================================================*/
CREATE PROC [dbo].[SP_EMP_TEAM_SELECT] 
	@VIEW_TYPE INT
AS
BEGIN
	
	IF @VIEW_TYPE < 10
	BEGIN

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
			UNION ALL SELECT '1','','==============','Y','Y','','',NULL,'',GETDATE(),NULL,NULL,0,0,'',1
			UNION ALL SELECT '2','','==============','Y','Y','','',NULL,'',GETDATE(),NULL,NULL,0,1,'',2
			UNION ALL SELECT '3','','==============','Y','Y','','',NULL,'',GETDATE(),NULL,NULL,0,2,'',3
			UNION ALL SELECT '4','','==============','Y','Y','','',NULL,'',GETDATE(),NULL,NULL,0,4,'',4
			UNION ALL SELECT 
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
				99999 AS ORDER_SEQ,
				4 AS TEAM_TYPE,
				DBO.FN_CUS_GET_EMP_NAME(TEAM_EMP_CODE) AS [TEAM_EMP_NAME],
				CASE WHEN TEAM_CODE < 500 THEN '1' + TEAM_CODE ELSE '2000' END AS [FLAG]
			FROM EMP_TEAM WITH(NOLOCK)
			WHERE VIEW_YN = 'N' 
			AND USE_YN = 'Y'
	
		) TBL 
		WHERE ( @VIEW_TYPE = 1 AND TEAM_TYPE IN ( 1 , 2 ) )  --  예약상품 , 영업 비영업까지 
		OR ( @VIEW_TYPE = 2 AND TEAM_TYPE IN ( 1 , 2 , 3  ) ) -- 관리까지 (  정산,회계,통계)
		OR ( @VIEW_TYPE = 3 AND TEAM_TYPE IN ( 1 , 2 , 3 , 4 ) ) -- 사용하지 않는 팀까지( 회계,통계)
		OR ( @VIEW_TYPE = 4 AND TEAM_TYPE IN ( 0 , 1 , 2 ,3 ) ) -- 그룹웨어용( 임원진 포함 ) 
		OR ( @VIEW_TYPE = 0 AND TEAM_TYPE IN ( 0 , 1 , 2 ,3 , 4  ) ) -- 전체 나옴 
		ORDER BY TEAM_TYPE, ORDER_SEQ, FLAG, TEAM_NAME

	END
	ELSE
	BEGIN
	
		WITH LIST AS
		(
			SELECT A.*, 0 AS [LEVEL]
			FROM EMP_TEAM A WITH(NOLOCK) 
			WHERE A.TEAM_EMP_CODE = @VIEW_TYPE AND A.VIEW_YN = 'Y' AND A.USE_YN = 'Y'
			UNION ALL
			SELECT A.*, (B.LEVEL+ 1) AS [LEVEL]
			FROM EMP_TEAM A WITH(NOLOCK) 
			INNER JOIN LIST B ON B.TEAM_CODE = A.PARENT_CODE AND A.VIEW_YN = 'Y' AND A.USE_YN = 'Y'
		)
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
		FROM LIST A
		ORDER BY TEAM_TYPE, ORDER_SEQ, FLAG, TEAM_NAME

	END

END
GO
