USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_CONSULT_SELECT_SEQ
■ DESCRIPTION				: CTI 상담정보 조회(CONSULT_SEQ)
■ INPUT PARAMETER			: 
	@CONSULT_SEQ VARCHAR(14): 상담이력 SEQ
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC CTI.SP_CTI_CONSULT_SELECT_SEQ '20150102000112'

	EMP_CODE EMP_NAME             POS_TYPE    EXT_NUM TEAM_CODE TEAM_NAME                                            CUS_NO      CUS_NAME             CUS_TEL              CUS_GRADE   AGE
-------- -------------------- ----------- ------- --------- ---------------------------------------------------- ----------- -------------------- -------------------- ----------- -----------
2014058  박애                   1           4115    612       홍콩팀                                                  7030102     강덕현                  07081729423          0           0



■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-02		곽병삼			최초생성
   2020-12-09		김성호			고객 등급 위치 변경 (CUS_VIP_HISTRORY)
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_CONSULT_SELECT_SEQ]
--DECLARE
	@CONSULT_SEQ	VARCHAR(14)

--SET @@CONSULT_SEQ = '20141102000112'
AS

SET NOCOUNT ON

	SELECT
		CTI.EMP_CODE,
		EMP.KOR_NAME AS EMP_NAME,
		EMP.POS_TYPE,
		EMP.INNER_NUMBER3 AS EXT_NUM,
		CTI.TEAM_CODE,
		(SELECT TEAM_NAME FROM Diablo.dbo.EMP_TEAM WHERE TEAM_CODE = CTI.TEAM_CODE) + '팀' AS TEAM_NAME,
		CTI.CUS_NO,
		CUS.CUS_NAME,
		CTI.CUS_TEL,
		--CUS.NOR_TEL1+CUS.NOR_TEL2+CUS.NOR_TEL3 AS NOR_TEL,
		--CUS.HOM_TEL1+CUS.HOM_TEL2+CUS.HOM_TEL3 AS HOM_TEL,
		--CUS.COM_TEL1+CUS.COM_TEL2+CUS.COM_TEL3 AS COM_TEL, 
		CVH.CUS_GRADE,
		ISNULL(DATEDIFF(YEAR,CAST(CUS.BIRTH_DATE AS DATETIME),GETDATE()),0) AS AGE
	FROM sirens.cti.CTI_CONSULT CTI WITH(NOLOCK)
	LEFT JOIN Diablo.dbo.EMP_MASTER_damo EMP WITH(NOLOCK) ON CTI.EMP_CODE = EMP.EMP_CODE
	LEFT JOIN Diablo.dbo.CUS_CUSTOMER_DAMO CUS WITH(NOLOCK) ON CTI.CUS_NO = CUS.CUS_NO
	LEFT JOIN Diablo.dbo.CUS_VIP_HISTORY CVH WITH(NOLOCK) ON CTI.CUS_NO = CVH.CUS_NO AND CVH.VIP_YEAR = YEAR(GETDATE())
	WHERE CTI.CONSULT_SEQ = @CONSULT_SEQ

SET NOCOUNT OFF


GO
