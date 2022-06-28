USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





    
/*================================================================================================================    
■ USP_NAME     : [ZP_SELECT_TEL_TOTAL_COUNT]    
■ DESCRIPTION    :   
■ INPUT PARAMETER   :     
■ OUTPUT PARAMETER   :     
■ EXEC      :     ZP_SELECT_TEL_TOTAL_COUNT 'telCount'
■ MEMO      :     누적전화번호 합계 조회(TEL 유효)
------------------------------------------------------------------------------------------------------------------    
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------    
   DATE    AUTHOR   DESCRIPTION               
------------------------------------------------------------------------------------------------------------------    
   2020-07-06  유민석   최초생성    
================================================================================================================*/
CREATE PROC [dbo].[ZP_SELECT_TEL_TOTAL_COUNT]
	@SearchTarget VARCHAR(20)
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	
	
	IF @SearchTarget = 'telCount' -- 전체
	BEGIN
		WITH LIST AS (
		         SELECT NOR_TEL1 + NOR_TEL2 + NOR_TEL3 AS TELNUMBER
		         FROM   VIEW_MEMBER
		         
		         
		         UNION	
		         SELECT NOR_TEL1 + NOR_TEL2 + NOR_TEL3 AS TELNUMBER
		         FROM   RES_MASTER_DAMO
		         
		         
		         UNION		
		         SELECT A.NOR_TEL1 + A.NOR_TEL2 + A.NOR_TEL3 AS TELNUMBER
		         FROM   RES_CUSTOMER_DAMO A 
		         WHERE  A.SALE_PRICE <> 0 -- 0원인 것은 인솔자 이므로 제외
		     )		
		
		SELECT COUNT(1)
		FROM   LIST
		WHERE  TELNUMBER NOT LIKE '0100%'
		       AND TELNUMBER NOT LIKE '0101%'
		       AND TELNUMBER LIKE '01%'
		       AND LEN(TELNUMBER) > 9
	END	
END
GO
