USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_MEMBER_BOARD_INFO_SELECT
■ DESCRIPTION				: 검색_마이페이지게시글정보
■ INPUT PARAMETER			: CUS_NO
■ EXEC						: 
    -- exec SP_MOV2_MEMBER_BOARD_INFO_SELECT 4797216

■ MEMO						: 마이페이지게시글정보
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-08-04		오준욱(IBSOLUTION)		최초생성
   2017-11-!5		박형만			상품평은 CONTENTS 를 SUBJECT 로 
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_MEMBER_BOARD_INFO_SELECT]
	@CUS_NO			INT
AS
BEGIN

	SELECT * FROM (
		SELECT 2 AS NUM, * FROM (
			SELECT TOP 5 * FROM (
				-- 1:1 문의 , 여행후기 , 고객의소리
				SELECT 'NO' AS MASTER_CODE, 0 AS COM_SEQ, H.MASTER_SEQ, H.BOARD_SEQ, H.SUBJECT, H.NEW_DATE 
				FROM HBS_DETAIL H WITH(NOLOCK) 
				WHERE H.MASTER_SEQ IN(1, 4, 12, 19, 24) AND H.NEW_CODE = CONVERT(VARCHAR,@CUS_NO)
				AND H.DEL_YN ='N' 	
	
				UNION

				-- 상품평
				SELECT P.MASTER_CODE, P.COM_SEQ, 0 AS MASTER_SEQ, 0 AS BOARD_SEQ, 
				CASE WHEN LEN(P.CONTENTS) > 50 THEN SUBSTRING(P.CONTENTS,1,50) ELSE P.CONTENTS END AS [SUBJECT] ,
				P.NEW_DATE 
				FROM PRO_COMMENT P WITH(NOLOCK) 
				WHERE 1 = 1 AND P.CUS_NO = @CUS_NO
			) A
			ORDER BY A.NEW_DATE DESC
		) B

		UNION

		SELECT 3 AS NUM, * FROM (
			-- 공지사항
			SELECT TOP 1 'NO' AS MASTER_CODE, 0 AS COM_SEQ, H.MASTER_SEQ, H.BOARD_SEQ, H.SUBJECT, H.NEW_DATE 
			FROM HBS_DETAIL H WITH(NOLOCK) 
			WHERE H.MASTER_SEQ = 3 
			AND H.DEL_YN ='N' 	
			ORDER BY NEW_DATE DESC
		) C
	) D
	ORDER BY NUM, NEW_DATE DESC


END           
GO
