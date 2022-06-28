USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_acc_slipm_seq]   
   @day     char(8),  
   @emp_no  varchar(10),   
   @slip_fg char(1),    /* 수입(1) 지출(2) 대체(3) */  
   @junl_fg char(2)     /* 분개전표구분 */     
  
as  
declare @ret_seq int,  
        @dept_cd varchar(10)  
  
 select @ret_seq = isnull(max(slip_mk_seq), 0) + 1  
   from acc_slipm  
  where slip_mk_day = @day;  
  
if @ret_seq is null or @ret_seq = 0  
   set @ret_seq = 1  
  
/* 부서코드 */  
select @dept_cd = team_code
  from emp_master
 where emp_code = @emp_no  
  
insert into acc_slipm ( slip_mk_day, slip_mk_seq, dept_cd,  emp_no,  slip_fg,  junl_fg)  
               values ( @day,        @ret_seq,    @dept_cd, @emp_no, @slip_fg, @junl_fg )  
  
return @ret_seq  

GO
