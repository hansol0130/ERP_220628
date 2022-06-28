USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_CALL_PRICE_MAIN
■ DESCRIPTION				: 전화상담 대비 수익율 전체 건수
■ INPUT PARAMETER			: 
	:SDATE				  : 시작일자
  :EDATE				  : 종료일자
  @teamCode					: 팀코드
  @PRICE					: 총비용
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_CALL_PRICE_MAIN '2015-01-01', '2015-01-20' , '549' , 2000000000


■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2015-02-06		박노민			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_CALL_PRICE_MAIN]
@SDATE varchar(10), 
@EDATE varchar(10),
@TEAMCODE varchar(3),
@PRICE	bigint
AS


BEGIN
--set @sDate = '2015-01-01';
--set @eDate = '2015-01-31';
--set @teamCode = '549';

declare @callTotal bigint;
declare @callCon bigint;
declare @callAB bigint;
declare @resCount bigint;
declare @agentCnt decimal(18,0);
declare @TotalBuy decimal(18,0);
declare @TotalPrice decimal(18,0);
declare @PriceRate bigint;



select @TotalBuy = 총판매금,@PriceRate = 수익률   from diablo.dbo.xn_set_get_team_profit(@SDATE,@EDATE,@TEAMCODE)


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
	set @PriceRate = (@TotalBuy - @TotalPrice) * 100 / iif(@TotalBuy=0,1,@TotalBuy);
end

--총통화건수
select @callTotal = sum(con_call + ab_call) ,@callCon = sum(con_call) , @callAB = sum(ab_call) 
 from sirens.cti.CTI_STAT_ARS where S_DATE between replace(@SDATE,'-','') and replace(@EDATE,'-','')
 and s_week not in (7,1)
and GROUP_NO = @TEAMCODE

-- 예약건수
select @resCount = sum(reserve_count)  from sirens.cti.CTI_STAT_WORKTIME where S_DATE between replace(@SDATE,'-','') and replace(@EDATE,'-','')
and TEAM_CODE = @TEAMCODE




select '전체' gubun, @callTotal call_Total, @callCon call_Con, @callAB call_AB, @callCon * 100 / iif(@calltotal=0,1,@calltotal) call_Rate, @calltotal / iif(@resCount=0,1,@resCount) Res_To_Call
, @TotalBuy / iif(@callTotal=0,1,@callTotal) Call_To_Price, @TotalBuy Total_Buy, @PriceRate Price_Rate ,@TotalPrice Total_Price, @TotalBuy - @TotalPrice Total_Ben
union all
select '1인', @callTotal / iif(@agentCnt=0,1,@agentCnt), @callCon / iif(@agentCnt=0,1,@agentCnt), @callAB /iif(@agentCnt=0,1,@agentCnt), @callCon * 100 / iif(@calltotal=0,1,@calltotal), @calltotal / iif(@resCount=0,1,@resCount)
, @TotalBuy / iif(@callTotal=0,1,@callTotal) / iif(@agentCnt=0,1,@agentCnt), @TotalBuy / iif(@agentCnt=0,1,@agentCnt), @PriceRate,@TotalPrice / iif(@agentCnt=0,1,@agentCnt), (@TotalBuy - @TotalPrice) /iif(@agentCnt=0,1,@agentCnt)

END
GO
