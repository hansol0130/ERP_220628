USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_MOV2_MEMBER_INFO_SELECT
■ DESCRIPTION				: 검색_회원정보
■ INPUT PARAMETER			: CUS_NO
■ EXEC						: 
    -- 
	exec SP_MOV2_MEMBER_INFO_SELECT 4228549

■ MEMO						: MOV2_멤버정보
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-08-04		오준욱(IBSOLUTION)		최초생성
   2017-09-12		고민우(IBSOLUTION)		수정 : HISTORY_CNT 추가
   2017-10-16		박형만			수정 : HISTORY_CNT 추가 SP_MOV2_HISTORY_MASTER_COUNT_SELECT 와 같게 수정
   2017-10-18		박형만			이동제외 
   2018-08-21		박형만			튜닝 MGT_CNT  , 사용안하는걸로 판단 주석처리 
    
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_MEMBER_INFO_SELECT]
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
		AND A.RES_STATE <> 8 -- 이동제외
		UNION ALL 	
		SELECT A.RES_CODE  FROM RES_MASTER_damo A WITH(NOLOCK) 
			INNER JOIN RES_CUSTOMER_DAMO B WITH(NOLOCK) 
				ON A.RES_CODE = B.RES_CODE 
				AND A.CUS_NO <> B.CUS_NO 
		WHERE B.CUS_NO = @CUS_NO 
		AND A.RES_STATE <> 8 -- 이동제외
		AND B.RES_STATE = 0  --정상출발자만
		AND (( @MEM_YN = 'N' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE()) ) OR @MEM_YN = 'Y' )  --비회원 출발일 30일 지난것은 표시 안함  
		AND B.VIEW_YN ='Y' --노출여부
		GROUP BY A.RES_CODE 
	) TBL1 

	DECLARE @MTG_CNT INT 
	SELECT @MTG_CNT = -1 
	--SELECT @MTG_CNT = COUNT(*)
	--FROM 
	--(
	--	SELECT A.RES_CODE FROM RES_MASTER_damo A WITH(NOLOCK) 
	--	WHERE A.CUS_NO = @CUS_NO 
	--	AND (( @MEM_YN = 'N' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE()) ) OR @MEM_YN = 'Y' )  --비회원 출발일 30일 지난것은 표시 안함 
	--	AND A.VIEW_YN ='Y' --노출여부
	--	--AND ( SUBSTRING(A.RES_CODE,2,1) = 'P' OR (SUBSTRING(A.RES_CODE,2,1) = 'T' AND SUBSTRING(A.PRO_CODE,1,1) <> 'K'))
	--	AND ( A.PRO_TYPE=1 OR A.PRO_TYPE = 2 AND A.PRO_CODE NOT LIKE 'K%')
	--	AND A.RES_STATE <> 8 -- 이동제외 
	--	UNION ALL 	
	--	SELECT A.RES_CODE  FROM RES_MASTER_damo A WITH(NOLOCK) 
	--		INNER JOIN RES_CUSTOMER_DAMO B WITH(NOLOCK) 
	--			ON A.RES_CODE = B.RES_CODE 
	--			AND A.CUS_NO <> B.CUS_NO 
	--	WHERE B.CUS_NO = @CUS_NO 
	--	AND A.RES_STATE <> 8 -- 이동제외 
	--	AND B.RES_STATE = 0  --정상출발자만
	--	AND (( @MEM_YN = 'N' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE()) ) OR @MEM_YN = 'Y' )  --비회원 출발일 30일 지난것은 표시 안함  
	--	AND B.VIEW_YN ='Y' --노출여부
	--	--AND ( SUBSTRING(A.RES_CODE,2,1) = 'P' OR (SUBSTRING(A.RES_CODE,2,1) = 'T' AND SUBSTRING(A.PRO_CODE,1,1) <> 'K'))
	--	AND ( A.PRO_TYPE=1 OR A.PRO_TYPE = 2 AND A.PRO_CODE NOT LIKE 'K%')
	--	GROUP BY A.RES_CODE 
	--) TBL2 

	--총 포인트 
	DECLARE @POINT_PRICE INT 
	SELECT TOP 1 @POINT_PRICE = TOTAL_PRICE FROM CUS_POINT WITH(NOLOCK) WHERE CUS_NO = @CUS_NO
	ORDER BY POINT_NO DESC  

	--관심상품 갯수
	DECLARE @INT_CNT INT 
	SELECT @INT_CNT = COUNT(*) FROM CUS_INTEREST I WITH(NOLOCK) WHERE I.CUS_NO = @CUS_NO

	--알림수
	DECLARE @NOTICE_CNT INT 
	SELECT @NOTICE_CNT = COUNT(*) FROM CUVE C WITH(NOLOCK) WHERE C.CUS_NO = @CUS_NO

	--히스토리수
	DECLARE @HISTORY_CNT INT 
	--SELECT @HISTORY_CNT = COUNT(*) FROM CUS_MASTER_HISTORY H WITH(NOLOCK) WHERE H.CUS_NO = @CUS_NO AND HIS_TYPE = 1 AND MASTER_CODE IS NOT NULL
	SELECT @HISTORY_CNT = COUNT(*) FROM CUS_MASTER_HISTORY A WITH(NOLOCK)  WHERE CUS_NO = @CUS_NO 
	AND ( HIS_TYPE <> 1 OR ( HIS_TYPE = 1 AND MASTER_CODE <> '' AND MASTER_CODE IS NOT NULL ) )


	--1:1 문의 (자유여행+패키지)
	DECLARE @INQ_CNT INT 
	SELECT @INQ_CNT = COUNT(*) FROM HBS_DETAIL WITH(NOLOCK) 
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


	--회원정보 조회 
	IF EXISTS ( SELECT * FROM CUS_MEMBER  WITH(NOLOCK) WHERE CUS_NO = @CUS_NO AND CUS_STATE = 'Y'  )
	BEGIN
		--정회원
		SELECT 
			@RES_CNT AS RES_CNT , 
			@MTG_CNT AS MTG_CNT , 
			@POINT_PRICE AS POINT_PRICE , 
			@INT_CNT AS INT_CNT, 
			@NOTICE_CNT AS NOTICE_CNT,
			@HISTORY_CNT AS HISTORY_CNT,

			@INQ_CNT AS INQ_CNT , 
			@POST_CNT AS POST_CNT , 
			@COMM_CNT AS COMM_CNT , 
			@VOC_CNT AS VOC_CNT , 

			CUS_ID , CUS_NO , CUS_NAME, LAST_NAME , FIRST_NAME , NOR_TEL1 , NOR_TEL2 , NOR_TEL3 , EMAIL , 
			DAMO.dbo.dec_varchar('DIABLO','dbo.CUS_CUSTOMER','PASS_NUM', A.SEC_PASS_NUM) AS PASS_NUM  , PASS_EXPIRE ,
			POINT_CONSENT 
		FROM CUS_MEMBER A WITH(NOLOCK) WHERE CUS_NO =@CUS_NO;
	END 
	ELSE 
	BEGIN
		--비회원
		SELECT 
			@RES_CNT AS RES_CNT , 
			@MTG_CNT AS MTG_CNT , 
			@POINT_PRICE AS POINT_PRICE , 
			@INT_CNT AS INT_CNT, 
			@NOTICE_CNT AS NOTICE_CNT,
			@HISTORY_CNT AS HISTORY_CNT,

			@INQ_CNT AS INQ_CNT , 
			@POST_CNT AS POST_CNT , 
			@COMM_CNT AS COMM_CNT , 
			@VOC_CNT AS VOC_CNT , 

			CUS_ID , CUS_NO , CUS_NAME, LAST_NAME , FIRST_NAME , NOR_TEL1 , NOR_TEL2 , NOR_TEL3 , EMAIL , 
			DAMO.dbo.dec_varchar('DIABLO','dbo.CUS_CUSTOMER','PASS_NUM', A.SEC_PASS_NUM) AS PASS_NUM  , PASS_EXPIRE ,
			POINT_CONSENT
		FROM CUS_CUSTOMER_damo A WITH(NOLOCK) WHERE CUS_NO =@CUS_NO;
	END 

END           



GO
