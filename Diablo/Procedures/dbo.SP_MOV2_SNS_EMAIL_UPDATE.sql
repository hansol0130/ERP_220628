USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*-------------------------------------------------------------------------------------------------
■ Server					: CUS_SNS_INFO 이메일 정보가 없다면 업데이트 한다.
■ Database					: DIABLO
■ USP_Name					: SP_MOV2_SNS_EMAIL_UPDATE
■ Description				: SNS EMAIL
■ Input Parameter			:                  		
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC SP_MOV2_SNS_EMAIL_UPDATE 
■ Author					: 정지용  
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2018-03-23		정지용			최초생성
-------------------------------------------------------------------------------------------------*/ 
CREATE PROC [dbo].[SP_MOV2_SNS_EMAIL_UPDATE] 
(
	@SNS_EMAIL VARCHAR(100),
	@SNS_COMPANY INT,
	@SNS_ID VARCHAR(30),
	@CUS_NO INT
) AS 
BEGIN
	IF EXISTS ( SELECT 1 FROM CUS_SNS_INFO WITH(NOLOCK) WHERE CUS_NO = @CUS_NO AND SNS_ID = @SNS_ID AND SNS_COMPANY = @SNS_COMPANY AND SNS_EMAIL IS NULL )
	BEGIN 
		UPDATE CUS_SNS_INFO SET SNS_EMAIL = @SNS_EMAIL WHERE CUS_NO = @CUS_NO AND SNS_ID = @SNS_ID AND SNS_COMPANY = @SNS_COMPANY AND SNS_EMAIL IS NULL;
	END
END
GO
