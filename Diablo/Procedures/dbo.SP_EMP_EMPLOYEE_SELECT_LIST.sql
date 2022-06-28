USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*-------------------------------------------------------------------------------------------------
■ USP_Name					: SP_EMP_EMPLOYEE_SELECT_LIST  
■ Description				: 임직원 전체 검색
							: 
■ Exec						: EXEC SP_EMP_EMPLOYEE_SELECT_LIST 
■ Author					: 
■ Date						: 
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
2019-07-31			김남훈			임직원 전체 검색 	
-------------------------------------------------------------------------------------------------*/ 

CREATE PROC [dbo].[SP_EMP_EMPLOYEE_SELECT_LIST]
AS
BEGIN
SELECT ROW_NUMBER() OVER( ORDER BY EMP_CODE ASC) AS NUM 
,EMP_CODE 
,KOR_NAME 
,TEAM_CODE 
,( SELECT TOP 1 TEAM_NAME FROM EMP_TEAM B WHERE A.TEAM_CODE = B.TEAM_CODE ) AS TEAM_NAME,
	CASE WHEN POS_TYPE = 1 THEN '사원' 
		WHEN POS_TYPE = 2 THEN '계장' 
		WHEN POS_TYPE = 3 THEN '대리' 
		WHEN POS_TYPE = 4 THEN '과장' 
		WHEN POS_TYPE = 5 THEN '차장' 
		WHEN POS_TYPE = 6 THEN '부장' 
		WHEN POS_TYPE = 7 THEN '상무보' 
		WHEN POS_TYPE = 8 THEN '상무' 
		WHEN POS_TYPE = 9 THEN '고문' 
		WHEN POS_TYPE = 10 THEN '전무' 
		WHEN POS_TYPE = 11 THEN '대표' 
		WHEN POS_TYPE = 98 THEN '부회장' 
		WHEN POS_TYPE = 99 THEN '회장' 
		ELSE '-' END  AS POS_TYPE, 
 CONVERT(VARCHAR(10),A.JOIN_DATE,121) as JOIN_DATE ,
 CONVERT(VARCHAR(10), dbo.FN_CUS_GET_BIRTH_DATE(SOC_NUMBER1 , SOC_NUMBER2),121) as BIRTH_DATE, 
 A.SOC_NUMBER1, 
 CASE WHEN GENDER = 'M' THEN '남' 
	WHEN GENDER = 'F' THEN '여' ELSE '' END  AS GENDER , 
 CASE WHEN WORK_TYPE = 1 THEN '재직' 
	 WHEN WORK_TYPE = 5 THEN '퇴사' 
	 WHEN WORK_TYPE = 2 THEN   '휴직' ELSE '기타' END AS WORK_TYPE, 
CASE WHEN GROUP_TYPE = 1 THEN '영업' 
	WHEN GROUP_TYPE = 2 THEN '비영업' 
	WHEN GROUP_TYPE = 3 THEN '임원' 
	WHEN GROUP_TYPE = 4 THEN '지점' 
	WHEN GROUP_TYPE = 5 THEN '외부' 
	WHEN GROUP_TYPE = 9 THEN '제외' 
	ELSE '-' END AS GROUP_TYPE , 
	A.ZIP_CODE,
	A.ADDRESS1 , ADDRESS2 ,
	A.INNER_NUMBER3 ,
	ISNULL(A.INNER_NUMBER1,'') + '-'+ 
	ISNULL(A.INNER_NUMBER2,'') + '-'  +
	A.INNER_NUMBER3 AS INNER_NUMBER
FROM EMP_MASTER A 
WHERE  WORK_TYPE IN (1,2)   
AND EMP_CODE < 3000000
ORDER BY  A.EMP_CODE ASC ,  ( SELECT TOP 1 TEAM_NAME FROM EMP_TEAM B WHERE A.TEAM_CODE = B.TEAM_CODE ) 


END

GO
