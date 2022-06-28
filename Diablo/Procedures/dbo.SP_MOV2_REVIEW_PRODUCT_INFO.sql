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
    -- [SP_MOV2_REVIEW_PRODUCT_INFO] 	 		
							  		
■ MEMO						:	VR 동영상 링크 정보 조회.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY             		      
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-05-26	  아이비솔루션				최초생성
   2017-11-03		김성호					INNER JOIN -> LEFT JOIN 으로 수정
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_REVIEW_PRODUCT_INFO]

	-- Add the parameters for the stored procedure here
	@MS			varchar(20)
AS
BEGIN
    SELECT 
		A.MASTER_NAME, A.MASTER_CODE, B.*
	FROM PKG_MASTER A
	LEFT JOIN INF_FILE_MASTER B ON B.FILE_CODE = A.MAIN_FILE_CODE
	WHERE  A.MASTER_CODE = @MS OR A.MASTER_CODE IN (SELECT AA.MASTER_CODE FROM PKG_DETAIL AA WHERE AA.PRO_CODE = @MS)
END
GO
