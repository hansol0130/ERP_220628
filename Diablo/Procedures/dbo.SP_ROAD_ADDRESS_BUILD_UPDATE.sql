USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: SP_ROAD_ADDRESS_BUILD_UPDATE
■ DESCRIPTION				: 도로명 주소, 지번, 부가정보 수정/삭제
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-11-18		이유라			최초생성  
================================================================================================================*/ 
CREATE PROC [dbo].[SP_ROAD_ADDRESS_BUILD_UPDATE]
	@JUSO_CODE_DATA		XML,
	@JIBUN_CODE_DATA	XML,
	@INFO_CODE_DATA		XML
AS 
BEGIN

	DECLARE @TEMP_JUSO_TABLE TABLE (
		관리번호	VARCHAR(25),
		도로명코드	VARCHAR(12),
		읍면동일련번호	VARCHAR(2),
		지하여부	CHAR(1),
		건물본번	INT,
		건물부번	INT,
		기초구역번호	VARCHAR(5),
		변경사유코드	CHAR(2),
		고시일자	VARCHAR(8),
		변경전도로명주소	VARCHAR(25),
		상세주소부여여부	CHAR(1)
	);
	DECLARE @TEMP_JIBUN_TABLE TABLE (
		관리번호	VARCHAR(25),
		일련번호	INT,
		법정동코드	VARCHAR(10),
		시도명		VARCHAR(20),
		시군구명	VARCHAR(20),
		법정읍면동명	VARCHAR(20),
		법정리명	VARCHAR(20),
		산여부		CHAR(1),
		지번본번	INT,
		지번부번	INT,
		대표여부	CHAR(1)
	);
	DECLARE @TEMP_INFO_TABLE TABLE (
		관리번호	VARCHAR(25),
		행정동코드	VARCHAR(10),
		행정동명	VARCHAR(20),
		우편번호	VARCHAR(5),
		우편번호일련번호	VARCHAR(3),
		다량배달처명	VARCHAR(40),
		건축물대장건물명	VARCHAR(40),
		시군구건물명	VARCHAR(200),
		공동주택여부	CHAR(1)
	);

	WITH LIST AS (
		SELECT
			  t1.col.value('./관리번호[1]', 'VARCHAR(25)') AS 관리번호
			, t1.col.value('./도로명코드[1]', 'VARCHAR(12)') as 도로명코드
			, t1.col.value('./읍면동일련번호[1]', 'VARCHAR(2)') as 읍면동일련번호
			, t1.col.value('./지하여부[1]', 'CHAR(1)') as 지하여부
			, t1.col.value('./건물본번[1]', 'INT') as 건물본번
			, t1.col.value('./건물부번[1]', 'INT') as 건물부번
			, t1.col.value('./기초구역번호[1]', 'VARCHAR(5)') as 기초구역번호
			, t1.col.value('./변경사유코드[1]', 'CHAR(2)') as 변경사유코드
			, t1.col.value('./고시일자[1]', 'VARCHAR(8)') as 고시일자
			, t1.col.value('./변경전도로명주소[1]', 'VARCHAR(25)') as 변경전도로명주소
			, t1.col.value('./상세주소부여여부[1]', 'CHAR(1)') as 상세주소부여여부
		FROM @JUSO_CODE_DATA.nodes('/ArrayOfRoadAddrBuildRQ/RoadAddrBuildRQ') as t1(col)
	)
	INSERT INTO @TEMP_JUSO_TABLE 
	SELECT * FROM LIST;

	WITH LIST AS (
		SELECT
			  t1.col.value('./관리번호[1]', 'VARCHAR(25)') AS 관리번호
			, t1.col.value('./일련번호[1]', 'INT') as 일련번호
			, t1.col.value('./법정동코드[1]', 'VARCHAR(10)') as 법정동코드
			, t1.col.value('./시도명[1]', 'VARCHAR(20)') as 시도명
			, t1.col.value('./시군구명[1]', 'VARCHAR(20)') as 시군구명
			, t1.col.value('./법정읍면동명[1]', 'VARCHAR(20)') as 법정읍면동명
			, t1.col.value('./법정리명[1]', 'VARCHAR(20)') as 법정리명
			, t1.col.value('./산여부[1]', 'CHAR(1)') as 산여부
			, t1.col.value('./지번본번[1]', 'INT') as 지번본번
			, t1.col.value('./지번부번[1]', 'INT') as 지번부번
			, t1.col.value('./대표여부[1]', 'CHAR(1)') as 대표여부	
		FROM @JIBUN_CODE_DATA.nodes('/ArrayOfRoadAddrJibunRQ/RoadAddrJibunRQ') as t1(col)
	)
	INSERT INTO @TEMP_JIBUN_TABLE
	SELECT * FROM LIST;

	WITH LIST AS (
		SELECT
			  t1.col.value('./관리번호[1]', 'VARCHAR(25)') AS 관리번호
			, t1.col.value('./행정동코드[1]', 'VARCHAR(10)') as 행정동코드
			, t1.col.value('./행정동명[1]', 'VARCHAR(20)') as 행정동명
			, t1.col.value('./우편번호[1]', 'VARCHAR(5)') as 우편번호
			, t1.col.value('./우편번호일련번호[1]', 'VARCHAR(3)') as 우편번호일련번호
			, t1.col.value('./다량배달처명[1]', 'VARCHAR(40)') as 다량배달처명
			, t1.col.value('./건축물대장건물명[1]', 'VARCHAR(40)') as 건축물대장건물명
			, t1.col.value('./시군구건물명[1]', 'VARCHAR(200)') as 시군구건물명
			, t1.col.value('./공동주택여부[1]', 'CHAR(1)') as 공동주택여부
		FROM @INFO_CODE_DATA.nodes('/ArrayOfRoadAddrInfoRQ/RoadAddrInfoRQ') as t1(col)
	)
	INSERT INTO @TEMP_INFO_TABLE
	SELECT * FROM LIST;

	--SELECT A.* FROM @TEMP_JUSO_TABLE A 
	--SELECT A.* FROM @TEMP_JIBUN_TABLE A
	--SELECT A.* FROM @TEMP_INFO_TABLE A 

	--주소테이블 변경사유코드 31번 신규 
	INSERT INTO ROAD_ADDR SELECT * FROM @TEMP_JUSO_TABLE WHERE 변경사유코드 = '31'
	INSERT INTO ROAD_ADDR_JIBUN SELECT A.* FROM @TEMP_JIBUN_TABLE A INNER JOIN @TEMP_JUSO_TABLE B ON A.관리번호 = B.관리번호 AND B.변경사유코드 = '31'
	INSERT INTO ROAD_ADDR_INFO SELECT A.* FROM @TEMP_INFO_TABLE A INNER JOIN @TEMP_JUSO_TABLE B ON A.관리번호 = B.관리번호 AND B.변경사유코드 = '31'

	--주소테이블 변경사유코드 63번 폐지 
	DELETE FROM ROAD_ADDR WHERE 관리번호 IN (SELECT 관리번호 FROM @TEMP_JUSO_TABLE WHERE 변경사유코드 = '63')

	--주소테이블 변경사유코드 34,51,70,71번 수정
	UPDATE A 
	SET 
		A.도로명코드 = B.도로명코드,
		A.읍면동일련번호 = B.읍면동일련번호,
		A.지하여부 = B.지하여부,
		A.건물본번 = B.건물본번,
		A.건물부번 = B.건물부번,
		A.기초구역번호 = B.기초구역번호,
		A.변경사유코드 = B.변경사유코드,
		A.고시일자 = B.고시일자,
		A.변경전도로명주소 =  B.변경전도로명주소,
		A.상세주소부여여부 = B.상세주소부여여부
	FROM ROAD_ADDR A
	INNER JOIN @TEMP_JUSO_TABLE B ON A.관리번호 = B.관리번호 AND B.변경사유코드 IN ('34', '51', '70', '71')

	UPDATE A 
	SET 
		--A.일련번호 = C.일련번호,
		A.법정동코드 = C.법정동코드,
		A.시도명 = C.시도명,
		A.시군구명 = C.시군구명,
		A.법정읍면동명 = C.법정읍면동명,
		A.법정리명 = C.법정리명,
		A.산여부 = C.산여부,
		A.지번본번 = C.지번본번,
		A.지번부번 = C.지번부번,
		A.대표여부 = C.대표여부
	FROM ROAD_ADDR_JIBUN A
	INNER JOIN @TEMP_JUSO_TABLE B ON A.관리번호 = B.관리번호 AND B.변경사유코드 IN ('34', '51', '70', '71')
	INNER JOIN @TEMP_JIBUN_TABLE C ON A.관리번호 = C.관리번호

	UPDATE A 
	SET 
		A.행정동코드 = C.행정동코드,
		A.행정동명 = C.행정동명,
		A.우편번호 = C.우편번호,
		A.우편번호일련번호 = C.우편번호일련번호,
		A.다량배달처명 = C.다량배달처명,
		A.건축물대장건물명 = C.건축물대장건물명,
		A.시군구건물명 = C.시군구건물명,
		A.공동주택여부 = C.공동주택여부
	FROM ROAD_ADDR_INFO A
	INNER JOIN @TEMP_JUSO_TABLE B ON A.관리번호 = B.관리번호 AND B.변경사유코드 IN ('34', '51', '70', '71')
	INNER JOIN @TEMP_INFO_TABLE C ON A.관리번호 = C.관리번호

END

GO
