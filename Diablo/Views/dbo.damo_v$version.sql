USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create view [dbo].[damo_v$version] as
/********************************************************************************
*** v$version *****
[----]
  db server-- -------- ---- 
  32bit/64bit ---- ----, stadard/enterprise------------
[data]
 	 @@version	-	 sql server-- -------- ---- 
[from]
 
[result values]
microsoft sql server  2000 - 8.00.2039 (intel x86)   may  3 2005 23:18:38   copyright (c) 1988-2003 microsoft corporation  enterprise edition on windows nt 5.2 (build 3790: service pack 1) 


[--------]
  - sql 2000-- sql2005-- -------- ------.
  - -------- -------- ---- ------ ------ ------ ------ ---- -------- ------
                
[--------]
	- ----
	- ----
	- ----
******************************************************************************** */
select @@version as banner
GO
