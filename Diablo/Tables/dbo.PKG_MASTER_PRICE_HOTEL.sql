USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_MASTER_PRICE_HOTEL](
	[MASTER_CODE] [dbo].[MASTER_CODE] NOT NULL,
	[PRICE_SEQ] [int] NOT NULL,
	[DAY_NUMBER] [int] NOT NULL,
	[HTL_MASTER_CODE] [varchar](10) NULL,
	[SUP_CODE] [varchar](10) NULL,
	[STAY_TYPE] [int] NULL,
	[STAY_INFO] [nvarchar](500) NULL,
	[DINNER_1] [varchar](100) NULL,
	[DINNER_2] [varchar](100) NULL,
	[DINNER_3] [varchar](100) NULL,
	[DINNER_CODE_1] [varchar](20) NULL,
	[DINNER_CODE_2] [varchar](20) NULL,
	[DINNER_CODE_3] [varchar](20) NULL,
 CONSTRAINT [PK_PKG_MASTER_PRICE_HOTEL] PRIMARY KEY CLUSTERED 
(
	[MASTER_CODE] ASC,
	[PRICE_SEQ] ASC,
	[DAY_NUMBER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_MASTER_PRICE_HOTEL]  WITH CHECK ADD  CONSTRAINT [R_295] FOREIGN KEY([MASTER_CODE], [PRICE_SEQ])
REFERENCES [dbo].[PKG_MASTER_PRICE] ([MASTER_CODE], [PRICE_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PKG_MASTER_PRICE_HOTEL] CHECK CONSTRAINT [R_295]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE_HOTEL', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가격순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE_HOTEL', @level2type=N'COLUMN',@level2name=N'PRICE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE_HOTEL', @level2type=N'COLUMN',@level2name=N'DAY_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE_HOTEL', @level2type=N'COLUMN',@level2name=N'HTL_MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공급자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE_HOTEL', @level2type=N'COLUMN',@level2name=N'SUP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'숙박타입 ( 0 :호텔, 1 : 미정, 2  :기내박, 3 : 선박 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE_HOTEL', @level2type=N'COLUMN',@level2name=N'STAY_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'숙박비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE_HOTEL', @level2type=N'COLUMN',@level2name=N'STAY_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'식사정보1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE_HOTEL', @level2type=N'COLUMN',@level2name=N'DINNER_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'식사정보2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE_HOTEL', @level2type=N'COLUMN',@level2name=N'DINNER_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'식사정보3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE_HOTEL', @level2type=N'COLUMN',@level2name=N'DINNER_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'식사정보코드1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE_HOTEL', @level2type=N'COLUMN',@level2name=N'DINNER_CODE_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'식사정보코드2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE_HOTEL', @level2type=N'COLUMN',@level2name=N'DINNER_CODE_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'식사정보코드3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE_HOTEL', @level2type=N'COLUMN',@level2name=N'DINNER_CODE_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터가격별호텔' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE_HOTEL'
GO
