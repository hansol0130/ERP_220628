USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_CODE_MAST_CITY_IMAGE](
	[CITY_CODE] [bigint] NOT NULL,
	[CITY_NAME] [nvarchar](800) NULL,
	[IMG] [varchar](500) NULL,
 CONSTRAINT [PK_HTL_CODE_MAST_CITY_IMAGE] PRIMARY KEY CLUSTERED 
(
	[CITY_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
