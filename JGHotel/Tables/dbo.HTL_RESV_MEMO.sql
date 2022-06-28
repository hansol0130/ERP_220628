USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_RESV_MEMO](
	[MSG_NO] [int] IDENTITY(1,1) NOT NULL,
	[RESV_NO] [int] NOT NULL,
	[MEMO] [varchar](5000) NULL,
	[CREATE_USER] [varchar](30) NULL,
	[CREATE_DATE] [datetime] NULL,
 CONSTRAINT [PK_HTL_RESV_MEMO] PRIMARY KEY CLUSTERED 
(
	[MSG_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO