USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ USP_NAME					: SP_HTL_VGT_BOOKING_COUNT
■ DESCRIPTION				: VGT 예약 시 좌석 카운트
■ INPUT PARAMETER			:                     
		@MASTER_CODE		: 호텔 마스터코드
		@PRICE_SEQ_LIST		: 가격순번 (EX 1|2)
		@COUNT_LIST			: 숙박 룸 갯수 (EX 1|2)
		@CHECK_IN			: 숙박시작일
		@CHECK_OUT			: 숙박종료일
		@ERRORCODE			: 에러 코드
		@ERRORMSG			: 에러 메세지
■ EXEC						: 

declare @p6 int
set @p6=0
declare @p7 varchar(100)
set @p7=0
exec SP_HTL_VGT_BOOKING_COUNT @MASTER_CODE=N'EHB00007',@PRICE_SEQ_LIST=N'1|3',@COUNT_LIST=N'1|3',@CHECK_IN='2011-11-10 00:00:00',@CHECK_OUT='2011-11-12 00:00:00',@ERRORCODE=@p6 output,@ERRORMSG=@p7 output
select @p6, @p7


■ AUTHOR					: 
■ DATE						:  
---------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
---------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
---------------------------------------------------------------------------------------------------
2011-09-21			김성호			최초생성
-------------------------------------------------------------------------------------------------*/ 

CREATE PROCEDURE [dbo].[SP_HTL_VGT_BOOKING_COUNT]
(
	@MASTER_CODE		VARCHAR(20),
	@PRICE_SEQ_LIST		VARCHAR(30),
	@COUNT_LIST			VARCHAR(30),
	@CHECK_IN			DATETIME,
	@CHECK_OUT			DATETIME,
	@ERRORCODE			INTEGER OUTPUT,
	@ERRORMSG			VARCHAR(100) OUTPUT
)
AS
BEGIN

	BEGIN TRY
	
	BEGIN TRAN
	
	-- 잔여좌석 체크
	IF NOT EXISTS(
		SELECT * FROM HTL_PRICE_DETAIL A
		INNER JOIN DBO.FN_SPLIT(@PRICE_SEQ_LIST, '|') B ON A.PRICE_SEQ = B.DATA
		INNER JOIN DBO.FN_SPLIT(@COUNT_LIST, '|') C ON B.ID = C.ID
		WHERE A.MASTER_CODE = @MASTER_CODE AND A.BOOKING_DATE >= @CHECK_IN AND A.BOOKING_DATE < @CHECK_OUT
		AND ROOM_COUNT < (RES_COUNT + C.DATA)
	)
	BEGIN
		UPDATE A SET A.RES_COUNT = ISNULL(D.RES_ROOM_COUNT, 0) + C.DATA
		FROM HTL_PRICE_DETAIL A
		INNER JOIN DBO.FN_SPLIT(@PRICE_SEQ_LIST, '|') B ON A.PRICE_SEQ = B.DATA
		INNER JOIN DBO.FN_SPLIT(@COUNT_LIST, '|') C ON B.ID = C.ID
		LEFT JOIN (
			-- 해당 가격 예약자 수
			SELECT A.MASTER_CODE, C.PRICE_SEQ, D.DATE AS [BOOKING_DATE], SUM(C.ROOM_COUNT) AS [RES_ROOM_COUNT]
			FROM RES_MASTER A
			INNER JOIN RES_HTL_ROOM_MASTER B ON A.RES_CODE = B.RES_CODE
			INNER JOIN RES_HTL_ROOM_DETAIL C ON B.RES_CODE = C.RES_CODE
			INNER JOIN PUB_TMP_DATE D ON B.CHECK_IN <= D.DATE AND B.CHECK_OUT > D.DATE
			INNER JOIN DBO.FN_SPLIT(@PRICE_SEQ_LIST, '|') E ON C.PRICE_SEQ = E.DATA
			WHERE A.MASTER_CODE = @MASTER_CODE AND A.RES_STATE <= 7 AND D.DATE >= @CHECK_IN AND D.DATE < @CHECK_OUT
			GROUP BY A.MASTER_CODE, C.PRICE_SEQ, D.DATE
		) D ON A.MASTER_CODE = D.MASTER_CODE AND A.PRICE_SEQ = D.PRICE_SEQ AND A.BOOKING_DATE = D.BOOKING_DATE
		WHERE A.MASTER_CODE = @MASTER_CODE AND A.BOOKING_DATE >= @CHECK_IN AND A.BOOKING_DATE < @CHECK_OUT
		
		SET @ERRORCODE = 0
		SET @ERRORMSG = '예약완료'
	END
	ELSE
	BEGIN
		SET @ERRORCODE = 100
		SET @ERRORMSG = '좌석이 부족합니다.'
	END
	
	COMMIT TRAN

	END TRY
	BEGIN CATCH 
		SET @ERRORCODE = 999
		SET @ERRORMSG = ERROR_MESSAGE()

		ROLLBACK TRAN
	END CATCH
END


	
--SELECT * FROM HTL_PRICE_DETAIL A
--INNER JOIN DBO.FN_SPLIT('1|9', '|') B ON A.PRICE_SEQ = B.DATA
--INNER JOIN DBO.FN_SPLIT('1|1', '|') C ON B.ID = C.ID
--WHERE A.MASTER_CODE = 'EHB00007' AND A.BOOKING_DATE >= '2011-11-10' AND A.BOOKING_DATE < '2011-11-12'
--AND ROOM_COUNT < RES_COUNT + C.DATA
GO
