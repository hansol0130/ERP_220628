USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: XN_COM_GET_VGL_YN
■ Description				: 본사직원 유무를 리턴한다. (Y: 본사, N: 이외)
■ Input Parameter			:                  
		@EMP_CODE			: 사원코드
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	SELECT DBO.XN_COM_GET_VGL_YN('2008011')
	SELECT DBO.XN_COM_GET_VGL_YN('A130001')
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2013-02-28		김성호			최초생성
	2013-03-25		김성호			테이블 검색으로 보강
	2013-05-06		김성호			검색조건에서 WORK_TYPE 제거
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[XN_COM_GET_VGL_YN]
(
	@EMP_CODE CHAR(7)
)
RETURNS CHAR(1)
AS
BEGIN
	DECLARE @VGL_YN CHAR(1)
	
	--IF ISNUMERIC(@EMP_CODE) = 1
	IF EXISTS(SELECT 1 FROM EMP_MASTER WHERE EMP_CODE = @EMP_CODE)
		SET @VGL_YN = 'Y'
	ELSE 
		SET @VGL_YN = 'N'

	RETURN (@VGL_YN)
END





GO
