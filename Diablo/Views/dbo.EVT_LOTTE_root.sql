USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  create view [dbo].[EVT_LOTTE_root] (  [EVT_NO] , [CUS_NAME] , [SOC_NUM1] , [NOR_TEL1] , [NOR_TEL2] , [NOR_TEL3] , [PASS_NUM] , [EMAIL] , [ZIP_CODE] , [ADDRESS1] , [ADDRESS2] , [NEW_CODE] , [NEW_DATE] , [SOC_NUM2]  ) as select   [EVT_NO], [CUS_NAME], [SOC_NUM1], [NOR_TEL1], [NOR_TEL2], [NOR_TEL3], [PASS_NUM], [EMAIL], [ZIP_CODE], [ADDRESS1], [ADDRESS2], [NEW_CODE], [NEW_DATE],convert(char(7), damo.[dbo].[damo_decrypt_Diablo_EVT_LOTTE_SOC_NUM2_499467D22B4BF11D8DBC87253DB9D96EB73CBD22]('Diablo','dbo.EVT_LOTTE','SOC_NUM2', [sec_SOC_NUM2] ,'I')) COLLATE Korean_Wansung_CI_AS    from [dbo].[EVT_LOTTE_damo] 
GO
