USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUV_RECEIVE](
	[CUV_SEQ] [int] NOT NULL,
	[REC_SEQ] [int] NOT NULL,
	[CUS_NO] [dbo].[CUS_NO] NULL,
	[CHECK_DATE] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CUV_RECEIVE]  WITH CHECK ADD  CONSTRAINT [R_CUV_RECEIVE_CUV_SEQ] FOREIGN KEY([CUV_SEQ])
REFERENCES [dbo].[CUV_MASTER] ([CUV_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CUV_RECEIVE] CHECK CONSTRAINT [R_CUV_RECEIVE_CUV_SEQ]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'큐비순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUV_RECEIVE', @level2type=N'COLUMN',@level2name=N'CUV_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'큐비타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUV_RECEIVE', @level2type=N'COLUMN',@level2name=N'REC_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'타이틀' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUV_RECEIVE', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUV_RECEIVE', @level2type=N'COLUMN',@level2name=N'CHECK_DATE'
GO
