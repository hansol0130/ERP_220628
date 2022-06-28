USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_POL_MASTER_INSERT
■ DESCRIPTION				: 폴마스터 등록
■ INPUT PARAMETER			:
	@TARGET					: 대상(0-비회원, 1-회원, 2-내부)
	@POL_TYPE				: 구분(1-전체평가, 2-가이드평가, 3-호텔평가, 4-식사평가, 5-고객평가, 6-이벤트)
	@POL_STATE				: 상태(1-진행중, 2-종료)
	@SUBJECT				: 제목
	@POL_DESC				: 설명
	@START_DATE				: 시작일자
	@END_DATE				: 종료일자
	@OPEN_DATE				: 발표일자
	@NEW_CODE				: 등록자 코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_POL_MASTER_INSERT ('0', '1', '1', '폴마스터 등록 테스트', '', '2013-04-05', '2013-05-05', NULL,  '9999999')

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-05		최영준			최초생성
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[XP_POL_MASTER_INSERT]
	@TARGET			CHAR(1),
	@POL_TYPE		CHAR(1),
	@POL_STATE		CHAR(1),
	@SUBJECT		VARCHAR(400),
	@POL_DESC		TEXT,
	@START_DATE		DATETIME,
	@END_DATE		DATETIME,
	@OPEN_DATE		DATETIME,
	@NEW_CODE		CHAR(7),
	@EDT_CODE		CHAR(7)
AS
BEGIN
	
	INSERT INTO POL_MASTER
		([TARGET], POL_TYPE, POL_STATE, [SUBJECT], POL_DESC, [START_DATE], END_DATE, OPEN_DATE, NEW_CODE, EDT_CODE)
	VALUES
		(@TARGET, @POL_TYPE, @POL_STATE, @SUBJECT, @POL_DESC, @START_DATE, @END_DATE, @OPEN_DATE, @NEW_CODE, @EDT_CODE);

	SELECT @@IDENTITY;

END

GO
