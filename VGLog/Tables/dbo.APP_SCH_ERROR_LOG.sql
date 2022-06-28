USE [VGLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[APP_SCH_ERROR_LOG](
	[SCH_DATE] [int] NOT NULL,
	[SCH_SEQ] [int] NOT NULL,
	[ERROR_SEQ] [int] NOT NULL,
	[METHOD] [nchar](100) NULL,
	[ERROR_MESSAGE] [varchar](max) NULL,
	[NEW_DATE] [datetime] NOT NULL,
 CONSTRAINT [PK_APP_SCH_ERROR_LOG] PRIMARY KEY CLUSTERED 
(
	[SCH_DATE] ASC,
	[SCH_SEQ] ASC,
	[ERROR_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
