USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create view [dbo].[damo_v$instance] as
/********************************************************************************
*** v$instance *****
[----]
  ---- ------ server-- hostname ----

[data]
	@@servername as hostname
  
[from]
        
[--------]

[result values]
glasgow

        
[--------]
	- ----
	- ----
	- ----
******************************************************************************** */

select @@servername as hostname
GO
