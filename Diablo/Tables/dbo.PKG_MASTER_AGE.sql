USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_MASTER_AGE](
	[MASTER_CODE] [varchar](10) NOT NULL,
	[NEW_DATE] [datetime] NOT NULL,
	[AGE0] [int] NULL,
	[AGE10] [int] NULL,
	[AGE20] [int] NULL,
	[AGE30] [int] NULL,
	[AGE40] [int] NULL,
	[AGE50] [int] NULL,
	[AGE60] [int] NULL,
	[AGE70] [int] NULL,
	[AGE80] [int] NULL,
	[AGE0_PERCENT] [int] NULL,
	[AGE10_PERCENT] [int] NULL,
	[AGE20_PERCENT] [int] NULL,
	[AGE30_PERCENT] [int] NULL,
	[AGE40_PERCENT] [int] NULL,
	[AGE50_PERCENT] [int] NULL,
	[AGE60_PERCENT] [int] NULL,
	[AGE70_PERCENT] [int] NULL,
	[AGE80_PERCENT] [int] NULL,
	[TOTAL_COUNT] [int] NULL,
 CONSTRAINT [PK_PKG_MASTER_AGE] PRIMARY KEY CLUSTERED 
(
	[MASTER_CODE] ASC,
	[NEW_DATE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_MASTER_AGE]  WITH CHECK ADD  CONSTRAINT [R_PKG_MASTER_AGE] FOREIGN KEY([MASTER_CODE])
REFERENCES [dbo].[PKG_MASTER] ([MASTER_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PKG_MASTER_AGE] CHECK CONSTRAINT [R_PKG_MASTER_AGE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_AGE', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'통계일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_AGE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0~9' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_AGE', @level2type=N'COLUMN',@level2name=N'AGE0'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'10대' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_AGE', @level2type=N'COLUMN',@level2name=N'AGE10'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'20대' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_AGE', @level2type=N'COLUMN',@level2name=N'AGE20'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'30대' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_AGE', @level2type=N'COLUMN',@level2name=N'AGE30'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'40대' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_AGE', @level2type=N'COLUMN',@level2name=N'AGE40'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'50대' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_AGE', @level2type=N'COLUMN',@level2name=N'AGE50'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'60대' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_AGE', @level2type=N'COLUMN',@level2name=N'AGE60'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'70대' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_AGE', @level2type=N'COLUMN',@level2name=N'AGE70'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'80대' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_AGE', @level2type=N'COLUMN',@level2name=N'AGE80'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0~9퍼센트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_AGE', @level2type=N'COLUMN',@level2name=N'AGE0_PERCENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'10대퍼센트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_AGE', @level2type=N'COLUMN',@level2name=N'AGE10_PERCENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'20대퍼센트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_AGE', @level2type=N'COLUMN',@level2name=N'AGE20_PERCENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'30대퍼센트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_AGE', @level2type=N'COLUMN',@level2name=N'AGE30_PERCENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'40대퍼센트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_AGE', @level2type=N'COLUMN',@level2name=N'AGE40_PERCENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'50대퍼센트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_AGE', @level2type=N'COLUMN',@level2name=N'AGE50_PERCENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'60대퍼센트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_AGE', @level2type=N'COLUMN',@level2name=N'AGE60_PERCENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'70대퍼센트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_AGE', @level2type=N'COLUMN',@level2name=N'AGE70_PERCENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'80대퍼센트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_AGE', @level2type=N'COLUMN',@level2name=N'AGE80_PERCENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'총출발자수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_AGE', @level2type=N'COLUMN',@level2name=N'TOTAL_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터별예약연령통계' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_AGE'
GO
