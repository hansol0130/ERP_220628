USE [VGLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VGT_SHORTURL](
	[SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[URL] [varchar](900) NULL,
	[URL_KEY] [varchar](20) NULL,
	[NEW_DATE] [datetime] NULL,
 CONSTRAINT [PK_VGT_SHORTURL] PRIMARY KEY CLUSTERED 
(
	[SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VGT_SHORTURL] ADD  DEFAULT (getdate()) FOR [NEW_DATE]
GO