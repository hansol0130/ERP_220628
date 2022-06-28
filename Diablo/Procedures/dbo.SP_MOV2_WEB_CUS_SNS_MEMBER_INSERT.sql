USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_WEB_CUS_SNS_MEMBER_INSERT
■ DESCRIPTION				: 회원가입 정보 입력 (SNS 회원)
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec  SP_MOV2_WEB_CUS_SNS_MEMBER_INSERT
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-09-27	아이비솔루션		최초 생성 (SNS 회원 가입용으로 별도 생성)
================================================================================================================*/ 
CREATE PROC [dbo].[SP_MOV2_WEB_CUS_SNS_MEMBER_INSERT]
(
	@CUS_ID			VARCHAR(20), 
	@CUS_PASS		VARCHAR(100), 
	@CUS_NAME		VARCHAR(20),
	@EMAIL			VARCHAR(40),
	@SNS_COMPANY	VARCHAR(30),
	@SNS_ID			VARCHAR(30),
	@SNS_EMAIL		VARCHAR(100)
)
AS 
BEGIN
/*
JOIN_TYPE (모바일 가입: 0 , 웹회원가입 : 1)
*/
	DECLARE @CUS_NO INT

	-- 여행자 테이블
	INSERT INTO CUS_CUSTOMER_DAMO
		(
			CUS_ID, CUS_PASS, CUS_NAME, EMAIL, LUNAR_YN, NEW_CODE, NEW_DATE,
			EMAIL_INFLOW_TYPE, SMS_INFLOW_TYPE
		)
	VALUES
		(
			@CUS_ID, @CUS_PASS, @CUS_NAME, @EMAIL, 'N' , '9999999', GETDATE(),
			'99', '99'
		)

	SELECT @CUS_NO = @@IDENTITY
			
	-- 회원 테이블
	INSERT INTO CUS_MEMBER
		(
			CUS_NO, CUS_ID, CUS_PASS, CUS_NAME, EMAIL, LUNAR_YN, NEW_CODE, NEW_DATE, JOIN_TYPE
		)
	VALUES
		(
			@CUS_NO, @CUS_ID, @CUS_PASS, @CUS_NAME, @EMAIL, 'N', '9999999', GETDATE(), 0
		)

	-- SNS 연동 정보 테이블
	INSERT INTO CUS_SNS_INFO
        (
			CUS_NO, SNS_COMPANY, SNS_ID , SNS_EMAIL
		)
     VALUES
		(
			@CUS_NO, @SNS_COMPANY, @SNS_ID, @SNS_EMAIL
		)

	-- 고객번호 리턴
	SELECT @CUS_NO
END

GO
