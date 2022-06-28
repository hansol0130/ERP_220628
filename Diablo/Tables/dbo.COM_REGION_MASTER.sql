USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COM_REGION_MASTER](
	[AGT_CODE] [varchar](10) NOT NULL,
	[REG_MASTER_SEQ] [int] NOT NULL,
	[REGION_NAME] [varchar](20) NULL,
	[ALL_YN] [char](1) NULL,
	[USE_YN] [char](1) NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_SEQ] [int] NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_SEQ] [int] NULL,
 CONSTRAINT [PK_COM_REGION_MASTER] PRIMARY KEY CLUSTERED 
(
	[AGT_CODE] ASC,
	[REG_MASTER_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_REGION_MASTER', @level2type=N'COLUMN',@level2name=N'AGT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_REGION_MASTER', @level2type=N'COLUMN',@level2name=N'REG_MASTER_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출장지역명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_REGION_MASTER', @level2type=N'COLUMN',@level2name=N'REGION_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전체유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_REGION_MASTER', @level2type=N'COLUMN',@level2name=N'ALL_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_REGION_MASTER', @level2type=N'COLUMN',@level2name=N'USE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_REGION_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_REGION_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_REGION_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_REGION_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객사지역정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_REGION_MASTER'
GO
