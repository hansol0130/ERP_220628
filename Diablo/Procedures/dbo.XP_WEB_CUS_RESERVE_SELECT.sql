USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================  
■ USP_NAME     : [XP_WEB_CUS_RESERVE_SELECT]  
■ DESCRIPTION    : 고객 예약 내역 확인  
■ INPUT PARAMETER   :   
■ OUTPUT PARAMETER   :   
■ EXEC      :   
  
exec XP_WEB_CUS_RESERVE_SELECT @CUS_NO='11577193'  
  
■ MEMO      :   
------------------------------------------------------------------------------------------------------------------  
■ CHANGE HISTORY                     
------------------------------------------------------------------------------------------------------------------  
   DATE			AUTHOR			DESCRIPTION             
------------------------------------------------------------------------------------------------------------------  
   2019-05-13	김남훈			최초생성  
   2019-06-18	김남훈			예약기준아닌 출발일 기준으로.  
   2020-03-13	지니웍스 임검제	PKG_DETAIL NOLOCK 추가 , DEP_DATE 조건 삭제
================================================================================================================*/   
  
CREATE PROC [dbo].[XP_WEB_CUS_RESERVE_SELECT]  
 @CUS_NO   VARCHAR(20)    
AS   
BEGIN
	--SELECT A.RES_CODE, CONVERT(VARCHAR(10),A.DEP_DATE,121) AS DEP_DATE, C.PRO_NAME
	--FROM RES_MASTER_damo A WITH(NOLOCK)
	--LEFT JOIN RES_CUSTOMER_DAMO B WITH(NOLOCK)
	--ON A.RES_CODE = B.RES_CODE
	--INNER JOIN PKG_DETAIL C  WITH(NOLOCK)
	--ON A.PRO_CODE = C.PRO_CODE
	--WHERE (A.CUS_NO = @CUS_NO OR B.CUS_NO = @CUS_NO)
	--AND A.RES_STATE NOT IN (7,8,9) --취소되지않은
	--AND B.RES_STATE = 0   --정상출발자
	--AND B.VIEW_YN ='Y' --노출여부
	--AND A.DEP_DATE  >= DATEADD(MM,-3,GETDATE())  
	
	SELECT A.RES_CODE
	      ,CONVERT(VARCHAR(10) ,A.DEP_DATE ,121) AS DEP_DATE
	      ,C.PRO_NAME
	FROM   RES_MASTER_damo A WITH(NOLOCK)
	       LEFT JOIN RES_CUSTOMER_DAMO B WITH(NOLOCK)
	            ON  A.RES_CODE = B.RES_CODE
	       INNER JOIN PKG_DETAIL C WITH(NOLOCK)
	            ON  A.PRO_CODE = C.PRO_CODE
	WHERE  1 = 1
	       AND A.CUS_NO = @CUS_NO
	       AND A.RES_STATE NOT IN (7 ,8 ,9) --취소되지않은
	       AND B.RES_STATE = 0 --정상출발자
	       AND B.VIEW_YN = 'Y' --노출여부 
	SELECT A.RES_CODE
	      ,CONVERT(VARCHAR(10) ,A.DEP_DATE ,121) AS DEP_DATE
	      ,C.PRO_NAME
	FROM   RES_MASTER_damo A WITH(NOLOCK)
	       LEFT JOIN RES_CUSTOMER_DAMO B WITH(NOLOCK)
	            ON  A.RES_CODE = B.RES_CODE
	       INNER JOIN PKG_DETAIL C WITH(NOLOCK)
	            ON  A.PRO_CODE = C.PRO_CODE
	WHERE  1 = 1
	       AND B.CUS_NO = @CUS_NO
	       AND A.RES_STATE NOT IN (7 ,8 ,9) --취소되지않은
	       AND B.RES_STATE = 0 --정상출발자
	       AND B.VIEW_YN = 'Y' --노출여부
END  
  
  
GO
