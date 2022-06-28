USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: SP_MOV2_ICN_CONDITION_SELECT
■ DESCRIPTION				: 검색_인천공항혼잡도목록
■ INPUT PARAMETER			: 
■ EXEC						: 
    -- 
	exec SP_MOV2_ICN_CONDITION_SELECT

■ MEMO						: 인천공항 혼잡도목록
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-25		IBSOLUTION				최초생성
   2017-12-06		IBSOLUTION				최근일자 데이타 가져오기로 변경(배치)
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_ICN_CONDITION_SELECT]
AS
BEGIN

	DECLARE @DEP_DATE DATETIME;

	SELECT TOP 1 @DEP_DATE = DEP_DATE FROM API_ICN_CONDITION 
		WHERE DATEDIFF(DD, GETDATE(), DEP_DATE) <= 0
		ORDER BY DEP_DATE DESC

	SELECT * FROM API_ICN_CONDITION A WITH (NOLOCK)
		Where A.DEP_DATE = @DEP_DATE
		Order By A.DEP_TIME

--@DEP_DATE		VARCHAR(10),
--@MIN			INT
--AS
--BEGIN
--	SELECT * FROM API_ICN_CONDITION A WITH (NOLOCK)
--		Where A.DEP_DATE = (
--			SELECT MAX(B.DEP_DATE) FROM API_ICN_CONDITION B WITH (NOLOCK) 
--				Where CONVERT(VARCHAR(10), B.DEP_DATE, 23) = @DEP_DATE
--					AND B.DEP_DATE > DATEADD(MI, @MIN, GETDATE())
--		)
--		Order By A.DEP_TIME

END           


GO
