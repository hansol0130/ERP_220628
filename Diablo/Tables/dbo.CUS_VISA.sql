USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_VISA](
	[CUS_NO] [dbo].[CUS_NO] NOT NULL,
	[VISA_SEQ] [int] NOT NULL,
	[NATION_NAME] [varchar](50) NULL,
	[VISA_ISSUE] [datetime] NULL,
	[VISA_EXPIRE] [datetime] NULL,
	[NEW_DATE] [datetime] NULL,
 CONSTRAINT [PK_CUS_VISA] PRIMARY KEY CLUSTERED 
(
	[CUS_NO] ASC,
	[VISA_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비자순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_VISA', @level2type=N'COLUMN',@level2name=N'VISA_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국가명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_VISA', @level2type=N'COLUMN',@level2name=N'NATION_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유효기간시작일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_VISA', @level2type=N'COLUMN',@level2name=N'VISA_ISSUE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유효기간종료일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_VISA', @level2type=N'COLUMN',@level2name=N'VISA_EXPIRE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_VISA', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비자정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_VISA'
GO
