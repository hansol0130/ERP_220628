USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: [SP_MOV2_WEBZIN_PAGING_SELECT]
■ DESCRIPTION				: VR 동영상 링크 정보 조회
■ INPUT PARAMETER			: @VR_NO@VR_NAME @VR_DESC @VR_CREATOR @nowPage	
■ EXEC						: 

	DECLARE @TOTAL_COUNT INT
    exec SP_MOV2_WEBZIN_PAGING_SELECT 'COUNT', 2, 10, 'N', '', @TOTAL_COUNT OUT
	SELECT @TOTAL_COUNT
							  		
■ MEMO						:	VR 동영상 링크 정보 조회.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY             		      
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-05-26		아이비솔루션				최초생성
   2017-10-20		김성호					현재 기준 사용하는 곳 없음
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_WEBZIN_PAGING_SELECT]

	-- Add the parameters for the stored procedure here
	@ORDER			varchar(200),
	@nowPage			INT,
    @pageSize			INT,
	@NTYPE				CHAR(2),
	@DEL_YN				CHAR(2),
	@TOTAL_COUNT		INT OUT
AS
BEGIN

    DECLARE @Start    INT=((@nowPage-1)*@pageSize)

	SELECT 
	A.BOARD_SEQ
	,A.MASTER_SEQ
	,A.SUBJECT
	,A.CONTENTS
	,A.SHOW_COUNT
	FROM HBS_DETAIL AS A WITH(NOLOCK)
	WHERE 1=1
	AND (@NTYPE IS NULL OR @NTYPE ='' OR A.NOTICE_YN = @NTYPE)
	AND (@DEL_YN IS NULL OR @DEL_YN ='' OR A.DEL_YN = @DEL_YN)
	ORDER BY CASE @ORDER WHEN N'COUNT' THEN SHOW_COUNT
						 ELSE NEW_DATE END  DESC
	OFFSET @Start ROWS
	FETCH NEXT @pageSize ROWS ONLY


	SELECT @TOTAL_COUNT=COUNT(*) 
	FROM HBS_DETAIL AS A WITH(NOLOCK)
	WHERE 1=1
	AND (@NTYPE IS NULL OR @NTYPE ='' OR A.NOTICE_YN = @NTYPE)
	AND (@DEL_YN IS NULL OR @DEL_YN ='' OR A.DEL_YN = @DEL_YN)

END
GO
