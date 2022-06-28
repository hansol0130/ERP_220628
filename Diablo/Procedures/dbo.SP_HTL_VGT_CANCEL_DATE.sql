USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ USP_Name					: SP_HTL_VGT_CANCEL_DATE
■ Description				: VGT 취소마감일 검색
■ Input Parameter			:                     
		@@MASTER_CODE		: 호텔 마스터코드
		@@PRICE_SEQ_LIST	: 가격순번 (EX 1|2)
		@@BOOKING_DATE		: 숙박일
■ Exec						: exec SP_HTL_VGT_CANCEL_DATE @MASTER_CODE=N'EHB00007',@PRICE_SEQ_LIST=N'1|3',@COUNT_LIST='2|1,@BOOKING_DATE='2011-11-10 00:00:00''
■ Author					: 
■ Date						:  
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
2011-09-19			김성호			최초생성
2012-03-02			박형만			WITH(NOLOCK) 추가 
-------------------------------------------------------------------------------------------------*/ 

CREATE PROCEDURE [dbo].[SP_HTL_VGT_CANCEL_DATE]
(
	@MASTER_CODE		VARCHAR(20),
	@PRICE_SEQ_LIST		VARCHAR(30),
	@COUNT_LIST			VARCHAR(30),
	@BOOKING_DATE		DATETIME
)
AS
BEGIN

	SELECT A.*, C.DATA AS [RES_ROOM_COUNT] FROM HTL_PRICE_DETAIL A WITH(NOLOCK)
	INNER JOIN DBO.FN_SPLIT(@PRICE_SEQ_LIST, '|') B ON A.PRICE_SEQ = B.DATA
	INNER JOIN DBO.FN_SPLIT(@COUNT_LIST, '|') C ON B.ID = C.ID
	WHERE MASTER_CODE = @MASTER_CODE AND BOOKING_DATE = @BOOKING_DATE
	
	--DECLARE @QUERY NVARCHAR(4000)
	
	--SET @QUERY = '
	--SELECT A.*, C.DATA AS [RES_ROOM_COUNT] FROM HTL_PRICE_DETAIL A
	--INNER JOIN DBO.FN_SPLIT(''' + @PRICE_SEQ_LIST + ''', ''|'') B ON A.PRICE_SEQ = B.DATA
	--INNER JOIN DBO.FN_SPLIT(''' + @COUNT_LIST + ''', ''|'') C ON B.ID = C.ID
	--WHERE MASTER_CODE = @MASTER_CODE AND BOOKING_DATE = @BOOKING_DATE'
	
	--EXEC SP_EXECUTESQL @QUERY, N'@MASTER_CODE VARCHAR(20),@BOOKING_DATE DATETIME', @MASTER_CODE, @BOOKING_DATE

END


GO
