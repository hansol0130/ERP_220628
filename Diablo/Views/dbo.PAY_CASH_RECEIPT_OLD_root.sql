USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  create view [dbo].[PAY_CASH_RECEIPT_OLD_root] (  [RECEIPT_NO] , [GROUP_NO] , [REQ_NO] , [REQ_VER] , [PAY_SEQ] , [MCH_SEQ] , [RES_CODE] , [SOC_NUM1] , [NOR_TEL1] , [NOR_TEL2] , [NOR_TEL3] , [TARGET_PRICE] , [STATUS_TYPE] , [NEW_CODE] , [REQ_COMMENT] , [MNG_CODE] , [MNG_COMMENT] , [NEW_DATE] , [EDT_DATE] , [REMARK] , [SOC_NUM2]  ) as select   [RECEIPT_NO], [GROUP_NO], [REQ_NO], [REQ_VER], [PAY_SEQ], [MCH_SEQ], [RES_CODE], [SOC_NUM1], [NOR_TEL1], [NOR_TEL2], [NOR_TEL3], [TARGET_PRICE], [STATUS_TYPE], [NEW_CODE], [REQ_COMMENT], [MNG_CODE], [MNG_COMMENT], [NEW_DATE], [EDT_DATE], [REMARK],convert(varchar(7), damo.[dbo].[damo_decrypt_Diablo_PAY_CASH_RECEIPT_OLD_SOC_NUM2_64B2A0F1C9259154EF8B0F544296149F26B5BADE]('Diablo','dbo.PAY_CASH_RECEIPT_OLD','SOC_NUM2', [sec_SOC_NUM2] ,'I')) COLLATE Korean_Wansung_CI_AS    from [dbo].[PAY_CASH_RECEIPT_OLD_damo] 
GO
