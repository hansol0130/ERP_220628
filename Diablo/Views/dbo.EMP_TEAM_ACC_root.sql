USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  create view [dbo].[EMP_TEAM_ACC_root] (  [ACC_SEQ] , [TEAM_CODE] , [ACC_NAME] , [ACC_HOLDER] , [BANK_NAME] , [SORT_NUM] , [NEW_CODE] , [NEW_DATE] , [EDT_CODE] , [EDT_DATE] , [DEL_YN] , [ACC_NUM]  ) as select   [ACC_SEQ], [TEAM_CODE], [ACC_NAME], [ACC_HOLDER], [BANK_NAME], [SORT_NUM], [NEW_CODE], [NEW_DATE], [EDT_CODE], [EDT_DATE], [DEL_YN],convert(varchar(20), damo.[dbo].[damo_decrypt_Diablo_EMP_TEAM_ACC_ACC_NUM_17D455B2672C976024D6AE69055F799A338C9B14]('Diablo','dbo.EMP_TEAM_ACC','ACC_NUM', [sec_ACC_NUM] ,'I')) COLLATE Korean_Wansung_CI_AS    from [dbo].[EMP_TEAM_ACC_damo] 
GO
