USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_CUVE_LIST_SELECT
■ DESCRIPTION				: 검색_큐비페이지별목록
■ INPUT PARAMETER			: CUS_NO, PAGE_INDEX, PAGE_SIZE
■ EXEC						: 
    -- exec SP_MOV2_CUVE_LIST_SELECT 998899301, 1, 20


	
		SELECT *
		FROM CUVE A WITH(NOLOCK)

■ MEMO						: 큐비페이지별목록
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-07-27		오준욱(IBSOLUTION)		최초생성
   2017-10-10		김성호					오류 최적화
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_CUVE_LIST_SELECT]
	@CUS_NO			INT,
	@PAGE_INDEX		INT,
	@PAGE_SIZE		INT
AS
BEGIN






	--WITH LIST AS
	--(
	--	SELECT CUVE_NO
	--	FROM CUVE A WITH(NOLOCK)
	--	WHERE A.CUS_NO = @CUS_NO
	--	ORDER BY A.SEND_DATE
	--	OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
	--	ROWS ONLY
	--)
	--SELECT A.*, C.CUR_ITEM, C.CUR_LINK
	--FROM LIST Z
	--INNER JOIN CUVE A WITH(NOLOCK) ON Z.CUVE_NO = Z.CUVE_NO
	--LEFT JOIN CUVE_HISTORY B ON A.HIS_NO = B.HIS_NO
	--LEFT JOIN CUR_INFO C ON B.CUR_NO = C.CUR_NO;
	

	SELECT P1.* FROM (	
		SELECT ROW_NUMBER() OVER (ORDER BY A1.SEND_DATE DESC ) AS ROWNUM, * 
		FROM ( 	
			SELECT A.*, C.CUR_ITEM, C.CUR_LINK
			FROM CUVE A WITH(NOLOCK)
			LEFT JOIN CUVE_HISTORY B ON A.HIS_NO = B.HIS_NO
			LEFT JOIN CUR_INFO C ON B.CUR_NO = C.CUR_NO
			WHERE CUS_NO = @CUS_NO
		) A1
	) P1
	WHERE P1.ROWNUM BETWEEN (@PAGE_INDEX - 1) * @PAGE_SIZE + 1 AND @PAGE_INDEX  * @PAGE_SIZE;

END           



GO
