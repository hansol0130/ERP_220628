USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_ROAD_ADDRESS_JIBUN_INSERT
■ DESCRIPTION				: 도로명 주소 지번 입력
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
CREATE PROC [dbo].[SP_ROAD_ADDRESS_JIBUN_INSERT]
	@CODE_DATA		XML
AS 
BEGIN
	INSERT INTO ROAD_ADDR_JIBUN
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
	FROM @CODE_DATA.nodes('/ArrayOfRoadAddrJibunRQ/RoadAddrJibunRQ') as t1(col)

	--INSERT INTO ROAD_JIBUN
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
	--	, t1.col.value('./지하여부[1]', 'CHAR(1)') as 지하여부
	--	, t1.col.value('./건물본번[1]', 'INT') as 건물본번
	--	, t1.col.value('./건물부번[1]', 'INT') as 건물부번		
	--	, t1.col.value('./지번일련번호[1]', 'INT') as 지번일련번호
	--	, t1.col.value('./이동사유코드[1]', 'VARCHAR(2)') as 이동사유코드
	--FROM @CODE_DATA.nodes('/ArrayOfRoadAddrJibunRQ/RoadAddrJibunRQ') as t1(col)

END
GO
