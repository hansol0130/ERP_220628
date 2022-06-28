USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Server					: 
■ Database					: DIABLO
■ USP_Name					: XP_AGT_MEMBER_INSERT
■ Description				: 거래처 직원을 추가한다. (자동으로 직원 사번생성)_
■ Input Parameter			:                  
		@AGT_TYPE			: 거래처 종류 구분
		@........			: 직원 정보
■ Output Parameter			:                  
■ Output Value				: 추가된 직원의 사번 (MEM_CODE)                
■ Exec						: EXEC XP_AGT_MEMBER_INSERT 1, .....
■ Author					: 이규식  
■ Date						: 2013-02-20
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2013-02-20		이규식			최초생성  
	2014-01-27		정지용			생년월일 / 성별 추가
	2014-10-29		정지용			마케팅 타입 추가
	2021-11-10      오준혁           국내거래처 타입 추가(제휴사 등록을 위해 사용)
	2022-01-10      오준혁           호텔_국내 타입 추가(홈쇼핑-호텔 등록을 위해 사용)
-------------------------------------------------------------------------------------------------*/ 

CREATE PROCEDURE [dbo].[XP_AGT_MEMBER_INSERT]
	@AGT_CODE varchar(10),
	@MEM_CODE varchar(7),
	@MEM_TYPE int,
	@WORK_TYPE int,
	@KOR_NAME varchar(20),
	@ENG_LAST_NAME varchar(20),
	@ENG_FIRST_NAME varchar(20),
	@TEAM_NAME varchar(20),
	@POS_NAME varchar(20),
	@PASSWORD varchar(20),
	@TEL_NUMBER1 varchar(4),
	@TEL_NUMBER2 varchar(4),
	@TEL_NUMBER3 varchar(4),
	@HP_NUMBER1 varchar(4),
	@HP_NUMBER2 varchar(4),
	@HP_NUMBER3 varchar(4),
	@EMAIL varchar(30),
	@ZIP_CODE varchar(7),
	@ADDRESS1 varchar(50),
	@ADDRESS2 varchar(80),
	@NEW_CODE char(7),
	@EDT_CODE char(7),
	@BIRTH_DATE varchar(10),
	@GENDER	char(1)
AS

	SET NOCOUNT OFF;
	DECLARE @AGT_TYPE INT
		
	BEGIN
			-- 거래처의 종류를 가져온다.
			SELECT @AGT_TYPE = AGT_TYPE_CODE FROM AGT_MASTER WITH(NOLOCK) WHERE AGT_CODE = @AGT_CODE;

			-- 고유한 사원코드를 받아온다.
			-- 사원코드는 1~9999 번호로 시작되면 9999가 넘어갈경우 1로 다시 초기화된다.
			EXEC	[dbo].[SP_COD_GETSEQ] 'AGT', @MEM_CODE OUTPUT

			SET @MEM_CODE = 
				CASE @AGT_TYPE
					-- 랜드사
					WHEN 12 THEN 'L'
					-- 호텔_국내
					WHEN 23 THEN 'H'
					-- 인솔자
					WHEN 30 THEN 'T'
					-- 대리점
					WHEN 50 THEN 'A'
					-- 마케팅
					WHEN 70 THEN 'M'
					-- 국내거래처
					WHEN 80 THEN 'P'
				END
				+ @MEM_CODE;

			IF (LEN(@MEM_CODE) <> 7) 
			BEGIN
				RAISERROR ( N'사번을 생성할수 없는 거래처 종류 입니다.' ,16,1)
			END

			INSERT INTO AGT_MEMBER(
				MEM_CODE,
				AGT_CODE,
				MEM_TYPE,
				WORK_TYPE,
				KOR_NAME,
				ENG_LAST_NAME,
				ENG_FIRST_NAME,
				TEAM_NAME,
				POS_NAME,
				PASSWORD,
				TEL_NUMBER1,
				TEL_NUMBER2,
				TEL_NUMBER3,
				HP_NUMBER1,
				HP_NUMBER2,
				HP_NUMBER3,
				EMAIL,
				ZIP_CODE,
				ADDRESS1,
				ADDRESS2,
				BLOCK_COUNT,
				NEW_CODE,
				BIRTH_DATE,
				GENDER
			) VALUES (
				@MEM_CODE,
				@AGT_CODE, 
				@MEM_TYPE,
				@WORK_TYPE,
				@KOR_NAME,
				@ENG_LAST_NAME,
				@ENG_FIRST_NAME,
				@TEAM_NAME,
				@POS_NAME,
				@PASSWORD,
				@TEL_NUMBER1,
				@TEL_NUMBER2,
				@TEL_NUMBER3,
				@HP_NUMBER1,
				@HP_NUMBER2,
				@HP_NUMBER3,
				@EMAIL,
				@ZIP_CODE,
				@ADDRESS1,
				@ADDRESS2,
				0,
				@NEW_CODE,
				@BIRTH_DATE,
				@GENDER
			)

			SELECT @MEM_CODE AS MEM_CODE
	END
GO
