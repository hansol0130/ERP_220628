USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


create view [dbo].[damo_product_component_version] as
/********************************************************************************
*** product_component_version *****
[----]
  db server-- ---- ---- ---- (version and status information for component products)
[data]
  serverproperty('productversion')	-	 sql server-- ------------
[from]
 ------
[result values]
sql server 2000
        
[--------]
  - sql 2000-- sql2005-- -------- ------.
  - -------- ---- -------- -------- return ----
                
[--------]
	- ----
	- ----
	- ----
******************************************************************************** */
select case substring(cast(serverproperty('productversion') as varchar),1,1)
	when 7 then 'sql server 7.0'
	when 8 then 'sql server 2000'
	when 9 then 'sql server 2005' 
	end as product
GO
