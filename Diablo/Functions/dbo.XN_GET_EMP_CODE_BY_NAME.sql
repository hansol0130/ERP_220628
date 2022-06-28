USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: XN_GET_EMP_CODE_BY_NAME
■ Description				: 사원명으로 사번 정보 가져오기
■ Input Parameter			:                  
		@EMP_NAME			: 직원명
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	SELECT * fROM XN_GET_EMP_CODE_BY_NAME('김성호')
	SELECT * fROM XN_GET_EMP_CODE_BY_NAME('정지용')
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2013-03-07		김성호			최초생성
-------------------------------------------------------------------------------------------------*/ 
CREATE FUNCTION [dbo].[XN_GET_EMP_CODE_BY_NAME]
(	
	@EMP_NAME	VARCHAR(20)
)
RETURNS @RTNVALUE TABLE 
(
	SEQ_NO		INT,
	EMP_CODE	CHAR(7)
) 
AS
BEGIN

	INSERT INTO @RTNVALUE (SEQ_NO, EMP_CODE)
	SELECT ROW_NUMBER() OVER(ORDER BY A.EMP_CODE) AS [SEQ_NO], EMP_CODE
	FROM (
		SELECT EMP_CODE
		FROM EMP_MASTER WHERE KOR_NAME LIKE @EMP_NAME + '%'
		UNION ALL
		SELECT MEM_CODE 
		FROM AGT_MEMBER WHERE KOR_NAME LIKE @EMP_NAME + '%'
	) A	 

	RETURN
END


GO
