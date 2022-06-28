USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_ROAD_ADDRESS_BUILD_INSERT
■ DESCRIPTION				: 도로명 주소 건물 입력
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-11-02		정지용			최초생성  
================================================================================================================*/ 
CREATE PROC [dbo].[SP_ROAD_ADDRESS_BUILD_INSERT]
	@CODE_DATA		XML
AS 
BEGIN

	INSERT INTO ROAD_ADDR
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
	FROM @CODE_DATA.nodes('/ArrayOfRoadAddrBuildRQ/RoadAddrBuildRQ') as t1(col)

	--INSERT INTO ROAD_BUILD
	--SELECT
	--	  t1.col.value('./법정동코드[1]', 'CHAR(10)') AS 법정동코드
	--	, t1.col.value('./시도명[1]', 'VARCHAR(40)') as 시도명
	--	, t1.col.value('./시군구명[1]', 'VARCHAR(40)') as 시군구명
	--	, t1.col.value('./법정읍면동명[1]', 'VARCHAR(40)') as 법정읍면동명
	--	, t1.col.value('./법정리명[1]', 'VARCHAR(40)') as 법정리명
	--	, t1.col.value('./산여부[1]', 'CHAR(1)') as 산여부
	--	, t1.col.value('./지번본번[1]', 'INT') as 지번본번
	--	, t1.col.value('./지번부번[1]', 'INT') as 지번부번
	--	, t1.col.value('./도로명코드[1]', 'CHAR(12)') as 도로명코드
	--	, t1.col.value('./도로명[1]', 'VARCHAR(80)') as 도로명
	--	, t1.col.value('./지하여부[1]', 'CHAR(1)') as 지하여부
	--	, t1.col.value('./건물본번[1]', 'INT') as 건물본번
	--	, t1.col.value('./건물부번[1]', 'INT') as 건물부번
	--	, t1.col.value('./건축물대장건물명[1]', 'VARCHAR(40)') as 건축물대장건물명
	--	, t1.col.value('./상세건물명[1]', 'VARCHAR(100)') as 상세건물명
	--	, t1.col.value('./건물관리번호[1]', 'CHAR(25)') as 건물관리번호
	--	, t1.col.value('./읍면동일련번호[1]', 'CHAR(2)') as 읍면동일련번호
	--	, t1.col.value('./행정동코드[1]', 'CHAR(10)') as 행정동코드
	--	, t1.col.value('./행정동명[1]', 'VARCHAR(20)') as 행정동명
	--	, t1.col.value('./우편번호[1]', 'VARCHAR(5)') as 우편번호
	--	, t1.col.value('./우편일련번호[1]', 'VARCHAR(3)') as 우편일련번호
	--	, t1.col.value('./다량배달처명[1]', 'VARCHAR(40)') as 다량배달처명
	--	, t1.col.value('./이동사유코드[1]', 'VARCHAR(2)') as 이동사유코드
	--	, t1.col.value('./고시일자[1]', 'CHAR(8)') as 고시일자
	--	, t1.col.value('./변경전도로명주소[1]', 'VARCHAR(25)') as 변경전도로명주소
	--	, t1.col.value('./시군구용건물명[1]', 'VARCHAR(200)') as 시군구용건물명
	--	, t1.col.value('./공동주택여부[1]', 'CHAR(1)') as 공동주택여부
	--	, t1.col.value('./기초구역번호[1]', 'VARCHAR(5)') as 기초구역번호
	--	, t1.col.value('./상세주소부여여부[1]', 'CHAR(1)') as 상세주소부여여부
	--	, t1.col.value('./비고1[1]', 'VARCHAR(8)') as 비고1
	--	, t1.col.value('./비고2[1]', 'VARCHAR(8)') as 비고2
	--FROM @CODE_DATA.nodes('/ArrayOfRoadAddrBuildRQ/RoadAddrBuildRQ') as t1(col)

END

GO
