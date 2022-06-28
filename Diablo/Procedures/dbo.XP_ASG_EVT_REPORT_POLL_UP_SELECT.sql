USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 /*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_REPORT_POLL_UP_SELECT
■ DESCRIPTION				: 대외업무시스템 인솔자관리 출장보고서 POLL 리스트 수정시 검색
■ INPUT PARAMETER			: 
	@POL_TYPE CHAR(1)		:  전체평가 = 1, 가이드평가 = 2, 호텔평가 = 3, 식사평가 = 4, 고객평가 = 5, 이벤트 = 6
	@PRO_CODE	VARCHAR(20)
■ OUTPUT PARAMETER			: 

■ EXEC						: 
	DECLARE @POL_TYPE CHAR(1),@PRO_CODE	VARCHAR(20)
	SELECT @POL_TYPE='4', @PRO_CODE='CPP456-130503'

	exec XP_ASG_EVT_REPORT_POLL_UP_SELECT @POL_TYPE ,@PRO_CODE

	select * from otr_pol_master
	select * from otr_pol_answer where otr_pol_master_seq = '5427'
	delete from otr_pol_master where otr_pol_master_seq = '5425'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-11		오인규			최초생성   
   2014-03-07		이동호			AGT_NAME 컬럼 랜드사명 추가       
================================================================================================================*/ 
CREATE  PROCEDURE [dbo].[XP_ASG_EVT_REPORT_POLL_UP_SELECT]
(
	@POL_TYPE	CHAR(1),
	@PRO_CODE	VARCHAR(20)
)

AS  
BEGIN
	
	DECLARE @OTR_SEQ INT
	SELECT	@OTR_SEQ = OTR_SEQ
    FROM	dbo.OTR_MASTER WITH(NOLOCK)
	WHERE	PRO_CODE = @PRO_CODE

	IF @POL_TYPE = '1'
	BEGIN

		
		SELECT 
			   OTR_POL_MASTER_SEQ AS MASTER_SEQ  --  
			 --, OTR_SEQ                        --  
			 , TARGET                         --  
			 , POL_TYPE                       -- 
			 , '1' AS POL_STATE 
			 , SUBJECT                        --  
			 , POL_DESC                       --  
		  FROM dbo.OTR_POL_MASTER  WITH(NOLOCK)
		 WHERE OTR_SEQ = @OTR_SEQ
		 AND   POL_TYPE = @POL_TYPE  --PollTypeEnum { 전체평가 = 1, 가이드평가 = 2, 호텔평가 = 3, 식사평가 = 4, 고객평가 = 5, 이벤트 = 6 };
	

	 
	SELECT		A.OTR_POL_MASTER_SEQ AS MASTER_SEQ
				,B.OTR_POL_QUESTION_SEQ AS QUESTION_SEQ
				,B.QUESTION_TITLE
				,B.QUS_TYPE
				,C.OTR_POL_EXAMPLE_SEQ AS EXAMPLE_SEQ
				,C.EXAMPLE_DESC
				,D.OTR_POL_ANSWER_SEQ AS ANSWER_SEQ
				,CASE WHEN B.QUS_TYPE ='2' THEN D.ANSWER_TEXT ELSE   Convert(NVARCHAR(100),D.OTR_POL_EXAMPLE_SEQ)  END  AS ANSWER_VALUE
	  FROM	dbo.OTR_POL_MASTER A WITH(NOLOCK)
	  INNER JOIN dbo.OTR_POL_QUESTION B WITH(NOLOCK) ON A.OTR_POL_MASTER_SEQ = B.OTR_POL_MASTER_SEQ
	  INNER JOIN dbo.OTR_POL_DETAIL C WITH(NOLOCK) ON B.OTR_POL_MASTER_SEQ = C.OTR_POL_MASTER_SEQ AND B.OTR_POL_QUESTION_SEQ = C.OTR_POL_QUESTION_SEQ
	  LEFT OUTER JOIN dbo.OTR_POL_ANSWER D WITH(NOLOCK) ON C.OTR_POL_MASTER_SEQ = D.OTR_POL_MASTER_SEQ  AND C.OTR_POL_QUESTION_SEQ =  D.OTR_POL_QUESTION_SEQ --AND C.OTR_POL_EXAMPLE_SEQ = D.OTR_POL_EXAMPLE_SEQ            
	  WHERE A.OTR_SEQ = @OTR_SEQ
	  AND	A.POL_TYPE = @POL_TYPE  --PollTypeEnum { 전체평가 = 1, 가이드평가 = 2, 호텔평가 = 3, 식사평가 = 4, 고객평가 = 5, 이벤트 = 6 };
	 
		SELECT '' AS NOTABLE
	END
	ELSE IF @POL_TYPE = '2'
	BEGIN
			
		SELECT 
			   OTR_POL_MASTER_SEQ AS MASTER_SEQ  --  
			 --, OTR_SEQ                        --  
			 , TARGET                         --  
			 , POL_TYPE                       -- 
			 , '1' AS POL_STATE 
			 , SUBJECT                        --  
			 , POL_DESC                       --  
		  FROM dbo.OTR_POL_MASTER  WITH(NOLOCK)
		 WHERE OTR_SEQ = @OTR_SEQ
		 AND   POL_TYPE = @POL_TYPE  --PollTypeEnum { 전체평가 = 1, 가이드평가 = 2, 호텔평가 = 3, 식사평가 = 4, 고객평가 = 5, 이벤트 = 6 };
	

	 
	SELECT		A.OTR_POL_MASTER_SEQ AS MASTER_SEQ
				,B.OTR_POL_QUESTION_SEQ AS QUESTION_SEQ
				,B.QUESTION_TITLE
				,B.QUS_TYPE
				,C.OTR_POL_EXAMPLE_SEQ AS EXAMPLE_SEQ
				,C.EXAMPLE_DESC
				,D.OTR_POL_ANSWER_SEQ AS ANSWER_SEQ
				,CASE WHEN B.QUS_TYPE ='2' THEN D.ANSWER_TEXT ELSE  Convert(NVARCHAR(100),D.OTR_POL_EXAMPLE_SEQ) END  AS ANSWER_VALUE
	  FROM	dbo.OTR_POL_MASTER A WITH(NOLOCK)
	  INNER JOIN dbo.OTR_POL_QUESTION B WITH(NOLOCK) ON A.OTR_POL_MASTER_SEQ = B.OTR_POL_MASTER_SEQ
	  INNER JOIN dbo.OTR_POL_DETAIL C WITH(NOLOCK) ON B.OTR_POL_MASTER_SEQ = C.OTR_POL_MASTER_SEQ AND B.OTR_POL_QUESTION_SEQ = C.OTR_POL_QUESTION_SEQ
	  LEFT OUTER JOIN dbo.OTR_POL_ANSWER D WITH(NOLOCK) ON C.OTR_POL_MASTER_SEQ = D.OTR_POL_MASTER_SEQ  AND C.OTR_POL_QUESTION_SEQ =  D.OTR_POL_QUESTION_SEQ --AND C.OTR_POL_EXAMPLE_SEQ = D.OTR_POL_EXAMPLE_SEQ            
	  WHERE A.OTR_SEQ = @OTR_SEQ
	  AND	A.POL_TYPE = @POL_TYPE  --PollTypeEnum { 전체평가 = 1, 가이드평가 = 2, 호텔평가 = 3, 식사평가 = 4, 고객평가 = 5, 이벤트 = 6 };
	 
	
			-- 가이드 평가/일정별 지역

	  SELECT A.OTR_POL_MASTER_SEQ AS MASTER_SEQ
				,A.OTR_DATE1
				,A.OTR_DATE2                      --  
				,ROW_NUMBER() OVER(ORDER BY A.OTR_SEQ) AS DAY_SEQ
				,A.OTR_CITY                       --  
				,A.AGT_CODE				
				,(CASE WHEN A.AGT_CODE IS NULL THEN B.KOR_NAME ELSE A.AGT_NAME END ) AS AGT_NAME 
				,A.GUIDE_NAME
				,A.MEM_CODE
		  FROM	dbo.OTR_POL_MASTER A WITH(NOLOCK)
		  LEFT OUTER JOIN dbo.AGT_MASTER B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE
		 WHERE	A.OTR_SEQ = @OTR_SEQ
		 AND	A.POL_TYPE = @POL_TYPE  --PollTypeEnum { 전체평가 = 1, 가이드평가 = 2, 호텔평가 = 3, 식사평가 = 4, 고객평가 = 5, 이벤트 = 6 };
		 ORDER BY A.OTR_DATE1 -- A.OTR_SEQ

	END

	ELSE IF @POL_TYPE = '3'
	BEGIN

	
		SELECT 
			   OTR_POL_MASTER_SEQ AS MASTER_SEQ  --  
			 --, OTR_SEQ                        --  
			 , TARGET                         --  
			 , POL_TYPE                       -- 
			 , '1' AS POL_STATE 
			 , SUBJECT                        --  
			 , POL_DESC                       --  
		  FROM dbo.OTR_POL_MASTER WITH(NOLOCK)
		 WHERE OTR_SEQ = @OTR_SEQ
		 AND   POL_TYPE = @POL_TYPE  --PollTypeEnum { 전체평가 = 1, 가이드평가 = 2, 호텔평가 = 3, 식사평가 = 4, 고객평가 = 5, 이벤트 = 6 };
	

	 
	SELECT		A.OTR_POL_MASTER_SEQ AS MASTER_SEQ
				,B.OTR_POL_QUESTION_SEQ AS QUESTION_SEQ
				,B.QUESTION_TITLE
				,B.QUS_TYPE
				,C.OTR_POL_EXAMPLE_SEQ AS EXAMPLE_SEQ
				,C.EXAMPLE_DESC
				,D.OTR_POL_ANSWER_SEQ AS ANSWER_SEQ
				,CASE WHEN B.QUS_TYPE ='2' THEN D.ANSWER_TEXT ELSE Convert(NVARCHAR(100),D.OTR_POL_EXAMPLE_SEQ)  END  AS ANSWER_VALUE
	  FROM	dbo.OTR_POL_MASTER A WITH(NOLOCK)
	  INNER JOIN dbo.OTR_POL_QUESTION B WITH(NOLOCK) ON A.OTR_POL_MASTER_SEQ = B.OTR_POL_MASTER_SEQ
	  INNER JOIN dbo.OTR_POL_DETAIL C WITH(NOLOCK) ON B.OTR_POL_MASTER_SEQ = C.OTR_POL_MASTER_SEQ AND B.OTR_POL_QUESTION_SEQ = C.OTR_POL_QUESTION_SEQ
	  LEFT OUTER JOIN dbo.OTR_POL_ANSWER D WITH(NOLOCK) ON C.OTR_POL_MASTER_SEQ = D.OTR_POL_MASTER_SEQ  AND C.OTR_POL_QUESTION_SEQ =  D.OTR_POL_QUESTION_SEQ --AND C.OTR_POL_EXAMPLE_SEQ = D.OTR_POL_EXAMPLE_SEQ            
	  WHERE A.OTR_SEQ = @OTR_SEQ
	  AND	A.POL_TYPE = @POL_TYPE  --PollTypeEnum { 전체평가 = 1, 가이드평가 = 2, 호텔평가 = 3, 식사평가 = 4, 고객평가 = 5, 이벤트 = 6 };
	 
	
			-- 가이드 평가/일정별 지역
			 SELECT 
				A.OTR_POL_MASTER_SEQ AS MASTER_SEQ
				,A.OTR_DATE1
				,A.OTR_DATE2                      --  
				,ROW_NUMBER() OVER(ORDER BY A.OTR_SEQ) AS DAY_SEQ
				,A.OTR_CITY                       --  
				,A.AGT_CODE				
				,A.HOTEL_NAME
				,(CASE WHEN A.AGT_CODE IS NULL THEN B.KOR_NAME ELSE A.AGT_NAME END ) AS AGT_NAME 
		  FROM	dbo.OTR_POL_MASTER A WITH(NOLOCK)
		  LEFT OUTER JOIN dbo.AGT_MASTER B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE
		 WHERE	A.OTR_SEQ = @OTR_SEQ
		 AND	A.POL_TYPE = @POL_TYPE  --PollTypeEnum { 전체평가 = 1, 가이드평가 = 2, 호텔평가 = 3, 식사평가 = 4, 고객평가 = 5, 이벤트 = 6 };
		 ORDER BY A.OTR_DATE1 --A.OTR_SEQ

		
	END
	ELSE IF @POL_TYPE = '4'
	BEGIN

	 
		SELECT 
			   OTR_POL_MASTER_SEQ AS MASTER_SEQ  --  
			 --, OTR_SEQ                        --  
			 , TARGET                         --  
			 , POL_TYPE                       -- 
			 , '1' AS POL_STATE 
			 , SUBJECT                        --  
			 , POL_DESC                       --  
		  FROM dbo.OTR_POL_MASTER  WITH(NOLOCK)
		 WHERE OTR_SEQ = @OTR_SEQ
		 AND   POL_TYPE = @POL_TYPE  --PollTypeEnum { 전체평가 = 1, 가이드평가 = 2, 호텔평가 = 3, 식사평가 = 4, 고객평가 = 5, 이벤트 = 6 };
	

	 
	SELECT		A.OTR_POL_MASTER_SEQ AS MASTER_SEQ
				,B.OTR_POL_QUESTION_SEQ AS QUESTION_SEQ
				,B.QUESTION_TITLE
				,B.QUS_TYPE
				,C.OTR_POL_EXAMPLE_SEQ AS EXAMPLE_SEQ
				,C.EXAMPLE_DESC
				,D.OTR_POL_ANSWER_SEQ AS ANSWER_SEQ
				,CASE WHEN B.QUS_TYPE ='2' THEN D.ANSWER_TEXT ELSE  Convert(NVARCHAR(100),D.OTR_POL_EXAMPLE_SEQ)  END  AS ANSWER_VALUE
	  FROM	dbo.OTR_POL_MASTER A WITH(NOLOCK)
	  INNER JOIN dbo.OTR_POL_QUESTION B WITH(NOLOCK) ON A.OTR_POL_MASTER_SEQ = B.OTR_POL_MASTER_SEQ
	  INNER JOIN dbo.OTR_POL_DETAIL C WITH(NOLOCK) ON B.OTR_POL_MASTER_SEQ = C.OTR_POL_MASTER_SEQ AND B.OTR_POL_QUESTION_SEQ = C.OTR_POL_QUESTION_SEQ
	  LEFT OUTER JOIN dbo.OTR_POL_ANSWER D WITH(NOLOCK) ON C.OTR_POL_MASTER_SEQ = D.OTR_POL_MASTER_SEQ  AND C.OTR_POL_QUESTION_SEQ =  D.OTR_POL_QUESTION_SEQ --AND C.OTR_POL_EXAMPLE_SEQ = D.OTR_POL_EXAMPLE_SEQ            
	  WHERE A.OTR_SEQ = @OTR_SEQ
	  AND	A.POL_TYPE = @POL_TYPE  --PollTypeEnum { 전체평가 = 1, 가이드평가 = 2, 호텔평가 = 3, 식사평가 = 4, 고객평가 = 5, 이벤트 = 6 };
	 

			-- 가이드 평가/일정별 지역
			 SELECT 
				A.OTR_POL_MASTER_SEQ AS MASTER_SEQ
				,A.OTR_DATE1
				,A.OTR_DATE2                      --  
				,ROW_NUMBER() OVER(ORDER BY A.OTR_SEQ) AS DAY_SEQ
				,A.OTR_CITY                       --  
				,A.AGT_CODE
				,A.MEAL_TYPE                      --  
				,A.RESTAURANT_NAME                --  
				,(CASE WHEN A.AGT_CODE IS NULL THEN B.KOR_NAME ELSE A.AGT_NAME END ) AS AGT_NAME 
		  FROM	dbo.OTR_POL_MASTER A WITH(NOLOCK)
		  LEFT OUTER JOIN dbo.AGT_MASTER B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE
		 WHERE	A.OTR_SEQ = @OTR_SEQ
		 AND	A.POL_TYPE = @POL_TYPE  --PollTypeEnum { 전체평가 = 1, 가이드평가 = 2, 호텔평가 = 3, 식사평가 = 4, 고객평가 = 5, 이벤트 = 6 };
		 ORDER BY A.OTR_DATE1,A.MEAL_TYPE  --A.OTR_SEQ

	END
	ELSE IF @POL_TYPE = '5'
	BEGIN

	 
		SELECT 
			   OTR_POL_MASTER_SEQ AS MASTER_SEQ  --  
			 --, OTR_SEQ                        --  
			 , TARGET                         --  
			 , POL_TYPE                       -- 
			 , '1' AS POL_STATE 
			 , SUBJECT                        --  
			 , POL_DESC                       --  
		  FROM dbo.OTR_POL_MASTER WITH(NOLOCK)
		 WHERE OTR_SEQ = @OTR_SEQ
		 AND   POL_TYPE = @POL_TYPE  --PollTypeEnum { 전체평가 = 1, 가이드평가 = 2, 호텔평가 = 3, 식사평가 = 4, 고객평가 = 5, 이벤트 = 6 };
	

	 
	SELECT		A.OTR_POL_MASTER_SEQ AS MASTER_SEQ
				,B.OTR_POL_QUESTION_SEQ AS QUESTION_SEQ
				,B.QUESTION_TITLE
				,B.QUS_TYPE
				,C.OTR_POL_EXAMPLE_SEQ AS EXAMPLE_SEQ
				,C.EXAMPLE_DESC
				,D.OTR_POL_ANSWER_SEQ AS ANSWER_SEQ
				,CASE WHEN B.QUS_TYPE ='2' THEN D.ANSWER_TEXT ELSE  Convert(NVARCHAR(100),D.OTR_POL_EXAMPLE_SEQ)  END  AS ANSWER_VALUE
	  FROM	dbo.OTR_POL_MASTER A WITH(NOLOCK)
	  INNER JOIN dbo.OTR_POL_QUESTION B WITH(NOLOCK) ON A.OTR_POL_MASTER_SEQ = B.OTR_POL_MASTER_SEQ
	  INNER JOIN dbo.OTR_POL_DETAIL C WITH(NOLOCK) ON B.OTR_POL_MASTER_SEQ = C.OTR_POL_MASTER_SEQ AND B.OTR_POL_QUESTION_SEQ = C.OTR_POL_QUESTION_SEQ
	  LEFT OUTER JOIN dbo.OTR_POL_ANSWER D WITH(NOLOCK) ON C.OTR_POL_MASTER_SEQ = D.OTR_POL_MASTER_SEQ  AND C.OTR_POL_QUESTION_SEQ =  D.OTR_POL_QUESTION_SEQ --AND C.OTR_POL_EXAMPLE_SEQ = D.OTR_POL_EXAMPLE_SEQ            
	  WHERE A.OTR_SEQ = @OTR_SEQ
	  AND	A.POL_TYPE = @POL_TYPE  --PollTypeEnum { 전체평가 = 1, 가이드평가 = 2, 호텔평가 = 3, 식사평가 = 4, 고객평가 = 5, 이벤트 = 6 };
	 

			-- 가이드 평가/일정별 지역
			 SELECT 
				A.OTR_POL_MASTER_SEQ AS MASTER_SEQ
				,A.OTR_DATE1
				,A.OTR_DATE2                      --  
				,ROW_NUMBER() OVER(ORDER BY A.OTR_SEQ) AS DAY_SEQ
				,A.CLIENT_NAME                --  
				,A.CLIENT_TEL                --  
				,A.CLIENT_CALL_YN                --  
		  FROM	dbo.OTR_POL_MASTER  A WITH(NOLOCK)
		 WHERE	A.OTR_SEQ = @OTR_SEQ
		 AND	A.POL_TYPE = @POL_TYPE  --PollTypeEnum { 전체평가 = 1, 가이드평가 = 2, 호텔평가 = 3, 식사평가 = 4, 고객평가 = 5, 이벤트 = 6 };
		 ORDER BY A.OTR_SEQ

	END

END
GO
