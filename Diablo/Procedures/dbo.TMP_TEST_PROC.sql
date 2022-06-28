USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CUS_ASCALL_SELECT
■ DESCRIPTION				: AS CALL 조회 ( 일주일 단위 픽스 )
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	SP_CUS_ASCALL_SELECT '2014-08-04', '2014-08-10'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-08-11		정지용
================================================================================================================*/ 
CREATE PROC [dbo].[TMP_TEST_PROC]
	@MENU_CODE varchar(20)
AS 
BEGIN	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	WITH LIST(PARENT_CODE, MENU_CODE, MENU_NAME, LINK_URL, SITE_CODE, LVL, ORDER_NUM) AS
	(
		SELECT PARENT_CODE, MENU_CODE, MENU_NAME, LINK_URL, SITE_CODE, 0 AS LVL,
		CONVERT(VARCHAR(20), RIGHT(CONVERT(CHAR(3), 100 + ORDER_NUM), 2)) AS ORDER_NUM	
		FROM MNU_MASTER_REL A WITH(NOLOCK)
		WHERE A.SITE_CODE = 'VGT' AND MENU_CODE = @MENU_CODE
		UNION ALL
		SELECT A.PARENT_CODE, A.MENU_CODE, A.MENU_NAME, A.LINK_URL, A.SITE_CODE, B.LVL + 1,
		CONVERT(VARCHAR(20), B.ORDER_NUM + RIGHT(CONVERT(CHAR(3), 100 + A.ORDER_NUM), 2)) AS ORDER_NUM	
		FROM MNU_MASTER_REL A WITH(NOLOCK)
		INNER JOIN LIST B ON A.SITE_CODE = B.SITE_CODE AND A.PARENT_CODE = B.MENU_CODE
	)
	SELECT * FROM LIST A ORDER BY A.ORDER_NUM

END 


GO
