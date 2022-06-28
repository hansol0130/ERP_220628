USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_NON_MEMBER_INFO_SELECT
■ DESCRIPTION				: 검색_비회원출발자정보로 검색
■ INPUT PARAMETER			: @RES_CODE		VARCHAR(10),
	@CUS_NAME		VARCHAR(20),
	@BIRTH_DATE		DATETIME,
	@GENDER			CHAR(1),
	@NOR_TEL1		VARCHAR(4),
	@NOR_TEL2		VARCHAR(6),
	@NOR_TEL3		VARCHAR(4)
■ EXEC						: 
    -- 

	exec SP_MOV2_NON_MEMBER_INFO_SELECT 'RP1710174753','승은',''  ,'' , '','','', ''
	exec SP_MOV2_NON_MEMBER_INFO_SELECT '','박형만','1980-07-08'  ,'M' , '010','9185','2481', ''

	exec SP_MOV2_NON_MEMBER_INFO_SELECT '','신솔비','1991-01-25'  ,'M' , '010','4088	','0659', ''
	
	exec SP_MOV2_NON_MEMBER_INFO_SELECT '','김말녀','1954-02-10'  ,'f' , '010','2853','7254', ''
	
	WHERE A.CUS_NAME = '박종만'
	AND A.BIRTH_DATE = '1975-10-19 00:00:00.000'
	AND A.GENDER = 'M'
	AND A.NOR_TEL1 = '010'
	AND A.NOR_TEL2 = '8754'
	AND A.NOR_TEL3 = '9402'

	
		SELECT *
		FROM CUVE A WITH(NOLOCK)

■ MEMO						: 비회원 출발자 정보로 검색
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-17		박형만					최초생성
   2017-10-21		ibsolution				전화번호 대신 여권번호 이용한 검색추가
   2019-03-28		박형만					매칭안된 회원번호 1은 로그인 에서 제외 
   2020-03-16       지니웍스 임검제			예약정보 찾기 휴대폰번호, 예약번호 조건 추가 
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_SLIME_NON_MEMBER_INFO_SELECT]
	@RES_CODE		VARCHAR(12),
	@CUS_NAME		VARCHAR(20),
	@BIRTH_DATE		DATETIME,
	@GENDER			CHAR(1),
	@NOR_TEL1		VARCHAR(4),
	@NOR_TEL2		VARCHAR(6),
	@NOR_TEL3		VARCHAR(4),
	@PASSPORT_NUM	VARCHAR(20)
AS
BEGIN
	-- 예약번호로 찾기 예약자 로그인 , 예약번호가 있고, 전화번호가 없을 시 
	IF( ISNULL(@RES_CODE,'') <> '' AND (ISNULL(@NOR_TEL1,'') = '' OR ISNULL(@NOR_TEL2,'') = '' OR ISNULL(@NOR_TEL3,'') = '')) 
	BEGIN
		SELECT ISNULL(D.CUS_ID,E.CUS_ID) AS CUS_ID  , A.CUS_NO, A.RES_NAME as CUS_NAME, B.FIRST_NAME, B.LAST_NAME, A.GENDER, A.BIRTH_DATE, A.NOR_TEL1, A.NOR_TEL2, A.NOR_TEL3, B.EMAIL  ,
			A.RES_STATE, A.DEP_DATE 
		FROM RES_MASTER_damo A WITH (NOLOCK) 
			LEFT JOIN CUS_CUSTOMER_damo  B  WITH(NOLOCK)
				ON A.CUS_NO = B.CUS_NO 
			LEFT JOIN CUS_MEMBER D  WITH (NOLOCK)
				ON A.CUS_NO = D.CUS_NO 
			LEFT JOIN CUS_MEMBER_SLEEP E  WITH (NOLOCK)
				ON A.CUS_NO = E.CUS_NO
		WHERE A.RES_CODE = @RES_CODE
		AND A.RES_NAME = @CUS_NAME
		--AND A.RES_STATE < 7
		AND A.VIEW_YN = 'Y'
		AND A.DEP_DATE > DATEADD(DD,-30,GETDATE()) 

		AND A.CUS_NO <> 1 
	END 
	ELSE -- 출발자 찾기 
	BEGIN
		-- 여권번호로 찾기 
		IF( ISNULL(@PASSPORT_NUM,'') <> '' )
			BEGIN
				SELECT ISNULL(D.CUS_ID,E.CUS_ID) AS CUS_ID, A.CUS_NO, A.SEQ_NO, A.CUS_NAME, A.FIRST_NAME, A.LAST_NAME, A.GENDER, A.BIRTH_DATE, A.NOR_TEL1, A.NOR_TEL2, A.NOR_TEL3, A.EMAIL, B.DEP_DATE ,  
					A.RES_CODE, C.PRO_NAME + ' [' + CONVERT(char(10), C.DEP_DATE, 23) + '(' + replace(DATENAME (WEEKDAY, C.DEP_DATE), '요일', '') + ')' + ' ~ ' + CONVERT(char(10), C.ARR_DATE, 23) + '(' + replace(DATENAME (WEEKDAY, C.ARR_DATE), '요일', '')  + ')]' AS PRO_DESC ,
					A.RES_STATE
				FROM RES_CUSTOMER_damo A WITH (NOLOCK)
					INNER JOIN RES_MASTER_damo B WITH (NOLOCK)
					ON A.RES_CODE = B.RES_CODE
					INNER JOIN PKG_DETAIL C WITH (NOLOCK)
					ON B.PRO_CODE = C.PRO_CODE
					LEFT JOIN CUS_MEMBER D  WITH (NOLOCK)
						ON A.CUS_NO = D.CUS_NO 
					LEFT JOIN CUS_MEMBER_SLEEP E  WITH (NOLOCK)
						ON A.CUS_NO = E.CUS_NO
			
				WHERE A.CUS_NAME = @CUS_NAME
					AND A.BIRTH_DATE = @BIRTH_DATE
					AND A.GENDER = @GENDER
					AND damo.dbo.dec_varchar('DIABLO','dbo.RES_CUSTOMER','PASS_NUM', A.sec_PASS_NUM) = @PASSPORT_NUM
					AND A.VIEW_YN = 'Y'
					AND B.DEP_DATE > DATEADD(DD,-30,GETDATE()) 
					AND DBO.XN_APP_RES_USE_YN(A.RES_CODE) = 'Y' 
					
					AND A.CUS_NO <> 1 

				ORDER BY CASE WHEN B.DEP_DATE > GETDATe() THEN 1 ELSE 0 END DESC , 
					CASE WHEN A.RES_STATE = 0 THEN 1 ELSE 0 END DESC,
					B.DEP_DATE ASC ,  A.CUS_NO DESC 
			END
		ELSE
		-- 휴대폰번호로 찾기 
			BEGIN
				SELECT ISNULL(D.CUS_ID,E.CUS_ID) AS CUS_ID, A.CUS_NO, A.SEQ_NO, A.CUS_NAME, A.FIRST_NAME, A.LAST_NAME, A.GENDER, A.BIRTH_DATE, A.NOR_TEL1, A.NOR_TEL2, A.NOR_TEL3, A.EMAIL, B.DEP_DATE ,  
					A.RES_CODE, C.PRO_NAME + ' [' + CONVERT(char(10), C.DEP_DATE, 23) + '(' + replace(DATENAME (WEEKDAY, C.DEP_DATE), '요일', '') + ')' + ' ~ ' + CONVERT(char(10), C.ARR_DATE, 23) + '(' + replace(DATENAME (WEEKDAY, C.ARR_DATE), '요일', '')  + ')]' AS PRO_DESC ,
					A.RES_STATE
				FROM RES_CUSTOMER_damo A WITH (NOLOCK)
					INNER JOIN RES_MASTER_damo B WITH (NOLOCK)
					ON A.RES_CODE = B.RES_CODE
					INNER JOIN PKG_DETAIL C WITH (NOLOCK)
					ON B.PRO_CODE = C.PRO_CODE
					LEFT JOIN CUS_MEMBER D  WITH (NOLOCK)
						ON A.CUS_NO = D.CUS_NO 
					LEFT JOIN CUS_MEMBER_SLEEP E  WITH (NOLOCK)
						ON A.CUS_NO = E.CUS_NO
			
				WHERE A.CUS_NAME = @CUS_NAME
					/*출발자 생일,성별 제외 20191108*/
					--AND A.BIRTH_DATE = @BIRTH_DATE
					--AND A.GENDER = @GENDER
					AND A.RES_CODE = @RES_CODE
					AND A.NOR_TEL1 = @NOR_TEL1
					AND A.NOR_TEL2 = @NOR_TEL2
					AND A.NOR_TEL3 = @NOR_TEL3
					AND A.VIEW_YN = 'Y'
					AND B.DEP_DATE > DATEADD(DD,-30,GETDATE()) 
					AND A.CUS_NO <> 1 

				ORDER BY CASE WHEN B.DEP_DATE > GETDATe() THEN 1 ELSE 0 END DESC , 
					CASE WHEN A.RES_STATE = 0 THEN 1 ELSE 0 END DESC,
					B.DEP_DATE ASC ,  A.CUS_NO DESC 
			END
	END 
END

GO
