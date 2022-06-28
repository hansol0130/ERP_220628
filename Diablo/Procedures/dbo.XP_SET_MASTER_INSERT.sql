USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_SET_MASTER_INSERT
■ DESCRIPTION				: 정산등록
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec XP_SET_MASTER_INSERT ('XXX111-150930', '2008011')
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2015-10-14		김성호			최초생성
   2018-01-15		김성호			재무팀 권한에 재무회계/자산관리담당 추가
   2020-10-23       오준혁			키중복 오류 체크
   2021-05-11		김성호			더존코드 미생성 상품 더존코드 생성
================================================================================================================*/ 
CREATE  PROC [dbo].[XP_SET_MASTER_INSERT]
	@PRO_CODE	VARCHAR(20),
	@NEW_CODE	VARCHAR(7)
AS  
BEGIN

	DECLARE @DAY INT, @DEP_DATE DATETIME, @IS_OK CHAR(1), @MESSAGE VARCHAR(100) = (@PRO_CODE + ' 행사가 존재하지 않습니다.')

	-- 세팅
	SELECT @DAY = DAY(GETDATE()), @DEP_DATE = A.DEP_DATE, @IS_OK = 'N', @MESSAGE = '생성가능일 보다 이전 행사입니다.'
	FROM PKG_DETAIL A WITH(NOLOCK)
	WHERE A.PRO_CODE = @PRO_CODE

	-- 1~5일은 한달전 출발행사까지 생성 가능
	IF @DAY >= 1 AND @DAY <= 5 AND DATEDIFF(DAY, DATEFROMPARTS(YEAR(DATEADD(MONTH, -1, GETDATE())), MONTH(DATEADD(MONTH, -1, GETDATE())), 1), @DEP_DATE) >= 0
	BEGIN
		SELECT @IS_OK = 'Y', @MESSAGE = '정산 마스터가 생성 되었습니다.'
	END -- 6일이후는 그달 5일 출발행사부터 생성 가능
	ELSE IF @DAY > 5 AND @DAY <= 31 AND DATEDIFF(DAY, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1), @DEP_DATE) >= 0
	BEGIN
		SELECT @IS_OK = 'Y', @MESSAGE = '정산 마스터가 생성 되었습니다.'
	END -- 재무팀은 무조건 생성 가능
	ELSE IF EXISTS(SELECT 1 FROM EMP_MASTER A WITH(NOLOCK) WHERE A.EMP_CODE = @NEW_CODE AND A.TEAM_CODE IN (419, 521))
	BEGIN
		SELECT @IS_OK = 'Y', @MESSAGE = '정산 마스터가 생성 되었습니다.(재무팀)'
	END


	-- @PRO_CODE 키 중복 체크
	IF EXISTS (
	       SELECT 1
	       FROM   SET_MASTER
	       WHERE  PRO_CODE = @PRO_CODE
	   )
	BEGIN
	    SELECT @IS_OK = 'N'
	          ,@MESSAGE = '행사코드 중복 오류 (정산 마스터에 ' + @PRO_CODE + ' 가 있습니다.)'
	END

	IF @IS_OK = 'Y'
	BEGIN
		INSERT INTO SET_MASTER (PRO_CODE, MASTER_CODE, PRO_TYPE, DEP_DATE, ARR_DATE, NEW_CODE, PROFIT_TEAM_CODE, PROFIT_TEAM_NAME)
		SELECT A.PRO_CODE, A.MASTER_CODE, A.PRO_TYPE, A.DEP_DATE, A.ARR_DATE, @NEW_CODE, C.TEAM_CODE, C.TEAM_NAME
		FROM PKG_DETAIL A WITH(NOLOCK)
		INNER JOIN EMP_MASTER B WITH(NOLOCK) ON A.NEW_CODE = B.EMP_CODE
		INNER JOIN EMP_TEAM C WITH(NOLOCK) ON B.TEAM_CODE = C.TEAM_CODE
		WHERE A.PRO_CODE = @PRO_CODE
	END
	
	-------------------------------------
	-- 더존코드 미생성시 생성
	-------------------------------------
	IF NOT EXISTS(SELECT 1 FROM ACC_MATCHING WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE)
		AND EXISTS(SELECT 1 FROM RES_MASTER_damo WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE)
	BEGIN
		DECLARE @RES_CODE VARCHAR(20);
		SELECT TOP 1 @RES_CODE = RES_CODE FROM RES_MASTER_damo WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE
		
		exec dbo.SP_ACC_GET_DUZ_CODE @RES_CODE
		
		SET @MESSAGE = @MESSAGE + ' [더존코드생성]' 
	END


	SELECT @MESSAGE
END 
GO
