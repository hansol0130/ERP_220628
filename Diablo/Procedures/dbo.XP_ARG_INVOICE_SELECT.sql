USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_ARG_INVOICE_SELECT
■ DESCRIPTION				: 수배현황상세 리스트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	DECLARE @COUNT INT
	EXEC DBO.XP_ARG_MASTER_LIST_SELECT 1, 10, @COUNT OUTPUT, 'ProductCode=&Title=테스트&ArrangeStatus=&StartDate=&EndDate=&AgentCode=&NewCode', 0
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-22		이규식			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_ARG_INVOICE_SELECT]
 	@ARG_SEQ_NO int,
	@GRP_SEQ_NO int
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	-- 수배상세
	SELECT 
	*,
	DBO.XN_COM_GET_EMP_NAME(NEW_CODE) AS NEW_NAME,
	DBO.XN_COM_GET_TEAM_NAME(NEW_CODE) AS NEW_TEAM_NAME,
	DBO.XN_COM_GET_EMP_NAME(CFM_CODE) AS CFM_NAME,
	DBO.XN_COM_GET_TEAM_NAME(CFM_CODE) AS CFM_TEAM_NAME
	FROM ARG_DETAIL WITH(NOLOCK)
	WHERE ARG_SEQ_NO = @ARG_SEQ_NO

	-- 수배확정 명단
	SELECT 
	*,
	DBO.XN_COM_GET_EMP_NAME(NEW_CODE) AS NEW_NAME,
	DBO.XN_COM_GET_TEAM_NAME(NEW_CODE) AS NEW_TEAM_NAME
	FROM ARG_CUSTOMER WITH(NOLOCK)
	WHERE ARG_SEQ_NO = @ARG_SEQ_NO

	-- 인보이스
	SELECT
	*,
	DBO.XN_COM_GET_EMP_NAME(NEW_CODE) AS NEW_NAME,
	DBO.XN_COM_GET_TEAM_NAME(NEW_CODE) AS NEW_TEAM_NAME
	FROM ARG_INVOICE WITH(NOLOCK)
	WHERE ARG_SEQ_NO = @ARG_SEQ_NO

	-- 인보이스 세부항목
	SELECT
	A.*,
	B.TITLE,
	DBO.XN_COM_GET_EMP_NAME(A.NEW_CODE) AS NEW_NAME,
	DBO.XN_COM_GET_TEAM_NAME(A.NEW_CODE) AS NEW_TEAM_NAME
	FROM ARG_INVOICE_DETAIL A WITH(NOLOCK)
	INNER JOIN ARG_INVOICE_ITEM B WITH(NOLOCK) ON A.INV_SEQ_NO = B.SEQ_NO
	WHERE ARG_SEQ_NO = @ARG_SEQ_NO

END 

GO
