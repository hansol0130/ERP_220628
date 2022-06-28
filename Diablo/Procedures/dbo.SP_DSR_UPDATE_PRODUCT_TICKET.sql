USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_DSR_UPDATE_PRODUCT_TICKET]    
 @RES_CODE VARCHAR(20),    
 @SEQ_NO INT,    
 @TICKET VARCHAR(20),    
 @ISSUE_CODE CHAR(7),  
 @CITY_CODE CHAR(3),  
 @NEW_CODE CHAR(7)    
AS    
BEGIN    
 DECLARE @PRO_CODE VARCHAR(20)    
 DECLARE @SALE_CODE VARCHAR(20)    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
    
 -- 행사 코드가 없을 경우 매칭 시키지 않는다.    
 IF NOT EXISTS(SELECT TOP 1 1 FROM RES_MASTER_damo WHERE RES_CODE = @RES_CODE) RETURN    
 IF NOT EXISTS(SELECT TOP 1 1 FROM RES_CUSTOMER_damo WHERE RES_CODE = @RES_CODE AND SEQ_NO = @SEQ_NO) RETURN    
 -- 티켓이 없을 경우 매칭 시키지 않는다.    
 IF NOT EXISTS(SELECT TOP 1 1 FROM DSR_TICKET WHERE TICKET = @TICKET) RETURN    
    
 SELECT @PRO_CODE = PRO_CODE, @SALE_CODE = NEW_CODE FROM RES_MASTER_damo WHERE RES_CODE = @RES_CODE;    
     
 UPDATE DSR_TICKET SET     
  PRO_CODE = @PRO_CODE,    
  RES_CODE = @RES_CODE,    
  RES_SEQ_NO = @SEQ_NO,    
  SALE_CODE = @SALE_CODE,    
  ISSUE_CODE = @ISSUE_CODE,    
  CITY_CODE = @CITY_CODE,  
  NEW_CODE = @NEW_CODE    
 WHERE TICKET = @TICKET;    
    
 -- 기존에 입금이 물려있을 경우에는 입금을 이동해준다.    
 IF EXISTS (SELECT * FROM PAY_MASTER_damo WHERE SEC1_PAY_NUM = damo.dbo.pred_meta_plain_v (@TICKET,'DIABLO','dbo.PAY_MASTER','PAY_NUM') )    
 BEGIN    
  UPDATE PAY_MATCHING     
  SET PRO_CODE = @PRO_CODE, RES_CODE = @RES_CODE     
  WHERE PAY_SEQ IN (SELECT PAY_SEQ FROM PAY_MASTER_damo WHERE SEC1_PAY_NUM = damo.dbo.pred_meta_plain_v (@TICKET,'DIABLO','dbo.PAY_MASTER','PAY_NUM') AND (PAY_TYPE = 10 OR PAY_TYPE = 12))    
 END    
    
END 
GO
