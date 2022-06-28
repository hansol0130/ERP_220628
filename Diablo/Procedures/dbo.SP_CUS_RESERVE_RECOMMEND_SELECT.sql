USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CUS_RESERVE_RECOMMEND_SELECT
■ DESCRIPTION				: 추천인 입력을 위한 고객 검색

	기준 따른 1계정 정보를 반환 

	1. 핸드폰인증유무
	2. 실명인증 -> SNS sert_yn
	3. 예약일자
	4. 마지막 로그인 일자

■ INPUT PARAMETER			: 고객명, 고객핸드폰번호
■ EXEC						: 

	EXEC SP_CUS_RESERVE_RECOMMEND_SELECT '김성호', '010', '3253', '6841'

------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2018-10-12			김성호					최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_CUS_RESERVE_RECOMMEND_SELECT]
(
	@CUS_NAME		VARCHAR(20),
	@NOR_TEL1		VARCHAR(5),
	@NOR_TEL2		VARCHAR(5),
	@NOR_TEL3		VARCHAR(5)
)
AS
BEGIN

	WITH CUS_LIST AS
	(
		-- 회원
		SELECT A.CUS_NO, A.CUS_NAME, A.CUS_ID, ISNULL(A.PHONE_AUTH_YN, 'N') AS [PHONE_AUTH_YN], ISNULL(A.CERT_YN, 'N') AS [CERT_YN], A.LAST_LOGIN_DATE
		FROM CUS_MEMBER A WITH(NOLOCK)
		WHERE A.CUS_NAME = @CUS_NAME AND A.NOR_TEL1 = @NOR_TEL1 AND A.NOR_TEL2 = @NOR_TEL2 AND A.NOR_TEL3 = @NOR_TEL3
		UNION
		-- 휴면회원
		SELECT A.CUS_NO, A.CUS_NAME, A.CUS_ID, ISNULL(A.PHONE_AUTH_YN, 'N'), A.CERT_YN, A.LAST_LOGIN_DATE
		FROM CUS_MEMBER_SLEEP A WITH(NOLOCK)
		WHERE A.CUS_NAME = @CUS_NAME AND A.NOR_TEL1 = @NOR_TEL1 AND A.NOR_TEL2 = @NOR_TEL2 AND A.NOR_TEL3 = @NOR_TEL3
	)
	-- 최근 예약
	, RES_LIST AS
	(
		SELECT A.CUS_NO, B.NEW_DATE, ROW_NUMBER() OVER (PARTITION BY B.CUS_NO ORDER BY NEW_DATE DESC) AS [ROWNUM]
		FROM CUS_LIST A
		INNER JOIN RES_MASTER B WITH(NOLOCK) ON A.CUS_NO = B.CUS_NO
		WHERE B.RES_STATE < 7
	)
	SELECT A.CUS_NO, A.CUS_ID, A.PHONE_AUTH_YN, A.CERT_YN, B.NEW_DATE, A.LAST_LOGIN_DATE
	FROM CUS_LIST A
	LEFT JOIN RES_LIST B ON A.CUS_NO = B.CUS_NO AND B.ROWNUM = 1
	ORDER BY A.PHONE_AUTH_YN DESC, CERT_YN DESC, B.NEW_DATE DESC, A.LAST_LOGIN_DATE DESC

END
GO
