USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*================================================================================================================
■ USP_NAME					: XP_ARG_GUIDE_ARRANGE
■ DESCRIPTION				: 대외업무시스템 랜드사 가이드 배정 및 배정 취소
■ INPUT PARAMETER			: 
	@ARG_SEQ_NO		INT ,			: 수배번호
	@PRO_CODE		VARCHAR(20),	: 행사코드
	@AGT_CODE		VARCHAR(10),	: 랜드사코드
	@MEM_CODE		VARCHAR(7),		: 가이드코드
	@NEW_CODE		VARCHAR(7),		: 
	@ARRANGE_KIND	VARCHAR(1),		: 배정 구분  A(배정)/C(취소)
	@RESULTS		INT OUTPUT
■ OUTPUT PARAMETER			: 
   
■ EXEC						: 

	exec XP_ARG_GUIDE_ARRANGE 1, '', '92685', 'L130122', '9999999', 'C', 0

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-31		김완기			최초생성    
   2014-04-09		정지용			스키마 변경으로 수정
================================================================================================================*/ 
CREATE PROC [dbo].[XP_ARG_GUIDE_ARRANGE]
	@ARG_CODE		VARCHAR(12) ,
	@PRO_CODE		VARCHAR(20),
	@AGT_CODE		VARCHAR(10),
	@MEM_CODE		VARCHAR(7),
	@NEW_CODE		VARCHAR(7),
	@ARRANGE_KIND	VARCHAR(1),		-- A(배정)/C(취소)
	@RESULTS		INT OUTPUT
AS 
BEGIN
	
	DECLARE @ARRANGE_COUNT INT;

	SELECT @ARRANGE_COUNT = COUNT(*) FROM ARG_GUIDE WHERE ARG_CODE = @ARG_CODE AND MEM_CODE = @MEM_CODE

	SET @RESULTS = 0;


	--SELECT * FROM ARG_GUIDE

	--배정
	IF @ARRANGE_KIND = 'A'
		BEGIN
			IF @ARRANGE_COUNT > 0
				BEGIN
					SET @RESULTS = -1;
				END
			ELSE
				BEGIN
					DECLARE @ARG_GUIDE_SEQ INT
					SELECT @ARG_GUIDE_SEQ = ISNULL((SELECT ARG_GUIDE_SEQ FROM ARG_GUIDE WHERE ARG_CODE = @ARG_CODE), 0) + 1

					INSERT INTO ARG_GUIDE (ARG_CODE, ARG_GUIDE_SEQ, AGT_CODE, MEM_CODE, NEW_CODE, NEW_DATE)
					VALUES (@ARG_CODE, @ARG_GUIDE_SEQ, @AGT_CODE, @MEM_CODE, @NEW_CODE, GETDATE())
				END
		END

	--배정 취소
	ELSE IF @ARRANGE_KIND  = 'C'
		BEGIN
			IF @ARRANGE_COUNT < 1
				BEGIN
					SET @RESULTS = -2;
				END
			ELSE
				BEGIN
					DELETE ARG_GUIDE WHERE ARG_CODE = @ARG_CODE AND MEM_CODE = @MEM_CODE
				END
		END

	SELECT @RESULTS

END 


GO
