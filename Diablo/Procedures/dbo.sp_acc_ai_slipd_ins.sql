USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec sp_acc_ai_slipd_ins 'NEW', '20100408',0,'jpy111-100117','20091103', 'mclick'                
CREATE procedure [dbo].[sp_acc_ai_slipd_ins]                  
         @chk              char(3),          /* 체크 'NEW', 'ADD'        */                    
         @slip_mk_day      char(8),          /* 전표일자                 */                    
         @slip_mk_seq      smallint output,  /* 전표일련번호             */                    
         @pro_code         varchar(20),                                              
         @tckout_day       datetime,                    
         @emp_no           varchar(10)       /* 등록사번                 */                    
as                                                       
                    
                    
declare  @slip_fg          char(1),          /* 수입(1) 지출(2) 대체(3)  */                                                            
         @use_acc_cd       varchar(10),          /* 계정코드                 */                                                           
         @tck_cnt          numeric(12),      /* 티켓수                   */                             
         @air_cd_short     varchar(10),                                   
         @remark           varchar(100),      /* 비고11                   */                             
         @amt_w            numeric(12),                                   
         @start_day        char(8),                                   
         @comm_amt         numeric(12),                     
         @comm_vat         numeric(12),                                   
         @card_amt         numeric(12),                    
         @cash_amt         numeric(12),                    
         @tot_card_amt     numeric(12),                    
         @tot_cash_amt     numeric(12),                             
         @pan_dept_cd      varchar(10),                                  
         @pan_emp_no       varchar(10),                            
         @min_tck_no       varchar(10),                    
         @max_tck_no       varchar(10),                       
         @tck_no           varchar(10),               
         @site_cd          varchar(10),                               
         @ret              int,
         @issue_code		varchar(10)                                                
                    
                    
Begin transaction                     
                    
                     
                    
                   
   select @chk  = 'NEW',                  
          @tot_cash_amt = 0,                  
          @tot_card_amt = 0                  
                    
                    
   declare cur_1 scroll cursor for                    
                     
         select isnull(sum(b.cash_price),0),                       
                isnull(sum(b.card_price),0),                             
                count(*),                    
                isnull(sum(b.comm_price),0),                    
                isnull(sum(b.comm_price),0) * 0.1,                           
                min(b.sale_code),                    
        min(a.team_code),                  
                min(b.ticket),                    
                max(b.ticket),                  
                b.airline_code,                     
                min(isnull(convert(char(8), b.start_date, 112),''))   ,
                min(issue_code)                                      
           from dsr_ticket b, emp_master_damo a                  
          where b.issue_date = @tckout_day                
            --convert(char(8), b.issue_date, 112) = @tckout_day                    
            and b.pro_code = @pro_code                                        
            and b.ticket_status = 1  /*정상티켓*/                    
            and isnull(b.cash_price,0) + isnull(b.card_price,0) <> 0                    
            and not exists ( select a.ticket                  
                               from acc_dsr_slip a                  
                              where a.ticket =  b.ticket )                    
            and b.sale_code = a.emp_code                                       
      group by isnull(b.cash_price,0),                       
               isnull(b.card_price,0),                 
               b.airline_code                                                           
                     
            
                     
                    
   open cur_1                    
                    
  fetch next from cur_1 into  @cash_amt,                  
                              @card_amt,                    
                              @tck_cnt,                    
                              @comm_amt,                    
                              @comm_vat,                    
                              @pan_emp_no,                    
                              @pan_dept_cd,                    
                              @min_tck_no,                    
                              @max_tck_no,                    
                              @air_cd_short,                                                
                              @start_day,
                              @issue_code                                   
                                              
                     
                    
 while ( @@fetch_status <> -1 )                    
   begin                     
                    
     if @chk = 'NEW'  and  @cash_amt + @card_amt <> 0                   
     begin                    
                        
       select @slip_fg = '3'                              
       exec @slip_mk_seq = sp_acc_slipm_seq @slip_mk_day, @emp_no, @slip_fg, 'AI'                     
       select @chk = 'ADD'                    
     end                     
                       
            
     select @site_cd = dz_code            
       from acc_code                
      where cd_fg = 'ARCD'            
        and cd = @air_cd_short            
          
     if @site_cd is null or @site_cd = ''             
        set @site_cd = @air_cd_short             
                   
             
            
     --select @remark  = '항공' + @pro_code + ' ' + @start_day + ' ' +  @min_tck_no + ' ' + @max_tck_no + ' ' + convert(char(8), @tckout_day, 112)                  
	select @remark  = '[항공] ' + @pro_code + ' / ' +  @min_tck_no + ' ' + @max_tck_no + ' (' + 
		isnull((select kor_name from EMP_MASTER_damo where EMP_CODE = @pan_emp_no), '') + ' / ' + 
		isnull((select kor_name from EMP_MASTER_damo where EMP_CODE = @issue_code), '') + ')'           
		
     if @cash_amt + @card_amt <> 0                     
     begin                    
                          
         select @use_acc_cd = use_acc_cd1,                                  
                @amt_w      = @cash_amt + @card_amt                                                                              
           from acc_junl                  
          where junl_fg = 'AI'                    
            and junl_cd = 'A1'                    
                     
                    
          exec @ret = sp_acc_slipd_ins  @slip_mk_day, @slip_mk_seq, @use_acc_cd, '1', @site_cd, @pan_dept_cd, @pan_emp_no,                   
                                        @pro_code, null, @amt_w, 0, @remark, @emp_no                               
                                                      
          if @ret <> 0 GOTO ERR_HANDLER                       
                             
                                    
      end                    
                          
      if @comm_amt <> 0                     
      begin                    
         select @use_acc_cd = use_acc_cd1,                                    
                @amt_w      = @comm_amt                               
           from acc_junl                  
          where junl_fg = 'AI'                    
            and junl_cd = 'A2'                    
                    
          exec @ret = sp_acc_slipd_ins  @slip_mk_day, @slip_mk_seq, @use_acc_cd, '2', @site_cd, @pan_dept_cd, @pan_emp_no,                   
                                        @pro_code, null, 0, @amt_w, @remark, @emp_no                               
                    
                                                      
          if @ret <> 0 GOTO ERR_HANDLER                                    
                           
                           
          select @use_acc_cd = use_acc_cd1,                               
                 @amt_w      = @comm_vat                               
            from acc_junl                  
           where junl_fg = 'AI'                    
   and junl_cd = 'A3'                    
                    
          exec @ret = sp_acc_slipd_ins  @slip_mk_day, @slip_mk_seq, @use_acc_cd, '2', @site_cd, @pan_dept_cd, @pan_emp_no,                   
                                        @pro_code, null, 0, @amt_w, @remark, @emp_no                               
                    
                                                      
          if @ret <> 0 GOTO ERR_HANDLER                                          
                    
      end                    
      if @cash_amt + @card_amt - @comm_amt - @comm_vat <> 0                     
      begin                    
         select @use_acc_cd = use_acc_cd1,                                               
   @amt_w      = @cash_amt + @card_amt - @comm_amt - @comm_vat                                                     
           from acc_junl                  
          where junl_fg = 'AI'                    
            and junl_cd = 'A4'                    
                    
          exec @ret = sp_acc_slipd_ins  @slip_mk_day, @slip_mk_seq, @use_acc_cd, '2', @site_cd, @pan_dept_cd, @pan_emp_no,                   
                                        @pro_code, null, 0, @amt_w, @remark, @emp_no                              
                    
                                                      
          if @ret <> 0 GOTO ERR_HANDLER                       
                    
      end                    
      if @card_amt <> 0                
      begin                    
         select @use_acc_cd = use_acc_cd1,                                  
                @amt_w      = @card_amt                      
             from acc_junl                  
          where junl_fg = 'AI'                    
            and junl_cd = 'A5'                   
                    
           exec @ret = sp_acc_slipd_ins  @slip_mk_day, @slip_mk_seq, @use_acc_cd, '1', @site_cd, @pan_dept_cd, @pan_emp_no,                   
                                        @pro_code, null, @amt_w, 0, @remark, @emp_no                              
                    
                                  
          if @ret <> 0 GOTO ERR_HANDLER                                                          
                    
                                  
                              
          select @use_acc_cd = use_acc_cd2,                                   
                 @amt_w      = @card_amt                                                
             from acc_junl                  
          where junl_fg = 'AI'                    
             and junl_cd = 'A5'                    
                    
           exec @ret = sp_acc_slipd_ins  @slip_mk_day, @slip_mk_seq, @use_acc_cd, '2', @site_cd, @pan_dept_cd, @pan_emp_no,                   
                                        @pro_code, null, 0, @amt_w, @remark, @emp_no                              
                    
                                                      
          if @ret <> 0 GOTO ERR_HANDLER                                                         
                    
      end                    
                        
      select @tot_card_amt = @tot_card_amt + @card_amt,                    
             @tot_cash_amt = @tot_cash_amt + @cash_amt                  
                         
                    
      fetch next from cur_1 into  @cash_amt,                  
                             @card_amt,                    
                                  @tck_cnt,                    
                                  @comm_amt,                    
                                  @comm_vat,                    
                                  @pan_emp_no,                    
                                  @pan_dept_cd,                    
                                  @min_tck_no,                    
                                  @max_tck_no,                    
                                  @air_cd_short,                                                
                                  @start_day,
                              @issue_code                                   
                                              
                       
      
    end                    
                    
close      cur_1                    
                    
                  
deallocate cur_1                              
                      
                  
                  
                              
                    
     if  @tot_cash_amt + @tot_card_amt <> 0                          
     begin                         
                       
          declare cur_tck_no scroll cursor for                    
                     
           select b.ticket                                    
             from dsr_ticket b, emp_master_damo a                  
            where b.issue_date = @tckout_day                
              --    convert(char(8), b.issue_date, 112) = @tckout_day                     
              and b.pro_code = @pro_code                                        
              and b.ticket_status = 1  /*정상티켓*/                    
              and isnull(b.cash_price,0) + isnull(b.card_price,0) <> 0                    
              and not exists ( select a.ticket                  
                  from acc_dsr_slip a                  
                              where a.ticket =  b.ticket )                    
              and b.sale_code = a.emp_code                                       
         order by b.ticket                                                                     
                     
          open cur_tck_no                  
                    
          fetch next from cur_tck_no into @tck_no                                                                            
                      
          while ( @@fetch_status <> -1 )                    
          begin                      
                                              
             insert into acc_dsr_slip  (ticket, slip_mk_day, slip_mk_seq, ins_dt)                  
                               values ( @tck_no, @slip_mk_day, @slip_mk_seq, default )                   
                               
                               
             if @ret <> 0 GOTO ERR_HANDLER                                                         
                    
                               
             fetch next from cur_tck_no into @tck_no                                                                                                  
                       
                       
          end                    
                    
          close      cur_tck_no                    
                    
                  
          deallocate cur_tck_no                        
                       
     end                    
                    
                    
                    
commit transaction                       
return 0                      
                      
ERR_HANDLER:                      
  Rollback transaction                      
  return -1                    
                    
                    
                    
                    
                
              
            
          
        
      
    
  

GO
