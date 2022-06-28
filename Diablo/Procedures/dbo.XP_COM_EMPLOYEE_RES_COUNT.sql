USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_EMPLOYEE_RES_COUNT
■ DESCRIPTION				: BTMS 출장자 예약 카운트
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC XP_COM_EMPLOYEE_RES_COUNT '129', '92756'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR					DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-05-09		저스트고(강태영)		최초생성
================================================================================================================*/ 

CREATE PROC [dbo].[XP_COM_EMPLOYEE_RES_COUNT]
@EMP_SEQ INT,
@AGT_CODE INT

AS

BEGIN

	SELECT COUNT(*) AS RES_COUNT
	FROM RES_CUSTOMER A
	INNER JOIN COM_EMPLOYEE_MATCHING B ON A.CUS_NO = B.CUS_NO
	WHERE B.EMP_SEQ = @EMP_SEQ AND B.AGT_CODE = @AGT_CODE

END
GO
