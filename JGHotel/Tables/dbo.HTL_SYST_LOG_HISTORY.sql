USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_SYST_LOG_HISTORY](
	[LOG_ID] [numeric](18, 0) NOT NULL,
	[USER_ID] [varchar](50) NOT NULL,
	[CREATE_DATE] [datetime] NOT NULL,
	[LOG_SUCCESS] [varchar](50) NULL,
	[LOG_IP] [varchar](100) NULL,
	[LOG_AGENT] [varchar](500) NULL,
 CONSTRAINT [PK_HTL_SYST_LOG_HISTORY] PRIMARY KEY CLUSTERED 
(
	[LOG_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
