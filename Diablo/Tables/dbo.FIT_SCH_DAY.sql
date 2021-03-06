USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FIT_SCH_DAY](
	[DAY_SEQ] [int] NOT NULL,
	[SCH_SEQ] [int] NOT NULL,
	[CUS_NO] [dbo].[CUS_NO] NOT NULL,
 CONSTRAINT [PK_FIT_SCH_DAY] PRIMARY KEY CLUSTERED 
(
	[CUS_NO] ASC,
	[SCH_SEQ] ASC,
	[DAY_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FIT_SCH_DAY]  WITH CHECK ADD FOREIGN KEY([CUS_NO], [SCH_SEQ])
REFERENCES [dbo].[FIT_SCH_MASTER] ([CUS_NO], [SCH_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
