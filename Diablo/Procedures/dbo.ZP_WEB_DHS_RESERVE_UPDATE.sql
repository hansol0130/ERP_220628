USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME						: ZP_WEB_DHS_RESERVE_UPDATE
■ DESCRIPTION					: 홈쇼핑 호텔 예약 완료 처리
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    : ZP_WEB_DHS_RESERVE_UPDATE 'RT2201060946'
■ MEMO						    :
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2022-01-17		김홍우			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_WEB_DHS_RESERVE_UPDATE]
	@RES_CODE CHAR(12)
	,@BIT_CODE VARCHAR(4)
	,@DEP_DATE DATETIME
	,@ARR_DATE DATETIME
	,@PNR_INFO VARCHAR(10)	--'3|2' -- '성인 3명 아동 2명'
	,@CUS_REQUEST VARCHAR(1000)	--'비흡연방으로 주세요'
AS 
BEGIN
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    
    --DECLARE @RES_CODE RES_CODE='RP2201127227'
    --       ,@BIT_CODE VARCHAR(4)=1
    --       ,@DEP_DATE DATETIME='2022-02-05'
    --       ,@ARR_DATE DATETIME
    --       ,@PNR_INFO VARCHAR(10)='3|2' -- '성인 3명 아동 2명'
    --       ,@CUS_REQUEST VARCHAR(1000)='흡연방으로 주세요'
    --       ,@NEW_CODE CHAR(7)='2008011'
    
    
    UPDATE RM
    SET    PRO_CODE = (RM.MASTER_CODE + '-' + CONVERT(VARCHAR(6) ,@DEP_DATE ,12) + @BIT_CODE)
          ,PRO_NAME = PMP.PRICE_NAME
          ,PRICE_SEQ = (
               SELECT TOP 1 PRICE_SEQ
               FROM   PKG_DETAIL_PRICE
               WHERE  PRO_CODE = (RM.MASTER_CODE + '-' + CONVERT(VARCHAR(6) ,@DEP_DATE ,12) + @BIT_CODE)
           )
          ,DEP_DATE = @DEP_DATE
          ,ARR_DATE = DATEADD(D ,1 ,@DEP_DATE)
          ,LAST_PAY_DATE = DATEADD(DD ,-14 ,@DEP_DATE)
          ,PNR_INFO = @PNR_INFO
          ,CUS_REQUEST = @CUS_REQUEST
          ,NEW_DATE = GETDATE()
          ,RES_STATE = 2 --예약확정(2) : 고객이 숙박일을 결정 (엑셀다운, 호텔확정코드 등록 대상 조회)
    FROM   RES_MASTER_damo RM
           LEFT OUTER JOIN dbo.PKG_MASTER_PRICE PMP
                ON  RM.MASTER_CODE = PMP.MASTER_CODE
                    AND PMP.PRICE_SEQ = CONVERT(INT ,@BIT_CODE)
	WHERE  RM.RES_CODE = @RES_CODE;
    
    --DECLARE @PRO_CODE      VARCHAR(20)
    --       ,@PRICE_SEQ     INT
    --       ,@PRO_NAME      NVARCHAR(100)
    --       ,@RES_STATE     INT = 2		--예약확정(2) : 고객이 숙박일을 결정 (엑셀다운, 호텔확정코드 등록 대상 조회)
    
    --SELECT @PRO_NAME = PMP.PRICE_NAME
    --      ,@PRO_CODE = (RM.MASTER_CODE + '-' + CONVERT(VARCHAR(6) ,@DEP_DATE ,12) + @BIT_CODE)
    --      ,@PRICE_SEQ = (
    --           SELECT TOP 1 PRICE_SEQ
    --           FROM   PKG_DETAIL_PRICE
    --           WHERE  PRO_CODE = (RM.MASTER_CODE + '-' + CONVERT(VARCHAR(6) ,@DEP_DATE ,12) + @BIT_CODE)
    --       )
    --      ,@ARR_DATE = DATEADD(D ,1 ,@DEP_DATE)
    --FROM   dbo.RES_MASTER_damo RM
    --       LEFT OUTER JOIN dbo.PKG_MASTER_PRICE PMP
    --            ON  RM.MASTER_CODE = PMP.MASTER_CODE
    --                AND PMP.PRICE_SEQ = CONVERT(INT ,@BIT_CODE)
    --WHERE  RM.RES_CODE = @RES_CODE;
    
    ---- 예약 마스터 업데이트     
    --UPDATE dbo.RES_MASTER_damo
    --SET    PRO_CODE = @PRO_CODE
    --      ,PRO_NAME = @PRO_NAME
    --      ,DEP_DATE = @DEP_DATE
    --      ,ARR_DATE = @ARR_DATE
    --      ,LAST_PAY_DATE = DATEADD(DD ,-14 ,@DEP_DATE)
    --      ,PNR_INFO = @PNR_INFO
    --      ,CUS_REQUEST = @CUS_REQUEST
    --      ,EDT_DATE = GETDATE()
    --      ,RES_STATE = @RES_STATE
    --WHERE  RES_CODE = @RES_CODE;
END
GO
