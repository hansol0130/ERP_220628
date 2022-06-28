USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_AirNation](
	[NATION_CODE] [char](3) NOT NULL,
	[KOR_NAME] [nvarchar](100) NULL,
	[ENG_NAME] [nvarchar](100) NULL,
	[ORDER_SEQ] [int] NULL,
	[IS_USE] [char](1) NULL,
 CONSTRAINT [PK_PUB_AirNation] PRIMARY KEY CLUSTERED 
(
	[NATION_CODE] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PUB_AirNation] ADD  DEFAULT ('1') FOR [IS_USE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국가코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AirNation', @level2type=N'COLUMN',@level2name=N'NATION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'한글국가명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AirNation', @level2type=N'COLUMN',@level2name=N'KOR_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문국가명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AirNation', @level2type=N'COLUMN',@level2name=N'ENG_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정렬순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AirNation', @level2type=N'COLUMN',@level2name=N'ORDER_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AirNation', @level2type=N'COLUMN',@level2name=N'IS_USE'
GO
