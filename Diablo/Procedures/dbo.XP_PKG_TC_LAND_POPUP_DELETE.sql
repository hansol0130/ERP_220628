USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Database					: DIABLO
■ USP_Name					: XP_PKG_TC_LAND_POPUP_DELETE
■ Description				: 
■ Input Parameter			:
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
■ Author					:  
■ Date						: 
■ Memo						: 상품마스터화면/ 랜드사 선택 삭제
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date				Author			Description           
---------------------------------------------------------------------------------------------------
	2013-04-25			오인규			최초생성
  	2022-01-14			김성호			PKG_AGT_MASTER 스키마 변경으로 SP 수정
-------------------------------------------------------------------------------------------------*/ 
CREATE PROCEDURE [dbo].[XP_PKG_TC_LAND_POPUP_DELETE]
(
    @TOT_CODE     VARCHAR(20)
   ,@AGT_CODE     VARCHAR(10)
)
AS
BEGIN
	DELETE 
	FROM   dbo.PKG_AGT_MASTER
	WHERE  TOT_CODE = @TOT_CODE
	       AND AGT_CODE = @AGT_CODE;
END

GO
