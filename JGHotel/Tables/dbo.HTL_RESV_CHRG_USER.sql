USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_RESV_CHRG_USER](
	[USER_ID] [varchar](50) NOT NULL,
	[REG_DATE] [varchar](8) NOT NULL,
	[CNT] [int] NULL,
 CONSTRAINT [PK_HTL_RESV_CHRG_USER] PRIMARY KEY CLUSTERED 
(
	[USER_ID] ASC,
	[REG_DATE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO