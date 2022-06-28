USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_WEB_RES_AIR_DOM_CANCEL
■ DESCRIPTION				: 국내항공 예약 취소
■ INPUT PARAMETER			:
	@RES_CODE	RES_CODE,
	@CXL_CODE	EMP_CODE,
	@RES_STATE	INT
■ OUTPUT PARAMETER			: 
■ EXEC						: 

XP_WEB_RES_AIR_DOM_CANCEL 'RT1705162053' , '9999999' , 9 
	취소시 상품 
	취소시 당일발권후 VOID취소 가 있으면 입금삭제처리를 한다 
		아시아나,대한항공 - DSR VOID 처리 
		진에어,티웨이 - 정산내역삭제
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2016-01-28		박형만			
	2016-02-01		박형만	void 취소 처리 
	2017-04-20		박형만	출발일 지나고 , 결제금액 있는거는 취소 안되게 임시 처리 !!
	2017-06-07		박형만	출발일 지나고 , 결제금액 있는거는 취소되도록 
	2017-07-31		박형만	출발일 지나고 , 결제금액 있고 , 999999 인것은 취소 안되도록 처리 

================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_WEB_RES_AIR_DOM_CANCEL]
	@RES_CODE	RES_CODE,
	@CXL_CODE	EMP_CODE,
	@RES_STATE	INT
AS
BEGIN
	
	--DECLARE @RES_CODE VARCHAR(20)
	--SELECT @RES_CODE = 'RT1701228006'

	

	-- 입금정보,예약정보
	DECLARE @PRO_CODE PRO_CODE
	DECLARE @AGT_CODE VARCHAR(10)
	DECLARE @AIRLINE_CODE VARCHAR(2)
	DECLARE @RES_CNT INT 
	DECLARE @EMP_CODE VARCHAR(10)  --접수자->처리자
	--DECLARE @PNR_CODE VARCHAR(10)
	DECLARE @PAY_DATE DATETIME
	DECLARE @PAY_PRICE INT
	DECLARE @PAY_MAT_SEQ INT 

	DECLARE @DEP_DATE DATETIME 

	SELECT 
		@PRO_CODE = A.PRO_CODE , 
		@AGT_CODE = A.SALE_COM_CODE , 
		@AIRLINE_CODE = B.AIRLINE_CODE,
		@RES_CNT = ISNULL((SELECT COUNT(*) FROM RES_CUSTOMER_DAMO WITH(NOLOCK)  WHERE RES_CODE = @RES_CODE ),0),
		@EMP_CODE = A.NEW_CODE , 
		@PAY_DATE = C.NEW_DATE , @PAY_PRICE = C.PART_PRICE , @PAY_MAT_SEQ = C.PAY_SEQ ,
		@DEP_DATE = A.DEP_DATE 
	FROM RES_MASTER_DAMO A WITH(NOLOCK) 
		LEFT JOIN RES_AIR_DETAIL B WITH(NOLOCK) 
			ON A.RES_CODE = B.RES_CODE 
		LEFT JOIN PAY_MATCHING C WITH(NOLOCK) 
			ON A.RES_CODE = C.RES_CODE 
	WHERE A.RES_CODE = @RES_CODE  
	--SELECT @DEP_DATE ,@PAY_PRICE
	--출발일이 지났고,결제금액 있고 ,취소자 코드가 시스템(고객)일때 취소 처리하지 않음
	IF( @DEP_DATE < GETDATE() AND @PAY_PRICE > 0  AND @CXL_CODE = '9999999' )
	BEGIN
		SELECT '삭제하지않음' 
		RETURN 
	END 



	-- 오늘 
	-- 취소당일
	DECLARE @BASE_DATE DATETIME 
	SET @BASE_DATE = CONVERT(DATETIME,CONVERT(VARCHAR(10),GETDATE(),121))


	--SELECT @AIRLINE_CODE ,@PAY_DATE , @PAY_PRICE , @PAY_MAT_SEQ

	--SELECT @TODAY 
	BEGIN TRY 
		BEGIN TRAN 
		--입금내역 있으면 
		IF( @PAY_MAT_SEQ IS NOT NULL AND  ISNULL(@PAY_PRICE,0) > 0  )
		BEGIN
			-- 당일발권 금액 있으면 void 취소 
			IF ( @PAY_DATE >= @BASE_DATE AND @PAY_DATE < DATEADD(D,1,@BASE_DATE) )
			BEGIN
				-- [입금내역 삭제처리] ----------------------------
				--DELETE PAY_MATCHING WHERE PAY_SEQ  = @PAY_MAT_SEQ 
				UPDATE PAY_MATCHING SET CXL_YN ='Y' ,CXL_DATE = GETDATE() , CXL_CODE = '9999999' 
				WHERE PAY_SEQ  = @PAY_MAT_SEQ 

				--DELETE PAY_MASTER_damo WHERE PAY_SEQ = @PAY_MAT_SEQ -- 마스터 삭제시 PAY_MATCHING 도 삭제 됨  
				--삭제 말고 입금 취소로 
				UPDATE PAY_MASTER_damo SET CXL_YN ='Y' ,CXL_DATE = GETDATE() , CXL_CODE = '9999999' 
				WHERE PAY_SEQ = @PAY_MAT_SEQ 

				-- 대한항공,아시아나
				IF (@AIRLINE_CODE IN('KE','OZ') )
				BEGIN
					-- [DSR VOID 처리] ----------------------------
					-- DSR 상태 VOID 로 수정 , 금액 0 원으로 
					-- @TICKET_STATUS (Normal = 1, Void, Refund)
					UPDATE DSR_TICKET 
					SET TICKET_STATUS = 2  -- Void
						, FARE = 0 , NET_PRICE = 0 , TAX_PRICE = 0 , CASH_PRICE = 0 , CARD_PRICE = 0 , QUE_PRICE = 0 
						,EDT_CODE = '9999999', EDT_DATE = GETDATE()  
					WHERE RES_CODE = @RES_CODE

					---- DSR VOID 등록
					--INSERT INTO DSR_VOID
					--	(TICKET, NEW_CODE, NEW_DATE, VOID_REMARK, PROCESS_DATE, EMP_CODE)
					--SELECT	TICKET,NEW_CODE,GETDATE(),'국내온라인항공VOID',GETDATE(),@EMP_CODE FROM DSR_TICKET 
					--WHERE RES_CODE = @RES_CODE
					--AND TICKET NOT IN ( SELECT TICKET FROM DSR_VOID WITH(NOLOCK) WHERE RES_CODE = @RES_CODE ) 

					-- [항공비 삭제 처리] ----------------------------
					DECLARE @AIR_SEQ_NO INT 
					--ROUTING 으로 비교 
					SELECT @AIR_SEQ_NO = (SELECT TOP 1 AIR_SEQ_NO FROM SET_AIR_AGENT WHERE ROUTING LIKE (@RES_CODE + '%'))
					IF @AIR_SEQ_NO IS NOT NULL 
					BEGIN
						DELETE SET_AIR_AGENT 
						WHERE PRO_CODE = @PRO_CODE  --해당행사
						AND AIRLINE_CODE = @AIRLINE_CODE  --항공사
						AND AIR_SEQ_NO =@AIR_SEQ_NO 
					END 

					DELETE SET_AIR_CUSTOMER
					WHERE RES_CODE = @RES_CODE  -- 예약코드

					--VALUES (@TICKET, @NEW_CODE, GETDATE(), @VOID_REMARK, GETDATE(), @EMP_CODE)
				END 
				-- 티웨이,진에어
				ELSE IF (@AIRLINE_CODE IN('TW','LJ'))
				BEGIN
					DECLARE @SEQ_NO INT 

					-- [지상비 삭제처리] ----------------------------
					DELETE  SET_LAND_AGENT
					WHERE PRO_CODE = @PRO_CODE  --해당행사
					AND AGT_CODE = @AGT_CODE  --항공사
					AND REMARK LIKE @RES_CODE + '%'  -- 비고에 예약코드가 있는것, 비고가 변경될시에 삭제 안될수 있음 

					DELETE SET_LAND_CUSTOMER
					WHERE RES_CODE = @RES_CODE  -- 예약코드
				END 

				--VOID 공통 
				--상품가 0원으로 
				UPDATE RES_CUSTOMER_damo SET SALE_PRICE = 0, TAX_PRICE = 0 WHERE RES_CODE = @RES_CODE

			END 
		END -- 입금내역  처리 완료
		ELSE 
		BEGIN
			-- 입금내역 없으면  -- *전체항공사공통 
			-- 상품가 0원으로 
			UPDATE RES_CUSTOMER_damo SET SALE_PRICE = 0, TAX_PRICE = 0 WHERE RES_CODE = @RES_CODE
		END  

		--[공통처리 사항]
		-- 예약취소로 
		UPDATE RES_MASTER_damo SET RES_STATE = @RES_STATE, CXL_CODE = @CXL_CODE, CXL_DATE = GETDATE()
		WHERE RES_CODE = @RES_CODE;

		--커밋
		COMMIT TRAN
	END TRY 
	BEGIN CATCH 
		--롤백
		ROLLBACK TRAN 

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT 
			@ErrorMessage = ERROR_MESSAGE(),
			@ErrorSeverity = ERROR_SEVERITY(),
			@ErrorState = ERROR_STATE();

		-- Use RAISERROR inside the CATCH block to return error
		-- information about the original error that caused
		-- execution to jump to the CATCH block.
		RAISERROR (@ErrorMessage, -- Message text.
					@ErrorSeverity, -- Severity.
					@ErrorState -- State.
					);
	END CATCH 

END 
GO
