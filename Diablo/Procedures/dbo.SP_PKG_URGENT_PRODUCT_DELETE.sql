USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_PKG_URGENT_PRODUCT_DELETE
■ DESCRIPTION				: 긴급모객 상품 일괄 삭제
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-04-16		정지용			최초생성   
   2018-11-22		이명훈		    삭제권한 담당자에서 담당자 팀비교로 변경
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_PKG_URGENT_PRODUCT_DELETE]
(
	@XML	NVARCHAR(MAX)
) 
AS 
BEGIN

	DECLARE @DOCHANDLE INT

	EXEC SP_XML_PREPAREDOCUMENT @DOCHANDLE OUTPUT, @XML;

	UPDATE A SET A.SHOW_YN = B.SHOW_YN, A.EDT_CODE = B.EDT_CODE, A.EDT_DATE = GETDATE()
	FROM PKG_URGENT_MASTER A
	INNER JOIN OPENXML(@DOCHANDLE, N'/ArrayOfUrgentProductRQ/UrgentProductRQ', 0)
	WITH
	(
		SITE_CODE	VARCHAR(3)		'./SiteCode',
		U_SEQ		INT				'./uSeq',
		SHOW_YN		VARCHAR(10)		'./ShowYN',
		EDT_CODE	CHAR(7)			'./EdtCode'
	) B ON A.SITE_CODE = B.SITE_CODE
	 AND A.U_SEQ = B.U_SEQ 
	 AND B.EDT_CODE IN (SELECT EMP_CODE 
					   FROM EMP_MASTER 
					   WHERE TEAM_CODE = (
							SELECT TEAM_CODE 
							FROM EMP_MASTER 
							WHERE EMP_CODE = A.NEW_CODE) 
					   GROUP BY EMP_CODE)

	EXEC SP_XML_REMOVEDOCUMENT @DOCHANDLE

END 
GO
