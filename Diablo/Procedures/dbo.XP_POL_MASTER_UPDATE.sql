USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_POL_MASTER_UPDATE
■ DESCRIPTION				: 폴마스터 수정
■ INPUT PARAMETER			: 
	@MASTER_SEQ				: 폴마스터 코드
	@TARGET					: 대상(0-비회원, 1-회원, 2-내부)
	@POL_TYPE				: 구분(1-전체평가, 2-가이드평가, 3-호텔평가, 4-식사평가, 5-고객평가, 6-이벤트)
	@POL_STATE				: 상태(1-진행중, 2-종료)
	@SUBJECT				: 제목
	@POL_DESC				: 설명
	@START_DATE				: 시작일자
	@END_DATE				: 종료일자
	@OPEN_DATE				: 발표일자
	@EDT_CODE				: 수정자 코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_POL_MASTER_UPDATE (1, 0, 1, 1, '폴마스터 등록 테스트 수정', '', '2013-04-05', '2013-05-05', NULL,  '9999999')

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-05		최영준			최초생성
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[XP_POL_MASTER_UPDATE]
	@MASTER_SEQ		INT,
	@TARGET			CHAR(1),
	@POL_TYPE		CHAR(1),
	@POL_STATE		CHAR(1),
	@SUBJECT		VARCHAR(400),
	@POL_DESC		TEXT,
	@START_DATE		DATETIME,
	@END_DATE		DATETIME,
	@OPEN_DATE		DATETIME,
	@EDT_CODE		CHAR(7)
AS
BEGIN
	SET NOCOUNT OFF;

	BEGIN

		UPDATE POL_MASTER SET 
			[TARGET] = @TARGET,
			POL_TYPE = @POL_TYPE,
			POL_STATE = @POL_STATE,
			[SUBJECT] = @SUBJECT,
			POL_DESC = @POL_DESC,
			[START_DATE] = @START_DATE,
			END_DATE = @END_DATE,
			OPEN_DATE = @OPEN_DATE,
			EDT_CODE = @EDT_CODE,
			EDT_DATE = GETDATE()
		WHERE MASTER_SEQ = @MASTER_SEQ
		
	END
END


GO
