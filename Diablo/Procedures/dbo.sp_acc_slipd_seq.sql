USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_acc_slipd_seq]   
   @slip_mk_day     char(8),  
   @slip_mk_seq     smallint,  
   @slip_det_seq    smallint output  
  
as  
  
select @slip_det_seq = isnull(max(slip_det_seq), 0) + 1  
  from acc_slipd
 where slip_mk_day = @slip_mk_day  
   and slip_mk_seq = @slip_mk_seq  
  
if @slip_det_seq is null or @slip_det_seq = 0  
   set @slip_det_seq = 1  

GO
