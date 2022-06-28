USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: [SP_MOV2_CUS_PUSH_PAGING_SELECT]
■ DESCRIPTION				: 검색_푸시페이징조회
■ INPUT PARAMETER			: @nowPage @pageSize @CUSTOMER_NO @TOTAL_COUNT	
■ EXEC						: 	

   DECLARE	@TOTAL_COUNT INT OUT
   EXEC SP_MOV2_CUS_PUSH_PAGING_SELECT 1, 20, 4797216, @TOTAL_COUNT
   SELECT @TOTAL_COUNT
							  		
■ MEMO						: 푸시 페이징 조회
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY             		      
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-22	  아이비솔루션				최초생성
================================================================================================================*/ 
create PROCEDURE [dbo].[SP_MOV2_CUS_PUSH_PAGING_SELECT]

	@nowPage			INT,
    @pageSize			INT,
	@CUS_NO				INT,
	@TOTAL_COUNT		INT OUT
AS
BEGIN
    DECLARE @Start    INT=((@nowPage-1)*@pageSize)

	SELECT *
	FROM APP_MESSAGE A WITH (NOLOCK) 
	WHERE A.MSG_SEQ_NO IN ( 
		SELECT B.MSG_SEQ_NO FROM APP_RECEIVE B WITH (NOLOCK) WHERE B.CUS_NO = @CUS_NO
		)
	ORDER BY A.NEW_DATE DESC
	OFFSET @Start ROWS
	FETCH NEXT @pageSize ROWS ONLY

	SELECT @TOTAL_COUNT = COUNT(*) 
	FROM  APP_MESSAGE A WITH (NOLOCK) 
	WHERE A.MSG_SEQ_NO IN ( 
		SELECT B.MSG_SEQ_NO FROM APP_RECEIVE B WITH (NOLOCK) WHERE B.CUS_NO = @CUS_NO
		)

END
GO
