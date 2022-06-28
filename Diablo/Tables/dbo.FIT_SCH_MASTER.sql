USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FIT_SCH_MASTER](
	[SCH_SEQ] [int] NOT NULL,
	[SCH_NAME] [nvarchar](50) NULL,
	[CUS_NO] [dbo].[CUS_NO] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[PRO_CODE] [dbo].[PRO_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[DEP_DATE] [datetime] NULL,
	[NIGHT] [int] NULL,
	[DAY] [int] NULL,
 CONSTRAINT [PK_FIT_SCH_MASTER] PRIMARY KEY CLUSTERED 
(
	[CUS_NO] ASC,
	[SCH_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
