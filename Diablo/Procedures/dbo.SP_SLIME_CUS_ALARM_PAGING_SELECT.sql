USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================  
■ USP_NAME     : [SP_MOV2_CUS_CUVE_PAGING_SELECT]  
■ DESCRIPTION    : 큐브 페이징 조회  
■ INPUT PARAMETER   : @nowPage @pageSize @CUSTOMER_NO @TOTAL_COUNT   
■ EXEC      :    
    -- [[[SP_MOV2_CUS_CUVE_PAGING_SELECT]]]    
   
 DECLARE @TOTAL_COUNT INT  
 EXEC SP_SLIME_CUS_ALARM_PAGING_SELECT 1,10, '12025367', 1,1,1,1, @TOTAL_COUNT OUTPUT  
 SELECT @TOTAL_COUNT  
             
■ MEMO      : 큐브 페이징 조회  
------------------------------------------------------------------------------------------------------------------  
■ CHANGE HISTORY                       
------------------------------------------------------------------------------------------------------------------  
   DATE    AUTHOR           DESCRIPTION             
------------------------------------------------------------------------------------------------------------------  
   2017-05-26   아이비솔루션    최초생성  
   2020-02-28   지니웍스        큐비 테이블 수정 
   2020-07-06   홍종우			푸시(알림) 수정
================================================================================================================*/   
CREATE PROCEDURE [dbo].[SP_SLIME_CUS_ALARM_PAGING_SELECT] 

-- Add the parameters for the stored procedure here  
@PAGE_INDEX INT, 
@PAGE_SIZE INT, 
@CUSTOMER_NO INT, 
@CUVE_FLAG INT, /*큐비*/ 
@PUSH_FLAG INT, /*푸시*/ 
@SMS_FLAG INT, /*문자/알림*/ 
@EMAIL_FLAG INT, /*이메일*/ 
@TOTAL_COUNT INT OUT
AS
BEGIN
	DECLARE @Start INT = ((@PAGE_INDEX - 1) * @PAGE_SIZE)  
	
	SELECT *
	FROM   (
	           /*큐비*/  
	           SELECT CM.CUV_SEQ AS REF_NO
	                 ,CM.CUV_TITLE AS TITLE
	                 ,CM.CUV_BODY AS [MESSAGE]
	                 ,CM.NEW_DATE AS SEND_DATE
	                 ,1 AS ALARM_TYPE
	                 ,'F' AS CHECK_READ
	                 ,'' AS MSG_TYPE
	           FROM   dbo.CUV_MASTER AS CM WITH(NOLOCK)
	                  JOIN dbo.CUV_RECEIVE AS CR WITH(NOLOCK)
	                       ON  CR.CUV_SEQ = CM.CUV_SEQ
	           WHERE  CR.CUS_NO = @CUSTOMER_NO
	                  AND @CUVE_FLAG = 1 
	           
	           UNION ALL 
	           
	           /*푸시*/  
	           SELECT A.MSG_NO AS REF_NO
	                 ,B.TITLE AS TITLE
	                 ,B.MSG AS [MESSAGE]
	                 ,B.RECV_DATE AS SEND_DATE
	                 ,2 AS ALARM_TYPE
	                 ,CASE WHEN A.READ_DATE IS NULL THEN 'F' ELSE 'T' END  CHECK_READ
	                 ,B.TEMPLATE_TYPE AS MSG_TYPE
	           FROM   APP_PUSH_MSG_ALARM A
	                 ,APP_PUSH_MSG_INFO B WITH(NOLOCK)
	           WHERE  A.MSG_NO = B.MSG_NO 
	                  --AND (@MSG_NO = -1 OR A.MSG_NO = @MSG_NO)
	                  AND A.CUS_NO = @CUSTOMER_NO
	                  AND B.RECV_DATE > DATEADD(M ,-1 ,GETDATE())
	                  AND @PUSH_FLAG = 1 
	           UNION ALL
	           SELECT A.MSG_SEQ_NO AS REF_NO
	                 ,A.TITLE AS TITLE
	                 ,'[참좋은여행]비행편 변동으로 인한 운항정보 변경사항을 안내드립니다.' AS [MESSAGE]
	                 ,A.NEW_DATE AS SEND_DATE
	                 ,2 AS ALARM_TYPE
	                 ,CASE WHEN B.READ_DATE IS NULL THEN 'F' ELSE 'T' END  CHECK_READ
	                 ,'G' AS MSG_TYPE
	           FROM   APP_MESSAGE_damo A(NOLOCK)
	                  JOIN APP_RECEIVE B(NOLOCK)
	                       ON  A.MSG_SEQ_NO = B.MSG_SEQ_NO
	           WHERE  B.CUS_NO = @CUSTOMER_NO
	                  AND A.NEW_DATE > DATEADD(M ,-1 ,GETDATE())
	                  AND @PUSH_FLAG = 1 
	           
	           UNION ALL 
	           
	           /*메시지*/  
	           SELECT SMS.SND_NO AS REF_NO
	                 ,'' AS TITLE
	                 ,SMS.BODY AS [MESSAGE]
	                 ,SMS.NEW_DATE AS SEND_DATE
	                 ,3 AS ALARM_TYPE
	                 ,'F' AS CHECK_READ
	                 ,'' AS MSG_TYPE
	           FROM   (
	                      SELECT SMS.SND_NO
	                            ,SMS.SND_TYPE
	                            ,SMS.RCV_NUMBER1
	                            ,SMS.RCV_NUMBER2
	                            ,SMS.RCV_NUMBER3
	                            ,SMS.RCV_NAME
	                            ,SMS.SND_NUMBER
	                            ,SMS.NEW_CODE
	                            ,EM.KOR_NAME AS [EMP_NAME]
	                            ,SMS.BODY
	                            ,SMS.NEW_DATE
	                            ,SMS.SND_RESULT
	                      FROM   Diablo.dbo.RES_CUSTOMER RES WITH(NOLOCK)
	                             INNER JOIN Diablo.dbo.RES_SND_SMS SMS WITH(NOLOCK)
	                                  ON  RES.RES_CODE = SMS.RES_CODE
	                             LEFT OUTER JOIN DIABLO.DBO.EMP_MASTER EM
	                                  ON  SMS.NEW_CODE = EM.EMP_CODE
	                      WHERE  RES.CUS_NO = @CUSTOMER_NO
	                             AND @SMS_FLAG = 1
	                             AND SMS.SND_NO NOT IN (SELECT SMS.SND_NO
	                                                    FROM   Diablo.dbo.RES_SND_SMS SMS WITH(NOLOCK)
	                                                    WHERE  SMS.CUS_NO = @CUSTOMER_NO) 
	                      UNION ALL  
	                      SELECT SMS.SND_NO
	                            ,SMS.SND_TYPE
	                            ,SMS.RCV_NUMBER1
	                            ,SMS.RCV_NUMBER2
	                            ,SMS.RCV_NUMBER3
	                            ,SMS.RCV_NAME
	                            ,SMS.SND_NUMBER
	                            ,SMS.NEW_CODE
	                            ,EM.KOR_NAME AS [EMP_NAME]
	                            ,SMS.BODY
	                            ,SMS.NEW_DATE
	                            ,SMS.SND_RESULT
	                      FROM   Diablo.dbo.RES_SND_SMS SMS WITH(NOLOCK)
	                             LEFT OUTER JOIN DIABLO.DBO.EMP_MASTER EM
	                                  ON  SMS.NEW_CODE = EM.EMP_CODE
	                      WHERE  SMS.CUS_NO = @CUSTOMER_NO
	                             AND @SMS_FLAG = 1
	                  ) SMS 
	           
	           UNION ALL 
	           
	           /*이메일*/  
	           SELECT EML.SND_NO AS REF_NO
	                 ,EML.TITLE
	                 ,EML.TITLE AS [MESSAGE]
	                 ,EML.NEW_DATE AS SEND_DATE
	                 ,4 AS ALARM_TYPE
	                 ,'F' AS CHECK_READ
	                 ,'' AS MSG_TYPE
	           FROM   Diablo.dbo.RES_CUSTOMER RES WITH(NOLOCK)
	                  INNER JOIN Diablo.dbo.RES_SND_EMAIL EML WITH(NOLOCK)
	                       ON  RES.RES_CODE = EML.RES_CODE
	                  LEFT OUTER JOIN Diablo.dbo.EMP_MASTER EM WITH(NOLOCK)
	                       ON  EML.NEW_CODE = EM.EMP_CODE
	           WHERE  RES.CUS_NO = @CUSTOMER_NO
	                  AND @EMAIL_FLAG = 1
	       ) A
	ORDER BY
	       A.SEND_DATE DESC 
	       
	       OFFSET @Start ROWS
	
	FETCH NEXT @PAGE_SIZE ROWS ONLY  
	
	
	SELECT @TOTAL_COUNT = SUM(CNT)
	FROM   (
	           /*큐비*/  
	           SELECT COUNT(*) AS CNT
	           FROM   dbo.CUV_MASTER AS CM WITH(NOLOCK)
	                  JOIN dbo.CUV_RECEIVE AS CR WITH(NOLOCK)
	                       ON  CR.CUV_SEQ = CM.CUV_SEQ
	           WHERE  CR.CUS_NO = @CUSTOMER_NO
	                  AND @CUVE_FLAG = 1 
	           
	           UNION ALL 
	           
	           /*푸시*/  
	           SELECT COUNT(*) AS CNT
	           FROM   APP_PUSH_MSG_ALARM A
	                 ,APP_PUSH_MSG_INFO B WITH(NOLOCK)
	           WHERE  A.MSG_NO = B.MSG_NO 
	                  --AND (@MSG_NO = -1 OR A.MSG_NO = @MSG_NO)
	                  AND A.CUS_NO = @CUSTOMER_NO
	                  AND B.RECV_DATE > DATEADD(M ,-1 ,GETDATE())
	                  AND @PUSH_FLAG = 1 
	           UNION ALL
	           SELECT COUNT(*) AS CNT
	           FROM   APP_MESSAGE_damo A(NOLOCK)
	                  JOIN APP_RECEIVE B(NOLOCK)
	                       ON  A.MSG_SEQ_NO = B.MSG_SEQ_NO
	           WHERE  B.CUS_NO = @CUSTOMER_NO
	                  AND A.NEW_DATE > DATEADD(M ,-1 ,GETDATE())
	                  AND @PUSH_FLAG = 1 
	           
	           UNION ALL 
	           
	           /*메시지*/  
	           SELECT COUNT(*) AS CNT
	           FROM   (
	                      SELECT SMS.SND_NO
	                            ,SMS.SND_TYPE
	                            ,SMS.RCV_NUMBER1
	                            ,SMS.RCV_NUMBER2
	                            ,SMS.RCV_NUMBER3
	                            ,SMS.RCV_NAME
	                            ,SMS.SND_NUMBER
	                            ,SMS.NEW_CODE
	                            ,EM.KOR_NAME AS [EMP_NAME]
	                            ,SMS.BODY
	                            ,SMS.NEW_DATE
	                            ,SMS.SND_RESULT
	                      FROM   Diablo.dbo.RES_CUSTOMER RES WITH(NOLOCK)
	                             INNER JOIN Diablo.dbo.RES_SND_SMS SMS WITH(NOLOCK)
	                                  ON  RES.RES_CODE = SMS.RES_CODE
	                             LEFT OUTER JOIN DIABLO.DBO.EMP_MASTER EM
	                                  ON  SMS.NEW_CODE = EM.EMP_CODE
	                      WHERE  RES.CUS_NO = @CUSTOMER_NO
	                             AND @SMS_FLAG = 1
	                             AND SMS.SND_NO NOT IN (SELECT SMS.SND_NO
	                                                    FROM   Diablo.dbo.RES_SND_SMS SMS WITH(NOLOCK)
	                                                    WHERE  SMS.CUS_NO = @CUSTOMER_NO) 
	                      UNION ALL  
	                      SELECT SMS.SND_NO
	                            ,SMS.SND_TYPE
	                            ,SMS.RCV_NUMBER1
	                            ,SMS.RCV_NUMBER2
	                            ,SMS.RCV_NUMBER3
	                            ,SMS.RCV_NAME
	                            ,SMS.SND_NUMBER
	                            ,SMS.NEW_CODE
	                            ,EM.KOR_NAME AS [EMP_NAME]
	                            ,SMS.BODY
	                            ,SMS.NEW_DATE
	                            ,SMS.SND_RESULT
	                      FROM   Diablo.dbo.RES_SND_SMS SMS WITH(NOLOCK)
	                             LEFT OUTER JOIN DIABLO.DBO.EMP_MASTER EM
	                                  ON  SMS.NEW_CODE = EM.EMP_CODE
	                      WHERE  SMS.CUS_NO = @CUSTOMER_NO
	                             AND @SMS_FLAG = 1
	                  ) SMS 
	           
	           UNION ALL 
	           
	           /*이메일*/  
	           SELECT COUNT(*) AS CNT
	           FROM   Diablo.dbo.RES_CUSTOMER RES WITH(NOLOCK)
	                  INNER JOIN Diablo.dbo.RES_SND_EMAIL EML WITH(NOLOCK)
	                       ON  RES.RES_CODE = EML.RES_CODE
	                  LEFT OUTER JOIN Diablo.dbo.EMP_MASTER EM WITH(NOLOCK)
	                       ON  EML.NEW_CODE = EM.EMP_CODE
	           WHERE  RES.CUS_NO = @CUSTOMER_NO
	                  AND @EMAIL_FLAG = 1
	       ) A
END  
GO
