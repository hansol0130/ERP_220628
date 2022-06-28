USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_ACC_PUM_SLIPD_INS_NEW
■ DESCRIPTION				: 입금전표 생성
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2010-06-21		투어소프트		최초생성
	2016-01-19		김성호			미수금 마이너스의 경우 거래처 예외처리 추가
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_ACC_PUM_SLIPD_INS_NEW_TEMP]           
   @CHK          CHAR(3),          /* 체크 'NEW', 'ADD' */        
   @SLIP_MK_DAY  CHAR(8),          /* 전표일자 */        
   @SLIP_MK_SEQ  SMALLINT OUTPUT,  /* 전표일련번호 */        
   @EDI_CODE     CHAR(10),         /*----- 입금내역 PK -----*/         
   @EMP_NO       EMP_CODE,          /* 등록사번 */
   @PROCESS_TYPE	VARCHAR(1)

/*
	AccountProcessList.asps 에서 정의
	// 지상비/공동경비 선급금				ProcessType = "1";
	// 지상비/공동경비 미지급랜드			ProcessType = "2";
	// 지상비/공동경비 선급금 마이너스	ProcessType = "3";
	// 지상비/공동경비 미수금 마이너스	ProcessType = "4"; <- 거래처가 반대
*/


/* 전자결재 문서 전표 생성 시 사용되는 SP */

AS        
DECLARE @SLIP_FG      CHAR(1),    /* 수입(1) 지출(2) 대체(3) */        
        @SLIP_DET_SEQ SMALLINT    /* 전표DETAIL 일련번호 */         
              
DECLARE @USE_ACC_CD    VARCHAR(10),      /* 계정코드 */        
        @DEB_AMT_W     NUMERIC(12),      /* 차변금액 */        
        @CRE_AMT_W     NUMERIC(12),      /* 대변금액 */        
        @AMT_W         NUMERIC(12),      /* 대변금액 */        
        @REMARK_DEB    VARCHAR(200),     /* 비고1 */                         
        @REMARK_CRE    VARCHAR(200),     /* 비고1 */                         
        @DEB_USE_ACC_CD CHAR(10),       /* 차변 계정 */        
        @CRE_USE_ACC_CD CHAR(10),       /* 대변 계정 */        
        @EV_NO         VARCHAR(20),        
        @EV_NM         VARCHAR(200),        
        @START_DAY     CHAR(8),                
        @IN_EMP_NO     VARCHAR(10),      /* 입금자사번 */                   
        @SITE_CD1       VARCHAR(10),               
        @SITE_CD2       VARCHAR(10),               
        @DEPT_CD       VARCHAR(10),                       
        @SAVE_ACC_NO   VARCHAR(20),                
        @RES_CODE      VARCHAR(20),        
        @IO_DAY        VARCHAR(8),       
        @DOC_TYPE      VARCHAR(10),             
        @DETAIL_TYPE   VARCHAR(10),      
        @DETAIL_NAME   VARCHAR(20),      
        @JUNL_FG       VARCHAR(2),			/* 분개계정코드 */
        @JUNL_NM       VARCHAR(12),       
        @PRO_CODE      VARCHAR(20),      
        @RET           INT       ,
        @SUBJECT		VARCHAR(200)
              
          
BEGIN TRANSACTION              
           
/*G1 일반지결전표  
G2 행사지결전표(환불지결)  
G3 행사지결전표(공동경비)  
G4 행사지결전표(지상비)  
G5 행사지결전표(기타)
G6 선수금환불*/  
  
           
           
SELECT  @DOC_TYPE    = A.DOC_TYPE,                  
        @DETAIL_TYPE = A.DETAIL_TYPE,              
        @DETAIL_NAME = A.DETAIL_NAME,                    
        @DEB_AMT_W   = A.PRICE * (CASE WHEN @PROCESS_TYPE = '4' THEN -1 ELSE 1 END),
        @CRE_AMT_W   = A.PRICE * (CASE WHEN @PROCESS_TYPE = '4' THEN -1 ELSE 1 END),
        @AMT_W       = A.PRICE,               
        @EV_NO       = A.PRO_CODE,                
        @SITE_CD1     = A.AGT_CODE,        
		@SITE_CD2     = A.AGT_CODE,        
        @IN_EMP_NO   = A.NEW_CODE,      
        @REMARK_DEB  = A.EDI_CODE + ' ' + A.SUBJECT,
        @REMARK_CRE  = A.PAY_BANK + ' ' + DAMO.DBO.DEC_VARCHAR('DIABLO', 'DBO.EDI_MASTER', 'PAY_ACCOUNT', A.SEC_PAY_ACCOUNT) + ' ' + A.PAY_RECEIPT,
        @SUBJECT = A.SUBJECT,
        @RES_CODE    = A.MASTER_CODE,      
        @DEPT_CD     = A.RCV_TEAM_CODE,      
        @JUNL_FG     = CASE WHEN A.DOC_TYPE = '4' THEN 'G1'      
                            WHEN A.DOC_TYPE = '8' AND A.DETAIL_TYPE = '1' THEN 'G4'      
                            WHEN A.DOC_TYPE = '8' AND A.DETAIL_TYPE = '2' THEN 'G3'           
                            WHEN A.DOC_TYPE = '8' AND A.DETAIL_TYPE = '3' THEN 'G2'      
                            WHEN A.DOC_TYPE = '8' AND A.DETAIL_TYPE = '4' THEN 'G5'
                            WHEN A.DOC_TYPE = '8' AND A.DETAIL_TYPE = '5' THEN 'G6' END,  
        @JUNL_NM     = CASE WHEN A.DOC_TYPE = '4' THEN '[일반지결]'      
                            WHEN A.DOC_TYPE = '8' AND A.DETAIL_TYPE = '1' THEN '[지상비지결]'      
                            WHEN A.DOC_TYPE = '8' AND A.DETAIL_TYPE = '2' THEN '[공동비지결]'           
                            WHEN A.DOC_TYPE = '8' AND A.DETAIL_TYPE = '3' THEN '[환불지결]'      
                            WHEN A.DOC_TYPE = '8' AND A.DETAIL_TYPE = '4' THEN '[기타지결]'
                            WHEN A.DOC_TYPE = '8' AND A.DETAIL_TYPE = '5' THEN '[선수금환불]' END,  
        @PRO_CODE    = PRO_CODE                           
   FROM EDI_MASTER_DAMO A      
  WHERE A.EDI_CODE = @EDI_CODE       
    AND A.DOC_TYPE IN ( '4', '8' )      
    AND A.EDI_STATUS = '3'    
    AND NOT EXISTS ( SELECT P.EDI_CODE      
                       FROM ACC_PUM_SLIP P      
                      WHERE P.EDI_CODE =  A.EDI_CODE )        
                            
        
     IF @CHK = 'NEW'  AND  @AMT_W <> 0      
     BEGIN        
             
         SELECT @SLIP_FG = '3' /* 대체전표 */        
         EXEC @SLIP_MK_SEQ = SP_ACC_SLIPM_SEQ @SLIP_MK_DAY, @EMP_NO, @SLIP_FG, @JUNL_FG      
            
     END
	     
    -- 2010-10-6 강우미 과장의 요청으로 적요란을 전자결재 문서 제목으로 변경함
    -- 아래는 이전소스
    --IF @PRO_CODE IS NOT NULL AND @PRO_CODE <> ''    
    --   SELECT @REMARK_DEB = @JUNL_NM + ' ' +  PRO_CODE + ' ' + PRO_NAME,  
    --          @REMARK_CRE = @JUNL_NM + ' ' +  PRO_CODE + ' ' + PRO_NAME  
    --     FROM PKG_DETAIL  
    --    WHERE PRO_CODE = @PRO_CODE     
    --ELSE  
    --   SELECT @REMARK_DEB = @JUNL_NM +  ' ' + @REMARK_DEB,  
    --          @REMARK_CRE = @JUNL_NM +  ' ' + @REMARK_CRE  
    
    --======================================================================================  
    IF @PRO_CODE IS NOT NULL AND @PRO_CODE <> ''    
    BEGIN
		SELECT @REMARK_DEB = @SUBJECT, @REMARK_CRE = @SUBJECT  
	END
    ELSE  
		SELECT @REMARK_DEB = @JUNL_NM +  ' ' + @REMARK_DEB
			, @REMARK_CRE = @JUNL_NM +  ' ' + @REMARK_CRE
      
    --======================================================================================

    -- 차변  
    IF @DEB_AMT_W  <> 0         
    BEGIN
			-- 계정코드 검색
          SELECT @USE_ACC_CD = USE_ACC_CD1,      
                 @SAVE_ACC_NO = NULL      
            FROM ACC_JUNL      
           WHERE JUNL_FG = @JUNL_FG      
             AND JUNL_CD = (CASE WHEN @PROCESS_TYPE = '0' THEN 'A' ELSE @PROCESS_TYPE END)


			-- 항목 수 만큼 나눠서 전표 생성 (반제처리)
			DECLARE @PRICE VARCHAR(200), @PRICE_PART DECIMAL, @FG_NM1 VARCHAR(40), @FG_NM2 VARCHAR(40), @FG_NM3 VARCHAR(40)
			
			IF @JUNL_FG = 'G3'			-- 공동경비
				SELECT @PRICE = (
					SELECT '[' + RIGHT(('00' + CONVERT(VARCHAR(3), GRP_SEQ_NO)), 3) + ']'
						+ CONVERT(VARCHAR(15), (PRICE * (CASE WHEN @PROCESS_TYPE = '4' THEN -1 ELSE 1 END))) + '|' AS [text()] 
					FROM SET_GROUP
					WHERE PRO_CODE = @PRO_CODE AND EDI_CODE = @EDI_CODE FOR XML PATH('')
				)
			ELSE IF @JUNL_FG = 'G4'		-- 지상비
				SELECT @PRICE = (
					SELECT '[' + RIGHT(('00' + CONVERT(VARCHAR(3), LAND_SEQ_NO)), 3) + ']'
						+ CONVERT(VARCHAR(15), (PAY_PRICE * (CASE WHEN @PROCESS_TYPE = '4' THEN -1 ELSE 1 END))) + '|' AS [text()] 
					FROM SET_LAND_AGENT 
					WHERE PRO_CODE = @PRO_CODE AND EDI_CODE = @EDI_CODE FOR XML PATH('')
				)
			ELSE
				SELECT @PRICE = ('[000]' + CONVERT(VARCHAR(15), @DEB_AMT_W) + '|')

			-- 전자결재 계좌번호 검색
			IF @JUNL_FG = 'G6'
			BEGIN
				SELECT @SAVE_ACC_NO = damo.dbo.dec_varchar('DIABLO', 'dbo.PAY_MASTER', 'PAY_NUM', B.sec_PAY_NUM) 
				FROM EDI_MASTER A WITH(NOLOCK)
				INNER JOIN PAY_MASTER_DAMO B WITH(NOLOCK) ON A.PAY_SEQ = B.PAY_SEQ
				WHERE A.EDI_CODE = @EDI_CODE
			END

			WHILE (SELECT CHARINDEX('|', @PRICE)) > 0
			BEGIN
				-- 공동경비, 지상비 지결서는 정산 순번을 비고에 추가한다
				IF @JUNL_FG IN ('G3', 'G4')
				BEGIN
					SELECT @FG_NM1 = @JUNL_FG, @FG_NM2 = @PRO_CODE, @FG_NM3 = CONVERT(INT, SUBSTRING(@PRICE, 2, 3))

					-- 지상비/공동경비 미수금 마이너스
					IF @PROCESS_TYPE = '4'
					BEGIN
						SELECT @SITE_CD1 = USE_ACC_CD1, /* 거래처-은행 */                      
					           @SAVE_ACC_NO = RTRIM(REMARK)      
						FROM ACC_JUNL WITH(NOLOCK)      
						WHERE JUNL_FG = @JUNL_FG AND JUNL_CD = 'A1'  
					END
				END
				
				SELECT @PRICE_PART = CONVERT(DECIMAL, SUBSTRING(@PRICE, 6, CHARINDEX('|', @PRICE) - 6))
			
				EXEC @RET = SP_ACC_SLIPD_INS_NEW  @SLIP_MK_DAY, @SLIP_MK_SEQ, @USE_ACC_CD, '1', @SITE_CD1, @DEPT_CD, @IN_EMP_NO,
                                        @EV_NO, @SAVE_ACC_NO, @PRICE_PART, 0, @REMARK_DEB, @EMP_NO, @FG_NM1, @FG_NM2, @FG_NM3

                                          
				IF @RET <> 0 GOTO ERR_HANDLER  

			
				SET @PRICE = SUBSTRING(@PRICE, (CHARINDEX('|', @PRICE) + 1), LEN(@PRICE))
			END         
      
    END            
	-- 대변
    IF @CRE_AMT_W  <> 0         
    BEGIN
         SELECT @USE_ACC_CD = USE_ACC_CD2                      
           FROM ACC_JUNL WITH(NOLOCK)      
          WHERE JUNL_FG = @JUNL_FG      
            AND JUNL_CD = (CASE WHEN @PROCESS_TYPE = '0' THEN 'A' ELSE @PROCESS_TYPE END)
              
         SELECT @SITE_CD2 = CASE WHEN @PROCESS_TYPE = 4 THEN @SITE_CD2 ELSE USE_ACC_CD1 END, /* 거래처-은행 */
                @SAVE_ACC_NO = RTRIM(REMARK)      
           FROM ACC_JUNL WITH(NOLOCK)     
          WHERE JUNL_FG = @JUNL_FG      
            AND JUNL_CD = 'A1'
			
		 EXEC @RET = SP_ACC_SLIPD_INS_NEW  @SLIP_MK_DAY, @SLIP_MK_SEQ, @USE_ACC_CD, '2', @SITE_CD2, @DEPT_CD, @IN_EMP_NO,       
                                       @EV_NO, @SAVE_ACC_NO, 0, @CRE_AMT_W, @REMARK_CRE, @EMP_NO, @FG_NM1, @FG_NM2, @FG_NM3 
                    
         --EXEC @RET = SP_ACC_SLIPD_INS  @SLIP_MK_DAY, @SLIP_MK_SEQ, @USE_ACC_CD, '2', @SITE_CD2, @DEPT_CD, @IN_EMP_NO,       
         --                              @EV_NO, @SAVE_ACC_NO, 0, @CRE_AMT_W, @REMARK_CRE, @EMP_NO                   
                                          
         IF @RET <> 0 GOTO ERR_HANDLER           
    END      
      
	IF @AMT_W  <> 0
	BEGIN
       INSERT INTO ACC_PUM_SLIP (EDI_CODE,  SLIP_MK_DAY,  SLIP_MK_SEQ,  INS_DT)
                         VALUES (@EDI_CODE, @SLIP_MK_DAY, @SLIP_MK_SEQ, DEFAULT)
                         
       IF @RET <> 0 GOTO ERR_HANDLER
	END
	
COMMIT TRANSACTION           
RETURN 0          
          
ERR_HANDLER:          
  ROLLBACK TRANSACTION          
  RETURN -1


  
GO
