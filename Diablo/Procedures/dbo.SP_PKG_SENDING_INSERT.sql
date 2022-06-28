USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PKG_SENDING_INSERT
■ DESCRIPTION				: 샌딩 입력
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
    2017-04-17		정지용			최초생성
	2018-02-20		김성호			고유키생성 ex: 2K001 (1년 범위 UNIQUE) 첫자리:월,둘째자리:일,나머지:일련번호
	2018-03-06		김성호			고유키생성 ex: M06001 (월 범위 UNIQUE) 첫자리:공항터미널,둘셋째자리:일자,나머지:일련번호
	2018-10-10		박형만			SEND_KEY NULL 일때 실패 
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PKG_SENDING_INSERT]
	@PRO_CODE VARCHAR(20),
	@PRO_NAME VARCHAR(200),
	@DEP_DATE DATETIME,
	@DEP_TIME CHAR(5),
	@TRANS_NAME VARCHAR(15),
	@MEET_CNT INT,
	@CONTRACT_CNT INT,
	@RECEIPT_CNT INT,
	@MEET_COUNTER INT,
	@MEET_DATE DATETIME,
	@MEET_TIME CHAR(5),
	@REMARK VARCHAR(2000),
	@MANAGER_CODE CHAR(7),
	@INNER_NUMBER VARCHAR(4),
	@EMR_TEL_NUMBER VARCHAR(11),
	@TC_YN CHAR(1),
	@NEW_CODE CHAR(7)
AS 
BEGIN
	SET NOCOUNT OFF;

	BEGIN TRY

	BEGIN TRAN

	/*
	IF EXISTS (SELECT 1 FROM PKG_SENDING WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE )
	BEGIN
		SELECT 'EXISTS';
		RETURN;
	END
	*/

	-- 고유키 발급 **************************************************************************************************************

--	컬럼추가
--	ALTER TABLE dbo.PKG_SENDING ADD SEND_KEY VARCHAR(5) NULL;

	--DECLARE @SEND_KEY VARCHAR(5), @DAY_ARRAY VARCHAR(100) = '1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V';
	--SET @SEND_KEY = (SELECT DATA FROM FN_SPLIT(@DAY_ARRAY, ',') A WHERE A.ID = MONTH(@MEET_DATE)) + (SELECT DATA FROM FN_SPLIT(@DAY_ARRAY, ',') A WHERE A.ID = DAY(@MEET_DATE));

	DECLARE @SEND_KEY VARCHAR(6), @MEET_COUNTER_VAL CHAR(1), @MEET_DAY CHAR(2);	
	SELECT @MEET_COUNTER_VAL = CASE @MEET_COUNTER WHEN 2 THEN 'M' WHEN 4 THEN 'H' WHEN 3 THEN 'G' END, @MEET_DAY = FORMAT(@MEET_DATE, 'dd');
	SET @SEND_KEY = @MEET_COUNTER_VAL + @MEET_DAY;

	SELECT @SEND_KEY = (@SEND_KEY + RIGHT(('000' + CONVERT(VARCHAR(3), ISNULL(MAX(SUBSTRING(A.SEND_KEY, 4, 3)), 0) + 1)), 3))
	FROM PKG_SENDING A WITH(NOLOCK)
	WHERE A.MEET_DATE = @MEET_DATE;
	-- **************************************************************************************************************************


	IF( @SEND_KEY IS NOT NULL ) 
	BEGIN
		INSERT INTO PKG_SENDING (
			PRO_CODE, PRO_NAME, DEP_DATE, DEP_TIME, TRANS_NAME, 
			MEET_CNT, CONTRACT_CNT, RECEIPT_CNT, MEET_COUNTER, MEET_DATE, MEET_TIME, 
			MANAGER_CODE, INNER_NUMBER, EMR_TEL_NUMBER, TC_YN,
			REMARK, NEW_CODE, NEW_DATE, SEND_KEY
		)
		VALUES (
			@PRO_CODE, @PRO_NAME, @DEP_DATE, @DEP_TIME, @TRANS_NAME,
			@MEET_CNT, @CONTRACT_CNT, @RECEIPT_CNT, @MEET_COUNTER, @MEET_DATE, @MEET_TIME,
			@MANAGER_CODE, @INNER_NUMBER, @EMR_TEL_NUMBER, @TC_YN,
			@REMARK, @NEW_CODE, GETDATE(), @SEND_KEY
		);	
	END 
	

	IF @@ROWCOUNT > 0
	BEGIN
		SELECT 'SUCC';
	END
	ELSE
	BEGIN
		SELECT 'FAIL';
	END

	COMMIT TRAN

	END TRY
	BEGIN CATCH 
		ROLLBACK TRAN

		SELECT 'FAIL';
	END CATCH
END



GO
