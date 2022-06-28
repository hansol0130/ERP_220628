USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUV_MASTER](
	[CUV_SEQ] [int] IDENTITY(1,1) NOT NULL,
	[CUV_TYPE] [int] NOT NULL,
	[CUV_TITLE] [varchar](100) NULL,
	[CUV_BODY] [varchar](200) NULL,
	[COM_KEY1] [varchar](20) NULL,
	[COM_KEY2] [varchar](20) NULL,
	[OPEN_DATE] [datetime] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_NAME] NULL
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'큐비순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUV_MASTER', @level2type=N'COLUMN',@level2name=N'CUV_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'큐비타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUV_MASTER', @level2type=N'COLUMN',@level2name=N'CUV_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'타이틀' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUV_MASTER', @level2type=N'COLUMN',@level2name=N'CUV_TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUV_MASTER', @level2type=N'COLUMN',@level2name=N'CUV_BODY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공통키1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUV_MASTER', @level2type=N'COLUMN',@level2name=N'COM_KEY1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공통키2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUV_MASTER', @level2type=N'COLUMN',@level2name=N'COM_KEY2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공개일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUV_MASTER', @level2type=N'COLUMN',@level2name=N'OPEN_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUV_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUV_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
