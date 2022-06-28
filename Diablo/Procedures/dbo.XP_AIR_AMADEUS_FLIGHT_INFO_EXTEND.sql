USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_AIR_AMADEUS_FLIGHT_INFO_EXTEND
■ DESCRIPTION				: 아마데우스 항공편 XML 데이터 확장
■ INPUT PARAMETER			: 
	@XML XML				: AMDEUS RESPONSE XML DATA
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_AIR_AMADEUS_FLIGHT_INFO_EXTEND ''

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-02-27		김성호			최초생성
   2014-03-07		김성호			숨은경유지, 코드쉐어항목 추가
   2014-06-12		박형만			flyingTime varchar(5) 로 변경 
================================================================================================================*/ 
CREATE  PROCEDURE [dbo].[XP_AIR_AMADEUS_FLIGHT_INFO_EXTEND]
(
	@XML XML
)
AS  
BEGIN

	WITH LIST AS
	(
		select 
			t1.col.value('./SegmentIndex[1]', 'int') as [SEGMENT_INDEX],
			t1.col.value('./AirlineCode[1]', 'varchar(2)') as [AIRLINE_CODE],
			t1.col.value('./DepartureDate[1]', 'varchar(10)') as [DEP_DATE],
			t1.col.value('./DepartureTime[1]', 'varchar(5)') as [DEP_TIME],
			t1.col.value('./ArrivalDate[1]', 'varchar(10)') as [ARR_DATE],
			t1.col.value('./ArrivalTime[1]', 'varchar(5)') as [ARR_TIME],
			t1.col.value('./FlyingTime[1]', 'varchar(5)') as [FLYING_TIME], 
			t1.col.value('./DepartureAirportCode[1]', 'varchar(3)') as [DEP_AIRPORT_CODE],
			t1.col.value('./ArrivalAirportCode[1]', 'varchar(3)') as [ARR_AIRPORT_CODE],
			t1.col.value('./HiddenStopAirportCode[1]', 'varchar(3)') as [HIDDEN_STOP_AIRPORT_CODE],
			t1.col.value('./HiddenStopStayTime[1]', 'varchar(10)') as [HIDDEN_STOP_STAY_TIME],
			t1.col.value('./CodeShareAirlineCode[1]', 'varchar(3)') as [CODESHARE_AIRLINE_CODE]

		from @xml.nodes('/ArrayOfSegmentInfoRS/SegmentInfoRS') as t1(col)
	)
	SELECT Z.*, A.KOR_NAME AS [AIRLINE_NAME]
		, B.KOR_NAME AS [DEP_AIRPORT_NAME], C.KOR_NAME AS [DEP_CITY_NAME]
		, D.KOR_NAME AS [ARR_AIRPORT_NAME], E.KOR_NAME AS [ARR_CITY_NAME]
		, G.KOR_NAME AS [HIDDEN_STOP_CITY_NAME], H.KOR_NAME AS [CODESHARE_AIRLINE_NAME]
	FROM LIST Z
	LEFT JOIN PUB_AIRLINE A WITH(NOLOCK) ON Z.AIRLINE_CODE = A.AIRLINE_CODE
	LEFT JOIN PUB_AIRPORT B WITH(NOLOCK) ON Z.DEP_AIRPORT_CODE = B.AIRPORT_CODE
	LEFT JOIN PUB_CITY C WITH(NOLOCK) ON B.CITY_CODE = C.CITY_CODE
	LEFT JOIN PUB_AIRPORT D WITH(NOLOCK) ON Z.ARR_AIRPORT_CODE = D.AIRPORT_CODE
	LEFT JOIN PUB_CITY E WITH(NOLOCK) ON D.CITY_CODE = E.CITY_CODE
	LEFT JOIN PUB_AIRPORT F WITH(NOLOCK) ON Z.HIDDEN_STOP_AIRPORT_CODE = F.AIRPORT_CODE
	LEFT JOIN PUB_CITY G WITH(NOLOCK) ON F.CITY_CODE = G.CITY_CODE
	LEFT JOIN PUB_AIRLINE H WITH(NOLOCK) ON Z.CODESHARE_AIRLINE_CODE = H.AIRLINE_CODE

END





/*
<ArrayOfSegmentInfoRS>
  <SegmentInfoRS>
    <SegmentIndex>1</SegmentIndex>
    <AirlineCode>CA</AirlineCode>
    <DepartureDate>2014-03-22</DepartureDate>
    <DepartureTime>18:10</DepartureTime>
    <ArrivalDate>2014-03-22</ArrivalDate>
    <ArrivalTime>19:20</ArrivalTime>
    <FlyingTime>0210</FlyingTime>
    <DepartureAirportCode>ICN</DepartureAirportCode>
    <ArrivalAirportCode>PEK</ArrivalAirportCode>
  </SegmentInfoRS>
  <SegmentInfoRS>
    <SegmentIndex>2</SegmentIndex>
    <AirlineCode>SU</AirlineCode>
    <DepartureDate>2014-03-23</DepartureDate>
    <DepartureTime>12:40</DepartureTime>
    <ArrivalDate>2014-03-23</ArrivalDate>
    <ArrivalTime>17:45</ArrivalTime>
    <FlyingTime>1005</FlyingTime>
    <DepartureAirportCode>ICN</DepartureAirportCode>
    <ArrivalAirportCode>SVO</ArrivalAirportCode>
  </SegmentInfoRS>
  <SegmentInfoRS>
    <SegmentIndex>3</SegmentIndex>
    <AirlineCode>MH</AirlineCode>
    <DepartureDate>2014-03-22</DepartureDate>
    <DepartureTime>11:00</DepartureTime>
    <ArrivalDate>2014-03-22</ArrivalDate>
    <ArrivalTime>16:50</ArrivalTime>
    <FlyingTime>0650</FlyingTime>
    <DepartureAirportCode>ICN</DepartureAirportCode>
    <ArrivalAirportCode>KUL</ArrivalAirportCode>
  </SegmentInfoRS>
  <SegmentInfoRS>
    <SegmentIndex>4</SegmentIndex>
    <AirlineCode>JL</AirlineCode>
    <DepartureDate>2014-03-22</DepartureDate>
    <DepartureTime>08:00</DepartureTime>
    <ArrivalDate>2014-03-22</ArrivalDate>
    <ArrivalTime>10:20</ArrivalTime>
    <FlyingTime>0220</FlyingTime>
    <DepartureAirportCode>ICN</DepartureAirportCode>
    <ArrivalAirportCode>NRT</ArrivalAirportCode>
  </SegmentInfoRS>
</ArrayOfSegmentInfoRS>
*/

GO
