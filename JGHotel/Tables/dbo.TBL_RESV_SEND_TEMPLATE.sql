USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_RESV_SEND_TEMPLATE](
	[SEQ_NO] [int] NOT NULL,
	[RESV_TYPE] [varchar](2) NULL,
	[TITLE] [varchar](100) NULL,
	[MENT] [varchar](500) NULL,
	[ALTOK] [varchar](100) NULL,
	[USEYN] [varchar](1) NULL,
 CONSTRAINT [PK_TBL_RESV_SEND_TEMPLATE] PRIMARY KEY CLUSTERED 
(
	[SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO