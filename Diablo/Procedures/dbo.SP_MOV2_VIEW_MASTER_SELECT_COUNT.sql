USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: SP_MOV2_VIEW_MASTER_SELECT_COUNT
■ DESCRIPTION				: 검색_조회중인마스터_행사상품
■ INPUT PARAMETER			: NTYPE, PRO_CODE, SESSION_ID
	-- NTYPE: 1 (MASTER_CODE), 2 (PRO_CODE)
■ EXEC						: 
    -- EXEC SP_MOV2_VIEW_MASTER_SELECT_COUNT 2, 'APP5020-170927KE'

■ MEMO						: 조회중인마스터_행사상품 갯수를 구함
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-08-02		IBSOLUTION				최초생성
   2017-11-15		IBSOLUTION				한시간 이내 조건 추가
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_VIEW_MASTER_SELECT_COUNT]
	@NTYPE			INT,
	@CODE			VARCHAR(20)
AS
BEGIN
	IF @NTYPE = 1 
		SELECT COUNT(*) AS COUNT FROM VIEW_MASTER WHERE MASTER_CODE = @CODE AND DATEDIFF ( MINUTE , NEW_DATE , GETDATE() ) < 60
	ELSE
		SELECT COUNT(*) AS COUNT FROM VIEW_MASTER WHERE PRO_CODE = @CODE AND DATEDIFF ( MINUTE , NEW_DATE , GETDATE() ) < 60
END           

GO
