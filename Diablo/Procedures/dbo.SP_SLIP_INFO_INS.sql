USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[SP_SLIP_INFO_INS]         
          @slip_mk_day        char(8)           
        , @slip_mk_seq        smallint  
        , @slip_det_seq		  smallint
        , @slip_det_seq_old   smallint
        , @use_acc_cd         varchar(10)  
        , @dc_fg              varchar(1)  
        , @site_cd            varchar(10)  
        , @dept_cd            varchar(10)  
        , @emp_no             varchar(10)  
        , @pro_code           varchar(20)  
        , @save_acc_no        varchar(20)  
        , @deb_amt_w          numeric(12)     
        , @cre_amt_w          numeric(12)     
        , @remark             varchar(200)          
        , @ins_emp_no         varchar(10)  
        
as             
   
BEGIN TRAN          
             
declare   
    @site_cd_chk   char(1),
    @dept_cd_chk   char(1),
    @emp_no_chk    char(1),
    @pro_code_chk  char(1),
    @acc_no_chk    char(1),
    @seq_count	   smallint
   
             
begin   
	IF @slip_det_seq_old > 0 
	BEGIN
		DELETE ACC_SLIPD 
		WHERE 
            SLIP_MK_DAY = @slip_mk_day
            AND SLIP_MK_SEQ = @slip_mk_seq
            AND SLIP_DET_SEQ =  @slip_det_seq_old
	END
	         
    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRAN
        RETURN @@ERROR
    END

    SELECT @seq_count = COUNT(*) 
    FROM ACC_SLIPD
    WHERE
        SLIP_MK_DAY = @slip_mk_day
        AND SLIP_MK_SEQ = @slip_mk_seq
        AND SLIP_DET_SEQ = @slip_det_seq
    
    IF @seq_count > 0
    BEGIN
        UPDATE ACC_SLIPD
        SET SLIP_DET_SEQ = SLIP_DET_SEQ + 1
        WHERE
            SLIP_MK_DAY = @slip_mk_day
            AND SLIP_MK_SEQ = @slip_mk_seq
            AND SLIP_DET_SEQ >= @slip_det_seq
    END
    
    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRAN
        RETURN @@ERROR
    END
    
    if DATALENGTH(@remark) > 100   
       SELECT @remark = substring(@remark, 1, len(@remark) - ((DATALENGTH(@remark) - 98)))   
          
       SELECT @site_cd_chk  =  site_cd_chk,
              @dept_cd_chk  =  dept_cd_chk,
              @emp_no_chk   =  emp_no_chk,
              @pro_code_chk =  pro_code_chk,
              @acc_no_chk   =  acc_no_chk
       FROM acc_account
       WHERE USE_ACC_CD = @use_acc_cd            
    
         insert acc_slipd
                       ( slip_mk_day, slip_mk_seq, slip_det_seq, use_acc_cd, 
                         dc_fg, deb_amt_w, cre_amt_w,                        
                         remark, 
                         site_cd, 
                         dept_cd, 
                         emp_no,
                         pro_code, 
                         save_acc_no,                          
                         ins_dt,      ins_emp_no   
                       )   
                values ( @slip_mk_day, @slip_mk_seq, @slip_det_seq, @use_acc_cd,
                         @dc_fg , @deb_amt_w,  @cre_amt_w,
                         @remark,                         
                         case when @site_cd_chk = 'Y' then @site_cd end,
                         case when @dept_cd_chk = 'Y' then @dept_cd end,
                         case when @emp_no_chk = 'Y' then @emp_no end,
                         case when @pro_code_chk = 'Y' then @pro_code end,
                         case when @acc_no_chk = 'Y' then @save_acc_no end,                        
                         default,    @ins_emp_no  
                         )  
                      
    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRAN
        RETURN @@ERROR
    END
           
end    
    
COMMIT TRAN

GO
