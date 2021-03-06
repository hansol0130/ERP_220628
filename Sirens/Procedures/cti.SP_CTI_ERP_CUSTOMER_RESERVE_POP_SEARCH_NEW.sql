USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_ERP_CUSTOMER_RESERVE_POP_SEARCH_NEW
■ DESCRIPTION				: ERP 고객정보 예약현황 팝업 검색 NEW 
■ INPUT PARAMETER			: 
	@CUS_NO					: 고객ID
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec cti.SP_CTI_ERP_CUSTOMER_RESERVE_POP_SEARCH_NEW @CUS_NAME = '박형만', @CUS_TEL = '01091852481'
	exec cti.SP_CTI_ERP_CUSTOMER_RESERVE_POP_SEARCH_NEW @CUS_NAME = '', @CUS_TEL = '01091852481'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-10-18		곽병삼			최초생성
   2014-11-07		김성호			고객검색 예약 수와 출발일자 조건값 맞춤
   2014-11-15		김성호			고객의 예약 검색 조건 변경으로 수정
   2014-12-17		곽병삼			예약현황 1년이내 조회조건 제외.
   2017-11-28		박형만			고객번호-> 예약,출발자 정보 검색으로 변경 (NEW)
   2018-05-09		박형만			최근1년출발~미출발 OR 최근3개월 예약 으로 조건 수정 
   2018-11-12		이명훈			상품코드 검색시 Where 조건이 이상하여 PRO_CODE 에러
   2019-01-25		박형만			예약쪽 일반전화 ETC_TEL 성능상의 문제로 01X 로 시작하지 않을때만 추가 
   2019-03-20		김남훈			이름 Like 검색 의미없음으로 제거
================================================================================================================*/ 

CREATE PROCEDURE [cti].[SP_CTI_ERP_CUSTOMER_RESERVE_POP_SEARCH_NEW]
--DECLARE
	@CUS_ID		VARCHAR(20) = null ,
	@CUS_NAME	VARCHAR(20) = null ,
	@CUS_BIRTH	VARCHAR(10) = null ,
	@GENDER		VARCHAR(1) = null ,
	@RES_CODE	VARCHAR(20) = null ,
	@CUS_TEL	VARCHAR(20) = null ,
	@CUS_EMAIL	VARCHAR(40) = null  
AS

SET NOCOUNT ON;

--declare @CUS_ID		VARCHAR(20) = null ,
--	@CUS_NAME	VARCHAR(20) = null ,
--	@CUS_BIRTH	VARCHAR(10) = null ,
--	@GENDER		VARCHAR(1) = null ,
--	@RES_CODE	VARCHAR(20) = null ,
--	@CUS_TEL	VARCHAR(20) = null ,
--	@CUS_EMAIL	VARCHAR(40) = null  
--SET @CUS_ID = ''
--SET @CUS_TEL = '01091852481'
--SET @CUS_NAME = ''
 
DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000), @WHERE NVARCHAR(1000),
@WHERE_MAST NVARCHAR(600) , @WHERE_CUST NVARCHAR(600) 

DECLARE @CUS_TEL1 VARCHAR(4), @CUS_TEL2 VARCHAR(4), @CUS_TEL3 VARCHAR(20)

SELECT @WHERE = '', @CUS_TEL = REPLACE(@CUS_TEL, '-', '');
SELECT @WHERE_MAST = '', @WHERE_CUST = '' -- 예약테이블, 출발테이블 전용 

	--예약코드 우선 
	IF( ISNULL(@RES_CODE,'') <> '')
	BEGIN
		-- 예약코드가 12자리를 넘기면 행사코드로 인지해서 동작
		IF LEN(@RES_CODE) > 12
		BEGIN
			SET @WHERE = @WHERE + N' AND A.PRO_CODE = @RES_CODE '
		END
		ELSE IF ISNULL(@RES_CODE, '') <> ''
		BEGIN
			SET @WHERE = @WHERE + N' AND A.RES_CODE = @RES_CODE '
		END
	END 
	ELSE 
	BEGIN
		-- 전화번호 처리
		IF ISNULL(@CUS_TEL, '') <> ''
		BEGIN
			IF LEN(@CUS_TEL) = 7 OR LEN(@CUS_TEL) = 8
			BEGIN
				SELECT @CUS_TEL1 = '', @CUS_TEL2 = SUBSTRING(@CUS_TEL, 1, (LEN(@CUS_TEL) - 4)), @CUS_TEL3 = SUBSTRING(@CUS_TEL, (LEN(@CUS_TEL) - 3), 4)
			END
			ELSE IF LEN(@CUS_TEL) = 9
			BEGIN
				SELECT @CUS_TEL1 = SUBSTRING(@CUS_TEL, 1, 2), @CUS_TEL2 = SUBSTRING(@CUS_TEL, 3, 3), @CUS_TEL3 = SUBSTRING(@CUS_TEL, 6, 4)
			END
			ELSE IF LEN(@CUS_TEL) = 10 AND SUBSTRING(@CUS_TEL, 1, 2) = '02'
			BEGIN
				SELECT @CUS_TEL1 = SUBSTRING(@CUS_TEL, 1, 2), @CUS_TEL2 = SUBSTRING(@CUS_TEL, 3, 4), @CUS_TEL3 = SUBSTRING(@CUS_TEL, 7, 4)
			END
			ELSE IF LEN(@CUS_TEL) = 10 AND SUBSTRING(@CUS_TEL, 1, 2) <> '02'
			BEGIN
				SELECT @CUS_TEL1 = SUBSTRING(@CUS_TEL, 1, 3), @CUS_TEL2 = SUBSTRING(@CUS_TEL, 4, 3), @CUS_TEL3 = SUBSTRING(@CUS_TEL, 7, 4)
			END
			ELSE IF LEN(@CUS_TEL) = 11
			BEGIN
				SELECT @CUS_TEL1 = SUBSTRING(@CUS_TEL, 1, 3), @CUS_TEL2 = SUBSTRING(@CUS_TEL, 4, 4), @CUS_TEL3 = SUBSTRING(@CUS_TEL, 8, 4)
			END
			ELSE
			BEGIN
				SELECT @CUS_TEL3 = @CUS_TEL
			END 

			IF LEN(@CUS_TEL) = 4
			BEGIN
				--2019-01-25 성능 문제로 삭제함
				--SET @WHERE_MAST = @WHERE_MAST + N' AND (A.NOR_TEL3 = @CUS_TEL3 OR A.ETC_TEL3 = @CUS_TEL3) '
				SET @WHERE_MAST = @WHERE_MAST + N' AND (A.NOR_TEL3 = @CUS_TEL3) '
				SET @WHERE_CUST = @WHERE_CUST + N' AND (A.NOR_TEL3 = @CUS_TEL3) '

			END
			ELSE IF LEN(@CUS_TEL) > 4
			BEGIN

				--2019-01-25 성능 문제로 수정 
				-- 01X 로 시작하지 않을때만 ETC_TEL 넣기 
				IF SUBSTRING(@CUS_TEL1,1,2) <> '01' 
				BEGIN
					SET @WHERE_MAST = @WHERE_MAST + N' AND ((A.NOR_TEL3 = @CUS_TEL3 AND A.NOR_TEL2 = @CUS_TEL2 AND ISNULL(A.NOR_TEL1, '''') = @CUS_TEL1) 
					OR (A.ETC_TEL3 = @CUS_TEL3 AND A.ETC_TEL2 = @CUS_TEL2 AND ISNULL(A.ETC_TEL1, '''') = @CUS_TEL1)) '
				END 
				ELSE 
				BEGIN
					SET @WHERE_MAST = @WHERE_MAST + N' AND ((A.NOR_TEL3 = @CUS_TEL3 AND A.NOR_TEL2 = @CUS_TEL2 AND ISNULL(A.NOR_TEL1, '''') = @CUS_TEL1)) '
				END 
				
				SET @WHERE_CUST = @WHERE_CUST + N' AND ((A.NOR_TEL3 = @CUS_TEL3 AND A.NOR_TEL2 = @CUS_TEL2 AND ISNULL(A.NOR_TEL1, '''') = @CUS_TEL1)) '
			END
		END


		IF ISNULL(@CUS_ID, '') <> ''
		BEGIN
			SET @WHERE = @WHERE + N' AND A.CUS_NO IN (
SELECT CUS_NO FROM Diablo.DBO.CUS_MEMBER WITH(NOLOCK) WHERE CUS_ID = @CUS_ID AND CUS_STATE =''Y''
UNION ALL SELECT CUS_NO FROM Diablo.DBO.CUS_MEMBER_SLEEP WITH(NOLOCK) WHERE CUS_ID = @CUS_ID AND CUS_STATE =''Y''
)'
		END

		IF ISNULL(@CUS_NAME, '') <> ''
		BEGIN 
			SET @WHERE_MAST = @WHERE_MAST + N' AND A.RES_NAME = @CUS_NAME'
			SET @WHERE_CUST = @WHERE_CUST + N' AND A.CUS_NAME = @CUS_NAME'
		END

		IF ISNULL(@CUS_EMAIL, '') <> ''
		BEGIN
			SET @WHERE_MAST = @WHERE_MAST + N' AND A.RES_EMAIL	LIKE @CUS_EMAIL + ''%'''
			SET @WHERE_CUST = @WHERE_CUST + N' AND A.EMAIL		LIKE @CUS_EMAIL + ''%'''
		END

		IF ISNULL(@CUS_BIRTH, '') <> '' AND ISDATE(@CUS_BIRTH) > 0
		BEGIN
			SET @WHERE = @WHERE + N' AND A.BIRTH_DATE = CONVERT(DATETIME, @CUS_BIRTH) '
		END

		IF ISNULL(@GENDER, '') <> ''
		BEGIN
			SET @WHERE = @WHERE + N' AND A.GENDER = @GENDER '
		END
		
	END 
	SET @SQLSTRING = + N'
SELECT * FROM ( 
SELECT ''M'' AS [CUS_TYPE], A.CUS_NO,
	A.RES_CODE,
	A.RES_STATE,
	A.RES_TYPE,
	A.RES_NAME,
	A.NOR_TEL1 + ''-'' + A.NOR_TEL2 + ''-'' + A.NOR_TEL3 AS RES_TEL,
	CONVERT(VARCHAR(10),A.DEP_DATE,120) AS DEP_DT,
	''('' + LEFT(DATENAME(dw,A.DEP_DATE),1) + '')'' AS DEP_WEEKDAY,
	SUBSTRING(CONVERT(VARCHAR(16),A.DEP_DATE,120),12,5) AS DEP_TM,
	A.PRO_TYPE,
	A.PRO_CODE,
	A.PRO_NAME,
	A.NEW_CODE,
	(SELECT KOR_NAME FROM Diablo.DBO.EMP_MASTER WHERE EMP_CODE = A.NEW_CODE ) AS NEW_NAME
FROM Diablo.DBO.RES_MASTER_DAMO A WITH(NOLOCK)
WHERE A.RES_STATE <= 7  
AND (A.DEP_DATE > DATEADD(YY, -1,GETDATE()) -- 출발일:출발후1년~미출발 예약 
 OR A.NEW_DATE > DATEADD(MM, -3, GETDATE()) -- 예약일:최근3개월내 예약 
)  
'+ @WHERE  + '  
'+ @WHERE_MAST  + '
UNION ALL
SELECT ''C'' AS [CUS_TYPE],A.CUS_NO,
	B.RES_CODE,
	B.RES_STATE,
	B.RES_TYPE,
	A.CUS_NAME AS RES_NAME,
	A.NOR_TEL1 + ''-'' + A.NOR_TEL2 + ''-'' + A.NOR_TEL3 AS RES_TEL,
	CONVERT(VARCHAR(10),B.DEP_DATE,120) AS DEP_DT,
	''('' + LEFT(DATENAME(dw,B.DEP_DATE),1) + '')'' AS DEP_WEEKDAY,
	SUBSTRING(CONVERT(VARCHAR(16),B.DEP_DATE,120),12,5) AS DEP_TM,
	B.PRO_TYPE,
	B.PRO_CODE,
	B.PRO_NAME,
	B.NEW_CODE,
	(SELECT KOR_NAME FROM Diablo.DBO.EMP_MASTER WHERE EMP_CODE = B.NEW_CODE ) AS NEW_NAME
FROM Diablo.DBO.RES_CUSTOMER_damo A WITH(NOLOCK)
INNER JOIN Diablo.DBO.RES_MASTER_DAMO B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
WHERE B.RES_STATE <= 7 AND A.RES_STATE = 0 
AND (B.DEP_DATE > DATEADD(YY, -1,GETDATE()) -- 출발일:출발후1년~미출발 예약 
 OR B.NEW_DATE > DATEADD(MM, -3, GETDATE()) -- 예약일:최근3개월내 예약 
)  
'+ REPLACE(@WHERE,'A.','B.')  + '
'+ @WHERE_CUST  +'

--	AND A.RES_STATE <= 7 AND B.RES_STATE = 0 AND B.CUS_NO = @CUS_NO
) TBL 
ORDER BY DEP_DT DESC;
';

 

/* 예약건수 조회 1년이내 조건
	SELECT A.CUS_NO, A.RES_CODE, A.DEP_DATE
	FROM Diablo.DBO.RES_MASTER_DAMO A WITH(NOLOCK)
	WHERE A.DEP_DATE > DATEADD(YY, -1, GETDATE())
		AND A.RES_STATE <= 7 AND A.CUS_NO IN (SELECT CUS_NO FROM LIST)
	UNION
	SELECT B.CUS_NO, A.RES_CODE, A.DEP_DATE
	FROM Diablo.DBO.RES_MASTER_DAMO A WITH(NOLOCK)
	INNER JOIN Diablo.DBO.RES_CUSTOMER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
	WHERE A.DEP_DATE > DATEADD(YY, -1, GETDATE())
		AND A.RES_STATE <= 7 AND B.RES_STATE = 0 AND B.CUS_NO IN (SELECT CUS_NO FROM LIST)
*/
	SET @PARMDEFINITION = N'
		@CUS_ID		VARCHAR(20),
		@CUS_NAME	VARCHAR(20),
		@CUS_BIRTH	VARCHAR(10),
		@GENDER		VARCHAR(1),
		@RES_CODE	VARCHAR(20),
		@CUS_TEL1	VARCHAR(4),
		@CUS_TEL2	VARCHAR(4),
		@CUS_TEL3	VARCHAR(4),
		@CUS_EMAIL	VARCHAR(40)';

	--SELECT LEN(@SQLSTRING)

	--PRINT @SQLSTRING 
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@CUS_ID,
		@CUS_NAME,
		@CUS_BIRTH,
		@GENDER,
		@RES_CODE,
		@CUS_TEL1,
		@CUS_TEL2,
		@CUS_TEL3,
		@CUS_EMAIL;



SET NOCOUNT OFF
GO
