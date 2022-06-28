USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_ROAD_ADDRESS_CODE_UPDATE
■ DESCRIPTION				: 도로명 주소 코드 수정
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-11-17		이유라			최초생성  
================================================================================================================*/ 
CREATE PROC [dbo].[SP_ROAD_ADDRESS_CODE_UPDATE]
	@CODE_DATA		XML
AS 
BEGIN

	DECLARE @TEMP_CODE_TABLE TABLE (
			도로명코드 VARCHAR(12),
			도로명	VARCHAR(80),
			도로명로마자	NVARCHAR(160),
			읍면동일련번호	VARCHAR(2),
			시도명	VARCHAR(40),
			시도로마자	NVARCHAR(80),
			시군구명	VARCHAR(40),
			시군구로마자	NVARCHAR(80),
			읍면동명	VARCHAR(40),
			읍면동로마자	NVARCHAR(80),
			읍면동구분	CHAR(1),
			읍면동코드	CHAR(3),
			사용여부	CHAR(1),
			변경사유	CHAR(1),
			변경이력정보	VARCHAR(14),
			고시일자	VARCHAR(8),
			말소일자	VARCHAR(8)
	);

	WITH LIST AS
	(
		SELECT
			  t1.col.value('./도로명코드[1]', 'VARCHAR(12)') AS 도로명코드
			, t1.col.value('./도로명[1]', 'VARCHAR(80)') as 도로명
			, t1.col.value('./도로명로마자[1]', 'NVARCHAR(160)') as 도로명로마자
			, t1.col.value('./읍면동일련번호[1]', 'VARCHAR(2)') as 읍면동일련번호
			, t1.col.value('./시도명[1]', 'VARCHAR(40)') as 시도명
			, t1.col.value('./시도로마자[1]', 'NVARCHAR(80)') as 시도로마자
			, t1.col.value('./시군구명[1]', 'VARCHAR(40)') as 시군구명
			, t1.col.value('./시군구로마자[1]', 'NVARCHAR(80)') as 시군구로마자
			, t1.col.value('./읍면동명[1]', 'VARCHAR(40)') as 읍면동명
			, t1.col.value('./읍면동로마자[1]', 'NVARCHAR(80)') as 읍면동로마자
			, t1.col.value('./읍면동구분[1]', 'CHAR(1)') as 읍면동구분
			, t1.col.value('./읍면동코드[1]', 'CHAR(3)') as 읍면동코드
			, t1.col.value('./사용여부[1]', 'CHAR(1)') as 사용여부
			, t1.col.value('./변경사유[1]', 'CHAR(1)') as 변경사유
			, t1.col.value('./변경이력정보[1]', 'VARCHAR(14)') as 변경이력정보
			, t1.col.value('./고시일자[1]', 'VARCHAR(8)') as 고시일자
			, t1.col.value('./말소일자[1]', 'VARCHAR(8)') as 말소일자
		FROM @CODE_DATA.nodes('/ArrayOfRoadAddrCodeRQ/RoadAddrCodeRQ') as t1(col)
	)
	INSERT INTO @TEMP_CODE_TABLE 
	SELECT * FROM LIST;

	--신규
	INSERT INTO ROAD_ADDR_CODE SELECT * FROM @TEMP_CODE_TABLE WHERE 변경이력정보 = '신규'

	--수정
	UPDATE A
	SET 
		A.도로명 = B.도로명,
		A.도로명로마자 = B.도로명로마자,
		A.시도명 = B.시도명,
		A.시도로마자 = B.시도로마자,
		A.시군구명 = B.시군구명,
		A.시군구로마자 = B.시군구로마자,
		A.읍면동명 = B.읍면동명,
		A.읍면동로마자 = B.읍면동로마자,
		A.읍면동구분 = B.읍면동구분,
		A.읍면동코드 = B.읍면동코드,
		A.사용여부 = B.사용여부,
		A.변경사유 = B.변경사유,
		A.변경이력정보 = B.변경이력정보,
		A.고시일자 = B.고시일자,
		A.말소일자 = B.말소일자
	FROM ROAD_ADDR_CODE A
	INNER JOIN @TEMP_CODE_TABLE B ON  A.도로명코드 = B.도로명코드 AND A.읍면동일련번호 = B.읍면동일련번호 AND B.사용여부 = '0' AND B.변경이력정보 != '신규'

	--삭제
	DELETE A FROM ROAD_ADDR_CODE A INNER JOIN @TEMP_CODE_TABLE B ON A.도로명코드 = B.도로명코드 AND A.읍면동일련번호 = B.읍면동일련번호 AND B.사용여부 = '1'

END

GO
