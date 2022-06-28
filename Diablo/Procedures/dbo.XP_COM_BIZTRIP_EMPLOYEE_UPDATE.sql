USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BIZTRIP_EMPLOYEE_UPDATE
■ DESCRIPTION				: BTMS 출장자 그룹 적용 직원 등록
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처코드
	@BT_SEQ					: 출장그룹 순번
	@ALL_YN					: 전체선택 유무
	@NEW_SEQ				: 등록자 코드
	@EMP_INFO				: 등록 값
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-30		김성호			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BIZTRIP_EMPLOYEE_UPDATE]
	@AGT_CODE		VARCHAR(10),
	@BT_SEQ			INT,
	@ALL_YN			CHAR(1),
	@NEW_SEQ		INT,

	@EMP_INFO		XML
AS 
BEGIN

	UPDATE COM_BIZTRIP_GROUP SET ALL_YN = @ALL_YN, EDT_DATE = GETDATE(), EDT_SEQ = @NEW_SEQ WHERE AGT_CODE = @AGT_CODE AND BT_SEQ = @BT_SEQ;

	DELETE FROM COM_BIZTRIP_EMPLOYEE WHERE AGT_CODE = @AGT_CODE AND BT_SEQ = @BT_SEQ;

	WITH LIST AS
	(
		SELECT
			ROW_NUMBER() OVER (ORDER BY t1.col.value('./AgentCode[1]', 'varchar(10)')) AS [RowNumber]
			, t1.col.value('./AgentCode[1]', 'varchar(10)') as [AgentCode]
			, t1.col.value('./BizTripSeq[1]', 'int') as [BizTripSeq]
			, t1.col.value('./BizTripEmpSeq[1]', 'int') as [BizTripEmpSeq]
			, t1.col.value('./BizTripEmpType[1]', 'char(1)') as [BizTripEmpType]
			, t1.col.value('./BizTripEmployeeSeq[1]', 'int') as [BizTripEmployeeSeq]
		FROM @EMP_INFO.nodes('/ArrayOfBizTripEmployeeRQ/BizTripEmployeeRQ') as t1(col)
	)
	INSERT INTO COM_BIZTRIP_EMPLOYEE (AGT_CODE, BT_SEQ, BTE_SEQ, BT_EMP_TYPE, BT_EMP_SEQ, NEW_DATE, NEW_SEQ)
	SELECT @AGT_CODE, @BT_SEQ, A.RowNumber, A.BizTripEmpType, A.BizTripEmployeeSeq, GETDATE(), @NEW_SEQ
	FROM LIST A

END

GO
