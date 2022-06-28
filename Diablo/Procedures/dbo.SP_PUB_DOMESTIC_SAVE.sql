USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Server					: 211.115.202.230
■ Database					: DIABLO
■ USP_Name					: SP_PUB_DOMESTIC_SAVE  
■ Description				: 국내 상품 저장
■ Input Parameter			:                  
		@TYPE_CODE			: 구분 코드
		@SEQ_NO				: 순번
		@TITLE				: 제목
		@THUMBNAIL			: 썸네일
		@PRO_CODE			: 행사 코드
		@PRO_NAME			: 행사명
		@SALE_PRICE			: 상품 가격
		@MOVE_URL			: 이동 URL
		@REMARK				: 비고
		@NEW_CODE			: 최종 작성자 
■ Output Parameter			:                
■ Output Value				:                 
■ Exec						: EXEC SP_PUB_DOMESTIC_SAVE  
■ Author					: 임형민  
■ Date						: 2010-06-09 
■ Memo						: 
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2010-06-09       임형민			최초생성  
-------------------------------------------------------------------------------------------------*/ 

CREATE PROC [dbo].[SP_PUB_DOMESTIC_SAVE]
(
	@TYPE_CODE				INT,
	@SEQ_NO					INT							= '',
	@TITLE					VARCHAR(1000)				= '',
	@THUMBNAIL				VARCHAR(100)				= '',
	@PRO_CODE				VARCHAR(20)					= '',
	@PRO_NAME				VARCHAR(100)				= '',
	@SALE_PRICE				INT							= '',
	@MOVE_URL				VARCHAR(MAX)				= '',
	@REMARK					VARCHAR(MAX)				= '',
	@NEW_CODE				INT							= ''
)

AS

	BEGIN
		-- 만약 구분 코드 값이 없다면..
		IF @SEQ_NO = 0
		BEGIN
			DECLARE @SET_SEQ_NO INT
			
			-- 구분 코드에 해당하는 다음 순번을 채번한다.
			SELECT @SET_SEQ_NO = ISNULL(MAX(SEQ_NO), 0) + 1
			FROM DBO.PUB_DOMESTIC_PRODUCT
			WHERE TYPE_CODE = @TYPE_CODE
			
			-- 구분 코드와 순번에 해당하는 국내 상품을 새롭게 저장한다.
			INSERT INTO DBO.PUB_DOMESTIC_PRODUCT (TYPE_CODE, SEQ_NO, TITLE, THUMBNAIL, PRO_CODE, PRO_NAME, SALE_PRICE, MOVE_URL, REMARK, NEW_CODE, NEW_DATE)
			VALUES (@TYPE_CODE, @SET_SEQ_NO, @TITLE, @THUMBNAIL, @PRO_CODE, @PRO_NAME, @SALE_PRICE, @MOVE_URL, @REMARK, @NEW_CODE, GETDATE())
		END
		ELSE
		BEGIN
			UPDATE DBO.PUB_DOMESTIC_PRODUCT
				SET TITLE = @TITLE, 
					THUMBNAIL = @THUMBNAIL, 
					PRO_CODE = @PRO_CODE, 
					PRO_NAME = @PRO_NAME, 
					SALE_PRICE = @SALE_PRICE, 
					MOVE_URL = @MOVE_URL, 
					REMARK = @REMARK,
					NEW_CODE = @NEW_CODE,
					NEW_DATE = GETDATE()
			WHERE TYPE_CODE = @TYPE_CODE
			  AND SEQ_NO = @SEQ_NO
		END
	END
GO
