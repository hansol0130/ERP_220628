USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_CLIENT_DETAIL_INFO_SELECT
■ DESCRIPTION				: BTMS 거래처 상세 정보
■ INPUT PARAMETER			: AGT_CODE
■ OUTPUT PARAMETER			: 
■ EXEC						: 	
	EXEC XP_COM_CLIENT_DETAIL_INFO_SELECT '92756'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-11		저스트고강태영			최초생성
   2016-06-07		김성호					BTMS_YN 검색 조건 추가
   2016-08-09		박형만					SALE_RATE 복지몰 할인율 추가 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_CLIENT_DETAIL_INFO_SELECT]
	@AGT_CODE VARCHAR(5)
AS 
BEGIN

SELECT
	A.NEW_DATE,			--등록일
	A.AGT_CODE,			--거래처코드
	A.SHOW_YN,			--상태
	A.AGT_TYPE_CODE,	--거래처유형
	A.USE_CODE,			--사용구분
	A.AGT_PART_CODE,	--세부구분
	A.KOR_NAME,			--거래처명
	(SELECT AGT_NAME FROM AGT_MASTER WHERE AGT_CODE = B.PARENT_AGT_CODE) AS PARENT_AGT_NAME, --상위거래처명
	B.PARENT_AGT_CODE,	--상위거래처 코드
	A.AGT_NAME,			--사업장명
	A.CEO_NAME,			--대표자명
	A.NOR_TEL1,			--대표번호1
	A.NOR_TEL2,			--대표번호2
	A.NOR_TEL3,			--대표번호3
	A.FAX_TEL1,			--팩스번호1
	A.FAX_TEL2,			--팩스번호2
	A.FAX_TEL3,			--팩스번호3
	A.AGT_REGISTER,		--사업자번호
	A.AGT_CONDITION,	--업태
	A.AGT_ITEM,			--업종
	A.ZIP_CODE,			--우편번호
	A.ADDRESS1,			--주소1
	A.ADDRESS2,			--주소2
	A.URL,				--홈페이지
	B.COMPANY_NUMBER,	--법인번호
	B.AGT_ID,			--도메인설정
	A.TAX_YN,			--세금계산서
	B.CON_START_DATE,	--계약시작일
	B.CON_END_DATE,		--계약종료일
	A.COMM_RATE,		--수수료율
	A.PAY_LATER_YN,		--후불여부
	A.ADMIN_REMARK,		--비고
	ISNULL(C.KOR_NAME, '-') AS EDT_NAME,	--최근수정자
	ISNULL(D.TEAM_NAME, '-') AS EDT_TEAM_NAME,	--최근수정자 부서
	ISNULL(E.PUB_VALUE, '-') AS EDT_POS,	--최근수정자직급
	A.EDT_DATE,			--최근수정일
	ISNULL(A.BTMS_YN, 'N') AS [BTMS_YN] , 
	B.SALE_RATE 
FROM AGT_MASTER A WITH(NOLOCK)
LEFT JOIN COM_MASTER B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE
LEFT JOIN EMP_MASTER C WITH(NOLOCK) ON C.EMP_CODE = A.EDT_CODE
LEFT JOIN EMP_TEAM D WITH(NOLOCK) ON C.TEAM_CODE = D.TEAM_CODE
LEFT JOIN COD_PUBLIC E WITH(NOLOCK) ON C.POS_TYPE = E.PUB_CODE AND E.PUB_TYPE = 'EMP.POSTYPE'
WHERE A.AGT_CODE = @AGT_CODE

--파일 정보
SELECT * FROM COM_FILE WITH(NOLOCK)
WHERE AGT_CODE = @AGT_CODE ORDER BY FILE_SEQ ASC

--담당자 정보
SELECT
	A.AGT_CODE,
	A.MANAGER_TYPE,
	A.EMP_CODE,
	B.KOR_NAME,
	A.NEW_DATE
FROM COM_MANAGER A WITH(NOLOCK)
LEFT JOIN EMP_MASTER B WITH(NOLOCK) ON A.EMP_CODE = B.EMP_CODE
WHERE AGT_CODE = @AGT_CODE
ORDER BY A.MANAGER_TYPE ASC

--카드 정보
SELECT * FROM AGT_ACCOUNT WITH(NOLOCK)
WHERE SHOW_YN = 'Y' AND AGT_CODE = @AGT_CODE
ORDER BY ACC_SEQ ASC

END

GO
