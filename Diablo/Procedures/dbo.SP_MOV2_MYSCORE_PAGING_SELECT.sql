USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: [[SP_MOV2_MYSCORE_PAGING_SELECT]]
■ DESCRIPTION				: 검색_나의상품평점수조회
■ INPUT PARAMETER			: @@CUSTOMER_NO @NOWPAGE @PAGESIZE @TOTAL_COUNT	
■ EXEC						: 

    -- EXEC SP_MOV2_MYSCORE_PAGING_SELECT  	 		
							  		
■ MEMO						:	나의상품평점수조회.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY             		      
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-05-26		아이비솔루션			최초생성
   2017-10-23		아이비솔루션			[COM_SEQ] 추가
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_MYSCORE_PAGING_SELECT]

	-- ADD THE PARAMETERS FOR THE STORED PROCEDURE HERE
	@CUSTOMER_NO	    INT,
	@NOWPAGE			INT,
    @PAGESIZE			INT,
	@TOTAL_COUNT		INT OUT
AS
BEGIN
    DECLARE @START INT = ((@NOWPAGE-1) * @PAGESIZE);

	WITH LIST AS (
		SELECT A.[MASTER_CODE]
			   ,A.[COM_SEQ]
		       ,A.[PRO_CODE]
			   ,A.CONTENTS
			   ,A.TITLE
			   ,A.GRADE
			   ,A.NEW_DATE
			   ,A.NICKNAME
		FROM [DIABLO].[DBO].[PRO_COMMENT] AS A
		WHERE
		1=1
		AND (@CUSTOMER_NO IS NULL OR @CUSTOMER_NO='' OR A.CUS_NO= @CUSTOMER_NO)
	)
	SELECT 
		A.*
		,B.MASTER_NAME
		,C.PRO_NAME
		,F.*
	FROM LIST AS A
	INNER JOIN PKG_MASTER AS B ON A.MASTER_CODE = B.MASTER_CODE 
	LEFT JOIN PKG_DETAIL AS C ON A.PRO_CODE=C.PRO_CODE
	LEFT JOIN INF_FILE_MASTER F ON B.MAIN_FILE_CODE =F.FILE_CODE
	ORDER BY A.NEW_DATE DESC
	OFFSET @START ROWS
	FETCH NEXT @PAGESIZE ROWS ONLY;

	SELECT @TOTAL_COUNT=COUNT(*) 
	FROM [DIABLO].[DBO].[PRO_COMMENT] AS A
	WHERE
	1=1
	AND(@CUSTOMER_NO IS NULL OR @CUSTOMER_NO='' OR A.CUS_NO= @CUSTOMER_NO)

END

GO
