USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_IVR_SMS_INSERT
■ DESCRIPTION				: SMS 전송 데이터 저장
■ INPUT PARAMETER			: SMS 전송 내역
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	DECLARE @SND_NO INT, @INNER_NUMBER VARCHAR(20)
	exec SP_IVR_SMS_INSERT @SND_NO OUTPUT, @INNER_NUMBER OUTPUT, 35, '02-2188-4683', '내용', 0, '010', '3215', '9860', '김길동', '2008011', 2, 'RP1407071921'
	SELECT @SND_NO, @INNER_NUMBER

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-10-17		김성호			최초생성
   2014-10-28		김성호			발신자 번호 오류 수 
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_IVR_SMS_INSERT]
(
	@SND_NO			INT	OUTPUT,
	@INNER_NUMBER	VARCHAR(20) OUTPUT,
	@SND_TYPE		INT,
	@SND_NUMBER		VARCHAR(20),
	@BODY			VARCHAR(500),
	@SND_RESULT		INT,
	@RCV_NUMBER1	VARCHAR(4),
	@RCV_NUMBER2	VARCHAR(4),
	@RCV_NUMBER3	VARCHAR(4),
	@RCV_NAME		VARCHAR(40),
	@NEW_CODE		VARCHAR(10),
	@SND_METHOD		CHAR(1),
	@RES_CODE		VARCHAR(20)
)

AS  
BEGIN

	SELECT @INNER_NUMBER = (ISNULL(B.INNER_NUMBER1, '') + ISNULL(B.INNER_NUMBER2, '') + ISNULL(B.INNER_NUMBER3, ''))
	FROM Diablo.DBO.RES_MASTER_DAMO A WITH(NOLOCK)
	INNER JOIN Diablo.DBO.EMP_MASTER B WITH(NOLOCK) ON A.NEW_CODE = B.EMP_CODE
	WHERE A.RES_CODE = @RES_CODE;

	INSERT INTO Diablo.DBO.RES_SND_SMS (
		SND_TYPE, SND_NUMBER, BODY, SND_RESULT, RCV_NUMBER1, RCV_NUMBER2, RCV_NUMBER3, RCV_NAME, NEW_CODE, NEW_DATE, SND_METHOD, RES_CODE
	) VALUES (
		@SND_TYPE, @INNER_NUMBER, @BODY, @SND_RESULT, @RCV_NUMBER1, @RCV_NUMBER2, @RCV_NUMBER3, @RCV_NAME, @NEW_CODE, GETDATE(), @SND_METHOD, @RES_CODE
	);		
	
	SELECT @SND_NO = @@IDENTITY;
END
GO
