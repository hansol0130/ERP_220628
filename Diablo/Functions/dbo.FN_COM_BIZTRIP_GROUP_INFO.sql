USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_COM_BIZTRIP_GROUP_INFO
■ Description				: 코드로 검색된 직원의 최우선 룰 코드 반환
■ Input Parameter			: 

	@AGT_CODE VARCHAR(10)	: 거래처코드
	@CODES VARCHAR(100)		: 예약코드 OR 거래처직원코드

■ Output Parameter			: 
■ Output Value				: 
■ Exec						: 

	SELECT * FROM DBO.FN_COM_BIZTRIP_GROUP_INFO('92756', '109,118,122,123')

---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2016-03-14		김성호			최초생성
	2016-03-18		정지용			규정전직원사용일때 나와야되서 수정
	2016-04-01		김성호			전직원적용 오류 수정
	2016-04-08		김성호			출장그룹 사용가능 여부 체크
-------------------------------------------------------------------------------------------------*/ 
create FUNCTION [dbo].[FN_COM_BIZTRIP_GROUP_INFO]
(	
	@AGT_CODE	VARCHAR(10),
	@CODES		VARCHAR(100)
)
RETURNS TABLE
AS
RETURN
(
	WITH EMP_LIST AS
	(
		SELECT B.AGT_CODE, B.EMP_SEQ, C.TEAM_SEQ, C.POS_SEQ
		FROM RES_CUSTOMER_damo A WITH(NOLOCK)
		INNER JOIN COM_EMPLOYEE_MATCHING B WITH(NOLOCK) ON B.AGT_CODE = @AGT_CODE AND A.CUS_NO = B.CUS_NO
		INNER JOIN COM_EMPLOYEE C WITH(NOLOCK) ON B.AGT_CODE = C.AGT_CODE AND B.EMP_SEQ = C.EMP_SEQ
		WHERE A.RES_CODE IN (SELECT DATA FROM DBO.FN_SPLIT(@CODES, ','))
		UNION
		SELECT A.AGT_CODE, A.EMP_SEQ, A.TEAM_SEQ, A.POS_SEQ
		FROM COM_EMPLOYEE A WITH(NOLOCK)
		WHERE A.AGT_CODE = @AGT_CODE AND A.EMP_SEQ IN (SELECT (CASE WHEN ISNUMERIC(DATA) = 1 THEN DATA ELSE NULL END) FROM DBO.FN_SPLIT(@CODES, ','))
	)
	, RULE_LIST AS
	(
		SELECT ROW_NUMBER() OVER (PARTITION BY A.EMP_SEQ ORDER BY ISNULL(B.ORDER_NUM, 99999)) AS [ROWNUMBER], A.AGT_CODE, A.EMP_SEQ, B.BT_SEQ, B.ORDER_NUM
		FROM EMP_LIST A
		LEFT JOIN (
			SELECT A.AGT_CODE, A.BT_SEQ, A.ORDER_NUM, A.ALL_YN, B.BT_EMP_TYPE, B.BT_EMP_SEQ
			FROM COM_BIZTRIP_GROUP A WITH(NOLOCK)
			LEFT JOIN COM_BIZTRIP_EMPLOYEE B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE AND A.BT_SEQ = B.BT_SEQ
			WHERE A.AGT_CODE = @AGT_CODE AND A.USE_YN = 'Y'
		) B ON A.AGT_CODE = B.AGT_CODE AND ( (B.ALL_YN = 'Y') OR (B.BT_EMP_SEQ = ( CASE B.BT_EMP_TYPE WHEN 'E' THEN A.EMP_SEQ WHEN 'P' THEN A.POS_SEQ WHEN 'T' THEN A.TEAM_SEQ END )) )	
	)
	SELECT A.AGT_CODE, A.EMP_SEQ, A.BT_SEQ, A.ORDER_NUM
	FROM RULE_LIST A
	WHERE A.ROWNUMBER = 1

	--WITH EMP_LIST AS
	--(
	--	SELECT B.AGT_CODE, B.EMP_SEQ, C.TEAM_SEQ, C.POS_SEQ
	--	FROM RES_CUSTOMER_damo A WITH(NOLOCK)
	--	INNER JOIN COM_EMPLOYEE_MATCHING B WITH(NOLOCK) ON B.AGT_CODE = @AGT_CODE AND A.CUS_NO = B.CUS_NO
	--	INNER JOIN COM_EMPLOYEE C WITH(NOLOCK) ON B.AGT_CODE = C.AGT_CODE AND B.EMP_SEQ = C.EMP_SEQ
	--	WHERE A.RES_CODE IN (SELECT DATA FROM DBO.FN_SPLIT(@CODES, ','))
	--	UNION
	--	SELECT A.AGT_CODE, A.EMP_SEQ, A.TEAM_SEQ, A.POS_SEQ
	--	FROM COM_EMPLOYEE A WITH(NOLOCK)
	--	WHERE A.AGT_CODE = @AGT_CODE AND A.EMP_SEQ IN (SELECT (CASE WHEN ISNUMERIC(DATA) = 1 THEN DATA ELSE NULL END) FROM DBO.FN_SPLIT(@CODES, ','))
	--)
	--, RULE_LIST AS
	--(
	--	SELECT ROW_NUMBER() OVER (PARTITION BY A.EMP_SEQ ORDER BY ISNULL(C.ORDER_NUM, 99999)) AS [ROWNUMBER], A.AGT_CODE, A.EMP_SEQ, C.BT_SEQ, C.ORDER_NUM
	--	FROM EMP_LIST A
	--	LEFT JOIN COM_BIZTRIP_EMPLOYEE B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE AND B.BT_EMP_SEQ = (CASE B.BT_EMP_TYPE WHEN 'E' THEN A.EMP_SEQ WHEN 'P' THEN A.POS_SEQ WHEN 'T' THEN A.TEAM_SEQ END)
	--	LEFT JOIN COM_BIZTRIP_GROUP C WITH(NOLOCK) ON B.AGT_CODE = C.AGT_CODE AND B.BT_SEQ = C.BT_SEQ AND C.USE_YN = 'Y'
	--)
	--SELECT A.AGT_CODE, A.EMP_SEQ, A.BT_SEQ, A.ORDER_NUM
	--FROM RULE_LIST A
	--WHERE A.ROWNUMBER = 1

	--SELECT * FROM (
	--	SELECT 
	--		ROW_NUMBER() OVER (PARTITION BY A.BT_EMP_SEQ ORDER BY MIN(B.ORDER_NUM) ASC) AS [ROW_NUMBER], 
	--		A.AGT_CODE, A.BT_SEQ, A.BTE_SEQ, A.BT_EMP_SEQ,
	--		B.ALL_YN, B.REPORT_YN, B.EMAIL_SEND_YN, B.CONFIRM_YN, B.HOTEL_LIKE_YN, B.AIR_SAME_YN, B.AIR_LIKE_YN,
	--		B.BTG_NAME, B.ORDER_NUM
	--	FROM COM_BIZTRIP_EMPLOYEE A WITH(NOLOCK)
	--	INNER JOIN COM_BIZTRIP_GROUP B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE AND A.BT_SEQ = B.BT_SEQ AND B.USE_YN = 'Y'
	--	WHERE 
	--		A.AGT_CODE = @AGT_CODE AND A.BT_EMP_TYPE = 'E'
	--		AND A.BT_EMP_SEQ IN (SELECT B.EMP_SEQ FROM RES_CUSTOMER A LEFT JOIN COM_EMPLOYEE_MATCHING B ON A.CUS_NO = B.CUS_NO WHERE A.RES_CODE IN (SELECT RES_CODE FROM COM_BIZTRIP_DETAIL WHERE BT_CODE = @BT_CODE))
	--	GROUP BY A.AGT_CODE, A.BT_SEQ, A.BTE_SEQ, A.BT_EMP_SEQ, ORDER_NUM, B.ALL_YN, B.REPORT_YN, B.EMAIL_SEND_YN, B.CONFIRM_YN, B.HOTEL_LIKE_YN, B.AIR_SAME_YN, B.AIR_LIKE_YN, B.BTG_NAME
	--) A WHERE A.ROW_NUMBER = 1
)

GO
