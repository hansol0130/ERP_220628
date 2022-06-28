USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_PUB_SALE_PRODUCT_INSERT
■ DESCRIPTION				: 할인행사 등록
■ INPUT PARAMETER			: 
	@SITE_CODE		CHAR(3)	: 사이트코드
	@SALE_SEQ		INT		: 할인상품순번
	@SIGN_CODE		VARCHAR(30)	: 지역코드
	@PRO_CODE		VARCHAR(20)	: 행사코드
	@SALE_NAME		VARCHAR(50)	: 할인행사명
	@CONTENT		VARCHAR(50)	: 할인행사정보
	@START_DATE		DATETIME	: 할인시작
	@END_DATE		DATETIME	: 할인종료
	@COST_PRICE		INT		: 원가
	@ORDER_NUM		INT		: 정렬순서
	@SHOW_YN		CHAR(1)	: 보기유무
	@NEW_CODE		CHAR(7)	: 작성자코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-24		김성호			최초생성
   2013-06-09		김성호			sale_name, content 사이즈 수정 varchar(50) -> varchar(200)
================================================================================================================*/ 
 CREATE PROCEDURE [dbo].[XP_PUB_SALE_PRODUCT_INSERT]
 (
	@SITE_CODE		CHAR(3),
	@SALE_SEQ		INT,
	@SIGN_CODE	VARCHAR(30),
	@PRO_CODE		VARCHAR(20),
	@SALE_NAME		VARCHAR(200),
	@CONTENT		VARCHAR(200),
	@START_DATE		DATETIME,
	@END_DATE		DATETIME,
	@COST_PRICE		INT,
	@ORDER_NUM		INT,
	@SHOW_YN		CHAR(1),
	@NEW_CODE		CHAR(7)
) 
AS 
BEGIN 

	SELECT @SALE_SEQ = (ISNULL(MAX(SALE_SEQ), 0) + 1) FROM SALE_MASTER A WHERE A.SITE_CODE = @SITE_CODE

	INSERT INTO SALE_MASTER (SITE_CODE, SALE_SEQ, SIGN_CODE, PRO_CODE, SALE_NAME, CONTENT, START_DATE, END_DATE, COST_PRICE, ORDER_NUM, NEW_CODE, NEW_DATE)
	VALUES (
		@SITE_CODE, @SALE_SEQ, @SIGN_CODE, @PRO_CODE, @SALE_NAME, @CONTENT,  CONVERT(VARCHAR(10), @START_DATE, 120), CONVERT(VARCHAR(10), @END_DATE, 120), 
		@COST_PRICE, 0, @NEW_CODE, GETDATE()
	)

	SELECT @SALE_SEQ

END 

GO
