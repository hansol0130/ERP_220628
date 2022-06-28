USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  create view [dbo].[PPT_MASTER_LOG_root] (  [RES_CODE] , [PPT_NO] , [LAST_NAME] , [FIRST_NAME] , [GENDER] , [BIRTH_DATE] , [PASS_ISSUE] , [PASS_EXPIRE] , [PASS_NUM] , row_id ) as select   [RES_CODE], [PPT_NO], [LAST_NAME], [FIRST_NAME], [GENDER], [BIRTH_DATE], [PASS_ISSUE], [PASS_EXPIRE],convert(varchar(20), damo.[dbo].[damo_decrypt_Diablo_PPT_MASTER_LOG_PASS_NUM_38BB92612EC7B8CFDB43B463CD535658F2E331BE]('Diablo','dbo.PPT_MASTER_LOG','PASS_NUM', [sec_PASS_NUM] ,'I')) COLLATE Korean_Wansung_CI_AS  , row_id  from [dbo].[PPT_MASTER_LOG_damo] 
GO
