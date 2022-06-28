USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec sp_acc_slipd_send '20100419', 3,'N',  '9999999'    
      
CREATE procedure [dbo].[sp_acc_slipd_send]              
   @slip_mk_day char(8),                   
   @slip_mk_seq smallint,                 
   @del_yn      char(1),                
   @emp_no      varchar(10)                      
                 
                
as                
                
begin                
declare @fix_yn       char(1),                
        @slip_cnt     smallint,                
        @ev_ym        varchar(6),                
        @ev_seq       smallint,                 
        @slip_fg      char(1),                
        @amt_gubun    char(1),                
        @deb_amt      numeric(10),                
        @cre_amt      numeric(10),                
        @use_acc_cd   varchar(10),                
        @fg_nm1       varchar(40),                
        @fg_nm2       varchar(40),                
        @fg_nm3       varchar(40),                
        @slip_det_seq smallint,                 
        @ins_dt       char(8),                
        @ins_emp_no   varchar(10),                
        @ac001_emp_no varchar(10),                
        @ac001_emp_nm varchar(20),                
        @dept_code    varchar(20),                
        @data_gubun   varchar(2),                
        @node_code    varchar(4),                
        @site_cd      varchar(20),                    
        @acct_code    varchar(10),                
        @remark       varchar(100),                
        @pro_name     varchar(100),                 
        @pro_code     varchar(20),              
        @save_acc_no  varchar(20),               
        @dept_cd      varchar(10),                   
        @c_code       varchar(4),              
        @site_cd_chk   char(1),              
        @dept_cd_chk   char(1),              
        @emp_no_chk    char(1),              
        @pro_code_chk  char(1),              
        @acc_no_chk    char(1)                 
                
declare @junl_fg       varchar(2),                
        @check_code    varchar(3),                
        @check_code1   varchar(3),                
        @check_code2   varchar(3),                
        @check_code3   varchar(3),                
        @check_code4   varchar(3),                
        @check_code5   varchar(3),                
        @check_code6   varchar(3),                 
        @check_code7   varchar(3),                
        @check_code8   varchar(3),                
        @check_code9   varchar(3),                
        @check_code10  varchar(3),                
        @checkd_code   varchar(20),                
        @checkd_code1  varchar(20),                
        @checkd_code2  varchar(20),                
        @checkd_code3  varchar(20),                
        @checkd_code4  varchar(20),                
        @checkd_code5  varchar(20),                
        @checkd_code6  varchar(20),                
        @checkd_code7  varchar(20),                
        @checkd_code8  varchar(20),                
        @checkd_code9  varchar(20),                
        @checkd_code10 varchar(20),                
        @checkd_name   varchar(100),                
        @checkd_name1  varchar(100),                
        @checkd_name2  varchar(100),                
        @checkd_name3  varchar(100),                
        @checkd_name4  varchar(100),                
        @checkd_name5  varchar(100),                
        @checkd_name6  varchar(100),                
        @checkd_name7  varchar(100),                
        @checkd_name8  varchar(100),                
        @checkd_name9  varchar(100),                
        @checkd_name10 varchar(100),                
        @busi_no       varchar(15),                
        @gong_amt      numeric(10),                
        @publ_day      varchar(8),                
        @serial_no     smallint                
                
                
                                
 select @c_code = '3000'                
                        
                
 select @fix_yn = max(docu_stat),                
        @slip_cnt = count(*)                
   from dzdb.dzais.dzais.AUTODOCU                
  where write_date = @slip_mk_day                
    and data_no = @slip_mk_seq                
                
                
 if @fix_yn = '1'                
    return -9                
               
                 
 if @slip_cnt > 0           
 begin                 
                
      delete                 
        from dzdb.dzais.dzais.AUTODOCU                
       where write_date = @slip_mk_day                
         and data_no = @slip_mk_seq                
              
      delete                 
        from dzdb.dzais.dzais.taxrela                
       where write_date = @slip_mk_day                
         and data_no = @slip_mk_seq                
                
      delete                 
        from dzdb.dzais.dzais.taxrela2                
       where write_date = @slip_mk_day                
         and data_no = @slip_mk_seq                
       
      update acc_slipm
         set dz_send_dt = null
       where slip_mk_day = @slip_mk_day
         and slip_mk_seq = @slip_mk_seq

         
 end                
                
 if @del_yn = 'Y'
    return 0
                
                
/*                
 select @junl_fg = junl_fg,                
 @ac001_emp_nm = nm                 
   from ac001 a, em001 e                     
  where a.slip_mk_day = @slip_mk_day                
    and a.slip_mk_seq = @slip_mk_seq                
    and a.emp_no = e.emp_no                
*/


 select @junl_fg = a.junl_fg,                
        @ac001_emp_no = a.emp_no              
   from acc_slipm a              
  where a.slip_mk_day = @slip_mk_day                
    and a.slip_mk_seq = @slip_mk_seq                
                 
                
                
 if @junl_fg = 'EV'                
    select @pro_code = max(pro_code)                
      from acc_slipd              
     where slip_mk_day = @slip_mk_day                
      and slip_mk_seq = @slip_mk_seq                  
 else                
    select @pro_code = ''                
                
                
 select @dept_code = dept_code,                
        @node_code = node_code,                
        @ac001_emp_no = sno,                
        @ac001_emp_nm = KNAME                
   from dzdb.dzais.dzais.vbase_perinfo                
  where c_code = @c_code                
    and JAEJIK_GU = '100'                
    and sno = @ac001_emp_no                
                   
                 
 if @dept_code is null                
     select @dept_code = '5120'  /* 회계 */                
                 
 if @node_code is null                
     select @node_code = '2000'                
               
 /*                
 select @data_gubun = isnull(char_fr, '22')                
   from ba001                
  where cd_fg = 'JRNL'                
    and cd = @junl_fg                
 */                
                 
 if @data_gubun = '' or @data_gubun is null                
    select @data_gubun = '22'                
                 
                
                
  declare cur_1 scroll cursor for                
                
            
        select a.slip_fg,                
          case a.slip_fg  when '1' then '1'                 
                          when '2' then '2'                
                          else case when b.deb_amt_w <> 0 then '3'                
                                    else '4' end end ,                            
          b.deb_amt_w,                
          b.cre_amt_w,                
          b.use_acc_cd,                
          b.site_cd,                
          b.dept_cd,                
          b.emp_no,              
          b.pro_code,                
          b.save_acc_no,                
          c.site_cd_chk,              
          c.dept_cd_chk,              
          c.emp_no_chk,              
          c.pro_code_chk,              
          c.acc_no_chk,              
          b.slip_det_seq,                
          b.ins_dt,                
          b.ins_emp_no,                          
          isnull(b.remark,'')              
     from acc_slipm a, acc_slipd b, acc_account c              
    where a.slip_mk_day = @slip_mk_day                
      and a.slip_mk_seq = @slip_mk_seq                
      and a.slip_mk_day = b.slip_mk_day                
      and a.slip_mk_seq = b.slip_mk_seq                
      and b.use_acc_cd = c.use_acc_cd                       
 order by a.slip_mk_day,                
          a.slip_mk_seq,                
          b.slip_det_seq            
 open cur_1                
                
 fetch next from cur_1 into @slip_fg,                
                            @amt_gubun,                                          
                            @deb_amt,                
                            @cre_amt,                
                            @acct_code,                
                            @site_cd,                
                            @dept_cd,                
                            @emp_no,              
                            @pro_code,              
                            @save_acc_no,                
                            @site_cd_chk,                
                            @dept_cd_chk,                
                            @emp_no_chk,                
                            @pro_code_chk,                
                            @acc_no_chk,                                         
                            @slip_det_seq,                 
                            @ins_dt,                
                            @ins_emp_no,                                           
                            @remark                
                                            
 while ( @@fetch_status <> -1 )                
 begin                 
                    
                    
        select @busi_no = null,                
               @gong_amt = null                
                           
        select @check_code1 = null,  @checkd_code1 = null,  @checkd_name1 = null,                
               @check_code2 = null,  @checkd_code2 = null,  @checkd_name2 = null,                
               @check_code3 = null,  @checkd_code3 = null,  @checkd_name3 = null,                
               @check_code4 = null,  @checkd_code4 = null,  @checkd_name4 = null,                
               @check_code5 = null,  @checkd_code5 = null,  @checkd_name5 = null,                
               @check_code6 = null,  @checkd_code6 = null,  @checkd_name6 = null,                
               @check_code7 = null,  @checkd_code7 = null,  @checkd_name7 = null,                
               @check_code8 = null,  @checkd_code8 = null,  @checkd_name8 = null,                
               @check_code9 = null,  @checkd_code9 = null,  @checkd_name9 = null,                
               @check_code10 = null, @checkd_code10 = null, @checkd_name10 = null                 
                           
--      select serial_no, check_code                
--        into #temp                
--        from dzdb.dzais.dzais.checkcha                
--       where c_code = '3000'                
--         and acct_code = @acct_code                
--    order by serial_no                
                 
--       insert into dz_checkcha                
--       select acct_code, serial_no, check_code                
--         from dzdb.dzais.dzais.checkcha                
--        where c_code = '3000'                
--     order by acct_code, serial_no                 
                     
                   
    declare cur_2 scroll cursor for                
                   
        select serial_no, check_code                
          from acc_checkcha                
         where acct_code = @acct_code                
      order by serial_no                  
      
                
   open cur_2                
                   
   fetch next from cur_2 into  @serial_no, @check_code                
                   
   while ( @@fetch_status <> -1 )                
   begin                 
                           
                    
      select @checkd_code = null,                
             @checkd_name = null                
                      
                   
        
      
      if @check_code = 'A07'   /* 거래처 */                
      begin                
                     
         if @acct_code in( '12302', '27400' )  /* 카드미수금, 상품권예수금 */

          select @checkd_code = DZ_CODE,                
                 @checkd_name = DZ_NAME,                
                 @site_cd = DZ_CODE                           
            from acc_code
           where cd_fg = 'CARD'
             and cd = @site_cd   
         else

         begin  

          select @busi_no = agt_register              
            from agt_master              
           where agt_code = @site_cd              
                   
          select @checkd_code = CUST_CODE,                
                 @checkd_name = CUST_NAME,                
                 @site_cd = CUST_CODE                           
            from dzdb.dzais.dzais.VBASE_TRADE                
           where S_IDNO = @busi_no                
             and c_code = @c_code                

         end           
      end                     
                    
      else if @check_code in ( 'A01', 'A09', 'A11')   /* 부서 */                
      begin                
                   
         select @checkd_code = isnull(rtrim(dz_code), '5120')                
                --@checkd_name = isnull(rtrim(dz_name), '관리본부')                
           from acc_code              
          where cd_fg = 'DEPT'                
            and cd = @dept_cd              
               
         select @checkd_code = DEPT_CODE,                
                @checkd_name = DEPT_NAME                          
           from dzdb.dzais.dzais.VBASE_STANDARD_DEPT                
          where DEPT_CODE = @checkd_code                
            and c_code = '3000'                
               
                 
      end                  
                     
      else if @check_code = 'A03'     /* 금융기관 */                
      begin                
                   
         select @checkd_code = dz_code,                
                @checkd_name = dz_name              
           from acc_code               
          where cd_fg = 'BANK'                
            and cd = @site_cd                
                   
--          select @checkd_code = CHECKD_CODE,                 
--                 @checkd_name = CHECKD_NAME                          
--            from dzdb.dzais.dzais.CHECKD                
--           where CHECK_CODE = @check_code                 
--             and CHECKD_CODE = @checkd_code                
--             and c_code = '3000'                       
                      
      end                  
      else if @check_code = 'A05'  /* 표준적요 */                
      begin                
                      
          select @checkd_code = null,                 
                 @checkd_name = @remark    
                 --@checkd_name = case when @pro_code_chk = 'Y' then @pro_code  else '' end + ' '  + substring(@remark,1,40)                           
              
                                                   
                
      end                    
      else if @check_code = 'F05'    /* 계좌번호 */                
      begin                
                   
         select @save_acc_no = dz_name              
           from acc_code              
          where cd_fg = 'BACC'              
            and cd = @save_acc_no              
                   
         select @checkd_code = DEPOSIT_NO,                 
                @checkd_name = DEPOSIT_NAME                          
           from dzdb.dzais.dzais.DEPOSITMA                          
          where DEPOSIT_NO = @save_acc_no                
            and NODE_CODE = @node_code                
            and c_code = @c_code                
                   
      end                
      else if @check_code = 'T01'   and @acct_code in ('13500', '25500')    /* 세무구분 */                     
                   
--          select @checkd_code = CHECKD_CODE,                 
--                 @checkd_name = CHECKD_NAME                          
--            from dzdb.dzais.dzais.CHECKD                
--           where CHECK_CODE = @check_code                 
--             and CHECKD_CODE = case when @acct_code = '13500' then '21' else '14' end                 
--             and c_code = @c_code                
                          
              select @checkd_code = case when @acct_code = '13500' then '21' else '14' end,                 
                     @checkd_name = case when @acct_code = '13500' then '과세(매입세금계산서)' else '기타(매출)' end      
               
      else if @check_code = 'T03'   and @acct_code in ('13500', '25500')     /* 과세표준 */                   
      begin                
                    
        select @gong_amt = isnull(deb_amt_w,0) + isnull(cre_amt_w,0)                
          from acc_slipd              
         where slip_mk_day = @slip_mk_day                
           and slip_mk_seq = @slip_mk_seq                
           and slip_det_seq = @slip_det_seq - 1                 
                   
        select @checkd_code = null,                 
               @checkd_name = convert(varchar(12), @gong_amt)                
      end                          
      else if @check_code = 'F19'  /* 발행일자 */                
      begin                 
                       
         if @acct_code in ('13500', '25500'   )                        
            select @checkd_code = null,                 
                   @checkd_name = @slip_mk_day                
                   
         select @publ_day = @checkd_name                
        
      end                  
      else if @check_code = 'A13'    /* PROJECT-행사번호  */                
      begin                  
                      
                   
           select @pro_name =  @pro_code + substring(pro_name, 1,8)                
             from pkg_detail              
            where pro_code = @pro_code                         
                   
        
           select @checkd_code = duz_code,        
                  @checkd_name = @pro_name                        
             from ACC_MATCHING        
            where pro_code = @pro_code                         
                       
                   
      end                  
                      
                                                           
                
     if @checkd_name is not null                      
     begin                 
                     
     if @serial_no = 1                
        select @check_code1  = @check_code,                
               @checkd_code1 = @checkd_code,                
       @checkd_name1 = @checkd_name                
     else if @serial_no = 2                
        select @check_code2  = @check_code,                
               @checkd_code2 = @checkd_code,                
               @checkd_name2 = @checkd_name                 
     else if @serial_no = 3                
        select @check_code3  = @check_code,                
               @checkd_code3 = @checkd_code,                
               @checkd_name3 = @checkd_name                 
     else if @serial_no = 4                
        select @check_code4  = @check_code,                
               @checkd_code4 = @checkd_code,                
               @checkd_name4 = @checkd_name                 
     else if @serial_no = 5                
        select @check_code5  = @check_code,                
               @checkd_code5 = @checkd_code,                
               @checkd_name5 = @checkd_name                 
     else if @serial_no = 6                
        select @check_code6  = @check_code,                
               @checkd_code6 = @checkd_code,                
               @checkd_name6 = @checkd_name                 
     else if @serial_no = 7                
        select @check_code7  = @check_code,                
        @checkd_code7 = @checkd_code,                
               @checkd_name7 = @checkd_name                 
     else if @serial_no = 8                
        select @check_code8  = @check_code,                
               @checkd_code8 = @checkd_code,                
               @checkd_name8 = @checkd_name                 
     else if @serial_no = 9                
        select @check_code9  = @check_code,                
               @checkd_code9 = @checkd_code,                
               @checkd_name9 = @checkd_name                 
     else if @serial_no = 10                
        select @check_code10  = @check_code,                
               @checkd_code10 = @checkd_code,                
               @checkd_name10 = @checkd_name                 
                               
    end                
                   
     fetch next from cur_2 into  @serial_no, @check_code                                  
                
                    
   end                
                
   close      cur_2                
   deallocate cur_2                
                  
                 
     insert into dzdb.dzais.dzais.AUTODOCU                
            ( data_gubun, write_date, data_no, data_line, data_slip,                
              dept_code, node_code, c_code, docu_stat,                
              docu_type, docu_gubun, amt_gubun, dr_amt, cr_amt, acct_code,                
              check_code1, check_code2,check_code3,check_code4,check_code5,                 
              check_code6, check_code7,check_code8,check_code9,check_code10,                 
              checkd_code1, checkd_code2,checkd_code3,checkd_code4,checkd_code5,                 
              checkd_code6, checkd_code7,checkd_code8,checkd_code9,checkd_code10,                 
              checkd_name1, checkd_name2,checkd_name3,checkd_name4,checkd_name5,                 
              checkd_name6, checkd_name7,checkd_name8,checkd_name9,checkd_name10,                 
              insert_date, insert_id )                  
     values                
            ( @data_gubun, @slip_mk_day, @slip_mk_seq, @slip_det_seq, 1,                
              @dept_code, @node_code, @c_code,  '0',                
              '11', @slip_fg, @amt_gubun, @deb_amt, @cre_amt, @acct_code,                
              @check_code1,  @check_code2, @check_code3,  @check_code4, @check_code5,                
              @check_code6,  @check_code7, @check_code8,  @check_code9, @check_code10,                
              @checkd_code1, @checkd_code2,@checkd_code3, @checkd_code4,@checkd_code5,                
              @checkd_code6, @checkd_code7,@checkd_code8, @checkd_code9,@checkd_code10,                
              @checkd_name1, @checkd_name2,@checkd_name3, @checkd_name4,@checkd_name5,                
              @checkd_name6, @checkd_name7,@checkd_name8, @checkd_name9,@checkd_name10,                
              @ins_dt, @ins_emp_no )                
                 
                 
     /* 부가세예수금은 세금계산서가 없으므로 필요없음 */                
     /* 부가세대급금 */                
                     
     if @acct_code in ( '13500' , '25500' )                        
     begin                
                  
                 
        insert into dzdb.dzais.dzais.taxrela                
            ( data_gubun, write_date, data_no, data_line, data_slip,                
              dept_code, node_code, c_code,                 
              bal_date, ven_type, tax_gu,                 
              gong_amt, tax_vat, ven_code, s_idno,                 
              gong_amt2 )                
        values                
            ( @data_gubun, @slip_mk_day, @slip_mk_seq, @slip_det_seq, 1,                
              @dept_code, @node_code, @c_code,                
              @publ_day, case when @acct_code = '13500' then '0' else '1' end , case when @acct_code = '13500' then  '21' else '14' end,                
              @gong_amt, case when @acct_code = '13500' then  @deb_amt else @cre_amt end , @site_cd, @busi_no,                
              0 )                 
                         
                 
        insert into dzdb.dzais.dzais.taxrela2                
            ( data_gubun, write_date, data_no, data_line, data_slip,                
              dept_code, node_code, c_code,                 
              taxsub_no, monday, pummok, mu_size, qty, price,                
              supply_price, vat_price )                
        values                
            ( @data_gubun, @slip_mk_day, @slip_mk_seq, @slip_det_seq, 1,                
              @dept_code, @node_code, @c_code,                
              1, substring(@publ_day,5,4), null, null, 1, @gong_amt,                
              @gong_amt, case when @acct_code = '13500' then  @deb_amt  else @cre_amt end )                
                  
     end                
                 
                 
--      drop table #temp                
                
      fetch next from cur_1 into @slip_fg,            
                                 @amt_gubun,                                          
                                 @deb_amt,                
                                 @cre_amt,                
                                 @acct_code,                
                                 @site_cd,                
                                 @dept_cd,                
                                 @emp_no,              
                                 @pro_code,              
                                 @save_acc_no,                
                                 @site_cd_chk,                
                                 @dept_cd_chk,                
                                 @emp_no_chk,                
                                 @pro_code_chk,                
                                 @acc_no_chk,                                         
                                 @slip_det_seq,                 
                                 @ins_dt,                
                                 @ins_emp_no,                                           
                                 @remark                
                
                     
                
                       
  end                
           
                
 close      cur_1                             
                             
 deallocate cur_1                                       
 
               
  update acc_slipm
     set dz_send_dt = getdate()
   where slip_mk_day = @slip_mk_day
     and slip_mk_seq = @slip_mk_seq

    
  exec sp_acc_slipd_send1 @slip_mk_day, @slip_mk_seq                
                
end                
                
              
            
          
        
      
    
  

GO
