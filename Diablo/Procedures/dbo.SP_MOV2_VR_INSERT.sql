USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_MOV2_VR_INSERT
■ DESCRIPTION				: VR 동영상 링크 정보 입력.
■ INPUT PARAMETER			: @VR_NAME	@VR_DESC @VR_CREATOR @VR_LINK @VR_THUMBNAIL @NEW_CODE @NEW_DATE
■ EXEC						: 	
    -- SP_MOV2_VR_INSERT 	 		
							  		
■ MEMO						:	VR 동영상 링크 정보 입력.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY             		      
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-05-26	  아이비솔루션				최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_VR_INSERT]

	-- Add the parameters for the stored procedure here
	@VR_NAME			varchar(200),
	@VR_DESC			varchar(200),
	@VR_CREATOR			VARCHAR(20),
	@VR_LINK			varchar(200),
	@VR_THUMBNAIL		varchar(200),
	@NEW_CODE			char(7),
	@NEW_DATE			datetime ,
	@REGION_CODE		char(3),
	@VR_TYPE			int	
	
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO VR_MASTER(VR_NAME, VR_DESC, VR_CREATOR,VR_LINK,VR_THUMBNAIL,NEW_CODE,NEW_DATE, REGION_CODE, VR_TYPE)
		 OUTPUT INSERTED.*
	VALUES(@VR_NAME, @VR_DESC,@VR_CREATOR,@VR_LINK,@VR_THUMBNAIL,@NEW_CODE,GETDATE(),@REGION_CODE,@VR_TYPE)
END


GO
