USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_acc_ev_slipd_ins]                  
   @chk          char(3),          /* 체크 'NEW', 'ADD' */                         
   @pro_code     varchar(20),      /*        */                       
   @slip_mk_day  char(8),          /* 전표일자          */                        
   @slip_mk_seq  smallint output,  /* 전표일련번호 */                    
   @emp_no       varchar(10)       /* 사번              */                    
                       
                    
                    
as                    
declare @slip_det_seq smallint                         
     ,  @slip_fg      char(1)                        
     ,  @deb_sum      numeric(12)                    
     ,  @cre_sum      numeric(12)                    
     ,  @jan_amt      numeric(12)                    
                    
declare @use_acc_cd   varchar(10),                            
        @site_cd      varchar(10),                    
        @site_nm      varchar(40),                    
        @ins_emp_no   varchar(10),                    
        @emp_nm       varchar(40),                            
        @calc_cd      varchar(4),                                    
        @money_cd     char(1),                    
        @amt_f        numeric(12,2),                    
        @amt_w        numeric(12),                           
        @calc_seq   smallint,                    
        @person_cnt   smallint,                    
        @deb_amt_w    numeric(12),                     
        @cre_amt_w    numeric(12),                     
        @deb_amt_f    numeric(12,2),                    
        @amt_1000     numeric(12),                     
        @amt_1001     numeric(12),                             
        @remark       varchar(200),                            
        @bohum_site_nm  varchar(40),                    
        @bohum_site_cd  varchar(10),                             
        @start_day    varchar(8),                    
        @dc_fg        char(1),                            
        @in_out       char(2),                            
        @cha_dept_cd      varchar(10),                          
        @cha_dept_nm      varchar(30),                  
        @ret           int,
        @slip_det_cnt  smallint                              
                          
Begin transaction                    
                    
                    
     select @deb_sum = 0,                    
            @cre_sum = 0,                    
            @jan_amt = 0,
            @slip_det_cnt= 0                    
                    
                
--    select a.ins_code, b.kor_name From pkg_detail a                
--     inner join agt_master b on a.ins_code = b.agt_code                
--     where a.pro_code = 'jpy111-100117'                
                
                
                
     select @bohum_site_cd = a.ins_code                    
       from pkg_detail a                  
      where a.pro_code = @pro_code                          
                          
     select @cha_dept_cd = a.profit_team_code,                  
            @start_day = isnull(convert(char(8), a.dep_date, 112),'')                   
       from set_master a                  
      where a.pro_code = @pro_code                          
                    
-- select isnull((SALE_PRICE - AIR_PRICE - AIR_PROFIT - ISNULL(AIR_ETC_COM_PRICE, 0) + - ISNULL(AIR_ETC_COM_PROFIT, 0) - AIR_ETC_PRICE + AIR_ETC_PROFIT) , 0)            
-- from DBO.FN_SET_GET_COMPLETE('APF233-100401')              
--                     
--                     
                    
     /* 수탁금 */                  
--     select @amt_1000 = isnull((SALE_PRICE - AIR_PRICE - AIR_PROFIT + AIR_ETC_COM_PRICE - AIR_ETC_PRICE + AIR_ETC_PROFIT) , 0)                          
--      from DBO.FN_SET_GET_COMPLETE(@pro_code)                
                          
 declare cur_1 scroll cursor for                    
                    
                    
  select 'A',                  
         null,                    
         a.new_code,                  
         '1',                  
         (select isnull((SALE_PRICE - AIR_PRICE - AIR_PROFIT - AIR_ETC_PRICE + AIR_ETC_PROFIT) , 0)            
   from DBO.FN_SET_GET_COMPLETE(@pro_code)),                         
         '수탁금'                           
    from set_master a               
   where pro_code = @pro_code                           
     and  not exists ( select p.pro_code                  
                       from acc_ev_slip p                  
                 where p.pro_code =  a.pro_code )                    
union all                    
 select 'B',                  
         a.agt_code,                  
         a.new_code,                     
         '2',                  
         a.pay_price,                  
         convert(varchar(5), a.land_seq_no) + ' ' +                    
         isnull(@start_day,'') +  ' ' +                       
         convert(varchar(12), convert(int, a.korean_price)) + ' * ' +  convert(varchar(3), a.res_count) + ' ' +                    
         case when a.exc_rate > 1 then                  
              '(' + convert(varchar(12), convert(int, a.foreign_price))  +' * ' +  convert(varchar(3), a.res_count) + ')' else '' end                    
   from  set_land_agent a                  
  where  pro_code = @pro_code                   
    and  a.pay_price <> 0                
    and  not exists ( select p.pro_code                  
                       from acc_ev_slip p                  
       where p.pro_code =  a.pro_code )                    
                                                
union all                  
  select 'C',        
         '90052',                  
         a.new_code,                                          
         '2',                  
         a.price,      
        '공통경비'                          
--          convert(varchar(5), a.grp_seq_no) + ' ' +                             
--          convert(varchar(12), a.korean_price) + ' * ' +  convert(varchar(3), 1) + ' ' +                    
--          case when a.exc_rate > 1 then                  
--               '(' + convert(varchar(12), a.foreign_price)  +' * ' +  convert(varchar(3), 1) + ')' else ''  end                    
   from  set_group a                
  where  pro_code = @pro_code                  
    and  a.korean_price <> 0                            
    and  not exists ( select p.pro_code                  
                        from acc_ev_slip p                  
                       where p.pro_code =  a.pro_code )                    
union all                  
 select 'D',                  
         @bohum_site_cd,                  
         min(a.new_code),                                          
         '2',                  
         sum(a.ins_price),                           
         '보험료'                  
   from  set_customer a                  
  where  pro_code = @pro_code                      
    and  a.ins_price <> 0                         
    and  not exists ( select p.pro_code                  
                        from acc_ev_slip p                  
                       where p.pro_code =  a.pro_code )                    
                    
order by 1                  
                    
                    
open cur_1                    
                    
fetch next from cur_1 into  @calc_cd      ,                                              
                            @site_cd      ,                                             
                            @ins_emp_no   ,                    
                            @dc_fg        ,                  
                            @amt_w        ,                                                
                            @remark                     
                     
                     
while ( @@fetch_status <> -1 )                    
   begin                     
                    
     if @chk = 'NEW'                    
     begin                    
                         
       select @slip_fg = '3'               
       exec @slip_mk_seq = sp_acc_slipm_seq @slip_mk_day, @emp_no, @slip_fg, 'EV'                 
       set @chk = 'ADD'                  
                                
     end                     
     
           select @remark = '[정산] ' + a.pro_code 
				+ ' / ' 
				+ (SELECT Z.TEAM_NAME FROM EMP_TEAM Z WHERE Z.TEAM_CODE = B.TEAM_CODE) 
				+ ' / ' + 
				+ B.KOR_NAME
             from pkg_detail a
             inner join emp_master_damo b on b.emp_CODE = a.new_code
            where a.pro_code = @pro_code             
          
                    
      if isnull(@amt_w,0) <> 0              
      begin              
        select @use_acc_cd = use_acc_cd1,                  
               @deb_amt_w = case when @dc_fg = '1' then @amt_w else 0 end,                              @cre_amt_w = case when @dc_fg = '2' then @amt_w else 0 end                  
          from acc_junl                  
         where junl_fg = 'EV'                    
           and junl_cd = @calc_cd                  
                     
                    
        exec @ret = sp_acc_slipd_ins  @slip_mk_day, @slip_mk_seq, @use_acc_cd, @dc_fg, @site_cd, @cha_dept_cd, @ins_emp_no,                   
                                      @pro_code, null,@deb_amt_w, @cre_amt_w, @remark, @emp_no                               
                                                      
        if @ret <> 0 GOTO ERR_HANDLER                       
                    
                         
        select @deb_sum = @deb_sum + (case when @dc_fg = '1' then @deb_amt_w else 0 end),                    
               @cre_sum = @cre_sum + (case when @dc_fg = '1' then 0 else @cre_amt_w end),
               @slip_det_cnt = @slip_det_cnt + 1                     
      end              
                    
            
      fetch next from cur_1 into  @calc_cd      ,                                              
                                  @site_cd      ,                                             
                                  @ins_emp_no   ,                    
                                  @dc_fg        ,                  
                                  @amt_w    ,                                           
                                  @remark                     
                    
                    
   end                    
/* Cursor Close */                    
                    
close      cur_1                    
                    
/* Cursor Deallocate */                    
deallocate cur_1                              
                    
                     
 select @jan_amt = isnull(@deb_sum,0) - isnull(@cre_sum,0)                    
                    
 if @jan_amt <> 0                     
 begin                    
                       
                           
      select @use_acc_cd = use_acc_cd1,                  
             @dc_fg = '2',                  
             @site_cd = null,                  
             @deb_amt_w = 0,                    
             @cre_amt_w = case when @jan_amt < 11000 then @jan_amt else @jan_amt * 10 / 11 end                    
        from acc_junl                  
       where junl_fg = 'EV'                    
         and junl_cd = 'P'                  
                    
                       
      exec @ret = sp_acc_slipd_ins  @slip_mk_day, @slip_mk_seq, @use_acc_cd, @dc_fg, @site_cd, @cha_dept_cd, @ins_emp_no,                   
                                    @pro_code, null, @deb_amt_w, @cre_amt_w, @remark, @emp_no                               
                                                      
      if @ret <> 0 GOTO ERR_HANDLER                        
                    
 end                    
 if @jan_amt >= 11000                     
 begin                    
    /* 부가세예수금 */                    
      select @use_acc_cd = use_acc_cd1,                  
             @dc_fg = '2',                  
             @site_cd = null,                  
             @deb_amt_w = 0,                    
             @cre_amt_w = @jan_amt * 1 / 11                  
        from acc_junl                  
       where junl_fg = 'EV'                    
         and junl_cd = 'Q'       
                    
                    
      exec @ret = sp_acc_slipd_ins  @slip_mk_day, @slip_mk_seq, @use_acc_cd, @dc_fg, @site_cd, @cha_dept_cd, @ins_emp_no,                   
                                    @pro_code, null, @deb_amt_w, @cre_amt_w, @remark, @emp_no                               
                                                      
      if @ret <> 0 GOTO ERR_HANDLER                         
                      
 end                    
                    
 if  isnull(@deb_sum,0) <> 0 or  isnull(@cre_sum,0) <> 0  or @slip_det_cnt > 0                   
 begin                    
 insert into acc_ev_slip (pro_code,  slip_mk_day,  slip_mk_seq,  ins_dt)                  
                      values (@pro_code, @slip_mk_day, @slip_mk_seq, default)                   
                               
                               
     if @ret <> 0 GOTO ERR_HANDLER                                                           
                     
 end                       
                             
                     
                     
commit transaction                     
return 0                    
                    
ERR_HANDLER:                    
  Rollback transaction                    
  return -1                    
                    
                
              
            
          
        
      
    
  

GO
