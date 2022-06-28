USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: [SP_MOV2_CUS_CUVE_PAGING_SELECT]
■ DESCRIPTION				: 큐브 페이징 조회
■ INPUT PARAMETER			: @nowPage @pageSize @CUSTOMER_NO @TOTAL_COUNT	
■ EXEC						: 	
    -- [[[SP_MOV2_CUS_CUVE_PAGING_SELECT]]] 	 		
							  		
■ MEMO						: 큐브 페이징 조회
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY             		      
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-05-26	  아이비솔루션				최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_SLIME_CUS_CUVE_PAGING_SELECT]

	-- Add the parameters for the stored procedure here
	@nowPage			INT,
    @pageSize			INT,
	@CUSTOMER_NO		INT,
	@TOTAL_COUNT		INT OUT
AS
BEGIN
    DECLARE @Start    INT=((@nowPage-1)*@pageSize)

		SELECT 
			*
		FROM CUVE AS A WITH(NOLOCK)
		WHERE A.CUS_NO=@CUSTOMER_NO
		ORDER BY A.SEND_DATE DESC
		OFFSET @Start ROWS
		FETCH NEXT @pageSize ROWS ONLY


		SELECT @TOTAL_COUNT=COUNT(*) 
		FROM  CUVE AS A WITH(NOLOCK)
		WHERE A.CUS_NO=@CUSTOMER_NO
END
GO
