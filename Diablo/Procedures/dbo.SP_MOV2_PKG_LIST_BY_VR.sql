USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: [SP_MOV2_PKG_LIST_BY_VR]
■ DESCRIPTION				: VR 동영상 링크 정보 조회
■ INPUT PARAMETER			: @VR_NO@VR_NAME @VR_DESC @VR_CREATOR @nowPage	
■ EXEC						: 	
  [SP_MOV2_VR_BY_PKG_LIST] 	 		
							  		
■ MEMO						:	VR 동영상 링크 정보 조회.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY             		      
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-05-26	  아이비솔루션				최초생성
================================================================================================================*/ 
CREate PROCEDURE [dbo].[SP_MOV2_PKG_LIST_BY_VR]

	-- Add the parameters for the stored procedure here
	@VR_NO				INT	
AS
BEGIN
	 

  SELECT 
  Z.VR_NO
  ,Z.MASTER_CODE
  ,C.EVT_NAME
  ,C.EVT_SHORT_REMARK
  ,C.EVT_SEQ
  ,C.EVT_YN
  FROM VR_CONTENT AS Z
  INNER JOIN PKG_MASTER AS A ON Z.MASTER_CODE=A.MASTER_CODE
  INNER JOIN PUB_EVENT_DATA AS B ON A.MASTER_CODE=B.MASTER_CODE
  INNER JOIN PUB_EVENT AS C ON b.EVT_SEQ =c.EVT_SEQ
  
  WHERE A.NEXT_DATE >=GETDATE()
  AND B.SHOW_YN='Y'
  AND Z.VR_NO=@VR_NO

END
GO
