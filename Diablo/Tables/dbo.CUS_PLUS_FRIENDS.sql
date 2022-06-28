USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_PLUS_FRIENDS](
	[SNS_SEQ] [int] IDENTITY(1,1) NOT NULL,
	[SNS_ID] [varchar](20) NOT NULL,
	[STATE] [varchar](10) NULL,
	[ID_TYPE] [varchar](20) NULL,
	[PUBLIC_ID] [varchar](20) NULL,
	[UPDATE_DATE] [datetime] NULL,
 CONSTRAINT [PK_CUS_PLUS_FRIENDS] PRIMARY KEY CLUSTERED 
(
	[SNS_SEQ] ASC,
	[SNS_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카카오발급계정' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_PLUS_FRIENDS', @level2type=N'COLUMN',@level2name=N'SNS_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'채널상태(added/block)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_PLUS_FRIENDS', @level2type=N'COLUMN',@level2name=N'STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유입타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_PLUS_FRIENDS', @level2type=N'COLUMN',@level2name=N'ID_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'채널명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_PLUS_FRIENDS', @level2type=N'COLUMN',@level2name=N'PUBLIC_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'업데이트시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_PLUS_FRIENDS', @level2type=N'COLUMN',@level2name=N'UPDATE_DATE'
GO
