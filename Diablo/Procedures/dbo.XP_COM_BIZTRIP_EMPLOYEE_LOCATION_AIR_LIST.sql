USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_BIZTRIP_EMPLOYEE_LOCATION_AIR_LIST
■ DESCRIPTION				: BTMS 출장자 위치 현황 항공 리스트
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	XP_COM_BIZTRIP_EMPLOYEE_LOCATION_AIR_LIST 1, 10, 100, 'AgentCode=93971&BtDate=2016-11-14&RegionCode=130&EmpName=&TeamSeq='
	XP_COM_BIZTRIP_EMPLOYEE_LOCATION_AIR_LIST 1, 10, 100, 'AgentCode=93971&BtDate=2016-11-14&RegionCode=330&EmpName=&TeamSeq='

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR					DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-03-09		저스트고(강윤성)		최초생성
   2016-11-14		저스트고(이유라)		ROUTING_TYPE 추가
================================================================================================================*/ 

CREATE PROC [dbo].[XP_COM_BIZTRIP_EMPLOYEE_LOCATION_AIR_LIST]
@PAGE_INDEX INT,
@PAGE_SIZE INT,
@TOTAL_COUNT INT OUTPUT,
@KEY VARCHAR(400)

AS

BEGIN
	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000);
	DECLARE @WHERE NVARCHAR(4000);
	DECLARE @AGT_CODE VARCHAR(10), @TEAM_SEQ INT, @BT_DATE DATETIME, @EMP_NAME VARCHAR(20), @REGION_CODE VARCHAR(10)

	SELECT
		@AGT_CODE = DBO.FN_PARAM(@KEY, 'AgentCode'),
		@TEAM_SEQ = DBO.FN_PARAM(@KEY, 'TeamSeq'),
		@BT_DATE = DBO.FN_PARAM(@KEY, 'BtDate'),
		@EMP_NAME = DBO.FN_PARAM(@KEY, 'EmpName'),
		@REGION_CODE = DBO.FN_PARAM(@KEY, 'RegionCode')

	 SELECT @WHERE = ' WHERE A.RES_CODE IN (SELECT RES_CODE FROM COM_BIZTRIP_DETAIL WHERE BT_CODE IN (SELECT BT_CODE FROM COM_BIZTRIP_MASTER WHERE AGT_CODE = @AGT_CODE)) '
	 SET @WHERE = @WHERE + ' AND B.AGT_CODE = @AGT_CODE AND F.PRO_TYPE = 2 AND B.APPROVAL_STATE = 2  AND F.RES_STATE <> 9 AND F.RES_STATE <> 7 '

	IF (@TEAM_SEQ > 0)
	 BEGIN
		SET @WHERE = @WHERE + ' AND H.TEAM_SEQ = @TEAM_SEQ '
	 END

	IF (@BT_DATE <> '')
	 BEGIN
		SET @WHERE = @WHERE + ' AND (SELECT START_DATE FROM RES_SEGMENT WHERE SEQ_NO = K.SEQ_NO AND RES_CODE = A.RES_CODE) < DATEADD(DAY, 1, CONVERT(DATETIME, @BT_DATE)) '
		SET @WHERE = @WHERE + ' AND (CASE WHEN (SELECT COUNT(*) FROM RES_SEGMENT WHERE RES_CODE = A.RES_CODE) > 2
									THEN ((DATEADD(DAY, 1, ISNULL((SELECT START_DATE FROM RES_SEGMENT WHERE SEQ_NO = (K.SEQ_NO + 1) AND RES_CODE = A.RES_CODE), CONVERT(DATETIME, @BT_DATE)))))
									ELSE
									(DATEADD(DAY, 1, ISNULL((SELECT END_DATE FROM RES_SEGMENT WHERE RES_CODE = A.RES_CODE AND SEQ_NO = (SELECT COUNT(*) FROM RES_SEGMENT WHERE RES_CODE = A.RES_CODE)), CONVERT(DATETIME, ''9999-12-30''))) - 1)
									END) > CONVERT(DATETIME, @BT_DATE) '
	 END

	IF (LEN(@EMP_NAME) > 0)
	 BEGIN
		SET @WHERE = @WHERE + ' AND A.CUS_NAME LIKE ''%'' + @EMP_NAME + ''%'''
	 END

	IF (@REGION_CODE <> '')
	 BEGIN
		SET @WHERE = @WHERE + ' AND J.REGION_CODE = @REGION_CODE '
	 END

	SET @SQLSTRING = N'
		SELECT DISTINCT @TOTAL_COUNT = COUNT(*)
		FROM RES_CUSTOMER A 
		INNER JOIN COM_BIZTRIP_MASTER B ON B.BT_CODE IN (SELECT BT_CODE FROM COM_BIZTRIP_DETAIL WHERE RES_CODE = A.RES_CODE)
		LEFT JOIN COM_EMPLOYEE_MATCHING D ON A.CUS_NO = D.CUS_NO AND D.AGT_CODE = B.AGT_CODE
		LEFT JOIN COM_EMPLOYEE E ON D.EMP_SEQ = E.EMP_SEQ AND E.AGT_CODE = B.AGT_CODE
		LEFT JOIN RES_MASTER_DAMO F ON A.RES_CODE = F.RES_CODE
		LEFT JOIN COM_POSITION G ON E.POS_SEQ = G.POS_SEQ AND G.AGT_CODE = B.AGT_CODE
		LEFT JOIN COM_TEAM H ON E.TEAM_SEQ = H.TEAM_SEQ AND H.AGT_CODE = B.AGT_CODE
		LEFT JOIN RES_SEGMENT K ON K.RES_CODE = A.RES_CODE
		LEFT JOIN PUB_CITY C ON C.CITY_CODE = K.ARR_CITY_CODE
		LEFT JOIN PUB_NATION I ON I.NATION_CODE = C.NATION_CODE
		LEFT JOIN PUB_REGION J ON J.REGION_CODE = I.REGION_CODE
		' + @WHERE + N';

		SELECT DISTINCT
			B.BT_CODE, E.EMP_SEQ, A.CUS_NO, A.CUS_NAME, G.POS_NAME, H.TEAM_NAME,
			F.DEP_DATE AS BT_START_DATE,
			F.ARR_DATE AS BT_END_DATE,
			A.NEW_DATE,
			DBO.FN_RES_AIR_GET_PRO_NAME(A.RES_CODE) AS JOURNEY,
			J.REGION_CODE,
			F.RES_CODE,
			E.MANAGER_YN,
			dbo.FN_RES_AIR_GET_RTG_TYPE(F.RES_CODE) AS ROUTING_TYPE
		FROM RES_CUSTOMER A
		INNER JOIN COM_BIZTRIP_MASTER B  ON B.BT_CODE IN (SELECT BT_CODE FROM COM_BIZTRIP_DETAIL WHERE RES_CODE = A.RES_CODE)
		LEFT JOIN COM_EMPLOYEE_MATCHING D  ON A.CUS_NO = D.CUS_NO AND D.AGT_CODE = B.AGT_CODE
		LEFT JOIN COM_EMPLOYEE E  ON D.EMP_SEQ = E.EMP_SEQ AND E.AGT_CODE = B.AGT_CODE
		LEFT JOIN RES_MASTER_DAMO F  ON A.RES_CODE = F.RES_CODE
		LEFT JOIN COM_POSITION G  ON E.POS_SEQ = G.POS_SEQ AND G.AGT_CODE = B.AGT_CODE
		LEFT JOIN COM_TEAM H  ON E.TEAM_SEQ = H.TEAM_SEQ AND H.AGT_CODE = B.AGT_CODE
		LEFT JOIN RES_SEGMENT K ON K.RES_CODE = A.RES_CODE
		LEFT JOIN PUB_CITY C  ON C.CITY_CODE = K.ARR_CITY_CODE
		LEFT JOIN PUB_NATION I  ON I.NATION_CODE = C.NATION_CODE
		LEFT JOIN PUB_REGION J  ON J.REGION_CODE = I.REGION_CODE
		' + @WHERE + '
		ORDER BY A.NEW_DATE DESC
		OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE ROWS ONLY '

	SET @PARMDEFINITION = N'
	@PAGE_INDEX INT,
	@PAGE_SIZE INT,
	@TOTAL_COUNT INT OUTPUT,
	@AGT_CODE VARCHAR(10),
	@TEAM_SEQ INT,
	@BT_DATE DATETIME,
	@EMP_NAME VARCHAR(20),
	@REGION_CODE VARCHAR(10)';

	PRINT @SQLSTRING

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
	@PAGE_INDEX,
	@PAGE_SIZE,
	@TOTAL_COUNT OUTPUT,
	@AGT_CODE,
	@TEAM_SEQ,
	@BT_DATE,
	@EMP_NAME,
	@REGION_CODE
END
GO