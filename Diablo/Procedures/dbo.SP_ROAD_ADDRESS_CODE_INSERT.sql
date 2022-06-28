USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_ROAD_ADDRESS_CODE_INSERT
■ DESCRIPTION				: 도로명 주소 코드 입력
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
CREATE PROC [dbo].[SP_ROAD_ADDRESS_CODE_INSERT]
	@CODE_DATA		XML
AS 
BEGIN
	INSERT INTO ROAD_ADDR_CODE
	SELECT
		  t1.col.value('./도로명코드[1]', 'VARCHAR(12)') AS 도로명코드
		, t1.col.value('./도로명[1]', 'VARCHAR(80)') as 도로명
		, t1.col.value('./도로명로마자[1]', 'VARCHAR(80)') as 도로명로마자
		, t1.col.value('./읍면동일련번호[1]', 'NVARCHAR(2)') as 읍면동일련번호
		, t1.col.value('./시도명[1]', 'VARCHAR(40)') as 시도명
		, t1.col.value('./시도로마자[1]', 'VARCHAR(40)') as 시도로마자
		, t1.col.value('./시군구명[1]', 'VARCHAR(40)') as 시군구명
		, t1.col.value('./시군구로마자[1]', 'VARCHAR(40)') as 시군구로마자
		, t1.col.value('./읍면동명[1]', 'VARCHAR(40)') as 읍면동명
		, t1.col.value('./읍면동로마자[1]', 'CHAR(40)') as 읍면동로마자
		, t1.col.value('./읍면동구분[1]', 'CHAR(1)') as 읍면동구분
		, t1.col.value('./읍면동코드[1]', 'CHAR(3)') as 읍면동코드
		, t1.col.value('./사용여부[1]', 'CHAR(1)') as 사용여부
		, t1.col.value('./변경사유[1]', 'CHAR(1)') as 변경사유
		, t1.col.value('./변경이력정보[1]', 'VARCHAR(14)') as 변경이력정보
		, t1.col.value('./고시일자[1]', 'CHAR(8)') as 고시일자
		, t1.col.value('./말소일자[1]', 'CHAR(8)') as 말소일자
	FROM @CODE_DATA.nodes('/ArrayOfRoadAddrCodeRQ/RoadAddrCodeRQ') as t1(col)

	--INSERT INTO ROAD_CODE
	--SELECT
	--	  t1.col.value('./시군구코드[1]', 'CHAR(5)') AS 시군구코드
	--	, t1.col.value('./도로명번호[1]', 'CHAR(7)') as 도로명번호
	--	, t1.col.value('./시군구코드[1]', 'CHAR(5)') + t1.col.value('./도로명번호[1]', 'CHAR(7)') AS 도로명코드
	--	, t1.col.value('./도로명[1]', 'VARCHAR(80)') as 도로명
	--	, t1.col.value('./도로명로마자[1]', 'NVARCHAR(80)') as 도로명로마자
	--	, t1.col.value('./읍면동일련번호[1]', 'CHAR(2)') as 읍면동일련번호
	--	, t1.col.value('./시도명[1]', 'VARCHAR(40)') as 시도명
	--	, t1.col.value('./시군구명[1]', 'VARCHAR(40)') as 시군구명
	--	, t1.col.value('./읍면동구분[1]', 'CHAR(1)') as 읍면동구분
	--	, t1.col.value('./읍면동코드[1]', 'CHAR(3)') as 읍면동코드
	--	, t1.col.value('./읍면동명[1]', 'VARCHAR(40)') as 읍면동명
	--	, t1.col.value('./상위도로명번호[1]', 'CHAR(7)') as 상위도로명번호
	--	, t1.col.value('./상위도로명[1]', 'VARCHAR(80)') as 상위도로명
	--	, t1.col.value('./사용여부[1]', 'CHAR(1)') as 사용여부
	--	, t1.col.value('./변경사유[1]', 'CHAR(1)') as 변경사유
	--	, t1.col.value('./변경이력정보[1]', 'VARCHAR(14)') as 변경이력정보
	--	, t1.col.value('./시도명로마자[1]', 'NVARCHAR(40)') as 시도명로마자
	--	, t1.col.value('./시군구명로마자[1]', 'NVARCHAR(40)') as 시군구명로마자
	--	, t1.col.value('./읍면동명로마자[1]', 'NVARCHAR(40)') as 읍면동명로마자
	--	, t1.col.value('./고시일자[1]', 'CHAR(8)') as 고시일자
	--	, t1.col.value('./말소일자[1]', 'CHAR(8)') as 말소일자
	--FROM @CODE_DATA.nodes('/ArrayOfRoadAddrCodeRQ/RoadAddrCodeRQ') as t1(col)

END

GO
