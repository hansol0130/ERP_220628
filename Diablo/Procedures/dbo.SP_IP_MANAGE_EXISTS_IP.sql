USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_IP_MANAGE_EXISTS_IP
■ DESCRIPTION				: 사내 IP관리
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2014-04-11		정지용			최초생성
   2014-05-15		정지용			재직중인 직원만 조회가능
================================================================================================================*/ 
CREATE PROC [dbo].[SP_IP_MANAGE_EXISTS_IP]
 	@IP_TYPE  INT, -- 1 :PC, 2 : 전화기
	@IPADDRESS VARCHAR(15)
AS 
BEGIN
	--IF EXISTS(SELECT 1 FROM IP_MASTER WHERE IP_TYPE = @IP_TYPE AND IP_NUMBER = @IPADDRESS)-- 1: PC, 2: 전화
	IF EXISTS(
		SELECT 1 FROM IP_MASTER A WITH(NOLOCK)
		LEFT OUTER JOIN EMP_MASTER B WITH(NOLOCK) on A.CONNECT_CODE = B.EMP_CODE
		WHERE IP_TYPE = @IP_TYPE AND IP_NUMBER = @IPADDRESS AND ((B.WORK_TYPE = 1 AND B.EMP_CODE IS NOT NULL) OR (B.EMP_CODE IS NULL))
	)-- 1: PC, 2: 전화
	BEGIN
		SELECT 0;
		RETURN;
	END
	SELECT 1;
END



GO
