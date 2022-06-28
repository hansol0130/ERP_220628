USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SND_REQUEST](
	[SND_NO] [int] IDENTITY(1,1) NOT NULL,
	[SND_TYPE] [int] NULL,
	[AIRPORT_TYPE] [int] NULL,
	[SND_DATE] [datetime] NULL,
	[SUBJECT] [varchar](30) NULL,
	[BODY] [varchar](4000) NULL,
	[PRO_CODE] [dbo].[PRO_CODE] NULL,
	[RES_CODE] [dbo].[RES_CODE] NULL,
	[RES_COUNT] [int] NULL,
	[RES_PHONE] [varchar](20) NULL,
	[RES_NAME] [varchar](20) NULL,
	[SHOW_YN] [char](1) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_NAME] [dbo].[NEW_NAME] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_NAME] [dbo].[EDT_NAME] NULL,
	[SND_COUNTER] [varchar](20) NULL,
	[SND_YN] [char](1) NULL,
	[CONFIRM_DATE] [datetime] NULL,
	[CONFIRM_CODE] [char](7) NULL,
	[SND_CHARGE_CODE] [varchar](7) NULL,
	[START_TIME] [char](5) NULL,
 CONSTRAINT [PK_SND_REQUEST] PRIMARY KEY CLUSTERED 
(
	[SND_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 패키지, 1 : 요청' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SND_REQUEST', @level2type=N'COLUMN',@level2name=N'SND_TYPE'
GO
