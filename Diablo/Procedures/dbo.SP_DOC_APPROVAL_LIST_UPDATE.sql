USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_DOC_APPROVAL_LIST_UPDATE
■ DESCRIPTION				: 전자결재 일괄 결재 처리
■ INPUT PARAMETER			: 
	@EDI_CODE_LIST			: 전자결재 문서코드 (ex 1501076726,1412052437,1411052196)
	@EMP_CODE				: 결재자 사원코드
	@APP_CODE				: 상위 결재자 사원코드

■ EXEC						: 

	exec dbo.SP_DOC_APPROVAL_LIST_UPDATE '', '', ''

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2015-03-23		김성호			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_DOC_APPROVAL_LIST_UPDATE]
	@EDI_CODE_LIST	VARCHAR(4000),
	@EMP_CODE		VARCHAR(7),
	@APP_CODE		VARCHAR(7)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRAN;

	BEGIN TRY;

		-- 미결재 문서 검증
		SELECT @EDI_CODE_LIST = (
			SELECT (A.EDI_CODE + ',') AS [text()] 
			FROM EDI_APPROVAL A 
			WHERE A.EDI_CODE IN (SELECT Data FROM FN_SPLIT(@EDI_CODE_LIST, ',')) AND A.APP_CODE = @EMP_CODE AND A.APP_STATUS = 'N' FOR XML PATH('')
		)

		-- 1. 결재자 정보 업데이트
		UPDATE A SET A.READ_YN = 'Y', A.APP_STATUS = 'Y', A.APP_DATE = GETDATE()
		FROM EDI_APPROVAL A
		WHERE A.EDI_CODE IN (SELECT Data FROM FN_SPLIT(@EDI_CODE_LIST, ',')) AND A.APP_CODE = @EMP_CODE

		-- 2. 결재자 등록 또는 전결 처리
		-- 상급자 존재
		IF @APP_CODE <> ''
		BEGIN
			INSERT INTO EDI_APPROVAL (
				EDI_CODE,		SEQ_NO,			APP_STATUS,		APP_TYPE,
				APP_CODE,		[APP_NAME],		TEAM_NAME,		DUTY_NAME,		POS_NAME,
				NEW_CODE,		NEW_TEAM_NAME,	NEW_DUTY_NAME,	NEW_POS_NAME
			)
			SELECT
				A.EDI_CODE,		(A.SEQ_NO + 1),	'N',			'1',
				B.EMP_CODE,		B.KOR_NAME,		B.TEAM_NAME,	B.DUTY_NAME,	B.POS_NAME,
				A.APP_CODE,		A.TEAM_NAME,	A.DUTY_NAME,	A.POS_NAME
			FROM EDI_APPROVAL A
			CROSS JOIN (
				-- 상급자는 동일
				SELECT A.EMP_CODE, A.KOR_NAME, B.TEAM_NAME,
					(SELECT PUB_VALUE FROM COD_PUBLIC WITH(NOLOCK) WHERE PUB_TYPE='EMP.DUTYTYPE' AND PUB_CODE = A.DUTY_TYPE) AS [DUTY_NAME],
					(SELECT PUB_VALUE FROM COD_PUBLIC WITH(NOLOCK) WHERE PUB_TYPE='EMP.POSTYPE' AND PUB_CODE = A.POS_TYPE) AS [POS_NAME]
				FROM EMP_MASTER_damo A
				INNER JOIN EMP_TEAM B ON A.TEAM_CODE = B.TEAM_CODE
				WHERE A.EMP_CODE = @APP_CODE
			) B
			WHERE A.EDI_CODE IN (SELECT Data FROM FN_SPLIT(@EDI_CODE_LIST, ',')) AND A.APP_CODE = @EMP_CODE
		END
		ELSE
		BEGIN
			UPDATE A SET A.APP_TYPE = (
					CASE
						WHEN A.DOC_TYPE IN (4,8) THEN '2'		-- 일반지결, 행사지결
						WHEN A.DOC_TYPE IN (1,2,7) THEN '3'		-- 휴가, 출장, 경영지원실경유기안
						WHEN A.DOC_TYPE = 9 THEN '4'			-- 출장보고서
						ELSE A.APP_TYPE
					END
				), A.EDI_STATUS = (
					CASE
						WHEN A.DOC_TYPE IN (3,5,6) THEN '3'		-- 기안, 업무협조문, 발권요청서
						ELSE A.EDI_STATUS
					END
				)
			FROM EDI_MASTER_damo A
			WHERE A.EDI_CODE IN (SELECT Data FROM FN_SPLIT(@EDI_CODE_LIST, ',')) AND A.APP_TYPE = '1'

			-- 전결처리된 문서 결재라인의 읽기 여부를 다시 N으로 수정해 준다
			UPDATE A SET A.READ_YN = 'N'
			FROM EDI_APPROVAL A
			INNER JOIN EDI_MASTER_damo B ON A.EDI_CODE = B.EDI_CODE
			WHERE A.EDI_CODE IN (SELECT Data FROM FN_SPLIT(@EDI_CODE_LIST, ',')) AND B.DOC_TYPE IN (3,5,6)
		END

		IF @@TRANCOUNT > 0
			COMMIT TRAN;

	END TRY
	BEGIN CATCH 

		IF @@TRANCOUNT > 0
			ROLLBACK TRAN;

	END CATCH
END
GO
