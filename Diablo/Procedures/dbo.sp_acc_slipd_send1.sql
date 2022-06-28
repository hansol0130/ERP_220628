USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_acc_slipd_send1]      
   @slip_mk_day char(8),           
   @slip_mk_seq smallint        
         
        
as        
        
declare @pro_name     varchar(200),           
        @pro_code     varchar(20),              
        @dz_pro_code  varchar(20),                  
        @c_code       varchar(4)                
           
        
        
select @c_code = '3000'        
        
 declare cur_1 scroll cursor for        
        
  select distinct tab.pro_code      
     from        
        (        
           select b.pro_code   as pro_code      
             from acc_slipm a, acc_slipd b, acc_account c      
            where a.slip_mk_day = @slip_mk_day        
              and a.slip_mk_seq = @slip_mk_seq        
              and a.slip_mk_day = b.slip_mk_day        
              and a.slip_mk_seq = b.slip_mk_seq        
              and b.use_acc_cd = c.use_acc_cd         
              and c.pro_code_chk = 'Y'        
     ) tab        
        
        
        
 open cur_1        
        
 fetch next from cur_1 into @pro_code      
                                  
 while ( @@fetch_status <> -1 )        
   begin         
  
      select @dz_pro_code = duz_code    
        from ACC_MATCHING    
       where pro_code = @pro_code                     
                   
      if @@rowcount = 1      
      begin       
        if Not Exists ( select *        
                          from dzdb.dzais.dzais.VBASE_PJTCODE        
                         where c_code = @c_code        
                           and proj_code = @dz_pro_code )        
       
        begin        
           --select @pro_name =  @pro_code  + substring(pro_name, 1,8)        
           --  from pkg_detail      
           -- where pro_code = @pro_code      
            
          -- begin transaction pjtcode_insert        
        
           insert into dzdb.base.dzbase.PJTCODE        
           (C_CODE, PROJ_CODE,    PROJ_NAME,  PROJ_AMT, PROJ_PCOST,  PROJ_PMARGIN, FPROJ_DATE,        
            TPROJ_DATE,  PROJ_DAY, DT_REG,        
            UM_PCOST, UM_AMT, RT_EXCH,  UM_PMARGIN,COST_MTRL,  COST_LABOR,        
            COST_PROCESS,   COST_ETC,  COST_ADD,  DEGREE,          
            FG_VAT, FG_PJT,  GWA_AMT,  MYUN_AMT, PROJ_STAT,        
            MYUN_RATE,  BUL_TYPE, CAL_DATE, PROJ_VAT,   ZIBUN_RATE )        
           values         
           ( @c_code, @dz_pro_code, @pro_code, 0,0,0,'00000000',        
             '00000000', '0', getdate(),        
             0, 0, 0, 0, 0, 0,        
             0,0,0,0,        
             '2', '1', 0, 0, '1',        
             0,'0','00000000',0, 0 )         
         --  commit transaction pjtcode_insert        
        end          
                
      end                  
                 
        
             
      fetch next from cur_1 into @pro_code      
             
               
  end        
        
        
close      cur_1        
        
deallocate cur_1                  
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
      
    
  

GO
