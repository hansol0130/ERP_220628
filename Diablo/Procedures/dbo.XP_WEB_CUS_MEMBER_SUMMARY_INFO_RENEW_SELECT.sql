USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_WEB_CUS_MEMBER_SUMMARY_INFO_SELECT
■ DESCRIPTION				: 마이페이지 회원 종합정보 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

exec XP_WEB_CUS_MEMBER_SUMMARY_INFO_RENEW_SELECT @CUS_NO=12566088

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-01		박형만			최초생성
   2013-06-19		박형만			고객의 소리 DEL_YN 조건 추가 
   2013-10-31		박형만			문의게시판 패키지+자유여행+자유여행담당자게시판 건수 불러오기
   2014-05-20		박형만			비회원은 출발일 30일 지난것 표시 안함
   2014-06-17		박형만			노출여부 VIEW_YN 컬럼조건 추가
   2014-12-09		박형만			호텔관련 - 상품구분별  COUNT 추가 
   2018-04-06		박형만			CERT_YN 컬럼추가 
   2020-04-20		김영민			고객등급 컬럼추가 CUS_CUSTOMER_damo 등급 바라보게 변경
   2020-11-02		오준혁			고객등급은 함수사용 dbo.FN_CUS_GET_CUS_GRADE_NAME
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_WEB_CUS_MEMBER_SUMMARY_INFO_RENEW_SELECT]
	@CUS_NO			INT  
AS 
BEGIN
--DECLARE @CUS_NO INT 
--SET @CUS_NO=4228549

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
	

	--최근 1년 
	DECLARE @START_DATE DATETIME 
	DECLARE @END_DATE DATETIME 
	SET @START_DATE = CONVERT(DATETIME,CONVERT(VARCHAR(10),DATEADD( YY , -1 , GETDATE()),121)) 
	SET @END_DATE = GETDATE()
	--최근1년 예약건수
	DECLARE @REC_RES_CNT INT 

	DECLARE @REC_PKG_RES_CNT INT 
	DECLARE @REC_AIR_RES_CNT INT 
	DECLARE @REC_HTL_RES_CNT INT 
	--SELECT @REC_RES_CNT = COUNT(*)
	--FROM 
	--(
	--	SELECT A.RES_CODE FROM RES_MASTER_damo A WITH(NOLOCK) 
	--	WHERE A.CUS_NO = @CUS_NO AND A.NEW_DATE BETWEEN @START_DATE AND @END_DATE
	--	AND (( @MEM_YN = 'N' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE()) ) OR @MEM_YN = 'Y' )  --비회원 출발일 30일 지난것은 표시 안함 
	--	AND A.VIEW_YN ='Y' --노출여부
	--	UNION ALL 	
	--	SELECT A.RES_CODE  FROM RES_MASTER_damo A WITH(NOLOCK) 
	--		INNER JOIN RES_CUSTOMER_DAMO B WITH(NOLOCK) 
	--			ON A.RES_CODE = B.RES_CODE 
	--			AND A.CUS_NO <> B.CUS_NO 
	--	WHERE B.CUS_NO = @CUS_NO AND A.NEW_DATE BETWEEN @START_DATE AND @END_DATE
	--	AND B.RES_STATE = 0  --정상출발자만 
	--	AND (( @MEM_YN = 'N' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE()) ) OR @MEM_YN = 'Y' )  --비회원 출발일 30일 지난것은 표시 안함 
	--	AND B.VIEW_YN ='Y' --노출여부
	--	GROUP BY A.RES_CODE 
	--) TBL 

	--최근1년 예약건수
	SELECT 
		@REC_RES_CNT = TOTAL_CNT , @REC_PKG_RES_CNT = PKG_CNT , @REC_AIR_RES_CNT =AIR_CNT , @REC_HTL_RES_CNT = HTL_CNT 
	FROM 
	(
		SELECT 
			SUM(1) TOTAL_CNT , 
			SUM(CASE WHEN A.PRO_TYPE = 1 THEN 1 ELSE 0 END)  AS PKG_CNT , 
			SUM(CASE WHEN A.PRO_TYPE = 2 THEN 1 ELSE 0 END)  AS AIR_CNT , 
			SUM(CASE WHEN A.PRO_TYPE = 3 THEN 1 ELSE 0 END)  AS HTL_CNT 
		FROM ( 
			SELECT A.RES_CODE FROM RES_MASTER_damo A WITH(NOLOCK) 
			WHERE A.CUS_NO = @CUS_NO AND A.NEW_DATE BETWEEN @START_DATE AND @END_DATE
			AND (( @MEM_YN = 'N' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE()) ) OR @MEM_YN = 'Y' )  --비회원 출발일 30일 지난것은 표시 안함 
			AND A.VIEW_YN ='Y' --노출여부
			UNION ALL 	
			SELECT A.RES_CODE  FROM RES_MASTER_damo A WITH(NOLOCK) 
				INNER JOIN RES_CUSTOMER_DAMO B WITH(NOLOCK) 
					ON A.RES_CODE = B.RES_CODE 
					AND A.CUS_NO <> B.CUS_NO 
			WHERE B.CUS_NO = @CUS_NO AND A.NEW_DATE BETWEEN @START_DATE AND @END_DATE
			AND B.RES_STATE = 0  --정상출발자만 
			AND (( @MEM_YN = 'N' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE()) ) OR @MEM_YN = 'Y' )  --비회원 출발일 30일 지난것은 표시 안함 
			AND B.VIEW_YN ='Y' --노출여부
			GROUP BY A.RES_CODE 
			--SELECT A.RES_CODE FROM RES_MASTER_damo A WITH(NOLOCK) 
			--WHERE A.CUS_NO = @CUS_NO 
			--AND (( @MEM_YN = 'N' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE()) ) OR @MEM_YN = 'Y' )  --비회원 출발일 30일 지난것은 표시 안함 
			--AND A.VIEW_YN ='Y' --노출여부
			--UNION ALL 	
			--SELECT A.RES_CODE  FROM RES_MASTER_damo A WITH(NOLOCK) 
			--	INNER JOIN RES_CUSTOMER_DAMO B WITH(NOLOCK) 
			--		ON A.RES_CODE = B.RES_CODE 
			--		AND A.CUS_NO <> B.CUS_NO 
			--WHERE B.CUS_NO = @CUS_NO 
			--AND B.RES_STATE = 0  --정상출발자만 
			--AND (( @MEM_YN = 'N' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE()) ) OR @MEM_YN = 'Y' )  --비회원 출발일 30일 지난것은 표시 안함 
			--AND B.VIEW_YN ='Y' --노출여부
			--GROUP BY A.PRO_TYPE , A.RES_CODE 
		) TBL 
			INNER JOIN RES_MASTER_damo A WITH(NOLOCK)  
				ON TBL.RES_CODE = A.RES_CODE 
	) TBL2 



	--총 포인트 
	DECLARE @POINT_PRICE INT 
	SELECT TOP 1 @POINT_PRICE = TOTAL_PRICE FROM CUS_POINT WITH(NOLOCK) WHERE CUS_NO = @CUS_NO
	ORDER BY POINT_NO DESC  

	--1:1 문의 (자유여행+패키지)
	DECLARE @INQ_CNT INT 
	SELECT @INQ_CNT = COUNT(*) FROM HBS_DETAIL WITH(NOLOCK) 
	--WHERE MASTER_SEQ IN(4,12) AND NEW_CODE = CONVERT(VARCHAR,@CUS_NO)
	WHERE MASTER_SEQ IN(4,12,24) AND NEW_CODE = CONVERT(VARCHAR,@CUS_NO) --(패키지+자유여행+자유여행담당자문의) 
	AND DEL_YN ='N' 
	--여행후기
	DECLARE @POST_CNT INT 
	SELECT @POST_CNT = COUNT(*) FROM HBS_DETAIL WITH(NOLOCK) 
	WHERE MASTER_SEQ = 1 AND NEW_CODE = CONVERT(VARCHAR,@CUS_NO)
	AND DEL_YN ='N' 
	--상품평
	DECLARE @COMM_CNT INT 
	SELECT @COMM_CNT = COUNT(*) FROM PRO_COMMENT WITH(NOLOCK) 
	WHERE CUS_NO = @CUS_NO
	--고객의소리
	DECLARE @VOC_CNT INT 
	SELECT @VOC_CNT = COUNT(*) FROM HBS_DETAIL WITH(NOLOCK) 
	WHERE MASTER_SEQ = 19 AND NEW_CODE = CONVERT(VARCHAR,@CUS_NO)
	AND DEL_YN ='N' 

	-- 관심상품 갯수 - 20191115 리뉴얼
	DECLARE @INT_CNT INT 
	SELECT @INT_CNT = COUNT(*)
	FROM CUS_INTEREST A WITH(NOLOCK) WHERE CUS_NO = @CUS_NO;

	-- 히스토리 갯수 - 20191115 리뉴얼
	DECLARE @HISTORY_CNT INT
	SELECT @HISTORY_CNT = COUNT(*) 
	FROM CUS_MASTER_HISTORY A WITH(NOLOCK)
	WHERE A.CUS_NO = @CUS_NO
		AND (A.HIS_TYPE <> 1 OR (A.HIS_TYPE = 1 AND A.MASTER_CODE <> ''))

	--회원정보 조회 
	IF EXISTS ( SELECT * FROM CUS_MEMBER  WITH(NOLOCK) WHERE CUS_NO = @CUS_NO AND CUS_STATE = 'Y'  )
	BEGIN
		--정회원
		SELECT 
			@RES_CNT AS RES_CNT , 
			@POINT_PRICE AS POINT_PRICE , 
			@INQ_CNT AS INQ_CNT , 
			@POST_CNT AS POST_CNT , 
			@COMM_CNT AS COMM_CNT , 
			@VOC_CNT AS VOC_CNT , 
			@REC_RES_CNT AS REC_RES_CNT , 
			@REC_PKG_RES_CNT AS REC_PKG_RES_CNT , 
			@REC_HTL_RES_CNT AS REC_HTL_RES_CNT , 
			@REC_AIR_RES_CNT AS REC_AIR_RES_CNT , 

			/*관심상품갯수 - 20191115리뉴얼*/
			@INT_CNT AS INT_CNT,
			/*히스토리갯수 - 20191115리뉴얼*/
			@HISTORY_CNT AS HISTORY_CNT,

			A.CUS_ID , A.CUS_NO , A.CUS_NAME, A.LAST_NAME , A.FIRST_NAME , A.NOR_TEL1 , A.NOR_TEL2 , A.NOR_TEL3 , A.EMAIL , B.CUS_GRADE ,
			DAMO.dbo.dec_varchar('DIABLO','dbo.CUS_CUSTOMER','PASS_NUM', A.SEC_PASS_NUM) AS PASS_NUM  , A.PASS_EXPIRE ,
			A.POINT_CONSENT ,
			A.CERT_YN,
			dbo.FN_CUS_GET_CUS_GRADE_NAME(@CUS_NO ,FORMAT(GETDATE() ,'yyyy')) AS 'CUS_GRADE_NAME'
		FROM CUS_MEMBER A WITH(NOLOCK) LEFT JOIN CUS_CUSTOMER_damo B WITH(NOLOCK) ON A.CUS_NO = B.CUS_NO WHERE A.CUS_NO =@CUS_NO;
	END 
	ELSE 
	BEGIN
		--비회원
		SELECT 
			@RES_CNT AS RES_CNT , 
			@POINT_PRICE AS POINT_PRICE , 
			@INQ_CNT AS INQ_CNT , 
			@POST_CNT AS POST_CNT , 
			@COMM_CNT AS COMM_CNT , 
			@VOC_CNT AS VOC_CNT , 
			@REC_RES_CNT AS REC_RES_CNT , 
			@REC_PKG_RES_CNT AS REC_PKG_RES_CNT , 
			@REC_HTL_RES_CNT AS REC_HTL_RES_CNT , 
			@REC_AIR_RES_CNT AS REC_AIR_RES_CNT , 

			/*관심상품갯수 - 20191115리뉴얼*/
			@INT_CNT AS INT_CNT,
			/*관심상품갯수 - 20191115리뉴얼*/
			@HISTORY_CNT AS HISTORY_CNT,

			CUS_ID , CUS_NO , CUS_NAME, LAST_NAME , FIRST_NAME , NOR_TEL1 , NOR_TEL2 , NOR_TEL3 , EMAIL ,
			DAMO.dbo.dec_varchar('DIABLO','dbo.CUS_CUSTOMER','PASS_NUM', A.SEC_PASS_NUM) AS PASS_NUM  , PASS_EXPIRE ,
			POINT_CONSENT ,
			'N' AS CERT_YN,
			'' AS 'CUS_GRADE_NAME'
		FROM CUS_CUSTOMER_damo A WITH(NOLOCK) WHERE CUS_NO =@CUS_NO;
	END 

	--고객정보 
END 

GO
