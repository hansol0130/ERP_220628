USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ONDA_HTL_INFO_SUB_ADD](
	[HOTEL_CODE] [varchar](50) NOT NULL,
	[SUPP_CODE] [varchar](2) NOT NULL,
	[ADD_INFO1] [varchar](3000) NULL,
	[ADD_INFO2] [varchar](3000) NULL,
	[ADD_INFO3] [varchar](3000) NULL
) ON [PRIMARY]
GO
