USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME						: [ZP_WEB_DHS_RESERVE_DEFAULT_SELECT]
■ DESCRIPTION					: 홈쇼핑 호텔 예약 기본 조회
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    : [ZP_WEB_DHS_RESERVE_DEFAULT_SELECT] 'RP2201127228'
■ EXEC						    : [ZP_WEB_DHS_RESERVE_DEFAULT_SELECT] '', '17722201961'
■ MEMO						    :
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2022-01-11		김홍우			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_WEB_DHS_RESERVE_DEFAULT_SELECT]
	@RES_CODE			CHAR(12)=''
	,@C_RES_CODE		CHAR(11)=''		--알림톡 으로 들어 올경우(파라미터 명 "C")
AS 
BEGIN
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    
    DECLARE @RES_CODE_ VARCHAR(12)
    
    
    IF (@C_RES_CODE<>'')	--알림톡에서 넘어 온 경우
    BEGIN
        SELECT @RES_CODE_ = DBO.XN_RES_CODE_CHANGE(@C_RES_CODE)
    END
    ELSE 
    IF (@RES_CODE<>'')		--intro 페이지에서 예약하기 버튼을 통해 넘어 온경우
    BEGIN
        SET @RES_CODE_ = @RES_CODE
    END
    
    PRINT @RES_CODE_
    
    SELECT RM.RES_CODE
          ,PM.MASTER_NAME
          ,RM.RES_NAME
          ,PM.RES_REMARK
          ,RM.RES_STATE
          ,RM.MASTER_CODE
          ,PM.PKG_REVIEW
    FROM   dbo.RES_MASTER_DAMO RM
           INNER JOIN dbo.PKG_MASTER PM
                ON  RM.MASTER_CODE = PM.MASTER_CODE
    WHERE  RES_CODE = @RES_CODE_;
END


GO
