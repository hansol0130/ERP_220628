USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COM_BBS_CATEGORY](
	[MASTER_SEQ] [int] NOT NULL,
	[CATEGORY_SEQ] [int] NOT NULL,
	[CATEGORY_NAME] [nvarchar](40) NOT NULL,
	[CATEGORY_CODE] [int] NULL,
	[CATEGORY_DESC] [varchar](100) NULL,
	[USE_YN] [char](1) NOT NULL,
	[NEW_DATE] [datetime] NOT NULL,
	[NEW_SEQ] [int] NOT NULL,
 CONSTRAINT [PK_COM_BBS_CATEGORY] PRIMARY KEY CLUSTERED 
(
	[MASTER_SEQ] ASC,
	[CATEGORY_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
