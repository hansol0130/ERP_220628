USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_CUS_RECOMMEND_POINT_SELECT_CUSTOMER
■ DESCRIPTION				: 추천인 제도 포인트 한고객의 지급현황 내역 ( 추천받은 사람의 추천한 사람 리스트 내역 ) 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	XP_CUS_RECOMMEND_POINT_SELECT_CUSTOMER 10630091 
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-11-09		박형만			최초생성
================================================================================================================*/ 
create  PROC [dbo].[XP_CUS_RECOMMEND_POINT_SELECT_CUSTOMER]
	@CUS_NO INT  
AS 
BEGIN 

	-- 고유번호가 오게 되면 
	-- 해당 고유 번호를 추천한 가입자 리스트들을 보여줌 
	
	SELECT 
		ROW_NUMBER() OVER (ORDER BY A.REC_SEQ) AS [ROWNUMBER],
		A.REC_SEQ,A.REC_GRP_SEQ,A.CUS_TYPE,A.REC_TYPE,
		A.CUS_NO,A.POINT_NO,A.NEW_CODE,A.NEW_DATE,A.REMARK , 
		B.CUS_ID , 
		B.CUS_NAME , B.BIRTH_DATE, B.NOR_TEL1, B.NOR_TEL2, B.NOR_TEL3, 
		C.POINT_PRICE 
	FROM CUS_RECOMMEND A WITH(NOLOCK) 
		LEFT JOIN VIEW_MEMBER B 
			ON A.CUS_NO = B.CUS_NO 
		LEFT JOIN CUS_POINT C 
			ON A.POINT_NO  = C.POINT_NO 

	-- 추천한 사람의 
	-- 같은 적립 그룹 중에서 
	WHERE A.REC_GRP_SEQ IN ( SELECT REC_GRP_SEQ FROM CUS_RECOMMEND WHERE CUS_NO  = @CUS_NO AND CUS_TYPE = 2 )  -- 
	AND A.CUS_TYPE  =1  -- 가입자 (추천한사람) 
	ORDER BY A.REC_SEQ 

END 



GO
