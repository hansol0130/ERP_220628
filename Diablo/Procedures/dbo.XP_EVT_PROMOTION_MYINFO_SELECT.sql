USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_EVT_PROMOTION_MYINFO_SELECT
■ DESCRIPTION				: 프로모션 이벤트 내 글/등수 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC XP_EVT_PROMOTION_MYINFO_SELECT 11, '정지용', '010', '3444', '1147'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-05-18		정지용
================================================================================================================*/ 
CREATE PROC [dbo].[XP_EVT_PROMOTION_MYINFO_SELECT]
	@SEC_SEQ INT,
	@CUS_NAME VARCHAR(20),
	@NOR_TEL1 VARCHAR(4),
	@NOR_TEL2 VARCHAR(4),
	@NOR_TEL3 VARCHAR(4)
AS 
BEGIN	
	WITH LIST AS (	
		SELECT 	
			RANK() OVER (ORDER BY ISNULL(C.RC_CNT, 0) DESC ) AS [RANK],
			B.SEC_SEQ,
			B.CONTENTS,
			B.CUS_NAME,
			B.NOR_TEL1,
			B.NOR_TEL2,
			B.NOR_TEL3,
			ISNULL(C.RC_CNT, 0) AS RC_CNT,
			B.NEW_DATE
		FROM EVT_PROMOTION_MASTER A WITH(NOLOCK)
		INNER JOIN EVT_PROMOTION_DETAIL B WITH(NOLOCK) ON A.SEC_SEQ = B.SEC_SEQ
		LEFT JOIN (
			SELECT SEC_SEQ, SEQ_NO, COUNT(1) AS RC_CNT FROM EVT_PROMOTION_DETAIL_RECOMMENDED WITH(NOLOCK) GROUP BY SEC_SEQ, SEQ_NO
		) C ON B.SEC_SEQ = C.SEC_SEQ AND B.SEQ_NO = C.SEQ_NO
		WHERE A.SEC_SEQ = @SEC_SEQ AND B.DEL_YN = 'N'
	)
	SELECT 
		[RANK],
		CONTENTS,
		CUS_NAME,
		NOR_TEL1,
		NOR_TEL2,
		NOR_TEL3,
		RC_CNT,
		NEW_DATE
	FROM LIST
	WHERE CUS_NAME = @CUS_NAME AND NOR_TEL1 = @NOR_TEL1 AND NOR_TEL2 = @NOR_TEL2 AND NOR_TEL3 = @NOR_TEL3

END
GO
