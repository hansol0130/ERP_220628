USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  create view [dbo].[APP_MESSAGE_root] (  [MSG_SEQ_NO] , [CUS_NO] , [MSG_TYPE] , [OS_TYPE] , [REMARK] , [NEW_CODE] , [NEW_DATE] , [PRO_CODE] , [RES_CODE] , [Tag] , [TITLE] , [GPS_X] , [GPS_Y]  ) as select   [MSG_SEQ_NO], [CUS_NO], [MSG_TYPE], [OS_TYPE], [REMARK], [NEW_CODE], [NEW_DATE], [PRO_CODE], [RES_CODE], [Tag], [TITLE],damo.[dbo].[damo_decrypt_Diablo_APP_MESSAGE_GPS_X_7B8B67C57F6CE32621A2BFFE112A932E86C616C5]('Diablo','dbo.APP_MESSAGE','GPS_X', [sec_GPS_X] ,'I'),damo.[dbo].[damo_decrypt_Diablo_APP_MESSAGE_GPS_Y_0A2968A278C5C3582258D913D20A46D7039BC6E9]('Diablo','dbo.APP_MESSAGE','GPS_Y', [sec_GPS_Y] ,'I')   from [dbo].[APP_MESSAGE_damo] 
GO
