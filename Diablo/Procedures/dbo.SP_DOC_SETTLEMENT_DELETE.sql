USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_DOC_SETTLEMENT_DELETE
■ DESCRIPTION				: 지결 재검토 (복수로 할때)
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2014-12-17		정지용			지결 취소시 결제진행중인 인보이시는 수배확정상태로 돌림 ( SET_LAND_AGENT의 EDI_CODE 가 지워지기전에 실행 )
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_DOC_SETTLEMENT_DELETE]
	@EDI_CODE		VARCHAR(1000),
	@EMP_CODE		VARCHAR(7)
AS
BEGIN
	SET NOCOUNT ON;
	-- 변수 선언

	DECLARE @SQLSTRING NVARCHAR(4000), @EDI_CODE2 VARCHAR(1000), @EMP_NAME VARCHAR(20)
	SELECT @EMP_NAME = ISNULL(DBO.FN_CUS_GET_EMP_NAME(@EMP_CODE), '')
	SELECT @EDI_CODE2 = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@EDI_CODE, ',') FOR XML PATH('')), 1, 1, '')

	SET @SQLSTRING = N'IF EXISTS(SELECT 1 FROM EDI_MASTER_DAMO WHERE EDI_CODE IN (' + @EDI_CODE2 + ') AND RCV_YN = ''Y'')
	BEGIN
		--삭제 불가
		SELECT 1
	END
	ELSE
	BEGIN
		-- 수배확정상태로 돌림
		UPDATE B SET B.ARG_STATUS = 6, B.EDT_CODE = ''' + @EMP_CODE + ''', B.EDT_DATE = GETDATE()
		FROM ARG_MASTER A
		INNER JOIN ARG_DETAIL B ON A.ARG_CODE = B.ARG_CODE
		INNER JOIN ARG_INVOICE C ON B.ARG_CODE = C.ARG_CODE AND B.GRP_SEQ_NO = C.GRP_SEQ_NO
		INNER JOIN SET_LAND_AGENT D ON A.PRO_CODE = D.PRO_CODE AND C.LAND_SEQ_NO = D.LAND_SEQ_NO
		WHERE D.EDI_CODE IN (''' + @EDI_CODE + ''')
		UPDATE D SET D.ARG_STATUS = 6, D.EDT_CODE = ''' + @EMP_CODE + ''', D.EDT_DATE = GETDATE()
		FROM ARG_MASTER A
		INNER JOIN ARG_INVOICE B ON A.ARG_CODE = B.ARG_CODE
		INNER JOIN ARG_CONNECT C ON B.ARG_CODE = C.ARG_CODE AND B.GRP_SEQ_NO = C.GRP_SEQ_NO
		INNER JOIN ARG_CUSTOMER D ON C.ARG_CODE = D.ARG_CODE AND C.CUS_SEQ_NO = D.CUS_SEQ_NO
		INNER JOIN SET_LAND_AGENT E ON A.PRO_CODE = E.PRO_CODE AND B.LAND_SEQ_NO = E.LAND_SEQ_NO
		WHERE E.EDI_CODE IN (''' + @EDI_CODE + ''')

		--문서 연결 삭제
		UPDATE A SET EDI_CODE = NULL, DOC_YN = ''N''
		FROM SET_LAND_AGENT A
		INNER JOIN (
			SELECT EDI_CODE, PRO_CODE FROM EDI_MASTER_DAMO WHERE EDI_CODE IN (' + @EDI_CODE2 + ')
		) B ON A.PRO_CODE = B.PRO_CODE AND A.EDI_CODE = B.EDI_CODE

		UPDATE A SET EDI_CODE = NULL, DOC_YN = ''N''
		FROM SET_AIR_AGENT A
		INNER JOIN (
			SELECT EDI_CODE, PRO_CODE FROM EDI_MASTER_DAMO WHERE EDI_CODE IN (' + @EDI_CODE2 + ')
		) B ON A.PRO_CODE = B.PRO_CODE AND A.EDI_CODE = B.EDI_CODE
		
		UPDATE A SET EDI_CODE = NULL, DOC_YN = ''N''
		FROM SET_GROUP A
		INNER JOIN (
			SELECT EDI_CODE, PRO_CODE FROM EDI_MASTER_DAMO WHERE EDI_CODE IN (' + @EDI_CODE2 + ')
		) B ON A.PRO_CODE = B.PRO_CODE AND A.EDI_CODE = B.EDI_CODE
	
		--삭제 가능
		
		UPDATE EDI_APPROVAL SET APP_STATUS = ''Y'' WHERE EDI_CODE IN (' + @EDI_CODE2 + ') AND APP_STATUS = ''N''
		UPDATE EDI_MASTER_DAMO SET EDI_STATUS = 2 WHERE EDI_CODE IN (' + @EDI_CODE2 + ')
		INSERT INTO EDI_COMMENT
		SELECT DATA, (ISNULL((SELECT MAX(SEQ_NO) FROM EDI_COMMENT WHERE EDI_CODE = DATA), 0) + 1) AS [SEQ_NO]
			, ''[SYSTEM] 정산삭제'', ''1'', ''' + @EMP_CODE + ''', GETDATE()
			, ''' + @EMP_NAME + '''
		FROM DBO.FN_SPLIT(''' + @EDI_CODE + ''', '','')
		
		SELECT 2
	END'
	
	EXEC SP_EXECUTESQL @SQLSTRING;
	--PRINT @SQLSTRING

END
GO
