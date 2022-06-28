USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_acc_pr_slipd_ins]
   @chk          char(3),          /* 체크 'NEW', 'ADD' */            
   @slip_mk_day  char(8),          /* 전표일자 */            
   @slip_mk_seq  smallint output,  /* 전표일련번호 */            
   @pay_seq      int,              /*----- 입금내역 PK -----*/             
   @mch_seq      int,      
   @emp_no       EMP_CODE          /* 등록사번 */            
            
as            
declare @slip_fg      char(1),    /* 수입(1) 지출(2) 대체(3) */            
        @slip_det_seq smallint    /* 전표DETAIL 일련번호 */             
                  
declare @use_acc_cd    varchar(10),      /* 계정코드 */            
        @deb_amt_w     numeric(12),      /* 차변금액 */            
        @cre_amt_w     numeric(12),      /* 대변금액 */            
        @amt_w         numeric(12),      /* 대변금액 */            
        @remark        varchar(200),     /* 비고1 */                             
        @deb_use_acc_cd char(10),       /* 차변 계정 */            
        @cre_use_acc_cd char(10),       /* 대변 계정 */            
        @ev_no         varchar(20),            
        @ev_nm         varchar(200),            
        @start_day     char(8),                    
        @in_emp_no     varchar(10),      /* 입금자사번 */                 
        @res_nm        varchar(20),      /* 예약자명 */            
        @in_nm         varchar(20),      /* 입금고객명 */                                    
        @site_cd       varchar(10),                   
        @dept_cd       varchar(10),                   
        @pay_type      int,            
        @pay_sub_type  varchar(50),            
        @pay_sub_name  varchar(50),            
        @save_acc_no   varchar(20),                    
        @res_code      varchar(20),            
        @io_day        varchar(8),           
        @junl_fg       varchar(2),                
        @ret           int                
                  
                  
Begin transaction                  
        
/* @junl_fg 'P1' 예약 'P2' 기타 */         
               
select  @junl_fg = case when b.res_code = 'R00000000000' then 'P2' else 'P1' end,             
        @io_day       = convert(char(8), a.pay_date, 112),             
        @pay_type     = a.pay_type,                      
        @pay_sub_type = a.pay_sub_type,                  
        @pay_sub_name = a.pay_sub_name,                  
        @save_acc_no  = case when a.pay_type = '0' then damo.dbo.dec_varchar('DIABLO','dbo.PAY_MASTER','PAY_NUM', a.SEC_PAY_NUM)  end,  /* 예금계좌 */                  
        @deb_amt_w   = b.part_price,             
        @cre_amt_w   = b.part_price,                   
        @amt_w       = b.part_price,                   
        @ev_no       = b.pro_code,            
        @in_nm       = a.pay_name,            
        @site_cd     = a.agt_code,            
        @in_emp_no   = a.new_code,          
        @remark      = isnull(a.pay_remark, '') + ' ' +  '입금자:' + a.pay_name ,           
        @res_code    = b.res_code,          
        @dept_cd     = (select b.team_code From emp_master_damo b where b.emp_code = a.new_code),
        @pay_type    = a.pay_type            
   from pay_master_damo a, pay_matching b          
  where a.pay_seq = @pay_seq         
    --and a.closed_yn = 'Y'         
    and a.pay_type in ( 0, 12, 13 )        
    and b.mch_seq = @mch_seq            
    and a.pay_seq = b.pay_seq    
    and b.cxl_yn = 'N'    
    and exists ( select p.pay_seq          
                   from acc_pr_slip p          
                  where p.pay_seq =  a.pay_seq        
                    and p.slip_mk_seq > 0 )          
    and not exists ( select p.pay_seq          
                       from acc_re_slip p          
                      where p.pay_seq = a.pay_seq        
                        and p.mch_seq = b.mch_seq                        
                        and p.slip_mk_seq > 0 )                 
    
    --@remark      = isnull(a.pay_remark, convert(char(10), convert(datetime, d.dep_date), 111) + ', ' +  c.pro_name),      
           
    if @junl_fg = 'P1'        
     select @res_nm      = '예약자:' + c.res_name,        
            @in_emp_no   = c.profit_emp_code,        
            @dept_cd     = c.profit_team_code,        
            @start_day   = convert(char(8), d.dep_date, 112),  
         -- @remark      = '[선수대체예약] ' + @in_nm  + ' '  + d.pro_code 
            @remark      = '[선수대체' + case @pay_type when 0 then '-은행] ' when 13 then '-ARS] ' when 12 then '-TASF] '  end
                                + @in_nm  + ' '  + d.pro_code 
       from res_master_DAMO c,pkg_detail d           
      where res_code =  @res_code        
        and c.pro_code = d.pro_code          
    else   
     select @remark      = '[선수대체기타] ' + @remark   
            
            
    if @chk = 'NEW'  and  @amt_w <> 0          
    begin            
                 
         select @slip_fg = '3' /* 대체전표 */            
         exec @slip_mk_seq = sp_acc_slipm_seq @slip_mk_day, @emp_no, @slip_fg, @junl_fg             
                
     end             
            
                
    if @deb_amt_w  <> 0            
    begin            
                  
          select @use_acc_cd = use_acc_cd1          
            from acc_junl          
           where junl_fg = @junl_fg            
             and junl_cd = convert(varchar(10),@pay_type)            
                       
            
            
               
          exec @ret = sp_acc_slipd_ins  @slip_mk_day, @slip_mk_seq, @use_acc_cd, '1', @site_cd, @dept_cd, @in_emp_no,           
                                        @ev_no, @save_acc_no, @deb_amt_w, 0, @remark, @emp_no                       
                                              
          if @ret <> 0 GOTO ERR_HANDLER               
          
    end                
                 
    if @cre_amt_w  <> 0             
    begin            
                  
                
                 
         select @use_acc_cd = use_acc_cd2                          
           from acc_junl          
          where junl_fg = @junl_fg            
            and junl_cd = convert(varchar(10),@pay_type)            
                      
            
                        
         exec @ret = sp_acc_slipd_ins  @slip_mk_day, @slip_mk_seq, @use_acc_cd, '2', @site_cd, @dept_cd, @in_emp_no,           
                                       @ev_no, @save_acc_no, 0, @cre_amt_w, @remark, @emp_no                       
                                              
         if @ret <> 0 GOTO ERR_HANDLER               
    end          
          
   if @amt_w  <> 0             
   begin          
             
    
      insert into acc_re_slip (pay_seq,  mch_seq, slip_proc_yn,  slip_mk_day, slip_mk_seq,  ins_dt)              
                       values (@pay_seq, @mch_seq, 'Y', @slip_mk_day,@slip_mk_seq, default)               
      
      if @ret <> 0 GOTO ERR_HANDLER                                                   
             
                 
  end            
            
            
            
commit transaction               
return 0              
              
ERR_HANDLER:              
  Rollback transaction              
  return -1            
            
            
              
            
            
            
            
            
            
            
            
            
            
            
          
        
      
    
  


GO
