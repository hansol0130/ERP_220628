USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_EVT_PROMOTION_SHARE_TOTAL_LIST
■ DESCRIPTION				: 프로모션 이벤트 쉐어 리스트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	declare @p5 int, @p6 int, @p7 int, @p8 int
	set @p5=NULL
	set @p6=NULL
	set @p7=NULL
	set @p8=NULL
	exec SP_EVT_PROMOTION_SHARE_TOTAL_LIST @PAGE_INDEX=1,@PAGE_SIZE=20,@KEY=N'secSeq=11&startDate=2017-05-11&endDate=2017-05-13',@ORDER_BY=0,@TOTAL_COUNT=@p5 output, @FB_COUNT=@p6 output, @TW_COUNT=@p7 output, @KAKAO_COUNT=@p8 output
	select @p5 as 카운트, @p6 as 페북, @p7 as 트위터, @p8 as 카카오
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2017-05-12		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_EVT_PROMOTION_SHARE_TOTAL_LIST]
 	@PAGE_INDEX  INT,
	@PAGE_SIZE  INT,
	@KEY	varchar(200),
	@ORDER_BY	int,
	@TOTAL_COUNT INT OUTPUT,
	@FB_COUNT INT OUTPUT,
	@TW_COUNT INT OUTPUT,
	@KAKAO_COUNT INT OUTPUT
AS 
BEGIN
	DECLARE @SEC_SEQ INT;
 	DECLARE @START_DATE VARCHAR(10);
	DECLARE @END_DATE VARCHAR(10);

	SELECT
		@SEC_SEQ = DBO.FN_PARAM(@KEY, 'secSeq'),
		@START_DATE = DBO.FN_PARAM(@KEY, 'startDate'),
		@END_DATE = DBO.FN_PARAM(@KEY, 'endDate');

	-- 총 카운트 조회
	SELECT 
		@TOTAL_COUNT = COUNT(1)
	FROM (
		SELECT CONVERT(VARCHAR(10), NEW_DATE, 102) AS NEW_DATE FROM EVT_PROMOTION_DETAIL_SHARE WITH(NOLOCK)
		WHERE 
			SEC_SEQ = @SEC_SEQ
			AND (@START_DATE = '' OR NEW_DATE >= @START_DATE + ' 00:00:00') AND (@END_DATE = '' OR NEW_DATE <= @END_DATE + ' 23:59:59')
		GROUP BY CONVERT(VARCHAR(10), NEW_DATE, 102)
	) A;

	-- 리스트 조회
	WITH LIST1 AS(
		SELECT
			SEC_SEQ, SEQ_NO, CUS_NO, SHARE_NAME, IPADDRESS, NEW_DATE
		FROM EVT_PROMOTION_DETAIL_SHARE WITH(NOLOCK)
		WHERE 
			SEC_SEQ = @SEC_SEQ
			AND (@START_DATE = '' OR NEW_DATE >= @START_DATE + ' 00:00:00') AND (@END_DATE = '' OR NEW_DATE <= @END_DATE + ' 23:59:59')
	),
	LIST2 AS (
		SELECT 
			SEC_SEQ,
			CONVERT(VARCHAR(10), NEW_DATE, 102) AS NEW_DATE,
			CASE 
				WHEN SHARE_NAME = 'FACEBOOK' THEN COUNT(1) ELSE 0 END AS FACEBOOK,
			CASE 
				WHEN SHARE_NAME = 'TWITTER' THEN COUNT(1) ELSE 0 END AS TWITTER,
			CASE 
				WHEN SHARE_NAME = 'KAKAO' THEN COUNT(1) ELSE 0 END AS KAKAO
		FROM LIST1
		GROUP BY 
			SEC_SEQ, CONVERT(VARCHAR(10), NEW_DATE, 102), SHARE_NAME
	)
	SELECT 
		NEW_DATE, FACEBOOK, TWITTER, KAKAO
	FROM (
		SELECT 
			NEW_DATE,
			SUM(FACEBOOK) AS FACEBOOK,
			SUM(TWITTER) AS TWITTER,
			SUM(KAKAO) AS KAKAO		
		FROM LIST2
		GROUP BY NEW_DATE	
	) A
	ORDER BY NEW_DATE DESC
	OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
	ROWS ONLY;

	-- 각 소셜 별 총 카운트
	SELECT 
		@FB_COUNT = SUM(CASE WHEN SHARE_NAME = 'FACEBOOK' THEN 1 ELSE 0 END),
		@TW_COUNT = SUM(CASE WHEN SHARE_NAME = 'TWITTER' THEN 1 ELSE 0 END),
		@KAKAO_COUNT = SUM(CASE WHEN SHARE_NAME = 'KAKAO' THEN 1 ELSE 0 END)
	FROM EVT_PROMOTION_DETAIL_SHARE WITH(NOLOCK);
END


GO
