USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_TOURSOFT](
	[SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[EV_YM] [char](6) NULL,
	[EV_SEQ] [int] NULL,
	[EV_NM] [nvarchar](100) NULL,
	[RES_DAY] [char](8) NULL,
	[RES_SEQ] [int] NULL,
	[PRO_CODE] [varchar](20) NULL,
	[NEW_DATE] [datetime] NULL,
 CONSTRAINT [PK_RES_TOURSOFT] PRIMARY KEY CLUSTERED 
(
	[SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RES_TOURSOFT] ADD  CONSTRAINT [DF_RES_TOURSOFT_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO