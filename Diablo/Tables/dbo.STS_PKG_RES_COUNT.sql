USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STS_PKG_RES_COUNT](
	[MASTER_CODE] [dbo].[MASTER_CODE] NOT NULL,
	[ALL_COUNT] [int] NULL,
	[TWO_COUNT] [int] NULL,
	[THREE_COUNT] [int] NULL,
	[FOUR_COUNT] [int] NULL,
	[FIVE_COUNT] [int] NULL,
	[TWO_PERCENT] [int] NULL,
	[THREE_PERCENT] [int] NULL,
	[FOUR_PERCENT] [int] NULL,
	[FIVE_PERCENT] [int] NULL,
	[UPDATE_DATE] [datetime] NULL,
 CONSTRAINT [PK_STS_PKG_RES_COUNT] PRIMARY KEY CLUSTERED 
(
	[MASTER_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[STS_PKG_RES_COUNT]  WITH CHECK ADD  CONSTRAINT [R_289] FOREIGN KEY([MASTER_CODE])
REFERENCES [dbo].[PKG_MASTER] ([MASTER_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[STS_PKG_RES_COUNT] CHECK CONSTRAINT [R_289]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STS_PKG_RES_COUNT', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전체에약자수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STS_PKG_RES_COUNT', @level2type=N'COLUMN',@level2name=N'ALL_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'20대예약자수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STS_PKG_RES_COUNT', @level2type=N'COLUMN',@level2name=N'TWO_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'30대예약자수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STS_PKG_RES_COUNT', @level2type=N'COLUMN',@level2name=N'THREE_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'40대예약자수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STS_PKG_RES_COUNT', @level2type=N'COLUMN',@level2name=N'FOUR_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'50대예약자수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STS_PKG_RES_COUNT', @level2type=N'COLUMN',@level2name=N'FIVE_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'20대백분율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STS_PKG_RES_COUNT', @level2type=N'COLUMN',@level2name=N'TWO_PERCENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'30대백분율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STS_PKG_RES_COUNT', @level2type=N'COLUMN',@level2name=N'THREE_PERCENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'40대백분율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STS_PKG_RES_COUNT', @level2type=N'COLUMN',@level2name=N'FOUR_PERCENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'50대백분율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STS_PKG_RES_COUNT', @level2type=N'COLUMN',@level2name=N'FIVE_PERCENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'업데이트일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STS_PKG_RES_COUNT', @level2type=N'COLUMN',@level2name=N'UPDATE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'연령별예약인비율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STS_PKG_RES_COUNT'
GO
