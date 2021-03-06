USE [VGLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_SERVICE_XML](
	[SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[INFLOW_PATH] [varchar](50) NULL,
	[INFLOW_METHOD] [varchar](30) NULL,
	[REQUEST] [varchar](max) NULL,
	[RESPONSE] [varchar](max) NULL,
	[NEW_DATE] [datetime] NULL,
	[PROVIDER] [varchar](10) NULL,
 CONSTRAINT [PK_PUB_SERVICE_XML] PRIMARY KEY CLUSTERED 
(
	[SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
