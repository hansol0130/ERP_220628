USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_AIR_FARE_DISCOUNT_INSERT
- 기 능 : 오늘의 특가 항공권 등록
====================================================================================
	참고내용
====================================================================================
- 예제
 EXEC SP_AIR_FARE_DISCOUNT_INSERT '베를린','ZE','20110420','20110430','2011-04-10 23:59:59',100000,80000,1,'9999999'
====================================================================================
	변경내역
====================================================================================
- 2011-04-05 박형만 신규 작성 
- 2012-10-09 박형만 오늘의 특가 항공권으로 변경 
===================================================================================*/
CREATE PROC [dbo].[SP_AIR_FARE_DISCOUNT_INSERT]
	@START_DATE	DATETIME	,--	출발시작기간
	@END_DATE	DATETIME	,--	출발종료기간
	@AIRLINE_CODE	varchar(3)	,--	항공사코드
	@SUBJECT	VARCHAR(50)	, 
	@TITLE1	VARCHAR(50),
	@TEXT1	VARCHAR(100),
	@TITLE2	VARCHAR(50),
	@TEXT2	VARCHAR(100),
	@TITLE3	VARCHAR(50),
	@TEXT3	VARCHAR(100),
	@DIS_PRICE	int,
	@LINK	VARCHAR(500),
	@NEW_CODE	NEW_CODE
AS
INSERT INTO FARE_DISCOUNT (
	START_DATE,END_DATE,AIRLINE_CODE,SUBJECT,
	TITLE1,TEXT1,TITLE2,TEXT2,TITLE3,TEXT3,
	DIS_PRICE,LINK,USE_YN,NEW_CODE,NEW_DATE
)
VALUES (@START_DATE,@END_DATE,@AIRLINE_CODE,@SUBJECT,
	@TITLE1,@TEXT1,@TITLE2,@TEXT2,@TITLE3,@TEXT3,
	@DIS_PRICE,@LINK,'Y',@NEW_CODE,GETDATE())

GO
