USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVSMTPCATEGORY](
	[CATEGORY_CD] [varchar](12) NOT NULL,
	[GRP_CD] [char](2) NULL,
	[PCATEGORY_CD] [varchar](12) NULL,
	[LEVEL_CD] [numeric](2, 0) NULL,
	[CATEGORY_NM] [char](50) NULL,
	[CATEGORY_DESC] [char](100) NULL,
	[ACTIVE_YN] [char](1) NULL,
 CONSTRAINT [PK_NVSMTPCATEGORY] PRIMARY KEY CLUSTERED 
(
	[CATEGORY_CD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
