USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ Server					: 211.115.202.203
■ Database					: DIABLO
■ USP_Name					: SP_CUS_POINT_HISTORY_SEARCH
■ Description				: ERP 사용자 포인트 내역 조회
■ Input Parameter			:                  
		@CUS_NO				: 
		@CUS_NAME			: 
		@CUS_ID				: 
		@SOC_NUM1			: 
		@SOC_NUM2			: 
		@POINT_TYPE			: 
		@ACC_USE_TYPE		: 
		@PERIOD_TYP			: 
		@START_DATE			: 
		@END_DATE			:   
		@RES_CODE			: 
		@PRO_CODE			: 
		@TITLE				:
		@ORDER_TYPE			: 
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC SP_CUS_POINT_HISTORY_SEARCH @CUS_NO,@CUS_NAME,@CUS_ID,@SOC_NUM1,@SOC_NUM2,@POINT_TYPE ,@ACC_USE_TYPE,@PERIOD_TYPE,@START_DATE ,@END_DATE,@RES_CODE,@PRO_CODE,@TITLE,@ORDER_TYPE
							  EXEC SP_EXECUTESQL N'EXEC SP_CUS_POINT_HISTORY_SEARCH @CUS_NO,@CUS_NAME,@CUS_ID,@SOC_NUM1,@SOC_NUM2,@POINT_TYPE ,@ACC_USE_TYPE,@PERIOD_TYPE,@START_DATE,@END_DATE,@RES_CODE,@PRO_CODE,@TITLE,@ORDER_TYPE',N'@CUS_NO INT,@CUS_NAME NVARCHAR(4000),@CUS_
ID NVAR


CHAR(4000),@SOC_NUM1 NVARCHAR(4000),@SOC_NUM2 NVARCHAR(4000),@POINT_TYPE INT,@ACC_USE_TYPE INT,@PERIOD_TYPE NVARCHAR(1),@START_DATE NVARCHAR(10),@END_DATE NVARCHAR(10),@RES_CODE NVARCHAR(4000),@PRO_CODE NVARCHAR(4000),@TITLE VARCHAR(100),@ORDER_TYPE NVARC
HAR(1)',@CUS_NO=0,@C


US_NAME=N'',@CUS_ID=NULL,@SOC_NUM1=N'',@SOC_NUM2=N'',@POINT_TYPE=-1,@ACC_USE_TYPE=0,@PERIOD_TYPE=N'1',@START_DATE=N'2010-05-01',@END_DATE=N'2010-07-01',@RES_CODE=N'',@PRO_CODE=NULL,@ORDER_TYPE=N'1'
■ Author					: 박형만  
■ Date						: 2010-05-10
■ Memo						: 
------------------------------------------------------------------------------------------------------------------
■ Change History                   
------------------------------------------------------------------------------------------------------------------
   Date				Author			Description           
------------------------------------------------------------------------------------------------------------------
   2010-05-10		박형만			최초생성  
   2010-06-03		박형만			암호화 적용
   2010-06-11		박형만			CP.RES_CODE 로변경
   2010-07-01		박형만			관리자 명 추가 
   2010-09-13		임형민			포인트 사용 시 (-) 부분 수정
   2010-12-08		김성호			회원테이블 분리
   2011-01-20		박형만			여행자테이블로변경(CUS_CUSTOMER_DAMO)
   2011-09-08		박형만			관리자 사용취소 금액 - 로 표시 되던거 원상 복구. (이제부턴 데이터에 - 가 들어간다)
   2011-12-19		박형만			
   2013-07-23		김성호			cus_customer 테이블 삭제로 인해 해당 테이블 조인형태를 left join 으로 변경
   2015-03-03		김성호			주민번호 삭제, 생년월일 추가
   2017-07-20		김성호			포인트 부가세 면세로 인한 예약 수익부서 추가
   2018-08-30		김성호			행사, 예약코드 검색 시 다른 조건 무시하도록 수정
   2018-11-30		이명훈			포인트내역 내용검색 추가
   2019-01-08		박형만			포인트 구매실적129 회원가입378 로 수정
   2020-05-11		김성호			포인트 구매실적1259 회원가입378 로 수정 (이벤트 적립 = 5 추가)
   2021-03-31		김영민			CC.CXL_DATE(탈퇴일추가)
   2021-08-19		김성호			이벤트적립(acc_use_type=5 구매실적에서 회원가입으로 변경)
================================================================================================================*/ 
CREATE PROC [dbo].[SP_CUS_POINT_HISTORY_SEARCH]
(
	@CUS_NO		INT,
	@CUS_NAME	VARCHAR(20),
	@CUS_ID		VARCHAR(20),
	@BIRTH_DATE	DATETIME,
	@POINT_TYPE INT ,-- ''=전체,0=적립,1=사용,4=양도,2=소멸
	@ACC_USE_TYPE INT ,-- 사용타입
	@PERIOD_TYPE CHAR(1) ,--기간선택 1=날짜,2=유효기간
	@START_DATE VARCHAR(10),		
	@END_DATE  VARCHAR(10),	
	@RES_CODE RES_CODE,
	@PRO_CODE VARCHAR(20),
	@TITLE VARCHAR(100),
	@ORDER_TYPE CHAR(1) --정렬방식  1=날짜순,2=유효기간순,3=포인트순
)
AS


-----------------------
--go 

--DECLARE @CUS_NO		INT,
--	@CUS_NAME	VARCHAR(20),
--	@CUS_ID		VARCHAR(20),
--	@SOC_NUM1	VARCHAR(6),
--	@SOC_NUM2	VARCHAR(7),
	
--	@POINT_TYPE INT ,--  1=적립,2=사용     ''=전체,0=적립,1=사용,4=양도,2=소멸
--	@ACC_USE_TYPE INT ,-- 사용타입
	
--	@PERIOD_TYPE CHAR(1) ,--기간선택 1=날짜,2=유효기간
	
--	@START_DATE VARCHAR(10),		
--	@END_DATE  VARCHAR(10),	
	
--	@RES_CODE RES_CODE,
--	@PRO_CODE VARCHAR(20),
--	@ORDER_TYPE CHAR(1)--정렬방식  1=날짜순,2=유효기간순,3=포인트순
	
--SELECT  @CUS_NAME = '',  @PERIOD_TYPE = '1' ,  
--@START_DATE = '2011-12-01' ,@END_DATE = '2011-12-13', @ORDER_TYPE='1'
-------------------------
	
DECLARE @SQLSTRING NVARCHAR(4000)

DECLARE @WHERE NVARCHAR(1000) = ''
DECLARE @WHERE_1 NVARCHAR(1000) = '' --적립TB WHERE 
DECLARE @WHERE_2 NVARCHAR(1000) = '' --사용TB WHERE 
DECLARE @ORDER_BY NVARCHAR(1000) = '' --정렬문자열
DECLARE @PARMDEFINITION NVARCHAR(1000)

--예약코드 
IF ISNULL(@RES_CODE, '') <> ''
BEGIN
	SET @WHERE = @WHERE + ' AND RM.RES_CODE = @RES_CODE '
END
--행사코드
ELSE IF ISNULL(@PRO_CODE, '') <> ''
BEGIN
	SET @WHERE = @WHERE + ' AND RM.PRO_CODE = @PRO_CODE '
END
ELSE
BEGIN

	--고객이름
	IF ISNULL(@CUS_NAME, '') <> ''
		SET @WHERE = @WHERE + ' AND CC.CUS_NAME = @CUS_NAME'
	--고객아이디
	IF ISNULL(@CUS_ID, '') <> ''
		SET @WHERE = @WHERE + ' AND CC.CUS_ID = @CUS_ID'
	--고객고유번호
	IF ISNULL(@CUS_NO, -1) > 0
		SET @WHERE = @WHERE + ' AND CC.CUS_NO = @CUS_NO'
	-- 생년월일

	IF ISDATE(@BIRTH_DATE) > 0
		SET @WHERE = @WHERE + ' AND CC.BIRTH_DATE = @BIRTH_DATE'

	--내용검색
	IF ISNULL(@TITLE, '') <> ''
	BEGIN
		SET @TITLE = '%'+ @TITLE + '%'
		SET @WHERE = @WHERE + ' AND CP.TITLE LIKE @TITLE'
	END

	--포인트 적립/사용 구분
	IF ISNULL(@POINT_TYPE, -1) > -1
	BEGIN
		--적립/사용
		IF( @POINT_TYPE IN (1,2) )
		BEGIN
			SET @WHERE = @WHERE + ' AND CP.POINT_TYPE = @POINT_TYPE'   
		END 
	
		--양도
		IF( @POINT_TYPE = 3 ) 
		BEGIN
			SET @WHERE = @WHERE + ' AND (CP.POINT_TYPE = 1 AND CP.ACC_USE_TYPE =6 ' --양도
			SET @WHERE = @WHERE + ' OR CP.POINT_TYPE = 2 AND CP.ACC_USE_TYPE =4) ' --양도
		END 
	END 

	--포인트 상세 구분(적립,사용일때만)
	IF ISNULL(@ACC_USE_TYPE, -1) > 0 AND @POINT_TYPE IN (1,2)
	BEGIN
		SET @WHERE = @WHERE + ' AND CP.ACC_USE_TYPE = @ACC_USE_TYPE ' -- 
	END 

	IF ISNULL(@PERIOD_TYPE, '') <>'' 
	BEGIN
		--적립,사용날짜
		IF ISNULL(@START_DATE, '')<> ''  
			SET @WHERE = @WHERE + ' AND CP.NEW_DATE >= CONVERT(DATETIME,@START_DATE)'
		IF ISNULL(@END_DATE, '')<> ''  
			SET @WHERE = @WHERE + ' AND CP.NEW_DATE < DATEADD(DD,1,@END_DATE)'
			
		IF @PERIOD_TYPE = '2' --유효기간(적립테이블만)
		BEGIN
			IF ISNULL(@START_DATE, '')<> ''  
				SET @WHERE = @WHERE + ' AND CP.END_DATE >= CONVERT(DATETIME,@START_DATE)'
			IF ISNULL(@END_DATE, '')<> ''  
				SET @WHERE = @WHERE + ' AND CP.END_DATE < DATEADD(DD,1,@END_DATE)'
		END 
	END 

END

--정렬
IF ISNULL(@ORDER_TYPE,'') <>''
BEGIN
	SET @ORDER_BY = @ORDER_BY + (CASE WHEN @ORDER_TYPE = '1' THEN ' ORDER BY TBL.NEW_DATE DESC '  --날짜순
									WHEN @ORDER_TYPE ='2' THEN ' ORDER BY TBL.END_DATE DESC '
									WHEN @ORDER_TYPE ='3' THEN ' ORDER BY TBL.POINT_PRICE DESC ' 
									ELSE '' END )
END 

SET @SQLSTRING= 
'
SELECT TBL.* 
	, SUM(CASE WHEN CPH.ACC_TYPE IN (1,2,9) THEN ISNULL(CPH.POINT_PRICE, 0) ELSE 0 END) ACC_POINT_PRICE1
	, SUM(CASE WHEN CPH.ACC_TYPE IN (3,5,7,8) THEN ISNULL(CPH.POINT_PRICE, 0) ELSE 0 END) ACC_POINT_PRICE2
FROM (
	--적립내역
	SELECT 
		CP.POINT_TYPE , 
		CP.ACC_USE_TYPE , --사용/적립타입
		CC.CUS_NO, 
		CP.POINT_NO,
		CP.NEW_DATE ,--적립날짜
		CC.CUS_NAME ,--성명
		CC.CUS_ID ,--아이디
		CC.BIRTH_DATE,
		CC.GENDER,
		CP.RES_CODE, --예약코드
		RM.PRO_CODE,--행사코드
		RM.NEW_TEAM_NAME,--수익팀명
		CP.TITLE
		+ ISNULL((CASE WHEN CP.POINT_TYPE=1 AND ACC_USE_TYPE IN ( 2,6 ) THEN ''(''+EM.KOR_NAME+'')''  --관리자적립,이전적립
			 WHEN CP.POINT_TYPE=2 AND ACC_USE_TYPE IN ( 3,4 ) THEN ''(''+EM.KOR_NAME+'')''  --관리자차감,이전차감
			 ELSE '''' END ),'''')  AS TITLE , -- 내용
		CP.END_DATE , --유효기간
		CP.NEW_CODE , 
		CASE WHEN CP.POINT_TYPE = 2 AND ACC_USE_TYPE = 6 THEN CP.POINT_PRICE
			ELSE CP.POINT_PRICE END AS POINT_PRICE ,
		--환불 가능 포인트 있으면 조회 
		CASE WHEN CP.POINT_TYPE = 2 AND CP.ACC_USE_TYPE NOT IN(6) AND CP.IS_CXL = 0 THEN 
			1 ELSE 0 END AS RFD_POINT_PRICE , 
		
--		DBO.FN_RES_GET_CUS_POINT_HISTORY_ACC_PRICE(CP.POINT_NO , ''1,2,5,9'') AS ACC_POINT_PRICE1,
--		DBO.FN_RES_GET_CUS_POINT_HISTORY_ACC_PRICE(CP.POINT_NO , ''3,7,8'') AS ACC_POINT_PRICE2,
		CC.CXL_DATE
	
	FROM CUS_POINT  AS CP WITH(NOLOCK) 
		LEFT JOIN CUS_CUSTOMER_DAMO AS CC WITH(NOLOCK) ON CP.CUS_NO = CC.CUS_NO 
		LEFT JOIN RES_MASTER_damo AS RM WITH(NOLOCK) ON CP.RES_CODE = RM.RES_CODE
		--LEFT JOIN RES_CUSTOMER_damo AS RC WITH(NOLOCK) ON CP.RES_CODE = RC.RES_CODE AND CP.CUS_NO = RC.CUS_NO 
		LEFT JOIN EMP_MASTER_damo AS EM WITH(NOLOCK) ON CP.NEW_CODE  = EM.EMP_CODE 
	WHERE 1=1
		' + @WHERE + '
) TBL
LEFT JOIN CUS_POINT_HISTORY CPH WITH(NOLOCK) ON TBL.POINT_NO = CPH.POINT_NO
GROUP BY TBL.POINT_TYPE, TBL.ACC_USE_TYPE, TBL.CUS_NO, TBL.POINT_NO, TBL.NEW_DATE, TBL.CUS_NAME, TBL.CUS_ID, TBL.BIRTH_DATE, TBL.GENDER, TBL.RES_CODE, TBL.PRO_CODE, TBL.NEW_TEAM_NAME
	, TBL.TITLE, TBL.END_DATE, TBL.NEW_CODE, TBL.POINT_PRICE, TBL.RFD_POINT_PRICE, TBL.CXL_DATE
' + @ORDER_BY

SET @PARMDEFINITION = N'
	@CUS_NO			INT,
	@CUS_NAME		VARCHAR(20),
	@CUS_ID			VARCHAR(20),
	@BIRTH_DATE		DATETIME,
	@POINT_TYPE		INT,
	@ACC_USE_TYPE	INT,
	@PERIOD_TYPE	CHAR(1),
	@START_DATE		VARCHAR(10),
	@END_DATE		VARCHAR(10),
	@RES_CODE		RES_CODE,
	@PRO_CODE		VARCHAR(20),
	@TITLE			VARCHAR(100),
	@ORDER_TYPE		CHAR(1)';

EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
	@CUS_NO,
	@CUS_NAME,
	@CUS_ID,
	@BIRTH_DATE,
	@POINT_TYPE,
	@ACC_USE_TYPE,
	@PERIOD_TYPE,
	@START_DATE,
	@END_DATE,
	@RES_CODE,
	@PRO_CODE,
	@TITLE,
	@ORDER_TYPE;

--PRINT(@SQLSTRING)

GO
