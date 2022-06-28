USE [Cuve]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--===================================
-- view --------
--===================================

/*
  C# ---- ---- ------ -- IP, Mac Address, Program Name ---- ------ -- ---- -------- ------ --
*/
create view [dbo].[damo_session_infos] as
  select sysp.spid, convert(varchar, sysp.login_time, 121) as login_time,
  rtrim(sysp.program_name) as program_name,
  rtrim(sysp.hostname) as host_name, convert(varchar(20),
  sysp.hostprocess) as host_process_id,
  case when sysp.net_address = '' or sysp.net_address is null then
  'UNKNOWN' else substring(sysp.net_address, 1,
  2)+':'+substring(sysp.net_address, 3, 2)+':'+substring(sysp.net_address,
  5, 2)+':'+substring(sysp.net_address, 7,
  2)+':'+substring(sysp.net_address, 9, 2)+':'+substring(sysp.net_address,
  11, 2) end as mac_address,
  sdc.client_net_address as ip,
  sdc.net_transport as connect_type
  from master.dbo.sysprocesses sysp, sys.dm_exec_connections sdc,
  sys.dm_exec_sessions sds
  where sysp.spid = sdc.session_id and sysp.spid = sds.session_id
GO
