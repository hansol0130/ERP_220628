USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
-- 2012-03-02 READ UNCOMMITTED 설정
*/
CREATE proc [dbo].[SP_COM_MENU_LIST]        
@EMP_CODE char(7),        
@MENU_GROUP_CODE varchar(5)      
as       

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 
IF @EMP_CODE is null    
BEGIN    
	WITH STEP_PUB_MENU (MENU_GROUP_CODE, PARENT_CODE, MENU_CODE, MENU_NAME, MENU_DEPTH, SORT_CODE, SORT_NAME, SORT, MENU_LINK, SHOW_YN, MENU_ORDER) AS  
	(
		SELECT
			A.MENU_GROUP_CODE,
			A.PARENT_CODE,
			A.MENU_CODE,
			A.MENU_NAME,
			0,
			A.SORT_CODE,
			(SELECT MENU_NAME FROM PUB_MENU WHERE MENU_GROUP_CODE = A.MENU_GROUP_CODE AND MENU_CODE = A.SORT_CODE) AS [SORT_NAME],
			CONVERT(VARCHAR(255), (A.MENU_GROUP_CODE + CONVERT(VARCHAR(3), A.MENU_CODE) +  A.MENU_NAME)) AS [SORT],
			A.MENU_LINK,
			A.SHOW_YN,
			A.MENU_ORDER
		FROM PUB_MENU A
		WHERE PARENT_CODE IS NULL AND MENU_GROUP_CODE = @MENU_GROUP_CODE
		UNION ALL
		SELECT
			A.MENU_GROUP_CODE,
			A.PARENT_CODE,
			A.MENU_CODE,
			A.MENU_NAME,
			B.MENU_DEPTH + 1,
			A.SORT_CODE,
			B.SORT_NAME,
			CONVERT (VARCHAR(255), RTRIM(B.SORT) + '| ' + A.MENU_NAME),
			A.MENU_LINK,
			A.SHOW_YN,
			A.MENU_ORDER
		FROM PUB_MENU A
		INNER JOIN STEP_PUB_MENU B ON A.MENU_GROUP_CODE = B.MENU_GROUP_CODE AND A.PARENT_CODE = B.MENU_CODE
	)
	SELECT
	--	A.SORT,
		A.MENU_GROUP_CODE,
		A.PARENT_CODE,  
		A.MENU_CODE,  
		A.MENU_NAME,  
		A.MENU_DEPTH,  
		A.SORT_CODE,  
		A.SORT_NAME,  
		A.MENU_LINK,  
		B.EMP_CODE,  
		B.SELECT_YN,  
		B.INSERT_YN,  
		B.UPDATE_YN,  
		B.DELETE_YN,  
		B.MASTER_YN ,  
		A.SHOW_YN,  
		A.MENU_ORDER  
	FROM STEP_PUB_MENU A  
	INNER JOIN PUB_GRANT B ON A.MENU_GROUP_CODE = B.MENU_GROUP_CODE AND A.MENU_CODE = B.MENU_CODE AND B.SELECT_YN='Y' AND A.SHOW_YN='Y'  
	ORDER BY A.MENU_GROUP_CODE, B.MENU_CODE, A.SORT, A.MENU_DEPTH, A.MENU_ORDER;  
	    
END    
    
ELSE    
BEGIN    
    
	 IF @MENU_GROUP_CODE is null         
	 BEGIN        
		WITH STEP_PUB_MENU (MENU_GROUP_CODE, PARENT_CODE, MENU_CODE, MENU_NAME, MENU_DEPTH, SORT_CODE, SORT_NAME, SORT, MENU_LINK, SHOW_YN, MENU_ORDER) AS  
		(
			SELECT
				A.MENU_GROUP_CODE,
				A.PARENT_CODE,
				A.MENU_CODE,
				A.MENU_NAME,
				0,
				A.SORT_CODE,
				(SELECT MENU_NAME FROM PUB_MENU WHERE MENU_GROUP_CODE = A.MENU_GROUP_CODE AND MENU_CODE = A.SORT_CODE) AS [SORT_NAME],
				CONVERT(VARCHAR(255), (A.MENU_GROUP_CODE + CONVERT(VARCHAR(3), A.MENU_CODE) +  A.MENU_NAME)) AS [SORT],
				A.MENU_LINK,
				A.SHOW_YN,
				A.MENU_ORDER
			FROM PUB_MENU A
			WHERE PARENT_CODE IS NULL --AND MENU_GROUP_CODE = @MENU_GROUP_CODE
			UNION ALL
			SELECT
				A.MENU_GROUP_CODE,
				A.PARENT_CODE,
				A.MENU_CODE,
				A.MENU_NAME,
				B.MENU_DEPTH + 1,
				A.SORT_CODE,
				B.SORT_NAME,
				CONVERT (VARCHAR(255), RTRIM(B.SORT) + '| ' + A.MENU_NAME),
				A.MENU_LINK,
				A.SHOW_YN,
				A.MENU_ORDER
			FROM PUB_MENU A
			INNER JOIN STEP_PUB_MENU B ON A.MENU_GROUP_CODE = B.MENU_GROUP_CODE AND A.PARENT_CODE = B.MENU_CODE
		)
		SELECT
		--	A.SORT,
			A.MENU_GROUP_CODE,
			A.PARENT_CODE,  
			A.MENU_CODE,  
			A.MENU_NAME,  
			A.MENU_DEPTH,  
			A.SORT_CODE,  
			A.SORT_NAME,  
			A.MENU_LINK,  
			B.EMP_CODE,  
			B.SELECT_YN,  
			B.INSERT_YN,  
			B.UPDATE_YN,  
			B.DELETE_YN,  
			B.MASTER_YN ,  
			A.SHOW_YN,  
			A.MENU_ORDER  
		FROM STEP_PUB_MENU A  
		INNER JOIN PUB_GRANT B ON A.MENU_GROUP_CODE = B.MENU_GROUP_CODE AND A.MENU_CODE = B.MENU_CODE AND B.EMP_CODE = @EMP_CODE AND B.SELECT_YN='Y' AND A.SHOW_YN='Y'  
		ORDER BY A.MENU_GROUP_CODE, B.MENU_CODE, A.SORT, A.MENU_DEPTH, A.MENU_ORDER;        

	 END        
	         
	 ELSE        
	 BEGIN        
		WITH STEP_PUB_MENU (MENU_GROUP_CODE, PARENT_CODE, MENU_CODE, MENU_NAME, MENU_DEPTH, SORT_CODE, SORT_NAME, SORT, MENU_LINK, SHOW_YN, MENU_ORDER) AS  
		(
			SELECT
				A.MENU_GROUP_CODE,
				A.PARENT_CODE,
				A.MENU_CODE,
				A.MENU_NAME,
				0,
				A.SORT_CODE,
				(SELECT MENU_NAME FROM PUB_MENU WHERE MENU_GROUP_CODE = A.MENU_GROUP_CODE AND MENU_CODE = A.SORT_CODE) AS [SORT_NAME],
				CONVERT(VARCHAR(255), (A.MENU_GROUP_CODE + CONVERT(VARCHAR(3), A.MENU_CODE) +  A.MENU_NAME)) AS [SORT],
				A.MENU_LINK,
				A.SHOW_YN,
				A.MENU_ORDER
			FROM PUB_MENU A
			WHERE PARENT_CODE IS NULL AND MENU_GROUP_CODE = @MENU_GROUP_CODE
			UNION ALL
			SELECT
				A.MENU_GROUP_CODE,
				A.PARENT_CODE,
				A.MENU_CODE,
				A.MENU_NAME,
				B.MENU_DEPTH + 1,
				A.SORT_CODE,
				B.SORT_NAME,
				CONVERT (VARCHAR(255), RTRIM(B.SORT) + '| ' + A.MENU_NAME),
				A.MENU_LINK,
				A.SHOW_YN,
				A.MENU_ORDER
			FROM PUB_MENU A
			INNER JOIN STEP_PUB_MENU B ON A.MENU_GROUP_CODE = B.MENU_GROUP_CODE AND A.PARENT_CODE = B.MENU_CODE
		)
		SELECT
		--	A.SORT,
			A.MENU_GROUP_CODE,
			A.PARENT_CODE,  
			A.MENU_CODE,  
			A.MENU_NAME,  
			A.MENU_DEPTH,  
			A.SORT_CODE,  
			A.SORT_NAME,  
			A.MENU_LINK,  
			B.EMP_CODE,  
			B.SELECT_YN,  
			B.INSERT_YN,  
			B.UPDATE_YN,  
			B.DELETE_YN,  
			B.MASTER_YN ,  
			A.SHOW_YN,  
			A.MENU_ORDER  
		FROM STEP_PUB_MENU A  
		INNER JOIN PUB_GRANT B ON A.MENU_GROUP_CODE = B.MENU_GROUP_CODE AND A.MENU_CODE = B.MENU_CODE AND B.EMP_CODE = @EMP_CODE AND B.SELECT_YN='Y' AND A.SHOW_YN='Y'  
		ORDER BY A.MENU_GROUP_CODE, B.MENU_CODE, A.SORT, A.MENU_DEPTH, A.MENU_ORDER;
	       
	 END        
	         
END    
--select * from PUB_MENU
GO
