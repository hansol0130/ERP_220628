USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



create  view [dbo].[v_builtinfunctions] as
      select getutcdate() as gmttime, getdate() as localtime, timediff = datediff(minute, getutcdate(), getdate())



GO
