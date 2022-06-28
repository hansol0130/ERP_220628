USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: [SP_MOV2_VR_REGION_COUNT]
■ DESCRIPTION				: VR 동영상 링크 정보 조회
■ INPUT PARAMETER			: @VR_NO@VR_NAME @VR_DESC @VR_CREATOR @nowPage	
■ EXEC						: 	
    -- [SP_MOV2_VR_REGION_COUNT] 	 		
							  		
■ MEMO						:	VR 동영상 지역별 카운트.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY             		      
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-05-26	  아이비솔루션				최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_VR_REGION_COUNT]

	-- Add the parameters for the stored procedure here
	@TOTAL_COUNT	INT OUT,
	@VR_TYPE		INT	
AS
BEGIN
	 
	SELECT
	VM.REGION_CODE
	,COUNT(*) AS VR_COUNT
	FROM VR_MASTER AS VM WITH(NOLOCK)
	WHERE 1=1
	AND(@VR_TYPE IS NULL OR @VR_TYPE='' OR VM.VR_TYPE=@VR_TYPE)
	GROUP BY VM.REGION_CODE 

	SELECT @TOTAL_COUNT = COUNT(*)
	FROM VR_MASTER AS VM WITH(NOLOCK)
	WHERE 1=1
	AND(@VR_TYPE IS NULL OR @VR_TYPE='' OR VM.VR_TYPE=@VR_TYPE)

END
GO
