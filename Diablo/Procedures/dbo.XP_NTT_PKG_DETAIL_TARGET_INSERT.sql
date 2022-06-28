USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: [XP_NTT_PKG_DETAIL_TARGET_INSERT]
■ DESCRIPTION				: 네이버 트립토파즈 업데이트 상품 등록 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC [XP_NTT_PKG_DETAIL_TARGET_INSERT] @PRO_CODE='EPP3653', @EMP_CODE='2008011'
	
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2021-11-18			김성호			최초생성
	2021-11-24			김성호			등록되지않은 행사만 등록
	2021-11-29			김성호			네이버 제휴사 상품 등록 된 건만 대상으로 등록
================================================================================================================*/ 
CREATE PROC [dbo].[XP_NTT_PKG_DETAIL_TARGET_INSERT]
	@PRO_CODE VARCHAR(20),		-- 상품 코드
	@EMP_CODE VARCHAR(10)		-- 등록자
AS 
BEGIN
	
	SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @BIT_CODE VARCHAR(4)
	SELECT @BIT_CODE = SUBSTRING(@PRO_CODE, CHARINDEX('-', @PRO_CODE)+7, 4)
	
	IF NOT EXISTS(SELECT 1 FROM dbo.NTT_PKG_DETAIL_UPDATE_TARGET WHERE PRO_CODE = @PRO_CODE AND CHK_DATE IS NULL)
	BEGIN
		INSERT INTO dbo.NTT_PKG_DETAIL_UPDATE_TARGET (MASTER_CODE, PRO_CODE, PRICE_SEQ, BIT_CODE, NEW_DATE, NEW_CODE)
		SELECT PD.MASTER_CODE, PD.PRO_CODE, PDP.PRICE_SEQ
			, ISNULL(SUBSTRING(PD.PRO_CODE, (CHARINDEX('-', PD.PRO_CODE)+7), 4), ''), GETDATE(), @EMP_CODE
		FROM dbo.PKG_DETAIL PD WITH(NOLOCK)
		INNER JOIN dbo.PKG_DETAIL_PRICE PDP WITH(NOLOCK) ON PD.PRO_CODE = PDP.PRO_CODE
		INNER JOIN dbo.PKG_MASTER_AFFILIATE PMA WITH(NOLOCK) ON PD.MASTER_CODE = PMA.MASTER_CODE AND PMA.BIT_CODE = @BIT_CODE 
			AND PMA.PROVIDER = 41 AND PMA.USE_YN = 'Y'	-- 네이버
		WHERE PD.PRO_CODE = @PRO_CODE AND PD.DEP_DATE > GETDATE()
	END
END

GO
