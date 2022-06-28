USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VIEW_MASTER](
	[VIEW_SEQ] [int] IDENTITY(1,1) NOT NULL,
	[MASTER_CODE] [varchar](10) NULL,
	[PRO_CODE] [varchar](20) NULL,
	[SESSION_ID] [varchar](100) NULL,
	[NEW_DATE] [datetime] NULL,
 CONSTRAINT [PK_VIEW_MASTER] PRIMARY KEY CLUSTERED 
(
	[VIEW_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
