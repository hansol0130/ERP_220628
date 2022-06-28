USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_ACC_SLIPD_INS_NEW
■ DESCRIPTION				: 가입금전표생성
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2012-08-09		투어소프트		최초생성
   2015-05-04		김성호			REMARK 계정에 따른 비고 값 추가
   2019-07-04		김성호			네이버페이 추가로 COD_PUBLIC 검색 조건 수정
   2020-11-25		김성호			단품상품추가로 인한 쿼리 정리
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_ACC_SLIPD_INS_NEW]            
          @SLIP_MK_DAY		CHAR(8)
        , @SLIP_MK_SEQ		SMALLINT  
        , @USE_ACC_CD		VARCHAR(10)	-- 계정코드  
        , @DC_FG			VARCHAR(1)	-- 차대변구분
        , @SITE_CD			VARCHAR(10)	-- 거래처코드  
        , @DEPT_CD			VARCHAR(10)	-- 담당부서
        , @EMP_NO			VARCHAR(10)	-- 등록자사번
        , @PRO_CODE			VARCHAR(20)	-- 행사코드
        , @SAVE_ACC_NO		VARCHAR(20)	-- 계좌번호
        , @DEB_AMT_W		NUMERIC(12)	-- 차변 값
        , @CRE_AMT_W		NUMERIC(12)	-- 대변 값
        , @REMARK			VARCHAR(200)-- REMARK
        , @INS_EMP_NO		VARCHAR(10)	-- 작성자
        , @FG_NM1			VARCHAR(40)	-- 비고1
        , @FG_NM2			VARCHAR(40)	-- 비고2
        , @FG_NM3			VARCHAR(40)	-- 비고3
        
AS             
             
DECLARE   @SLIP_DET_SEQ     SMALLINT

BEGIN  
             
	EXEC SP_ACC_SLIPD_SEQ @SLIP_MK_DAY, @SLIP_MK_SEQ, @SLIP_DET_SEQ OUTPUT

	-- 미수금대체
	IF @USE_ACC_CD = '12300'
	BEGIN
		SELECT @REMARK = ISNULL(A.PUB_VALUE2, '') + @REMARK
		FROM COD_PUBLIC A WITH(NOLOCK)
		WHERE A.PUB_TYPE LIKE 'PAY.[MN][IA]%' AND A.PUB_CODE = @FG_NM2
	END

	WHILE (DATALENGTH(@REMARK) > 200)
	BEGIN
		SELECT @REMARK = SUBSTRING(@REMARK, 1, (LEN(@REMARK) - 1))
	END
  
	INSERT INTO ACC_SLIPD
	(
		SLIP_MK_DAY,	SLIP_MK_SEQ,	SLIP_DET_SEQ,	USE_ACC_CD,		DC_FG,
		DEB_AMT_W,		CRE_AMT_W,		REMARK,
	    SITE_CD,
	    DEPT_CD,
	    EMP_NO,
	    PRO_CODE,
	    SAVE_ACC_NO,
	    FG_NM1,			FG_NM2,			FG_NM3,			INS_DT,			INS_EMP_NO
	)
	SELECT
		@SLIP_MK_DAY,	@SLIP_MK_SEQ,	@SLIP_DET_SEQ,	@USE_ACC_CD,	@DC_FG,
		@DEB_AMT_W,		@CRE_AMT_W,		@REMARK,
		CASE WHEN A.SITE_CD_CHK = 'Y' THEN @SITE_CD END,		-- 거래처
		CASE WHEN A.DEPT_CD_CHK = 'Y' THEN @DEPT_CD END,		-- 부서
		CASE WHEN A.EMP_NO_CHK = 'Y' THEN @EMP_NO END,			-- 상품명
	    CASE WHEN A.PRO_CODE_CHK = 'Y' THEN @PRO_CODE END,		-- 행사번호
	    CASE WHEN A.ACC_NO_CHK = 'Y' THEN @SAVE_ACC_NO END,		-- 계좌번호
	    @FG_NM1,		@FG_NM2,		@FG_NM3,		GETDATE(),		@INS_EMP_NO
	FROM ACC_ACCOUNT A WITH(NOLOCK)
	WHERE A.USE_ACC_CD = @USE_ACC_CD

	RETURN @@ERROR
END    
GO
