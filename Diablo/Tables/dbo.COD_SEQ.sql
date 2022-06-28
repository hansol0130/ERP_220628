USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COD_SEQ](
	[COD_TYPE] [varchar](6) NOT NULL,
	[COD_SQ] [int] NULL,
	[FLAG] [char](1) NULL,
 CONSTRAINT [PK_COD_SEQ] PRIMARY KEY CLUSTERED 
(
	[COD_TYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공용순번명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COD_SEQ', @level2type=N'COLUMN',@level2name=N'COD_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COD_SEQ', @level2type=N'COLUMN',@level2name=N'COD_SQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COD_SEQ', @level2type=N'COLUMN',@level2name=N'FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공용순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COD_SEQ'
GO
