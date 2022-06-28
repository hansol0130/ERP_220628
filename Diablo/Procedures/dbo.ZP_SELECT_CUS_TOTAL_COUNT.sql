USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




    
/*================================================================================================================    
■ USP_NAME     : [ZP_SELECT_CUS_TOTAL_COUNT]    
■ DESCRIPTION    :   
■ INPUT PARAMETER   :     
■ OUTPUT PARAMETER   :     
■ EXEC      :     ZP_SELECT_CUS_TOTAL_COUNT 'totalCount', 'Y' 
■ MEMO      :     누적회원, 활성회원, 휴면회원 대상 TEL 유효 유무 조회
------------------------------------------------------------------------------------------------------------------    
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------    
   DATE    AUTHOR   DESCRIPTION               
------------------------------------------------------------------------------------------------------------------    
   2020-07-06  유민석   최초생성    
================================================================================================================*/
CREATE PROC [dbo].[ZP_SELECT_CUS_TOTAL_COUNT]
	@SearchTarget VARCHAR(20),
	@TelYN VARCHAR(20)
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	
	
	IF @SearchTarget = 'totalCount' -- 전체
	BEGIN
		SELECT COUNT(1) AS 'TotalCount'
		FROM   VIEW_MEMBER
		WHERE  (CASE WHEN @TelYN = 'totalTelCount' THEN 1
					 WHEN @TelYN = 'Y'
						  AND (NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '0100%' 
						  AND NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '0101%' 
						  AND NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '01%' 
						  AND LEN(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) > 9) THEN 1
					 WHEN @TelYN = 'N'
						  AND (NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '0100%' 
						  OR NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '0101%' 
						  OR NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '01%' 
						  OR LEN(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) <= 9 
						  OR NOR_TEL1 IS NULL 
						  OR NOR_TEL2 IS NULL 
						  OR NOR_TEL3 IS NULL) THEN 1
                     END) = 1
        
		SELECT COUNT(1) AS 'RcvAgreeTotalCount' -- SMS/EMAIL 전체 동의
		FROM   VIEW_MEMBER
		WHERE  (CASE WHEN @TelYN = 'totalTelCount' THEN 1
					 WHEN @TelYN = 'Y'
						  AND (NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '0100%' 
						  AND NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '0101%' 
						  AND NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '01%' 
						  AND LEN(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) > 9) THEN 1
					 WHEN @TelYN = 'N'
						  AND (NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '0100%' 
						  OR NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '0101%' 
						  OR NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '01%' 
						  OR LEN(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) <= 9 
						  OR NOR_TEL1 IS NULL 
						  OR NOR_TEL2 IS NULL 
						  OR NOR_TEL3 IS NULL) THEN 1
                     END) = 1
				AND RCV_EMAIL_YN = 'Y'
				AND RCV_SMS_YN = 'Y'	
    
    
		SELECT COUNT(1) AS 'EmailAgreeTotalCount' -- EMAIL만 동의
		FROM   VIEW_MEMBER
		WHERE  (CASE WHEN @TelYN = 'totalTelCount' THEN 1
					 WHEN @TelYN = 'Y'
						  AND (NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '0100%' 
						  AND NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '0101%' 
						  AND NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '01%' 
						  AND LEN(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) > 9) THEN 1
					 WHEN @TelYN = 'N'
						  AND (NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '0100%' 
						  OR NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '0101%' 
						  OR NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '01%' 
						  OR LEN(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) <= 9 
						  OR NOR_TEL1 IS NULL 
						  OR NOR_TEL2 IS NULL 
						  OR NOR_TEL3 IS NULL) THEN 1
                     END) = 1
				AND RCV_EMAIL_YN = 'Y'
				AND (RCV_SMS_YN = 'N' OR RCV_SMS_YN IS NULL)		
    
    
		SELECT COUNT(1) AS 'SmsAgreeTotalCount' -- SMS만 동의
		FROM   VIEW_MEMBER
		WHERE  (CASE WHEN @TelYN = 'totalTelCount' THEN 1
					 WHEN @TelYN = 'Y'
						  AND (NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '0100%' 
						  AND NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '0101%' 
						  AND NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '01%' 
						  AND LEN(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) > 9) THEN 1
					 WHEN @TelYN = 'N'
						  AND (NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '0100%' 
						  OR NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '0101%' 
						  OR NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '01%' 
						  OR LEN(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) <= 9 
						  OR NOR_TEL1 IS NULL 
						  OR NOR_TEL2 IS NULL 
						  OR NOR_TEL3 IS NULL) THEN 1
                     END) = 1
				AND (RCV_EMAIL_YN = 'N' OR RCV_EMAIL_YN IS NULL)
				AND RCV_SMS_YN = 'Y'   		       		  
	END
	
	ELSE IF @SearchTarget = 'cusCount' -- 활성회원일때
	BEGIN
		SELECT COUNT(1) AS 'TotalCount'
		FROM   VIEW_MEMBER
		WHERE  
			  (CASE WHEN @TelYN = 'totalTelCount' AND SLEEP_YN = 'N' THEN 1
					WHEN @TelYN = 'Y' AND SLEEP_YN = 'N'
						  AND (NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '0100%' 
						  AND NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '0101%' 
						  AND NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '01%' 
						  AND LEN(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) > 9) THEN 1
					 WHEN @TelYN = 'N' AND SLEEP_YN = 'N'
						  AND (NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '0100%' 
						  OR NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '0101%' 
						  OR NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '01%' 
						  OR LEN(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) <= 9 
						  OR NOR_TEL1 IS NULL 
						  OR NOR_TEL2 IS NULL 
						  OR NOR_TEL3 IS NULL) THEN 1
                     END) = 1
						
		SELECT COUNT(1) AS 'RcvAgreeTotalCount' -- SMS/EMAIL 전체 동의
		FROM   VIEW_MEMBER
		WHERE  
			  (CASE WHEN @TelYN = 'totalTelCount' AND SLEEP_YN = 'N' THEN 1
					WHEN @TelYN = 'Y' AND SLEEP_YN = 'N'
						  AND (NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '0100%' 
						  AND NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '0101%' 
						  AND NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '01%' 
						  AND LEN(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) > 9) THEN 1
					 WHEN @TelYN = 'N' AND SLEEP_YN = 'N'
						  AND (NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '0100%' 
						  OR NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '0101%' 
						  OR NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '01%' 
						  OR LEN(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) <= 9 
						  OR NOR_TEL1 IS NULL 
						  OR NOR_TEL2 IS NULL 
						  OR NOR_TEL3 IS NULL) THEN 1
                     END) = 1
				AND RCV_EMAIL_YN = 'Y'
				AND RCV_SMS_YN = 'Y'		
			       
		SELECT COUNT(1) AS 'EmailAgreeTotalCount' -- EMAIL만 동의
		FROM   VIEW_MEMBER
		WHERE  
			  (CASE WHEN @TelYN = 'totalTelCount' AND SLEEP_YN = 'N' THEN 1
					WHEN @TelYN = 'Y' AND SLEEP_YN = 'N'
						  AND (NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '0100%' 
						  AND NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '0101%' 
						  AND NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '01%' 
						  AND LEN(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) > 9) THEN 1
					 WHEN @TelYN = 'N' AND SLEEP_YN = 'N'
						  AND (NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '0100%' 
						  OR NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '0101%' 
						  OR NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '01%' 
						  OR LEN(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) <= 9 
						  OR NOR_TEL1 IS NULL 
						  OR NOR_TEL2 IS NULL 
						  OR NOR_TEL3 IS NULL) THEN 1
                     END) = 1
				AND RCV_EMAIL_YN = 'Y'
				AND (RCV_SMS_YN = 'N' OR RCV_SMS_YN IS NULL)
				      
		SELECT COUNT(1) AS 'SmsAgreeTotalCount' -- SMS만 동의
		FROM   VIEW_MEMBER
		WHERE  
			  (CASE WHEN @TelYN = 'totalTelCount' AND SLEEP_YN = 'N' THEN 1
					WHEN @TelYN = 'Y' AND SLEEP_YN = 'N'
						  AND (NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '0100%' 
						  AND NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '0101%' 
						  AND NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '01%' 
						  AND LEN(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) > 9) THEN 1
					 WHEN @TelYN = 'N' AND SLEEP_YN = 'N'
						  AND (NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '0100%' 
						  OR NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '0101%' 
						  OR NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '01%' 
						  OR LEN(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) <= 9 
						  OR NOR_TEL1 IS NULL 
						  OR NOR_TEL2 IS NULL 
						  OR NOR_TEL3 IS NULL) THEN 1
                     END) = 1
				AND (RCV_EMAIL_YN = 'N' OR RCV_EMAIL_YN IS NULL)
				AND RCV_SMS_YN = 'Y' 	       			       		       
	END
	
	ELSE IF @SearchTarget = 'cusSleep' -- 휴면회원일때
	BEGIN
		SELECT COUNT(1) AS 'TotalCount'
	    FROM   CUS_MEMBER_SLEEP
		WHERE (CASE WHEN @TelYN = 'totalTelCount' THEN 1
					WHEN @TelYN = 'Y'
						  AND (NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '0100%' 
						  AND NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '0101%' 
						  AND NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '01%' 
						  AND LEN(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) > 9) THEN 1
					WHEN @TelYN = 'N'
						  AND (NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '0100%' 
						  OR NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '0101%' 
						  OR NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '01%' 
						  OR LEN(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) <= 9 
						  OR NOR_TEL1 IS NULL 
						  OR NOR_TEL2 IS NULL 
						  OR NOR_TEL3 IS NULL) THEN 1
                     END) = 1	   		
				
		SELECT COUNT(1) AS 'RcvAgreeTotalCount' -- SMS/EMAIL 전체 동의
	    FROM   CUS_MEMBER_SLEEP
		WHERE (CASE WHEN @TelYN = 'totalTelCount' THEN 1
					WHEN @TelYN = 'Y'
						  AND (NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '0100%' 
						  AND NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '0101%' 
						  AND NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '01%' 
						  AND LEN(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) > 9) THEN 1
					WHEN @TelYN = 'N'
						  AND (NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '0100%' 
						  OR NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '0101%' 
						  OR NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '01%' 
						  OR LEN(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) <= 9 
						  OR NOR_TEL1 IS NULL 
						  OR NOR_TEL2 IS NULL 
						  OR NOR_TEL3 IS NULL) THEN 1
                     END) = 1
				AND RCV_EMAIL_YN = 'Y'
				AND RCV_SMS_YN = 'Y'	    
	           
	    SELECT COUNT(1) AS 'EmailAgreeTotalCount' -- EMAIL만 동의
	    FROM   CUS_MEMBER_SLEEP
		WHERE (CASE WHEN @TelYN = 'totalTelCount' THEN 1
					WHEN @TelYN = 'Y'
						  AND (NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '0100%' 
						  AND NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '0101%' 
						  AND NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '01%' 
						  AND LEN(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) > 9) THEN 1
					WHEN @TelYN = 'N'
						  AND (NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '0100%' 
						  OR NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '0101%' 
						  OR NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '01%' 
						  OR LEN(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) <= 9 
						  OR NOR_TEL1 IS NULL 
						  OR NOR_TEL2 IS NULL 
						  OR NOR_TEL3 IS NULL) THEN 1
                     END) = 1
				AND RCV_EMAIL_YN = 'Y'
				AND (RCV_SMS_YN = 'N' OR RCV_SMS_YN IS NULL)    
	           
	    SELECT COUNT(1) AS 'SmsAgreeTotalCount' -- SMS만 동의
	    FROM   CUS_MEMBER_SLEEP
		WHERE (CASE WHEN @TelYN = 'totalTelCount' THEN 1
					WHEN @TelYN = 'Y'
						  AND (NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '0100%' 
						  AND NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '0101%' 
						  AND NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '01%' 
						  AND LEN(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) > 9) THEN 1
					WHEN @TelYN = 'N'
						  AND (NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '0100%' 
						  OR NOR_TEL1 + NOR_TEL2 + NOR_TEL3 LIKE '0101%' 
						  OR NOR_TEL1 + NOR_TEL2 + NOR_TEL3 NOT LIKE '01%' 
						  OR LEN(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) <= 9 
						  OR NOR_TEL1 IS NULL 
						  OR NOR_TEL2 IS NULL 
						  OR NOR_TEL3 IS NULL) THEN 1
                     END) = 1
				AND (RCV_EMAIL_YN = 'N' OR RCV_EMAIL_YN IS NULL)
				AND RCV_SMS_YN = 'Y' 
	END		
END
GO
