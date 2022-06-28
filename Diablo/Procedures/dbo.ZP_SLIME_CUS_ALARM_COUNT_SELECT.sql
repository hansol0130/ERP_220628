USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================            
■ USP_NAME     : [ZP_SLIME_CUS_ALARM_COUNT_SELECT]            
■ DESCRIPTION    : 알림 갯수 조회            
■ INPUT PARAMETER   : @CUSTOMER_NO, @CUVE_FLAG, @PUSH_FLAG, @SMS_FLAG, @EMAIL_FLAG, @TOTAL_COUNT             
■ EXEC      :              
                 
 DECLARE @TOTAL_COUNT INT            
 EXEC [ZP_SLIME_CUS_ALARM_COUNT_SELECT] '12025367', 1,1,1,1,0, @TOTAL_COUNT OUTPUT            
 SELECT @TOTAL_COUNT            
                       
■ MEMO      :             
------------------------------------------------------------------------------------------------------------------            
■ CHANGE HISTORY                                 
------------------------------------------------------------------------------------------------------------------            
   DATE    AUTHOR           DESCRIPTION                       
------------------------------------------------------------------------------------------------------------------            
   2020-02-12   지니웍스    최초생성            
   2020-02-20   지니웍스    알림 카운트 조건 수정(읽음 여부 조건 추가)        
================================================================================================================*/             
CREATE PROCEDURE [dbo].[ZP_SLIME_CUS_ALARM_COUNT_SELECT]         
        
@CUSTOMER_NO INT,         
@CUVE_FLAG INT, /*큐비*/         
@PUSH_FLAG INT, /*푸시*/         
@SMS_FLAG INT, /*문자/알림*/         
@EMAIL_FLAG INT, /*이메일*/         
@IS_NEW BIT = 0 , /* 읽음여부 */         
@TOTAL_COUNT INT OUT        
AS        
BEGIN        
 SELECT @TOTAL_COUNT = SUM(CNT)        
 FROM   (        
            /*큐비*/            
            SELECT COUNT(*) AS CNT        
            FROM   dbo.CUV_MASTER AS cm WITH(NOLOCK)        
                   JOIN dbo.CUV_RECEIVE AS cr WITH(NOLOCK)        
                        ON  cr.CUV_SEQ = cm.CUV_SEQ        
            WHERE  cr.CUS_NO = @CUSTOMER_NO        
                   AND @CUVE_FLAG = 1        
                   AND (@IS_NEW = 0 OR (@IS_NEW = 1 AND cr.CHECK_DATE IS NULL))         
                    
                    
                    
            UNION ALL         
                    
            /*푸시*/            
            SELECT COUNT(*) AS CNT        
            FROM   APP_PUSH_MSG_ALARM A WITH(NOLOCK)        
                  ,APP_PUSH_MSG_INFO B WITH(NOLOCK)        
            WHERE  A.MSG_NO = B.MSG_NO         
                   --AND (@MSG_NO = -1 OR A.MSG_NO = @MSG_NO)        
                   AND A.CUS_NO = @CUSTOMER_NO        
                   AND B.RECV_DATE > DATEADD(M ,-1 ,GETDATE())        
                   AND @PUSH_FLAG = 1        
                   AND @IS_NEW = 0         
                    
            --UNION ALL         
                    
            --/*메시지*/            
            --SELECT COUNT(*) AS CNT        
            --FROM   (        
            --           SELECT SMS.SND_NO        
            --                 ,SMS.SND_TYPE        
            --                 ,SMS.RCV_NUMBER1        
            --                 ,SMS.RCV_NUMBER2        
            --                 ,SMS.RCV_NUMBER3        
            --                 ,SMS.RCV_NAME        
            --                 ,SMS.SND_NUMBER        
            --                 ,SMS.NEW_CODE        
            --                 ,EM.KOR_NAME AS [EMP_NAME]        
            --                 ,SMS.BODY        
            --                 ,SMS.NEW_DATE        
            --                 ,SMS.SND_RESULT        
            --           FROM   Diablo.dbo.RES_CUSTOMER RES WITH(NOLOCK)        
            --                  INNER JOIN Diablo.dbo.RES_SND_SMS SMS WITH(NOLOCK)        
            --                       ON  RES.RES_CODE = SMS.RES_CODE        
            --                  LEFT OUTER JOIN DIABLO.DBO.EMP_MASTER EM  WITH(NOLOCK)      
            --                       ON  SMS.NEW_CODE = EM.EMP_CODE        
            --           WHERE  RES.CUS_NO = @CUSTOMER_NO    
            --                  AND @SMS_FLAG = 1        
            --                  AND @IS_NEW = 0        
            --                  AND SMS.SND_NO NOT IN (SELECT SMS.SND_NO        
            --                                         FROM   Diablo.dbo.RES_SND_SMS SMS WITH(NOLOCK)        
            --     WHERE  SMS.CUS_NO = @CUSTOMER_NO)         
            --           UNION ALL            
            --           SELECT SMS.SND_NO        
            --                 ,SMS.SND_TYPE        
            --                 ,SMS.RCV_NUMBER1        
            --                 ,SMS.RCV_NUMBER2        
            --                 ,SMS.RCV_NUMBER3        
            --                 ,SMS.RCV_NAME        
            --                 ,SMS.SND_NUMBER        
            --                 ,SMS.NEW_CODE        
            --                 ,EM.KOR_NAME AS [EMP_NAME]        
            --                 ,SMS.BODY        
            --                 ,SMS.NEW_DATE        
            --                 ,SMS.SND_RESULT        
            --           FROM   Diablo.dbo.RES_SND_SMS SMS WITH(NOLOCK)        
            --                  LEFT OUTER JOIN DIABLO.DBO.EMP_MASTER EM WITH(NOLOCK)        
            --                       ON  SMS.NEW_CODE = EM.EMP_CODE        
            --           WHERE  @IS_NEW = 0        
            --                  AND SMS.CUS_NO = @CUSTOMER_NO        
            --                  AND @SMS_FLAG = 1        
            --       ) SMS         
                    
            UNION ALL         
                    
            /*이메일*/            
            SELECT COUNT(*) AS CNT        
            FROM   Diablo.dbo.RES_CUSTOMER RES WITH(NOLOCK)        
                   INNER JOIN Diablo.dbo.RES_SND_EMAIL EML WITH(NOLOCK)        
                        ON  RES.RES_CODE = EML.RES_CODE        
                   LEFT OUTER JOIN Diablo.dbo.EMP_MASTER EM WITH(NOLOCK)        
                        ON  EML.NEW_CODE = EM.EMP_CODE        
            WHERE  @IS_NEW = 0        
                   AND RES.CUS_NO = @CUSTOMER_NO        
                   AND @EMAIL_FLAG = 1        
        ) A        
END 
GO
