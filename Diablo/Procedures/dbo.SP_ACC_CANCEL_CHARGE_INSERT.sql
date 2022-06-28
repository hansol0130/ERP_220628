USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_ACC_CANCEL_CHARGE_INSERT
■ DESCRIPTION				: 취소수수료에 대한 전표 생성
■ INPUT PARAMETER			: 
	@PRO_CODE				: 행사 코드
	@SLIP_MK_DAY			: 전표 일자
	@EMP_NO					: 사번 코드
■ OUTPUT PARAMETER			: 
	@SLIP_MK_SEQ			: 전표일련번호
■ EXEC						: 

	declare @p4 int
	set @p4=NULL
	exec SP_ACC_CANCEL_CHARGE_INSERT @PRO_CODE='XXX101-131225',@CANCEL_CHARGE_PRICE=-1000,@SLIP_MK_DAY='20131206',@SLIP_MK_SEQ=@p4 output,@EMP_NO=N'2008011'
	select @p4

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-12-06		김성호			최초생성
   2016-01-19		김성호			기타계정 차/대변 수정
   2018-04-24		김성호			ACC_SLIPD 테이블 분개계정코드, 행사코드 등록
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_ACC_CANCEL_CHARGE_INSERT]
   @PRO_CODE			VARCHAR(20),		-- 행사코드
   @CANCEL_CHARGE_PRICE	DECIMAL,			-- 취소수수료
   @SLIP_MK_DAY			CHAR(8),			-- 전표일자
   @SLIP_MK_SEQ			SMALLINT OUTPUT,	-- 전표일련번호
   @EMP_NO				VARCHAR(10)			-- 사번
AS
BEGIN

	BEGIN TRY

	BEGIN TRAN

	DECLARE @USE_ACC_CD		VARCHAR(10),
			@SITE_CD		VARCHAR(10),
			@CALC_CD		VARCHAR(4),
	        @AMT_W			NUMERIC(12),
			@DEB_AMT_W		NUMERIC(12),                     
			@CRE_AMT_W		NUMERIC(12),
			@REMARK			VARCHAR(200),
			@DC_FG			CHAR(1),
			@CHA_DEPT_CD	VARCHAR(10),
			@RET			INT,
			@CHK			VARCHAR(3);

	-- 수익팀코드 
	SELECT @CHA_DEPT_CD = A.PROFIT_TEAM_CODE
	FROM SET_MASTER A WITH(NOLOCK)
	WHERE A.PRO_CODE = @PRO_CODE;

	SET @CHK = 'NEW'

	DECLARE CUR_1 SCROLL CURSOR FOR

	SELECT JUNL_CD, NULL AS [SITE_CD], CASE WHEN USE_ACC_CD1 IS NULL THEN '2' ELSE '1' END AS [DC_FG], @CANCEL_CHARGE_PRICE AS [AMT_W], JUNL_CD_NM
	FROM ACC_JUNL WITH(NOLOCK)
	WHERE JUNL_FG = 'EV' AND JUNL_CD IN ('A', 'E')

	--SELECT 'A', NULL, '1', @CANCEL_CHARGE_PRICE, '수탁금'
	--UNION
	--SELECT 'E', NULL, '2', @CANCEL_CHARGE_PRICE, '기타수익'

	OPEN CUR_1

	FETCH NEXT FROM CUR_1 INTO  @CALC_CD      ,		-- 분개전표구분 (ACC_JUNL 테이블에서 세부 항목 확인가능)
								@SITE_CD      ,		-- 거래처코드
								@DC_FG        ,		-- 차변: 1, 대변: 2
	                            @AMT_W        ,		-- 금액
		                        @REMARK				-- 비고

		WHILE ( @@FETCH_STATUS = 0)                    
		BEGIN

			IF @CHK = 'NEW'                    
			BEGIN
				/* 수입(1) 지출(2) 대체(3) */
				EXEC @SLIP_MK_SEQ = SP_ACC_SLIPM_SEQ @SLIP_MK_DAY, @EMP_NO, '3', 'EV'
				SET @CHK = 'ADD'
			END

			SELECT @REMARK = '[취소수수료] ' + A.PRO_CODE 
				+ ' / ' 
				+ (SELECT Z.TEAM_NAME FROM EMP_TEAM Z WITH(NOLOCK) WHERE Z.TEAM_CODE = B.TEAM_CODE) 
				+ ' / ' + 
				+ B.KOR_NAME
			FROM PKG_DETAIL A WITH(NOLOCK)
			INNER JOIN EMP_MASTER_damo B WITH(NOLOCK) ON B.EMP_CODE = A.NEW_CODE
			WHERE A.PRO_CODE = @PRO_CODE   
        
			IF ISNULL(@AMT_W,0) <> 0              
			BEGIN
				SELECT @USE_ACC_CD = CASE WHEN USE_ACC_CD1 IS NULL THEN USE_ACC_CD2 ELSE USE_ACC_CD1 END,
					   @DEB_AMT_W = CASE WHEN @DC_FG = '1' THEN @AMT_W ELSE 0 END,
					   @CRE_AMT_W = CASE WHEN @DC_FG = '2' THEN @AMT_W ELSE 0 END                  
				  FROM ACC_JUNL WITH(NOLOCK)
				 WHERE JUNL_FG = 'EV'                    
				   AND JUNL_CD = @CALC_CD                  

				--SELECT @USE_ACC_CD = USE_ACC_CD1,                  
				--	   @DEB_AMT_W = CASE WHEN @DC_FG = '1' THEN @AMT_W ELSE 0 END,
				--	   @CRE_AMT_W = CASE WHEN @DC_FG = '2' THEN @AMT_W ELSE 0 END                  
				--  FROM ACC_JUNL WITH(NOLOCK)
				-- WHERE JUNL_FG = 'EV'                    
				--   AND JUNL_CD = @CALC_CD                  
                    
				EXEC @RET = SP_ACC_SLIPD_INS_NEW @SLIP_MK_DAY, @SLIP_MK_SEQ, @USE_ACC_CD, @DC_FG, @SITE_CD, @CHA_DEPT_CD, @EMP_NO,
											  @PRO_CODE, NULL,@DEB_AMT_W, @CRE_AMT_W, @REMARK, @EMP_NO, 'EV', @PRO_CODE, NULL
                                                      
				IF @RET <> 0
				BEGIN
					ROLLBACK TRAN
					RETURN -1                    
				END 

				
			END              

			FETCH NEXT FROM CUR_1 INTO  @CALC_CD,
										@SITE_CD,
										@DC_FG,
										@AMT_W,
										@REMARK
		END

	CLOSE      CUR_1                    
                    
	DEALLOCATE CUR_1

	COMMIT TRAN

	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE()
		ROLLBACK TRAN
	END CATCH

END


GO
