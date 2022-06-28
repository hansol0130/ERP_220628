USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_MOB_CUS_MEMBER_MYPAGE_COUNT_SELECT
■ DESCRIPTION				: 모바일 마이페이지 회원 알림 정보 갯수
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

exec XP_MOB_CUS_MEMBER_MYPAGE_COUNT_SELECT @CUS_NO=4228549

exec XP_MOB_CUS_MEMBER_MYPAGE_COUNT_SELECT @CUS_NO=5090013


■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-09-05		박형만			최초생성
   2013-10-31		박형만			문의게시판 패키지+자유여행+자유여행담당자게시판 건수 불러오기
   2013-11-27		이동호			SMS알림건수 조건절 에 SND_RESULT 추가, 이메일알림건수 조걸절에 RES_STATE 추가 
   2014-06-17		박형만			노출여부 VIEW_YN 컬럼조건 추가
   2015-06-02		박형만			진행중 예약 , 출발일이 지나지 않은 건수로 수정
================================================================================================================*/ 
CREATE PROC [dbo].[XP_MOB_CUS_MEMBER_MYPAGE_COUNT_SELECT]
	@CUS_NO			INT  
AS 
BEGIN

	DECLARE @MEM_YN VARCHAR(1)  --정회원 여부 

	--회원정보 조회 
	IF EXISTS ( SELECT * FROM CUS_MEMBER  WITH(NOLOCK) WHERE CUS_NO = @CUS_NO AND CUS_STATE = 'Y'  )
	BEGIN
		SET @MEM_YN = 'Y' --정회원
	END 
	ELSE 
	BEGIN
		SET @MEM_YN = 'N' --비회원
	END 

	--총 예약건수 
	DECLARE @RES_CNT INT 
	SELECT @RES_CNT = COUNT(*)
	FROM 
	(
		SELECT A.RES_CODE FROM RES_MASTER_damo A WITH(NOLOCK) 
		WHERE A.CUS_NO = @CUS_NO 
		AND (( @MEM_YN = 'N' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE()) ) OR @MEM_YN = 'Y' )  --비회원 출발일 30일 지난것은 표시 안함 
		AND A.VIEW_YN ='Y' --노출여부
		UNION ALL 	
		SELECT A.RES_CODE  FROM RES_MASTER_damo A WITH(NOLOCK) 
			INNER JOIN RES_CUSTOMER_DAMO B WITH(NOLOCK) 
				ON A.RES_CODE = B.RES_CODE 
				AND A.CUS_NO <> B.CUS_NO 
		WHERE B.CUS_NO = @CUS_NO 
		AND B.RES_STATE = 0  --정상출발자만 
		AND (( @MEM_YN = 'N' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE()) ) OR @MEM_YN = 'Y' )  --비회원 출발일 30일 지난것은 표시 안함 
		AND B.VIEW_YN ='Y' --노출여부
		GROUP BY A.RES_CODE 
	) TBL 

	--진행중 미출발 예약 갯수 
	DECLARE @PROG_RES_CNT INT 
	SELECT @PROG_RES_CNT = COUNT(*) 
	FROM 
	(
		SELECT RES_CODE FROM (
			SELECT A.RES_CODE FROM RES_MASTER_damo A WITH(NOLOCK) 
			WHERE A.CUS_NO = @CUS_NO 
			AND A.RES_STATE NOT IN (7,8,9) --취소되지않은
			--AND DATEADD(D,7,GETDATE()) < A.DEP_DATE    -- 출발일7일지난상품
			AND A.DEP_DATE > GETDATE()    -- 출발일이 지나지 않은
			AND (( @MEM_YN = 'N' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE()) ) OR @MEM_YN = 'Y' )  --비회원 출발일 30일 지난것은 표시 안함 
			AND A.VIEW_YN ='Y' --노출여부
			UNION ALL 	
			SELECT A.RES_CODE  FROM RES_MASTER_damo A WITH(NOLOCK) 
				INNER JOIN RES_CUSTOMER_DAMO B WITH(NOLOCK) 
					ON A.RES_CODE = B.RES_CODE 
			WHERE B.CUS_NO = @CUS_NO 
			AND A.RES_STATE NOT IN (7,8,9) --취소되지않은
			AND A.DEP_DATE > GETDATE()    -- 출발일이 지나지 않은
			--AND DATEADD(D,7,GETDATE()) < A.DEP_DATE    -- 출발일7일지난상품
			AND B.RES_STATE = 0   --정상출발자
			AND (( @MEM_YN = 'N' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE()) ) OR @MEM_YN = 'Y' )  --비회원 출발일 30일 지난것은 표시 안함 
			AND B.VIEW_YN ='Y' --노출여부
		) TBL 
		GROUP BY RES_CODE 
	) TBL  

	--1:1 문의 수 (자유여행+패키지)
	DECLARE @INQ_CNT INT 
	SELECT @INQ_CNT = COUNT(*) FROM HBS_DETAIL WITH(NOLOCK) 
	--WHERE MASTER_SEQ IN(4,12) AND NEW_CODE = CONVERT(VARCHAR,@CUS_NO)
	WHERE MASTER_SEQ IN(4,12,24) AND NEW_CODE = CONVERT(VARCHAR,@CUS_NO)
	AND NEW_CODE <> '0'
	AND DEL_YN ='N' 

	--알림갯수. 회원의 진행중인예약(최근1달)
	--회원SMS,EMAIL 가져오기
	DECLARE @NOR_TEL1 INT ,@NOR_TEL2 INT , @NOR_TEL3 INT , @EMAIL VARCHAR(50) 
	SELECT @NOR_TEL1 = NOR_TEL1,@NOR_TEL2 = NOR_TEL2,@NOR_TEL3 = NOR_TEL3 , @EMAIL = EMAIL 
	FROM CUS_MEMBER WITH(NOLOCK) WHERE CUS_NO = @CUS_NO 

	--SMS알림건수 
	DECLARE @SND_SMS_CNT INT 
	SET @SND_SMS_CNT = 0
	IF( ISNULL(@NOR_TEL3,'') <> '' ) 
	BEGIN
		SELECT @SND_SMS_CNT = COUNT(*) FROM RES_SND_SMS WITH(NOLOCK)
		WHERE NEW_DATE > CONVERT(DATETIME,DATEADD(M,-1,GETDATE())) --최근1달
		AND RES_CODE IN ( SELECT RES_CODE FROM RES_MASTER_DAMO WHERE CUS_NO = @CUS_NO AND RES_STATE = 0 AND VIEW_YN ='Y' ) 
		AND RCV_NUMBER1 = @NOR_TEL1
		AND RCV_NUMBER2 = @NOR_TEL2
		AND RCV_NUMBER3 = @NOR_TEL3
		AND SND_RESULT = 1 --정상발송만
	END 

	--이메일알림건수 
	DECLARE @SND_EMAIL_CNT INT 
	SET @SND_EMAIL_CNT = 0
	IF( ISNULL(@EMAIL,'') <> '' AND ISNULL(@EMAIL,'') <> '@' ) 
	BEGIN
		SELECT @SND_EMAIL_CNT = COUNT(*) FROM RES_SND_EMAIL WITH(NOLOCK)
		WHERE NEW_DATE > CONVERT(DATETIME,DATEADD(M,-1,GETDATE()))  --최근1달
		AND RES_CODE IN ( SELECT RES_CODE FROM RES_MASTER_DAMO WHERE CUS_NO = @CUS_NO AND RES_STATE = 0 AND VIEW_YN ='Y' ) 
		AND RCV_EMAIL = @EMAIL
	END 

	-- 관심상품 갯수 
	DECLARE @INT_CNT INT 
	SELECT @INT_CNT = COUNT(*)
	FROM CUS_INTEREST A WITH(NOLOCK) WHERE CUS_NO = @CUS_NO;

	SELECT @RES_CNT AS RES_CNT, 
		@PROG_RES_CNT AS PROG_RES_CNT,
		@INQ_CNT INQ_CNT , 
		@SND_SMS_CNT + @SND_EMAIL_CNT  AS SEND_CNT, 
		@INT_CNT AS INT_CNT
END 
GO
