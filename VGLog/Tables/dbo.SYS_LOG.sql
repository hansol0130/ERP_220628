USE [VGLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYS_LOG](
	[SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[LOG_TYPE] [int] NULL,
	[CATEGORY] [varchar](500) NULL,
	[CLIENT_IP] [varchar](20) NULL,
	[SYSTEM] [varchar](500) NULL,
	[PATH] [varchar](1000) NULL,
	[TITLE] [varchar](max) NULL,
	[BODY] [varchar](max) NULL,
	[REQUEST] [varchar](max) NULL,
	[SESSION] [varchar](max) NULL,
	[TRACE] [varchar](max) NULL,
	[NEW_DATE] [datetime] NULL,
 CONSTRAINT [PK_SYS_LOG] PRIMARY KEY CLUSTERED 
(
	[SEQ_NO] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYS_LOG] ADD  DEFAULT (getdate()) FOR [NEW_DATE]
GO
