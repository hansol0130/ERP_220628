USE [damolog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


create view [dbo].[damo_v$mystat] as
/********************************************************************************
*** v$mystat *****
[----]
  -- connection-- spid ----

[data]
  	@@spid as sid  -- ---- spid
  
[from]
        
[--------]
        
[--------]
	- ----
	- ----
	- ----
******************************************************************************** */
-- v$mystat : -------- ----
select @@spid as sid
GO
