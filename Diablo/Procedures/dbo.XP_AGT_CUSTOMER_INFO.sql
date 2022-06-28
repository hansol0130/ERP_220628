USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_AGT_CUSTOMER_INFO
■ DESCRIPTION				: 사외업무시스템 인솔자 정보
■ INPUT PARAMETER			: 
	@MEM_CODE	VARCHAR(20), : 행사코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec XP_AGT_CUSTOMER_INFO 'T130001'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-25		이상일			최초생성    
================================================================================================================*/ 

 CREATE PROCEDURE [dbo].[XP_AGT_CUSTOMER_INFO]
(
	@MEM_CODE	VARCHAR(20)
)

AS  
BEGIN
	SELECT A.*
	FROM AGT_MEMBER A WITH(NOLOCK)
	WHERE A.MEM_CODE = @MEM_CODE
END


GO
