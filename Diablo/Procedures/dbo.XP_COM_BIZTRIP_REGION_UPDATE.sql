USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BIZTRIP_REGION_UPDATE
■ DESCRIPTION				: BTMS 출장자 규정 지역 등록
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-31		김성호			최초생성
   2016-02-03		김성호			임시테이블 -> 테이블변수로 수정
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BIZTRIP_REGION_UPDATE]
	@AGT_CODE			VARCHAR(10),
	@REG_MASTER_SEQ		INT,
	@REGION_NAME		VARCHAR(20),
	@ALL_YN				CHAR(1),
	@USE_YN				CHAR(1),
	@NEW_SEQ			INT,

	@DETAIL_INFO		XML
AS 
BEGIN

	-- 본문
	IF EXISTS(SELECT 1 FROM COM_REGION_MASTER WITH(NOLOCK) WHERE AGT_CODE = @AGT_CODE AND REG_MASTER_SEQ = @REG_MASTER_SEQ)
	BEGIN
		UPDATE A SET A.REGION_NAME = @REGION_NAME, A.ALL_YN = @ALL_YN, A.USE_YN = @USE_YN, EDT_DATE = GETDATE(), EDT_SEQ = @NEW_SEQ
		FROM COM_REGION_MASTER A
		WHERE A.AGT_CODE = @AGT_CODE AND A.REG_MASTER_SEQ = @REG_MASTER_SEQ
	END
	ELSE
	BEGIN
		SELECT @REG_MASTER_SEQ = ISNULL((SELECT MAX(REG_MASTER_SEQ) FROM COM_REGION_MASTER WITH(NOLOCK) WHERE AGT_CODE = @AGT_CODE), 0) + 1

		INSERT INTO COM_REGION_MASTER (AGT_CODE, REG_MASTER_SEQ, REGION_NAME, ALL_YN, USE_YN, NEW_DATE, NEW_SEQ)
		VALUES (@AGT_CODE, @REG_MASTER_SEQ, @REGION_NAME, @ALL_YN, @USE_YN, GETDATE(), @NEW_SEQ)
	END;

	-- 테이블변수 선언
	DECLARE @TEMP_REGION_DETAIL TABLE (
		RowNumber		INT,
		RegionDetailSeq	INT,
		RegionType		CHAR(1),
		RegionCode		VARCHAR(3)
	)

	INSERT INTO @TEMP_REGION_DETAIL (RowNumber, RegionDetailSeq, RegionType, RegionCode)
	SELECT
		ROW_NUMBER() OVER (ORDER BY t1.col.value('./RegionDetailSeq[1]', 'int')) AS [RowNumber]
		, t1.col.value('./RegionDetailSeq[1]', 'int') as [RegionDetailSeq]
		, t1.col.value('./RegionType[1]', 'char(1)') as [RegionType]
		, t1.col.value('./RegionCode[1]', 'varchar(3)') as [RegionCode]
	FROM @DETAIL_INFO.nodes('/ArrayOfBizTripRegionDetailRQ/BizTripRegionDetailRQ') as t1(col)
	-- 삭제
	UPDATE A SET A.USE_YN = 'N', A.EDT_DATE = GETDATE(), A.EDT_SEQ = @NEW_SEQ
	FROM COM_REGION_DETAIL A
	WHERE A.AGT_CODE = @AGT_CODE AND A.REG_MASTER_SEQ = @REG_MASTER_SEQ AND A.USE_YN = 'Y' AND A.REG_DETAIL_SEQ NOT IN (SELECT RegionDetailSeq FROM @TEMP_REGION_DETAIL);
	-- 등록
	DECLARE @MAX_SEQ INT
	SELECT @MAX_SEQ = ISNULL((SELECT MAX(A.REG_DETAIL_SEQ) FROM COM_REGION_DETAIL A WITH(NOLOCK) WHERE A.AGT_CODE = @AGT_CODE AND A.REG_MASTER_SEQ = @REG_MASTER_SEQ), 0)

	INSERT INTO COM_REGION_DETAIL (AGT_CODE, REG_MASTER_SEQ, REG_DETAIL_SEQ, REG_TYPE, REG_CODE, USE_YN, NEW_DATE, NEW_SEQ)
	SELECT @AGT_CODE, @REG_MASTER_SEQ, (@MAX_SEQ + A.RowNumber), A.RegionType, A.RegionCode, 'Y', GETDATE(), @NEW_SEQ
	FROM @TEMP_REGION_DETAIL A
	WHERE A.RegionDetailSeq = 0

END
GO
