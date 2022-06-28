USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_CALL_PRICE_LIST
■ DESCRIPTION				: 상담인원 별 수익율
■ INPUT PARAMETER			: 
  SDATE						: 시작일자
  EDATE						: 종료일자
  @teamCode					: 팀코드
  @PRICE					: 총비용
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_CALL_PRICE_LIST '2015-01-01', '2015-01-20' , '549', 2000000000


■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2015-02-06		박노민			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_CALL_PRICE_LIST]
@SDATE varchar(10), 
@EDATE varchar(10),
@TEAMCODE varchar(3),
@PRICE	bigint
AS


BEGIN

/*
set @sDate = '2015-01-01';
set @eDate = '2015-01-31';
set @teamCode = '612';
 set @teamCode = '551';
*/

declare @callTotal bigint;
declare @callCon bigint;
declare @callAB bigint;
declare @resCount bigint;
declare @agentCnt decimal(18,0);
declare @TotalBuy decimal(18,0);
declare @TotalPrice decimal(18,0);
declare @PriceRate bigint;
declare @TotalBen bigint;




select @TotalBuy = 총판매금,@PriceRate = 수익률, @TotalBen = 총판매금 -  총지출금  from diablo.dbo.xn_set_get_team_profit(@SDATE,@EDATE,@TEAMCODE)

-- 상담원수
select @agentCnt =  avg(cnt)  from (
select Z.s_date, count(Z.emp_code) cnt from (
select EMP_CODE, S_DATE  from sirens.cti.CTI_STAT_WORKTIME where S_DATE between replace(@SDATE,'-','') and replace(@EDATE,'-','')
and datepart(WEEKDAY,S_DATE) not in (1,7)
and TEAM_CODE = @TEAMCODE
group by EMP_CODE, S_DATE) Z
group by Z.s_date ) Y


set @TotalPrice = @PRICE * @agentCnt;

if @TotalPrice > 0
begin
	set @PriceRate = (@TotalBuy - @TotalPrice) * 100 / @TotalBuy;
end

--총통화건수
select @callTotal = sum(con_call + ab_call) ,@callCon = sum(con_call) , @callAB = sum(ab_call) 
 from sirens.cti.CTI_STAT_ARS where S_DATE between replace(@SDATE,'-','') and replace(@EDATE,'-','')
 and s_week not in (7,1)
and GROUP_NO = @TEAMCODE






declare @OneTotalBen bigint;
declare @OneTotalBuy bigint;
declare @OneTotalPrice bigint;
declare @OnecallCon bigint;
declare @OnecallAB bigint;

 select @OneTotalBen = (@TotalBen / @agentCnt) , @OneTotalBuy = @TotalBuy / @agentCnt, @OneTotalPrice = (@TotalPrice / @agentCnt), 
 @OnecallCon = (@callCon / @agentCnt  ), @OnecallAB = (@callAB / @agentCnt)

 Create Table #CallList1
 (
  agentCnt bigint,
  TotalBuy bigint,
  TotalPrice bigint,
  TotalBen bigint,
  TotalCon bigint,
  TotalAB bigint,
  MaxCall bigint,
  NOWGB	char(1)
 )

 declare @i int;


 
set @i = 1;

 while @agentCnt / 2 + @i < @agentCnt
 begin

  insert into #CallList1 
select @agentCnt - @i, @OneTotalBuy * (@agentCnt - @i), @OneTotalPrice * (@agentCnt - @i)  , @TotalBen - (@OneTotalBen *@i), 
@callCon - (@OnecallCon * @i) , @callAB + (@OnecallCon  * @i) , @callTotal ,'N'

set @i = @i +1
 end



 set @i = 0;
 declare @NowGB char(1) 
 set @NowGB = 'Y';

 while (@callCon + @OnecallCon * @i) < @callTotal
 begin


  insert into #CallList1 
		select @agentCnt + @i,  @OneTotalBuy * (@agentCnt + @i), @OneTotalPrice * (@agentCnt + @i)  , @TotalBen + (@OneTotalBen *@i), 
		@callCon + (@OnecallCon * @i) ,@callTotal- (@callCon + (@OnecallCon * @i)) , @callTotal, @NowGB

set @i = @i +1
set @NowGB = 'N';

 end


 -- 마지막 인원 증가시 상담완료 증가율
declare @Trate int;
set @Trate = (@callTotal- (@callCon + (@OnecallCon * (@i-1)))) * 100 / @OnecallCon
set @i = @i - 1


   insert into #CallList1 
select @agentCnt + (@i +1)
, @OneTotalBuy * (@agentCnt + @i ) + @OneTotalBuy * @Trate / 100
, @OneTotalPrice * (@agentCnt + @i +1 ) 
, @TotalBen + (@OneTotalBen *@i)+ @OneTotalBen * @Trate / 100
, @callTotal , 0  , @callTotal, 'N'



 --select @OneTotalBen  , @OneTotalBuy , @OneTotalPrice ,  @OnecallCon , @OnecallAB 

-- select @OneTotalBuy * 4

 select agentCnt agent_Cnt,totalbuy Total_Buy,TotalPrice Total_Price , totalbuy - totalPrice Total_Ben,
 totalcon Total_Con, totalab Total_AB,nowgb Now_Gb , (select max(totalbuy - totalPrice)  from #CallList1) Max_Ben
  from  #CallList1 order by AgentCnt



 drop table #CallList1 ;

 end
GO
