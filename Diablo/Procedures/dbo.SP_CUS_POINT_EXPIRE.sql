USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_CUS_POINT_EXPIRE
- 기 능 : 포인트 소멸 
====================================================================================
	참고내용
====================================================================================
- 포인트 소멸 PointExpireUpdate.exe 스케쥴 프로그램에서 사용
- 예제
 EXEC SP_CUS_POINT_EXPIRE 32 ,4153295 , '9999999'
====================================================================================
	변경내역
====================================================================================
- 2010-05-07 박형만 신규 작성 
- 2013-07-09 박형만	ACC_TYPE 원래적립 타입 입력추가. 로직 변경. 
- 2017-01-24 박형만	ACC_TYPE 원래적립 타입 양도일경우에 최상위 걸로 구함(함수사용)
===================================================================================*/
CREATE PROC [dbo].[SP_CUS_POINT_EXPIRE]
	@POINT_NO INT, 
	@CUS_NO INT,
	@NEW_CODE NEW_CODE ,
	@NEW_DATE DATETIME 
AS 
BEGIN 
--DECLARE @POINT_NO INT, 
--	@CUS_NO INT,
--	@NEW_CODE NEW_CODE 
	
--SET @POINT_NO = 3926
--SET @CUS_NO = 3755317
--SET @NEW_CODE = '9999999'

	-- 기존 적립타입  (2013.07.09추가)
	DECLARE @ACC_TYPE INT 
	--SET @ACC_TYPE = (SELECT ACC_USE_TYPE FROM CUS_POINT  WITH(NOLOCK)   WHERE POINT_NO = 33419 )
	--SET @ACC_TYPE = (SELECT ACC_USE_TYPE FROM CUS_POINT  WITH(NOLOCK)   WHERE POINT_NO = 33419 )
	SET @ACC_TYPE = dbo.XN_CUS_POINT_TOP_ACC_CODE(@POINT_NO)
	-- 소멸될 포인트-- (적립포인트-사용포인트) 실행 시점에 소멸될 포인트를 다시구함
	-- 조회된 소멸 대상 POINT_NO 를 소멸 시킴
	DECLARE @EXPIRE_POINT INT 
	SET  @EXPIRE_POINT = 
	(SELECT POINT_PRICE FROM CUS_POINT WITH(NOLOCK) 
	WHERE POINT_NO = @POINT_NO ) - 
	ISNULL((SELECT SUM(POINT_PRICE) FROM CUS_POINT_HISTORY WITH(NOLOCK) 
	WHERE ACC_POINT_NO =  @POINT_NO ),0) 

	--소멸포인트가 있을때만
	IF( @EXPIRE_POINT > 0 )
	BEGIN 
		-- 유효기간 지난것들만 
		IF( (SELECT END_DATE FROM CUS_POINT WITH(NOLOCK)  
			WHERE POINT_NO = @POINT_NO) < GETDATE() )
		BEGIN
			--소멸완료 시점 포인트 구함
			DECLARE @TOTAL_POINT INT 
			SET @TOTAL_POINT = ISNULL(
				(	SELECT TOP 1 TOTAL_PRICE
					FROM CUS_POINT AS CP WITH(NOLOCK)
					WHERE CP.CUS_NO = @CUS_NO ORDER BY POINT_NO DESC ) , 0 ) - @EXPIRE_POINT
					 
			------------------------------------------------------------------------------
			--#트랜젝션 시작
			BEGIN TRAN 

			--소멸사용마스터 입력 POINT_TYPE =2(사용) , ACC_USE_TYPE = 2 기간만료 
			INSERT INTO CUS_POINT ( CUS_NO,POINT_TYPE,ACC_USE_TYPE,START_DATE,END_DATE,
				POINT_PRICE,RES_CODE,TITLE,TOTAL_PRICE,REMARK,NEW_CODE,NEW_DATE,MASTER_SEQ,BOARD_SEQ ) 
			VALUES ( @CUS_NO,2,2,NULL,NULL,
				@EXPIRE_POINT,NULL,'유효기간만료',@TOTAL_POINT,NULL,@NEW_CODE,@NEW_DATE,NULL,NULL ) 

			--에러시 롤백
			IF @@ERROR <> 0 
			BEGIN
				RAISERROR ( 'CUS_POINT INSERT 오류' ,16,1)
				ROLLBACK TRAN 
				RETURN 
			END 
		
			--소멸사용디테일 입력 
			--DECLARE @NEW_POINT_NO INT 
			--SET @NEW_POINT_NO = ISNULL((SELECT MAX(POINT_NO)+1 FROM CUS_POINT_HISTORY WITH(NOLOCK)),1)
			INSERT INTO CUS_POINT_HISTORY (
				POINT_NO,SEQ_NO,ACC_POINT_NO,POINT_PRICE,NEW_CODE,NEW_DATE,ACC_TYPE) 
			SELECT @@IDENTITY,1,@POINT_NO,@EXPIRE_POINT,@NEW_CODE,GETDATE() ,@ACC_TYPE
		
			--에러시 롤백
			IF @@ERROR <> 0 
			BEGIN
				RAISERROR ( 'CUS_POINT_HISTORY INSERT 오류' ,16,1)
				ROLLBACK TRAN 
				RETURN 
			END
			
			--#트랜젝션 완료
			COMMIT TRAN 
			------------------------------------------------------------------------------
		END 
	END 
END 
GO
