USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_WEB_EVT_ROULETTE_RESULT
■ DESCRIPTION				: 회원의 룰렛이벤트 당첨정보를 가져온다.
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
EXEC XP_WEB_EVT_ROULETTE_RESULT 15, '자유시간'
SELECT * FROM EVT_ROULETTE
SELECT * FROM EVT_ROULETTE_WINNER
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-05-19		정지용
================================================================================================================*/ 
CREATE PROC [dbo].[XP_WEB_EVT_ROULETTE_RESULT]
	@CUS_NO INT,
	@PRODUCT_NAME VARCHAR(20)
AS 
BEGIN	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	DECLARE @CNT INT;
	SELECT @CNT = COUNT(1) FROM EVT_ROULETTE WITH(NOLOCK) WHERE CUS_CODE = @CUS_NO AND COP_USE_YN = 'N'

	-- 참여가능 횟수 없을 때 리턴
	IF @CNT = 0
	BEGIN
		SELECT 0;
		RETURN;
	END
	ELSE
	BEGIN

		DECLARE @EVT_WIN_SEQ INT
		DECLARE @COD_TYPE VARCHAR(10);
		SET @COD_TYPE = ('EVT1');
		EXEC [dbo].[SP_COD_GETSEQ_UNLIMITED] @COD_TYPE, @EVT_WIN_SEQ OUTPUT
		-- DELETE FROM COD_SEQ WHERE COD_TYPE = 'EVT1'

		DECLARE @RESULT INT;	
		SELECT @RESULT = ISNULL(EVT_RESULT, 4) FROM EVT_ROULETTE_WINNER WITH(NOLOCK) WHERE EVT_WIN_SEQ = @EVT_WIN_SEQ;

		IF ISNULL(@RESULT, '') = ''
		BEGIN
			SET @RESULT = 4;
		END

		-- ## 추가 : 이전에 1, 2, 3등에 당첨되었다면 중복당첨 안되게 업데이트
		IF EXISTS(SELECT 1 FROM EVT_ROULETTE WITH(NOLOCK) WHERE CUS_CODE = @CUS_NO AND EVT_RESULT IN (1, 2, 3))
		BEGIN
			SET @RESULT = 4;

			UPDATE EVT_W SET 
					EVT_WIN_SEQ = @EVT_WIN_SEQ + 1
				FROM (
					SELECT EVT_WIN_SEQ FROM EVT_ROULETTE_WINNER WITH(NOLOCK) WHERE EVT_WIN_SEQ = @EVT_WIN_SEQ
				) EVT_W
		END
		--

		-- ## 4등이 아닐때는 NULL
		IF @RESULT <> 4
		BEGIN
			SET @PRODUCT_NAME = NULL;
		END		

		-- ## 결과를 업데이트 한다.
		DECLARE @EVT_ROU_SEQ INT
		UPDATE EVT_R SET 
			@EVT_ROU_SEQ = EVT_ROU_SEQ = EVT_ROU_SEQ, EVT_WIN_SEQ = @EVT_WIN_SEQ, EVT_RESULT = @RESULT, EVT_PRODUCT = @PRODUCT_NAME, COP_USE_YN = 'Y', EDT_DATE = GETDATE()
		FROM ( 
			SELECT 
				TOP 1 EVT_ROU_SEQ, EVT_WIN_SEQ, EVT_RESULT, EVT_PRODUCT, COP_USE_YN, EDT_DATE
			FROM EVT_ROULETTE 
			WHERE CUS_CODE = @CUS_NO AND COP_USE_YN = 'N'
			ORDER BY EVT_WIN_SEQ ASC
		) EVT_R
		
		-- ## 1, 2, 3등 일때만
		IF @RESULT = 1 OR @RESULT = 2 OR @RESULT = 3
		BEGIN
			UPDATE EVT_W SET
				WIN_YN = 'Y'
			FROM (
				SELECT WIN_YN FROM EVT_ROULETTE_WINNER  WHERE EVT_WIN_SEQ = @EVT_WIN_SEQ AND WIN_YN = 'N'
			) EVT_W
		END

		SELECT @RESULT AS EVT_RESULT, @EVT_ROU_SEQ AS EVT_ROU_SEQ;
		RETURN;
	END
END 
GO
