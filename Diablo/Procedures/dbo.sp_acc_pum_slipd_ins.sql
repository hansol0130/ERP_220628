USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_acc_pum_slipd_ins]           
   @chk          char(3),          /* 체크 'NEW', 'ADD' */        
   @slip_mk_day  char(8),          /* 전표일자 */        
   @slip_mk_seq  smallint output,  /* 전표일련번호 */        
   @edi_code     char(10),         /*----- 입금내역 PK -----*/         
   @emp_no       EMP_CODE          /* 등록사번 */        
        
as        
declare @slip_fg      char(1),    /* 수입(1) 지출(2) 대체(3) */        
        @slip_det_seq smallint    /* 전표DETAIL 일련번호 */         
              
declare @use_acc_cd    varchar(10),      /* 계정코드 */        
        @deb_amt_w     numeric(12),      /* 차변금액 */        
        @cre_amt_w     numeric(12),      /* 대변금액 */        
        @amt_w         numeric(12),      /* 대변금액 */        
        @remark_deb    varchar(200),     /* 비고1 */                         
        @remark_cre    varchar(200),     /* 비고1 */                         
        @deb_use_acc_cd char(10),       /* 차변 계정 */        
        @cre_use_acc_cd char(10),       /* 대변 계정 */        
        @ev_no         varchar(20),        
        @ev_nm         varchar(200),        
        @start_day     char(8),                
        @in_emp_no     varchar(10),      /* 입금자사번 */                   
        @site_cd       varchar(10),               
        @dept_cd       varchar(10),                       
        @save_acc_no   varchar(20),                
        @res_code      varchar(20),        
        @io_day        varchar(8),       
        @doc_type      varchar(10),             
        @detail_type   varchar(10),      
        @detail_name   varchar(20),      
        @junl_fg       varchar(2),   
        @junl_nm       varchar(12),       
        @pro_code      varchar(20),      
        @ret           int       ,
        @subject		varchar(200)     
              
          
Begin transaction              
           
/*G1 일반지결전표  
G2 행사지결전표(환불지결)  
G3 행사지결전표(공동경비)  
G4 행사지결전표(지상비)  
G5 행사지결전표(기타)*/  
  
           
           
select  @doc_type    = a.doc_type,                  
        @detail_type = a.detail_type,              
        @detail_name = a.detail_name,                    
        @deb_amt_w   = a.price,         
        @cre_amt_w   = a.price,               
        @amt_w       = a.price,               
        @ev_no       = a.pro_code,                
        @site_cd     = a.agt_code,        
        @in_emp_no   = a.new_code,      
        @remark_deb  = a.edi_code + ' ' + a.subject,       
        @remark_cre  = a.pay_bank + ' ' + damo.dbo.dec_varchar('DIABLO', 'dbo.EDI_MASTER', 'PAY_ACCOUNT', A.SEC_PAY_ACCOUNT) + ' ' + a.pay_receipt,                
        @subject = a.SUBJECT,
        @res_code    = a.master_code,      
        @dept_cd     = a.rcv_team_code,      
        @junl_fg     = case when a.doc_type = '4' then 'G1'      
                            when a.doc_type = '8' and a.detail_type = '1' then 'G4'      
                            when a.doc_type = '8' and a.detail_type = '2' then 'G3'           
                            when a.doc_type = '8' and a.detail_type = '3' then 'G2'      
                            when a.doc_type = '8' and a.detail_type = '4' then 'G5' end,  
        @junl_nm     = case when a.doc_type = '4' then '[일반지결]'      
                            when a.doc_type = '8' and a.detail_type = '1' then '[지상비지결]'      
                            when a.doc_type = '8' and a.detail_type = '2' then '[공동비지결]'           
                            when a.doc_type = '8' and a.detail_type = '3' then '[환불지결]'      
                            when a.doc_type = '8' and a.detail_type = '4' then '[기타지결]' end,  
        @pro_code    = pro_code                           
   from edi_master_DAMO a      
  where a.edi_code = @edi_code       
    and a.doc_type in ( '4', '8' )      
    and a.edi_status = '3'    
    and not exists ( select p.edi_code      
                       from acc_pum_slip p      
                      where p.edi_code =  a.edi_code )        
                            
        
     if @chk = 'NEW'  and  @amt_w <> 0      
     begin        
             
         select @slip_fg = '3' /* 대체전표 */        
         exec @slip_mk_seq = sp_acc_slipm_seq @slip_mk_day, @emp_no, @slip_fg, @junl_fg      
            
     end         
  
  
        
    -- 2010-10-6 강우미 과장의 요청으로 적요란을 전자결재 문서 제목으로 변경함
    -- 아래는 이전소스
    --if @pro_code is not null and @pro_code <> ''    
    --   select @remark_deb = @junl_nm + ' ' +  pro_code + ' ' + pro_name,  
    --          @remark_cre = @junl_nm + ' ' +  pro_code + ' ' + pro_name  
    --     from pkg_detail  
    --    where pro_code = @pro_code     
    --else  
    --   select @remark_deb = @junl_nm +  ' ' + @remark_deb,  
    --          @remark_cre = @junl_nm +  ' ' + @remark_cre  
    
    --======================================================================================  
    if @pro_code is not null and @pro_code <> ''    
    begin
       set @remark_deb = @subject
		set @remark_cre = @subject  
	end
    else  
       select @remark_deb = @junl_nm +  ' ' + @remark_deb,  
              @remark_cre = @junl_nm +  ' ' + @remark_cre  
      
    --======================================================================================  
    if @deb_amt_w  <> 0         
    begin        
              
          select @use_acc_cd = use_acc_cd1,      
                 @save_acc_no = null      
            from acc_junl      
           where junl_fg = @junl_fg      
             and junl_cd = 'A'      
                   
        
        
           
          exec @ret = sp_acc_slipd_ins  @slip_mk_day, @slip_mk_seq, @use_acc_cd, '1', @site_cd, @dept_cd, @in_emp_no,       
                                        @ev_no, @save_acc_no, @deb_amt_w, 0, @remark_deb, @emp_no                   
                                          
          if @ret <> 0 GOTO ERR_HANDLER           
      
    end            
             
    if @cre_amt_w  <> 0         
    begin        
              
        
             
         select @use_acc_cd = use_acc_cd2                      
           from acc_junl      
          where junl_fg = @junl_fg      
            and junl_cd = 'A'      
              
         select @site_cd = use_acc_cd1, /* 거래처-은행 */                      
                @save_acc_no = rtrim(remark)      
           from acc_junl      
          where junl_fg = @junl_fg      
            and junl_cd = 'A1'          
        
                    
         exec @ret = sp_acc_slipd_ins  @slip_mk_day, @slip_mk_seq, @use_acc_cd, '2', @site_cd, @dept_cd, @in_emp_no,       
                                       @ev_no, @save_acc_no, 0, @cre_amt_w, @remark_cre, @emp_no                   
                                          
         if @ret <> 0 GOTO ERR_HANDLER           
    end      
      
   if @amt_w  <> 0         
   begin      
         
      
       insert into acc_pum_slip (edi_code,  slip_mk_day,  slip_mk_seq,  ins_dt)      
                         values (@edi_code, @slip_mk_day, @slip_mk_seq, default)       
                   
                   
       if @ret <> 0 GOTO ERR_HANDLER                                               
         
             
  end        
        
        
        
commit transaction           
return 0          
          
ERR_HANDLER:          
  Rollback transaction          
  return -1        
        
        
          
        
        
        
        
        
        
        
        
        
        
        
      
    
  

GO
