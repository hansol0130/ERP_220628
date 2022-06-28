USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: XN_GET_USERINFO
■ Description				: 사원코드로 일괄 정보 가져오기
■ Input Parameter			:                  
		@EMP_CODE			: 직원 코드
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	SELECT * fROM XN_GET_USERINFO('2008011')
	SELECT * fROM XN_GET_USERINFO('A130001')
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2013-02-22		김성호			최초생성
-------------------------------------------------------------------------------------------------*/ 
CREATE FUNCTION [dbo].[XN_GET_USERINFO]
(	
	@EMP_CODE	CHAR(7)
)
RETURNS @RTNVALUE TABLE 
(
	COM_TYPE	INT,
	EMP_CODE	CHAR(7),
	EMP_NAME	VARCHAR(20),
	TEAM_CODE	VARCHAR(10),
	TEAM_NAME	VARCHAR(50)
) 
AS
BEGIN

	INSERT INTO @RTNVALUE (COM_TYPE, EMP_CODE, EMP_NAME, TEAM_CODE, TEAM_NAME)
	SELECT 
		DBO.XN_COM_GET_COM_TYPE(@EMP_CODE),
		@EMP_CODE,
		DBO.XN_COM_GET_EMP_NAME(@EMP_CODE),
		DBO.XN_COM_GET_TEAM_CODE(@EMP_CODE),
		DBO.XN_COM_GET_TEAM_NAME(@EMP_CODE)

	RETURN
	 
END




GO
