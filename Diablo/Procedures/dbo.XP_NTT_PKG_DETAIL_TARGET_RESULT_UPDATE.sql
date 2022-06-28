USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_NTT_PKG_DETAIL_TARGET_RESULT_UPDATE
■ DESCRIPTION				: 네이버 트립토파즈 업데이트 상품 완료 갱신 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC dbo.XP_NTT_PKG_DETAIL_TARGET_RESULT_UPDATE @CODE_LIST='APP129-220701OZ,APP129-220702OZ'
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2021-11-18			김성호			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_NTT_PKG_DETAIL_TARGET_RESULT_UPDATE]
	@CODE_LIST VARCHAR(4000)		-- 순번 리스트
AS 
BEGIN
	
	IF EXISTS(SELECT DATA FROM dbo.FN_XML_SPLIT(@CODE_LIST, ',') WHERE DATA <> '')
	BEGIN
		UPDATE A SET A.CHK_DATE = GETDATE()
		FROM NTT_PKG_DETAIL_UPDATE_TARGET A
		--WHERE A.SEQ_NO IN (SELECT DATA FROM dbo.FN_XML_SPLIT(@CODE_LIST, ',') WHERE DATA <> '') AND A.CHK_DATE IS NULL
		WHERE A.PRO_CODE IN (SELECT DATA FROM dbo.FN_XML_SPLIT(@CODE_LIST, ',') WHERE DATA <> '') AND A.CHK_DATE IS NULL
	END
	
	RETURN @@ROWCOUNT
	
END 
GO
