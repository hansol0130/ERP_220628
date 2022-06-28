USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cti].[route_order](
	[owner_id] [varchar](20) NOT NULL,
	[next_id] [varchar](20) NOT NULL,
	[r_order] [int] NOT NULL,
	[next_type] [char](1) NOT NULL,
	[owner_type] [char](1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[owner_id] ASC,
	[next_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
