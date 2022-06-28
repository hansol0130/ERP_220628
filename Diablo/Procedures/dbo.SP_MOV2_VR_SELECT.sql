USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_MOV2_VR_INSERT
■ DESCRIPTION				: VR 동영상 링크 정보 조회
■ INPUT PARAMETER			: @VR_NO@VR_NAME @VR_DESC @VR_CREATOR @nowPage	
■ EXEC						: 	
    -- SP_MOV2_VR_SELECT 	 		
							  		
■ MEMO						:	VR 동영상 링크 정보 조회.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY             		      
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-05-26	  아이비솔루션				최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_VR_SELECT]

	-- Add the parameters for the stored procedure here
	@VR_NO				INT	,
	@VR_NAME			varchar(200),
	@VR_DESC			varchar(200),
	@nowPage			INT,
    @pageSize			INT,
	@VR_TYPE			INT,
	@REGION_CODE		char(3),	
	@TOTAL_COUNT		INT OUT
AS
BEGIN
    DECLARE @Start    INT=((@nowPage-1)*@pageSize)
	 
	SELECT
	*
	FROM VR_MASTER AS VM WITH(NOLOCK)
	WHERE 1=1
	AND(@VR_NO IS NULL OR @VR_NO='' OR VM.VR_NO=@VR_NO)
	AND(@VR_NAME IS NULL OR @VR_NAME='' OR VM.VR_NAME LIKE '%'+@VR_NAME+'%')
	AND(@VR_DESC IS NULL OR @VR_DESC='' OR VM.VR_DESC LIKE '%'+@VR_DESC+'%')
	AND(@VR_TYPE IS NULL OR @VR_TYPE='' OR VM.VR_TYPE=@VR_TYPE)
	AND(@REGION_CODE IS NULL OR @REGION_CODE='' OR VM.REGION_CODE=@REGION_CODE)
	ORDER BY VM.NEW_DATE DESC
	OFFSET @Start ROWS
	FETCH NEXT @pageSize ROWS ONLY

	SELECT @TOTAL_COUNT = COUNT(*)
	FROM VR_MASTER VM WITH(NOLOCK)
	WHERE 1=1
	AND(@VR_NO IS NULL OR @VR_NO='' OR VM.VR_NO=@VR_NO)
	AND(@VR_NAME IS NULL OR @VR_NAME='' OR VM.VR_NAME LIKE '%'+@VR_NAME+'%')
	AND(@VR_DESC IS NULL OR @VR_DESC='' OR VM.VR_DESC LIKE '%'+@VR_DESC+'%')
	AND(@VR_TYPE IS NULL OR @VR_TYPE='' OR VM.VR_TYPE=@VR_TYPE)
	AND(@REGION_CODE IS NULL OR @REGION_CODE='' OR VM.REGION_CODE=@REGION_CODE)

END
GO
