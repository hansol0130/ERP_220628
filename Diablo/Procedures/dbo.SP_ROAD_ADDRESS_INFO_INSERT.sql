USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_ROAD_ADDRESS_INFO_INSERT
■ DESCRIPTION				: 도로명 주소 부가정보 입력
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
CREATE PROC [dbo].[SP_ROAD_ADDRESS_INFO_INSERT]
	@CODE_DATA		XML
AS 
BEGIN

	INSERT INTO ROAD_ADDR_INFO
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
	FROM @CODE_DATA.nodes('/ArrayOfRoadAddrInfoRQ/RoadAddrInfoRQ') as t1(col)

END

GO
