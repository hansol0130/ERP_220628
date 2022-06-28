USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PROMOTION_MASTER](
	[PROMOTION_SEQ] [int] IDENTITY(1,1) NOT NULL,
	[SUP_CODE] [varchar](10) NULL,
	[REGION_CODE] [dbo].[REGION_CODE] NULL,
	[NATION_CODE] [dbo].[NATION_CODE] NULL,
	[STATE_CODE] [dbo].[STATE_CODE] NULL,
	[CITY_CODE] [dbo].[CITY_CODE] NULL,
	[MASTER_CODE] [dbo].[MASTER_CODE] NULL,
	[MASTER_NAME] [nvarchar](50) NULL,
	[DIS_START_DATE] [datetime] NULL,
	[DIS_END_DATE] [datetime] NULL,
	[DIS_GRADE] [int] NULL,
	[DIS_LEVEL] [int] NULL,
	[DIS_PRICE] [int] NULL,
	[DIS_PERCENT] [decimal](4, 2) NULL,
	[REMARK] [nvarchar](50) NULL,
	[SHOW_YN] [char](1) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
 CONSTRAINT [PK_PROMOTION_SEQ] PRIMARY KEY CLUSTERED 
(
	[PROMOTION_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
