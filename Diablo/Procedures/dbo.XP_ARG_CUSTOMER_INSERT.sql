USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ARG_CUSTOMER_INSERT
■ DESCRIPTION				: 수배현황상세 리스트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	DECLARE @COUNT INT
	EXEC DBO.XP_ARG_MASTER_LIST_SELECT 1, 10, @COUNT OUTPUT, 'ProductCode=&Title=테스트&ArrangeStatus=&StartDate=&EndDate=&AgentCode=&NewCode', 0
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-22		이규식			최초생성
   2014-01-14		박형만			SOC_NUM1 -> BIRTH_DATE 로 변경
   2014-02-04		이동호			핸드폰,이메일 삭제  -> 여권번호, 여권만료일 추가 변경
   2014-03-24		김성호			재 생성
   2014-04-07		김성호			NEW_CODE 삭제
   2014-04-07		김성호			부모문서 작성자 정보 검색
   2014-04-10		정지용			생년월일 VARCHAR(10) 에 맞추어서 CONVERT / 여권번호, 여권만료일 추가
   2014-04-10		김성호			예약코드 없을 시 예외처리 작업
   2015-03-03		김성호		주민번호 삭제, 생년월일 추가
   2015-11-18		박형만		생년월일 01 29 1976 -> yyyy-MM-dd 형식으로 들어가도록 
================================================================================================================*/ 
CREATE  PROC [dbo].[XP_ARG_CUSTOMER_INSERT]
	@ARG_TYPE INT,	-- 1: 수배요청, 2: 수배확정, 3: 인보이스, 4: 인보이스 확정
	@ARG_STATUS INT,
	@RES_CODE VARCHAR(12),
	@XML XML
AS 
BEGIN

	DECLARE @EMP_CODE_LIST VARCHAR(100)
	SET @EMP_CODE_LIST = '';

	IF @ARG_TYPE = 1
	BEGIN
		DECLARE @CUS_SEQ_NO INT
		SELECT @CUS_SEQ_NO = ISNULL(MAX(CUS_SEQ_NO), 0) + 1 
		FROM ARG_CUSTOMER 
		WHERE ARG_CODE IN (
			SELECT TOP 1 t1.col.value('./ArrangeCode[1]', 'varchar(12)') as [ArrangeCode]
			FROM @xml.nodes('/ArrayOfArrangeCustomerRQ/ArrangeCustomerRQ') as t1(col)
		)

		IF ISNULL(@RES_CODE, '') <> ''
		BEGIN
			INSERT INTO ARG_CUSTOMER (
				ARG_CODE, CUS_SEQ_NO, RES_CODE, SEQ_NO, ARG_STATUS, CUS_NAME, LAST_NAME, FIRST_NAME, AGE_TYPE, GENDER, 
				BIRTH_DATE, PASS_NUM, PASS_EXPIRE,
				EMAIL, CELLPHONE, ROOMING, ETC_REMAKR, NEW_CODE, NEW_DATE)
			SELECT
				 A.ArrangeCode, (A.CustomerNo + @CUS_SEQ_NO), A.reserveCode, A.reserveSeqNo, @ARG_STATUS, B.CUS_NAME, B.LAST_NAME, B.FIRST_NAME, B.AGE_TYPE, B.GENDER,
				 --CONVERT(VARCHAR(10), DBO.FN_CUS_GET_BIRTH_DATE(B.SOC_NUM1, damo.dbo.dec_varchar('DIABLO', 'dbo.RES_CUSTOMER', 'SOC_NUM2', SEC_SOC_NUM2)), 126),
				 CASE WHEN B.BIRTH_DATE IS NOT NULL THEN CONVERT(VARCHAR(10), B.BIRTH_DATE,121)  ELSE NULL END AS BIRTH_DATE, -- <- 출발자 정보에서 가져옴 
				 A.passportNum, A.passportExpire,
				 B.EMAIL, (B.NOR_TEL1 + '-' + B.NOR_TEL2 + '-' + B.NOR_TEL3), A.Rooming, A.Remark, A.NewCode, GETDATE()
			FROM (
				SELECT
					ROW_NUMBER() OVER(ORDER BY t1.col.value('./ReserveSeqNo[1]', 'int')) as [CustomerNo],
					t1.col.value('./ArrangeCode[1]', 'varchar(12)') as [ArrangeCode],
					t1.col.value('./ReserveCode[1]', 'varchar(20)') as [reserveCode],
					t1.col.value('./ReserveSeqNo[1]', 'int') as [reserveSeqNo],
					t1.col.value('./Rooming[1]', 'varchar(2)') as [Rooming],
					t1.col.value('./Remark[1]', 'nvarchar(2000)') as [Remark],
					t1.col.value('./NewCode[1]', 'char(7)') as [NewCode],
					t1.col.value('./PassportNum[1]', 'varchar(20)') as [passportNum],
					t1.col.value('./PassportExpire[1]', 'datetime') as [passportExpire]
				FROM @xml.nodes('/ArrayOfArrangeCustomerRQ/ArrangeCustomerRQ') as t1(col)
			) A
			INNER JOIN RES_CUSTOMER_damo B WITH(NOLOCK) ON A.reserveCode = B.RES_CODE AND A.reserveSeqNo = B.SEQ_NO;
		END
		ELSE
		BEGIN
			INSERT INTO ARG_CUSTOMER (
				ARG_CODE, CUS_SEQ_NO, RES_CODE, SEQ_NO, ARG_STATUS, CUS_NAME, LAST_NAME, FIRST_NAME, 
				AGE_TYPE, 
				GENDER, BIRTH_DATE, PASS_NUM, PASS_EXPIRE, ROOMING, ETC_REMAKR, NEW_CODE, NEW_DATE)
			SELECT
				 A.ArrangeCode, (A.CustomerNo + @CUS_SEQ_NO), A.reserveCode, A.reserveSeqNo, @ARG_STATUS, A.customerName, A.lastName, A.firstName, 
				 (CASE A.ageType WHEN '성인' THEN 0 WHEN '아동' THEN 1 WHEN '유아' THEN 2 END),
				 A.gender, a.birthDate, A.passportNum, A.passportExpire, A.Rooming, A.Remark, A.NewCode, GETDATE()
			FROM (
				SELECT
					ROW_NUMBER() OVER(ORDER BY t1.col.value('./ReserveSeqNo[1]', 'int')) as [CustomerNo],
					t1.col.value('./ArrangeCode[1]', 'varchar(12)') as [ArrangeCode],
					t1.col.value('./ReserveCode[1]', 'varchar(20)') as [reserveCode],
					t1.col.value('./ReserveSeqNo[1]', 'int') as [reserveSeqNo],
					t1.col.value('./CustomerName[1]', 'varchar(20)') as [customerName],
					t1.col.value('./LastName[1]', 'varchar(20)') as [lastName],
					t1.col.value('./FirstName[1]', 'varchar(20)') as [firstName],
					t1.col.value('./AgeType[1]', 'varchar(10)') as [ageType],
					t1.col.value('./Gender[1]', 'char(1)') as [gender],
					t1.col.value('./BirthDate[1]', 'varchar(10)') as [birthDate],
					t1.col.value('./PassportNum[1]', 'varchar(20)') as [passportNum],
					t1.col.value('./PassportExpire[1]', 'datetime') as [passportExpire],
					t1.col.value('./Rooming[1]', 'varchar(2)') as [Rooming],
					t1.col.value('./Remark[1]', 'nvarchar(2000)') as [Remark],
					t1.col.value('./NewCode[1]', 'char(7)') as [NewCode]
				FROM @xml.nodes('/ArrayOfArrangeCustomerRQ/ArrangeCustomerRQ') as t1(col)
			) A;
		END

		INSERT INTO ARG_CONNECT (ARG_CODE, GRP_SEQ_NO, CUS_SEQ_NO)
		SELECT
			A.ArrangeCode, A.GroupSeqNo, (A.CustomerNo + @CUS_SEQ_NO)
		FROM (
			SELECT
				t1.col.value('./ArrangeCode[1]', 'varchar(12)') as [ArrangeCode],
				t1.col.value('./GroupSeqNo[1]', 'int') as [GroupSeqNo],
				ROW_NUMBER() OVER(ORDER BY t1.col.value('./ReserveSeqNo[1]', 'int')) as [CustomerNo]
			FROM @xml.nodes('/ArrayOfArrangeCustomerRQ/ArrangeCustomerRQ') as t1(col)
		) A;

	END
	ELSE
	BEGIN
		UPDATE A SET A.ARG_STATUS = @ARG_STATUS, A.EDT_CODE = B.NewCode, A.EDT_DATE = GETDATE()
		FROM ARG_CUSTOMER A
		INNER JOIN (
			SELECT
				t1.col.value('./ArrangeCode[1]', 'varchar(12)') as [ArrangeCode],
				t1.col.value('./CustomerSeqNo[1]', 'int') as [CustomerSeqNo],
				t1.col.value('./NewCode[1]', 'char(7)') as [NewCode]
			FROM @xml.nodes('/ArrayOfArrangeCustomerRQ/ArrangeCustomerRQ') as t1(col)
		) B ON A.ARG_CODE = B.ArrangeCode AND A.CUS_SEQ_NO = B.CustomerSeqNo;

		INSERT INTO ARG_CONNECT (ARG_CODE, GRP_SEQ_NO, CUS_SEQ_NO)
		SELECT
			t1.col.value('./ArrangeCode[1]', 'varchar(12)') as [ArrangeCode],
			t1.col.value('./GroupSeqNo[1]', 'int') as [GroupSeqNo],
			t1.col.value('./CustomerSeqNo[1]', 'int') as [CustomerSeqNo]
		FROM @xml.nodes('/ArrayOfArrangeCustomerRQ/ArrangeCustomerRQ') as t1(col);

		-- 부모문서 작성자 정보 검색
		SELECT @EMP_CODE_LIST = STUFF((
			SELECT
				(',' + D.EMP_CODE + '|' + D.TEAM_NAME) AS [text()]
			FROM (
				SELECT
					t1.col.value('./ArrangeCode[1]', 'varchar(12)') as [ArrangeCode],
					t1.col.value('./CustomerSeqNo[1]', 'int') as [CustomerSeqNo]
				FROM @xml.nodes('/ArrayOfArrangeCustomerRQ/ArrangeCustomerRQ') as t1(col)
			) A
			INNER JOIN ARG_CONNECT B ON A.ArrangeCode = B.ARG_CODE AND A.CustomerSeqNo = B.CUS_SEQ_NO
			INNER JOIN ARG_DETAIL C ON B.ARG_CODE = C.ARG_CODE AND B.GRP_SEQ_NO = C.GRP_SEQ_NO
			INNER JOIN VIEW_EMP_MASTER D ON C.NEW_CODE = D.EMP_CODE
			WHERE C.ARG_TYPE = (CASE WHEN @ARG_TYPE IN (2, 3) THEN 1 WHEN @ARG_TYPE IN (4) THEN 3 END)
			GROUP BY D.EMP_CODE, D.TEAM_NAME
			FOR XML PATH('')
		), 1, 1, '')
	END

	SELECT @EMP_CODE_LIST
END

/*
<ArrayOfArrangeCustomerRQ>
  <ArrangeCustomerRQ>
    <ArrangeSeqNo>1</ArrangeSeqNo>
    <GroupSeqNo>0</GroupSeqNo>
    <CustomerName>홍길동</CustomerName>
    <LastName>hong</LastName>
    <FirstName>gildong</FirstName>
    <AgeType>성인</AgeType>
    <BirthDate>1977-09-12</BirthDate>
    <ReserveSeqNo>5</ReserveSeqNo>
    <ReserveCode>RP00000</ReserveCode>
    <Remark>기타사항</Remark>
    <Email>nolran@verygoodtour.com</Email>
    <Cellphone>010-1111-2222</Cellphone>
    <PassportExpire/>
  </ArrangeCustomerRQ>
</ArrayOfArrangeCustomerRQ>
*/


/*
ALTER PROC [dbo].[XP_ARG_CUSTOMER_INSERT]
	@ARG_SEQ_NO INT,
	@GRP_SEQ_NO INT,
 	@CUS_NAME VARCHAR(20),
	@LAST_NAME VARCHAR(20),
	@FIRST_NAME VARCHAR(20),
	@AGE_TYPE INT,
	@GENDER CHAR(1),
	@BIRTH_DATE VARCHAR(10),
	@SEQ_NO INT,
	@RES_CODE VARCHAR(12),
	@ETC_REMARK NVARCHAR(1000),
	@NEW_CODE VARCHAR(7),
	@AGE VARCHAR(3),
	@PASS_EXPIRE DATETIME,
	@PASS_NUM VARCHAR(20)
AS 
BEGIN
	DECLARE @CUS_SEQ_NO INT

	SELECT @CUS_SEQ_NO = ISNULL(MAX(CUS_SEQ_NO), 0) + 1 FROM ARG_CUSTOMER WHERE ARG_SEQ_NO = @ARG_SEQ_NO AND GRP_SEQ_NO = @GRP_SEQ_NO

	-- 예약 코드가 없을 경우
	IF ISNULL(@RES_CODE, '') = ''
	BEGIN
		INSERT INTO ARG_CUSTOMER(
			ARG_SEQ_NO,
			GRP_SEQ_NO,
			CUS_SEQ_NO,
			CUS_NAME,
			LAST_NAME,
			FIRST_NAME,
			AGE_TYPE,
			GENDER,
			BIRTH_DATE,
			SEQ_NO,
			RES_CODE,
			ETC_REMAKR,
			NEW_CODE,
			PASS_EXPIRE,
			PASS_NUM
		) VALUES (
			@ARG_SEQ_NO,
			@GRP_SEQ_NO,
			@CUS_SEQ_NO,
			@CUS_NAME,
			@LAST_NAME,
			@FIRST_NAME,
			@AGE_TYPE,
			@GENDER,
			@BIRTH_DATE,
			@SEQ_NO,
			NULL,
			@ETC_REMARK,
			@NEW_CODE,
			@PASS_EXPIRE,
			@PASS_NUM
		)
	END
	-- 예약 코드가 있을 경우에는 출발자 정보를 가져와 정보를 채워준다.
	BEGIN
		INSERT INTO ARG_CUSTOMER(
			ARG_SEQ_NO,
			GRP_SEQ_NO,
			CUS_SEQ_NO,
			CUS_NAME,
			LAST_NAME,
			FIRST_NAME,
			AGE_TYPE,
			GENDER,
			BIRTH_DATE,
			SEQ_NO,
			RES_CODE,
			ETC_REMAKR,
			NEW_CODE,
			PASS_EXPIRE,
			PASS_NUM,
			ROOMING
		) 
		SELECT
			@ARG_SEQ_NO,
			@GRP_SEQ_NO,
			@CUS_SEQ_NO,
			CUS_NAME,
			LAST_NAME,
			FIRST_NAME,
			AGE_TYPE,
			GENDER,
			@BIRTH_DATE,
			@SEQ_NO,
			@RES_CODE,
			@ETC_REMARK,
			NEW_CODE,
			@PASS_EXPIRE,
			@PASS_NUM,
			ROOMING
		FROM RES_CUSTOMER WITH(NOLOCK) WHERE RES_CODE = @RES_CODE AND SEQ_NO = @SEQ_NO
		
	END
END 
*/


GO
