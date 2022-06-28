USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_PRO_AIRLINE_EXC_QCHARGE_INSERT
■ DESCRIPTION				: 항공사 예외 지역별 유류할증료 일괄 등록
■ INPUT PARAMETER			: 
	@XML NVARCHAR(MAX)		: AirlineExcQcharegRQ 클래스의 SerializeXml 문자열
■ OUTPUT PARAMETER			: 
■ EXEC						: 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-01-22		김성호			최초생성
   2014-06-17		박형만			QchargePrice -> Adult,Child,Infant 로 세분화
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_PRO_AIRLINE_EXC_QCHARGE_INSERT]
(
	@AIRLINE_CODE	CHAR(2),
	@START_YEAR		INT,
	@XML			NVARCHAR(MAX)
) 
AS 
BEGIN

	DECLARE @DOCHANDLE INT, @EXC_SEQ INT

	SELECT @EXC_SEQ = ISNULL((SELECT MAX(EXC_SEQ) FROM AIRLINE_EXC_QCHARGE A WITH(NOLOCK) WHERE A.AIRLINE_CODE = @AIRLINE_CODE AND A.START_YEAR = @START_YEAR), 0)


	EXEC SP_XML_PREPAREDOCUMENT @DOCHANDLE OUTPUT, @XML;

	INSERT INTO AIRLINE_EXC_QCHARGE (AIRLINE_CODE, START_YEAR, EXC_SEQ, 
		NATION_CODES, AIRPORT_CODES, START_DATE, END_DATE, 
		ADT_QCHARGE , CHD_QCHARGE ,INF_QCHARGE  , NEW_CODE, NEW_DATE)
	SELECT A.AIRLINE_CODE, A.START_YEAR, (ROW_NUMBER() OVER (ORDER BY A.AIRLINE_CODE) + @EXC_SEQ),
		A.NATION_CODES, A.AIRPORT_CODES, A.START_DATE, A.END_DATE, 
		A.ADT_QCHARGE, A.CHD_QCHARGE, A.INF_QCHARGE, A.NEW_CODE, GETDATE()
	FROM OPENXML(@DOCHANDLE, N'/ArrayOfAirlineExcQChargeRQ/AirlineExcQChargeRQ', 0)
	WITH
	(
		AIRLINE_CODE	CHAR(2)			'./AirlineCode',
		START_YEAR		INT				'./StartYear',
		NATION_CODES	VARCHAR(200)	'./NationCodes',
		AIRPORT_CODES	VARCHAR(200)	'./AirportCodes',
		START_DATE		DATETIME		'./StartDate',
		END_DATE		DATETIME		'./EndDate',
		ADT_QCHARGE		INT			'./AdultQCharge',
		CHD_QCHARGE		INT			'./ChildQCharge',
		INF_QCHARGE		INT			'./InfantQCharge',
		NEW_CODE		CHAR(7)			'./NewCode'
	) A

	EXEC SP_XML_REMOVEDOCUMENT @DOCHANDLE

END 
GO
