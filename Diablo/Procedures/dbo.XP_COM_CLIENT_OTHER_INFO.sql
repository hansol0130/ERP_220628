USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_CLIENT_OTHER_INFO
■ DESCRIPTION				: BTMS 거래처 정보
■ INPUT PARAMETER			: AGT_CODE
■ OUTPUT PARAMETER			: 
■ EXEC						: 	
	EXEC XP_COM_CLIENT_OTHER_INFO
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-22		저스트고강태영			최초생성
   2016-05-26		박형만			이미지 없어도 나오도록 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_CLIENT_OTHER_INFO]
	@AGT_CODE varchar(10)
AS 
BEGIN
	
	SELECT top 1 
		B.[FILE_NAME],
		A.KOR_NAME,
		A.ADDRESS1,
		A.ADDRESS2,
		A.ZIP_CODE,
		A.CEO_NAME,
		A.FAX_TEL1,
		A.FAX_TEL2,
		A.FAX_TEL3,
		A.NOR_TEL1,
		A.NOR_TEL2,
		A.NOR_TEL3
	FROM AGT_MASTER A WITH(NOLOCK)
	LEFT JOIN COM_FILE B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE
	WHERE A.AGT_CODE = @AGT_CODE 
	ORDER BY B.FILE_SEQ ASC  
END 
GO
