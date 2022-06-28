USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BREAKREASON_LIST_UPDATE
■ DESCRIPTION				: BTMS 거래처 취소 사유 리스트 사용유무 일괄 업데이트
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처코드
	@REASON_INFO				: 사유 XML 데이터
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-02-01		김성호			최초생성
   2016-02-22		김성호			수정자 정보 등록
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BREAKREASON_LIST_UPDATE]
	@AGT_CODE		VARCHAR(10),
	@REASON_INFO		XML
AS 
BEGIN

	WITH LIST AS
	(
		SELECT
			ROW_NUMBER() OVER (ORDER BY t1.col.value('./AgentCode[1]', 'varchar(10)')) AS [RowNumber]
			, t1.col.value('./AgentCode[1]', 'varchar(10)') AS [AgentCode]
			, t1.col.value('./ReasonSeq[1]', 'int') as [ReasonSeq]
			--, t1.col.value('./ProductType[1]', 'char(1)') as [ProductType]
			--, t1.col.value('./ReasonRemark[1]', 'varchar(50)') as [ReasonRemark]
			, t1.col.value('./UseYn[1]', 'char(1)') as [UseYn]
			, t1.col.value('./NewSeq[1]', 'int') as [NewSeq]
		FROM @REASON_INFO.nodes('/ArrayOfCompanyBreakReasonRQ/CompanyBreakReasonRQ') as t1(col)
	)
	UPDATE A SET A.USE_YN = B.UseYn, A.EDT_DATE = GETDATE(), A.EDT_SEQ = B.NewSeq
	FROM COM_BREAK_REASON A
	INNER JOIN LIST B ON A.AGT_CODE = B.AgentCode AND A.REASON_SEQ = B.ReasonSeq

END

GO
