USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ FUNCTION_NAME					: FN_RES_GET_NEW_CODE
■ DESCRIPTION					: 예약담당자코드를 가져온다
■ EXEC						    : 

	SELECT dbo.FN_RES_GET_NEW_CODE('XPP110-220101', '2008011')

------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
									최초생성
   2022-02-04		김성호			행사가 없을 시 입력사번 리턴
================================================================================================================*/ 
CREATE FUNCTION [dbo].[FN_RES_GET_NEW_CODE]
(
	@PRO_CODE     VARCHAR(20)
   ,@EMP_CODE     VARCHAR(7)
)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @NEW_EMP_CODE CHAR(7);
	
	SELECT @NEW_EMP_CODE = NEW_CODE
	FROM   PKG_DETAIL WITH(NOLOCK)
	WHERE  PRO_CODE = @PRO_CODE
	
	RETURN ISNULL(@NEW_EMP_CODE ,@EMP_CODE)
END

GO
