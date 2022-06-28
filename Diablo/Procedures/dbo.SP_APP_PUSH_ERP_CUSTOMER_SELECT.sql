USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_APP_PUSH_ERP_CUSTOMER_SELECT
- 기 능 : 푸시 메세지 발송 고객 조회
====================================================================================
	참고내용
====================================================================================
- 예제
 EXEC SP_APP_PUSH_ERP_CUSTOMER_SELECT 'F', '30,40,50', '1Y'
====================================================================================
	변경내역
====================================================================================
- 2018-11-26 김남훈 신규 작성 
===================================================================================*/
CREATE PROC [dbo].[SP_APP_PUSH_ERP_CUSTOMER_SELECT]
	@GENDERTYPE VARCHAR(10), -- 성별
	@AGETYPE VARCHAR(50), --나이 (멀티가능)
	@RESTYPE VARCHAR(10) --이용내역
AS 
SET NOCOUNT ON 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @WHERE VARCHAR(1000) = ''
	DECLARE @AGEWHERE VARCHAR(1000) = ''
	DECLARE @SQLSTRING NVARCHAR(4000) = ''
	
	--ERP

	--조건 코드 확인
	--1. OSTYPE 제외
	--2. GENDERTYPE
	IF (@GENDERTYPE = 'M')
	BEGIN
		SET @WHERE = @WHERE + ' AND A.GENDER = ''M'''
	END

	IF (@GENDERTYPE = 'F')
	BEGIN
		SET @WHERE = @WHERE + ' AND A.GENDER = ''F'''
	END
	--3. AGETYPE

	IF (CHARINDEX('20', @AGETYPE) > 0)
	BEGIN
		SET @AGEWHERE = @AGEWHERE + 'AND (A.BIRTH_DATE BETWEEN DATEADD(YY,-29,GETDATE()) AND DATEADD(YY,-20,GETDATE())'
	END
	IF (CHARINDEX('30', @AGETYPE) > 0)
	BEGIN
		IF(LEN(@AGEWHERE) > 0)
		BEGIN
			SET @AGEWHERE = @AGEWHERE + ' OR A.BIRTH_DATE BETWEEN DATEADD(YY,-39,GETDATE()) AND DATEADD(YY,-30,GETDATE())'
		END
		ELSE
		BEGIN
			SET @AGEWHERE = @AGEWHERE + ' AND (A.BIRTH_DATE BETWEEN DATEADD(YY,-39,GETDATE()) AND DATEADD(YY,-30,GETDATE())'
		END
	END
	IF (CHARINDEX('40', @AGETYPE) > 0)
	BEGIN
		IF(LEN(@AGEWHERE) > 0)
		BEGIN
			SET @AGEWHERE = @AGEWHERE + ' OR A.BIRTH_DATE BETWEEN DATEADD(YY,-49,GETDATE()) AND DATEADD(YY,-40,GETDATE())'
		END
		ELSE
		BEGIN
			SET @AGEWHERE = @AGEWHERE + ' AND (A.BIRTH_DATE BETWEEN DATEADD(YY,-49,GETDATE()) AND DATEADD(YY,-40,GETDATE())'
		END
	END
	IF (CHARINDEX('50', @AGETYPE) > 0)
	BEGIN
		IF(LEN(@AGEWHERE) > 0)
		BEGIN
			SET @AGEWHERE = @AGEWHERE + ' OR A.BIRTH_DATE BETWEEN DATEADD(YY,-99,GETDATE()) AND DATEADD(YY,-50,GETDATE())'
		END
		ELSE
		BEGIN
			SET @AGEWHERE = @AGEWHERE + ' AND (A.BIRTH_DATE BETWEEN DATEADD(YY,-99,GETDATE()) AND DATEADD(YY,-50,GETDATE())'
		END
	END

	IF(LEN(@AGEWHERE) > 0)
	BEGIN
		SET @AGEWHERE = @AGEWHERE + ')'
		SET @WHERE = @WHERE + @AGEWHERE
	END

	--4. RESTYPE
	IF (@RESTYPE = '3M')
	BEGIN
		SET @WHERE = @WHERE + ' AND B.RES_DATE >= DATEADD(MM,-3,GETDATE())'
	END
	ELSE IF (@RESTYPE = '1Y')
	BEGIN
		SET @WHERE = @WHERE + ' AND B.RES_DATE >= DATEADD(YY,-1,GETDATE())'
	END
	ELSE IF (@RESTYPE = '3Y')
	BEGIN
		SET @WHERE = @WHERE + ' AND B.RES_DATE >= DATEADD(YY,-3,GETDATE())'
	END
	ELSE IF (@RESTYPE = 'NN')
	BEGIN
		SET @WHERE = @WHERE + ' AND B.RES_DATE IS NULL'
	END



	SET @SQLSTRING = 'SELECT A.CUS_NO FROM CUS_MEMBER A WITH(NOLOCK)
	LEFT OUTER JOIN (SELECT CUS_NO, MAX(NEW_DATE) AS RES_DATE FROM  RES_MASTER_damo  WITH(NOLOCK) GROUP BY CUS_NO) B 
	ON A.CUS_NO = B.CUS_NO WHERE 1=1 ' 
	+ @WHERE 

	PRINT @SQLSTRING

	EXEC SP_EXECUTESQL @SQLSTRING
END 
GO
