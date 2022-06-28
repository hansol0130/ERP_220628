USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACC_MAST_CODE](
	[M_CODE] [varchar](4) NOT NULL,
	[S_CODE] [varchar](10) NOT NULL,
	[CODE_NAME] [varchar](300) NULL,
	[CODE_NAME2] [varchar](300) NULL,
	[CODE_DESC] [varchar](500) NULL,
	[P_MCODE] [varchar](4) NULL,
	[P_SCODE] [varchar](10) NULL,
	[Y_CODE] [varchar](10) NULL,
	[USE_YN] [varchar](1) NULL,
	[SORT] [int] NULL,
 CONSTRAINT [PK_ACC_MAST_CODE] PRIMARY KEY CLUSTERED 
(
	[M_CODE] ASC,
	[S_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ACC_MAST_CODE] ADD  CONSTRAINT [DF_ACC_MAST_CODE_SORT]  DEFAULT ((999)) FOR [SORT]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACC_MAST_CODE', @level2type=N'COLUMN',@level2name=N'M_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'서브코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACC_MAST_CODE', @level2type=N'COLUMN',@level2name=N'S_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'코드명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACC_MAST_CODE', @level2type=N'COLUMN',@level2name=N'CODE_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'코드명1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACC_MAST_CODE', @level2type=N'COLUMN',@level2name=N'CODE_NAME2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'코드설명2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACC_MAST_CODE', @level2type=N'COLUMN',@level2name=N'CODE_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACC_MAST_CODE', @level2type=N'COLUMN',@level2name=N'USE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'소트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACC_MAST_CODE', @level2type=N'COLUMN',@level2name=N'SORT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회계코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACC_MAST_CODE'
GO
