USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
2011.06.01	PG 결제 시 결제사에 따라 더존 변경 되게 수정
2014-06-19	ACC_SLIPD 항목이 1000이상일때 ACC_SLIPM 분할 작업
*/

CREATE procedure [dbo].[sp_acc_re_slipd_ins_backup]                               
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
        @pay_type_nm   varchar(20),          
        @ret           int                                
                                  
                                  
Begin transaction                                  
                        
/* @junl_fg 'PR' 선수 'RE' 예약 'EC' 기타 */                         
select  @junl_fg = 'PR',                        
        @io_day       = convert(char(8), a.pay_date, 112),                             
        @pay_type     = a.pay_type,                                      
        @pay_sub_type = a.pay_sub_type,                                  
        @pay_sub_name = a.pay_sub_name,                                  
        @save_acc_no  = case when a.pay_type = '0' then damo.dbo.dec_varchar('DIABLO','dbo.PAY_MASTER','PAY_NUM', a.SEC_PAY_NUM) end,  /* 예금계좌 */                                  
--         @deb_amt_w   = a.pay_price,                                 
--         @cre_amt_w   = a.pay_price,        
--         @amt_w       = a.pay_price,    
        @deb_amt_w   = a.pay_price - isnull((select sum(p.part_price)                          
                                       from pay_matching p                          
                                      where p.pay_seq =  a.pay_seq      
                                        and p.cxl_yn = 'N'),0),                                 
        @cre_amt_w   = a.pay_price - isnull((select sum(p.part_price)                          
                                       from pay_matching p                          
                                      where p.pay_seq =  a.pay_seq      
                                        and p.cxl_yn = 'N'),0),        
        @amt_w       = a.pay_price - isnull((select sum(p.part_price)                          
                                       from pay_matching p                          
                                      where p.pay_seq =  a.pay_seq      
                                        and p.cxl_yn = 'N'),0),    
        @ev_no       = null,                          
        @in_nm       = a.pay_name,                            
        @site_cd     = a.agt_code,                            
        @in_emp_no   = a.new_code,                          
        @remark      = '[선수입금' + case a.pay_type when 0 then '-은행] ' when 13 then '-ARS] ' when 12 then '-TASF] '  end +  a.pay_name + ' '  + isnull(a.pay_remark, ''),                           
        @res_code    = null,                          
        @dept_cd     = (select b.team_code From emp_master_damo b where b.emp_code = a.new_code),          
        @pay_type_nm = ''                        
  from pay_master_damo a                            
 where a.pay_seq = @pay_seq                 
   and @mch_seq in ( 0, 13,12)                         
   --and a.closed_yn = 'Y'                        
   and a.pay_type  in ( 0 , 12, 13)    /* 은행입금 */                        
--    and not exists ( select p.pay_seq                          
--                       from pay_matching p                          
--                      where p.pay_seq =  a.pay_seq      
--                        and p.cxl_yn = 'N'    )             
   and a.pay_price > isnull(( select sum(p.part_price)                          
                         from pay_matching p                          
                        where p.pay_seq =  a.pay_seq      
                          and p.cxl_yn = 'N'    ),0)                  
   and not exists ( select p.pay_seq                          
                  from acc_pr_slip p                          
                     where p.pay_seq =  a.pay_seq             
                       and p.slip_mk_seq > 0 )                           
                           
union                               
select  @junl_fg = case when b.res_code = 'R00000000000' then 'ET' else 'RE' end,                           
        @io_day       = convert(char(8), a.pay_date, 112),                             
        @pay_type     = a.pay_type,                        
        @pay_sub_type = a.pay_sub_type,                                  
        @pay_sub_name = a.pay_sub_name,                                  
        @save_acc_no  = case when a.pay_type = '0' then damo.dbo.dec_varchar('DIABLO','dbo.PAY_MASTER','PAY_NUM', a.SEC_PAY_NUM)   end,  /* 예금계좌 */                                  
        @deb_amt_w   = b.part_price,                            
        @cre_amt_w   = b.part_price,                                   
        @amt_w       = b.part_price,                                   
        @ev_no       = b.pro_code,                        
        @in_nm       = a.pay_name,                            
        @site_cd     = a.agt_code,                            
        @in_emp_no   = a.new_code,                          
        @remark      = a.pay_name + ' '  + isnull(a.pay_remark, ''),                           
        @res_code    = b.res_code,                          
        @dept_cd     = (select b.team_code From emp_master_damo b where b.emp_code = a.new_code),          
        @pay_type_nm = case a.pay_type when 0 then '은행'          
                                       when 1 then '일반계좌'          
                                       when 2 then 'OFF신용카드'          
                                       when 3 then 'PG신용카드'          
                                       when 4 then '상품권'          
                                       when 5 then '현금'          
                                       when 6 then '미수대체'          
                                       when 7 then '포인트'          
                                       when 8 then '기타'          
                                       when 9 then '세금계산서'          
                                       when 10 then 'CCCF'          
                                       when 11 then 'IND_TKT'          
                                       when 12 then 'TASF' 
                                       when 13 then 'ARS' 
                                       when 14 then 'ARS호전환'
                                       when 15 then '가상계좌'
                                       when 71 then '포인트_구매실적'
                                       else '없음'  end          
          
          
   from pay_master_damo a, pay_matching b                        
  where a.pay_seq = @pay_seq                         
    --and a.closed_yn = 'Y'                             
    and a.pay_seq = b.pay_seq                       
    and b.mch_seq = @mch_seq                   
    and b.cxl_yn = 'N'                
    and not exists ( select p.pay_seq                          
                       from acc_re_slip p                          
                      where p.pay_seq = a.pay_seq                        
                        and p.mch_seq = b.mch_seq                                    
                        and p.slip_mk_seq > 0 )                      
--     and not exists ( select p.pay_seq                          
--                        from acc_pr_slip p                          
--                       where p.pay_seq = a.pay_seq                                               
--                         and p.slip_mk_seq > 0 )                      
                
                                     
    if @junl_fg = 'RE'                        
      select @res_nm      = '예약자:' + c.res_name,                        
             @in_emp_no   = c.profit_emp_code,                        
             @dept_cd     = c.profit_team_code,                        
             @start_day   = convert(char(8), d.dep_date, 112),            
             @remark      = '[예약입금-' + @pay_type_nm + '] ' + @in_nm + ' ' + d.pro_code + ' ' +  d.pro_name        
        from res_master_DAMO c,pkg_detail d                           
       where res_code =  @res_code                        
        and c.pro_code = d.pro_code           
                    
    else if @junl_fg = 'ET'            
      select @remark      = '[기타입금-' + @pay_type_nm + '] ' + @remark             
                
                                 
    --@remark      = isnull(a.pay_remark, convert(char(10), convert(datetime, d.dep_date), 111) + ', ' +  c.pro_name),         
                          
     if  @pay_type = 4          
         set @site_cd = '18095'          
--     else if @pay_type =  3	-- 2011.06.01 수정
--         set @site_cd = '18142'  
--     else if @pay_type =  13          
--         set @site_cd = '18142'          
     else if @pay_type =  12          
         set @site_cd = '80023'          
     else if @pay_type =  2          
         select @site_cd = cd          
           from acc_code          
          where cd_fg = 'CARD'          
            and cd_nm =  @pay_sub_name          
                      
                            
     if @chk = 'NEW'  and  @amt_w <> 0                          
     begin                            
                                 
         select @slip_fg = '3' /* 대체전표 */                            
         exec @slip_mk_seq = sp_acc_slipm_seq @slip_mk_day, @emp_no, @slip_fg, @junl_fg                             
                                
     end
	 -- 더존 제한으로 인해 항목 수가 1000이 넘으면 안된다.
	 ELSE IF @AMT_W <> 0 AND (SELECT COUNT(*) FROM ACC_SLIPD WHERE SLIP_MK_DAY = @slip_mk_day AND SLIP_MK_SEQ = @slip_mk_seq) >= 1000
	 BEGIN
		select @slip_fg = '3' /* 대체전표 */                            
         exec @slip_mk_seq = sp_acc_slipm_seq @slip_mk_day, @emp_no, @slip_fg, @junl_fg
	 END                    
                                
    if @deb_amt_w  <> 0                             
    begin                            
          if @pay_type = 4        
             select @use_acc_cd = use_acc_cd1                          
               from acc_junl                          
              where junl_fg = @junl_fg                            
                and junl_cd = case @pay_sub_name when '본사상품권' then '40'        
                                                 when '관광상품권' then '43'        
                                          else '4' end           
          else        
             select @use_acc_cd = use_acc_cd1                          
               from acc_junl                          
              where junl_fg = @junl_fg                            
                and junl_cd = convert(varchar(10),@pay_type)                            
                                       
          if @pay_type = 9                     
             select @deb_amt_w  = @deb_amt_w * 10 / 11             
                   
                              
          exec @ret = sp_acc_slipd_ins  @slip_mk_day, @slip_mk_seq, @use_acc_cd, '1', @site_cd, @dept_cd, @in_emp_no,                           
                                        @ev_no, @save_acc_no, @deb_amt_w, 0, @remark, @emp_no                                       
                                                              
          if @ret <> 0 GOTO ERR_HANDLER                               
                      
                    
          if @pay_type = 9                    
          begin                        
            select @use_acc_cd = use_acc_cd1                          
               from acc_junl                          
              where junl_fg = @junl_fg                            
                and junl_cd = 91                    
                      
              select @deb_amt_w      = ( @cre_amt_w - @deb_amt_w)                       
                     
              exec @ret = sp_acc_slipd_ins  @slip_mk_day, @slip_mk_seq, @use_acc_cd, '1', @site_cd, @dept_cd, @in_emp_no,                           
                                            @ev_no, @save_acc_no, @deb_amt_w, 0, @remark, @emp_no                                       
                                                              
              if @ret <> 0 GOTO ERR_HANDLER                               
          end                      
                    
                    
    end                                
                                 
    if @cre_amt_w  <> 0                             
    begin                            
                                  
                              
         if @pay_type = 4        
             select @use_acc_cd = use_acc_cd2                          
               from acc_junl                          
              where junl_fg = @junl_fg                            
                and junl_cd = case @pay_sub_name when '본사상품권' then '40'        
                                                 when '관광상품권' then '43'        
                                                 else '4' end           
          else                        
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
       if @junl_fg = 'PR'                              
         insert into acc_pr_slip (pay_seq,  slip_proc_yn, slip_mk_day, slip_mk_seq,  ins_dt)                          
                          values (@pay_seq, 'Y', @slip_mk_day,@slip_mk_seq, default)                           
      else                         
		insert into acc_re_slip (pay_seq, mch_seq, slip_proc_yn, slip_mk_day, slip_mk_seq, ins_dt)                          
                          values (@pay_seq, @mch_seq, 'Y', @slip_mk_day,@slip_mk_seq,default)                           
                                       
                                       
       if @ret <> 0 GOTO ERR_HANDLER                                                                   
                             
                                 
  end                     
                            
                            
                            
commit transaction      
return 0                                      
ERR_HANDLER:                              
  Rollback transaction                              
  return -1         
GO
