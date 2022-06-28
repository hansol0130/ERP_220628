USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_PHONE_AUTH](
	[SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[CUS_NAME] [varchar](50) NULL,
	[BIRTH_DATE] [datetime] NULL,
	[NOR_TEL1] [varchar](3) NULL,
	[NOR_TEL2] [varchar](4) NULL,
	[NOR_TEL3] [varchar](5) NULL,
	[CUS_NO] [int] NULL,
	[AUTH_KEY] [varchar](100) NULL,
	[AUTH_NO] [varchar](10) NULL,
	[AUTH_TYPE] [int] NULL,
	[SNS_COM_ID] [int] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_DATE] [datetime] NULL,
	[AUTH_RESULT] [int] NULL,
	[AUTH_DATE] [datetime] NULL,
	[RETRY_CNT] [int] NULL,
	[CUS_RESULT] [int] NULL,
	[DUP_CUS_NO] [varchar](1000) NULL,
	[CLIENT_IP] [varchar](20) NULL,
	[CUS_ID] [varchar](20) NULL,
	[REMARK] [varchar](1000) NULL,
	[COMP_YN] [char](1) NULL,
	[ALIM_SEQ] [varchar](100) NULL,
	[SMS_SEQ] [int] NULL
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생년월일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_PHONE_AUTH', @level2type=N'COLUMN',@level2name=N'BIRTH_DATE'
GO
