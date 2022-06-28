USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ARG_DETAIL_STATUS_UPDATE_FOR_EDI_CODE
■ DESCRIPTION				: 수배 상태 업데이트 - 전자결제 
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

*ARG_STATUS : 
1수배요청,		2수배확정,		3수배취소,		4수배확정취소, 
5인보이스발행,	6인보이스확정,	7인보이스취소,	8인보이스확정취소, 
9정산결재,		10정산지급

	EXEC DBO.XP_ARG_DETAIL_STATUS_UPDATE_FOR_EDI_CODE 
		@EDI_CODE_LIST = '1804033779,1804044537', 
		@ARG_DETAIL_STATUS = 8 , @ARG_CUSTOMER_STATUS = 5  , 
		@EDT_CODE = '9999999'

	DECLARE @EDI_CODE_LIST	VARCHAR(8000)
	SET @EDI_CODE_LIST = '11011,12312'
	SELECT DATA FROM DBO.FN_SPLIT(@EDI_CODE_LIST,',') 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   
   2018-04-09		박형만			전자 결제 상태 업데이트시 , 수배상태도 수정 

================================================================================================================*/ 
CREATE PROC [dbo].[XP_ARG_DETAIL_STATUS_UPDATE_FOR_EDI_CODE]
	@EDI_CODE_LIST	VARCHAR(8000),
	@ARG_DETAIL_STATUS	INT,
	@ARG_CUSTOMER_STATUS INT,
	@EDT_CODE EMP_CODE 
AS 
BEGIN
	-- 수배 상태 업데이트 
	UPDATE B SET B.ARG_STATUS = @ARG_DETAIL_STATUS, B.EDT_CODE = @EDT_CODE, B.EDT_DATE = GETDATE()
	FROM ARG_MASTER A
	INNER JOIN ARG_DETAIL B ON A.ARG_CODE = B.ARG_CODE
	INNER JOIN ARG_INVOICE C ON B.ARG_CODE = C.ARG_CODE AND B.GRP_SEQ_NO = C.GRP_SEQ_NO
	INNER JOIN SET_LAND_AGENT D ON A.PRO_CODE = D.PRO_CODE AND C.LAND_SEQ_NO = D.LAND_SEQ_NO
	WHERE D.EDI_CODE IN (SELECT DATA FROM DBO.FN_SPLIT(@EDI_CODE_LIST,','))

	-- 수배 출발자 상태 업데이트 
	UPDATE D SET D.ARG_STATUS = @ARG_CUSTOMER_STATUS, D.EDT_CODE = @EDT_CODE, D.EDT_DATE = GETDATE()
	FROM ARG_MASTER A
	INNER JOIN ARG_INVOICE B ON A.ARG_CODE = B.ARG_CODE
	INNER JOIN ARG_CONNECT C ON B.ARG_CODE = C.ARG_CODE AND B.GRP_SEQ_NO = C.GRP_SEQ_NO
	INNER JOIN ARG_CUSTOMER D ON C.ARG_CODE = D.ARG_CODE AND C.CUS_SEQ_NO = D.CUS_SEQ_NO
	INNER JOIN SET_LAND_AGENT E ON A.PRO_CODE = E.PRO_CODE AND B.LAND_SEQ_NO = E.LAND_SEQ_NO
	WHERE E.EDI_CODE IN (SELECT DATA FROM DBO.FN_SPLIT(@EDI_CODE_LIST,','))

	-- 인보이스 확정 취소일 때 지상비 삭제 ArrangementInvoiceView.aspx 
	-- 확정인보이스 취소 ( 정산 결제 전까지 ) 
	-- ARG_DETAIL.ARG_STATUS	ARG_CUSTOMER.ARG_STATUS 
	IF @ARG_DETAIL_STATUS = 8 AND @ARG_CUSTOMER_STATUS = 5  -- //인보이스 취소시 출발자는 발행 상태로
	BEGIN
		--DELETE FROM A
		--FROM SET_LAND_AGENT A
		--INNER JOIN (
		--	SELECT A.PRO_CODE, B.LAND_SEQ_NO
		--	FROM ARG_MASTER A
		--	INNER JOIN ARG_INVOICE B ON A.ARG_CODE = B.ARG_CODE
		--	WHERE A.ARG_CODE = @ARG_CODE AND B.GRP_SEQ_NO = @GRP_SEQ_NO
		--) B ON A.PRO_CODE = B.PRO_CODE AND A.LAND_SEQ_NO = B.LAND_SEQ_NO
		--WHERE A.DOC_YN = 'N'

		--UPDATE ARG_INVOICE SET LAND_SEQ_NO = 0 WHERE ARG_CODE = @ARG_CODE AND GRP_SEQ_NO = @GRP_SEQ_NO

		-- 지상비 삭제 
		DELETE A 
		FROM SET_LAND_AGENT A 
		INNER JOIN ARG_MASTER B 
			ON A.PRO_CODE = B.PRO_CODE 
		INNER JOIN ARG_INVOICE C 
			ON B.ARG_CODE = C.ARG_CODE 
			AND A.LAND_SEQ_NO = C.LAND_SEQ_NO  
		WHERE A.EDI_CODE IN (SELECT DATA FROM DBO.FN_SPLIT(@EDI_CODE_LIST,','))
		AND A.DOC_YN = 'N'  -- 지결작성 안한것만 . 정산결제(전자결제작성이후) 에는 삭제되지 않음 

		-- 인보이스 - 지상비 연결 0 으로 
		UPDATE B SET B.LAND_SEQ_NO = 0
		FROM ARG_MASTER A
		INNER JOIN ARG_INVOICE B ON A.ARG_CODE = B.ARG_CODE
		INNER JOIN SET_LAND_AGENT E ON A.PRO_CODE = E.PRO_CODE AND B.LAND_SEQ_NO = E.LAND_SEQ_NO
		WHERE E.EDI_CODE IN (SELECT DATA FROM DBO.FN_SPLIT(@EDI_CODE_LIST,','))

	END
END 
GO
