USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_CURATION_RECEIVE_PAGING_SELECT
■ DESCRIPTION				: 검색_큐레이션수신정보_페이징
■ INPUT PARAMETER			: 
■ EXEC						: 
    -- EXEC SP_MOV2_CURATION_RECEIVE_PAGING_SELECT 10
■ MEMO						: 큐레이션수신정보_페이징
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-05		IBSOLUTION				최초생성
   2017-10-11		김성호					WITH(NOLOCK) 구문 누락 추가
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_CURATION_RECEIVE_PAGING_SELECT]
	@HIS_NO				INT,
	@FROM				INT,
	@TO					INT
AS
BEGIN

	SELECT * FROM
	(
		SELECT A.*,ROW_NUMBER() OVER (ORDER BY A.RCV_DATE DESC) AS NUM
		FROM (
			SELECT B.CUS_NAME, A.* FROM CUVE A WITH(NOLOCK) INNER JOIN CUS_CUSTOMER_DAMO B WITH(NOLOCK) ON A.CUS_NO = B.CUS_NO
			WHERE A.HIS_NO = @HIS_NO
		) A
	) A
	WHERE A.NUM BETWEEN  @FROM AND @TO

END           



GO
