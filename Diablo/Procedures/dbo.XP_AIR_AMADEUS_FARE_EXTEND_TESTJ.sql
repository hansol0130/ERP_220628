USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_AIR_AMADEUS_FARE_EXTEND_TESTJ
■ DESCRIPTION				: 아마데우스 XML 데이터 확장
■ INPUT PARAMETER			: 
	@XML XML				: AMDEUS RESPONSE XML DATA
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	DECLARE @SERVICE_FEE VARCHAR(10)

	exec XP_AIR_AMADEUS_FARE_EXTEND '', @SERVICE_FEE OUTPUT

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-02-24		김성호			최초생성
   2014-07-07		김성호			운임규정 조회를 위해 breakpoint 값 리턴
   2014-08-26		김성호			maxStay REF 값 넣기
   2014-09-05		김성호			수수료 검색 추가
   2014-09-24		박형만			Slice & Dice 를 위한 specific 테이블 추가
   2014-10-02		김성호			토파스 요청으로 7C,TW,ZE 항공사의 RP 운임 제외
   2014-10-15		박형만			룰조회 위한 paxCount 추가
   2014-10-21		김성호			토파스 요청으로 LJ, Z2 항공사의 RP 운임 추가 제외
   2014-10-21		박형만			항공팀 요청으로 RA(ATPCO nego fares - CAT35) 요금 제외
   2015-02-05		김성호			항공팀 요청으로 15.03.01 출발 칼리보(KLO)행 필리핀항공(PR) 일정 제외
   2016-02-18		김성호			토파스 요청으로 PR 항공사의 RP 운임 추가 제외 및 칼리보 예외처리 삭제
   2016-04-25		박형만			항공팀 요청으로 RA(ATPCO nego fares - CAT35) 요금 다시 노출 
   2016-10-18		박형만			무료 수하물 정보 추가 
--**   2016-12-26		김성호			일정 항목에 공동운항 항공사명 추가
   2017-03-10		박형만			chdFareBasis , infFareBasis 추가 
   2017-07-26		김성호			Non-Air 여정 제외 (17.02.16 토파스 메일 참조)
================================================================================================================*/ 
CREATE  PROCEDURE [dbo].[XP_AIR_AMADEUS_FARE_EXTEND_TESTJ]
(
	@XML XML,
	@SERVICE_FEE VARCHAR(10) OUTPUT
)
AS  
BEGIN

	-- 조건에 맞는 일정 체크
	--DECLARE @ACCORD_COUNT INT;

	-- 칼리보공항행 15.03.01 출발 일정 체크
	--with groupOfFlights as
	--(
	--	select
	--		t2.col.value('./flightDetails[1]/flightInformation[1]/productDateTime[1]/dateOfDeparture[1]', 'varchar(6)') as [dateOfDeparture],
	--		t2.col.value('./flightDetails[last()]/flightInformation[1]/location[last()]/locationId[1]', 'varchar(3)') as [airportOfArrival]
	--	from @Xml.nodes('/Fare_MasterPricerTravelBoardSearchReply/flightIndex') AS t1(col)
	--	cross apply t1.col.nodes('./groupOfFlights') as t2(col)
	--)
	--select @ACCORD_COUNT = count(*)
	--from groupOfFlights z
	--where z.dateOfDeparture NOT LIKE '__0215' and z.airportOfArrival = 'KLO';

	with list as 
	(
		select
			t1.col.value('./itemNumber[1]/itemNumberId[1]/number[1]', 'int') as [number],	-- 운임번호
			ROW_NUMBER() over ( partition by  t1.col.value('./itemNumber[1]/itemNumberId[1]/number[1]', 'int')  
				order by t1.col.value('./itemNumber[1]/itemNumberId[1]/number[1]', 'int') ) as fab_num , -- paxProduct 별 순번 
			t1.col.value('./paxFareProduct[1]/paxFareDetail[1]/codeShareDetails[transportStageQualifier="V"][1]/company[1]', 'varchar(3)') as [company],
			t1.col.value('./recPriceInfo[1]/monetaryDetail[1]/amount[1]', 'decimal') as [totalFareAmount],
			t1.col.value('./recPriceInfo[1]/monetaryDetail[2]/amount[1]', 'decimal') as [totalTaxAmount],
			t1.col.value('./recPriceInfo[1]/monetaryDetail[amountType="F"][1]/amount[1]', 'decimal') as [totalFuelAmountTypeF],
			t1.col.value('./recPriceInfo[1]/monetaryDetail[amountType="Q"][1]/amount[1]', 'decimal') as [totalFuelAmountTypeQ],

			t1.col.value('./paxFareProduct[paxReference/ptc="ADT"][1]/paxFareDetail[1]/totalFareAmount[1]', 'decimal') as [adultFareAmount],
			t1.col.value('./paxFareProduct[paxReference/ptc="ADT"][1]/paxFareDetail[1]/totalTaxAmount[1]', 'decimal') as [adultTaxAmount],
			t1.col.value('./paxFareProduct[paxReference/ptc="ADT"][1]/paxFareDetail[1]/monetaryDetails[amountType="F"][1]/amount[1]', 'decimal') as [adultFuelamountTypeF],
			t1.col.value('./paxFareProduct[paxReference/ptc="ADT"][1]/paxFareDetail[1]/monetaryDetails[amountType="Q"][1]/amount[1]', 'decimal') as [adultFuelamountTypeQ],

			t2.col.value('./segmentRef[1]/segRef[1]', 'int') as [segRef],	-- 여정번호
			t2.col.value('./majCabin[1]/bookingClassDetails[1]/designator[1]', 'varchar(1)') as [majCabin],
			t2.col.value('count(./groupOfFares)', 'int') as [byWayCount],

			t3.col.value('./productInformation[1]/cabinProduct[1]/rbd[1]', 'varchar(1)') as [rbd],
			t3.col.value('./productInformation[1]/cabinProduct[1]/cabin[1]', 'varchar(1)') as [cabin],
			t3.col.value('./productInformation[1]/cabinProduct[1]/avlStatus[1]', 'varchar(1)') as [avlStatus],
			t3.col.value('./productInformation[1]/fareProductDetail[1]/fareBasis[1]', 'varchar(10)') as [fareBasis],
			--t3.col.query('./productInformation[1]/fareProductDetail[1]/fareType/text()') as [fareType],
			REPLACE(REPLACE(CONVERT(VARCHAR(100), t3.col.query('./productInformation[1]/fareProductDetail[1]//fareType')), '<fareType>', ''), '</fareType>', ',') as [fareType],
			t3.col.value('./productInformation[1]/breakPoint[1]', 'varchar(1)') as [breakPoint] ,

			t3.col.value('./fareFamiliesRef[1]/referencingDetail[1]/refQualifier[1]', 'varchar(1)') as [mnrLstRefQualifier],
			t3.col.value('./fareFamiliesRef[1]/referencingDetail[1]/refNumber[1]', 'int') as [mnrLstRefNum]

		from @Xml.nodes('/Fare_MasterPricerTravelBoardSearchReply/recommendation') AS t1(col)	-- 운임
		cross apply t1.col.nodes('./paxFareProduct[paxReference/ptc="ADT"][1]/fareDetails') as t2(col)	-- 여정
		cross apply t2.col.nodes('./groupOfFares') as t3(col)	-- 세그
	)
	,farebasis as   -- paxFareProduct 의 FareBasis 추가  child , infant 별로 FareBasis 가 다른 경우가  있음 2017.03.10
	(
		select row_number() over (  partition by number , ptc  order by number) as fab_num , * from (
			select
				t1.col.value('./itemNumber[1]/itemNumberId[1]/number[1]', 'int') as [number],	-- 운임번호
				t2.col.value('./paxReference[1]/ptc[1]','varchar(3)') as ptc , 
				t4.col.value('./productInformation[1]/fareProductDetail[1]/fareBasis[1]', 'varchar(10)') as [fareBasis] -- ,
				--t4.col.value('./fareFamiliesRef[1]/referencingDetail[1]/refNumber[1]', 'int') as [mnrLstRefNum]
			from @Xml.nodes('/Fare_MasterPricerTravelBoardSearchReply/recommendation') AS t1(col)	-- 운임
			cross apply t1.col.nodes('./paxFareProduct') as t2(col)	-- 여정
			cross apply t2.col.nodes('./fareDetails/groupOfFares') as t4(col)	-- 세그  
		) t 
	) 
	select --z.*, a.KOR_NAME as [companyName]
		z.number, z.company, a.KOR_NAME as [companyName], z.totalFareAmount, z.totalTaxAmount, z.totalFuelAmountTypeF, z.totalFuelAmountTypeQ
		, z.adultFareAmount, z.adultTaxAmount, z.adultFuelamountTypeF, z.adultFuelamountTypeQ, z.segRef, z.majCabin, (z.byWayCount - 1) as [byWayCount]
		, z.rbd, z.cabin, z.avlStatus, z.fareBasis, z.fareType, z.breakPoint ,z.mnrLstRefQualifier , z.mnrLstRefNum  
		, ch.fareBasis as chdFareBasis , inf.fareBasis as infFareBasis 
	from list z
	inner join PUB_AIRLINE a with(nolock) on z.company = a.AIRLINE_CODE
	left join farebasis ch on z.number = ch.number and z.fab_num = ch.fab_num and ch.ptc = 'CH'
	left join farebasis inf on z.number = inf.number and z.fab_num = inf.fab_num and inf.ptc = 'IN'
	-- 14.10.02 7C, TW, ZE 항공 RP 운임 제외
	WHERE z.number IN (
		SELECT A.number
		FROM (
			SELECT aa.number, MAX(aa.company) AS [company], MAX(CHARINDEX('RP', CONVERT(VARCHAR(20), aa.fareType))) AS [RP_COUNT] 
			, MAX(CHARINDEX('RA', CONVERT(VARCHAR(20), aa.fareType))) AS [RA_COUNT] 
			FROM list aa
			GROUP BY aa.number
		) A
		WHERE (A.company NOT IN ('7C', 'TW', 'ZE', 'LJ', 'Z2', 'CZ', 'PR') OR A.RP_COUNT = 0)	-- 토파스 요청으로 7C,TW,ZE,LJ,Z2 항공사의 RP 운임 제외
		--and A.RA_COUNT = 0																-- 항공팀 요청으로 RA(ATPCO nego fares - CAT35) 요금 제외
		--and (@ACCORD_COUNT = 0 OR A.company <> 'PR')									-- 항공팀 요청으로 15.03.01 출발 칼리보(KLO)행 필리핀항공(PR) 일정 제외
	) 
	---------------------------------------
	order by z.number, z.segRef;

	-- 규정
	select
		t1.col.value('./itemNumber[1]/itemNumberId[1]/number[1]', 'int') as [number],	-- 운임번호
		t2.col.value('./pricingMessage[1]/freeTextQualification[1]/textSubjectQualifier[1]', 'varchar(5)') as [textSubjectQualifier],
		t2.col.value('./pricingMessage[1]/freeTextQualification[1]/informationType[1]', 'varchar(5)') as [informationType],
		t2.col.query('./pricingMessage[1]/description/text()') as [description],
		t2.col.value('./monetaryInformation[1]/monetaryDetail[1]/amount[1]', 'decimal') as [amount],
		t2.col.value('./monetaryInformation[1]/monetaryDetail[1]/currency[1]', 'varchar(3)') as [currency]
	from @xml.nodes('/Fare_MasterPricerTravelBoardSearchReply/recommendation') AS t1(col)	-- 운임
	cross apply t1.col.nodes('./paxFareProduct[paxReference/ptc="ADT"][1]/fare') as t2(col);

	/*-- 규정상세조회 조건테이블
	with list as
	(
		select
			ROW_NUMBER() over(order by
				t1.col.value('./itemNumber[1]/itemNumberId[1]/number[1]', 'int'),
				t3.col.value('./segmentRef[1]/segRef[1]', 'int'),
				t2.col.value('./paxFareDetail[1]/paxFareNum[1]', 'int')
			) as [segNum],
			t1.col.value('./itemNumber[1]/itemNumberId[1]/number[1]', 'int') as [number],	-- 운임번호
			t2.col.value('./paxFareDetail[1]/paxFareNum[1]', 'int') as [paxFareNum],
			t2.col.value('./paxReference[1]/ptc[1]', 'varchar(3)') as [ptc],
			t2.col.query('./paxReference[1]/traveller/ref/text()') as [reference],
			t3.col.value('./segmentRef[1]/segRef[1]', 'int') as [fareNum],
			t4.col.value('./productInformation[1]/cabinProduct[1]/rbd[1]', 'varchar(3)') as [bookingClass],
			t4.col.value('./productInformation[1]/fareProductDetail[1]/fareBasis[1]', 'varchar(10)') as [fareBasis],
			t4.col.value('./productInformation[1]/breakPoint[1]', 'varchar(1)') as [breakPoint]
		from @Xml.nodes('/Fare_MasterPricerTravelBoardSearchReply/recommendation') AS t1(col)	-- 운임
		cross apply t1.col.nodes('./paxFareProduct') as t2(col)	-- 연령구분
		cross apply t2.col.nodes('./fareDetails') as t3(col)	-- 
		cross apply t3.col.nodes('./groupOfFares') as t4(col)	-- 세그
	)
	select a.number, a.fareNum, a.segNum, bookingClass, fareBasis, breakPoint, a.paxFareNum, ptc, reference
	from list a
	order by number, fareNum, segNum, paxFareNum;
	*/

	-- 고객타입
	select
		t1.col.value('../itemNumber[1]/itemNumberId[1]/number[1]', 'int') as [number],	-- 운임번호
		t1.col.value('./paxFareDetail[1]/paxFareNum[1]', 'int') as [paxFareNum],
		t1.col.value('./paxReference[1]/ptc[1]', 'varchar(3)') as [ptc],
		t1.col.value('count(./paxReference[1]/traveller)', 'int') as [paxCount],
		t1.col.value('./paxFareDetail[1]/totalFareAmount[1]', 'decimal') as [paxFareAmount],
		t1.col.value('./paxFareDetail[1]/totalTaxAmount[1]', 'decimal') as [paxTaxAmount],
		t1.col.value('./paxFareDetail[1]/monetaryDetails[amountType="F"][1]/amount[1]', 'decimal') as [paxFuelAmountTypeF],
		t1.col.value('./paxFareDetail[1]/monetaryDetails[amountType="Q"][1]/amount[1]', 'decimal') as [paxFuelAmountTypeQ]
	from @xml.nodes('/Fare_MasterPricerTravelBoardSearchReply/recommendation/paxFareProduct') AS t1(col);	-- 운임

	-- 스케줄
	select
		t1.col.value('./itemNumber[1]/itemNumberId[1]/number[1]', 'int') as [number],	-- 운임번호
		--t2.col.value('./referencingDetail[1]/refNumber[1]', 'int') as [refNumber1], -- 아래 S:세그 , B:수화물 정보랑 구분해서 사용 으로 변경 
		--t2.col.value('./referencingDetail[2]/refNumber[1]', 'int') as [refNumber2], -- AmadeusMasterPricerTravelBoardSearch 의 Slice & Dice 로직 때문,,
		--t2.col.value('./referencingDetail[3]/refNumber[1]', 'int') as [refNumber3],
		t2.col.value('./referencingDetail[refQualifier="S"][1]/refNumber[1]', 'int') as [refNumber1], --  S:세그
		t2.col.value('./referencingDetail[refQualifier="S"][2]/refNumber[1]', 'int') as [refNumber2],
		t2.col.value('./referencingDetail[refQualifier="S"][3]/refNumber[1]', 'int') as [refNumber3],
		t2.col.value('./referencingDetail[refQualifier="B"][1]/refNumber[1]', 'int') as [bagRefNumber] ,  --B:수화물
		t2.col.value('./referencingDetail[1]/refQualifier[1]', 'varchar(1)') as [refQualifier1],  --사용안하는듯 ..
		t2.col.value('./referencingDetail[2]/refQualifier[1]', 'varchar(1)') as [refQualifier2],
		t2.col.value('./referencingDetail[3]/refQualifier[1]', 'varchar(1)') as [refQualifier3],
		t2.col.value('./referencingDetail[4]/refQualifier[1]', 'varchar(1)') as [refQualifier4]
	from @Xml.nodes('/Fare_MasterPricerTravelBoardSearchReply/recommendation') AS t1(col)	-- 운임
	cross apply t1.col.nodes('./segmentFlightRef') as t2(col);
	
	-- 일정
	with groupOfFlights as
	(
		select
			t1.col.value('./requestedSegmentRef[1]/segRef[1]', 'int') as [flightIndex],	-- 여정번호

			t2.col.value('./propFlightGrDetail[1]/flightProposal[1]/ref[1]', 'int') as [segRef],
			t2.col.value('./propFlightGrDetail[1]/flightProposal[unitQualifier="EFT"][1]/ref[1]', 'varchar(4)') as [flyingTime],
			t2.col.value('./propFlightGrDetail[1]/flightProposal[unitQualifier="MCX"][1]/ref[1]', 'varchar(2)') as [company],

			t2.col.value('./flightDetails[1]/flightInformation[1]/productDateTime[1]/dateOfDeparture[1]', 'varchar(6)') as [dateOfDeparture],
			t2.col.value('./flightDetails[1]/flightInformation[1]/productDateTime[1]/timeOfDeparture[1]', 'varchar(4)') as [timeOfDeparture],
			t2.col.value('./flightDetails[1]/flightInformation[1]/location[1]/locationId[1]', 'varchar(3)') as [airportOfDeparture],
			t2.col.value('./flightDetails[last()]/flightInformation[1]/productDateTime[1]/dateOfArrival[1]', 'varchar(6)') as [dateOfArrival],
			t2.col.value('./flightDetails[last()]/flightInformation[1]/productDateTime[1]/timeOfArrival[1]', 'varchar(4)') as [timeOfArrival],
			t2.col.value('./flightDetails[last()]/flightInformation[1]/location[last()]/locationId[1]', 'varchar(3)') as [airportOfArrival],
			t2.col.value('count(./flightDetails)', 'int') as [byWayCount],

			t3.col.value('./flightInformation[1]/productDateTime[1]/dateOfDeparture[1]', 'varchar(6)') as [segDateOfDeparture],
			t3.col.value('./flightInformation[1]/productDateTime[1]/timeOfDeparture[1]', 'varchar(4)') as [segTimeOfDeparture],
			t3.col.value('./flightInformation[1]/productDateTime[1]/dateOfArrival[1]', 'varchar(6)') as [segDateOfArrival],
			t3.col.value('./flightInformation[1]/productDateTime[1]/timeOfArrival[1]', 'varchar(4)') as [segTimeOfArrival],
			t3.col.value('./flightInformation[1]/location[1]/locationId[1]', 'varchar(3)') as [segAirportOfDeparture],
			t3.col.value('./flightInformation[1]/location[2]/locationId[1]', 'varchar(3)') as [segAirportOfArrival],
			t3.col.value('./flightInformation[1]/companyId[1]/marketingCarrier[1]', 'varchar(2)') as [marketingCarrier],
			t3.col.value('./flightInformation[1]/companyId[1]/operatingCarrier[1]', 'varchar(2)') as [operatingCarrier],
			t3.col.value('./flightInformation[1]/flightOrtrainNumber[1]', 'varchar(5)') as [flightOrtrainNumber],
			t3.col.value('./flightInformation[1]/productDetail[1]/equipmentType[1]', 'varchar(5)') as [fequipmentType]

		from @Xml.nodes('/Fare_MasterPricerTravelBoardSearchReply/flightIndex') AS t1(col)
		cross apply t1.col.nodes('./groupOfFlights') as t2(col)
		cross apply t2.col.nodes('./flightDetails') as t3(col)
	)
	select z.*, a.KOR_NAME as [airportNameOfDeparture], b.KOR_NAME as [cityNameOfDeparture]
		, c.KOR_NAME as [airportNameOfArrival], d.KOR_NAME as [cityNameOfArrival]
--**		, e.KOR_NAME as [operatingCarrierName]
	from groupOfFlights z
	inner join PUB_AIRPORT a with(nolock) on z.airportOfDeparture = a.AIRPORT_CODE
	inner join PUB_CITY b with(nolock) on a.CITY_CODE = b.CITY_CODE
	inner join PUB_AIRPORT c with(nolock) on z.airportOfArrival = c.AIRPORT_CODE
	inner join PUB_CITY d with(nolock) on c.CITY_CODE = d.CITY_CODE
--**	left join PUB_AIRLINE e with(nolock) on z.operatingCarrier = e.AIRLINE_CODE
	-- Non-Air 여정 제외 (17.02.16 토파스 메일 참조)
	where z.fequipmentType is null or  z.fequipmentType not in ('BUS', 'TGV', 'THL', 'THS', 'TRS', 'MTL', 'THT', 'TRN', 'TSL', 'ICE');


	-- slice & dice 테이블 
	select 
	number, referenceType , refNumber , flightIndex , 
	ROW_NUMBER() OVER ( PARTITION BY number ,refNumber , flightIndex ORDER BY number , refNumber , flightIndex  ) AS rowNum ,
	availCnxType
	from (
		select
			t1.col.value('./itemNumber[1]/itemNumberId[1]/number[1]', 'int') as [number]	-- 운임번호
			,t2.col.value('./specificRecItem[1]/referenceType[1]', 'varchar(2)') as [referenceType]
			,t2.col.value('./specificRecItem[1]/refNumber[1]', 'int') as [refNumber] 
			,t3.col.value('./requestedSegmentInfo[1]/segRef[1]','int') as [flightIndex]
			,t4.col.value('./fareCnxInfo[1]/contextDetails[1]/availabilityCnxType[1]' , 'varchar(2)') as [availCnxType] 

		from @xml.nodes('/Fare_MasterPricerTravelBoardSearchReply/recommendation') AS t1(col)	-- 운임
		cross apply t1.col.nodes('./specificRecDetails[specificRecItem/referenceType="A"]') as t2(col)
		cross apply t2.col.nodes('./specificProductDetails[1]/fareContextDetails') as t3(col) 	-- 세그  
		cross apply t3.col.nodes('./cnxContextDetails') as t4(col)  	-- 세그  
	) specific ;

	-- 무료 수화물 테이블 
	select * from 
	(
		select
			t2.col.value('./itemNumberInfo[1]/itemNumber[1]/number[1]', 'int') as [bagNumber]	-- 수화물 
			,t3.col.value('./refInfo[1]/referencingDetail[refQualifier="F"][1]/refQualifier[1]', 'varchar(2)') as [refQualifier]	-- 수화물 참조번호  
			,t3.col.value('./refInfo[1]/referencingDetail[refQualifier="F"][1]/refNumber[1]', 'int') as [freeRefNumber]	-- 수화물 참조번호  
			,t3.col.value('./paxRefInfo[1]/travellerDetails[1]/referenceNumber[1]', 'int') as [paxRefNum]	-- 탑승자 참조번호 
			,t4.col.value('./numberOfItemsDetails[referenceQualifier="RS"][1]/refNum[1]', 'int') as [flightIndex]	--  여정번호 
			,t5.col.value('./refOfLeg[1]', 'int') as [refSeg]	--  
			--,t5.col.value('./lastItemsDetails[refOfLeg="2"][1]/refOfLeg[1]', 'int') as [refSeg2]	--  
			--,t5.col.value('./lastItemsDetails[refOfLeg="3"][1]/refOfLeg[1]', 'int') as [refSeg3]	--  
		from @xml.nodes('/Fare_MasterPricerTravelBoardSearchReply/serviceFeesGrp') AS t1(col)	-- 운임
		cross apply t1.col.nodes('./serviceCoverageInfoGrp') as t2(col)
		cross apply t2.col.nodes('./serviceCovInfoGrp') as t3(col) 	-- 세그  
		cross apply t3.col.nodes('./coveragePerFlightsInfo') as t4(col) 	-- 세그  
		cross apply t4.col.nodes('./lastItemsDetails') as t5(col) 	-- 세그  
	) as bagref 
		inner join 
	(
		select t2.col.value('./itemNumberInfo[1]/itemNumberDetails[1]/number[1]', 'int') as [freeBagNumber]	-- 무료수화물번호
			 ,t2.col.value('./freeBagAllownceInfo[1]/baggageDetails[1]/freeAllowance[1]', 'varchar(2)') as [freeBagQty]	--  
			 ,t2.col.value('./freeBagAllownceInfo[1]/baggageDetails[1]/quantityCode[1]', 'varchar(2)') as [freeBagType]	-- 무료수화물번호
			 ,t2.col.value('./freeBagAllownceInfo[1]/baggageDetails[1]/unitQualifier[1]', 'varchar(2)') as [freeBagUnit]	-- 무료수화물번호
		from @xml.nodes('/Fare_MasterPricerTravelBoardSearchReply/serviceFeesGrp') AS t1(col)	-- 운임
		cross apply t1.col.nodes('./freeBagAllowanceGrp') as t2(col)
	) as baginfo 
		on bagref.freeRefNumber  = baginfo.freeBagNumber 
	
	-- 수수료
	select @SERVICE_FEE = '0'

	--with list as
	--(
	--	select
	--		t4.col.value('./locationId[1]', 'varchar(3)') as [locationId]
	--	from @Xml.nodes('/Fare_MasterPricerTravelBoardSearchReply/flightIndex') AS t1(col)
	--	cross apply t1.col.nodes('./groupOfFlights') as t2(col)
	--	cross apply t2.col.nodes('./flightDetails[last()]') as t3(col)
	--	cross apply t3.col.nodes('./flightInformation[1]/location[last()]') as t4(col)
	--)
	--select @SERVICE_FEE = max(a.PUB_VALUE)
	--from (
	--	select e.PUB_VALUE
	--	from (
	--		select locationId
	--		from list
	--		group by locationId
	--	) a
	--	inner join PUB_AIRPORT b with(nolock) on a.locationId = b.AIRPORT_CODE
	--	inner join PUB_CITY c with(nolock) on b.city_code = c.CITY_CODE
	--	inner join PUB_NATION d with(nolock) on c.NATION_CODE = d.NATION_CODE
	--	inner join COD_PUBLIC e with(nolock) on d.REGION_CODE = e.PUB_CODE
	--	where e.PUB_TYPE = 'AIR.SERVICE.CHARGE'
	--	union all
	--	select a.PUB_VALUE
	--	from COD_PUBLIC a with(nolock)
	--	where a.PUB_TYPE = 'AIR.SERVICE.CHARGE' and a.PUB_CODE = '999'
	--) a


	/*
	select
		t1.col.value('./requestedSegmentRef[1]/segRef[1]', 'int') as [segRef],	-- 여정번호
		t2.col.value('./propFlightGrDetail[1]/flightProposal[1]/ref[1]', 'int') as [ref],
		t2.col.value('./propFlightGrDetail[1]/flightProposal[unitQualifier="EFT"][1]/ref[1]', 'varchar(4)') as [flyingTime],
		t2.col.value('./propFlightGrDetail[1]/flightProposal[unitQualifier="MCX"][1]/ref[1]', 'varchar(2)') as [company],

		t2.col.value('./flightDetails[1]/flightInformation[1]/productDateTime[1]/dateOfDeparture[1]', 'varchar(6)') as [dateOfDeparture],
		t2.col.value('./flightDetails[1]/flightInformation[1]/productDateTime[1]/timeOfDeparture[1]', 'varchar(4)') as [timeOfDeparture],
		t2.col.value('./flightDetails[last()]/flightInformation[1]/productDateTime[1]/dateOfArrival[1]', 'varchar(6)') as [dateOfArrival],
		t2.col.value('./flightDetails[last()]/flightInformation[1]/productDateTime[1]/timeOfArrival[1]', 'varchar(4)') as [timeOfArrival],

		t3.col.value('./flightInformation[1]/productDateTime[1]/dateOfDeparture[1]', 'varchar(6)') as [SegdateOfDeparture],
		t3.col.value('./flightInformation[1]/productDateTime[1]/timeOfDeparture[1]', 'varchar(4)') as [SegtimeOfDeparture],
		t3.col.value('./flightInformation[1]/productDateTime[1]/dateOfArrival[1]', 'varchar(6)') as [SegdateOfArrival],
		t3.col.value('./flightInformation[1]/productDateTime[1]/timeOfArrival[1]', 'varchar(4)') as [SegtimeOfArrival],
		t3.col.value('./flightInformation[1]/location[1]/locationId[1]', 'varchar(3)') as [companyOfDeparture],
		t3.col.value('./flightInformation[1]/location[2]/locationId[1]', 'varchar(3)') as [companyOfArrival],
		t3.col.value('./flightInformation[1]/companyId[1]/marketingCarrier[1]', 'varchar(2)') as [marketingCarrier],
		t3.col.value('./flightInformation[1]/companyId[1]/operatingCarrier[1]', 'varchar(2)') as [operatingCarrier],
		t3.col.value('./flightInformation[1]/flightOrtrainNumber[1]', 'varchar(5)') as [flightOrtrainNumber],
		t3.col.value('./flightInformation[1]/productDetail[1]/equipmentType[1]', 'varchar(5)') as [fequipmentType]

	from @Xml.nodes('/Fare_MasterPricerTravelBoardSearchReply/flightIndex') AS t1(col)
	cross apply t1.col.nodes('./groupOfFlights') as t2(col)
	cross apply t2.col.nodes('./flightDetails') as t3(col)
	*/

	--select
	--	t1.col.value('./itemNumber[1]/itemNumberId[1]/number[1]', 'int') as [number],	-- 운임번호
	----	t3.col.value('./refNumber[1]', 'int') as [aa]
	--	t2.col.value('./referencingDetail[1]/refNumber[1]', 'int') as [refNumber],
	--	t2.col.value('./referencingDetail[2]/refNumber[1]', 'int') as [refNumber],
	--	t2.col.value('./referencingDetail[3]/refNumber[1]', 'int') as [refNumber]

	--from @Xml.nodes('/Fare_MasterPricerTravelBoardSearchReply/recommendation') AS t1(col)
	--cross apply t1.col.nodes('./segmentFlightRef') as t2(col)
	----cross apply t2.col.nodes('./referencingDetail') as t3(col)
	----inner join @Xml.nodes('/Fare_MasterPricerTravelBoardSearchReply/flightIndex') AS t2(col)
END




GO
