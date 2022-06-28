USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVT_VOTE](
	[SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[CUS_NO] [int] NOT NULL,
	[EVT_NO] [int] NOT NULL,
	[VOTE_NO] [int] NOT NULL,
	[VOTE_DATE] [datetime] NOT NULL
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'참여순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_VOTE', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_VOTE', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_VOTE', @level2type=N'COLUMN',@level2name=N'EVT_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'투표번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_VOTE', @level2type=N'COLUMN',@level2name=N'VOTE_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'투표날짜' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_VOTE', @level2type=N'COLUMN',@level2name=N'VOTE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카카오톡투표이벤트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_VOTE'
GO
