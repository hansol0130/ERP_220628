USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_ADDITION](
	[CUS_NO] [dbo].[CUS_NO] NOT NULL,
	[WEDDING_YN] [char](1) NULL,
	[WEDDING_DATE] [varchar](10) NULL,
	[MATE_BIRTHDAY] [varchar](10) NULL,
	[MATE_LUNAR_YN] [char](1) NULL,
	[HOPE_REGION] [varchar](20) NULL,
	[TRAVEL_TYPE] [varchar](20) NULL,
	[INFLOW_ROUTE] [varchar](100) NULL,
	[PASS_IMG_PATH] [varchar](200) NULL,
	[PASS_IMG_URL] [varchar](200) NULL,
 CONSTRAINT [PK_CUS_ADDITION] PRIMARY KEY CLUSTERED 
(
	[CUS_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CUS_ADDITION]  WITH CHECK ADD  CONSTRAINT [R_258] FOREIGN KEY([CUS_NO])
REFERENCES [dbo].[CUS_CUSTOMER_damo] ([CUS_NO])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CUS_ADDITION] CHECK CONSTRAINT [R_258]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결혼여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_ADDITION', @level2type=N'COLUMN',@level2name=N'WEDDING_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결혼기념일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_ADDITION', @level2type=N'COLUMN',@level2name=N'WEDDING_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'배우자생일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_ADDITION', @level2type=N'COLUMN',@level2name=N'MATE_BIRTHDAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'배우자생일음력여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_ADDITION', @level2type=N'COLUMN',@level2name=N'MATE_LUNAR_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가고싶은여행지' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_ADDITION', @level2type=N'COLUMN',@level2name=N'HOPE_REGION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행선호타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_ADDITION', @level2type=N'COLUMN',@level2name=N'TRAVEL_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'INFLOW_ROUTE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_ADDITION', @level2type=N'COLUMN',@level2name=N'INFLOW_ROUTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권이미지위치' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_ADDITION', @level2type=N'COLUMN',@level2name=N'PASS_IMG_PATH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권이미지URL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_ADDITION', @level2type=N'COLUMN',@level2name=N'PASS_IMG_URL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객부가정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_ADDITION'
GO
