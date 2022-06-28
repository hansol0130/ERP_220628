USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_URGENT_MASTER](
	[SITE_CODE] [char](3) NOT NULL,
	[U_SEQ] [int] NOT NULL,
	[REGION_CODE] [varchar](30) NULL,
	[PRO_CODE] [varchar](20) NULL,
	[PRO_NAME] [varchar](200) NULL,
	[SEAT_CNT] [int] NULL,
	[SHOW_YN] [char](1) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
 CONSTRAINT [PK_PKG_URGENT_MASTER] PRIMARY KEY CLUSTERED 
(
	[SITE_CODE] ASC,
	[U_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
