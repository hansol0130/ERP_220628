USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_MASTER_PARTNER_DATA](
	[PRO_CODE] [dbo].[PRO_CODE] NOT NULL,
	[MASTER_CODE] [dbo].[MASTER_CODE] NULL,
	[DEP_DATE] [date] NULL,
	[ALONE] [int] NULL,
	[FRIEND] [int] NULL,
	[FAMILY] [int] NULL,
	[COUPLE] [int] NULL,
	[MEETING] [int] NULL,
	[ETC] [int] NULL,
 CONSTRAINT [PK_PKG_MASTER_PARTNER_DATA] PRIMARY KEY CLUSTERED 
(
	[PRO_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER_DATA', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER_DATA', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER_DATA', @level2type=N'COLUMN',@level2name=N'DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'혼자출발여행' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER_DATA', @level2type=N'COLUMN',@level2name=N'ALONE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'친구와출발여행' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER_DATA', @level2type=N'COLUMN',@level2name=N'FRIEND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가족과출발여행' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER_DATA', @level2type=N'COLUMN',@level2name=N'FAMILY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'커플출발여행' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER_DATA', @level2type=N'COLUMN',@level2name=N'COUPLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'모임출발여행' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER_DATA', @level2type=N'COLUMN',@level2name=N'MEETING'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'나머지여행' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER_DATA', @level2type=N'COLUMN',@level2name=N'ETC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터별동반자분석데이터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER_DATA'
GO
