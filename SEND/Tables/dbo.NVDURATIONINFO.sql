USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVDURATIONINFO](
	[DURATIONINFO_CD] [char](2) NOT NULL,
	[MAXTIME] [numeric](15, 0) NULL,
	[MINTIME] [numeric](15, 0) NULL,
	[VALID_CHK] [char](1) NULL,
 CONSTRAINT [PK_NVDURATIONINFO] PRIMARY KEY CLUSTERED 
(
	[DURATIONINFO_CD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
