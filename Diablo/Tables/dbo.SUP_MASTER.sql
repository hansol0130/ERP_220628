USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SUP_MASTER](
	[SUP_CODE] [varchar](10) NOT NULL,
	[SUP_NAME] [varchar](20) NULL,
 CONSTRAINT [PK_SUPPLIER_MASTER] PRIMARY KEY CLUSTERED 
(
	[SUP_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공급자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUP_MASTER', @level2type=N'COLUMN',@level2name=N'SUP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공급자명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUP_MASTER', @level2type=N'COLUMN',@level2name=N'SUP_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔공급자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUP_MASTER'
GO
