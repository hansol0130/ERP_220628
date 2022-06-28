USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_DOC_STATE](
	[MASTER_CODE] [dbo].[PRO_CODE] NOT NULL,
	[EMP_CODE] [dbo].[EMP_CODE] NOT NULL,
	[SEQ] [int] NOT NULL,
	[CLOSED] [char](1) NULL,
	[COLLAPSED] [char](1) NULL,
	[DOCZONEID] [varchar](100) NULL,
	[HEIGHT] [int] NULL,
	[INDEX] [int] NULL,
	[LEFT] [int] NULL,
	[PINNED] [char](1) NULL,
	[TAG] [varchar](max) NULL,
	[TEXT] [varchar](max) NULL,
	[TITLE] [varchar](300) NULL,
	[TOP] [int] NULL,
	[UNIQUENAME] [varchar](100) NULL,
	[WIDTH] [int] NULL,
 CONSTRAINT [PK_PKG_DOC_STATE] PRIMARY KEY CLUSTERED 
(
	[MASTER_CODE] ASC,
	[EMP_CODE] ASC,
	[SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드/마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DOC_STATE', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성직원코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DOC_STATE', @level2type=N'COLUMN',@level2name=N'EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DOC_STATE', @level2type=N'COLUMN',@level2name=N'SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마감여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DOC_STATE', @level2type=N'COLUMN',@level2name=N'CLOSED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'COLLAPSED' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DOC_STATE', @level2type=N'COLUMN',@level2name=N'COLLAPSED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DOCZONEID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DOC_STATE', @level2type=N'COLUMN',@level2name=N'DOCZONEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'HEIGHT' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DOC_STATE', @level2type=N'COLUMN',@level2name=N'HEIGHT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'INDEX' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DOC_STATE', @level2type=N'COLUMN',@level2name=N'INDEX'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'LEFT' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DOC_STATE', @level2type=N'COLUMN',@level2name=N'LEFT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고정여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DOC_STATE', @level2type=N'COLUMN',@level2name=N'PINNED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'TAG' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DOC_STATE', @level2type=N'COLUMN',@level2name=N'TAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'TEXT' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DOC_STATE', @level2type=N'COLUMN',@level2name=N'TEXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'TITLE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DOC_STATE', @level2type=N'COLUMN',@level2name=N'TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'TOP' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DOC_STATE', @level2type=N'COLUMN',@level2name=N'TOP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'UNIQUENAME' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DOC_STATE', @level2type=N'COLUMN',@level2name=N'UNIQUENAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'WIDTH' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DOC_STATE', @level2type=N'COLUMN',@level2name=N'WIDTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PKG_DOC_STATE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DOC_STATE'
GO
