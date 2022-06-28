USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_RES_EVENT_INSERT
- 기 능 : 할인예약정보등록
====================================================================================
	참고내용
 기존 예약정보를 등록한뒤에 
 예약자가 이벤트할인 해당 예약자 이면
 기존예약정보를 할인예약정보로 UPDATE 해줌
 *예약상태 담당자 확인중으로 <- 보류
 
====================================================================================
- 예제
 EXEC SP_RES_EVENT_INSERT 0
====================================================================================
	변경내역
====================================================================================
- 2011-02-01 박형만 신규 작성 
===================================================================================*/
CREATE PROC [dbo].[SP_RES_EVENT_INSERT]
	@PRO_CODE	PRO_CODE,
	@RES_CODE	RES_CODE,
	--@EVT_SEQ	int,
	--@EVT_ADT_PRICE	int,
	@NEW_CODE	char(7)
AS 
BEGIN
--DECLARE @EVT_SEQ INT 
--SET @EVT_SEQ = -1 -- 1

	--할인대상자 여부
	DECLARE @IS_DC_RES INT 
	SET @IS_DC_RES = 0 
	
	-- 행사코드와 기간에 해당하는 이벤트 번호
	DECLARE @EVT_SEQ INT 
	SELECT TOP 1 @EVT_SEQ = EVT_SEQ FROM PKG_EVENT WHERE PRO_CODE = @PRO_CODE
	AND GETDATE() BETWEEN START_DATE AND END_DATE

	--할인가격. 예약당시의 할인 가격 넣어줌
	DECLARE @EVT_ADT_PRICE INT 
	SELECT TOP 1 @EVT_ADT_PRICE = DC_ADT_PRICE FROM PKG_EVENT WHERE PRO_CODE = @PRO_CODE
	AND EVT_SEQ = @EVT_SEQ
		
	--이벤트 번호, 할인가격이 있을때
	IF @EVT_SEQ > 0 AND @EVT_ADT_PRICE > 0 
	BEGIN
	
		-- 총예약건수가 할인대상자 보다 적을경우 
		IF(	(SELECT TOP 1 DC_APP_COUNT FROM PKG_EVENT WHERE PRO_CODE = @PRO_CODE AND EVT_SEQ = @EVT_SEQ)
			> (	SELECT COUNT(*) FROM RES_EVENT AS RE 
				INNER JOIN RES_MASTER_damo AS RM WITH(NOLOCK)ON RE.RES_CODE = RM.RES_CODE 
				AND RM.RES_STATE NOT IN (7,8,9) -- 취소이동환불 예약이 아닌것만 계산
				WHERE RE.PRO_CODE = @PRO_CODE AND RE.EVT_SEQ = @EVT_SEQ)  )
		BEGIN
			
			
			--중복 예약자 확인 RETURN CODE : -2 
			DECLARE @CUS_NO INT 
			SELECT @CUS_NO = CUS_NO FROM RES_MASTER_damo WHERE RES_CODE = @RES_CODE
			/* 행사별 중복확인
			IF (SELECT COUNT(*) FROM RES_MASTER_damo WHERE PRO_CODE = @PRO_CODE 
				AND CUS_NO = @CUS_NO ) < 2
			*/
			/* 해당 이벤트별 중복확인 */
			IF (SELECT COUNT(*) FROM RES_EVENT AS RE 
				INNER JOIN  RES_MASTER_damo AS RM 
					ON RE.RES_CODE = RM.RES_CODE
				WHERE EVT_SEQ = @EVT_SEQ AND CUS_NO = @CUS_NO ) < 2
			BEGIN 
				
				----------------------------------
				--트랜젝션 시작
				BEGIN TRAN 
				--할인적용 대상자 입력
				INSERT INTO RES_EVENT ( PRO_CODE, RES_CODE, EVT_SEQ, EVT_ADT_PRICE, NEW_CODE, NEW_DATE )
				VALUES ( @PRO_CODE ,@RES_CODE, @EVT_SEQ, @EVT_ADT_PRICE, @NEW_CODE, GETDATE() )
					
				--예약 할인적용 시켜준다. 할인적용시 포인트 쌓지 않도록 0 으로
				UPDATE RES_CUSTOMER 
				SET DC_PRICE  = SALE_PRICE - @EVT_ADT_PRICE  , POINT_PRICE = 0 ,POINT_YN = 'N', POINT_RATE = 0 
				WHERE RES_CODE = @RES_CODE
				AND SEQ_NO IN ( 1, 2 ) --무조건 두명만
				
				--예약 마스터 비고에 표시
				UPDATE RES_MASTER 
				SET ETC = '*VGIF할인적용예약'
				WHERE RES_CODE = @RES_CODE 
				
				IF( @@ERROR <> 0 )
				BEGIN
					RAISERROR('할인적용대상자 입력시 에러',16,1)
					SET @IS_DC_RES = -999	
					ROLLBACK TRAN 
				END 
				ELSE 
				BEGIN
					SET @IS_DC_RES = 1 	
					COMMIT TRAN 
				END 
				----------------------------------	
			END 
			ELSE
			BEGIN
				SET @IS_DC_RES = -2 -- 중복예약임 
			END 
			
			
		END 
	END 
	ELSE 
	BEGIN
		--이벤트 번호 없으면 , --할인가격 없거나 0 이면 
		SET @IS_DC_RES = 0
	END 

	SELECT @IS_DC_RES AS IS_DC_RES 
END 
GO
