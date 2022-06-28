USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================      
■ USP_NAME     : SP_MOV2_SNS_CUS_INSERT      
■ DESCRIPTION    : 입력_SNS 가입정보입력      
■ INPUT PARAMETER   : @CUS_NO, @SNS_COMPANY, @SNS_ID, @SNS_EMAIL, @SNS_NAME      
■ EXEC      :
       
    -- SP_MOV2_SNS_CUS_INSERT '8505125', '1','232328505125','a@a.gmail.com', '김호석'   --일반 회원등록번호 ,SNS 회사 ,SNS 발행 아이디, 이메일, 이름      
 EXEC SP_MOV2_SNS_CUS_INSERT '7225080', '3','10417444','uniajung@naver.com', '..러브유'      
 SELECT * FROM CUS_SNS_INFO
       
■ MEMO      : SNS 회원가입시 일반 회원가입 키값으로  SNS 회원입력.      
------------------------------------------------------------------------------------------------------------------      
■ CHANGE HISTORY                         
------------------------------------------------------------------------------------------------------------------      
   DATE			AUTHOR				DESCRIPTION                 
------------------------------------------------------------------------------------------------------------------      
   2017-05-26	아이비솔루션			최초생성      
   2017-10-23	정지용				수정      
   2020-02-19	임검제(지니웍스)		INFLOW TYPE 추가     
   2020-02-20	임검제(지니웍스)		INFLOW 타입 입력되지 않은사람만 수정되도록 수정  
   2020-03-02	임검제(지니웍스)		INFLOW 타입 업데이트 추가
   2020-05-22	김영민(EHD)     		카카오통계출력으로인한 수정
   2020-08-06   홍종우					카카오싱크 로그인 연동 오류 수정
   2020-09-17   홍종우					@SNS_ID VARCHAR(20) -> VARCHAR(100) 변경
   2020-12-24	김영민					카카오톡 => 카카오싱크 신규가입시 카카오톡 DISCNT_DATE UPDATE
================================================================================================================*/       
CREATE PROCEDURE [dbo].[SP_SLIME_SNS_CUS_INSERT]      
(      
	@CUS_NO     INT,      
	@SNS_COMPANY   INT,      
	@SNS_ID    VARCHAR(100),      
	@SNS_EMAIL   VARCHAR(200),      
	@SNS_NAME   VARCHAR(20)  ,    
	@INFLOW_TYPE  INT    
)     
AS      
BEGIN       
	SET NOCOUNT ON;      --기존인원
	IF EXISTS ( SELECT 1 FROM CUS_SNS_INFO WITH(NOLOCK) WHERE SNS_COMPANY = @SNS_COMPANY AND SNS_ID = @SNS_ID  AND DISCNT_DATE IS NULL )      
	BEGIN       
		UPDATE dbo.CUS_SNS_INFO 
		SET 
		    CUS_NO = @CUS_NO,
			INFLOW_TYPE = 
			(   
					CASE ISNULL(@INFLOW_TYPE,1)   
						WHEN 0 THEN 1   
						ELSE @INFLOW_TYPE  
					END 
			),
			CHANGE_DATE = 
			(   
				CASE ISNULL(@INFLOW_TYPE,1)   
					WHEN 1 THEN null     
					WHEN 2 THEN GETDATE()   
					ELSE null  
				END  
			),
			NEW_DATE = GETDATE()
		WHERE SNS_COMPANY = @SNS_COMPANY AND SNS_ID = @SNS_ID AND DISCNT_DATE IS NULL;

		SELECT 'SNS_EXISTS';      
		RETURN;      
	END      
	ELSE      
	BEGIN      --싱크해제인원
		IF EXISTS ( SELECT 1 FROM CUS_SNS_INFO WITH(NOLOCK) WHERE SNS_COMPANY = @SNS_COMPANY AND SNS_ID = @SNS_ID  AND DISCNT_DATE IS NOT NULL)      
		BEGIN      
			UPDATE CUS_SNS_INFO SET       
				CUS_NO = @CUS_NO,            
				SNS_ID = @SNS_ID,      
				SNS_EMAIL = @SNS_EMAIL,      
				DISCNT_DATE = null,      
				NEW_DATE = GETDATE(),
				CHANGE_DATE = 
				(   
					CASE ISNULL(@INFLOW_TYPE,1)   
						WHEN 1 THEN null   
						WHEN 2 THEN GETDATE()   
						ELSE null  
					END  
				),
				INFLOW_TYPE = 
				(   
					CASE ISNULL(@INFLOW_TYPE,1)   
						WHEN 0 THEN 1   
						ELSE @INFLOW_TYPE  
					END 
				)
				WHERE SNS_COMPANY = @SNS_COMPANY AND SNS_ID = @SNS_ID;      
		END      
		ELSE      
		BEGIN     --신규인원 
			INSERT INTO CUS_SNS_INFO (CUS_NO, SNS_COMPANY,SNS_ID,SNS_EMAIL,SNS_NAME, NEW_DATE, INFLOW_TYPE, CHANGE_DATE)      
			VALUES(@CUS_NO, @SNS_COMPANY, @SNS_ID, @SNS_EMAIL, @SNS_NAME, GETDATE(), 
				(   
					CASE ISNULL(@INFLOW_TYPE,1)   
						WHEN 0 THEN 1   
						ELSE @INFLOW_TYPE  
					END  
				),
				(
					CASE ISNULL(@INFLOW_TYPE,1)   
						WHEN 1 THEN null   
						WHEN 2 THEN GETDATE()   
						ELSE null  
					END  
				)
			);      
			 --카카오톡사용자 DISCNT_DATE UPDATE
			MERGE CUS_SNS_INFO AS A
				USING
				(
				SELECT CUS_NO ,
				CREATE_DATE FROM
				CUS_SNS_INFO WHERE SNS_COMPANY = 4 AND DISCNT_DATE IS NULL
				)
				AS B
				ON A.CUS_NO = B.CUS_NO
				AND A.SNS_COMPANY = 2
				AND A.DISCNT_DATE IS NULL
				WHEN MATCHED THEN
			UPDATE SET A.DISCNT_DATE = B.CREATE_DATE;   
		END
		
		SELECT '';      
	END      
/*      
IF EXISTS(SELECT * FROM CUS_SNS_INFO WHERE CUS_NO=@CUS_NO)      
BEGIN      
 SET NOCOUNT ON;      
 UPDATE CUS_SNS_INFO SET SNS_COMPANY=@SNS_COMPANY,SNS_ID=@SNS_ID,SNS_EMAIL=@SNS_EMAIL,DISCNT_DATE=null,NEW_DATE=GETDATE()      
  OUTPUT INSERTED.*      
 WHERE CUS_NO=@CUS_NO      
END      
ELSE      
BEGIN      
 SET NOCOUNT ON;      
 INSERT INTO CUS_SNS_INFO (CUS_NO, SNS_COMPANY,SNS_ID,SNS_EMAIL,SNS_NAME, NEW_DATE)      
   OUTPUT INSERTED.*      
 VALUES(@CUS_NO, @SNS_COMPANY, @SNS_ID, @SNS_EMAIL, @SNS_NAME, GETDATE())      
END      
*/      
END      
      
GO
